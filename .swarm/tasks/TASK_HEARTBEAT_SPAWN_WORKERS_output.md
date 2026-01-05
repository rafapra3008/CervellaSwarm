# Output: TASK_HEARTBEAT_SPAWN_WORKERS

**Completato da:** cervella-backend
**Data:** 2026-01-05

---

## Risultato

Il file `~/.local/bin/spawn-workers` conteneva GIA le modifiche richieste!

### Verifiche Passate

- [x] Prompt base contiene sezione HEARTBEAT (linee 130-137)
- [x] Istruzioni notifica INIZIO task presenti (linee 146-149)
- [x] Formato heartbeat corretto: `timestamp|task|azione`
- [x] Virgolette dritte in tutti gli osascript

### Sezione HEARTBEAT (linee 130-137)

```
HEARTBEAT (IMPORTANTE - fallo ogni 60 secondi mentre lavori!):
Scrivi il tuo stato attuale per la Regina:
echo "$(date +%s)|NOME_TASK|cosa stai facendo ora" >> .swarm/status/heartbeat_WORKER.log

Esempio:
echo "$(date +%s)|TASK_123|Analizzando file database.py" >> .swarm/status/heartbeat_backend.log

Questo permette alla Regina di vedere il tuo progresso in tempo reale!
```

### Sezione NOTIFICHE (linee 146-149)

```
NOTIFICHE (usa SEMPRE virgolette DRITTE!):
- INIZIO TASK: osascript -e 'display notification "Inizio: NOME_TASK" with title "CervellaSwarm"'
- FINE TASK: osascript -e 'display notification "Completato: NOME_TASK" with title "CervellaSwarm" sound name "Glass"'
- ERRORE: osascript -e 'display notification "ERRORE!" with title "CervellaSwarm" sound name "Basso"'
```

---

**Stato:** COMPLETATO (gia presente nel file)
