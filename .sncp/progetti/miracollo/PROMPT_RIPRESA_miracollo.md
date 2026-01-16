# PROMPT RIPRESA - Miracollo

> **Ultimo aggiornamento:** 16 Gennaio 2026 - Sessione 240
> **STATO:** Code cleanup completato, drag/resize problema identificato

---

## SESSIONE 240: CODE CLEANUP MIRACOLLOOK

### Completato

| Task | Prima | Dopo |
|------|-------|------|
| App.tsx | 570 righe | 318 righe (-44%) |
| App.css | legacy Vite | RIMOSSO |
| CommandPalette | 3 TODO navigation | FUNZIONANTE |
| gmail/api.py | 1821 righe | 8 moduli |

### File Creati (Frontend)
- `hooks/useEmailHandlers.ts` (182 righe)
- `hooks/useBulkActions.ts` (111 righe)
- `hooks/useFolderNavigation.ts` (69 righe)

### File Creati (Backend)
- `gmail/utils.py`, `inbox.py`, `message.py`, `actions.py`
- `gmail/compose.py`, `drafts.py`, `search.py`, `ai.py`

### Score: 7.5 → 8.2/10

---

## SCOPERTA CRITICA - DRAG/RESIZE

```
+================================================================+
|   PROBLEMA IDENTIFICATO!                                       |
|                                                                |
|   react-resizable-panels@4.4.1 INSTALLATA ma MAI usata!        |
|   Codice usava CSS nativo "resize: horizontal" (non funziona)  |
|                                                                |
|   Breaking changes v4:                                         |
|   - PanelGroup → Group                                         |
|   - PanelResizeHandle → Separator                              |
|   - direction → orientation                                    |
|   - data-* → aria-*                                            |
|                                                                |
|   SOLUZIONE PRONTA: ThreePanelResizable.tsx                    |
|   Effort: 2-3 ore                                              |
+================================================================+
```

**Report completo:** `.sncp/progetti/miracollo/idee/STUDIO_DRAG_RESIZE_PROBLEMA_20260116.md`

---

## PROSSIMA SESSIONE

```
1. Implementare drag/resize (codice pronto!)
   - Creare ThreePanelResizable.tsx
   - Aggiornare index.css (aria-* attributes)
   - Migrare App.tsx al nuovo component

2. Testare Drafts error 500 (serve backend running)

3. Continuare verso 9.5/10
```

---

## BACKLOG MIRACOLLOOK

| # | Task | Stato |
|---|------|-------|
| 1 | Drag/resize pannelli | PRONTO (codice ready) |
| 2 | Drafts error 500 | Da testare |
| 3 | Palette salutare | Validata, da applicare |
| 4 | Star/Labels (1.8) | Futuro |

---

## ARCHITETTURA

```
MIRACOLLO
├── PMS CORE (:8000)        → 85% - Produzione
├── MIRACOLLOOK (:8002)     → 65% - Code cleanup fatto
└── ROOM HARDWARE (:8003)   → 10% - Attesa hardware
```

---

## DECISIONE LAYOUT

**LAYOUT FISSO confermato** per ora.
Ma abbiamo la soluzione per drag/resize pronta se vogliamo.

---

*"Non esistono cose difficili, esistono cose non studiate!"*
