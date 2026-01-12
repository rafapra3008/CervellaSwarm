# RICERCA: Workflow Miracollo - Stato Attuale

> **Data:** 12 Gennaio 2026
> **Ricercatrice:** Cervella Researcher
> **Obiettivo:** Mappare workflow sviluppo/deploy di Miracollo

---

## TL;DR

**Status**: OK
**Workflow attuale**: Docker Compose + GitHub Actions + SSH Deploy
**Ambiente locale**: MANCA! (mai testato in locale Docker)
**Problemi trovati**: 0 ambiente di test locale, testing manuale su prod

**Opzione migliore**: Setup ambiente locale Docker + ngrok per webhook test

**Fonti**:
- docker-compose.yml (architettura nginx + backend)
- .github/workflows/deploy.yml (v3.1.0)
- scripts/deploy_vm.sh (Fortezza Mode v4.1.0)
- docs/setup/DOCKER_SETUP.md

**Next**: Proposta workflow improvement in decisioni/

---

## 1. ARCHITETTURA ATTUALE

### 1.1 Ambiente di Produzione

**VM Google Cloud:**
- IP: 34.27.179.164
- SSH Alias: `miracollo-cervella`
- Path: `/app/miracollo`
- User: `root`

**Stack Docker:**
```yaml
services:
  nginx:
    - Porta 80/443 (HTTPS con Let's Encrypt)
    - Reverse proxy per backend
    - Serve frontend statico da /app/miracollo/frontend

  backend:
    - Porta 8001 (interno)
    - FastAPI + Gunicorn + Uvicorn workers
    - Database SQLite: /app/miracollo/backend/data/miracollo.db
    - Container name: miracollo-backend-N (scalabile)
```

**Network:**
```
Internet (HTTPS)
    ↓
Nginx (443) → SSL termination
    ↓
Backend (8001) → FastAPI
    ↓
SQLite DB (file)
```

### 1.2 Frontend

**Dove serve:**
- VM host: `/app/miracollo/frontend/` (Nginx legge da qui)
- NON nel container Docker!

**File chiave:**
- index.html, planning.html, rateboard.html, what-if.html
- JS: frontend/js/
- CSS: frontend/css/

**Deploy frontend:**
- Script: `scripts/deploy.sh frontend/`
- Rsync diretto su VM (no container)

### 1.3 Backend

**Dove serve:**
- Container Docker: `/app/backend/`
- Build via Dockerfile multi-stage

**Struttura:**
```
backend/
├── main.py          # Entry point (v4.2.0)
├── core/            # Config, database, utils
├── routers/         # API endpoints (modulari)
├── services/        # Business logic
└── data/            # SQLite DB (volume persistente)
```

**Deploy backend:**
- GitHub Actions: git push → auto-deploy
- Script manuale: `scripts/deploy_vm.sh` (Fortezza Mode)

---

## 2. WORKFLOW DI DEPLOY

### 2.1 GitHub Actions (Automatico)

**Trigger:** git push master

**Workflow (.github/workflows/deploy.yml v3.1.0):**
```
1. GitHub Actions triggered
2. SSH to VM (root@34.27.179.164)
3. cd /app/miracollo
4. git pull origin master
5. docker compose up -d --build backend
6. nginx reload
7. Health check (https://localhost/health)
8. Se FAIL → ROLLBACK automatico (git reset)
```

**Health check:**
- Endpoint: `GET /health`
- Response 200 = OK
- Timeout: 10s dopo rebuild

**Rollback:**
- Salva commit precedente
- Se health check FAIL → git reset + rebuild
- Notifica Telegram (opzionale)

### 2.2 Deploy Manuale (Fortezza Mode)

**Script:** `scripts/deploy_vm.sh`

**12 Principi di Sicurezza:**
```
[0] Test locale OBBLIGATORIO (prompt manuale)
[1] Verifica file locale esistono
[2] Connessione SSH OK
[3] Health check PRE-deploy
[4] Verifica versione (no downgrade)
[5] Backup database automatico (keep last 5)
[6] Upload files (rsync)
[7] Verifica MD5 (integrity check)
[8] Build + restart Docker
[9] Health check POST-deploy (retry 6x)
[10] Log + notifica Telegram
```

**Rollback automatico:**
- Se health check POST fail → ripristina backup
- Notifica fallimento

**Deploy file singoli:**
```bash
./scripts/deploy.sh backend/main.py
./scripts/deploy.sh frontend/js/planning.js
```

**Features:**
- Cache busting automatico per JS/CSS
- Check dipendenze Python (pip freeze diff)
- Backup database pre-deploy
- MD5 verification
- Notifica Telegram

---

## 3. AMBIENTE LOCALE - STATO ATTUALE

### 3.1 Cosa Esiste

