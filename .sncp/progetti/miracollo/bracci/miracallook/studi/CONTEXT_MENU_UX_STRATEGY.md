# Context Menu UX Strategy - Miracollook
> Analisi completa per il context menu (right-click) nell'email client hotel
> **Data:** 14 Gennaio 2026
> **Esperta:** Cervella Marketing
> **Status:** STRATEGY COMPLETE - Ready for Implementation

---

## Executive Summary

**OBIETTIVO:** Definire quale opzioni nel context menu per massimizzare efficienza hotel workflow.

**CONTESTO:** L'utente fa tasto destro su un'email. Cosa deve vedere? SOLO quello che serve per lavorare veloce.

**DECISIONE CHIAVE:** Context menu DEVE essere hotel-specific, non generico. Laura (receptionist) non è un developer Gmail power user.

**DIFFERENZIATORE:** Opzioni PMS-integrated che nessun altro email client ha!

---

## 1. USER JOURNEY - Quando Usano Context Menu?

### Scenario A: Triage Veloce (Laura - Morning Rush)

```
CONTESTO: 7:50, inbox 42 email, deve capire cosa è urgente

AZIONI FREQUENTI:
- Mark as Read/Unread (scan veloce)
- Archive (newsletter, spam)
- Star (follow-up dopo)
- Move to category (riorganizza)
- Assign to Team (delega)

FREQUENZA: 80% delle interazioni mattutine
VELOCITÀ RICHIESTA: < 1 secondo per azione
```

### Scenario B: Guest Action Diretta (Durante Turno)

```
CONTESTO: Email ospite, serve azione veloce

AZIONI FREQUENTI:
- Reply (standard)
- Create Booking Note (PMS!)
- Link to Booking (PMS!)
- Assign to VIP (categoria)
- Snooze until check-in date

FREQUENZA: 60% email ospiti
VELOCITÀ RICHIESTA: < 2 secondi (con PMS lookup)
```

### Scenario C: Bulk Management (Fine Turno)

```
CONTESTO: Inbox cleanup, seleziona 10 email simili

AZIONI FREQUENTI:
- Archive All
- Mark All Read
- Move All to Team
- Apply Label All

FREQUENZA: 2-3 volte/giorno
VELOCITÀ RICHIESTA: Instant per bulk action
```

### Scenario D: Search & Organize (Manager - Weekly Review)

```
CONTESTO: Marco cerca pattern, organizza storico

AZIONI FREQUENTI:
- Search from Sender
- Search by Subject
- Filter by Guest (PMS!)
- Export Thread

FREQUENZA: 1-2 volte/settimana
VELOCITÀ RICHIESTA: Non critica (analytical task)
```

---

## 2. COMPETITOR ANALYSIS - Cosa Fanno Altri?

### Gmail (Industry Standard)

**Opzioni Context Menu:**
1. Reply
2. Forward
3. Search for emails from sender
4. Search by subject
5. Open in new window
6. Add label
7. Move email

**PRO:** Simple, familiare
**CONTRO:** Generico, no hotel context

### Superhuman (Power User Focus)

**Opzioni Context Menu:**
- Minimal! Preferiscono keyboard shortcuts
- Focus: Archive, Snooze, Remind Me

**PRO:** Ultra-fast per power user
**CONTRO:** Learning curve alta

### Front (Team Collaboration)

**Opzioni Context Menu:**
- Assign to teammate
- Add comment
- Create task
- Link to project

**PRO:** Team-centric
**CONTRO:** Troppo complesso per receptionist

### Hotel Messaging Tools (Canary, Guestara)

**Opzioni Context Menu:**
- Link to reservation
- Create note
- Escalate to manager

**PRO:** Hotel-specific!
**CONTRO:** No full email client

---

## 3. MIRACOLLOOK CONTEXT MENU - Proposta Completa

### PRINCIPI DESIGN

```
1. FREQUENZA > FUNZIONALITÀ
   → Le azioni più comuni in TOP

2. HOTEL-FIRST
   → PMS actions prominenti, non nascoste

3. MASSIMO 12 OPZIONI
   → Oltre = overwhelm (NN/G guidelines)

4. GROUPING LOGICO
   → Separatori chiari per categorie

5. KEYBOARD SHORTCUT VISIBILE
   → Educa utente mentre usa menu
```

### MENU STRUCTURE - 3 GRUPPI

