#!/usr/bin/env python3
"""
Swarm Exporter - Prometheus exporter per CervellaSwarm

Espone metriche dello sciame in formato Prometheus.
Legge da SQLite e aggiorna metriche ogni 30 secondi.

Metriche esposte:
- swarm_tasks_total: Totale task
- swarm_tasks_success_total: Task completati con successo
- swarm_tasks_failed_total: Task falliti
- swarm_agent_tasks_total{agent}: Task per agent
- swarm_task_duration_seconds{agent}: Durata task (histogram)
- swarm_lessons_total{severity}: Lezioni apprese per severity
- swarm_last_activity_timestamp: Timestamp ultimo task
- swarm_db_size_bytes: Dimensione database

"""

__version__ = "1.0.0"
__version_date__ = "2026-01-01"

import os
import sqlite3
import sys
import time
from pathlib import Path
from threading import Thread
from typing import Optional

from prometheus_client import (
    Counter, Gauge, Histogram,
    generate_latest, REGISTRY, CONTENT_TYPE_LATEST
)
from http.server import HTTPServer, BaseHTTPRequestHandler


# ===== CONFIGURATION =====

DB_PATH = os.environ.get(
    "SWARM_DB_PATH",
    str(Path.home() / ".cervellaswarm" / "swarm_memory.db")
)

EXPORTER_PORT = int(os.environ.get("EXPORTER_PORT", "9091"))
UPDATE_INTERVAL_SECONDS = int(os.environ.get("UPDATE_INTERVAL", "30"))


# ===== METRICS DEFINITION =====

# Counters (mai decrementano)
tasks_total = Counter(
    "swarm_tasks_total",
    "Totale task eseguiti dallo sciame"
)

tasks_success = Counter(
    "swarm_tasks_success_total",
    "Task completati con successo"
)

tasks_failed = Counter(
    "swarm_tasks_failed_total",
    "Task falliti"
)

agent_tasks = Counter(
    "swarm_agent_tasks_total",
    "Task per agent",
    ["agent"]
)

# Histograms (distribuzioni)
task_duration = Histogram(
    "swarm_task_duration_seconds",
    "Durata task in secondi",
    ["agent"],
    buckets=[0.1, 0.5, 1.0, 2.5, 5.0, 10.0, 30.0, 60.0, 120.0, 300.0]
)

# Gauges (valori istantanei)
lessons_by_severity = Gauge(
    "swarm_lessons_total",
    "Lezioni apprese per severity",
    ["severity"]
)

last_activity = Gauge(
    "swarm_last_activity_timestamp",
    "Timestamp ultimo task (Unix epoch)"
)

db_size = Gauge(
    "swarm_db_size_bytes",
    "Dimensione database in bytes"
)


# ===== DATABASE READER =====

class SwarmMetricsCollector:
    """Colleziona metriche dal database SQLite."""

    def __init__(self, db_path: str):
        self.db_path = Path(db_path)
        self.last_event_id: Optional[str] = None

        # Verifica che DB esista
        if not self.db_path.exists():
            print(f"⚠️  Database non trovato: {self.db_path}", file=sys.stderr)
            print(f"   Attendo creazione...", file=sys.stderr)

    def connect(self) -> Optional[sqlite3.Connection]:
        """Connessione sicura al database."""
        try:
            if not self.db_path.exists():
                return None

            conn = sqlite3.connect(self.db_path)
            conn.row_factory = sqlite3.Row
            return conn

        except Exception as e:
            print(f"❌ Errore connessione DB: {e}", file=sys.stderr)
            return None

    def update_metrics(self):
        """Aggiorna le metriche Prometheus dal database."""
        conn = self.connect()
        if not conn:
            return

        try:
            cursor = conn.cursor()

            # ===== NUOVI EVENTI (incrementali) =====
            # Evitiamo di ri-contare tutti gli eventi ogni volta
            query = """
                SELECT
                    id, agent_name, task_status, duration_ms, timestamp
                FROM swarm_events
                WHERE id > ?
                ORDER BY id ASC
            """

            cursor.execute(query, (self.last_event_id or "",))
            new_events = cursor.fetchall()

            for event in new_events:
                # Incrementa counter totali
                tasks_total.inc()

                # Incrementa per agent
                agent = event["agent_name"] or "unknown"
                agent_tasks.labels(agent=agent).inc()

                # Incrementa success/failed
                status = event["task_status"] or ""
                if "completed" in status.lower() or "success" in status.lower():
                    tasks_success.inc()
                elif "failed" in status.lower() or "error" in status.lower():
                    tasks_failed.inc()

                # Durata task (histogram)
                if event["duration_ms"]:
                    duration_sec = event["duration_ms"] / 1000.0
                    task_duration.labels(agent=agent).observe(duration_sec)

                # Aggiorna last_event_id
                self.last_event_id = event["id"]

            # ===== LEZIONI PER SEVERITY (snapshot) =====
            cursor.execute("""
                SELECT severity, COUNT(*) as count
                FROM lessons_learned
                WHERE severity IS NOT NULL
                GROUP BY severity
            """)

            for row in cursor.fetchall():
                severity = row["severity"] or "UNKNOWN"
                count = row["count"]
                lessons_by_severity.labels(severity=severity).set(count)

            # ===== ULTIMO TASK (timestamp) =====
            cursor.execute("""
                SELECT timestamp
                FROM swarm_events
                ORDER BY timestamp DESC
                LIMIT 1
            """)

            row = cursor.fetchone()
            if row and row["timestamp"]:
                # Converti ISO timestamp a Unix epoch
                from datetime import datetime
                try:
                    dt = datetime.fromisoformat(row["timestamp"].replace("Z", "+00:00"))
                    epoch = dt.timestamp()
                    last_activity.set(epoch)
                except Exception as e:
                    print(f"⚠️  Errore parsing timestamp: {e}", file=sys.stderr)

            # ===== DIMENSIONE DATABASE =====
            db_size.set(self.db_path.stat().st_size)

            conn.close()

        except Exception as e:
            print(f"❌ Errore update metriche: {e}", file=sys.stderr)
            if conn:
                conn.close()


