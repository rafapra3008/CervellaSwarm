# Studio Visibilita Worker - Guardiana Ricerca

**Data:** 05 Gennaio 2026
**Autore:** cervella-guardiana-ricerca
**Versione:** 1.0.0

---

## PARTE 1: La Mia Ricerca Indipendente

### 1. Analisi del Problema

Il problema centrale e' che lavoriamo "al buio" - quando un worker viene spawnato in una finestra Terminal separata, non abbiamo:

1. **Visibilita' LIVE**: Cosa sta facendo il worker in questo momento?
2. **Progress tracking**: A che punto e' del task?
3. **Alerting proattivo**: Il worker e' bloccato? Ha finito? Ha errori?

Attualmente abbiamo:
- `.swarm/status/worker_NAME.pid` - PID del processo
- `.swarm/status/worker_NAME.start` - Timestamp avvio
- `.swarm/logs/worker_TIMESTAMP.log` - Log COMPLETO dopo esecuzione

Ma NON abbiamo:
- Streaming live del log
- Notifiche di progresso
- Dashboard real-time dei contenuti

---

### 2. Come Fanno i Sistemi Professionali

#### A. CI/CD Pipelines (GitHub Actions, Jenkins)

**GitHub Actions** ha introdotto nel 2024/2025:
- **Streaming logs con backscroll**: Le ultime 1000 righe sono visibili anche quando arrivi a meta' job
- **Live tail automatico**: La pagina si aggiorna automaticamente
- **Job grouping**: Ogni step e' collassabile

**Limitazione API**: L'API di GitHub NON fornisce log real-time! Ritorna 404 mentre il job e' in corso. Solo dopo completion i log sono disponibili via API.

**Lezione**: Anche sistemi enterprise hanno questo problema! La soluzione di GitHub e' puramente UI-based (websocket nel browser).

#### B. Kubernetes (kubectl logs)

**Best practices 2025**:
- `kubectl logs -f` per streaming
- **Stern/Kubetail** per multi-pod aggregation
- **Sidecar containers** per log non-stdout

**Tools specializzati**:
- **Stern**: Color-coded output, regex filtering
- **Kail**: Raw e JSON output
- **Kubetail**: Aggregazione multi-pod

**Lezione**: La soluzione standard e' `tail -f` equivalente, con tools di aggregazione.

#### C. PM2 (Process Manager)

PM2 ha la soluzione piu' elegante:
- `pm2 logs` - Stream real-time
- `pm2 logs --json` - Stream strutturato
- `pm2 monit` - Dashboard TUI con CPU/memory
- **PM2 Plus** - Dashboard web cloud (a pagamento)

**Lezione**: Il pattern e' sempre lo stesso - file di log + tail + UI opzionale.

#### D. tmux (Multiplexer)

**tmux ha feature native**:
- `pipe-pane` - Redirect output a file/comando
- Alerts per activity/bell
- Split panes per monitoring multiplo

**TmuxTop** - Tool che mostra metriche per ogni pane.

**Lezione**: tmux puo' catturare output e inviarlo dove vogliamo.

---

### 3. Cosa Possiamo Fare con Claude Code

#### Limitazioni Note

1. **No WebSocket nativo**: Non possiamo fare streaming a browser
2. **No API di interrogazione**: Non possiamo chiedere "cosa sta facendo?"
3. **Hooks sono event-based**: Solo PreToolUse, PostToolUse, SubagentStop

#### Workaround Possibili

**Opzione A: tail -f del log file**
```bash
# La Regina puo' fare:
tail -f .swarm/logs/worker_*.log
```
Pro: Semplice, funziona
Contro: Rumoroso, mostra TUTTO

**Opzione B: Log strutturato + parser**
```bash
# Worker scrive:
echo "[PROGRESS] 50% - Analizzando file X" >> progress.log
# Dashboard legge:
tail -f progress.log | grep PROGRESS
```
Pro: Pulito, filtrabile
Contro: Richiede modifica ai worker

**Opzione C: File di heartbeat**
```bash
# Worker ogni 30 secondi:
echo "$(date +%s):Sto analizzando X" > .swarm/status/worker_NAME.heartbeat
# Monitor:
watch -n 5 cat .swarm/status/worker_*.heartbeat
```
Pro: Leggero, non intrusivo
Contro: Non e' streaming vero

**Opzione D: Named pipes (FIFO)**
```bash
mkfifo /tmp/worker_frontend.pipe
# Worker scrive la':
claude ... 2>&1 | tee /tmp/worker_frontend.pipe
# Monitor legge:
cat /tmp/worker_frontend.pipe
```
Pro: Vero streaming
Contro: Complesso, rischio di blocco se nessuno legge

---

### 4. Hooks Disponibili in Claude Code

| Hook | Quando | Payload |
|------|--------|---------|
| PreToolUse | Prima di ogni tool | Tool name, params |
| PostToolUse | Dopo tool completato | Tool name, result |
| Stop | Fine risposta Claude | Full output |
| SubagentStop | Fine subagent | Output subagent |
| Notification | Notifica | Message |

**Possibilita' interessante**:
Un hook `PostToolUse` potrebbe scrivere un log strutturato:
```json
{
  "timestamp": "2026-01-05T05:15:00",
  "tool": "Edit",
  "file": "src/app.py",
  "worker": "backend"
}
```

