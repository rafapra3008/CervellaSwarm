# PROMPT RIPRESA - Miracollo (Generale)

> **Ultimo aggiornamento:** 17 Gennaio 2026 - Sessione 252
> **NOTA:** Questo file e panoramica. Ogni braccio ha il SUO PROMPT_RIPRESA!

---

## SESSIONE 252: MODULARIZZAZIONE FASE 2.1

### Lavoro Completato
- Fix core/__init__.py (esportazioni mancanti)
- Split suggerimenti_engine.py (1047 righe -> 7 moduli)
- Retrocompatibilita mantenuta
- Test passano, main.py imports OK

### Split suggerimenti_engine.py
```
PRIMA: 1 file da 1047 righe
DOPO:
  services/suggerimenti/
  ├── types.py (43 righe)
  ├── analyzer.py (109 righe)
  ├── creators.py (491 righe)
  ├── integrations.py (157 righe)
  ├── confidence.py (268 righe)
  ├── orchestrator.py (266 righe)
  └── __init__.py (106 righe)
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

## PROSSIMA SESSIONE (253)

**FASE 2.2 + 2.3:**
```
1. Split planning_swap.py (965 righe)
2. Split settings.py (838 righe)
```

**Subroadmap:** `.sncp/progetti/miracollo/roadmaps/SUBROADMAP_MODULARIZZAZIONE_PMS.md`

---

*"Un modulo alla volta. Pulito e preciso."*
