# PROMPT RIPRESA - PMS Core

> **Ultimo aggiornamento:** 16 Gennaio 2026 - Sessione 241
> **STATO:** 85% - Produzione stabile

---

## COS'E PMS CORE

Braccio principale Miracollo. Sistema gestionale hotel.
Porta :8000, in produzione su GCP VM.

---

## STATO ATTUALE

```
IN PRODUZIONE - STABILE

Funzionalita LIVE:
- Prenotazioni CRUD
- Anagrafica ospiti
- Room Rack / Planning
- Fatturazione
- Rate Board (9.5/10!)
- Housekeeping
- Revenue AI
- Meteo integration
- Eventi locali
```

---

## SESSIONI RECENTI

| Sessione | Focus | Risultato |
|----------|-------|-----------|
| 240 | Deploy fix | services/__init__.py OK |
| 232 | Mappa ecosistema | NORD.md creato |
| 231 | Architettura 3 bracci | Struttura definita |

---

## NESSUN LAVORO URGENTE

```
PMS Core e STABILE.
Non richiede interventi.

Se serve lavorare:
1. Leggere COSTITUZIONE_pms-core.md
2. Verificare che non rompa nulla
3. Test PRIMA di deploy
4. Rollback pronto
```

---

## MODULI INTERNI

| Modulo | Path docs | Stato |
|--------|-----------|-------|
| Rate Board | `../../moduli/rateboard/` | 9.5/10 |
| What-If | `../../moduli/whatif/` | POC |
| Finanziario | `../../moduli/finanziario/` | Base |

---

## COMANDI

```bash
# Backend (su VM)
ssh miracollo-vm
cd /app/backend
source venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 8000

# Frontend (su VM)
# Servito da nginx su porta 80/443

# URL Produzione
https://miracollo.app
```

---

## COMUNICAZIONE

```
PMS Core ESPONE API per:
- Miracallook (dati ospiti)
- Room Hardware (stato camere)

PMS Core e la FONTE DI VERITA.
Gli altri bracci LEGGONO da noi.
```

---

*"Il cuore batte. L'hotel vive."*
*Braccio 1 - PMS Core*