Ma: Gli hooks girano DENTRO la sessione Claude. Non possono "uscire" per notificare la Regina in modo sincrono.

---

### 5. La Mia Raccomandazione

#### Soluzione IMMEDIATA (oggi)

1. **tail -f centralizzato**:
   - Modifica `spawn-workers.sh` per usare un singolo log aggregato
   - La Regina puo' fare `tail -f .swarm/logs/aggregated.log`

2. **Heartbeat file**:
   - Ogni worker scrive heartbeat ogni 30s
   - Dashboard mostra: "Worker X: attivo 15s fa - Analizzando Y"

#### Soluzione INTERMEDIA (1-2 sessioni)

3. **Log strutturato con prefix**:
   - Ogni output di worker ha prefix `[WORKER:backend] ...`
   - Tool di parsing che estrae e colora

4. **Dashboard enhanced**:
   - Aggiungi sezione "Live Activity" che legge heartbeat
   - Mostra "ultimo messaggio" da ogni worker

#### Soluzione IDEALE (futuro)

5. **TUI dedicata con tmux**:
   - Split screen: sinistra = dashboard, destra = log aggregato
   - Ogni worker in un pane tmux

6. **Hook-based observability**:
   - Usa il progetto [claude-code-hooks-multi-agent-observability](https://github.com/disler/claude-code-hooks-multi-agent-observability)
   - WebSocket server + Vue client per real-time

---

### 6. Analisi Costi/Benefici

| Soluzione | Effort | Impatto | Raccomandazione |
|-----------|--------|---------|-----------------|
| tail -f centralizzato | Basso | Medio | SI - Oggi |
| Heartbeat file | Basso | Medio | SI - Oggi |
| Log strutturato | Medio | Alto | SI - Prossima sessione |
| Dashboard enhanced | Medio | Alto | SI - Prossima sessione |
| TUI tmux | Alto | Molto Alto | Futuro |
| WebSocket observability | Alto | Molto Alto | Futuro (quando serve) |

---

## PARTE 2: Comparativo con Researcher

### Status

Il researcher (TASK_20260105_051500_studio_visibilita_researcher) e' ancora in fase `.working`.
Non ha ancora prodotto output.

**Azione richiesta**: Quando il researcher completa, la Regina dovra':
1. Creare un nuovo task per la Guardiana
2. Richiedere comparativo e sintesi finale

### Note per Comparativo Futuro

Punti chiave da confrontare:
1. Ha identificato le stesse soluzioni (tail -f, heartbeat, hooks)?
2. Ha trovato tools diversi?
3. Quali sono le sue priorita'?
4. C'e' convergenza sulla raccomandazione?

---

## PARTE 3: Sintesi Finale

### Status

In attesa di PARTE 2 per completare sintesi.

### Raccomandazione Provvisoria (Solo Guardiana)

Basandomi SOLO sulla mia ricerca:

**PRIORITA' 1 - OGGI:**
1. Implementare heartbeat file (30 secondi)
2. Dashboard mostra "ultimo heartbeat" per worker

**PRIORITA' 2 - PROSSIMA SESSIONE:**
3. Log strutturato con prefix [WORKER:name]
4. tail -f aggregato accessibile dalla Regina

**PRIORITA' 3 - FUTURO:**
5. Valutare claude-code-hooks-multi-agent-observability
6. TUI con tmux se serve monitoring professionale

---

## Checklist Completamento

- [x] Ricerca indipendente completata
- [x] Soluzioni documentate con pro/contro
- [x] Raccomandazione scritta
- [ ] Comparativo con researcher (IN ATTESA)
- [ ] Sintesi finale combinata (IN ATTESA)
- [x] Output scritto in _output.md

---

## Fonti

### Ricerca Web

- [SigNoz - Open Source Log Management](https://signoz.io/blog/open-source-log-management/)
- [Fiberplane - Fogwatch Real-time Log Viewing](https://fiberplane.com/blog/fogwatch/)
- [Kloudfuse - Real-Time Log Monitoring 2025](https://www.kloudfuse.com/blog/real-time-log-monitoring-tools)
- [TmuxTop - Tmux Process Monitoring](https://github.com/marlocarlo/tmuxtop)
- [Efficient Process Monitoring with Tmux](https://medium.com/@notdefine/efficient-process-monitoring-with-tmux-real-time-progress-display-for-multistep-tasks-77efce79e181)
- [CNCF - Kubernetes Logging Best Practices](https://www.cncf.io/blog/2023/07/03/kubernetes-logging-best-practices/)
- [Papertrail - Kubernetes Live Tail](https://www.papertrail.com/blog/how-to-live-tail-kubernetes-logs/)
- [PM2 Log Management](https://pm2.keymetrics.io/docs/usage/log-management/)
- [PM2 Plus Real-time Logs](https://pm2.io/docs/plus/guide/realtime-logs/)
- [GitHub Actions Streaming Logs](https://github.com/orgs/community/discussions/89879)
- [Claude Code Hooks Reference](https://code.claude.com/docs/en/hooks)
- [Claude Code Hooks Multi-Agent Observability](https://github.com/disler/claude-code-hooks-multi-agent-observability)

---

*Studio completato dalla Guardiana Ricerca - Parte 1*
*"Verifico qualita' e affidabilita' delle ricerche dello sciame!"*
