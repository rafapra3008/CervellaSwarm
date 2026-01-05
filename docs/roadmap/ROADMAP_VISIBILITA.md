# ROADMAP VISIBILITA' WORKER

> **Versione:** 1.0.0
> **Data:** 5 Gennaio 2026
> **Basata su:** Studio di 2 ricercatori (cervella-researcher + cervella-guardiana-ricerca)

---

## IL PROBLEMA

```
+------------------------------------------------------------------+
|                                                                  |
|   "LAVORIAMO AL BUIO!"                                          |
|                                                                  |
|   OGGI SAPPIAMO:                                                 |
|   - Quando worker INIZIA (spawn)                                 |
|   - Quando worker FINISCE (cleanup)                              |
|                                                                  |
|   NON SAPPIAMO:                                                  |
|   - Cosa fa MENTRE lavora                                        |
|   - Se e' bloccato o sta pensando                                |
|   - Quanto manca al completamento                                |
|   - Se ha problemi                                               |
|                                                                  |
|   "Lavorare al buio e' difficile!" - Rafa                       |
|                                                                  |
+------------------------------------------------------------------+
```

---

## STATO ATTUALE

| Cosa Esiste | File | Cosa Fa |
|-------------|------|---------|
| Dashboard ASCII | `scripts/swarm/dashboard.py` | Stato task (pending/working/done) |
| Monitor Status | `scripts/swarm/monitor-status.sh` | Lista task con emoji |
| Worker Health | spawn-workers v2.1.0 | PID/timestamp in `.swarm/status/` |
| Log files | `.swarm/logs/worker_*.log` | Output MA post-mortem |

**Gap:** I log esistono ma sono POST-MORTEM! Non vediamo cosa succede MENTRE lavora.

---

## LE 3 FASI

### FASE 1: QUICK WIN (Sessione 92)

**Tempo stimato:** 1-2 ore
**Impatto:** ALTO
**Complessita':** BASSA

| Task | Descrizione | File |
|------|-------------|------|
| 1.1 | Heartbeat file ogni 30-60s | spawn-workers.sh |
| 1.2 | Notifiche macOS a inizio task | spawn-workers.sh |
| 1.3 | Monitor heartbeat command | ~/.local/bin/swarm-heartbeat |
| 1.4 | Dashboard legge heartbeat | scripts/swarm/dashboard.py |

**Risultato atteso:**
```
$ swarm-heartbeat
[backend]  ACTIVE (15s ago) - Analizzando file X
[frontend] ACTIVE (8s ago)  - Creando componente Y
[tester]   IDLE   (5m ago)  - Ultimo task completato
```

---

### FASE 2: DASHBOARD ENHANCED (Sessione 93-94)

**Tempo stimato:** 2-4 ore
**Impatto:** MEDIO
**Complessita':** MEDIA

| Task | Descrizione | File |
|------|-------------|------|
| 2.1 | Upgrade con rich.live | dashboard.py |
| 2.2 | Sezione "Live Activity" | dashboard.py |
| 2.3 | Progress bar per task | dashboard.py |
| 2.4 | Log strutturato con prefix | spawn-workers.sh |

**Risultato atteso:**
Dashboard TUI con refresh automatico, colori, stato live.

---

### FASE 2.5: STUDIO FRONTEND WORKER (Post-FASE 1)

**Tempo stimato:** 1-2 ore
**Impatto:** ALTO
**Complessita':** BASSA

| Task | Descrizione |
|------|-------------|
| 2.5.1 | Osservare cosa vedono i worker nelle finestre |
| 2.5.2 | Analizzare se le istruzioni sono chiare |
| 2.5.3 | Migliorare prompt se necessario |
| 2.5.4 | Aggiungere visual feedback (emoji, box, colori) |

**Domande da rispondere:**
- I worker capiscono le istruzioni heartbeat?
- Il formato e' chiaro?
- Serve un "cheatsheet" visivo nel prompt?
- Le istruzioni sono troppo lunghe?

**PROBLEMA IDENTIFICATO (HARDTEST 5 Gen 2026):**
```
La finestra del worker mostra solo:
"🐝 [CervellaSwarm] Worker avviato"
...e poi NULLA fino alla fine!

Il worker LAVORA (heartbeat scritti!) ma l'utente
non vede niente. Cursore fermo, nessun output.

CAUSA: Claude bufferizza l'output.
EFFETTO: UX "al buio" per chi guarda la finestra.

IDEE PER FUTURO:
- Worker stampa "." periodicamente?
- Output verboso opzionale?
- Progress bar ASCII?
- Dipende dal livello utente (avanzato vs base)
```

**PRIORITA':** BASSA (sistema funziona, e' finitura UX)

---

### FASE 3: SWARM-WATCH PRO (Futuro)

**Tempo stimato:** 4-8 ore
**Impatto:** MOLTO ALTO
**Complessita':** ALTA

| Task | Descrizione |
|------|-------------|
| 3.1 | Terminal multiplexato con tmux |
| 3.2 | tail -f su log attivi |
| 3.3 | Split screen: dashboard + logs |
| 3.4 | Alerts per eventi critici |

