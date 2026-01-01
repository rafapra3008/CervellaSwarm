# Quick Start - CervellaSwarm Monitoring 🚀

Deploy rapido dello stack monitoring su VM Miracollo.

## Pre-requisiti

- [ ] VM Miracollo accessibile via SSH
- [ ] Docker installato sulla VM
- [ ] Bot Telegram configurato (token + chat_id)
- [ ] Database `swarm_memory.db` esistente

## Step 1: Telegram Bot (5 minuti)

```bash
# 1. Apri Telegram
# 2. Cerca: @BotFather
# 3. Invia: /newbot
# 4. Nome: CervellaSwarmBot
# 5. COPIA IL TOKEN!

# 6. Crea gruppo privato "CervellaSwarm Alerts"
# 7. Aggiungi il bot al gruppo
# 8. Invia: /start

# 9. Ottieni chat_id:
curl "https://api.telegram.org/bot<YOUR_TOKEN>/getUpdates"

# Cerca: "chat":{"id":-1001234567890
# COPIA IL NUMERO (negativo per gruppi)
```

## Step 2: Configurazione Locale (2 minuti)

```bash
cd ~/Developer/CervellaSwarm/docker

# Crea .env
cp .env.example .env

# Modifica con i tuoi valori
nano .env

# Inserisci:
# - GRAFANA_PASSWORD (scegli password forte)
# - TELEGRAM_BOT_TOKEN (dal passo 1)
# - TELEGRAM_CHAT_ID (dal passo 1)
# - SWARM_DB_PATH=../data/swarm_memory.db
```

## Step 3: Test Locale (opzionale - 5 minuti)

```bash
# Start stack
docker-compose -f docker-compose.monitoring.yml up -d

# Verifica running
docker-compose -f docker-compose.monitoring.yml ps

# Apri browser: http://localhost:3000
# Login: admin / <GRAFANA_PASSWORD>
# Dashboard: "CervellaSwarm - Overview"

# Test alert Telegram (dovrebbe arrivarti messaggio!)
docker logs cervellaswarm-alertmanager

# Stop
docker-compose -f docker-compose.monitoring.yml down
```

## Step 4: Deploy su VM (10 minuti)

```bash
# A. Crea directory su VM
ssh root@<VM_IP> "mkdir -p /opt/cervellaswarm/{monitoring,data}"

# B. Upload files
cd ~/Developer/CervellaSwarm

# Upload monitoring stack
scp -r docker/* root@<VM_IP>:/opt/cervellaswarm/monitoring/

# Upload database
scp data/swarm_memory.db root@<VM_IP>:/opt/cervellaswarm/data/

# C. Deploy su VM
ssh root@<VM_IP>

cd /opt/cervellaswarm/monitoring

# Crea .env (IMPORTANTE!)
cp .env.example .env
nano .env
# Inserisci i tuoi valori!

# Build e start
docker-compose -f docker-compose.monitoring.yml up -d

# Verifica
docker-compose -f docker-compose.monitoring.yml ps
# Tutti devono essere "Up (healthy)"
```

## Step 5: Verifica Funzionamento (5 minuti)

```bash
# SSH sulla VM
ssh root@<VM_IP>

# A. Test metriche exporter
curl http://localhost:9091/metrics | grep swarm_tasks_total

# B. Test Prometheus
curl http://localhost:9090/-/healthy
# Output: Prometheus is Healthy.

# C. Test Grafana
curl http://localhost:3000/api/health
# Output: {"commit":"...", "version":"..."}

# D. Test AlertManager
docker logs cervellaswarm-alertmanager | tail -20
# Nessun errore!
```

## Step 6: Accesso Dashboard

```bash
# Apri browser:
http://<VM_IP>:3000

# Login:
# Username: admin
# Password: <valore da .env>

# Dashboard:
# - Cerca "CervellaSwarm"
# - Click su "CervellaSwarm - Overview"

# Dovresti vedere:
# ✅ Task totali
# ✅ Success rate
# ✅ Agenti attivi
# ✅ Timeline attività
```

## Step 7: Test Alert Telegram

```bash
# SSH sulla VM
ssh root@<VM_IP>

cd /opt/cervellaswarm/monitoring

# Invia test alert
curl -X POST http://localhost:9093/api/v1/alerts \
  -H 'Content-Type: application/json' \
  -d '[{
    "labels": {
      "alertname": "TestAlert",
      "severity": "info"
    },
    "annotations": {
      "description": "Test alert dal monitoring CervellaSwarm!"
    }
  }]'

# Controlla Telegram!
# Dovresti ricevere messaggio con:
# "🐝 CervellaSwarm Alert"
```

## Comandi Utili

```bash
# Logs in tempo reale
docker-compose -f docker-compose.monitoring.yml logs -f

# Restart singolo servizio
docker-compose -f docker-compose.monitoring.yml restart grafana

# Stop tutto
docker-compose -f docker-compose.monitoring.yml down

# Start
docker-compose -f docker-compose.monitoring.yml up -d

# Status
docker-compose -f docker-compose.monitoring.yml ps

# Rebuild dopo modifiche
docker-compose -f docker-compose.monitoring.yml up -d --build swarm-exporter
```

## Troubleshooting Rapido

### Swarm Exporter non parte

```bash
# Check logs
docker logs cervellaswarm-exporter

# Problema comune: database path errato
# Verifica che /opt/cervellaswarm/data/swarm_memory.db esista!
ls -la /opt/cervellaswarm/data/

# Fix: copia database se manca
scp data/swarm_memory.db root@<VM_IP>:/opt/cervellaswarm/data/
```

### Alert non arrivano su Telegram

```bash
# Verifica variabili .env
cat /opt/cervellaswarm/monitoring/.env

# Verifica AlertManager logs
docker logs cervellaswarm-alertmanager

# Problema comune: token/chat_id errati
# Testa manualmente:
curl -X POST "https://api.telegram.org/bot<TOKEN>/sendMessage" \
  -d "chat_id=<CHAT_ID>&text=Test"
```

### Grafana non mostra dati

```bash
# Verifica Prometheus raggiungibile
docker exec cervellaswarm-grafana wget -O- http://prometheus:9090/-/healthy

# Se fallisce: problema network
# Riavvia tutto:
docker-compose -f docker-compose.monitoring.yml restart
```

## Metriche da Monitorare

Una volta attivo, tieni d'occhio:

- **Success Rate**: deve essere > 95%
- **Task/Giorno**: capire volume lavoro
- **Agenti attivi**: quanti agenti usi di più
- **Pattern errori**: errori ricorrenti
- **Lezioni CRITICAL**: da revieware subito

## Prossimi Step

Dopo il deploy:

1. ⏰ Configura review dashboard 1x/settimana
2. 📊 Monitora trend per 1 mese
3. 🎯 Ottimizza basandoti su dati reali
4. 📈 Aggiungi custom dashboard se serve

---

**Tempo totale setup:** ~30 minuti
**Costo extra:** 0 EURO (usa VM esistente!)
**Risultato:** Monitoring H24 completo! 🎉

*"Lo sciame ora VEDE tutto. Anche quando dormi."* 🐝👀

**Versione:** 1.0.0
**Data:** 1 Gennaio 2026
**Autori:** Cervella DevOps 🚀
