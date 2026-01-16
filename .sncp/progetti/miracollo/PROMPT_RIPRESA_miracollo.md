# PROMPT RIPRESA - Miracollo

> **Ultimo aggiornamento:** 16 Gennaio 2026 - Sessione 240
> **STATO:** Deploy OK + Drag/Resize IN CORSO

---

## SESSIONE 240: RIEPILOGO

### 1. DEPLOY MIRACOLLO FIXATO
- Fix `services/__init__.py` - 15 export mancanti (swap + stripe)
- Commits: `55fee8d`, `12cdd40`
- Backend: healthy, nginx: healthy, v1.7.0

### 2. DRAG/RESIZE INIZIATO (NON COMPLETO)
- Consultata cervella-marketing per UX specs
- Creato `ThreePanelResizable.tsx` (DA VERIFICARE)

---

## PROSSIMA SESSIONE - DA FARE

```
1. VERIFICARE export react-resizable-panels v4
   - Lo studio dice: Group, Panel, Separator
   - Io ho usato: PanelGroup, Panel, PanelResizeHandle
   - CONTROLLARE quale API e corretta!

2. AGGIORNARE index.css
   - Handle sempre visibile (2px grigio)
   - Hover: 4px accent (#7c7dff)

3. MIGRARE App.tsx
   - import ThreePanelResizable invece di ThreePanel

4. TESTARE
   - Visual, resize, constraints, collapse, persistenza

5. GUARDIANA QUALITA per score 9.5+
```

---

## SPECS UX (da cervella-marketing)

| Pannello | Default | Min | Max |
|----------|---------|-----|-----|
| Sidebar | 12% | 10% | 20% |
| List | 28% | 22% | 45% |
| Detail | 60% | 40% | - |

- Handle: **sempre visibile** 2px grigio, hover 4px accent
- Sidebar: **collapsabile** con toggle
- Mobile: stack verticale (futuro)

---

## FILES CHIAVE

| File | Stato |
|------|-------|
| `ThreePanelResizable.tsx` | CREATO (da verificare API) |
| `ThreePanel.tsx` | VECCHIO (backup) |
| `index.css` | DA AGGIORNARE (handle CSS) |
| `App.tsx` | DA MIGRARE |

---

## STUDIO COMPLETO

`.sncp/progetti/miracollo/idee/STUDIO_DRAG_RESIZE_PROBLEMA_20260116.md`
(831 righe - root cause + soluzione dettagliata)

---

## ARCHITETTURA

```
MIRACOLLO
├── PMS CORE (:8000)        → 85% - Deploy OK
├── MIRACOLLOOK (:8002)     → 65% - Drag/resize in corso
└── ROOM HARDWARE (:8003)   → 10% - Attesa hardware
```

---

*"Fatto BENE > Fatto VELOCE"*
