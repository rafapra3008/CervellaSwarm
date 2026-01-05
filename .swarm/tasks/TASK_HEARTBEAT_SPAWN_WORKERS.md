# TASK: Aggiungere Heartbeat + Notifiche Inizio a spawn-workers.sh

**Assegnato a:** cervella-backend
**Priorita:** ALTA
**Stato:** ready

---

## Obiettivo

Modificare `~/.local/bin/spawn-workers` per aggiungere:
1. Istruzioni HEARTBEAT nel prompt base
2. Notifica macOS a INIZIO task (non solo fine)

---

## File da Modificare

`~/.local/bin/spawn-workers`

---

## Cosa Aggiungere

### 1. Nel prompt base (funzione `get_base_prompt()`)

Aggiungere PRIMA di "COMANDI UTILI:" questa sezione:

```
HEARTBEAT (IMPORTANTE - fallo ogni 60 secondi mentre lavori!):
Scrivi il tuo stato attuale per la Regina:
echo "$(date +%s)|NOME_TASK|cosa stai facendo ora" >> .swarm/status/heartbeat_WORKER.log

Esempio:
echo "$(date +%s)|TASK_123|Analizzando file database.py" >> .swarm/status/heartbeat_backend.log

Questo permette alla Regina di vedere il tuo progresso in tempo reale!
```

### 2. Notifica INIZIO task

Modificare la sezione "DOPO OGNI TASK COMPLETATO:" in:

```
NOTIFICHE (usa SEMPRE virgolette DRITTE!):
- INIZIO TASK: osascript -e 'display notification "Inizio: NOME_TASK" with title "CervellaSwarm"'
- FINE TASK: osascript -e 'display notification "Completato: NOME_TASK" with title "CervellaSwarm" sound name "Glass"'
- ERRORE: osascript -e 'display notification "ERRORE!" with title "CervellaSwarm" sound name "Basso"'
```

---

## Verifica

- [ ] Prompt base contiene sezione HEARTBEAT
- [ ] Istruzioni notifica INIZIO task presenti
- [ ] Formato heartbeat corretto: `timestamp|task|azione`
- [ ] Virgolette dritte in tutti gli osascript

---

## Output

Scrivi conferma delle modifiche in:
`.swarm/tasks/TASK_HEARTBEAT_SPAWN_WORKERS_output.md`
