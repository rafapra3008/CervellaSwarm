# PROMPT RIPRESA - PMS Core

> **Ultimo aggiornamento:** 16 Gennaio 2026 - Sessione 242
> **STATO:** 85% - Produzione FIXATA

---

## SESSIONE 242 - PROBLEMA CRITICO RISOLTO

```
PROBLEMA: Planning non caricava dati in produzione
CAUSA: DUE container backend attivi!
  - app-backend-1 (DB VUOTO) ← nginx andava QUI!
  - miracollo-backend-1 (DB corretto)

FIX APPLICATI:
1. Migrazione 024 (is_test column) applicata
2. Container app-backend-1 RIMOSSO
3. Ora nginx va al container corretto

LEZIONE: SERVE FORTEZZA MODE PER DEPLOY!
```

---

## FORTEZZA MODE - DA IMPLEMENTARE

```
OGNI DEPLOY DEVE:
1. Verificare UN SOLO container backend attivo
2. Verificare migrazioni DB applicate
3. Test endpoint PRIMA di dichiarare successo
4. Guardiana Ops supervisiona

MAI PIU' deploy "alla cieca"!
```

---

## STATO ATTUALE

```
IN PRODUZIONE - STABILE (dopo fix)

Funzionalita LIVE:
- Prenotazioni CRUD
- Room Rack / Planning
- Rate Board (9.5/10!)
- Channel Manager
- Ricevute PDF (Sprint Finanziario)
```

---

## SESSIONI RECENTI

| Sessione | Focus | Risultato |
|----------|-------|-----------|
| 242 | **FIX CRITICO** | Due container, DB vuoto, nginx sbagliato |
| 241 | Deploy Fly.io | CervellaSwarm API |
| 240 | Deploy fix | services/__init__.py |

---

## MODULI INTERNI

| Modulo | Stato |
|--------|-------|
| Rate Board | 9.5/10 |
| Finanziario | Fase 1 OK |
| What-If | POC |

---

## COMANDI PRODUZIONE

```bash
# Verifica container (DEVE essere UNO SOLO!)
ssh miracollo-vm "docker ps | grep backend"

# Health check
curl https://miracollo.com/health

# Test endpoint
curl https://miracollo.com/api/planning/NL
```

---

*"Il cuore batte. Ma proteggiamolo."*
*Braccio 1 - PMS Core*