```
┌───────────────────────────────────────────────┐
│ GRUPPO 1: QUICK ACTIONS (80% frequenza)      │
├───────────────────────────────────────────────┤
│ ↩️  Reply                              R      │
│ ⤴️  Forward                            F      │
│ 📦 Archive                             E      │
│ ⭐ Star / Unstar                       S      │
├───────────────────────────────────────────────┤
│ GRUPPO 2: ORGANIZE (15% frequenza)           │
├───────────────────────────────────────────────┤
│ 🏷️  Add Label...                       L      │
│ 📁 Move to...                          V      │
│ 👥 Assign to Team...                   A      │
│ ✉️  Mark as Read / Unread              U      │
├───────────────────────────────────────────────┤
│ GRUPPO 3: HOTEL ACTIONS (5% freq - critico!) │
├───────────────────────────────────────────────┤
│ 🔗 Link to Booking                     ⌘B     │ <- PMS!
│ 📝 Create Booking Note                 ⌘N     │ <- PMS!
│ 🔍 View Guest Profile                  ⌘G     │ <- PMS!
│ ⏰ Snooze until Check-in               Z      │
└───────────────────────────────────────────────┘

TOTALE: 12 opzioni (sweet spot UX)
```

### CONTEXT-AWARE VARIATIONS

**Il menu CAMBIA in base al contesto!**

#### Variante A: Email NON LETTA

```
┌───────────────────────────────────────┐
│ ↩️  Reply                        R    │
│ 📦 Archive                       E    │
│ ⭐ Star                          S    │
│ ✉️  Mark as Read                 U    │  <- Emphasis!
│ ─────────────────────────────────    │
│ 🏷️  Add Label...                     │
│ 👥 Assign to Team...                 │
│ ─────────────────────────────────    │
│ 🔗 Link to Booking                    │
│ 📝 Create Note                        │
└───────────────────────────────────────┘

FOCUS: Read/Archive (triage veloce)
```

#### Variante B: Email GIA LETTA

```
┌───────────────────────────────────────┐
│ ↩️  Reply                        R    │
│ ⤴️  Forward                      F    │
│ 📦 Archive                       E    │
│ ✉️  Mark as Unread               U    │
│ ─────────────────────────────────    │
│ 🏷️  Add Label...                     │
│ 👥 Assign to Team...                 │
│ ─────────────────────────────────    │
│ 🔗 Link to Booking              ⌘B    │
│ 📝 Create Note                  ⌘N    │
└───────────────────────────────────────┘

FOCUS: Reply/Forward (azione post-lettura)
```

#### Variante C: Email CON ALLEGATO

```
┌───────────────────────────────────────┐
│ ↩️  Reply                        R    │
│ ⤴️  Forward                      F    │
│ 📎 Download All Attachments      ⌘D   │  <- Nuovo!
│ 📦 Archive                       E    │
│ ─────────────────────────────────    │
│ 🏷️  Add Label...                     │
│ 📁 Save to Booking Files         ⌘S   │  <- PMS!
│ ─────────────────────────────────    │
│ 🔗 Link to Booking                    │
└───────────────────────────────────────┘

FOCUS: Allegati + save to PMS
```

#### Variante D: Email DA OSPITE (Rilevato PMS Match)

```
┌───────────────────────────────────────┐
│ ↩️  Quick Reply (AI)            R     │  <- AI!
│ ⤴️  Forward to Manager          F     │
│ 📦 Archive + Resolve            E     │
│ ─────────────────────────────────    │
│ 🔗 Open Booking #12345         ⌘B     │  <- PMS Direct!
│ 📝 Add to Booking Notes        ⌘N     │  <- PMS!
│ 👁️  Guest Profile (Mrs. J.)    ⌘G     │  <- PMS!
│ ─────────────────────────────────    │
│ ⭐ Mark as VIP                        │
│ ⏰ Snooze until Check-in (15 Jan)     │  <- Smart!
└───────────────────────────────────────┘

FOCUS: PMS actions PROMINENTI!
```

#### Variante E: Email TEAM ASSIGNMENT

```
┌───────────────────────────────────────┐
│ ↩️  Reply to Sender              R    │
│ 💬 Add Team Comment              C    │  <- Nuovo!
│ ✅ Mark as Completed             ⌘X   │  <- Workflow!
│ 📦 Archive                       E    │
│ ─────────────────────────────────    │
│ 👥 Reassign to...                A    │
│ 🚨 Escalate to Manager           !    │  <- Critical!
│ ─────────────────────────────────    │
│ 🔗 Link to Booking                    │
└───────────────────────────────────────┘

FOCUS: Team collaboration
```

---

## 4. HOTEL-SPECIFIC OPTIONS - Deep Dive

### 🔗 Link to Booking

**TRIGGER:** Sempre visibile, ma smarth highlight se email da ospite

**AZIONE:**
1. Click → modal con booking search
2. Auto-suggest booking se PMS match trovato
3. Seleziona booking → link creato
4. Badge "🔗 Linked" appare su email

