# AUDIT INFRASTRUTTURA - MIRACOLLOOK
## Cervella Guardiana Ops - 16 Gennaio 2026

---

## VERDETTO GENERALE

| Area | Stato | Note |
|------|-------|------|
| **Infrastruttura** | DEV-ONLY | Nessun deploy produzione |
| **Sicurezza** | CRITICO | OAuth secrets esposti |
| **Performance** | OK | Bundle 436KB totale |
| **Affidabilita** | MEDIA | Error handling presente ma basico |

**Verdetto:** BLOCK DEPLOY fino a fix sicurezza

---

## 1. STATO INFRASTRUTTURA

### Deployment Attuale

```
STATO: SOLO SVILUPPO LOCALE
- Backend: FastAPI porta 8002 (uvicorn --reload)
- Frontend: Vite porta 5173 (npm run dev)
- NO Docker per Miracallook
- NO Nginx dedicato
- NO HTTPS
- NO produzione
```

### Configurazione Trovata

| Componente | File | Stato |
|------------|------|-------|
| Backend | `miracallook/backend/main.py` | Presente |
| Frontend | `miracallook/frontend/` | Presente |
| Docker | ASSENTE | Solo PMS Core ha docker-compose |
| Nginx | ASSENTE | Solo PMS Core ha nginx.conf |
| SSL | ASSENTE | Solo localhost HTTP |

### Differenza PMS Core vs Miracallook

```
PMS CORE (8001):
- docker-compose.yml
- nginx/nginx.conf
- SSL Let's Encrypt
- Health checks
- Rate limiting
- Logging configurato
- PRODUZIONE LIVE

MIRACALLOOK (8002):
- Solo start_dev.sh
- uvicorn --reload
- Nessun Docker
- Nessun proxy
- SOLO DEVELOPMENT
```

---

## 2. PROBLEMI DI SICUREZZA

### CRITICO: OAuth Secrets Esposti

**File:** `/miracallook/.env`

```
PROBLEMA: Google OAuth credentials hardcoded in file .env leggibile
- GOOGLE_CLIENT_ID esposto
- GOOGLE_CLIENT_SECRET esposto
- File accessibile localmente
```

**Impatto:**
- Se questo file finisce in git = compromissione OAuth
- Chiunque con accesso al Mac puo leggere le credenziali

**Status .gitignore:** OK - `.env` e nel gitignore

**Raccomandazione:**
1. Verificare che .env NON sia mai stato committato (git log)
2. Rigenerare OAuth credentials se necessario
3. Per produzione: usare secrets manager

### WARNING: CORS Wide Open

**File:** `miracallook/backend/main.py` linee 25-36

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "http://localhost:5173",
        "http://localhost:5174",
        "http://localhost:5175",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

**Stato:** OK per development, MA:
- Per produzione serve restringere origins
- `allow_methods=["*"]` troppo permissivo

### WARNING: Token Storage Single-User

**File:** `miracallook/backend/auth/google.py` linea 108

```python
user_token = db.query(UserToken).first()  # Ritorna primo utente
```

**Problema:** Design single-user MVP. Per multi-user servira rifattorizzare.

### OK: Gmail Scopes Corretti

```python
SCOPES = [
    "openid",
    "https://www.googleapis.com/auth/gmail.readonly",
    "https://www.googleapis.com/auth/gmail.send",
    "https://www.googleapis.com/auth/gmail.modify",
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/userinfo.profile",
]
```

**Nota:** `.modify` e necessario per archive/trash/drafts - corretto.

---

## 3. PERFORMANCE

### Frontend Bundle

```
TOTALE: 436KB
- index.js: 408KB (compresso)
- index.css: 28KB

VALUTAZIONE: OTTIMO per un client email completo
```

### Dependencies

```json
// Solo essenziali - BENE
"dependencies": {
  "@heroicons/react": "^2.2.0",
  "@tanstack/react-query": "^5.90.16",
  "axios": "^1.13.2",
  "cmdk": "^1.1.1",
  "react": "^19.2.0",
  "react-dom": "^19.2.0",
  "react-hotkeys-hook": "^5.2.1",
  "react-resizable-panels": "^4.4.1"
}
```

**Nota:** React 19 e moderno, dependencies minimali.

### Backend

```
Moduli caricati:
- FastAPI 0.109.0
- google-api-python-client 2.116.0
- anthropic 0.18.0 (per AI)
- SQLAlchemy 2.0.40

NESSUN problema performance evidente (API leggera)
```

---

## 4. AFFIDABILITA

### Error Handling

**Backend:** Presente con pattern consistente

```python
except HttpError as error:
    logger.error(f"Errore: {error}")
    if error.resp.status == 400:
        raise HTTPException(status_code=400, detail="...")
    elif error.resp.status == 401:
        raise HTTPException(status_code=401, detail="Token scaduto...")
    elif error.resp.status == 429:
        raise HTTPException(status_code=429, detail="Rate limit...")
    else:
        raise HTTPException(status_code=500, detail=f"...")
```

