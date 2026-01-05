# OUTPUT: TASK_HT4A

## Eseguito da: cervella-backend
## Completato: 2026-01-03 18:56

---

## RISULTATO

Task completato con successo!

### File Creati
- `test-orchestrazione/api/routes/users.py` (95 righe)
- `test-orchestrazione/api/routes/__init__.py` (5 righe)

### Endpoint Implementati

| Metodo | URL | Descrizione |
|--------|-----|-------------|
| GET | `/api/users` | Lista tutti gli utenti |
| GET | `/api/users/{id}` | Singolo utente per ID |

### Checklist
- [x] Endpoint GET /api/users creato
- [x] Ritorna lista: [{ id, name, email }]
- [x] Gestisce lista vuota []
- [x] Error handling 500
- [x] Type hints + docstring
- [x] Output con INFO PER FRONTEND

---

## INFO PER FRONTEND

### Endpoint Lista Utenti

```
URL:     GET /api/users
Method:  GET
Auth:    None (mock)

Response 200:
[
  {
    "id": 1,
    "name": "Mario Rossi",
    "email": "mario@test.com"
  },
  {
    "id": 2,
    "name": "Laura Bianchi",
    "email": "laura@test.com"
  }
]

Response 200 (empty):
[]

Response 500:
{
  "detail": "Errore interno del server: <messaggio>"
}
```

### Endpoint Singolo Utente

```
URL:     GET /api/users/{id}
Method:  GET
Params:  id (int) - ID utente
Auth:    None (mock)

Response 200:
{
  "id": 1,
  "name": "Mario Rossi",
  "email": "mario@test.com"
}

Response 404:
{
  "detail": "Utente non trovato"
}

Response 500:
{
  "detail": "Errore interno del server: <messaggio>"
}
```

### TypeScript Interface (suggerita)

```typescript
interface User {
  id: number;
  name: string;
  email: string;
}

// Fetch users
const response = await fetch('/api/users');
const users: User[] = await response.json();
```

---

## PER LA GUARDIANA

Livello rischio 2: **RICHIESTA VERIFICA**

Punti da verificare:
1. Type hints corretti (List[User], response_model)
2. Pydantic model User con validazione
3. Error handling HTTPException 500
4. Docstring con esempi

File: `test-orchestrazione/api/routes/users.py`