**USE CASE:**
```
Laura riceve email: "Hi, I'm arriving tomorrow..."
- Right click → Link to Booking
- Modal: "Found 2 matches: John Smith (Check-in 15 Jan)"
- Click → Email ora tagged con booking #12345
- Prossima volta: "Open Booking #12345" direct
```

**VALORE:** Zero context switch email->PMS

---

### 📝 Create Booking Note

**TRIGGER:** Sempre visibile se email linked to booking

**AZIONE:**
1. Click → inline text input appare
2. Scrivi nota (o AI suggerisce da email content)
3. Enter → nota salvata in PMS booking
4. Conferma: "Note added to Booking #12345"

**USE CASE:**
```
Email ospite: "I'm allergic to feathers, no down pillows please"
- Right click → Create Booking Note
- AI suggerisce: "Guest allergic to feathers - hypoallergenic pillows"
- Enter → salvato in PMS
- Housekeeping vede nota nel PMS
```

**VALORE:** Email insight → PMS automaticamente

---

### 👁️ View Guest Profile

**TRIGGER:** Disponibile se PMS match trovato

**AZIONE:**
1. Click → Guest Sidebar slide-in da destra
2. Mostra: foto, nome, camera, preferenze, storico
3. Click "Full Profile" → apre PMS (nuovo tab)

**USE CASE:**
```
Email da "j.smith@gmail.com" - chi è?
- Right click → View Guest Profile
- Sidebar: "John Smith, Room 305, Check-in oggi 15:00"
- Vede: "VIP guest, 5 previous stays, prefers quiet rooms"
- Risponde personalizzato!
```

**VALORE:** Context instant, no guessing

---

### ⏰ Snooze until Check-in

**TRIGGER:** Disponibile se email linked + check-in futuro

**AZIONE:**
1. Click → email archived
2. Auto-return inbox: mattina check-in day (7:00)
3. Notifica: "Guest arriving today - review email"

**USE CASE:**
```
15 giorni prima check-in: "Do you have parking?"
- Right click → Snooze until Check-in
- Email sparisce da inbox
- Check-in day (mattina): email riappare in top
- Laura: "Ah giusto, parcheggio! Preparo."
```

**VALORE:** Timing perfetto, zero overhead mentale

---

### 📁 Save to Booking Files

**TRIGGER:** Disponibile se email ha allegati + linked booking

**AZIONE:**
1. Click → allegati estratti
2. Upload automatico a PMS booking files
3. Conferma: "2 attachments saved to Booking #12345"

**USE CASE:**
```
Email: "Here's my passport copy for check-in"
- Right click → Save to Booking Files
- Passport PDF → PMS booking documents
- Check-in: receptionist vede doc già caricato
```

**VALORE:** Documents organized, no manual upload

---

### 🚨 Escalate to Manager

**TRIGGER:** Disponibile in team assignments

**AZIONE:**
1. Click → email reassigned to Manager inbox
2. Notifica manager: "Escalated from Laura - Urgent"
3. Original sender notified (opzionale)

**USE CASE:**
```
Complaint email: "Room AC broken, unacceptable!"
- Right click → Escalate to Manager
- Marco riceve con flag "ESCALATED"
- Laura può continuare, Marco handles
```

**VALORE:** Clear escalation path, no confusion

---

## 5. VISUAL DESIGN SPECS

### Layout & Spacing

```
MENU DIMENSIONS:
- Width: 280px (fixed)
- Max height: 480px (scroll se più opzioni)
- Border radius: 8px
- Shadow: 0 4px 12px rgba(0,0,0,0.15)

ITEM SPACING:
- Item height: 36px
- Padding: 8px 16px
- Gap between items: 2px
- Separator: 8px margin, 1px gray-200

TYPOGRAPHY:
- Font: Inter 14px
- Weight: 500 (medium)
- Icon size: 16px
- Shortcut: 11px, gray-500, right-aligned
```

### Color States

```
DEFAULT:
- Background: white
- Text: gray-900
- Icon: gray-600

HOVER:
- Background: indigo-50
- Text: indigo-900
- Icon: indigo-600

DISABLED:
- Background: gray-50
- Text: gray-400
- Icon: gray-300
- Cursor: not-allowed

HOTEL-SPECIFIC (Gruppo 3):
- Icon color: amber-600 (gold - stands out!)
- Hover: amber-50
```

### Icons Raccomandati

