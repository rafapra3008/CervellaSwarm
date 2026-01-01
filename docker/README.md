# CervellaSwarm Monitoring Stack 🐝📊

Stack completo per monitoring H24 dello sciame CervellaSwarm.

## Architettura

```
┌──────────────────────────────────────────────────────────────┐
│                      VM MIRACOLLO                            │
│                                                              │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐            │
│  │  Grafana   │  │ Prometheus │  │AlertManager│            │
│  │  :3000     │◄─┤  :9090     │◄─┤  :9093     │            │
│  └────────────┘  └────────────┘  └────────────┘            │
│         │              ▲                │                    │
│         │              │                │                    │
│         │        ┌─────┴─────┐         │                    │
│         │        │  Swarm    │         │                    │
│         │        │ Exporter  │         ▼                    │
│         │        │  :9091    │   ┌──────────┐              │
│         │        └─────┬─────┘   │ Telegram │              │
│         │              │         └──────────┘              │
│         │              │                                     │
│         │              ▼                                     │
│         │     ┌─────────────────┐                          │
│         └────►│ swarm_memory.db │                          │
│               └─────────────────┘                          │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

## Componenti

| Servizio | Porta | Descrizione |
|----------|-------|-------------|
| **Grafana** | 3000 | Dashboard e visualizzazione |
| **Prometheus** | 9090 | Time-series database |
| **AlertManager** | 9093 | Sistema alert (Telegram) |
| **Swarm Exporter** | 9091 | Metriche custom da SQLite |

## Setup Rapido

### 1. Configurazione Telegram Bot

Prima di tutto, crea un bot Telegram per ricevere alert:

```bash
# 1. Apri Telegram, cerca @BotFather
# 2. Invia: /newbot
# 3. Scegli nome: CervellaSwarmBot
# 4. Copia il TOKEN ricevuto

# 5. Crea un gruppo/canale privato
# 6. Aggiungi il bot al gruppo
# 7. Invia messaggio: /start

# 8. Ottieni chat_id:
curl https://api.telegram.org/bot<YOUR_TOKEN>/getUpdates

# Cerca: "chat":{"id":-1001234567890,...}
# Copia l'ID (numero negativo per gruppi)
```

### 2. Configurazione Ambiente

```bash
cd docker/

# Copia file esempio
cp .env.example .env

# Modifica con i tuoi valori
nano .env
```

**File `.env` da configurare:**
```bash
GRAFANA_PASSWORD=your_strong_password_here
TELEGRAM_BOT_TOKEN=123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11
TELEGRAM_CHAT_ID=-1001234567890
SWARM_DB_PATH=../data/swarm_memory.db
```

### 3. Deploy Locale (Test)

Per testare in locale prima del deploy su VM:

```bash
# Build e start
docker-compose -f docker-compose.monitoring.yml up -d

# Verifica status
docker-compose -f docker-compose.monitoring.yml ps

# Logs
docker-compose -f docker-compose.monitoring.yml logs -f

# Accesso servizi:
# - Grafana: http://localhost:3000 (admin / <GRAFANA_PASSWORD>)
# - Prometheus: http://localhost:9090
# - AlertManager: http://localhost:9093
# - Swarm Exporter: http://localhost:9091/metrics

# Stop
docker-compose -f docker-compose.monitoring.yml down
```

### 4. Deploy su VM Miracollo

#### A. Preparazione VM

```bash
# SSH sulla VM
ssh root@<VM_IP>

# Verifica Docker installato
docker --version
docker-compose --version

# Se manca, installa:
curl -fsSL https://get.docker.com | sh
```

#### B. Upload Files

```bash
# Dalla tua macchina locale:
cd /Users/rafapra/Developer/CervellaSwarm

# Crea directory remota
ssh root@<VM_IP> "mkdir -p /opt/cervellaswarm/monitoring"

