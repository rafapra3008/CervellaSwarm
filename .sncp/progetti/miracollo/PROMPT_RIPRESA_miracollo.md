# PROMPT RIPRESA - Miracollo (Generale)

> **Ultimo aggiornamento:** 18 Gennaio 2026 - Sessione 255
> **NOTA:** Questo file e panoramica. Ogni braccio ha il SUO PROMPT_RIPRESA!

---

## SESSIONE 255: MODULARIZZAZIONE FASE 2.4 + 2.5

### Lavoro Completato
- Split email_parser.py (830 righe -> 6 moduli) - 9.5/10
- Split confidence_scorer.py (779 righe -> 5 moduli) - 9/10
- Consultata Guardiana Ingegnera (2 piani validati)
- SHIM per backward compatibility creati

### Split email_parser.py
```
services/email/  (aggiunto al package esistente!)
├── models.py, detection.py, helpers.py
├── besync.py, bookingengine.py
└── __init__.py (router)
email_parser.py -> SHIM
```

### Split confidence_scorer.py
```
ml/confidence/
├── utils.py         (107 righe) - Constants
├── model_utils.py   (318 righe) - Model + variance
├── components.py    (140 righe) - Acceptance + Quality
├── scorer.py        (187 righe) - Main calculation
└── __init__.py       (80 righe) - Router
confidence_scorer.py -> SHIM
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
  [x] 2.4 email_parser.py -> email/ (6 moduli)
  [x] 2.5 confidence_scorer.py -> confidence/ (5 moduli) <-- OGGI!

PROGRESSO: 100% (5/5) COMPLETATA!
```

---

## PROSSIMA SESSIONE (256)

**FASE 3: CONSOLIDAMENTO**
```
- Organizza routers/ per domain
- Security TODO (Twilio, JWT)
- Test organization
- Documentation update
```

**Subroadmap:** `.sncp/progetti/miracollo/roadmaps/SUBROADMAP_MODULARIZZAZIONE_PMS.md`

---

*"Un modulo alla volta. Pulito e preciso."*
