# TASK: Test E2E per endpoint /api/users

## METADATA
- ID: TASK_HT4C
- Assegnato a: cervella-tester
- Livello rischio: 1 (BASSO - solo test, nessuna modifica)
- Timeout: 15 minuti
- Creato: 2026-01-03 18:54

## PERCHE
HARDTEST 4 - STEP FINALE!
Backend APPROVATO, Frontend APPROVATO, ora TEST!
Verifica che tutto funzioni insieme.

## CRITERI DI SUCCESSO
- [ ] Test Backend: endpoint risponde
- [ ] Test Frontend: hook struttura corretta
- [ ] Test Integration: formati compatibili
- [ ] Report con PASS/FAIL per ogni test

## FILE BACKEND
- test-orchestrazione/api/routes/users.py

## FILE FRONTEND
- test-orchestrazione/components/hooks/useUsers.js

## CHI VERIFICHERA
Nessuno (Livello 1)

## DETTAGLI

Verifica:
1. Backend: GET /api/users ritorna array con {id, name, email}
2. Frontend: useUsers() ha loading, error, users, refetch
3. Integration: formati compatibili tra backend e frontend

Scrivi report finale con tutti i test PASS/FAIL!