| Azione | Icon | Library |
|--------|------|---------|
| Reply | `↩️` arrow-bend-up-left | Lucide |
| Forward | `⤴️` arrow-up-right | Lucide |
| Archive | `📦` archive | Lucide |
| Star | `⭐` star | Lucide |
| Label | `🏷️` tag | Lucide |
| Move | `📁` folder | Lucide |
| Assign | `👥` users | Lucide |
| Mark Read | `✉️` mail-open | Lucide |
| Link Booking | `🔗` link | Lucide + amber! |
| Create Note | `📝` file-text | Lucide + amber! |
| Guest Profile | `👁️` user-circle | Lucide + amber! |
| Snooze | `⏰` clock | Lucide |
| Download | `📎` download | Lucide |
| Escalate | `🚨` alert-triangle | Lucide |

**NOTA:** Hotel-specific actions usano amber accent per visual differentiation!

---

## 6. INTERACTION PATTERNS

### Open/Close Behavior

```
TRIGGER OPEN:
- Right click su email list item
- Right click su email detail
- Menu key (Windows keyboard)
- Shift+F10 (alternate)

POSITION:
- Near cursor (10px offset)
- Adjust se vicino edge (flip up/left)
- Always visible (no overflow screen)

CLOSE:
- Click outside menu
- ESC key
- Click menu item (execute action)
- Scroll list (auto-close)
```

### Keyboard Navigation

```
DURANTE MENU APERTO:
- ↑/↓ arrows: Navigate items
- Enter: Execute selected
- ESC: Close menu
- Letter key: Jump to item (first letter match)
- Tab: Cycle through items

SHORTCUTS VISIBILI:
Ogni item mostra shortcut (es: "R" per Reply)
→ Educa utente: "Ah, posso fare R invece di menu!"
→ Gradual shift: context menu → keyboard power user
```

### Feedback & Confirmation

```
AZIONI IMMEDIATE (no confirm):
- Reply, Forward, Archive, Star
- Mark Read/Unread
- Add Label (modal)

AZIONI CON MODAL (input needed):
- Move to... (select folder)
- Assign to Team... (select person)
- Link to Booking (search booking)
- Create Note (text input)

AZIONI PERICOLOSE (confirm):
- Delete (no! Archive preferito)
- Escalate (optional confirm: "Add escalation note?")

SUCCESS FEEDBACK:
- Toast notification: "Email archived"
- Undo button in toast (5s)
- Optimistic update (instant visual)
```

---

## 7. DIFFERENTIATION FROM COMPETITORS

### Cosa Miracollook Fa MEGLIO

| Feature | Gmail | Superhuman | Front | Miracollook | Perché Meglio |
|---------|-------|------------|-------|-------------|---------------|
| **PMS Actions** | ❌ | ❌ | ❌ | ✅ | Nessuno ha hotel integration! |
| **Context-Aware** | ❌ | ⚠️ | ⚠️ | ✅ | Menu cambia per guest vs team |
| **Smart Snooze** | Basic | Good | ❌ | ✅ | Snooze to check-in date! |
| **Guest Profile** | ❌ | ❌ | ❌ | ✅ | Direct PMS lookup |
| **Team Escalate** | ❌ | ❌ | ✅ | ✅ | Match Front ma + hotel context |
| **Keyboard Visible** | ⚠️ | ✅ | ❌ | ✅ | Educa utente gradualmente |

### Value Proposition

```
GMAIL DICE:
"Right click per azioni base"

SUPERHUMAN DICE:
"Keyboard shortcuts > menu"

MIRACOLLOOK DICE:
"Right click per vedere opzioni PMS + email insieme"
"Link booking, crea nota, vedi ospite - senza lasciare email"
```

### Competitive Moat

```
Competitor può copiare:
- ✅ Design menu
- ✅ UX patterns
- ✅ Keyboard shortcuts

Competitor NON può copiare (senza PMS):
- ❌ Link to Booking
- ❌ Guest Profile lookup
- ❌ Booking Notes creation
- ❌ Smart snooze to check-in
- ❌ Save to Booking Files

MOAT = PMS integration deep!
```

---

## 8. IMPLEMENTATION PRIORITY

### MUST-HAVE (Sprint 1 - 3h)

**Gruppo 1 + Gruppo 2 Base:**

```
✅ CRITICAL PATH:
├── Reply                    (1h - già esiste, integrate in menu)
├── Forward                  (30min - idem)
├── Archive                  (30min - idem)
├── Star/Unstar             (30min - idem)
├── Mark Read/Unread        (30min - già fatto!)
└── Add Label               (30min - già fatto!)

TOTALE: ~3h per menu base Gmail-equivalent
```

**Deliverable:** Context menu funzionante con opzioni standard.

---

### SHOULD-HAVE (Sprint 2 - 6h)

**Gruppo 2 Completo + Hotel Actions Base:**

```
🏨 HOTEL-SPECIFIC:
├── Link to Booking          (2h - modal + PMS API)
├── Create Booking Note      (2h - inline input + PMS API)
├── View Guest Profile       (1h - trigger sidebar esistente)
└── Assign to Team           (1h - team assignment API)

TOTALE: ~6h per differentiation core
```

