# TASK: Hook useUsers per chiamare /api/users

## METADATA
- ID: TASK_HT4B
- Assegnato a: cervella-frontend
- Livello rischio: 2 (MEDIO - nuovo hook React)
- Timeout: 15 minuti
- Creato: 2026-01-03 18:54

## PERCHE
HARDTEST 4 - Full Stack! Backend APPROVATO, ora Frontend!
Usa le INFO dal backend per creare hook React.

## CRITERI DI SUCCESSO
- [ ] Hook useUsers() creato
- [ ] Chiama GET /api/users
- [ ] Gestisce loading state
- [ ] Gestisce error state
- [ ] Type/Interface User definito
- [ ] Output con INFO PER TESTER

## FILE DA CREARE
- test-orchestrazione/components/hooks/useUsers.js

## CHI VERIFICHERA
cervella-guardiana-qualita (Livello 2)

## INFO DAL BACKEND (TASK_HT4A)

```
URL:     GET /api/users
Method:  GET
Response: [{ id: number, name: string, email: string }]
```

## DETTAGLI

Crea hook React useUsers() che:
1. Fetch GET /api/users
2. Ritorna { users, loading, error }
3. Gestisce stati loading/error
4. Esempio uso nel output per il Tester
