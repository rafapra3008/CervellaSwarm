#!/usr/bin/env python3
"""
Test script per Swarm Exporter

Crea un database SQLite finto con dati di test,
poi verifica che l'exporter li legga correttamente.
"""

import sqlite3
import sys
import time
from pathlib import Path
from datetime import datetime, timezone, timedelta


def create_test_db(db_path: Path):
    """Crea database di test con dati finti."""

    # Rimuovi DB esistente
    if db_path.exists():
        db_path.unlink()

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # ===== TABELLA EVENTI =====
    cursor.execute("""
        CREATE TABLE swarm_events (
            id TEXT PRIMARY KEY,
            timestamp TEXT NOT NULL,
            session_id TEXT,
            event_type TEXT NOT NULL,
            agent_name TEXT,
            agent_role TEXT,
            task_id TEXT,
            parent_task_id TEXT,
            task_description TEXT,
            task_status TEXT,
            duration_ms INTEGER,
            success INTEGER,
            error_message TEXT,
            project TEXT,
            files_modified TEXT,
            tags TEXT,
            notes TEXT,
            created_at TEXT DEFAULT (datetime('now'))
        )
    """)

    # ===== TABELLA LEZIONI =====
    cursor.execute("""
        CREATE TABLE lessons_learned (
            id TEXT PRIMARY KEY,
            timestamp TEXT NOT NULL,
            context TEXT,
            problem TEXT,
            solution TEXT,
            pattern TEXT,
            agents_involved TEXT,
            confidence REAL DEFAULT 0.5,
            times_applied INTEGER DEFAULT 0,
            severity TEXT DEFAULT 'MEDIUM',
            created_at TEXT DEFAULT (datetime('now'))
        )
    """)

    # ===== DATI DI TEST =====

    # Eventi di successo
    now = datetime.now(timezone.utc)

    events = [
        # cervella-frontend (successo)
        (
            "evt-001",
            (now - timedelta(hours=2)).isoformat(),
            "session-1",
            "task_completed",
            "cervella-frontend",
            "frontend",
            "task-1",
            None,
            "Fix CSS bug",
            "completed",
            5500,  # 5.5 secondi
            1,
            None,
            "Miracollo",
            "src/App.css",
            "bug,css",
            "Fix completato",
            (now - timedelta(hours=2)).isoformat()
        ),
        # cervella-backend (successo)
        (
            "evt-002",
            (now - timedelta(hours=1, minutes=30)).isoformat(),
            "session-1",
            "task_completed",
            "cervella-backend",
            "backend",
            "task-2",
            None,
            "API endpoint create",
            "completed",
            12000,  # 12 secondi
            1,
            None,
            "Miracollo",
            "api/endpoints.py",
            "api,backend",
            "Endpoint creato",
            (now - timedelta(hours=1, minutes=30)).isoformat()
        ),
        # cervella-tester (failed)
        (
            "evt-003",
            (now - timedelta(hours=1)).isoformat(),
            "session-1",
            "task_failed",
            "cervella-tester",
            "tester",
            "task-3",
            None,
            "Run tests",
            "failed",
            8000,  # 8 secondi
            0,
            "Test suite failed: 2/10 tests failed",
            "Miracollo",
            "tests/test_api.py",
            "test,failed",
            "Test falliti",
            (now - timedelta(hours=1)).isoformat()
        ),
        # cervella-frontend (successo recente)
        (
            "evt-004",
            (now - timedelta(minutes=5)).isoformat(),
            "session-2",
            "task_completed",
            "cervella-frontend",
            "frontend",
            "task-4",
            None,
            "Update component",
            "completed",
            3200,  # 3.2 secondi
            1,
            None,
            "Contabilita",
            "src/components/Modal.jsx",
            "component,react",
            "Modal aggiornato",
            (now - timedelta(minutes=5)).isoformat()
        ),
    ]

    cursor.executemany("""
        INSERT INTO swarm_events VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    """, events)

    # Lezioni
    lessons = [
        (
            "lesson-001",
            (now - timedelta(days=1)).isoformat(),
            "Deploy production",
            "Deploy senza test locale",
            "SEMPRE test locale prima di deploy",
            "deploy-pattern",
            "cervella-devops",
            0.95,
            3,
            "CRITICAL",
            (now - timedelta(days=1)).isoformat()
        ),
        (
            "lesson-002",
            (now - timedelta(days=2)).isoformat(),
            "Code review",
            "File troppo grande (>500 righe)",
            "Spezzare file in moduli",
            "code-quality",
            "cervella-reviewer",
            0.80,
            5,
            "MEDIUM",
            (now - timedelta(days=2)).isoformat()
        ),
        (
            "lesson-003",
            (now - timedelta(hours=3)).isoformat(),
            "Testing",
            "Test mancanti per edge case",
            "Aggiungere test per edge case",
            "testing-pattern",
            "cervella-tester",
            0.70,
            1,
            "HIGH",
            (now - timedelta(hours=3)).isoformat()
        ),
    ]

    cursor.executemany("""
        INSERT INTO lessons_learned VALUES (?,?,?,?,?,?,?,?,?,?,?)
    """, lessons)

    conn.commit()
    conn.close()

    print(f"✅ Database di test creato: {db_path}")
    print(f"   - {len(events)} eventi")
    print(f"   - {len(lessons)} lezioni")


