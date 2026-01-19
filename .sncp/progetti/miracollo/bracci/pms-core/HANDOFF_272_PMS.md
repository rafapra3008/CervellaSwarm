# HANDOFF SESSIONE 272 - MIRACOLLO PMS

> **Data:** 19 Gennaio 2026
> **Braccio:** PMS Core (:8001)
> **Focus:** Pulizia Casa - Health 6.5/10 -> target 9/10

---

## STATO ATTUALE

```
PMS CORE
├── LIVE: 90% (produzione stabile)
├── Health: 6.5/10 (mappato questa sessione)
├── Modulo Finanziario: 75% (PARCHEGGIATO)
└── Pulizia Casa: 40% (IN CORSO)
```

---

## COSA ABBIAMO FATTO (Sessione 272)

### 1. AUDIT TECNICO
- Health Score: **6.5/10**
- 6 file >700 righe identificati
- 18 TODO mappati

### 2. MODULO SUBSCRIPTION ORGANIZZATO
```
backend/modules/subscription/
├── __init__.py        # Export pubblici
├── middleware.py      # LicenseCheckMiddleware
├── service.py         # SubscriptionService
├── router.py          # API endpoints
├── models.py          # Pydantic models
└── README.md          # Come riattivare
```
- Non serve ora (PMS uso interno)
- Pronto per riattivazione futura (vendita B2B)
- Guardiana APPROVE 9/10

### 3. ENCRYPTION INFRASTRUTTURA
```
backend/core/encryption.py    # TokenEncryptor Fernet
backend/scripts/generate_encryption_key.py
```
- Per criptare token Twilio/WhatsApp
- Chiave in .env (ENCRYPTION_KEY)

### 4. FIX TODO TECNICI (4 completati)

| File | Fix Applicato |
|------|---------------|
| `routers/settings/rooms.py:154` | Check prenotazioni future prima di disattivare camera |
| `services/email/bookingengine.py:87` | num_guests estratto da email (non piu hardcoded) |
| `routers/weather.py:84-115` | Location/type letti da database hotels |
| `routers/ml_api.py:447` | TODO obsoleto rimosso (codice gia implementato) |

### 5. SUBROADMAP SPLIT FILE CREATA

**Path:** `.sncp/progetti/miracollo/roadmaps/SUBROADMAP_SPLIT_FILE_GIGANTI.md`

---

## MAPPA SPLIT FILE GIGANTI

| # | File | Righe | Rischio | Sessioni |
|---|------|-------|---------|----------|
| 1 | tests/test_action_tracking.py | 820 | BASSO | 1 |
| 2 | routers/ml_api.py | 705 | BASSO | 1 |
| 3 | services/cm_import_service.py | 762 | MEDIO | 1.5 |
| 4 | routers/planning_core.py | 746 | **ALTO** | 2 |
| 5 | routers/ab_testing_api.py | 768 | MEDIO | 1.5 |
| 6 | routers/city_tax.py | 721 | MEDIO | 1.5 |

**Totale stimato:** 8-9 sessioni
**Standard:** Max 500 righe per file

---

## PROSSIMA SESSIONE - COSA FARE

### OPZIONE A: Split File (consigliato)

**Iniziare con warm-up (zero rischio):**

1. **test_action_tracking.py** (820 righe)
   - Solo test, zero impatto produzione
   - Splittare in directory `tests/test_action_tracking/`
   - Leggere SUBROADMAP per struttura target

2. **ml_api.py** (705 righe)
   - Router isolato, basso rischio
   - Splittare in directory `routers/ml/`

**ATTENZIONE:** planning_core.py e il CUORE del sistema. Farlo con calma!

### OPZIONE B: Test Scontrini RT

Quando in hotel:
- Stampante Bar: 192.168.200.240
- Test adapter SOAP
- Se OK: integrazione UI checkout

---

## FILE IMPORTANTI

| Cosa | Path |
|------|------|
| **SUBROADMAP Split** | `.sncp/progetti/miracollo/roadmaps/SUBROADMAP_SPLIT_FILE_GIGANTI.md` |
| NORD.md | `miracollogeminifocus/NORD.md` |
| PROMPT_RIPRESA | `.sncp/progetti/miracollo/bracci/pms-core/PROMPT_RIPRESA_pms-core.md` |
| Modulo Subscription | `backend/modules/subscription/README.md` |
| Encryption | `backend/core/ENCRYPTION_README.md` |

---

## PARCHEGGIATI

| Cosa | Motivo | Quando |
|------|--------|--------|
| Subscription system | Uso interno, no vendita | Quando B2B |
| Scontrini RT test | Serve essere in hotel | Prossima visita |
| Fatture XML impl. | Test SPRING OK | Quando serve |
| Export commercialista | 10-15 fatt/mese | Mai (manuale OK) |
| Notifiche CM | Modulo futuro | Q2 2026? |

---

## CHECKLIST PRE-SPLIT (per ogni file)

```
[ ] Leggere SUBROADMAP per struttura target
[ ] Backup file originale (git)
[ ] Identificare dipendenze (grep import)
[ ] Creare directory
[ ] Spostare models PRIMA
[ ] Spostare utils DOPO
[ ] Spostare endpoints ULTIMO
[ ] Aggiornare __init__.py
[ ] Aggiornare main.py import
[ ] Test suite completa
[ ] Commit atomico
```

---

## NOTE CRITICHE

1. **planning_core.py = CUORE del sistema**
   - Mai fretta su questo file
   - Test estensivi dopo split
   - Rollback plan pronto

2. **Focus SOLO su Miracollo PMS**
   - Non confondere con CervellaSwarm
   - Non confondere con Miracollook (:8002)

3. **Una cosa alla volta**
   - Un file per sessione
   - Commit atomici
   - Test sempre

---

*"Pulizia casa prima di costruire nuovo!"*
*"Fatto BENE > Fatto VELOCE"*

**Health: 6.5/10 -> target 9/10**

*Sessione 272 - Cervella & Rafa*