**File presenti:**
- ✅ Dockerfile (multi-stage, ottimizzato)
- ✅ docker-compose.yml
- ✅ .env.example
- ✅ requirements.txt
- ✅ docs/setup/DOCKER_SETUP.md (guida completa!)

**Documentazione:**
- Setup Docker ben documentato
- Quick start: `docker-compose up -d`
- Health check: `curl http://localhost:8001/health`

### 3.2 Cosa MANCA

**❌ Ambiente locale MAI TESTATO!**

Evidenze:
1. Script deploy_vm.sh chiede "Hai testato LOCALMENTE?" → risposta attesa: NO!
2. Nessun database locale in `backend/data/`
3. Nessun .env configurato (solo .env.example)

**❌ Testing locale:**
- Nessun docker-compose.yml per development
- Nessun mock per integrazioni esterne
- Nessun ngrok setup per webhook

**❌ Staging environment:**
- Solo prod! (34.27.179.164)
- Nessun ambiente di test separato

---

## 4. TESTING

### 4.1 Test Esistenti

**Backend tests:**
```
backend/tests/
├── test_alloggiati.py
├── test_gdpr.py
├── test_payment_flow_sprint2_3.py
├── test_revenue_intelligence.py
├── test_pricing_tracking.py
└── ... (20+ file)
```

**Come si eseguono:**
- ❓ SCONOSCIUTO (nessun pytest.ini trovato)
- ❓ Probabilmente: `pytest backend/tests/`

### 4.2 Gap di Testing

**❌ Nessun test automatico nel CI:**
- GitHub Actions deploy SENZA test!
- Deploy diretto senza validazione

**❌ Test manuali su produzione:**
- Unico modo per testare = deploy su prod
- Rischio alto di breaking changes

**❌ Integrazioni esterne:**
- WhatsApp, Gemini AI, Email IMAP
- Testing solo su prod (webhook reali!)

---

## 5. DATABASE

### 5.1 Produzione

**Tipo:** SQLite
**Path:** `/app/miracollo/backend/data/miracollo.db`
**Backup:** Automatico pre-deploy (keep last 5)

**Migrations:**
- File: `backend/database/migrations.py`
- Eseguito all'avvio (init_db())

### 5.2 Locale

**❌ NESSUN DATABASE LOCALE!**

Per testare localmente servirebbe:
1. Copiare DB prod (backup) in locale
2. O creare DB vuoto + seed data
3. O mock completo (in-memory SQLite)

---

## 6. INTEGRAZIONI ESTERNE

### 6.1 Servizi Attivi

**AI:**
- Google Gemini (document parser)
- Anthropic Claude (WhatsApp AI)

**Communication:**
- Meta WhatsApp Cloud API
- Twilio WhatsApp (alternativo)
- Email IMAP polling (Gmail)

**Payments:**
- ❓ (non trovato in questa ricerca)

### 6.2 Testing Integrazioni

**Problema attuale:**
- Webhook testing solo su prod!
- Nessun ngrok setup
- Nessun mock server

**Cosa serve:**
- ngrok tunnel per webhook locali
- Mock server per IMAP (MailHog?)
- Test API keys separate (dev/prod)

---

## 7. WORKFLOW DEVELOPMENT - COMPARAZIONE

### 7.1 Best Practice (da ricerca precedente)

**Aziende SaaS fanno:**
```
1. Ambiente locale identico a prod (Docker)
2. ngrok per webhook testing
3. Test automatici nel CI
4. Deploy solo se test OK
5. Rollback automatico
```

### 7.2 Miracollo Attuale

**Cosa fa BENE:**
- ✅ Docker Compose (architettura OK)
- ✅ GitHub Actions (deploy automatico)
- ✅ Rollback automatico
- ✅ Health check POST-deploy
- ✅ Backup database
- ✅ Fortezza Mode (12 principi sicurezza)

**Cosa MANCA:**
- ❌ Ambiente locale usato
- ❌ Test nel CI
- ❌ ngrok per webhook
- ❌ Staging environment
- ❌ Mock integrazioni

---

## 8. PROBLEMI IDENTIFICATI

### 8.1 Zero Testing Locale

**Rischio:** Breaking changes diretti in produzione

**Impatto:**
- Downtime possibile
- Rollback reattivo (non preventivo)
- Stress during deploy

**Soluzione:**
```bash
# Setup locale in 5 minuti:
cp .env.example .env
docker-compose up -d
curl http://localhost:8001/health
```

### 8.2 Nessun Test nel CI

**Rischio:** Deploy di codice broken

**GitHub Actions ATTUALE:**
```yaml
git pull → docker build → deploy
# MANCANO: pytest, linting, type checking
```

**GitHub Actions DOVREBBE:**
```yaml
git pull → pytest → linting → mypy → deploy
```