**Deliverable:** Menu hotel-specific funzionante. QUI sta il valore!

---

### NICE-TO-HAVE (Sprint 3 - 4h)

**Advanced Features:**

```
⚡ ADVANCED:
├── Snooze until Check-in    (2h - smart date logic)
├── Save to Booking Files    (1h - attachment upload API)
├── Escalate to Manager      (30min - reassign variant)
└── Context-aware variations (30min - conditional rendering)

TOTALE: ~4h per polish
```

**Deliverable:** Menu completo con tutte varianti smart.

---

### FUTURE ENHANCEMENTS (Post-MVP)

```
🚀 FASE 2:
- [ ] Multi-select bulk context menu (different options)
- [ ] Custom menu items (hotel config)
- [ ] AI suggested actions in menu
- [ ] "Frequently used" section (learning)
- [ ] Drag email to menu item (gesture alternative)
```

---

## 9. SUCCESS METRICS

### Quantitative

| Metric | Baseline | Target 1mo | How Measure |
|--------|----------|------------|-------------|
| **Context menu usage** | 0% | 40% actions | Track right-click vs keyboard |
| **Hotel actions usage** | N/A | 15% of context menu | Track Link Booking, Create Note |
| **Time to action** | 3-5s | 1-2s | Track right-click → execute |
| **PMS switches** | High | -30% | Track email→PMS app switch |
| **Keyboard adoption** | Low | 20% | Track shortcut usage growth |

### Qualitative

**User Survey (dopo 2 settimane):**

```
Q1: "Context menu mi fa risparmiare tempo" (1-5)
Target: > 4.0

Q2: "Hotel actions (Link Booking, Note) sono utili" (1-5)
Target: > 4.2

Q3: "Trovo facilmente l'azione che cerco" (1-5)
Target: > 4.0

Q4: "Preferisco context menu o keyboard shortcuts?" (choice)
Target: 50/50 split (entrambi hanno valore)
```

---

## 10. RISKS & MITIGATIONS

### Risk 1: Menu Troppo Complesso

**Problema:** 12+ opzioni = overwhelming per Laura

**Mitigation:**
- Context-aware hiding (mostra solo rilevanti)
- Grouping con separatori (visual chunking)
- User testing con receptionist reali
- Progressive disclosure: Start base → add hotel actions gradual

---

### Risk 2: PMS API Lento

**Problema:** "Link to Booking" prende 3s → frustrazione

**Mitigation:**
- Prefetch guest data on email list hover
- Skeleton loader in menu ("Loading booking...")
- Cache aggressivo (5min TTL)
- Fallback: "Link later" se API timeout

---

### Risk 3: Users Non Scoprono Menu

**Problema:** Abituati a click bottoni, non right-click

**Mitigation:**
- Onboarding tooltip: "Try right-click on email!"
- Context menu icon (⋮) su email hover (trigger alternativo)
- Keyboard shortcut visible → educa gradualmente
- Usage analytics → nudge se < 10% usage

---

### Risk 4: Keyboard Users Annoiati

**Problema:** Power user trova menu slow

**Mitigation:**
- Tutti shortcuts visibili (educa su alternative)
- Quick keyboard navigation (letter jump)
- Command palette alternativo (⌘K)
- Don't force menu, is optional workflow

---

## 11. DESIGN SPECS - Handoff Frontend

### Component Structure

```typescript
// frontend/src/components/EmailContextMenu/

EmailContextMenu.tsx          // Container + logic
├── ContextMenuItem.tsx       // Single item component
├── ContextMenuSeparator.tsx  // Visual divider
├── ContextMenuIcon.tsx       // Icon wrapper
└── useContextMenu.ts         // Hook (position, items, actions)

// Types
interface ContextMenuItem {
  id: string;
  label: string;
  icon: LucideIcon;
  shortcut?: string;
  action: () => void;
  disabled?: boolean;
  variant?: 'default' | 'hotel' | 'danger';
  divider?: boolean;
}

interface ContextMenuProps {
  email: Email;
  position: { x: number; y: number };
  onClose: () => void;
}
```

### Menu Items Configuration

