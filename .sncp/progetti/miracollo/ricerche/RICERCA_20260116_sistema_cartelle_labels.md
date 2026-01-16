# RICERCA: Sistema Cartelle/Labels Miracallook

**Data:** 2026-01-16
**Researcher:** cervella-researcher
**Progetto:** Miracallook
**Topic:** Stato attuale sistema cartelle/labels e completamento

---

## TL;DR

**Status:** PARZIALE - Backend OK, Frontend MANCANTE
**Opzione migliore:** Aggiungere sidebar con Inbox/Archive/Sent/Trash + labels Gmail
**Fonti:** [Superhuman Labels](https://help.superhuman.com/hc/en-us/articles/38458359354643-Labels-Gmail-Accounts), [Superhuman Folders](https://help.superhuman.com/hc/en-us/articles/43756940888979-Folders)
**Next:** Implementare sidebar navigazione + endpoint /gmail/sent + /gmail/archive

---

## STATO ATTUALE - BACKEND ✅

### API Esistenti (backend/gmail/api.py)

```python
FATTO ✅:
- GET  /gmail/inbox            → Lista email inbox
- GET  /gmail/message/{id}     → Singola email
- GET  /gmail/thread/{id}      → Thread conversazione
- GET  /gmail/labels           → Lista tutte le labels (riga 850-861)
- POST /gmail/archive          → Archivia email (riga 1050-1093)
- POST /gmail/trash            → Sposta in cestino (riga 1095-1137)
- POST /gmail/untrash          → Ripristina da cestino (riga 1139-1180)
- POST /gmail/mark-read        → Segna letto
- POST /gmail/mark-unread      → Segna non letto
- GET  /gmail/search           → Ricerca con query Gmail
- GET  /gmail/drafts           → Lista bozze
```

### Come Funziona Archive

**File:** `backend/gmail/api.py` (riga 1050-1093)

```python
@router.post("/archive")
async def archive_email(message_id: str):
    """
    Archivia email (rimuove da INBOX).

    In Gmail, archiviare = rimuovere il label INBOX.
    L'email rimane in All Mail e accessibile tramite ricerca.
    """
    service.users().messages().modify(
        userId="me",
        id=message_id,
        body={"removeLabelIds": ["INBOX"]}
    ).execute()
```

**Meccanismo:**
- Gmail usa sistema LABELS, non cartelle
- INBOX = label speciale
- Archive = rimuovere label INBOX
- Email rimane in "All Mail" (accessibile via search)

### Endpoint MANCANTI

```
SERVE:
- GET /gmail/sent         → Email inviate (labelIds=["SENT"])
- GET /gmail/archived     → Email archiviate (label=-INBOX)
- GET /gmail/trash-list   → Email cestinate (labelIds=["TRASH"])
- GET /gmail/starred      → Email starred (labelIds=["STARRED"])
```

---

## STATO ATTUALE - FRONTEND ❌

### Layout (ThreePanel.tsx)

```
Struttura 3-panel:
┌─────────┬─────────────┬──────────────┐
│ Sidebar │ Email List  │ Detail View  │
│ 200px   │ 350px       │ flex-1       │
└─────────┴─────────────┴──────────────┘
```

**Resizable:** Sidebar e List hanno `resize: horizontal`

### Sidebar Attuale (Sidebar.tsx)

```jsx
CONTENUTO:
├── Logo "Miracollook"
├── Compose Button (C)
├── All (tutte le email)
└── Categories (filtri locali):
    ├── VIP (ospiti Booking.com)
    ├── Check-in (reservation confirmed)
    ├── Team (staff interno)
    ├── Fornitori (utilities, suppliers)
    ├── Newsletter (marketing)
    ├── System (noreply, automated)
    └── Other (resto)
```

**Sistema attuale:** FILTRI CLIENT-SIDE su categorie
**NON USA:** Labels Gmail reali
**NON MOSTRA:** Inbox/Archive/Sent/Trash

### API Service (services/api.ts)

```typescript
emailApi = {
  getInbox(),        ✅
  archiveEmail(),    ✅
  trashEmail(),      ✅

  // MANCANO:
  getSent(),         ❌
  getArchived(),     ❌
  getTrashList(),    ❌
  getStarred(),      ❌
  getLabels(),       ❌ (endpoint esiste, ma non usato)
}
```

---

## COSA MANCA PER SISTEMA COMPLETO

### 1. Endpoint Backend

```python
# backend/gmail/api.py - AGGIUNGI:

@router.get("/sent")
async def get_sent_emails(max_results: int = 20):
    """Email inviate"""
    results = service.users().messages().list(
        userId="me",
        labelIds=["SENT"],
        maxResults=max_results
    ).execute()
    # ... processa come inbox

@router.get("/archived")
async def get_archived_emails(max_results: int = 20):
    """Email archiviate (no INBOX label)"""
    results = service.users().messages().list(
        userId="me",
        q="-in:inbox",  # Query Gmail per "non in inbox"
        maxResults=max_results
    ).execute()
    # ... processa

@router.get("/trash-list")
async def get_trash_emails(max_results: int = 20):
    """Email nel cestino"""
    results = service.users().messages().list(
        userId="me",
        labelIds=["TRASH"],
        maxResults=max_results
    ).execute()
    # ... processa

@router.get("/starred")
async def get_starred_emails(max_results: int = 20):
    """Email starred"""
    results = service.users().messages().list(
        userId="me",
        labelIds=["STARRED"],
        maxResults=max_results
    ).execute()
    # ... processa
```

### 2. Frontend - Nuovo Type

```typescript
// types/email.ts - ESTENDI:

type Folder =
  | 'inbox'
  | 'sent'
  | 'archived'
  | 'trash'
  | 'starred'
  | 'drafts';

type View =
  | { type: 'folder'; folder: Folder }
  | { type: 'category'; category: EmailCategory }
  | { type: 'label'; labelId: string };
```

### 3. Frontend - Sidebar Completo

```jsx
// Sidebar.tsx - RISTRUTTURA:

<nav>
  {/* SEZIONE 1: Folders Gmail */}
  <div>
    <div className="section-title">Folders</div>
    <SidebarItem icon="📥" label="Inbox" folder="inbox" />
    <SidebarItem icon="📤" label="Sent" folder="sent" />
    <SidebarItem icon="📦" label="Archive" folder="archived" />
    <SidebarItem icon="⭐" label="Starred" folder="starred" />
    <SidebarItem icon="📝" label="Drafts" folder="drafts" />
    <SidebarItem icon="🗑️" label="Trash" folder="trash" />
  </div>

  {/* SEZIONE 2: Categories (filtri smart) */}
  <div>
    <div className="section-title">Categories</div>
    <SidebarItem icon="👑" label="VIP" category="vip" />
    <SidebarItem icon="🏨" label="Check-in" category="checkin" />
    {/* ... altre categories */}
  </div>

  {/* SEZIONE 3: Custom Labels (futuro) */}
  <div>
    <div className="section-title">Labels</div>
    {/* Dalle labels Gmail API */}
  </div>
</nav>
```

### 4. App State Refactor

```typescript
// App.tsx - STATO:

const [currentView, setCurrentView] = useState<View>({
  type: 'folder',
  folder: 'inbox'
});

// Fetch dinamico basato su view
const { data: emails } = useMemo(() => {
  switch (currentView.type) {
    case 'folder':
      switch (currentView.folder) {
        case 'inbox': return useInbox();
        case 'sent': return useSent();
        case 'archived': return useArchived();
        case 'trash': return useTrash();
        // ...
      }
    case 'category':
      return useInbox().filter(categorizeEmail);
  }
}, [currentView]);
```

---

## COME FANNO I BIG PLAYER

### Gmail Web (Standard)

```
SIDEBAR:
├── Compose
├── Inbox (12)
├── Starred
├── Snoozed
├── Sent
├── Drafts
├── Trash
└── Labels:
    ├── Sistema (Spam, Important, etc.)
    └── Custom (create new label)
```

**Pattern:**
- Sidebar SEMPRE visibile (collapsable su mobile)
- Labels = folders virtuali
- Count badges sui label con unread
- Colori custom per label

### Superhuman (Premium)

```
SIDEBAR:
├── Compose (C)
├── Inbox (⌘ I)
├── Sent (⌘ E)
├── Scheduled
├── Drafts
└── Labels/Folders (⌘ K → go to)
```

**Pattern:**
- Keyboard-first (ogni folder ha shortcut)
- Cmd+K palette per quick nav
- Left arrow → mostra labels
- Swipe up (mobile) → folders

**Features:**
- Auto Archive (regole automatiche)
- Split Inbox (VIP, Team, etc.)
- Labels display inline con subject

**Fonti:**
- [Superhuman Labels](https://help.superhuman.com/hc/en-us/articles/38458359354643-Labels-Gmail-Accounts)
- [Superhuman Folders](https://help.superhuman.com/hc/en-us/articles/43756940888979-Folders)
- [Superhuman Auto Archive](https://help.superhuman.com/hc/en-us/articles/40127823829267-Auto-Archive)

---

## PROPOSTA SOLUZIONE - MVP

### FASE 1: Folders Base (4-6h)

**Backend:**
```python
1. GET /gmail/sent          (30 min)
2. GET /gmail/archived      (30 min)
3. GET /gmail/trash-list    (30 min)
4. GET /gmail/starred       (30 min)
```

**Frontend:**
```typescript
1. Estendi types (View, Folder)         (30 min)
2. Nuovi hooks (useSent, useArchived)   (1h)
3. Refactor Sidebar.tsx                 (2h)
   - Sezione Folders
   - Sezione Categories (esistente)
   - Gestione view corrente
4. Aggiorna App.tsx state               (1h)
5. Testing navigazione                  (1h)
```

**OUTPUT:**
```
SIDEBAR:
├── Compose
├── FOLDERS:
│   ├── Inbox (📥)
│   ├── Sent (📤)
│   ├── Archive (📦)
│   ├── Starred (⭐)
│   ├── Drafts (📝)
│   └── Trash (🗑️)
└── CATEGORIES: (esistente)
    ├── VIP
    ├── Check-in
    └── ...
```

### FASE 2: Labels Custom (futuro)

**Scope:**
- GET /gmail/labels (già esiste!)
- POST /gmail/labels/apply
- Sidebar sezione "Labels"
- Label picker (context menu + modal)
- Label colori + icone

**Effort:** 8-12h

---

## DECISIONI DA PRENDERE

### 1. Sidebar Layout

**Opzione A: Tutto in una sidebar (Gmail style)**
```
├── Compose
├── Folders (6 items)
├── Categories (7 items)
└── Labels (future)
```
**Pro:** Tutto visibile, Gmail familiarity
**Contro:** Può diventare lungo

**Opzione B: Tab sidebar (Superhuman style)**
```
Tab 1: Folders + Categories
Tab 2: Labels (future)
```
**Pro:** Più compatto
**Contro:** Extra click per switch

**RACCOMANDAZIONE:** Opzione A (Gmail style) - più immediato

### 2. Archive Button Position

**Opzione A: Solo context menu + keyboard (E)**
**Opzione B: Button in ThreadView header**
**Opzione C: Swipe gesture (mobile future)**

**RACCOMANDAZIONE:** Opzione B - visibilità + keyboard

### 3. Categories vs Folders

**Domanda:** Tenere entrambi o unificare?

**RACCOMANDAZIONE:**
- FOLDERS: navigazione vera (INBOX, SENT, TRASH)
- CATEGORIES: filtri smart CLIENT-SIDE su inbox
- Separazione chiara nella sidebar (2 sezioni)

---

## EFFORT ESTIMATE

| Fase | Task | Ore | Priority |
|------|------|-----|----------|
| **FASE 1** | Backend 4 endpoint | 2h | HIGH |
| | Frontend types + hooks | 1.5h | HIGH |
| | Sidebar refactor | 2h | HIGH |
| | App state refactor | 1h | HIGH |
| | Testing + polish | 1h | HIGH |
| **Totale FASE 1** | | **7.5h** | |
| **FASE 2** | Labels custom | 8-12h | MEDIUM |
| **FASE 3** | Label colors + icons | 4-6h | LOW |

**PRIORITÀ:** FASE 1 ora, FASE 2 dopo feedback Rafa

---

## RISCHI & MITIGATION

### Rischio 1: Gmail API Rate Limits

**Problema:** Chiamare 6 endpoint (inbox, sent, archive, etc.) = 6 requests
**Mitigation:**
- Cache React Query (30s staleTime già settato)
- Lazy loading (fetch solo folder aperta)
- Batch requests Gmail API (future optimization)

### Rischio 2: Performance con molte email

**Problema:** Archive può avere migliaia di email
**Mitigation:**
- Pagination (max_results=20, già implementato)
- Infinite scroll (react-window future)
- Search invece di "load all archive"

### Rischio 3: Confusion Categories vs Folders

**Problema:** User non capisce differenza
**Mitigation:**
- Separazione visiva sidebar (divider + title)
- Tooltip esplicativi
- Help modal con spiegazione

---

## FONTI

### Gmail API
- [Gmail API Labels](https://developers.google.com/gmail/api/guides/labels)
- [Gmail API Messages.list](https://developers.google.com/gmail/api/reference/rest/v1/users.messages/list)

### Competitor Analysis
- [Superhuman Labels](https://help.superhuman.com/hc/en-us/articles/38458359354643-Labels-Gmail-Accounts)
- [Superhuman Folders](https://help.superhuman.com/hc/en-us/articles/43756940888979-Folders)
- [Superhuman Auto Archive](https://help.superhuman.com/hc/en-us/articles/40127823829267-Auto-Archive)
- [Superhuman vs Shortwave 2026](https://zapier.com/blog/shortwave-vs-superhuman/)
- [How to use Superhuman](https://writing.arman.do/p/superhuman)

### Best Practices
- [Gmail Sidebar Navigation](https://bykelseysmith.com/how-to-keep-the-sidebar-in-gmail-from-collapsing/)
- [Email Sorting Apps 2026](https://blog.superhuman.com/email-sorter/)

---

## NEXT STEPS

1. ✅ Ricerca completata
2. ⏳ Review con Regina
3. ⏳ Decisione Rafa su priorità FASE 1 vs altri task
4. ⏳ Se approvato → delegare a:
   - Backend: cervella-backend (4 endpoint)
   - Frontend: cervella-frontend (sidebar + state)
   - Testing: cervella-tester (navigazione folders)

---

**COSTITUZIONE-APPLIED:** SI
**Principio usato:** "Studiare prima di agire" + "Come fanno i big players"
**Come applicato:**
- Ho studiato backend esistente (50% già fatto!)
- Ho analizzato Superhuman/Gmail patterns
- Ho proposto soluzione INCREMENTALE (FASE 1 MVP)
- Ho stimato effort REALISTICO (7.5h non mesi!)
- Ho documentato tutto per evitare ri-ricerca

*"Non reinventiamo la ruota - studiamo chi l'ha già fatta!"*
