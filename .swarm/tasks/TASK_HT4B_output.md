# OUTPUT: TASK_HT4B - Hook useUsers

## METADATA
- ID: TASK_HT4B
- Agent: cervella-frontend
- Status: COMPLETATO
- Completato: 2026-01-03 18:51

## FILE CREATO
- `test-orchestrazione/components/hooks/useUsers.js`

## CHECKLIST COMPLETATA
- [x] Hook useUsers() creato
- [x] Chiama GET /api/users
- [x] Gestisce loading state
- [x] Gestisce error state
- [x] Type/Interface User definito (JSDoc)
- [x] Output con INFO PER TESTER

## INFO PER TESTER (cervella-tester)

### Come testare il hook

```javascript
import { useUsers } from './hooks/useUsers';

function TestComponent() {
  const { users, loading, error, refetch } = useUsers();

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div>
      <h1>Users ({users.length})</h1>
      <ul>
        {users.map(user => (
          <li key={user.id}>
            {user.name} - {user.email}
          </li>
        ))}
      </ul>
      <button onClick={refetch}>Ricarica</button>
    </div>
  );
}
```

### Return Value

```javascript
{
  users: User[],      // Array di utenti (vuoto se errore)
  loading: boolean,   // true durante fetch
  error: string|null, // Messaggio errore o null
  refetch: function   // Funzione per ricaricare i dati
}
```

### User Type

```javascript
{
  id: number,
  name: string,
  email: string
}
```

### Test Cases Suggeriti

1. **Test loading state**: Verifica che loading=true inizialmente
2. **Test success**: Mock API che ritorna users, verifica users popolato
3. **Test error**: Mock API che fallisce, verifica error message
4. **Test refetch**: Chiama refetch(), verifica nuovo fetch

### Path per import

```javascript
import { useUsers } from 'test-orchestrazione/components/hooks/useUsers';
```

---
## READY FOR: cervella-tester (TASK_HT4C)