```typescript
// Gruppo 1: Quick Actions
const quickActions: ContextMenuItem[] = [
  {
    id: 'reply',
    label: 'Reply',
    icon: CornerUpLeft,
    shortcut: 'R',
    action: () => handleReply(email),
  },
  {
    id: 'forward',
    label: 'Forward',
    icon: CornerUpRight,
    shortcut: 'F',
    action: () => handleForward(email),
  },
  {
    id: 'archive',
    label: 'Archive',
    icon: Archive,
    shortcut: 'E',
    action: () => handleArchive(email),
  },
  {
    id: 'star',
    label: email.isStarred ? 'Unstar' : 'Star',
    icon: Star,
    shortcut: 'S',
    action: () => handleStar(email),
    divider: true, // Separator dopo
  },
];

// Gruppo 2: Organize
const organizeActions: ContextMenuItem[] = [
  {
    id: 'label',
    label: 'Add Label...',
    icon: Tag,
    shortcut: 'L',
    action: () => handleAddLabel(email),
  },
  {
    id: 'move',
    label: 'Move to...',
    icon: FolderInput,
    shortcut: 'V',
    action: () => handleMove(email),
  },
  {
    id: 'assign',
    label: 'Assign to Team...',
    icon: Users,
    shortcut: 'A',
    action: () => handleAssign(email),
  },
  {
    id: 'markread',
    label: email.isUnread ? 'Mark as Read' : 'Mark as Unread',
    icon: Mail,
    shortcut: 'U',
    action: () => handleMarkRead(email),
    divider: true,
  },
];

// Gruppo 3: Hotel Actions (conditional)
const hotelActions: ContextMenuItem[] = [
  {
    id: 'link-booking',
    label: 'Link to Booking',
    icon: Link,
    shortcut: '⌘B',
    action: () => handleLinkBooking(email),
    variant: 'hotel', // Gold styling!
  },
  {
    id: 'create-note',
    label: 'Create Booking Note',
    icon: FileText,
    shortcut: '⌘N',
    action: () => handleCreateNote(email),
    variant: 'hotel',
    disabled: !email.linkedBooking, // Solo se linked
  },
  {
    id: 'guest-profile',
    label: 'View Guest Profile',
    icon: User,
    shortcut: '⌘G',
    action: () => handleGuestProfile(email),
    variant: 'hotel',
    disabled: !email.guestMatch, // Solo se guest trovato
  },
  {
    id: 'snooze-checkin',
    label: 'Snooze until Check-in',
    icon: Clock,
    shortcut: 'Z',
    action: () => handleSnoozeCheckin(email),
    disabled: !email.linkedBooking || !email.futureCheckin,
  },
];
```

### Styling (Tailwind)

```typescript
// ContextMenuItem.tsx
const variantStyles = {
  default: 'hover:bg-indigo-50 hover:text-indigo-900',
  hotel: 'hover:bg-amber-50 hover:text-amber-900', // Gold!
  danger: 'hover:bg-red-50 hover:text-red-900',
};

return (
  <button
    className={cn(
      'w-full flex items-center gap-3 px-4 py-2',
      'text-sm font-medium text-gray-900',
      'transition-colors duration-150',
      variantStyles[variant],
      disabled && 'opacity-50 cursor-not-allowed'
    )}
    onClick={handleClick}
    disabled={disabled}
  >
    <Icon className="w-4 h-4" />
    <span className="flex-1 text-left">{label}</span>
    {shortcut && (
      <kbd className="text-xs text-gray-500">{shortcut}</kbd>
    )}
  </button>
);
```

### Position Logic

```typescript
// useContextMenu.ts
const calculatePosition = (
  clickX: number,
  clickY: number,
  menuWidth: number = 280,
  menuHeight: number = 400
) => {
  const viewportWidth = window.innerWidth;
  const viewportHeight = window.innerHeight;

  // Default: 10px offset da cursor
  let x = clickX + 10;
  let y = clickY + 10;

  // Flip left se overflow right
  if (x + menuWidth > viewportWidth) {
    x = clickX - menuWidth - 10;
  }

  // Flip up se overflow bottom
  if (y + menuHeight > viewportHeight) {
    y = clickY - menuHeight - 10;
  }

  // Clamp to viewport (safety)
  x = Math.max(10, Math.min(x, viewportWidth - menuWidth - 10));
  y = Math.max(10, Math.min(y, viewportHeight - menuHeight - 10));

  return { x, y };
};
```

### API Calls

```typescript
// Hotel-specific actions API

// Link to Booking
const handleLinkBooking = async (email: Email) => {
  const bookingId = await showBookingSearchModal(email);
  if (!bookingId) return;

  await api.linkEmailToBooking(email.id, bookingId);
  toast.success('Email linked to booking #' + bookingId);
};

// Create Booking Note
const handleCreateNote = async (email: Email) => {
  const note = await showNoteInputModal(email);
  if (!note) return;

  await api.createBookingNote(email.linkedBooking!, {
    content: note,
    source: 'email',
    emailId: email.id,
  });
  toast.success('Note added to booking');
};

// View Guest Profile
const handleGuestProfile = (email: Email) => {
  // Trigger existing GuestSidebar
  openGuestSidebar(email.guestMatch!);
};

// Snooze until Check-in
const handleSnoozeCheckin = async (email: Email) => {
  const checkinDate = email.linkedBooking!.checkinDate;
  const snoozeUntil = setHours(checkinDate, 7); // 7am check-in day

  await api.snoozeEmail(email.id, snoozeUntil);
  toast.success('Email snoozed until check-in day');
};
```

