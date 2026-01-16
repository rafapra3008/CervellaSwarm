# PROMPT RIPRESA - Miracollook

> **Ultimo aggiornamento:** 16 Gennaio 2026 - Sessione 241
> **STATO:** FASE 1 al 80% - Drag/Resize in corso

---

## COS'E MIRACOLLOOK

Email client per hotel che CONOSCE i tuoi ospiti.
Porta :8002 dentro ecosistema Miracollo.

---

## SESSIONE PRECEDENTE (240)

### FATTO
- Deploy fix (services/__init__.py)
- Consultata cervella-marketing per UX specs drag/resize
- Creato ThreePanelResizable.tsx (DA VERIFICARE API!)

### PROBLEMA IDENTIFICATO
```
react-resizable-panels v4 installata ma MAI USATA!
Lo studio dice: Group, Panel, Separator
Io ho usato: PanelGroup, Panel, PanelResizeHandle
VERIFICARE quale API e corretta!
```

---

## DA FARE (Prossima Sessione)

```
1. VERIFICARE API react-resizable-panels v4
   cd miracallook/frontend
   npm ls react-resizable-panels

2. AGGIORNARE ThreePanelResizable.tsx se serve

3. AGGIORNARE index.css (handle CSS)
   - Handle sempre visibile 2px grigio
   - Hover: 4px accent (#7c7dff)

4. MIGRARE App.tsx
   - import ThreePanelResizable invece di ThreePanel

5. TESTARE + GUARDIANA QUALITA
```

---

## SPECS UX (validate da marketing)

| Pannello | Default | Min | Max |
|----------|---------|-----|-----|
| Sidebar | 12% | 10% | 20% |
| List | 28% | 22% | 45% |
| Detail | 60% | 40% | - |

- Handle: sempre visibile 2px grigio, hover 4px accent
- Sidebar: collapsabile con toggle

---

## STATO FASE 1 (80%)

```
FATTO:
[x] OAuth, Inbox, Send, Reply, Forward, Archive, Trash
[x] Search, AI Summary, Keyboard Shortcuts, Command Palette
[x] Mark Read/Unread (Sessione 222)
[x] Drafts Auto-Save (Sessione 222)
[x] Upload Attachments (Sessione 223)
[x] Thread View (Sessione 223)

DA FARE:
[ ] 1.5 Resizable Panels (3h) <- IN CORSO!
[ ] 1.6 Context Menu (5h)
[ ] 1.7 Bulk Actions (7-10gg)
[ ] 1.8 Labels Custom (2-3gg)
[ ] 1.9 Contacts (2-3gg)
[ ] 1.10 Settings (8-12h)
```

---

## FILE CHIAVE

| File | Path | Stato |
|------|------|-------|
| ThreePanelResizable | `frontend/src/components/Layout/` | DA VERIFICARE |
| Studio drag/resize | `studi/RICERCA_RESIZABLE_PANELS_V4.md` | Completo |
| MAPPA COMPLETA | `MAPPA_COMPLETA_MIRACOLLOOK.md` | 48 step |

---

## COMANDI

```bash
# Backend
cd ~/Developer/miracollogeminifocus/miracallook/backend
uvicorn main:app --port 8002 --reload

# Frontend
cd ~/Developer/miracollogeminifocus/miracallook/frontend
npm run dev
```

---

*"Non e un email client. E l'Outlook che CONOSCE il tuo hotel."*
