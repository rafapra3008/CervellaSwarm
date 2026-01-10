# IDEA: FORTEZZA MODE per Cervella AI

> **Data:** 10 Gennaio 2026
> **Sessione:** 150
> **Stato:** DA IMPLEMENTARE
> **Priorita:** MEDIA (dopo che sistema e' stabile)

---

## Perche' Serve

Cervella AI ora vive su VM. Ogni volta che facciamo update dobbiamo:
- Non rompere nulla
- Poter tornare indietro
- Testare prima di deployare

FORTEZZA MODE garantisce questo.

---

## Adattamento da Miracollo

Miracollo ha FORTEZZA_MODE_v2.md con 5 fasi. Per Cervella AI adattiamo:

### FASE 0: Pre-Requisiti
```
[ ] Git status clean (cervella-ai repo)
[ ] Version aggiornata in __init__.py
[ ] Syntax check: python -m py_compile
[ ] Nessun print() debug
```

### FASE 1: Test Locale
```
[ ] Docker build locale OK
[ ] Docker run locale OK
[ ] curl localhost:8002/health OK
[ ] curl localhost:8002/api/chat OK
[ ] Test conversazione: "Chi sei?"
```

### FASE 2: Preparazione
```
[ ] File modificati identificati
[ ] Version annotata
[ ] Backup plan scritto
[ ] Commit fatto su GitHub
```

### FASE 3: Backup VM
```bash
# Backup container attuale
ssh miracollo-vm "docker tag cervella-ai:latest cervella-ai:backup-$(date +%Y%m%d)"

# Backup data
ssh miracollo-vm "cp -r /home/rafapra/cervella-ai/data /home/rafapra/cervella-ai/data.backup-$(date +%Y%m%d)"
```

### FASE 4: Deploy
```bash
# 1. Rsync nuovo codice
rsync -avz --exclude '.venv' --exclude 'data' \
  ~/Developer/cervella-ai/ miracollo-vm:/home/rafapra/cervella-ai/

# 2. Rebuild
ssh miracollo-vm "cd /home/rafapra/cervella-ai && docker build -t cervella-ai:latest ."

# 3. Restart
ssh miracollo-vm "docker stop cervella-ai && docker rm cervella-ai"
ssh miracollo-vm "docker run -d --name cervella-ai --restart always \
  -p 8002:8002 -v /home/rafapra/cervella-ai/data:/app/data \
  --env-file /home/rafapra/cervella-ai/.env cervella-ai:latest"
```

### FASE 5: Test Produzione
```
[ ] curl 34.27.179.164:8002/health OK
[ ] curl 34.27.179.164:8002/api/chat OK
[ ] Test: "Chi sei?" - risposta con personalita'
[ ] Miracollo ancora funziona (porta 8001)
```

---

## Rollback Rapido

```bash
# Se qualcosa va storto:

# 1. Stop container rotto
ssh miracollo-vm "docker stop cervella-ai && docker rm cervella-ai"

# 2. Restore backup image
ssh miracollo-vm "docker tag cervella-ai:backup-YYYYMMDD cervella-ai:latest"

# 3. Restart con backup
ssh miracollo-vm "docker run -d --name cervella-ai --restart always \
  -p 8002:8002 -v /home/rafapra/cervella-ai/data:/app/data \
  --env-file /home/rafapra/cervella-ai/.env cervella-ai:latest"

# 4. Test
curl http://34.27.179.164:8002/health
```

---

## Script Helper (TODO)

Creare `scripts/deploy_cervella_ai.sh`:
```bash
#!/bin/bash
# FORTEZZA MODE - Deploy Cervella AI
# Usage: ./deploy_cervella_ai.sh

echo "=== FORTEZZA MODE - Cervella AI ==="
echo ""

# FASE 3: Backup
echo "FASE 3: Backup..."
ssh miracollo-vm "docker tag cervella-ai:latest cervella-ai:backup-$(date +%Y%m%d)"
echo "Backup creato!"

# FASE 4: Deploy
echo "FASE 4: Deploy..."
# ... resto dello script
```

---

## Quando Implementare

- **ORA:** Non urgente, sistema funziona
- **PRIMA del prossimo update:** OBBLIGATORIO

---

## Checklist Implementazione

- [ ] Creare script `deploy_cervella_ai.sh`
- [ ] Testare backup/restore
- [ ] Documentare in FORTEZZA_MODE_CERVELLA_AI.md
- [ ] Aggiungere al workflow standard

---

*"FORTEZZA MODE = Professionalita'!"*
