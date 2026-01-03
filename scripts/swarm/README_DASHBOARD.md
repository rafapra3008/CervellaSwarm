# CervellaSwarm Dashboard

Dashboard ASCII minimale per monitorare lo stato dello sciame in tempo reale.

## Installazione

```bash
# Nessuna installazione richiesta!
# La dashboard usa solo librerie Python standard
```

## Uso

### Visualizzazione Singola

```bash
./dashboard.sh
# oppure
python3 dashboard.py
```

Output:
```
╔══════════════════════════════════════════════════════════════════════════════════════╗
║                         🐝 CERVELLASWARM DASHBOARD                                  ║
╠══════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                      ║
║  WORKERS STATUS                                                                      ║
║  ┌────────────────────────────┬──────────┬─────────────────────────────────────────┐ ║
║  │ Worker                     │ Status   │ Current Task                            │ ║
║  ├────────────────────────────┼──────────┼─────────────────────────────────────────┤ ║
║  │ ⚙️ backend                 │ ● ACTIVE │ TASK_001: API endpoint creation         │ ║
║  │ 🎨 frontend                │ ○ IDLE   │ -                                       │ ║
║  ...
```

### Watch Mode (Refresh Automatico)

```bash
./dashboard.sh --watch
# oppure
python3 dashboard.py --watch
```

- Refresh ogni 2 secondi (default)
- Ctrl+C per uscire
- Usa `--interval N` per cambiare intervallo (secondi)

### Output JSON

```bash
./dashboard.sh --json
# oppure
python3 dashboard.py --json
```

Utile per:
- Integrazione con altri script
- Logging automatico
- Parsing programmatico

## Funzionalità

### Workers Status

Mostra lo stato di tutti i 16 workers dello sciame:

- **● ACTIVE** (verde) - Worker sta lavorando su un task
- **◐ READY** (giallo) - Worker ha task pending
- **○ IDLE** (grigio) - Worker senza task

### Task Queue Stats

- **Pending**: Task creati ma non ancora ready
- **In Progress**: Task in lavorazione
- **Completed**: Task completati

### Metrics

- **Completed**: Totale task completati
- **Failed**: Task falliti (se supportato)
- **Duration**: Durata sessione corrente

### Last Activity

Mostra le ultime 5 attività:
- Timestamp
- Agent coinvolto
- Azione (Completed, Started, Ready, etc.)
- Task ID

## Esempi

### Monitoring durante uno Sprint

```bash
# Terminale 1: Avvia workers
./run_backend.sh TASK_001
./run_frontend.sh TASK_002

# Terminale 2: Watch dashboard
./dashboard.sh --watch
```

### Export stato per report

```bash
# Snapshot JSON con timestamp
./dashboard.sh --json > reports/swarm_status_$(date +%Y%m%d_%H%M%S).json
```

### Integrazione in script

```bash
# Check se ci sono worker attivi
if ./dashboard.sh --json | jq '.workers[] | select(.status == "active")' | grep -q "active"; then
    echo "Sciame attivo!"
else
    echo "Sciame idle"
fi
```

## Colori

La dashboard usa colori ANSI per migliorare la leggibilità:

- **Verde** (ACTIVE): Worker in azione
- **Giallo** (READY/Pending): Task in attesa
- **Ciano** (Completed): Task completati
- **Rosso** (Failed): Errori/fallimenti
- **Grigio** (IDLE): Stato inattivo

I colori sono automaticamente disabilitati se:
- Output redirezionato a file
- Terminale non supporta colori
- Flag `--json` attivo

## Requisiti

- Python 3.7+
- Terminale con larghezza minima 80 colonne
- Sistema `.swarm/tasks/` configurato

## Troubleshooting

### Dashboard mostra tutti workers IDLE

Possibili cause:
- Nessun task nella coda
- Marker files (.working, .ready) mancanti
- Path `.swarm/tasks/` non trovato

Soluzione:
```bash
# Verifica task
python3 task_manager.py list

# Crea un task di test
python3 task_manager.py create TEST_001 cervella-backend "Test task" 1
python3 task_manager.py ready TEST_001
```

### Errore "Module not found: task_manager"

Soluzione:
```bash
# Esegui dalla directory corretta
cd scripts/swarm/
python3 dashboard.py
```

### Colori non visualizzati

Causa: Terminale non supporta ANSI colors

Soluzione: Usa `--json` per output senza colori

## File Correlati

- `task_manager.py` - Gestione task (required)
- `dashboard.py` - Script principale dashboard
- `dashboard.sh` - Wrapper bash
- `.swarm/tasks/` - Directory task files

## Version

- **Version**: 1.0.0
- **Date**: 2026-01-03
- **Author**: Cervella Backend

---

*Parte del CervellaSwarm - "Uno sciame di Cervelle. Una sola missione."* 🐝
