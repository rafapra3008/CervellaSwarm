# Studio Visibilita Real-Time Worker - Output Ricerca

**Data:** 5 Gennaio 2026
**Agente:** cervella-researcher
**Task:** TASK_20260105_051500_studio_visibilita_researcher

---

## 1. Analisi del Problema

### Stato Attuale

Il sistema CervellaSwarm ha GIA' implementato:

| Cosa Esiste | File | Cosa Fa |
|-------------|------|---------|
| Dashboard ASCII | `scripts/swarm/dashboard.py` | Mostra stato task (pending/working/done) |
| Monitor Status | `scripts/swarm/monitor-status.sh` | Lista task con emoji stato |
| Worker Health Tracking | spawn-workers.sh v2.1.0 | PID/timestamp in `.swarm/status/` |
| Log files | `.swarm/logs/worker_*.log` | Output completo MA post-mortem |

### Il Gap: Cosa MANCA

```
+------------------------------------------------------------------+
|                                                                  |
|   PROBLEMA CENTRALE                                              |
|                                                                  |
|   I log esistono, ma sono POST-MORTEM!                          |
|   Vediamo cosa e' successo DOPO che e' finito.                  |
|   Non vediamo cosa sta succedendo MENTRE lavora.                |
|                                                                  |
+------------------------------------------------------------------+
```

**Specificamente:**

1. **Log non in streaming**: `tee "$LOG_FILE"` scrive nel file ma Claude bufferizza l'output
2. **Nessun heartbeat attivo**: Il file `.pid` esiste ma non c'e' un "sono vivo e sto facendo X"
3. **Nessun progresso**: Non sappiamo quanti task ha fatto, quanto manca
4. **Dashboard passiva**: Mostra solo stato file (done/working), non attivita' live

---

## 2. Soluzioni Trovate

### Soluzione A: Heartbeat File Attivo

**Concetto**: Worker scrive periodicamente il suo stato in un file

**Implementazione**:
```bash
# Worker scrive ogni 30 secondi
.swarm/status/worker_backend.heartbeat
# Contenuto:
# timestamp: 1736064000
# task: TASK_123
# action: Analyzing file X
# progress: 3/5 tasks
```

**Pro**:
- Semplice da implementare
- Nessuna dipendenza esterna
- Funziona con qualsiasi versione di Claude

**Contro**:
- Richiede che il worker scriva attivamente (modifica al prompt)
- Dipende dalla collaborazione del LLM
- Potrebbe non essere preciso se Claude e' occupato

**Complessita**: BASSA

---

### Soluzione B: tail -f su Log + Named Pipes

**Concetto**: Usare `tail -f` per seguire i log in tempo reale

**Implementazione**:
```bash
# Crea named pipe per streaming
mkfifo .swarm/streams/worker_backend.pipe

# Worker scrive nel pipe
claude ... 2>&1 | tee .swarm/logs/worker.log > .swarm/streams/worker_backend.pipe &

# Monitor legge dal pipe
tail -f .swarm/streams/worker_backend.pipe
```

**Pro**:
- True real-time streaming
- Pattern Unix classico e affidabile
- Nessuna modifica al worker necessaria

**Contro**:
- Named pipes bloccanti se nessuno legge
- Complessita' setup (writer/reader sincronizzati)
- Claude bufferizza comunque l'output (limitazione intrinseca)

**Complessita**: MEDIA

---

### Soluzione C: Dashboard Live con Rich (Python)

**Concetto**: Dashboard TUI con refresh automatico usando libreria Rich

**Implementazione**:
```python
from rich.live import Live
from rich.table import Table
from rich.layout import Layout

# Refresh ogni 2 secondi
with Live(generate_dashboard(), refresh_per_second=0.5) as live:
    while True:
        live.update(generate_dashboard())
        time.sleep(2)
```

**Pro**:
- UI bellissima e professionale
- Gia' usata in dashboard.py esistente (pattern compatibile)
- Supporta colori, animazioni, progress bar
- Puo' aggregare multiple fonti (log, status, heartbeat)

**Contro**:
- Richiede terminale che supporta ANSI
- Overhead CPU per refresh continuo
- Non risolve il problema del buffer Claude

**Complessita**: MEDIA

---

### Soluzione D: Notifiche macOS Periodiche

**Concetto**: Worker invia notifiche macOS per eventi importanti

