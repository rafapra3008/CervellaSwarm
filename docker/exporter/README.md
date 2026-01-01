# Swarm Exporter - Prometheus Exporter per CervellaSwarm

**Versione:** 1.0.0
**Data:** 1 Gennaio 2026

## Descrizione

Espone metriche dello sciame CervellaSwarm in formato Prometheus.

Legge dal database SQLite (`swarm_memory.db`) e aggiorna le metriche ogni 30 secondi.

## Metriche Esposte

| Metrica | Tipo | Descrizione |
|---------|------|-------------|
| `swarm_tasks_total` | Counter | Totale task eseguiti |
| `swarm_tasks_success_total` | Counter | Task completati con successo |
| `swarm_tasks_failed_total` | Counter | Task falliti |
| `swarm_agent_tasks_total{agent}` | Counter | Task per agent (label: agent) |
| `swarm_task_duration_seconds{agent}` | Histogram | Durata task in secondi (label: agent) |
| `swarm_lessons_total{severity}` | Gauge | Lezioni apprese (label: severity) |
| `swarm_last_activity_timestamp` | Gauge | Timestamp ultimo task (Unix epoch) |
| `swarm_db_size_bytes` | Gauge | Dimensione database |

## Quick Start

### Locale (Python)

```bash
# Installa dipendenze
pip install -r requirements.txt

# Avvia exporter
python3 swarm_exporter.py

# Test
curl http://localhost:9091/metrics
curl http://localhost:9091/health
```

### Docker

```bash
# Build
docker build -t cervellaswarm/exporter:1.0.0 .

# Run
docker run -d \
  --name swarm-exporter \
  -p 9091:9091 \
  -v ~/.cervellaswarm:/data:ro \
  -e SWARM_DB_PATH=/data/swarm_memory.db \
  cervellaswarm/exporter:1.0.0

# Logs
docker logs -f swarm-exporter
```

## Configurazione

Variabili d'ambiente:

| Variabile | Default | Descrizione |
|-----------|---------|-------------|
| `SWARM_DB_PATH` | `~/.cervellaswarm/swarm_memory.db` | Path database SQLite |
| `EXPORTER_PORT` | `9091` | Porta HTTP |
| `UPDATE_INTERVAL` | `30` | Intervallo aggiornamento (secondi) |

## Integrazione Prometheus

Aggiungi al `prometheus.yml`:

```yaml
scrape_configs:
  - job_name: 'cervellaswarm'
    static_configs:
      - targets: ['localhost:9091']
    scrape_interval: 30s
```

## Architettura

```
┌─────────────────┐
│  SQLite DB      │
│  swarm_memory   │
└────────┬────────┘
         │ (read every 30s)
         ▼
┌─────────────────┐
│  Swarm Exporter │
│  Python + HTTP  │
└────────┬────────┘
         │ :9091/metrics
         ▼
┌─────────────────┐
│  Prometheus     │
│  (scrape)       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Grafana        │
│  (visualizza)   │
└─────────────────┘
```

## Pattern Incrementale

L'exporter usa un pattern **incrementale** per efficienza:

- **Prima lettura**: Carica tutto il database
- **Aggiornamenti successivi**: Solo nuovi eventi (`WHERE id > last_id`)

Questo riduce il carico su database grandi.

## Health Check

Endpoint `/health` per monitoring:

```bash
curl http://localhost:9091/health
# {"status":"ok","version":"1.0.0"}
```

Docker healthcheck automatico ogni 30s.

## Troubleshooting

### Database non trovato

```
⚠️  Database non trovato: /path/to/swarm_memory.db
   Attendo creazione...
```

**Soluzione:** Verifica che `SWARM_DB_PATH` sia corretto.

### Metriche a zero

Se le metriche sono tutte zero, verifica:

```bash
# Connessione DB OK?
sqlite3 ~/.cervellaswarm/swarm_memory.db "SELECT COUNT(*) FROM swarm_events;"

# Exporter riceve eventi?
docker logs swarm-exporter | grep "Lettura iniziale"
```

### Prometheus non scrape

Verifica connectivity:

```bash
# Da Prometheus container
wget -O- http://swarm-exporter:9091/metrics

# Controlla Prometheus UI → Targets
# Status deve essere UP
```

## Performance

| Dimensione DB | RAM Usata | CPU (avg) | Update Time |
|---------------|-----------|-----------|-------------|
| 10MB (1K eventi) | ~15MB | <1% | <50ms |
| 100MB (10K eventi) | ~20MB | <2% | <200ms |
| 1GB (100K eventi) | ~30MB | <5% | <1s |

Pattern incrementale garantisce performance costanti.

## License

Parte di CervellaSwarm - Internal Tool

---

*"Lo sciame che MISURA e MIGLIORA!"* 🐝📊

Cervella & Rafa - 1 Gennaio 2026