**Risultato atteso:**
```
+------------------------------------------+
| [Workers Status] | [Live Logs]          |
|                  |                       |
| backend: ACTIVE  | > Reading file X...   |
| frontend: IDLE   | > Analyzing Y...      |
| tester: ACTIVE   | > Found issue Z       |
+------------------------------------------+
| [Task Queue]     | [Recent Activity]     |
| 3 pending        | 14:32 backend done    |
| 1 working        | 14:30 tester started  |
+------------------------------------------+
```

---

## DETTAGLIO FASE 1

### 1.1 Heartbeat File System

**Cosa fare:**
Modificare spawn-workers.sh per aggiungere istruzioni heartbeat nel prompt.

**Formato heartbeat:**
```
.swarm/status/heartbeat_WORKER.log
```

**Contenuto:**
```
timestamp|task_id|azione_corrente
1736064000|TASK_123|Analizzando file X
1736064060|TASK_123|Scrivendo modifiche
```

**Istruzione da aggiungere al prompt worker:**
```
HEARTBEAT (IMPORTANTE!):
Ogni 60 secondi mentre lavori, scrivi:
echo "$(date +%s)|TASK_ID|cosa stai facendo" >> .swarm/status/heartbeat_WORKER.log

Questo permette alla Regina di vedere il tuo progresso in tempo reale.
```

---

### 1.2 Notifiche Estese

**Aggiungere al prompt worker:**
```
NOTIFICHE:
- INIZIO: osascript -e 'display notification "Inizio: TASK_ID" with title "Swarm"'
- FINE:   osascript -e 'display notification "Fatto: TASK_ID" with title "Swarm" sound name "Glass"'
- ERRORE: osascript -e 'display notification "ERRORE!" with title "Swarm" sound name "Basso"'
```

---

### 1.3 Monitor Heartbeat Command

**Creare ~/.local/bin/swarm-heartbeat:**
```bash
#!/bin/bash
# swarm-heartbeat - Mostra stato live dei worker

for hb in .swarm/status/heartbeat_*.log; do
    [ -f "$hb" ] || continue
    worker=$(basename "$hb" .log | sed 's/heartbeat_//')
    last_line=$(tail -1 "$hb" 2>/dev/null)
    if [ -n "$last_line" ]; then
        timestamp=$(echo "$last_line" | cut -d'|' -f1)
        task=$(echo "$last_line" | cut -d'|' -f2)
        action=$(echo "$last_line" | cut -d'|' -f3)
        age=$(($(date +%s) - timestamp))
        if [ $age -lt 120 ]; then
            echo "[$worker] ACTIVE (${age}s ago) - $action"
        else
            echo "[$worker] STALE (${age}s ago) - $action"
        fi
    fi
done
```

---

### 1.4 Dashboard Upgrade

**Aggiungere a dashboard.py:**
```python
def get_live_activity():
    """Legge heartbeat files e mostra attivita' live."""
    from pathlib import Path
    activities = []
    for hb_file in Path('.swarm/status').glob('heartbeat_*.log'):
        lines = hb_file.read_text().strip().split('\n')
        if lines:
            last = lines[-1].split('|')
            if len(last) == 3:
                activities.append({
                    'worker': hb_file.stem.replace('heartbeat_', ''),
                    'timestamp': int(last[0]),
                    'task': last[1],
                    'action': last[2]
                })
    return activities
```

---

## LEZIONI DAI SISTEMI PRO

| Sistema | Pattern | Cosa Impariamo |
|---------|---------|----------------|
| GitHub Actions | WebSocket UI | Anche loro NON hanno API real-time! |
| Kubernetes | kubectl logs -f | Pattern tail -f e' standard |
| PM2 | pm2 logs + pm2 monit | File log + tail + UI opzionale |
| tmux | pipe-pane | Puo' catturare output e inviarlo |

**Lezione chiave:** Tutti usano file di log + tail. Non c'e' magia!

---

## LIMITAZIONI NOTE

### Buffer di Claude

Claude Code bufferizza l'output. I heartbeat aiutano ma non danno streaming "lettera per lettera".

### Dipendenza da LLM

Il sistema heartbeat richiede che il worker:
- Ricordi di scrivere i heartbeat
- Li scriva nel formato corretto
- Non "dimentichi" durante task lunghi

**Mitigazione:** Reminder chiaro nel prompt, formato semplice.

---

## CHECKLIST FASE 1

- [ ] 1.1 Heartbeat: Modificare spawn-workers.sh
- [ ] 1.2 Notifiche: Aggiungere inizio task
- [ ] 1.3 Command: Creare swarm-heartbeat
- [ ] 1.4 Dashboard: Aggiungere sezione heartbeat
- [ ] Test: Spawnare worker e verificare visibilita'

---

## FONTI

### Da cervella-researcher:
- Cronitor Heartbeat Monitoring Guide
- Estuary Real-Time Monitoring Best Practices
- Datadog Live Process Monitoring
- Rich Terminal Dashboards (Will McGugan)

### Da cervella-guardiana-ricerca:
- GitHub Actions Streaming Logs (limitazioni API)
- CNCF Kubernetes Logging Best Practices
- PM2 Log Management
- claude-code-hooks-multi-agent-observability (GitHub)

---

*"Lavorare al buio e' difficile - ora avremo luce!"*

Cervella & Rafa
