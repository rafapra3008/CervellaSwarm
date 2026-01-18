# PROMPT RIPRESA - Miracollo (Generale)

> **Ultimo aggiornamento:** 18 Gennaio 2026 - Sessione 256
> **NOTA:** Questo file e panoramica. Ogni braccio ha il SUO PROMPT_RIPRESA!

---

## SESSIONE 256: FIX DEPLOY DEFINITIVO

### Problema Risolto

```
ROOT CAUSE: Import assoluto negli SHIM files
  - email_parser.py: "from services.email" (SBAGLIATO)
  - Fixato: "from .email" (RELATIVO - funziona ovunque)

PREVENZIONE:
  - Test import aggiunto in GitHub Actions
  - Verifica PRIMA di deployare
```

### Analisi MACRO con Guardiane

```
Consultate: Guardiana Qualità + Ops + Ingegnera
Architettura: 8/10 - Solida
Subroadmap creata: SUBROADMAP_DEPLOY_ROBUSTO.md
```

### Deploy v4.1.0

```
1. Pull code
2. Build Docker
3. TEST IMPORT (nuovo!)
4. Deploy backend + polling 120s
5. Ricrea nginx
6. Health check finale
RISULTATO: SUCCESS!
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

## STATO MODULARIZZAZIONE

```
FASE 2: 100% COMPLETATA (Sessione 255)
  [x] 2.1 suggerimenti_engine.py -> 7 moduli
  [x] 2.2 planning_swap.py -> 5 moduli
  [x] 2.3 settings.py -> 7 moduli
  [x] 2.4 email_parser.py -> 6 moduli
  [x] 2.5 confidence_scorer.py -> 5 moduli

Health Score: 6/10 → 8/10 (30+ moduli creati!)
```

---

## PROSSIMA SESSIONE (257)

**FASE 3: CONSOLIDAMENTO** (quando torniamo a Miracollo)
```
- Organizza routers/ per domain
- Security TODO (Twilio, JWT)
- Test organization
```

**OPPURE:**
- Continuare con CervellaSwarm Show HN
- Dipende da priorità Rafa

---

## ROADMAPS

```
.sncp/progetti/miracollo/roadmaps/
├── SUBROADMAP_MODULARIZZAZIONE_PMS.md
└── SUBROADMAP_DEPLOY_ROBUSTO.md (NUOVO!)
```

---

*"Fatto BENE > Fatto veloce"*