**Implementazione**:
```bash
# Gia' presente nel prompt base, ma solo a fine task
osascript -e 'display notification "Iniziato task X" with title "CervellaSwarm"'

# Potrebbe essere esteso a:
# - Ogni 5 minuti "Ancora in lavorazione..."
# - Ad ogni cambio task
# - Per errori/warning
```

**Pro**:
- Zero overhead
- Gia' funzionante per fine task
- Notifiche native macOS (suono, banner)

**Contro**:
- Non e' una dashboard
- Potrebbe diventare spam se troppo frequente
- Richiede modifica al prompt

**Complessita**: BASSA

---

### Soluzione E: swarm-watch Command (Aggregatore)

**Concetto**: Un unico comando che aggrega tutte le fonti di visibilita'

**Implementazione**:
```bash
#!/bin/bash
# swarm-watch - Visualizza tutto lo swarm in tempo reale

# Terminal multiplexato:
# +------------------------------------------+
# | [Workers Status] | [Live Logs]          |
# |                  |                       |
# | backend: ACTIVE  | > Reading file X...   |
# | frontend: IDLE   | > Analyzing Y...      |
# | tester: ACTIVE   | > Found issue Z       |
# +------------------------------------------+
# | [Task Queue]     | [Recent Activity]     |
# | 3 pending        | 14:32 backend done    |
# | 1 working        | 14:30 tester started  |
# +------------------------------------------+
```

**Pro**:
- Single pane of glass
- Combina tutte le soluzioni precedenti
- UX ottimale per la Regina

**Contro**:
- Richiede implementazione di A, B, C prima
- Piu' complesso da mantenere
- Richiede terminale grande

**Complessita**: ALTA

---

## 3. Analisi Pro/Contro Comparativa

| Soluzione | Real-Time | Complessita | Dipendenze | Affidabilita |
|-----------|-----------|-------------|------------|--------------|
| A: Heartbeat File | ~30s delay | BASSA | Nessuna | Alta (se LLM collabora) |
| B: tail -f + Pipes | Vera | MEDIA | Unix pipes | Media (bloccante) |
| C: Rich Dashboard | 2s refresh | MEDIA | rich python | Alta |
| D: Notifiche macOS | Evento | BASSA | osascript | Alta |
| E: swarm-watch | Combo | ALTA | Tutte | Dipende |

---

## 4. Raccomandazione

### IMPLEMENTARE IN ORDINE:

```
+------------------------------------------------------------------+
|                                                                  |
|   FASE 1: Heartbeat File + Notifiche (QUICK WIN)                |
|   Tempo: 1-2 ore | Impatto: ALTO                                |
|                                                                  |
|   - Modifica prompt worker per scrivere heartbeat ogni 60s     |
|   - Aggiungi notifiche per inizio task (non solo fine)          |
|   - Dashboard esistente legge heartbeat per stato "live"        |
|                                                                  |
+------------------------------------------------------------------+

+------------------------------------------------------------------+
|                                                                  |
|   FASE 2: Dashboard Rich Migliorata                             |
|   Tempo: 2-4 ore | Impatto: MEDIO                               |
|                                                                  |
|   - Upgrade dashboard.py con rich.live                          |
|   - Aggiungi sezione "Live Activity" che legge heartbeat        |
|   - Progress bar per task in corso                              |
|                                                                  |
+------------------------------------------------------------------+

+------------------------------------------------------------------+
|                                                                  |
|   FASE 3: swarm-watch (Futuro)                                  |
|   Tempo: 4-8 ore | Impatto: ALTO                                |
|                                                                  |
|   - Terminale multiplexato con tmux/screen                      |
|   - tail -f su log attivi                                       |
|   - Dashboard + logs side-by-side                               |
|                                                                  |
+------------------------------------------------------------------+
```

### RACCOMANDAZIONE IMMEDIATA:

**Iniziare con FASE 1 (Heartbeat + Notifiche)**

Motivo:
1. Minimo sforzo, massimo impatto
2. Non richiede nuove dipendenze
3. Migliora subito la visibilita' senza riscrivere tutto
4. Base solida per fasi successive

---

## 5. Piano Implementazione - FASE 1

### Step 1: Creare sistema heartbeat (30 min)

**Modifica a spawn-workers.sh** - Aggiungere al prompt base:

