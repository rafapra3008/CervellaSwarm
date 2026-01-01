# Deployment Checklist - CervellaSwarm Monitoring 📋

Checklist completa per deploy sicuro dello stack monitoring su VM Miracollo.

## Pre-Deploy Checklist

### Locale

- [ ] Database `swarm_memory.db` esiste e contiene dati
  ```bash
  sqlite3 ~/Developer/CervellaSwarm/data/swarm_memory.db ".tables"
  # Output: error_patterns  lessons_learned  swarm_events
  ```

- [ ] File `.env` configurato con valori reali
  ```bash
  cd ~/Developer/CervellaSwarm/docker
  cat .env | grep -v "^#" | grep "="
  # Verifica che NON ci siano "your_*_here"
  ```

- [ ] Test locale eseguito con successo
  ```bash
  docker-compose -f docker-compose.monitoring.yml up -d
  docker-compose -f docker-compose.monitoring.yml ps
  # Tutti i servizi devono essere "Up (healthy)"
  ```

- [ ] Alert Telegram funzionante in locale
  ```bash
  # Hai ricevuto messaggio di test?
  ```

### VM Miracollo

- [ ] VM accessibile via SSH
  ```bash
  ssh root@<VM_IP> "echo OK"
  # Output: OK
  ```

- [ ] Docker installato e funzionante
  ```bash
  ssh root@<VM_IP> "docker --version && docker-compose --version"
  ```

- [ ] Spazio disco sufficiente (min 10GB liberi)
  ```bash
  ssh root@<VM_IP> "df -h /"
  ```

- [ ] RAM disponibile (min 2GB liberi per monitoring)
  ```bash
  ssh root@<VM_IP> "free -h"
  ```

- [ ] Porte disponibili: 3000, 9090, 9091, 9093
  ```bash
  ssh root@<VM_IP> "netstat -tuln | grep -E ':(3000|9090|9091|9093)'"
  # Output vuoto = porte libere!
  ```

## Deploy Checklist

### 1. Preparazione VM

- [ ] Directory creata
  ```bash
  ssh root@<VM_IP> "mkdir -p /opt/cervellaswarm/{monitoring,data}"
  ```

- [ ] Permessi corretti
  ```bash
  ssh root@<VM_IP> "chown -R 1000:1000 /opt/cervellaswarm"
  ```

### 2. Upload Files

- [ ] Stack monitoring uploadato
  ```bash
  scp -r ~/Developer/CervellaSwarm/docker/* root@<VM_IP>:/opt/cervellaswarm/monitoring/
  ```

- [ ] Database uploadato
  ```bash
  scp ~/Developer/CervellaSwarm/data/swarm_memory.db root@<VM_IP>:/opt/cervellaswarm/data/
  ```

- [ ] File `.env` uploadato e configurato
  ```bash
  ssh root@<VM_IP> "cat /opt/cervellaswarm/monitoring/.env | grep TELEGRAM_BOT_TOKEN"
  # Verifica che il token sia quello giusto!
  ```

### 3. Build e Start

- [ ] Build immagini Docker
  ```bash
  ssh root@<VM_IP>
  cd /opt/cervellaswarm/monitoring
  docker-compose -f docker-compose.monitoring.yml build
  ```

- [ ] Start servizi
  ```bash
  docker-compose -f docker-compose.monitoring.yml up -d
  ```

- [ ] Verifica status
  ```bash
  docker-compose -f docker-compose.monitoring.yml ps
  # Tutti devono essere "Up (healthy)"
  ```

### 4. Verifica Funzionamento

- [ ] Swarm Exporter espone metriche
  ```bash
  ssh root@<VM_IP> "curl -s http://localhost:9091/metrics | grep swarm_tasks_total"
  # Output: swarm_tasks_total{...} 123
  ```

- [ ] Prometheus healthy
  ```bash
  ssh root@<VM_IP> "curl -s http://localhost:9090/-/healthy"
  # Output: Prometheus is Healthy.
  ```

- [ ] Grafana healthy
  ```bash
  ssh root@<VM_IP> "curl -s http://localhost:3000/api/health"
  # Output: {"commit":...,"version":...}
  ```

- [ ] AlertManager healthy
  ```bash
  ssh root@<VM_IP> "curl -s http://localhost:9093/-/healthy"
  # Output: AlertManager is Healthy.
  ```

### 5. Test Accesso Esterno

- [ ] Grafana accessibile da browser
  ```
  http://<VM_IP>:3000
  Login: admin / <GRAFANA_PASSWORD>
  ```

- [ ] Dashboard "CervellaSwarm - Overview" visibile
  - [ ] Panel "Task Totali" mostra dati
  - [ ] Panel "Success Rate" mostra percentuale
  - [ ] Panel "Agenti Attivi" mostra numero
  - [ ] Timeline mostra grafico