# ===== HTTP SERVER =====

class MetricsHandler(BaseHTTPRequestHandler):
    """HTTP handler per endpoint /metrics."""

    def do_GET(self):
        """Risponde alle richieste GET."""
        if self.path == "/metrics":
            # Genera output Prometheus
            self.send_response(200)
            self.send_header("Content-Type", CONTENT_TYPE_LATEST)
            self.end_headers()

            output = generate_latest(REGISTRY)
            self.wfile.write(output)

        elif self.path == "/health":
            # Health check
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()

            health = b'{"status":"ok","version":"' + __version__.encode() + b'"}\n'
            self.wfile.write(health)

        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b"404 Not Found\n")

    def log_message(self, format, *args):
        """Silenzia i log HTTP (troppo verbose)."""
        pass


# ===== BACKGROUND UPDATER =====

def background_updater(collector: SwarmMetricsCollector, interval: int):
    """Thread che aggiorna le metriche ogni N secondi."""
    print(f"🔄 Background updater avviato (intervallo: {interval}s)", file=sys.stderr)

    while True:
        try:
            collector.update_metrics()
            time.sleep(interval)

        except KeyboardInterrupt:
            print("\n⏸️  Background updater fermato", file=sys.stderr)
            break

        except Exception as e:
            print(f"❌ Errore background updater: {e}", file=sys.stderr)
            time.sleep(interval)


# ===== MAIN =====

def main():
    """Entry point."""
    print("🐝 CervellaSwarm - Prometheus Exporter", file=sys.stderr)
    print(f"📅 Versione {__version__} ({__version_date__})", file=sys.stderr)
    print("-" * 60, file=sys.stderr)
    print(f"📂 Database: {DB_PATH}", file=sys.stderr)
    print(f"🌐 HTTP Port: {EXPORTER_PORT}", file=sys.stderr)
    print(f"🔄 Update Interval: {UPDATE_INTERVAL_SECONDS}s", file=sys.stderr)
    print("-" * 60, file=sys.stderr)

    # Collector
    collector = SwarmMetricsCollector(DB_PATH)

    # Prima lettura (sincrona)
    print("📊 Lettura iniziale metriche...", file=sys.stderr)
    collector.update_metrics()
    print("✅ Metriche inizializzate", file=sys.stderr)

    # Thread background updater
    updater_thread = Thread(
        target=background_updater,
        args=(collector, UPDATE_INTERVAL_SECONDS),
        daemon=True
    )
    updater_thread.start()

    # HTTP server
    server = HTTPServer(("0.0.0.0", EXPORTER_PORT), MetricsHandler)

    print(f"\n🚀 Exporter avviato su http://0.0.0.0:{EXPORTER_PORT}", file=sys.stderr)
    print(f"📈 Metriche disponibili su http://0.0.0.0:{EXPORTER_PORT}/metrics", file=sys.stderr)
    print(f"💚 Health check su http://0.0.0.0:{EXPORTER_PORT}/health", file=sys.stderr)
    print("\nPremere Ctrl+C per fermare...\n", file=sys.stderr)

    try:
        server.serve_forever()

    except KeyboardInterrupt:
        print("\n\n⏸️  Exporter fermato", file=sys.stderr)
        server.shutdown()
        sys.exit(0)


if __name__ == "__main__":
    main()
