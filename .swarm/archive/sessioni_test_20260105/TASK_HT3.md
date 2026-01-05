# TASK: Creare funzione validate_email in utils.py

## METADATA
- ID: TASK_HT3
- Assegnato a: cervella-backend
- Livello rischio: 2 (MEDIO - nuovo codice Python)
- Timeout: 15 minuti
- Creato: 2026-01-03 18:41

## PERCHE
HARDTEST 3: Testare flusso Regina -> Worker -> Guardiana via .swarm/
La funzione validate_email servira per validare email nei form.
Livello 2 = Guardiana deve verificare prima di approvare!

## CRITERI DI SUCCESSO
- [ ] Funzione validate_email(email: str) -> bool creata
- [ ] Gestisce formati email standard (user@domain.com)
- [ ] Gestisce casi edge (None, empty, invalid)
- [ ] Type hints presenti
- [ ] Docstring con esempi
- [ ] Output scritto in TASK_HT3_output.md

## FILE DA CREARE
- test-orchestrazione/api/utils.py

## CHI VERIFICHERA
cervella-guardiana-qualita (Livello 2 - verifica type hints, edge cases, docstring)

## DETTAGLI

Creare funzione validate_email() che:
1. Accetta stringa email
2. Ritorna True se email valida, False altrimenti
3. Gestisce casi: None, stringa vuota, formato invalido
4. Ha type hints completi
5. Ha docstring con esempi di uso

IMPORTANTE: Dopo completamento, la Guardiana verifichera il codice!
