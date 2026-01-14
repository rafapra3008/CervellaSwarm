# Ricerca Mark Read/Unread - Miracollook

**Data**: 2026-01-14
**Ricercatrice**: Cervella Researcher
**Obiettivo**: Implementare funzionalità Mark as Read/Unread in Miracollook

---

## BACKEND - Gmail API

### Endpoint per Email Actions Esistenti

**File**: `backend/gmail/api.py`

Endpoint attivi:
- `/gmail/archive` (POST) - Rimuove label INBOX
- `/gmail/trash` (POST) - Sposta in cestino
- `/gmail/star` (POST) - Aggiunge label STARRED
- `/gmail/unstar` (POST) - Rimuove label STARRED
- `/gmail/snooze` (POST) - Aggiunge label SNOOZED e rimuove INBOX

### Pattern Implementativo Backend

Tutti gli endpoint seguono lo stesso pattern (esempio `/archive`):

```python
@router.post("/archive")
async def archive_email(
    message_id: str = Body(..., description="ID messaggio", embed=True)
):
    service = get_gmail_service()

    try:
        # Modifica labels
        service.users().messages().modify(
            userId="me",
            id=message_id,
            body={"removeLabelIds": ["INBOX"]}
        ).execute()

        logger.info(f"Email archiviata: {message_id}")

        return {
            "status": "archived",
            "message_id": message_id
        }

    except HttpError as error:
        # Error handling...
```

### Gmail API - Label UNREAD

In Gmail API:
- **UNREAD** è un LABEL (come INBOX, STARRED, TRASH)
- **Mark as Read** = RIMUOVERE label UNREAD
- **Mark as Unread** = AGGIUNGERE label UNREAD

Gmail API call:
```python
# Mark as Read
service.users().messages().modify(
    userId="me",
    id=message_id,
    body={"removeLabelIds": ["UNREAD"]}
).execute()

# Mark as Unread
service.users().messages().modify(
    userId="me",
    id=message_id,
    body={"addLabelIds": ["UNREAD"]}
).execute()
```

### Dove Aggiungere Endpoint Backend

**Posizione consigliata**: Dopo gli endpoint Quick Actions (linea ~1703)

Aggiungere:
1. `/gmail/mark-read` (POST) - Rimuove label UNREAD
2. `/gmail/mark-unread` (POST) - Aggiunge label UNREAD

---

## FRONTEND - React/TypeScript

### Hook useEmails - Pattern Optimistic Update

**File**: `frontend/src/hooks/useEmails.ts`

Pattern esistente per `useArchiveEmail` (linee 148-178):

```typescript
export const useArchiveEmail = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (messageId: string) => emailApi.archiveEmail(messageId),

    // Optimistic update: rimuove subito dalla lista
    onMutate: async (messageId) => {
      await queryClient.cancelQueries({ queryKey: ['emails'] });
      const previousEmails = queryClient.getQueryData<Email[]>(['emails']);

      // Aggiorna cache ottimisticamente
      queryClient.setQueryData<Email[]>(['emails'], (old) =>
        old?.filter((e) => e.id !== messageId)
      );

      // Rimuove anche da IndexedDB
      deleteCachedEmail(messageId).catch(console.warn);

      return { previousEmails };
    },

    onError: (_err, _messageId, context) => {
      // Rollback se errore
      if (context?.previousEmails) {
        queryClient.setQueryData(['emails'], context.previousEmails);
      }
    },

    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['emails'] });
    },
  });
};
```

**DIFFERENZA per Mark Read/Unread**:
- Archive/Trash RIMUOVONO email dalla lista
- Mark Read/Unread MODIFICANO flag `isUnread` SENZA rimuovere

### Pattern Optimistic Update per Mark Read

```typescript
export const useMarkReadEmail = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (messageId: string) => emailApi.markRead(messageId),

    onMutate: async (messageId) => {
      await queryClient.cancelQueries({ queryKey: ['emails'] });
      const previousEmails = queryClient.getQueryData<Email[]>(['emails']);

      // Aggiorna isUnread ottimisticamente
      queryClient.setQueryData<Email[]>(['emails'], (old) =>
        old?.map((e) =>
          e.id === messageId
            ? { ...e, isUnread: false }
            : e
        )
      );

      return { previousEmails };
    },

    onError: (_err, _messageId, context) => {
      // Rollback
      if (context?.previousEmails) {
        queryClient.setQueryData(['emails'], context.previousEmails);
      }
    },

    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['emails'] });
    },
  });
};
```

### API Service - Dove Aggiungere

**File**: `frontend/src/services/api.ts`

Dopo gli endpoint Quick Actions (linea ~79):

