# PROMPT RIPRESA - Miracollo (Generale)

> **Ultimo aggiornamento:** 18 Gennaio 2026 - Sessione 255
> **NOTA:** Questo file e panoramica. Ogni braccio ha il SUO PROMPT_RIPRESA!

---

## SESSIONE 255: MODULARIZZAZIONE FASE 2.4

### Lavoro Completato
- Split email_parser.py (830 righe -> 6 moduli)
- Consultata Guardiana Ingegnera (piano validato)
- Audit Guardiana Qualita: 9.5/10 APPROVED
- SHIM per backward compatibility creato

### Split email_parser.py
```
PRIMA: 1 file da 830 righe

DOPO:
  services/email/  (aggiunto al package esistente!)
  ├── models.py         (167 righe) - Enums + DataClasses
  ├── detection.py       (98 righe) - detect_* functions
  ├── helpers.py        (183 righe) - utility functions
  ├── besync.py         (224 righe) - BeSync parsers
  ├── bookingengine.py  (145 righe) - BookingEngine parsers
  └── __init__.py       (217 righe) - Router + parse_email

  email_parser.py -> SHIM (85 righe)
```

---

## ARCHITETTURA 3 BRACCI

```
MIRACOLLO
├── PMS CORE (:8001)        90% - PRODUZIONE
├── MIRACOLLOOK (:8002)     60% - Drag/resize
└── ROOM HARDWARE (:8003)   10% - Attesa hardware
```

---

## PROGRESSO FASE 2 (Modularizzazione)

```
COMPLETATI:
  [x] 2.1 suggerimenti_engine.py -> suggerimenti/ (7 moduli)
  [x] 2.2 planning_swap.py -> planning/ (5 moduli)
  [x] 2.3 settings.py -> settings/ (7 moduli)
  [x] 2.4 email_parser.py -> email/ (6 moduli) <-- OGGI!

DA FARE:
  [ ] 2.5 confidence_scorer.py (778 righe)

PROGRESSO: 80% (4/5)
```

---

## PROSSIMA SESSIONE (256)

**FASE 2.5:**
```
Split confidence_scorer.py (778 righe)
  -> ml/confidence/ (3 moduli)
```

**Subroadmap:** `.sncp/progetti/miracollo/roadmaps/SUBROADMAP_MODULARIZZAZIONE_PMS.md`

---

*"Un modulo alla volta. Pulito e preciso."*