- [ ] Prometheus accessibile
  ```
  http://<VM_IP>:9090
  Query: swarm_tasks_total
  Execute → Deve mostrare risultati
  ```

### 6. Test Alert System

- [ ] Invia test alert
  ```bash
  ssh root@<VM_IP>
  curl -X POST http://localhost:9093/api/v1/alerts \
    -H 'Content-Type: application/json' \
    -d '[{"labels":{"alertname":"TestDeploy","severity":"info"},"annotations":{"description":"Deploy completato!"}}]'
  ```

- [ ] Ricevi messaggio su Telegram
  - [ ] Messaggio arrivato entro 1 minuto
  - [ ] Formato corretto
  - [ ] Tutti i dettagli presenti

### 7. Monitoring Continuo

- [ ] Logs clean (nessun errore)
  ```bash
  ssh root@<VM_IP>
  cd /opt/cervellaswarm/monitoring
  docker-compose -f docker-compose.monitoring.yml logs --tail=50
  ```

- [ ] Container non in restart loop
  ```bash
  docker stats --no-stream
  # Verifica RAM/CPU usage normale
  ```

- [ ] Volumi creati correttamente
  ```bash
  docker volume ls | grep cervellaswarm
  # Output:
  # cervellaswarm-prometheus-data
  # cervellaswarm-grafana-data
  # cervellaswarm-alertmanager-data
  ```

## Post-Deploy Checklist

### Configurazione Finale

- [ ] Password Grafana cambiata (se usata default)
  ```
  Settings → Users → admin → Change Password
  ```

- [ ] Timezone configurato
  ```
  Grafana → Settings → Preferences → Timezone
  Imposta: Browser Time (Europe/Rome)
  ```

- [ ] Notification channel Telegram verificato
  ```
  Grafana → Alerting → Contact points
  Testa invio notifica
  ```

### Backup

- [ ] Script backup creato
  ```bash
  ssh root@<VM_IP>
  nano /opt/cervellaswarm/backup.sh
  # Aggiungi script backup volumi
  chmod +x /opt/cervellaswarm/backup.sh
  ```

- [ ] Primo backup eseguito
  ```bash
  /opt/cervellaswarm/backup.sh
  ls -lh /opt/cervellaswarm/backups/
  ```

### Documentazione

- [ ] IP VM documentato
- [ ] Password Grafana salvata in password manager
- [ ] Token Telegram bot salvato (backup)
- [ ] Chat ID Telegram documentato

### Monitoring del Monitoring

- [ ] Aggiungi remind settimanale per check dashboard
- [ ] Configura alert se servizi monitoring vanno down
- [ ] Test failover (restart singolo container)

## Rollback Checklist

Se qualcosa va male:

- [ ] Stop stack
  ```bash
  docker-compose -f docker-compose.monitoring.yml down
  ```

- [ ] Check logs per errori
  ```bash
  docker-compose -f docker-compose.monitoring.yml logs
  ```

- [ ] Fix problema

- [ ] Restart
  ```bash
  docker-compose -f docker-compose.monitoring.yml up -d
  ```

## Success Criteria

Il deploy è considerato SUCCESSFUL se:

✅ Tutti i container sono "Up (healthy)"
✅ Dashboard Grafana mostra dati reali
✅ Alert Telegram funzionano
✅ Nessun errore nei logs
✅ Metriche aggiornate ogni 30s
✅ Success rate > 0% (se ci sono task)

## Comandi Utili Post-Deploy

```bash
# SSH sulla VM
alias swarm-ssh='ssh root@<VM_IP>'

# Logs monitoring
alias swarm-logs='ssh root@<VM_IP> "cd /opt/cervellaswarm/monitoring && docker-compose -f docker-compose.monitoring.yml logs -f"'

# Status
alias swarm-status='ssh root@<VM_IP> "cd /opt/cervellaswarm/monitoring && docker-compose -f docker-compose.monitoring.yml ps"'

# Restart
alias swarm-restart='ssh root@<VM_IP> "cd /opt/cervellaswarm/monitoring && docker-compose -f docker-compose.monitoring.yml restart"'
```

## Support

Se hai problemi:

1. Check logs: `docker-compose logs -f`
2. Check health: `docker-compose ps`
3. Verifica `.env` ha valori corretti
4. Verifica network: `docker network inspect cervellaswarm-monitoring`
5. Verifica volumi: `docker volume ls | grep cervellaswarm`

---

**Data Deploy:** _____________

**Deploy By:** Rafa & Cervella DevOps 🚀

**Status:** [ ] IN PROGRESS  [ ] COMPLETED  [ ] ROLLBACK

**Notes:**
```
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________
```

---

*"Fatto bene > Fatto veloce"* 💙