```typescript
markRead: async (messageId: string): Promise<void> => {
  await api.post('/gmail/mark-read', { message_id: messageId });
},

markUnread: async (messageId: string): Promise<void> => {
  await api.post('/gmail/mark-unread', { message_id: messageId });
},
```

### Componenti UI - Dove Aggiungere

**1. EmailDetail - Action Button**

**File**: `frontend/src/components/EmailDetail/EmailDetail.tsx`

Aggiungere button nella toolbar (linee 58-90):

```typescript
<button
  onClick={onMarkRead}  // o onMarkUnread
  className="px-4 py-2 bg-miracollo-bg-card hover:bg-miracollo-bg-hover text-miracollo-text rounded-miracollo-sm transition-fast"
  title="Mark as Read/Unread (U)"
>
  {email.isUnread ? 'Mark Read' : 'Mark Unread'}
</button>
```

**2. EmailListItem - Keyboard Shortcut**

**File**: `frontend/src/components/EmailList/EmailListItem.tsx`

Il componente già visualizza lo stato unread (linee 69-71):

```typescript
{email.isUnread && (
  <span className="w-2 h-2 rounded-full bg-miracollo-accent mr-2 flex-shrink-0" />
)}
```

La UI si aggiornerà automaticamente grazie all'optimistic update!

**3. App.tsx - Handler**

**File**: `frontend/src/App.tsx`

Aggiungere handler (pattern esistente linee 169-182):

```typescript
const handleMarkRead = async () => {
  if (selectedEmail) {
    try {
      await markReadEmail.mutateAsync(selectedEmail.id);
      setActionFeedback({ message: 'Marked as read!', type: 'success' });
      setTimeout(() => setActionFeedback(null), 2000);
    } catch (error) {
      console.error('Mark read failed:', error);
      setActionFeedback({ message: 'Mark read failed', type: 'error' });
      setTimeout(() => setActionFeedback(null), 2000);
    }
  }
};
```

### Keyboard Shortcuts

**File**: `frontend/src/hooks/useKeyboardShortcuts.ts`

Aggiungere shortcut (pattern esistente):
- `U` = Toggle Read/Unread (standard Gmail)

---

## GMAIL API - Documentazione

### Endpoint Gmail da Usare

**API**: `users.messages.modify`

**Docs**: https://developers.google.com/gmail/api/reference/rest/v1/users.messages/modify

**Request**:
```json
POST /gmail/v1/users/me/messages/{messageId}/modify
{
  "addLabelIds": ["UNREAD"],     // Mark as Unread
  "removeLabelIds": ["UNREAD"]   // Mark as Read
}
```

**Response**:
```json
{
  "id": "string",
  "threadId": "string",
  "labelIds": ["INBOX", "UNREAD", ...],
  ...
}
```

### Note Importanti

1. **UNREAD è un label**, NON un campo booleano
2. La modifica è **atomica** - una sola chiamata API
3. Gmail API **NON richiede scope aggiuntivi** (già autorizzato con `gmail.modify`)

---

## PIANO IMPLEMENTAZIONE

### Step 1: Backend Endpoints

**File**: `backend/gmail/api.py`

Aggiungere dopo `/snooze` (linea ~1775):

```python
@router.post("/mark-read")
async def mark_read_email(
    message_id: str = Body(..., description="ID messaggio da marcare come letto", embed=True)
):
    """
    Marca email come letta (rimuove label UNREAD).

    Esempio:
    ```
    POST /gmail/mark-read
    {
        "message_id": "18d1234567890abc"
    }
    ```
    """
    service = get_gmail_service()

    try:
        # Rimuovi label UNREAD
        service.users().messages().modify(
            userId="me",
            id=message_id,
            body={"removeLabelIds": ["UNREAD"]}
        ).execute()

        logger.info(f"Email marcata come letta: {message_id}")

        return {
            "status": "read",
            "message_id": message_id
        }

    except HttpError as error:
        logger.error(f"Errore mark read email: {error}")
        if error.resp.status == 404:
            raise HTTPException(status_code=404, detail="Messaggio non trovato")
        elif error.resp.status == 401:
            raise HTTPException(status_code=401, detail="Token scaduto. Rifare login.")
        else:
            raise HTTPException(status_code=500, detail=f"Errore Gmail API: {str(error)}")


@router.post("/mark-unread")
async def mark_unread_email(
    message_id: str = Body(..., description="ID messaggio da marcare come non letto", embed=True)
):
    """
    Marca email come non letta (aggiunge label UNREAD).

    Esempio:
    ```
    POST /gmail/mark-unread
    {
        "message_id": "18d1234567890abc"
    }
    ```
    """
    service = get_gmail_service()

    try:
        # Aggiungi label UNREAD
        service.users().messages().modify(
            userId="me",
            id=message_id,
            body={"addLabelIds": ["UNREAD"]}
        ).execute()

        logger.info(f"Email marcata come non letta: {message_id}")

        return {
            "status": "unread",
            "message_id": message_id
        }

    except HttpError as error:
        logger.error(f"Errore mark unread email: {error}")
        if error.resp.status == 404:
            raise HTTPException(status_code=404, detail="Messaggio non trovato")
        elif error.resp.status == 401:
            raise HTTPException(status_code=401, detail="Token scaduto. Rifare login.")
        else:
            raise HTTPException(status_code=500, detail=f"Errore Gmail API: {str(error)}")
```