---

## 12. TESTING SCENARIOS

### Unit Tests

```typescript
describe('EmailContextMenu', () => {
  it('renders quick actions for all emails', () => {
    // Reply, Forward, Archive, Star sempre presenti
  });

  it('shows "Mark as Read" for unread emails', () => {
    // Conditional label
  });

  it('shows hotel actions only if guest match found', () => {
    // Link Booking, Guest Profile conditional
  });

  it('disables Create Note if no linked booking', () => {
    // Disabled state
  });

  it('positions menu near cursor with flip logic', () => {
    // Position calculation
  });

  it('closes menu on outside click', () => {
    // Click away behavior
  });

  it('executes action and closes menu', () => {
    // Click item → action → close
  });
});
```

### E2E Tests (Playwright)

```typescript
test('Context menu workflow - Quick actions', async ({ page }) => {
  // 1. Right click email
  await page.locator('[data-email-id="123"]').click({ button: 'right' });

  // 2. Verify menu appears
  await expect(page.locator('[data-testid="context-menu"]')).toBeVisible();

  // 3. Click Archive
  await page.click('text=Archive');

  // 4. Verify email archived
  await expect(page.locator('[data-email-id="123"]')).toBeHidden();
});

test('Context menu workflow - Hotel action', async ({ page }) => {
  // 1. Right click guest email
  await page.locator('[data-email-id="456"]').click({ button: 'right' });

  // 2. Click Link to Booking
  await page.click('text=Link to Booking');

  // 3. Verify modal appears
  await expect(page.locator('[data-testid="booking-search-modal"]')).toBeVisible();

  // 4. Select booking
  await page.click('text=Booking #12345');

  // 5. Verify link created
  await expect(page.locator('[data-email-id="456"] [data-testid="booking-badge"]')).toBeVisible();
});
```

### User Testing Script

```
SCENARIO: Morning Triage con Context Menu

1. Setup: 10 email in inbox (mix VIP, team, regular)

2. Task: "Organize your inbox usando right-click"

3. Osserva:
   - Scopre context menu da solo? O serve hint?
   - Capisce grouping (quick vs organize vs hotel)?
   - Hotel actions sono chiari? O confusion?
   - Usa shortcuts dopo aver visto menu?

4. Chiedi:
   - "Quale azione hai usato più spesso?"
   - "C'era qualcosa che ti aspettavi ma non c'era?"
   - "Qualcosa ti è sembrato fuori posto?"
   - "Preferisci menu o keyboard shortcuts? Perché?"

5. Metrics:
   - Time to complete triage
   - % azioni via context menu vs toolbar
   - Errori (click wrong item)
   - Satisfaction (1-5)
```

---

## 13. DOCUMENTATION - User-Facing

### Cheat Sheet (Printable)

```
┌────────────────────────────────────────────────┐
│  MIRACOLLOOK - CONTEXT MENU QUICK REFERENCE    │
├────────────────────────────────────────────────┤
│  RIGHT-CLICK su qualsiasi email per:           │
│                                                 │
│  QUICK ACTIONS:                                │
│  ↩️  Reply                               R     │
│  ⤴️  Forward                             F     │
│  📦 Archive                              E     │
│  ⭐ Star / Unstar                        S     │
│                                                 │
│  ORGANIZE:                                     │
│  🏷️  Add Label                           L     │
│  📁 Move to Folder                       V     │
│  👥 Assign to Team                       A     │
│  ✉️  Mark Read / Unread                  U     │
│                                                 │
│  HOTEL ACTIONS (for guest emails):             │
│  🔗 Link to Booking                     ⌘B     │
│  📝 Create Booking Note                 ⌘N     │
│  👁️  View Guest Profile                 ⌘G     │
│  ⏰ Snooze until Check-in                Z     │
│                                                 │
│  TIP: Keyboard shortcuts anche più veloci!    │
└────────────────────────────────────────────────┘
```

### In-App Tooltip

```
[First right-click]
┌─────────────────────────────────────┐
│ 💡 TIP: Right-Click Menu            │
│                                     │
│ Hai scoperto il context menu!      │
│ Usa right-click per azioni veloci. │
│                                     │
│ Opzioni speciali per email ospiti: │
│ • Link to Booking                   │
│ • Create Note                       │
│ • View Guest Profile                │
│                                     │
│ [Don't show again]     [Got it! ✓]  │
└─────────────────────────────────────┘
```

