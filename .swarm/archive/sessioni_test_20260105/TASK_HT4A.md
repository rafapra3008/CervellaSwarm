# TASK: Endpoint GET /api/users per test Full Stack

## METADATA
- ID: TASK_HT4A
- Assegnato a: cervella-backend
- Livello rischio: 2 (MEDIO - nuovo endpoint API)
- Timeout: 15 minuti
- Creato: 2026-01-03 18:54

## PERCHE
HARDTEST 4 - Full Stack Pre-Miracollo!
Simuliamo task REALE: Backend -> Guardiana -> Frontend -> Guardiana -> Tester

## CRITERI DI SUCCESSO
- [ ] Endpoint GET /api/users creato
- [ ] Ritorna lista: [{ id, name, email }]
- [ ] Gestisce lista vuota []
- [ ] Error handling 500
- [ ] Type hints + docstring
- [ ] Output con INFO PER FRONTEND

## FILE DA CREARE
- test-orchestrazione/api/routes/users.py

## CHI VERIFICHERA
cervella-guardiana-qualita (Livello 2)

## DETTAGLI

Crea endpoint FastAPI:
- GET /api/users
- Mock data: [{"id": 1, "name": "Mario Rossi", "email": "mario@test.com"}]
- Type hints e docstring
- HTTPException 500 per errori

IMPORTANTE nell'output: scrivi INFO PER FRONTEND con URL, metodo, formato!