**Testing**:
```bash
# Test con curl
curl -X POST http://localhost:8002/gmail/mark-read \
  -H "Content-Type: application/json" \
  -d '{"message_id": "TEST_ID"}'
```

---

### Step 2: Frontend API Service

**File**: `frontend/src/services/api.ts`

Aggiungere dopo `snoozeEmail` (linea ~79):

```typescript
markRead: async (messageId: string): Promise<void> => {
  await api.post('/gmail/mark-read', { message_id: messageId });
},

markUnread: async (messageId: string): Promise<void> => {
  await api.post('/gmail/mark-unread', { message_id: messageId });
},
```

---

### Step 3: Frontend Hooks

**File**: `frontend/src/hooks/useEmails.ts`

Aggiungere dopo `useSnoozeEmail` (linea ~242):

```typescript
export const useMarkReadEmail = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (messageId: string) => emailApi.markRead(messageId),

    // Optimistic update: cambia isUnread subito
    onMutate: async (messageId) => {
      await queryClient.cancelQueries({ queryKey: ['emails'] });
      const previousEmails = queryClient.getQueryData<Email[]>(['emails']);

      // Aggiorna isUnread ottimisticamente
      queryClient.setQueryData<Email[]>(['emails'], (old) =>
        old?.map((e) =>
          e.id === messageId
            ? { ...e, isUnread: false }
            : e
        )
      );

      return { previousEmails };
    },

    onError: (_err, _messageId, context) => {
      // Rollback se errore
      if (context?.previousEmails) {
        queryClient.setQueryData(['emails'], context.previousEmails);
      }
    },

    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['emails'] });
    },
  });
};

export const useMarkUnreadEmail = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (messageId: string) => emailApi.markUnread(messageId),

    // Optimistic update: cambia isUnread subito
    onMutate: async (messageId) => {
      await queryClient.cancelQueries({ queryKey: ['emails'] });
      const previousEmails = queryClient.getQueryData<Email[]>(['emails']);

      // Aggiorna isUnread ottimisticamente
      queryClient.setQueryData<Email[]>(['emails'], (old) =>
        old?.map((e) =>
          e.id === messageId
            ? { ...e, isUnread: true }
            : e
        )
      );

      return { previousEmails };
    },

    onError: (_err, _messageId, context) => {
      // Rollback se errore
      if (context?.previousEmails) {
        queryClient.setQueryData(['emails'], context.previousEmails);
      }
    },

    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['emails'] });
    },
  });
};
```

---

### Step 4: Frontend UI - EmailDetail

**File**: `frontend/src/components/EmailDetail/EmailDetail.tsx`

Modificare interfaccia props (linea 4):

```typescript
interface EmailDetailProps {
  email: Email | null;
  onReply?: () => void;
  onForward?: () => void;
  onArchive?: () => void;
  onMarkRead?: () => void;      // NUOVO
  onMarkUnread?: () => void;    // NUOVO
}
```

Aggiungere button nella toolbar (dopo Archive button, linea ~89):

```typescript
{email && (
  <button
    onClick={email.isUnread ? onMarkRead : onMarkUnread}
    className="px-4 py-2 bg-miracollo-bg-card hover:bg-miracollo-bg-hover text-miracollo-text rounded-miracollo-sm transition-fast flex items-center gap-2"
    title={email.isUnread ? "Mark as Read (U)" : "Mark as Unread (U)"}
  >
    <span>{email.isUnread ? 'Mark Read' : 'Mark Unread'}</span>
    <span className="text-xs text-miracollo-text-muted ml-1 opacity-60">(U)</span>
  </button>
)}
```

---

### Step 5: Frontend UI - App.tsx

**File**: `frontend/src/App.tsx`

**Import hook** (linea 16):

```typescript
import {
  useEmails,
  useSearchEmails,
  useArchiveEmail,
  useTrashEmail,
  useStarEmail,
  useSnoozeEmail,
  useMarkReadEmail,    // NUOVO
  useMarkUnreadEmail,  // NUOVO
  useArchivedEmails,
  useStarredEmails,
  useSnoozedEmails,
  useTrashEmails
} from './hooks/useEmails';
```

