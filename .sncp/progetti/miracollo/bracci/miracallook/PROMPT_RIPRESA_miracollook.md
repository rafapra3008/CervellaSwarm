# PROMPT RIPRESA - Miracollook

> **Ultimo aggiornamento:** 16 Gennaio 2026 - Sessione 243
> **STATO:** Design Salutare IN CORSO - colori calm applicati, manca sfondo colonne

---

## COS'E MIRACOLLOOK

Email client per hotel che CONOSCE i tuoi ospiti.
Porta :8002 dentro ecosistema Miracollo.

---

## SESSIONE 243 - DESIGN SALUTARE (PARZIALE)

```
+================================================================+
|   APPLICATO:                                                    |
|   - Testo #FFFFFF -> #EBEBF5 (soft white, -glow)               |
|   - Colori calm: #778DA9 (blue-gray), #E0DED0 (warm)           |
|   - Labels FOLDERS/CATEGORIES -> calm-blue                      |
|   - Timestamps email -> calm-blue                               |
|   - Separatore sidebar -> calm-blue                             |
|                                                                |
|   NON FATTO:                                                    |
|   - Differenza sfondo tra colonne (Rafa ha screenshot studio)  |
|   - Rafa dice "vedo ancora molto uguale"                       |
+================================================================+
```

### File Modificati Sessione 243
- `tailwind.config.js` - miracollo-calm-blue, miracollo-calm-warm
- `index.css` - classi .text-miracollo-calm-blue, border, bg
- `Sidebar.tsx` - labels FOLDERS/CATEGORIES -> calm-blue
- `EmailListItem.tsx` - timestamps -> calm-blue

---

## PROSSIMA SESSIONE - Completare Design Salutare

```
OBIETTIVO: Applicare DIFFERENZA SFONDO tra colonne

COSA SERVE:
1. Rafa condivide screenshot dello studio originale
2. Capire esattamente quale sfondo per ogni colonna
3. Applicare e testare

RIFERIMENTI:
- Studio completo: .sncp/.../studi/RICERCA_DESIGN_SALUTARE.md
- Palette validata: .sncp/.../PALETTE_DESIGN_SALUTARE_VALIDATA.md
```

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

## STATO FASE 1 (80%)

```
FATTO:
[x] OAuth, Inbox, Send, Reply, Forward, Archive, Trash
[x] Search, AI Summary, Keyboard Shortcuts, Command Palette
[x] Mark Read/Unread, Drafts Auto-Save
[x] Upload Attachments, Thread View
[x] Resizable Panels (Allotment)
[~] Design Salutare (parziale)

DA FARE:
[ ] Design Salutare COMPLETO <- PROSSIMO!
[ ] Context Menu
[ ] Bulk Actions
[ ] Labels Custom
```

---

*"Non e un email client. E l'Outlook che CONOSCE il tuo hotel."*