def verify_exporter_metrics():
    """Verifica che l'exporter esponga metriche corrette."""
    import urllib.request

    time.sleep(2)  # Aspetta che exporter legga DB

    try:
        response = urllib.request.urlopen("http://localhost:9091/metrics")
        content = response.read().decode("utf-8")

        # Verifica presenza metriche chiave
        checks = {
            "tasks_total": "swarm_tasks_total" in content,
            "tasks_success": "swarm_tasks_success_total" in content,
            "tasks_failed": "swarm_tasks_failed_total" in content,
            "agent_tasks": "swarm_agent_tasks_total" in content,
            "task_duration": "swarm_task_duration_seconds" in content,
            "lessons": "swarm_lessons_total" in content,
            "last_activity": "swarm_last_activity_timestamp" in content,
            "db_size": "swarm_db_size_bytes" in content,
        }

        print("\n📊 Verifica metriche:")
        all_ok = True
        for name, ok in checks.items():
            status = "✅" if ok else "❌"
            print(f"   {status} {name}")
            if not ok:
                all_ok = False

        # Verifica valori
        print("\n📈 Valori metriche:")

        # Totale task (dovrebbe essere 4)
        if "swarm_tasks_total 4.0" in content:
            print("   ✅ swarm_tasks_total = 4.0")
        else:
            print("   ❌ swarm_tasks_total != 4.0")
            all_ok = False

        # Task success (dovrebbe essere 3)
        if "swarm_tasks_success_total 3.0" in content:
            print("   ✅ swarm_tasks_success_total = 3.0")
        else:
            print("   ❌ swarm_tasks_success_total != 3.0")
            all_ok = False

        # Task failed (dovrebbe essere 1)
        if "swarm_tasks_failed_total 1.0" in content:
            print("   ✅ swarm_tasks_failed_total = 1.0")
        else:
            print("   ❌ swarm_tasks_failed_total != 1.0")
            all_ok = False

        # Lessons per severity
        severity_ok = (
            'swarm_lessons_total{severity="CRITICAL"} 1.0' in content and
            'swarm_lessons_total{severity="HIGH"} 1.0' in content and
            'swarm_lessons_total{severity="MEDIUM"} 1.0' in content
        )

        if severity_ok:
            print("   ✅ swarm_lessons_total per severity OK")
        else:
            print("   ❌ swarm_lessons_total per severity ERRORE")
            all_ok = False

        return all_ok

    except Exception as e:
        print(f"❌ Errore verifica: {e}")
        return False


def main():
    """Test completo."""
    print("🧪 Test Swarm Exporter")
    print("-" * 60)

    # Path database di test
    test_db = Path("/tmp/swarm_test.db")

    print("\n1️⃣  Creazione database di test...")
    create_test_db(test_db)

    print("\n2️⃣  Avvia l'exporter con:")
    print(f"   export SWARM_DB_PATH={test_db}")
    print(f"   python3 swarm_exporter.py")

    print("\n3️⃣  Poi esegui questo script di nuovo con --verify:")
    print(f"   python3 test_exporter.py --verify")

    if "--verify" in sys.argv:
        print("\n4️⃣  Verifica metriche...")
        if verify_exporter_metrics():
            print("\n✅ TEST PASSATO!")
            sys.exit(0)
        else:
            print("\n❌ TEST FALLITO!")
            sys.exit(1)


if __name__ == "__main__":
    main()