**Inizializza hooks** (dopo linea 59):

```typescript
const markReadEmail = useMarkReadEmail();
const markUnreadEmail = useMarkUnreadEmail();
```

**Handler** (dopo `handleDelete`, linea ~200):

```typescript
const handleMarkRead = async () => {
  if (selectedEmail) {
    try {
      await markReadEmail.mutateAsync(selectedEmail.id);
      setActionFeedback({ message: 'Marked as read!', type: 'success' });
      setTimeout(() => setActionFeedback(null), 2000);
    } catch (error) {
      console.error('Mark read failed:', error);
      setActionFeedback({ message: 'Mark read failed', type: 'error' });
      setTimeout(() => setActionFeedback(null), 2000);
    }
  }
};

const handleMarkUnread = async () => {
  if (selectedEmail) {
    try {
      await markUnreadEmail.mutateAsync(selectedEmail.id);
      setActionFeedback({ message: 'Marked as unread!', type: 'success' });
      setTimeout(() => setActionFeedback(null), 2000);
    } catch (error) {
      console.error('Mark unread failed:', error);
      setActionFeedback({ message: 'Mark unread failed', type: 'error' });
      setTimeout(() => setActionFeedback(null), 2000);
    }
  }
};
```

**Passa props a EmailDetail** (linea ~320):

```typescript
<EmailDetail
  email={selectedEmail}
  onReply={handleReply}
  onForward={handleForward}
  onArchive={handleArchive}
  onMarkRead={handleMarkRead}      // NUOVO
  onMarkUnread={handleMarkUnread}  // NUOVO
/>
```

---

### Step 6: Keyboard Shortcuts

**File**: `frontend/src/hooks/useKeyboardShortcuts.ts`

Aggiungere nella interfaccia e handler:

```typescript
interface KeyboardShortcutsProps {
  // ... existing props
  onMarkRead?: () => void;
  onMarkUnread?: () => void;
}

// Nel useEffect, aggiungere:
case 'u':
  if (selectedIndex >= 0 && selectedIndex < emails.length) {
    const email = emails[selectedIndex];
    if (email.isUnread) {
      onMarkRead?.();
    } else {
      onMarkUnread?.();
    }
  }
  break;
```

---

## SUMMARY - COSA CAMBIARE

### Backend (1 file)
- `backend/gmail/api.py` - Aggiungere 2 endpoint: `/mark-read` e `/mark-unread`

### Frontend (5 file)
1. `frontend/src/services/api.ts` - Aggiungere 2 metodi API
2. `frontend/src/hooks/useEmails.ts` - Aggiungere 2 hooks con optimistic update
3. `frontend/src/components/EmailDetail/EmailDetail.tsx` - Aggiungere button UI
4. `frontend/src/App.tsx` - Aggiungere handlers e collegare
5. `frontend/src/hooks/useKeyboardShortcuts.ts` - Aggiungere shortcut `U`

### Testing
1. Backend: `curl -X POST .../mark-read`
2. Frontend: Click button in EmailDetail
3. Optimistic: Verificare che UI si aggiorni PRIMA della risposta API
4. Error handling: Simulare errore e verificare rollback
5. Keyboard: Premere `U` con email selezionata

---

## NOTE TECNICHE

### Optimistic Update - Come Funziona

1. **onMutate**: Esegue PRIMA della chiamata API
   - Cancella query in corso
   - Salva stato precedente
   - Aggiorna cache con nuovo valore
   - UI si aggiorna ISTANTANEAMENTE

2. **mutationFn**: Chiama API in background

3. **onError**: Se API fallisce
   - Ripristina stato precedente
   - UI torna allo stato originale

4. **onSettled**: Sempre alla fine
   - Invalida query per refresh da server
   - Garantisce sincronizzazione finale

### Differenza Archive vs Mark Read

| Azione | Effetto UI | Optimistic Update |
|--------|-----------|-------------------|
| **Archive** | Rimuove dalla lista | `old?.filter((e) => e.id !== messageId)` |
| **Mark Read** | Cambia visual (pallino) | `old?.map((e) => e.id === messageId ? {...e, isUnread: false} : e)` |

### Performance

- **Mark Read/Unread** è PIÙ VELOCE di Archive/Trash
- Modifica solo 1 flag, non sposta email
- Optimistic update garantisce UX istantanea
- IndexedDB NON richiede aggiornamento (solo flag in memoria)

---

**Fine Ricerca**

*Cervella Researcher - 2026-01-14*
