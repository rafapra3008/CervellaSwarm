# RICERCA: Checkbox nei Gruppi Email - Miracallook

**Data:** 2026-01-16
**Ricercatrice:** Cervella Researcher
**Progetto:** Miracallook
**Status:** ✅ COMPLETATA

---

## DOMANDE DA RISPONDERE

1. Come sono strutturati i gruppi di email? (componenti)
2. Dove viene gestita la lista email?
3. Come funziona la selezione checkbox attuale?
4. Perché i checkbox non appaiono nei gruppi?

---

## 1. STRUTTURA GRUPPI EMAIL

### Componenti Coinvolti

```
EmailList.tsx (componente principale)
  ├── crea bundles tramite createBundles()
  ├── renderizza BundleItem per i gruppi
  └── renderizza EmailListItem per email singole

BundleItem.tsx (componente gruppo)
  ├── Header collassabile (nome + icona + counter)
  └── Lista EmailListItem (quando espanso)

bundles.ts (logica raggruppamento)
  └── createBundles() -> (Email | EmailBundle)[]
```

### File e Linee Rilevanti

| File | Linee | Cosa Fa |
|------|-------|---------|
| `EmailList.tsx` | 46-47 | Crea bundles: `createBundles(filteredEmails)` |
| `EmailList.tsx` | 172-178 | Renderizza BundleItem per gruppi |
| `EmailList.tsx` | 180-189 | Renderizza EmailListItem normali (con checkbox) |
| `BundleItem.tsx` | 36-53 | Header gruppo (NESSUN CHECKBOX!) |
| `BundleItem.tsx` | 56-66 | Lista email nel gruppo (delega a EmailListItem) |
| `bundles.ts` | 35-106 | Logica raggruppamento per pattern |

---

## 2. GESTIONE LISTA EMAIL

### Flusso Dati

```
App.tsx
  └── useSelection() hook (selectedIds, toggle, selectAll, etc)
      └── passa props a EmailList
          └── EmailList passa props a EmailListItem
              └── EmailListItem renderizza checkbox SE onCheckChange presente
```

### Props Checkbox (EmailList → EmailListItem)

```tsx
// EmailList.tsx (righe 180-189)
<EmailListItem
  key={item.id}
  email={item}
  isSelected={item.id === selectedEmailId}
  onClick={() => onSelectEmail(item)}
  onContextMenu={onContextMenu}
  isChecked={selectedIds.has(item.id)}              // ✅ PASSA checkbox state
  onCheckChange={onToggleSelection ? () => onToggleSelection(item.id) : undefined}  // ✅ PASSA handler
  onShiftClick={onSelectRange ? () => onSelectRange(item.id, allEmailIds) : undefined}
/>
```

### Hook useSelection (hooks/useSelection.ts)

Gestisce:
- `selectedIds: Set<string>` - IDs email selezionate
- `toggle(id)` - Toggle singola email
- `selectAll(ids)` - Seleziona tutte
- `clearSelection()` - Deseleziona tutte
- `selectRange(endId, allIds)` - Shift+click range

---

## 3. COME FUNZIONA SELEZIONE ATTUALE

### EmailListItem.tsx

**Checkbox Rendering (righe 68-87):**
```tsx
{onCheckChange && (  // ✅ Checkbox appare SOLO se onCheckChange esiste
  <div
    role="checkbox"
    aria-checked={isChecked}
    tabIndex={0}
    onClick={handleCheckboxClick}
    onKeyDown={handleCheckboxKeyDown}
    className={...}
  >
    {isChecked && (
      <svg>...</svg>  // Checkmark icon
    )}
  </div>
)}
```

**Handler (righe 39-46):**
```tsx
const handleCheckboxClick = (e: React.MouseEvent) => {
  e.stopPropagation();  // Previene click su email
  if (e.shiftKey && onShiftClick) {
    onShiftClick();  // Range selection
  } else {
    onCheckChange?.(!isChecked);  // Toggle singolo
  }
};
```

### Master Checkbox (EmailList.tsx)

**Header con Select All (righe 99-125):**
- Stati: `'none'` | `'some'` | `'all'`
- Icona: CheckIcon (all), MinusIcon (some), nessuna (none)
- Click: toggle tra select all / deselect all

---

## 4. PERCHÉ CHECKBOX NON APPAIONO NEI GRUPPI

### IL PROBLEMA - 3 CAUSE

#### CAUSA #1: BundleItem NON Riceve Props Checkbox

**EmailList.tsx (righe 173-178):**
```tsx
<BundleItem
  key={item.id}
  bundle={item}
  selectedEmailId={selectedEmailId}
  onSelectEmail={onSelectEmail}
  // ❌ MANCA: selectedIds
  // ❌ MANCA: onToggleSelection
  // ❌ MANCA: onSelectRange
/>
```

**EmailListItem riceve invece (righe 180-189):**
```tsx
<EmailListItem
  ...
  isChecked={selectedIds.has(item.id)}  // ✅ PRESENTE
  onCheckChange={...}                   // ✅ PRESENTE
  onShiftClick={...}                    // ✅ PRESENTE
/>
```

#### CAUSA #2: BundleItem NON Passa Props alle Email Interne