### 8.3 Webhook Testing su Prod

**Rischio:** Test WhatsApp/Email solo con dati reali

**Problema:**
- Impossibile testare webhook localmente
- Debug difficile (log solo su VM)

**Soluzione:** ngrok + webhook inspector

---

## 9. SUGGERIMENTI MIGLIORAMENTO

### 9.1 Quick Wins (< 1 ora)

**1. Setup ambiente locale:**
```bash
cd ~/Developer/miracollogeminifocus
cp .env.example .env
# Edit .env: DATABASE_URL=sqlite:///./backend/data/miracollo_local.db
docker-compose up -d
```

**2. Aggiungi test al CI:**
```yaml
# .github/workflows/deploy.yml
- name: Run Tests
  run: |
    docker-compose run backend pytest
```

**3. Script quick test locale:**
```bash
# scripts/test_local.sh
docker-compose up -d
sleep 5
curl -f http://localhost:8001/health || exit 1
echo "✅ Local environment OK!"
```

### 9.2 Medium Effort (1-2 giorni)

**1. ngrok setup per webhook:**
```bash
brew install ngrok
# Add to docs/TESTING_WEBHOOKS.md
```

**2. Staging environment:**
```bash
# Nuovo server GCP o Docker container separato
# .env.staging con DB separato
```

**3. Mock integrazioni:**
```yaml
# docker-compose.local.yml
services:
  mailhog:  # Mock email server
    image: mailhog/mailhog
    ports:
      - "1025:1025"  # SMTP
      - "8025:8025"  # Web UI
```

### 9.3 Long Term (1 settimana)

**1. Test suite completa:**
- Unit tests (già esistono!)
- Integration tests (con DB)
- E2E tests (Playwright?)

**2. Blue-green deployment:**
- 2 container backend simultanei
- Nginx switch tra loro
- Zero downtime deploy

**3. Database PostgreSQL:**
- Migrazione da SQLite
- Cloud SQL (GCP)
- Backup automatici

---

## 10. DOMANDE PER RAFA

### 10.1 Ambiente Locale

**Q1:** Hai mai testato Miracollo in Docker locale?
- Se SI → dove sono i file .env e database?
- Se NO → vuoi che setup l'ambiente locale ora?

**Q2:** Preferisci database locale:
- [ ] Copia del DB prod (backup)?
- [ ] DB vuoto + seed data?
- [ ] In-memory SQLite (test)?

### 10.2 Testing

**Q3:** Vuoi aggiungere test automatici al CI?
- [ ] SI → quali test? (pytest, linting, mypy?)
- [ ] NO → perché?

**Q4:** Come testi le integrazioni attualmente?
- WhatsApp webhook?
- Email IMAP?
- Gemini AI?

### 10.3 Staging

**Q5:** Serve un ambiente staging separato?
- [ ] SI → server GCP nuovo?
- [ ] NO → test solo su locale + prod?

---

## 11. PROSSIMI STEP SUGGERITI

### Priorità ALTA (fai ORA)

**1. Setup ambiente locale (5 min):**
```bash
cd ~/Developer/miracollogeminifocus
cp .env.example .env
docker-compose up -d
curl http://localhost:8001/health
```

**2. Test locale prima di ogni deploy:**
- Modifica → test locale → git push
- Nuovo workflow: LOCAL FIRST!

### Priorità MEDIA (questa settimana)

**3. Aggiungi pytest al CI:**
```yaml
- name: Tests
  run: docker-compose run backend pytest -v
```

**4. Documentazione testing:**
- docs/TESTING.md
- Come testare localmente
- Come testare webhook

### Priorità BASSA (prossimo sprint)

**5. ngrok setup**
**6. Mock server integrazioni**
**7. Staging environment**

---

## 12. CONCLUSIONI

### Stato Attuale

**Architettura:** 9/10 (Docker, nginx, modularità)
**Deploy:** 8/10 (GitHub Actions, Fortezza Mode, rollback)
**Testing:** 3/10 (nessun test locale, CI senza test)
**Developer Experience:** 4/10 (test solo su prod)

### Gap Principali

1. **Zero testing locale** → Test solo su prod (RISCHIOSO!)
2. **CI senza test** → Deploy anche se broken
3. **Webhook testing** → Solo prod (no ngrok)

### Raccomandazione

**AZIONE IMMEDIATA:**
```
Setup ambiente locale Docker OGGI!
Tempo: 5 minuti
Beneficio: Test sicuri, sviluppo veloce, zero downtime risk
```

**ROADMAP (2 settimane):**
```
Week 1: Ambiente locale + pytest in CI
Week 2: ngrok setup + docs testing + staging (opzionale)
```

---

**"Testa locale, deploya sereno!"** 🧪✅

*Fine ricerca: 12 Gennaio 2026*
