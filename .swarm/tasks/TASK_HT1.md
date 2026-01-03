# TASK: Creare FAQ.md per Sistema Multi-Finestra

## METADATA
- ID: TASK_HT1
- Assegnato a: cervella-docs
- Livello rischio: 1 (BASSO - nuovo file, nessun rischio)
- Timeout: 15 minuti
- Creato: 2026-01-03 18:25

## PERCHE
Questo e un HARDTEST per verificare che il sistema Multi-Finestra funzioni.
La Regina (FINESTRA 1) crea questo task, il Worker (FINESTRA 2) lo esegue.
La comunicazione avviene SOLO via file in .swarm/tasks/

## CRITERI DI SUCCESSO
- [ ] File docs/FAQ_MULTI_FINESTRA.md creato
- [ ] Contiene sezione "Cos'e il Sistema Multi-Finestra?"
- [ ] Contiene sezione "Come funzionano i flag files?"
- [ ] Contiene esempi pratici
- [ ] Output scritto in TASK_HT1_output.md

## FILE DA CREARE
- docs/FAQ_MULTI_FINESTRA.md

## CHI VERIFICHERA
Nessuno (Livello 1 - basso rischio)

## DETTAGLI

Creare un file FAQ che spiega il Sistema Multi-Finestra a chi lo usera.
Deve essere chiaro, conciso, con esempi pratici.

Struttura suggerita:
1. Cos'e il Sistema Multi-Finestra?
2. Come funzionano i flag files (.ready, .working, .done)?
3. Esempi pratici di uso
4. Comandi utili
