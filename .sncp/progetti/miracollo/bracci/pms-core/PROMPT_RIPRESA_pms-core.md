# PROMPT RIPRESA - PMS Core

> **Ultimo aggiornamento:** 17 Gennaio 2026 - Sessione 251
> **STATO:** 90% - Produzione STABILE e VERIFICATA

---

## SESSIONE 251 - AUDIT COMPLETO VM

```
VERIFICATO DIRETTAMENTE SULLA VM:

INFRASTRUTTURA:
  miracollo.com         LIVE (SSL, HTTPS)
  miracollo-backend-1   Up 17h (healthy)
  miracollo-nginx       Up 23h (healthy)

DATABASE:
  TIPO: SQLite (NON PostgreSQL!)
  PATH: /app/backend/data/miracollo.db
  SIZE: 3.8 MB
  TABELLE: 80+
  DATI: 45 bookings, 11 rooms, 27 guests

NGINX:
  SSL Let's Encrypt
  Rate limiting, HSTS, Gzip
  Zero-downtime ready
```

---

## ARCHITETTURA REALE

```
Internet -> Nginx (443) -> Backend (8001) -> SQLite

VM: miracollo-cervella (Google Cloud)
PATH: /home/rafapra/app/
DEPLOY: docker-compose up -d
```

---

## FUNZIONALITA LIVE

| Modulo | Stato |
|--------|-------|
| Prenotazioni CRUD | LIVE |
| Room Rack / Planning | LIVE |
| Rate Board | LIVE (9.5/10) |
| Channel Manager | LIVE |
| Ricevute PDF | LIVE |
| Health Check | LIVE |

---

## PROSSIMI STEP

```
P1 - Pulizia Codice:
  [ ] Rimuovere 56 TODO nel codice
  [ ] Split planning_*.py (965 righe -> max 500)

P2 - Verifiche:
  [ ] Test integrazione Stripe
  [ ] Verificare Autopilot attivo

P3 - Miglioramenti:
  [ ] Backup automatico DB
  [ ] Monitoring (Sentry?)
```

---

## COMANDI UTILI

```bash
# SSH
ssh miracollo-vm

# Stato
docker ps

# Logs
docker logs miracollo-backend-1 --tail 100

# Health
curl https://miracollo.com/health
```

---

## DOCUMENTAZIONE

| File | Scopo |
|------|-------|
| STATO_REALE_PMS.md | Verifica completa infrastruttura |
| docker-compose.yml | Config deploy (su VM) |
| nginx.conf | Config nginx (su VM) |

---

*"Il diamante brilla. Ora e' documentato."*