```
HEARTBEAT (ogni 60 secondi durante il lavoro):
- Scrivi file: echo "$(date +%s)|TASK_ID|cosa stai facendo" >> .swarm/status/heartbeat_WORKER.log
- Questo permette alla Regina di vedere cosa stai facendo in tempo reale
```

**Creare script monitor-heartbeat.sh**:
```bash
#!/bin/bash
# Mostra ultimo heartbeat di ogni worker
for hb in .swarm/status/heartbeat_*.log; do
    worker=$(basename "$hb" .log | sed 's/heartbeat_//')
    last_line=$(tail -1 "$hb" 2>/dev/null)
    if [ -n "$last_line" ]; then
        timestamp=$(echo "$last_line" | cut -d'|' -f1)
        task=$(echo "$last_line" | cut -d'|' -f2)
        action=$(echo "$last_line" | cut -d'|' -f3)
        age=$(($(date +%s) - timestamp))
        if [ $age -lt 120 ]; then
            status="ACTIVE"
        else
            status="STALE (${age}s ago)"
        fi
        echo "[$worker] $status - $task: $action"
    fi
done
```

### Step 2: Notifiche estese (15 min)

**Modifica prompt worker** per notifiche extra:

```
NOTIFICHE (usa SEMPRE virgolette dritte!):
- Inizio task: osascript -e 'display notification "Inizio: TASK_ID" with title "CervellaSwarm"'
- Fine task: osascript -e 'display notification "Completato: TASK_ID" with title "CervellaSwarm" sound name "Glass"'
- Errore: osascript -e 'display notification "ERRORE: descrizione" with title "CervellaSwarm" sound name "Basso"'
```

### Step 3: Upgrade dashboard.py (45 min)

**Aggiungere sezione heartbeat** alla dashboard esistente:

```python
def get_live_activity():
    """Legge heartbeat files e mostra attivita' live."""
    activities = []
    for hb_file in Path('.swarm/status').glob('heartbeat_*.log'):
        last_line = hb_file.read_text().strip().split('\n')[-1]
        # Parse e mostra
    return activities
```

### Step 4: Comando rapido swarm-status (15 min)

**Creare ~/.local/bin/swarm-status**:
```bash
#!/bin/bash
cd /path/to/project
python3 scripts/swarm/dashboard.py --watch
```

---

## 6. Limitazioni Note

### Buffer di Claude

Claude Code bufferizza l'output del terminale. Questo significa che:
- Non vedremo output "lettera per lettera"
- L'output arriva in blocchi
- I heartbeat risolveranno parzialmente il problema

### Dipendenza da LLM

Il sistema heartbeat richiede che il worker LLM:
- Ricordi di scrivere i heartbeat
- Li scriva nel formato corretto
- Non "dimentichi" durante task lunghi

Mitigazione: Reminder periodico nel prompt, formato semplice.

---

## Fonti

- [Heartbeat Monitoring Guide - Cronitor](https://cronitor.io/guides/heartbeat-monitoring)
- [Real-Time Monitoring Best Practices - Estuary](https://estuary.dev/blog/real-time-monitoring/)
- [Best Practices for Live Process Monitoring - Datadog](https://docs.datadoghq.com/monitors/guide/best-practices-for-live-process-monitoring/)
- [Multi-Agent Systems Observability - Wipro](https://www.wipro.com/cloud/articles/multiagent-systems-from-observability-to-outcomes/)
- [Building Rich Terminal Dashboards - Will McGugan](https://www.willmcgugan.com/blog/tech/post/building-rich-terminal-dashboards/)
- [tail -f Real-Time Monitoring - Server for Beginner](https://serverforbeginner.com/watching-logs-live-using-tail-f-for-real-time-monitoring/)
- [Named Pipes for IPC Logging - offlinemark](https://offlinemark.com/fifos-and-simple-ipc-logging/)
- [Rich Live Display Documentation](https://rich.readthedocs.io/en/stable/live.html)

---

## Checklist Verifica

- [x] Almeno 3 soluzioni studiate (5 soluzioni)
- [x] Pro/contro per ogni soluzione
- [x] Raccomandazione chiara (FASE 1: Heartbeat + Notifiche)
- [x] Piano implementazione concreto (4 step dettagliati)
- [x] Output scritto in _output.md

---

*Ricerca completata da cervella-researcher*
*"Lavorare al buio e' difficile - ora avremo luce!" - Rafa*
