# HARDTEST_NOTIFICA - Test Notifiche macOS

## Metadata
- **Agent:** cervella-backend
- **Livello:** 1 (BASSO)
- **Priorità:** ALTA
- **Creato:** 2026-01-04 03:15

## Obiettivo

Testare che la notifica macOS funzioni quando completi un task.

## Requisiti

1. Leggi questo task
2. Crea file `test-orchestrazione/api/notifica_test.py` con una funzione semplice
3. **IMPORTANTE:** Dopo aver creato il file, esegui questo comando:
   ```bash
   osascript -e 'display notification "HARDTEST Notifica completato!" with title "CervellaSwarm" sound name "Glass"'
   ```
4. Scrivi output
5. Fai exit

## Criteri di Successo

- [ ] File creato
- [ ] Notifica suonata (Rafa deve sentire "Glass")
- [ ] Worker ha fatto exit

## Output Atteso

Scrivi l'output in `.swarm/tasks/HARDTEST_NOTIFICA_output.md`
