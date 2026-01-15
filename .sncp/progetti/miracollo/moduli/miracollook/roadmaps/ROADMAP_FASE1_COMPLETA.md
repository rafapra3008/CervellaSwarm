# ROADMAP FASE 1 - Miracollook

> **Creata:** 15 Gennaio 2026 - Sessione 222
> **Obiettivo:** Completare FASE 1 (~35h di lavoro)
> **Metodo:** Una feature alla volta, codice VERO, test, commit

---

## STATO INIZIALE

```
FASE 0: ████████████████████ 100% ✅
FASE 1: ██████.............. 30%
```

---

## SPRINT 1 - CRITICI (8h)

### 1.1 Mark Read/Unread (2h) 🔴
```
Difficoltà: ★☆☆☆☆
Ricerca: Non serve (pattern identico ad Archive)
Pattern: gmail/api.py righe 781-823

Backend:
  [ ] POST /gmail/mark-read (message_id)
  [ ] POST /gmail/mark-unread (message_id)

Frontend:
  [ ] api.ts: markRead(), markUnread()
  [ ] useEmails.ts: useMarkRead(), useMarkUnread()
  [ ] EmailDetail: bottoni/icone
  [ ] EmailList: indicatore unread visuale

Test: Click email unread → diventa read, e viceversa
```

### 1.2 Drafts Auto-Save (6h) 🔴
```
Difficoltà: ★★★☆☆
Ricerca: ✅ studi/RICERCA_DRAFTS_20260114.md

Backend:
  [ ] GET /gmail/drafts (lista bozze)
  [ ] POST /gmail/drafts (crea bozza)
  [ ] PUT /gmail/drafts/{id} (aggiorna)
  [ ] DELETE /gmail/drafts/{id} (elimina)

Frontend:
  [ ] useDrafts.ts hook completo
  [ ] DraftsList component
  [ ] Auto-save in ComposeModal (debounce 2s)
  [ ] Sidebar: sezione Drafts

Test: Scrivi email → chiudi → riapri → contenuto salvato
```

---

## SPRINT 2 - ALTI (12h)

### 2.1 Upload Attachments (4h) 🟠
```
Difficoltà: ★★★☆☆
Ricerca: ✅ decisioni/UPLOAD_ATTACHMENTS_SPECS.md

Backend:
  [ ] POST /gmail/send (con multipart/form-data)
  [ ] File validation (size, type)

Frontend:
  [ ] AttachmentPicker component
  [ ] Drag & drop zone
  [ ] Preview allegati
  [ ] Progress upload

Test: Componi email → allega file → invia → allegato ricevuto
```

### 2.2 Thread View (4h) 🟠
```
Difficoltà: ★★★★☆
Ricerca: ✅ decisioni/THREAD_VIEW_DESIGN_SPECS.md

Backend:
  [ ] GET /gmail/thread/{id} (tutti messaggi)
  [ ] Aggregazione conversazione

Frontend:
  [ ] ThreadList component
  [ ] Collapsed/Expanded rows
  [ ] Reply in context

Test: Click thread → vedi tutti i messaggi → reply mantiene contesto
```

### 2.3 Resizable Panels (4h) 🟠
```
Difficoltà: ★★☆☆☆
Ricerca: ✅ studi/RICERCA_RESIZABLE_PANELS.md
Libreria: react-resizable-panels

Frontend:
  [ ] Install react-resizable-panels
  [ ] Layout con 3 pannelli
  [ ] Persist sizes (localStorage)
  [ ] Min/max constraints

Test: Drag → resize → refresh → sizes mantenute
```

---

## SPRINT 3 - COMPLETAMENTO (15h)

### 3.1 Bulk Actions (5h) 🟡
```
Difficoltà: ★★★☆☆
Ricerca: Pattern da competitor analysis

Backend:
  [ ] POST /gmail/bulk-action
  [ ] {message_ids: [], action: 'archive'|'trash'|'read'|'unread'}

Frontend:
  [ ] Multi-select con checkbox
  [ ] BulkActionsToolbar
  [ ] Shift+click per range
  [ ] Keyboard shortcuts (Cmd+A)

Test: Seleziona 5 email → Archive all → tutte archiviate
```

### 3.2 Labels Custom (3h) 🟡
```
Difficoltà: ★★☆☆☆
Ricerca: Gmail API labels già studiata

Backend:
  [ ] POST /gmail/labels (create)
  [ ] PUT /gmail/labels/{id} (update)
  [ ] DELETE /gmail/labels/{id}
  [ ] POST /gmail/message/{id}/labels (assign)

Frontend:
  [ ] LabelPicker component
  [ ] Label colors
  [ ] Sidebar: labels dinamiche

Test: Crea label "Urgente" rosso → applica a email → filtra per label
```

### 3.3 Context Menu (5h) 🟡
```
Difficoltà: ★★★★☆
Ricerca: ✅ studi/RICERCA_CONTEXT_MENU*.md (2000+ righe!)
DIFFERENZIATORE: Hotel Actions unici!

Frontend:
  [ ] ContextMenu component
  [ ] 3 gruppi: Quick Actions, Organize, Hotel
  [ ] Keyboard nav (j/k, Enter)
  [ ] Position smart (viewport aware)

Test: Right-click email → menu appare → azione funziona
```

### 3.4 Contacts Autocomplete (6h) 🟢
```
Difficoltà: ★★★☆☆
Ricerca: Parziale (da completare se serve)

Backend:
  [ ] GET /gmail/contacts (from People API)
  [ ] Search/filter contacts

Frontend:
  [ ] ContactsAutocomplete component
  [ ] Debounced search
  [ ] Avatar + email display
  [ ] Recent contacts priority

Test: Scrivi "raf" in To → appare Rafa → click → email popolata
```

---

## CHECKLIST PROGRESSO

```
SPRINT 1 - CRITICI
[x] 1.1 Mark Read/Unread     15/01/2026 ✅
[ ] 1.2 Drafts Auto-Save     ____/____/2026

SPRINT 2 - ALTI
[ ] 2.1 Upload Attachments   ____/____/2026
[ ] 2.2 Thread View          ____/____/2026
[ ] 2.3 Resizable Panels     ____/____/2026

SPRINT 3 - COMPLETAMENTO
[ ] 3.1 Bulk Actions         ____/____/2026
[ ] 3.2 Labels Custom        ____/____/2026
[ ] 3.3 Context Menu         ____/____/2026
[ ] 3.4 Contacts Autocomplete ____/____/2026
```

---

## REGOLE

```
+================================================================+
|  PER OGNI FEATURE:                                              |
|                                                                 |
|  1. Leggi ricerca esistente (se c'è)                           |
|  2. Scrivi codice BACKEND                                       |
|  3. Testa endpoint (curl o Swagger)                            |
|  4. Scrivi codice FRONTEND                                      |
|  5. Testa end-to-end nel browser                               |
|  6. Git commit con messaggio chiaro                            |
|  7. Aggiorna questa roadmap ([ ] → [x])                        |
|  8. Aggiorna stato.md                                          |
|                                                                 |
|  MAI "FATTO" senza commit!                                      |
+================================================================+
```

---

## TEMPO STIMATO

```
Sprint 1:  8h  → Email client solido
Sprint 2: 12h  → Feature avanzate
Sprint 3: 15h  → Email client COMPLETO

TOTALE: ~35h

Un progresso al giorno = FASE 1 completa in ~2 settimane
```

---

*"Fatto BENE > Fatto VELOCE"*
*"Il tempo non ci interessa. Ci interessa fare BENE."*