**Valutazione:** BUONO - copre casi comuni Gmail API

### Health Check

**File:** `main.py`

```python
@app.get("/health")
async def health():
    return {
        "status": "ok",
        "app": "Miracollook",
        "version": "0.1.0"
    }
```

**Stato:** Presente MA basico
- Non verifica connessione DB
- Non verifica OAuth valido
- OK per dev, insufficiente per produzione

### Logging

```python
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
```

**Stato:** BASICO
- Solo console logging
- Nessun log rotation
- Nessun structured logging (JSON)

### Monitoring

**Stato:** ASSENTE
- Nessun APM
- Nessun metrics
- Nessun alerting

---

## 5. PROBLEMI NOTI

### Drafts Folder Error 500

**Analisi codice:** `/gmail/drafts` endpoint esiste e sembra corretto.

```python
@router.get("/drafts")
async def list_drafts(max_results: int = 20):
    # ... codice corretto
```

**Possibili cause errore 500:**
1. Token OAuth scaduto/revocato
2. Account Gmail non ha drafts
3. Gmail API rate limit
4. Credentials DB corrotto

**Raccomandazione:** 
- Verificare logs backend quando si riproduce errore
- Check `miracollook.db` per token validi
- Test con curl diretto su `/gmail/drafts`

### Deploy PMS Core Bloccato

**Non riguarda Miracallook.** Il problema `services/__init__.py` e nel PMS Core principale.

---

## 6. RACCOMANDAZIONI PER PRODUZIONE

### CRITICO (Prima del deploy)

| # | Azione | Priorita |
|---|--------|----------|
| 1 | Creare docker-compose per Miracallook | ALTA |
| 2 | Aggiungere nginx config con SSL | ALTA |
| 3 | Configurare CORS per dominio produzione | ALTA |
| 4 | Spostare OAuth secrets in secrets manager | ALTA |
| 5 | Rigenerare OAuth credentials se compromessi | ALTA |

### IMPORTANTE (Prima di 9.5/10)

| # | Azione | Priorita |
|---|--------|----------|
| 6 | Health check approfondito (DB + OAuth) | MEDIA |
| 7 | Structured logging (JSON) | MEDIA |
| 8 | Rate limiting interno (non solo nginx) | MEDIA |
| 9 | Multi-user auth support | MEDIA |
| 10 | Test suite per endpoint critici | MEDIA |

### NICE TO HAVE

| # | Azione | Priorita |
|---|--------|----------|
| 11 | APM/tracing (Sentry o simile) | BASSA |
| 12 | Metrics Prometheus | BASSA |
| 13 | Auto-refresh OAuth token | BASSA |

---

## 7. CHECKLIST DEPLOY-READY

```
PRE-DEPLOY CHECKLIST:

[ ] Docker
    [ ] Dockerfile per Miracallook backend
    [ ] docker-compose.yml separato o integrato
    [ ] Health check nel Dockerfile
    [ ] Logging configurato

[ ] Nginx
    [ ] nginx.conf per Miracallook
    [ ] SSL certificates
    [ ] CORS headers
    [ ] Rate limiting
    [ ] Proxy pass a backend

[ ] Security
    [ ] OAuth secrets in secrets manager
    [ ] CORS origins ristretti
    [ ] HTTPS enforced
    [ ] No credentials in logs

[ ] Monitoring
    [ ] Health endpoint approfondito
    [ ] Structured logging
    [ ] Alerting basico (UptimeRobot)

[ ] Testing
    [ ] Test OAuth flow
    [ ] Test tutti gli endpoint
    [ ] Test error handling
```

---

## 8. PIANO STABILITA 9.5/10

### Fase 1: Sicurezza (1-2 giorni)
1. Verifica git history per leak credentials
2. Rigenerare OAuth se necessario
3. Implementare proper secrets management

### Fase 2: Containerizzazione (2-3 giorni)
1. Creare Dockerfile Miracallook
2. Integrare in docker-compose esistente o nuovo
3. Configurare networking con PMS Core

### Fase 3: Proxy & SSL (1-2 giorni)
1. Estendere nginx.conf o creare nuovo
2. Configurare subdomain (es. mail.miracollo.com)
3. SSL con Let's Encrypt

### Fase 4: Monitoring (1 giorno)
1. Health check approfondito
2. Structured logging
3. UptimeRobot endpoint

### Tempo stimato totale: 5-8 giorni di lavoro

---

## SUMMARY

```
MIRACALLOOK ATTUALE:
- Stato: Development-only
- Security: CRITICO (OAuth in .env)
- Performance: OK (bundle 436KB)
- Affidabilita: MEDIA (error handling presente)
- Deploy-ready: NO

SERVE PER PRODUZIONE:
1. Docker + Nginx + SSL
2. Secrets management
3. Monitoring basico
4. Test suite

VERDETTO FINALE:
Codice funzionante per dev, ma NON deployare in produzione
senza le raccomandazioni CRITICHE implementate.
```

---

*Audit completato da Cervella Guardiana Ops*
*16 Gennaio 2026*
