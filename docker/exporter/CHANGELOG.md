# Changelog - Swarm Exporter

Tutte le modifiche importanti a questo progetto saranno documentate qui.

## [1.0.0] - 2026-01-01

### Creato
- 🎉 **Prima release!**
- Script `swarm_exporter.py` (316 righe)
  - Server HTTP Prometheus su porta 9091
  - 8 metriche esposte (Counter, Gauge, Histogram)
  - Pattern incrementale per efficienza
  - Background updater (ogni 30s)
  - Health check endpoint
- Dockerfile multi-stage
  - Utente non-root
  - Health check automatico
  - Immagine slim (Python 3.11)
- `docker-compose.example.yml`
- `test_exporter.py` - Test automatici
- README.md completo
- requirements.txt (prometheus_client)

### Metriche
- `swarm_tasks_total` - Counter totale task
- `swarm_tasks_success_total` - Counter task successo
- `swarm_tasks_failed_total` - Counter task falliti
- `swarm_agent_tasks_total{agent}` - Counter per agent
- `swarm_task_duration_seconds{agent}` - Histogram durata
- `swarm_lessons_total{severity}` - Gauge lezioni
- `swarm_last_activity_timestamp` - Gauge ultimo task
- `swarm_db_size_bytes` - Gauge dimensione DB

### Test
- ✅ Test locale passato
- ✅ Health check OK
- ✅ Metriche Prometheus OK
- ✅ Database di test validato
- ✅ Pattern incrementale verificato

### Performance
- RAM: ~15-30MB
- CPU: <5%
- Update time: <200ms per 10K eventi

---

*Cervella Backend - 1 Gennaio 2026* 🐝⚙️
