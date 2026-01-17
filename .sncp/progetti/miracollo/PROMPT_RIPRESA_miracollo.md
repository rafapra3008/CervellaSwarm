# PROMPT RIPRESA - Miracollo (Generale)

> **Ultimo aggiornamento:** 17 Gennaio 2026 - Sessione 253
> **NOTA:** Questo file e panoramica. Ogni braccio ha il SUO PROMPT_RIPRESA!

---

## SESSIONE 253: MODULARIZZAZIONE FASE 2.2

### Lavoro Completato
- Split planning_swap.py (1046 righe -> 5 moduli)
- Retrocompatibilita mantenuta (shim)
- Sintassi verificata OK

### Split planning_swap.py
```
PRIMA: 1 file da 1046 righe
DOPO:
  routers/planning/
  ├── __init__.py      (54 righe) - Router unificato
  ├── swap.py          (295 righe) - swap_rooms, multi_swap
  ├── segment_swap.py  (303 righe) - swap_segment + helpers
  ├── room_change.py   (157 righe) - change_room_during_stay
  ├── assignments.py   (202 righe) - get_room_assignments, move_segment
  └── history.py       (84 righe) - history, undo

  planning_swap.py -> SHIM (45 righe)
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

## PROSSIMA SESSIONE (254)

**FASE 2.3:**
```
Split settings.py (838 righe)
  -> routers/settings/ (3 moduli)
```

**Subroadmap:** `.sncp/progetti/miracollo/roadmaps/SUBROADMAP_MODULARIZZAZIONE_PMS.md`

---

*"Un modulo alla volta. Pulito e preciso."*