**BundleItem.tsx (righe 58-65):**
```tsx
{bundle.emails.map((email) => (
  <EmailListItem
    key={email.id}
    email={email}
    isSelected={email.id === selectedEmailId}
    onClick={() => onSelectEmail(email)}
    // ❌ MANCA: isChecked
    // ❌ MANCA: onCheckChange
    // ❌ MANCA: onShiftClick
  />
))}
```

#### CAUSA #3: BundleItem Props Interface Incompleta

**BundleItem.tsx (righe 5-9):**
```tsx
interface BundleItemProps {
  bundle: EmailBundle;
  selectedEmailId: string | null;
  onSelectEmail: (email: Email) => void;
  // ❌ MANCA: selectedIds: Set<string>
  // ❌ MANCA: onToggleSelection
  // ❌ MANCA: onSelectRange
}
```

---

## SOLUZIONE PROPOSTA

### Step 1: Aggiornare BundleItemProps

```tsx
interface BundleItemProps {
  bundle: EmailBundle;
  selectedEmailId: string | null;
  onSelectEmail: (email: Email) => void;
  // ✅ AGGIUNGI:
  selectedIds?: Set<string>;
  onToggleSelection?: (id: string) => void;
  onSelectRange?: (endId: string, allIds: string[]) => void;
}
```

### Step 2: Passare Props da EmailList a BundleItem

```tsx
// EmailList.tsx (righe 173-178)
<BundleItem
  key={item.id}
  bundle={item}
  selectedEmailId={selectedEmailId}
  onSelectEmail={onSelectEmail}
  // ✅ AGGIUNGI:
  selectedIds={selectedIds}
  onToggleSelection={onToggleSelection}
  onSelectRange={onSelectRange}
/>
```

### Step 3: BundleItem Passa Props alle Email Interne

```tsx
// BundleItem.tsx (righe 58-65)
{bundle.emails.map((email) => (
  <EmailListItem
    key={email.id}
    email={email}
    isSelected={email.id === selectedEmailId}
    onClick={() => onSelectEmail(email)}
    // ✅ AGGIUNGI:
    isChecked={selectedIds?.has(email.id)}
    onCheckChange={onToggleSelection ? () => onToggleSelection(email.id) : undefined}
    onShiftClick={onSelectRange ? () => onSelectRange(email.id, allEmailIds) : undefined}
  />
))}
```

**NOTA:** Serve `allEmailIds` array! Deve essere costruito da `bundle.emails.map(e => e.id)`.

### Step 4: (Opzionale) Checkbox sul Bundle Header

Se vogliamo checkbox "select all emails in bundle":

```tsx
// BundleItem.tsx - nel header (dopo icona)
const allBundleIds = bundle.emails.map(e => e.id);
const allSelected = allBundleIds.every(id => selectedIds?.has(id));
const someSelected = allBundleIds.some(id => selectedIds?.has(id)) && !allSelected;

<div
  role="checkbox"
  aria-checked={allSelected ? true : someSelected ? 'mixed' : false}
  onClick={() => {
    if (allSelected) {
      allBundleIds.forEach(id => onToggleSelection?.(id));  // Deselect all
    } else {
      allBundleIds.forEach(id => !selectedIds?.has(id) && onToggleSelection?.(id));  // Select all
    }
  }}
  className={...}
>
  {/* Icon: CheckIcon | MinusIcon | null */}
</div>
```

---

## FILE DA MODIFICARE

| File | Modifiche Necessarie | Righe Interessate |
|------|---------------------|-------------------|
| `BundleItem.tsx` | Interface + props passing | 5-9, 58-65 |
| `EmailList.tsx` | Passare props a BundleItem | 173-178 |

**IMPATTO:** Minimo. Solo 2 file, modifiche locali.

**RISCHIO:** Basso. Non cambia logica esistente, solo estende props.

---

## VERIFICA POST-FIX

Dopo implementazione, verificare:

1. ✅ Checkbox appaiono nelle email dentro i bundle espansi
2. ✅ Click su checkbox seleziona/deseleziona email
3. ✅ Shift+click funziona per range anche dentro bundle
4. ✅ Master checkbox include email nei bundle nel count
5. ✅ BulkActionsBar funziona con email selezionate nei bundle
6. ✅ Collapse/expand bundle NON deseleziona email

---

## FONTI

- `miracollogeminifocus/miracallook/frontend/src/components/EmailList/BundleItem.tsx`
- `miracollogeminifocus/miracallook/frontend/src/components/EmailList/EmailList.tsx`
- `miracollogeminifocus/miracallook/frontend/src/components/EmailList/EmailListItem.tsx`
- `miracollogeminifocus/miracallook/frontend/src/hooks/useSelection.ts`
- `miracollogeminifocus/miracallook/frontend/src/utils/bundles.ts`
- `miracollogeminifocus/miracallook/frontend/src/types/email.ts`

---

## NEXT STEP

**HANDOFF A:** Frontend Worker
**TASK:** Implementare fix checkbox in BundleItem
**FILES:** 2 (BundleItem.tsx, EmailList.tsx)
**EFFORT:** 15-30 minuti
**TESTING:** Manuale + verifica checklist sopra

---

*"Nulla è complesso - solo non ancora studiato!"*
*Ricerca completata con calma e precisione.*