---

## 14. ROLLOUT PLAN

### Phase 1: Internal Beta (1 settimana)

```
TARGET: Rafa + 2-3 test users

FEATURES:
- Menu base (Gruppo 1 + 2)
- NO hotel actions yet (test standard first)

GOAL:
- Validate position logic
- Validate item ordering
- Fix UI bugs
- Measure usage rate

SUCCESS:
- No crashes
- 30%+ actions via context menu
- Users find it intuitive
```

### Phase 2: Hotel Actions (1 settimana)

```
TARGET: Same users + 2 receptionists

FEATURES:
- Add Gruppo 3 (hotel actions)
- Link to Booking (real PMS)
- Guest Profile integration

GOAL:
- Validate PMS API performance
- Test hotel-specific value
- Collect qualitative feedback

SUCCESS:
- Hotel actions used 10%+ of time
- "This is useful!" feedback
- < 2s PMS lookup
```

### Phase 3: Full Rollout (2 settimane)

```
TARGET: All Miracollook users

FEATURES:
- Complete menu
- Context-aware variations
- All keyboard shortcuts
- Onboarding tooltip

GOAL:
- Scale to production
- Monitor performance/errors
- Iterate based on analytics

SUCCESS:
- 40%+ usage rate
- < 0.1% error rate
- 4.0+ satisfaction score
```

---

## CONCLUSION - The Big Picture

**Il context menu NON è "nice to have". È CORE UX.**

### Perché è Importante

```
1. DISCOVERERABILITY
   → Users scoprono features right-click
   → Alternative a keyboard (accessibility)

2. EFFICIENCY
   → 1 right-click vs 3 click toolbar
   → Muscle memory develops

3. DIFFERENTIATION
   → Hotel actions = NESSUN competitor ha
   → PMS integration shines qui!

4. PROGRESSIVE DISCLOSURE
   → Menu educa su shortcuts
   → Users graduano a power user
```

### Success Vision

**3 mesi:**
- Laura usa context menu daily
- "Link to Booking" è azione top 5
- Keyboard adoption grows 20%

**6 mesi:**
- Case study: "40% faster triage con context menu"
- Users request more hotel actions
- Competitor notice e provano copiare

**12 mesi:**
- Context menu = signature Miracollook feature
- Industry: "Email client fatto right per hotel"
- New users: "Wow, posso linkare booking da email!"

### Competitive Advantage

```
Gmail:    Menu generico
Outlook:  Menu generico
Superhuman: Menu minimo (keyboard-first)
Front:    Menu team (no hotel)

MIRACOLLOOK: Menu hotel-smart con PMS integration!

MOAT = Context + Speed + Hotel Actions
```

**Sono pronta a guidare l'implementazione!** ✨

---

## APPENDIX - Research Sources

### UX Best Practices
- [Designing Effective Contextual Menus: 10 Guidelines - NN/G](https://www.nngroup.com/articles/contextual-menus-guidelines/)
- [Context Menu UI Design: Best practices - Mobbin](https://mobbin.com/glossary/context-menu)
- [Building like it's 1984: Guide to context menus - Height](https://height.app/blog/guide-to-build-context-menus)
- [Contextual Menus: Delivering Relevant Tools - NN/G](https://www.nngroup.com/articles/contextual-menus/)

### Email Client Research
- [Gmail Right-Click Context Menu Options - Google Workspace](https://workspaceupdates.googleblog.com/2019/02/easily-take-action-in-gmail-with-new-right-click-menu.html)
- [Gmail's Right-Click Menu Opens Possibilities - Shift Blog](https://shift.com/guides/google-workspace/gmails-right-clicking-menu-opens-possibilities/)
- [New right-click menu options in Gmail - U-M ITS](https://its.umich.edu/communication/collaboration/google/update/new-right-click-menu-options-gmail)

### Hotel Workflow Research
- [Hotel Guest Messaging Systems: Practical Guide - Visito](https://www.visitoai.com/en/blog/hotel-guest-messaging-systems-a-practical-guide)
- [Hotel Front Desk Software: Functionality - AltexSoft](https://www.altexsoft.com/blog/hotel-front-desk-software/)
- [Top 7 AI Tools for Hotel PMS Integration - DialZara](https://dialzara.com/blog/top-7-ai-tools-for-hotel-pms-integration)

---

**Document Status:** COMPLETE & READY FOR IMPLEMENTATION
**Next Action:** Review con Rafa → Frontend implementation → User testing

*"I dettagli fanno SEMPRE la differenza!"* ✨

---

*Cervella Marketing - UX Strategy Lead*
*CervellaSwarm Family*
*14 Gennaio 2026*
