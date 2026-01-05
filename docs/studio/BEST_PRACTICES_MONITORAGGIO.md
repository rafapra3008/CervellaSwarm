# Best Practices Monitoraggio Real-Time

> **Estratto da:** Studio Visibilita' Worker (5 Gennaio 2026)
> **Fonti:** 2 ricercatori + 12 fonti web professionali

---

## Pattern Universali (Tutti i Big Player)

```
+------------------------------------------------------------------+
|                                                                  |
|   IL PATTERN E' SEMPRE LO STESSO:                               |
|                                                                  |
|   FILE DI LOG + TAIL + UI OPZIONALE                             |
|                                                                  |
|   Non c'e' magia. Solo buone pratiche.                          |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 1. GitHub Actions

### Cosa fanno
- Streaming logs con backscroll (ultime 1000 righe)
- Live tail automatico nella UI
- Job grouping (ogni step collassabile)

### Limitazione importante
> L'API di GitHub NON fornisce log real-time!
> Ritorna 404 mentre il job e' in corso.
> Solo dopo completion i log sono disponibili via API.

### Lezione per noi
Anche sistemi enterprise hanno questo problema!
La soluzione e' UI-based (websocket nel browser), non API.

---

## 2. Kubernetes

### Best practices 2025
- `kubectl logs -f` per streaming
- **Stern/Kubetail** per multi-pod aggregation
- **Sidecar containers** per log non-stdout

### Tools specializzati
| Tool | Cosa fa |
|------|---------|
| Stern | Color-coded output, regex filtering |
| Kail | Raw e JSON output |
| Kubetail | Aggregazione multi-pod |

### Lezione per noi
Pattern `tail -f` e' standard.
Tools di aggregazione per multi-source.

---

## 3. PM2

### La soluzione piu' elegante
- `pm2 logs` - Stream real-time
- `pm2 logs --json` - Stream strutturato
- `pm2 monit` - Dashboard TUI con CPU/memory
- **PM2 Plus** - Dashboard web cloud (a pagamento)

### Lezione per noi
File di log + tail + UI separata = pattern vincente.

---

## 4. tmux

### Feature native utili
- `pipe-pane` - Redirect output a file/comando
- Alerts per activity/bell
- Split panes per monitoring multiplo

### Tool interessante
**TmuxTop** - Mostra metriche per ogni pane.

### Lezione per noi
tmux puo' catturare output e inviarlo dove vogliamo.
Utile per FASE 3 (swarm-watch).

---

## 5. Log Strutturati

### Pattern consigliato
```
[TIMESTAMP] [LEVEL] [SOURCE] message
```

### Esempio per noi
```
[2026-01-05 14:32:15] [INFO] [backend] Iniziato TASK_123
[2026-01-05 14:32:45] [PROGRESS] [backend] 50% - Analizzando file X
[2026-01-05 14:33:00] [DONE] [backend] Completato TASK_123
```

### Vantaggi
- Filtrabile con grep
- Parsabile con script
- Leggibile da umani

---

## 6. Heartbeat Pattern

### Cos'e'
Il processo scrive periodicamente "sono vivo" in un file.

### Formato minimo
```
timestamp|context
```

### Formato ricco
```json
{
  "timestamp": 1736064000,
  "worker": "backend",
  "task": "TASK_123",
  "action": "Analizzando file X",
  "progress": "3/5"
}
```

### Come monitorare
```bash
# Check se worker e' attivo
last_beat=$(stat -f %m .swarm/status/heartbeat_backend.log)
now=$(date +%s)
age=$((now - last_beat))
if [ $age -gt 120 ]; then
    echo "Worker STALE!"
fi
```

---

## 7. Named Pipes (FIFO)

### Cosa sono
File speciali che permettono IPC (Inter-Process Communication).

### Pattern
```bash
mkfifo /tmp/worker.pipe

# Writer (worker)
echo "output" > /tmp/worker.pipe

# Reader (monitor)
cat /tmp/worker.pipe
```

### Pro/Contro
| Pro | Contro |
|-----|--------|
| Vero streaming | Bloccante se nessuno legge |
| Pattern Unix classico | Setup complesso |
| Nessun file intermedio | Richiede sincronizzazione |

### Quando usare
Solo per FASE 3 avanzata, se serve streaming vero.

---

## 8. Dashboard TUI (Rich Python)

### Libreria: Rich
```python
from rich.live import Live
from rich.table import Table

with Live(generate_table(), refresh_per_second=0.5) as live:
    while True:
        live.update(generate_table())
        time.sleep(2)
```

### Pro
- UI bellissima e professionale
- Supporta colori, animazioni, progress bar
- Puo' aggregare multiple fonti

### Contro
- Richiede terminale ANSI
- Overhead CPU per refresh continuo

---

## 9. Hooks Claude Code

### Hooks disponibili
| Hook | Quando | Uso potenziale |
|------|--------|----------------|
| PreToolUse | Prima di tool | Log "sto per fare X" |
| PostToolUse | Dopo tool | Log "ho fatto X" |
| Stop | Fine risposta | Cleanup |
| SubagentStop | Fine subagent | Log completamento |

### Limitazione
Gli hooks girano DENTRO la sessione Claude.
Non possono "uscire" per notificare in modo sincrono.

### Progetto interessante
[claude-code-hooks-multi-agent-observability](https://github.com/disler/claude-code-hooks-multi-agent-observability)
- WebSocket server + Vue client
- Real-time observability
- Da valutare per FASE 3

---

## 10. Notifiche macOS

### Comando
```bash
osascript -e 'display notification "messaggio" with title "titolo" sound name "Glass"'
```

### Suoni disponibili
- Glass (successo)
- Basso (errore)
- Ping (info)
- Pop (attenzione)

### Pro/Contro
| Pro | Contro |
|-----|--------|
| Zero overhead | Non e' una dashboard |
| Nativo macOS | Spam se troppo frequente |
| Suono + banner | Solo eventi discreti |

### Best practice
- Inizio task: notifica senza suono
- Fine task: notifica con Glass
- Errore: notifica con Basso

---

## Sintesi: Cosa Implementare

### OGGI (FASE 1)
1. **Heartbeat file** - Semplice, efficace
2. **Notifiche estese** - Gia' funzionante, solo estendere
3. **swarm-heartbeat command** - Aggregatore leggero

### PROSSIMO (FASE 2)
4. **Log strutturato** - Prefix [WORKER:name]
5. **Dashboard Rich** - Live refresh

### FUTURO (FASE 3)
6. **tmux split** - Dashboard + logs
7. **WebSocket observability** - Se serve pro

---

## Fonti Complete

1. Cronitor - Heartbeat Monitoring Guide
2. Estuary - Real-Time Monitoring Best Practices
3. Datadog - Live Process Monitoring
4. SigNoz - Open Source Log Management
5. Fiberplane - Fogwatch Real-time Log Viewing
6. Kloudfuse - Real-Time Log Monitoring 2025
7. CNCF - Kubernetes Logging Best Practices
8. Papertrail - Kubernetes Live Tail
9. PM2 - Log Management Documentation
10. GitHub Community - Actions Streaming Logs
11. Rich - Live Display Documentation
12. claude-code-hooks-multi-agent-observability

---

*"I pattern sono universali. L'implementazione e' nostra."*

Cervella & Rafa