# Upload files
scp -r docker/* root@<VM_IP>:/opt/cervellaswarm/monitoring/
scp data/swarm_memory.db root@<VM_IP>:/opt/cervellaswarm/data/
```

#### C. Deploy

```bash
# SSH sulla VM
ssh root@<VM_IP>

cd /opt/cervellaswarm/monitoring

# Configura .env
cp .env.example .env
nano .env

# Build e start
docker-compose -f docker-compose.monitoring.yml up -d

# Verifica tutto running
docker-compose -f docker-compose.monitoring.yml ps

# Logs
docker-compose -f docker-compose.monitoring.yml logs -f swarm-exporter
```

#### D. Test

```bash
# Test metrics endpoint
curl http://localhost:9091/metrics

# Test Prometheus
curl http://localhost:9090/-/healthy

# Test Grafana
curl http://localhost:3000/api/health
```

## Accesso Dashboard

Dopo il deploy, accedi a:

- **Grafana**: `http://<VM_IP>:3000`
  - Username: `admin`
  - Password: valore di `GRAFANA_PASSWORD` nel `.env`
  - Dashboard: "CervellaSwarm - Overview"

- **Prometheus**: `http://<VM_IP>:9090`
  - Query console disponibile

- **AlertManager**: `http://<VM_IP>:9093`
  - Gestione alert

## Metriche Disponibili

### Task Metrics
```promql
# Totale task
swarm_tasks_total

# Task successo
swarm_tasks_success_total

# Task falliti
swarm_tasks_failed_total

# Task per agente
swarm_agent_tasks_total{agent="cervella-frontend"}

# Success rate
100 * sum(swarm_tasks_success_total) / sum(swarm_tasks_total)
```

### Agent Metrics
```promql
# Agenti attivi (24h)
swarm_agents_active

# Durata task
swarm_task_duration_seconds
```

### Lessons & Patterns
```promql
# Lezioni apprese
swarm_lessons_total{severity="CRITICAL"}

# Timestamp ultimo task
swarm_last_activity_timestamp
```

## Alert Configurati

Gli alert vengono inviati su Telegram quando:

- **HighErrorRate**: Tasso errori > 10% (5min)
- **NoActivity**: Nessun task nelle ultime 4h
- **DatabaseUnavailable**: Database non accessibile

## Manutenzione

### Restart Servizi

```bash
cd /opt/cervellaswarm/monitoring

# Restart singolo servizio
docker-compose -f docker-compose.monitoring.yml restart grafana

# Restart tutto
docker-compose -f docker-compose.monitoring.yml restart

# Rebuild dopo modifiche
docker-compose -f docker-compose.monitoring.yml up -d --build
```

### Logs

```bash
# Logs tutti i servizi
docker-compose -f docker-compose.monitoring.yml logs -f

# Logs singolo servizio
docker-compose -f docker-compose.monitoring.yml logs -f swarm-exporter
docker-compose -f docker-compose.monitoring.yml logs -f prometheus
```

### Backup

```bash
# Backup volumi Grafana (dashboards, utenti, etc)
docker run --rm \
  -v cervellaswarm-grafana-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/grafana-backup-$(date +%Y%m%d).tar.gz /data

# Backup Prometheus (metriche ultime 15 giorni)
docker run --rm \
  -v cervellaswarm-prometheus-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/prometheus-backup-$(date +%Y%m%d).tar.gz /data
```

### Update

```bash
# Pull nuove immagini
docker-compose -f docker-compose.monitoring.yml pull

# Rebuild e restart
docker-compose -f docker-compose.monitoring.yml up -d --build
```

## Troubleshooting

### Swarm Exporter non parte

```bash
# Check logs
docker logs cervellaswarm-exporter

# Verifica database path
docker exec cervellaswarm-exporter ls -la /data/

# Test manuale
docker exec -it cervellaswarm-exporter python3 swarm_exporter.py
```

### Prometheus non vede metriche

```bash
# Verifica targets
curl http://localhost:9090/api/v1/targets

# Deve mostrare swarm-exporter UNHEALTHY
# Se UNHEALTHY, check network:
docker network inspect cervellaswarm-monitoring
```

### Alert non arrivano su Telegram

```bash
# Test configurazione AlertManager
docker logs cervellaswarm-alertmanager

# Test manuale invio
curl -X POST http://localhost:9093/api/v1/alerts \
  -H 'Content-Type: application/json' \
  -d '[{"labels":{"alertname":"test","severity":"info"}}]'
```

### Grafana non mostra dati

1. Verifica datasource Prometheus:
   - Settings → Data Sources → Prometheus
   - URL deve essere: `http://prometheus:9090`
   - Click "Save & Test"

2. Verifica metriche disponibili:
   - Explore → Metrics browser → Cerca "swarm_"

## Risorse VM

### Requisiti Minimi

- **CPU**: 2 vCPU
- **RAM**: 4 GB (2GB usati da Miracollo, 2GB per monitoring)
- **Disk**: 10 GB (Prometheus retention 15 giorni)
- **Network**: Porte aperte 3000, 9090, 9091, 9093

### Monitoring Risorse

```bash
# RAM usage
docker stats --no-stream

# Disk usage volumi
docker system df -v

# Pulizia se necessario
docker system prune -a --volumes
```

## Costi

- **VM Miracollo**: già esistente, già pagata! ✅
- **Docker images**: GRATIS (tutte open source)
- **Telegram bot**: GRATIS
- **Totale extra**: **0 EURO!** 🎉

## Sicurezza

- Tutti i servizi sono dietro firewall VM
- Accesso Grafana con password forte
- Telegram bot con chat privata
- Database SQLite read-only per exporter
- Container non-root user

## Support

- **Logs**: Tutti in `/opt/cervellaswarm/monitoring/logs/`
- **Config**: `/opt/cervellaswarm/monitoring/`
- **Database**: `/opt/cervellaswarm/data/swarm_memory.db`

---

**Versione:** 1.0.0
**Data:** 1 Gennaio 2026
**Autori:** Cervella DevOps 🚀 & Rafa 💙

*"Lo sciame che VEDE tutto. Anche quando dormi."* 🐝👀
