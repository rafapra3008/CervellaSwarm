# RICERCA: Edge Cases Sistema Multi-Agent CervellaSwarm

> **Data:** 8 Gennaio 2026
> **Autore:** cervella-researcher
> **Task ID:** TASK_RICERCA_EDGE_CASES
> **Versione:** 1.0.0

---

## EXECUTIVE SUMMARY

Questa ricerca documenta **tutti i possibili edge cases** e scenari problematici per CervellaSwarm, basandosi su:
1. Best practices da letteratura multi-agent 2025-2026
2. Known issues GIA documentati nel codebase
3. Pattern comuni da sistemi distribuiti

---

## 1. RACE CONDITIONS

### 1.1 File Concurrency

**Problema:** Due worker modificano lo stesso file contemporaneamente.

| Scenario | Rischio | CervellaSwarm Status |
|----------|---------|---------------------|
| Due worker Edit stesso .py | ALTO | PROTETTO da REGOLA 2 (UN FILE = UNA API) |
| Due worker leggono/scrivono .swarm/tasks/ | MEDIO | PARZIALE - file-based, no locking |
| Worker + Regina su PROMPT_RIPRESA.md | MEDIO | PROTETTO - solo Regina edita |

**Best Practice (Google ADK 2025):**
> "When using parallel agents, make sure each agent writes its data to a unique key. They share session state."

**Mitigazione CervellaSwarm:**
- REGOLA 2: "MAI DUE API SULLO STESSO FILE!"
- Worker scrivono SOLO su `TASK_*_output.md` con loro ID
- Regina coordina e verifica

**Test consigliato:**
```bash
# HARDTEST: Lanciare 2 worker sullo stesso file
# Verificare: chi vince? Si perdono dati?
spawn-workers --backend  # Task: edit api.py
spawn-workers --frontend # Task: edit api.py (stesso file!)
```

---

### 1.2 State Race in .swarm/tasks/

**Problema:** Worker A legge .ready, Worker B legge stesso .ready prima che A lo rimuova.

**Rischio:** BASSO (worker tipicamente in finestre separate con task diversi)

**Mitigazione attuale:**
1. Worker crea `.working` PRIMA di rimuovere `.ready`
2. Check atomico: se `.working` esiste, skip

**Gap identificato:**
- Nessun file locking esplicito
- Race window teorica di ~10ms

**Mitigazione proposta:**
```bash
# Usare flock per operazioni critiche
flock -n /tmp/swarm_task.lock -c "mv task.ready task.working"
```

---

## 2. DEADLOCK

### 2.1 Circular Wait tra Worker

**Scenario:**
- Backend aspetta output da Frontend (per API spec)
- Frontend aspetta output da Backend (per endpoint)

**Rischio:** BASSO (ordine esecuzione definito da REGOLA 3)

**REGOLA 3 CervellaSwarm:**
```
1. BACKEND PRIMA
2. FRONTEND DOPO
3. TESTER TERZO
4. REVIEWER ULTIMO
```

**Gap:** Se worker ignorano la regola o task non segue ordine standard.

**Test consigliato:**
```bash
# HARDTEST: Creare dipendenza circolare intenzionale
# TASK_A: "Leggi output di TASK_B"
# TASK_B: "Leggi output di TASK_A"
# Verificare: timeout? hang forever?
```

---

### 2.2 Lock Coupling (da letteratura)

**Definizione:** Acquisire multipli lock tenendo uno lock.

**Rischio in CervellaSwarm:** BASSO
- Non usiamo lock espliciti
- File-based communication non ha lock semantics

**Ma attenzione:** Se introducessimo database o Redis per coordination, questo diventerebbe critico.

---

## 3. TASK ORPHANI

### 3.1 .working Senza Processo

**Problema:** Worker crasha o viene killato. File `.working` resta.

**Status attuale:** DOCUMENTATO in `ISSUE_HEARTBEAT_FALSE_POSITIVE.md`

**Rilevamento:**
- `check-stuck.sh` controlla heartbeat
- Timeout 2 min = stuck detection

**Gap identificato:**
- Se heartbeat non parte (spawn-workers bug), false positive
- Se worker fa task lungo (11 Edit), false positive

**Mitigazione proposta (da issue):**
```bash
# Fix 1: Auto-start Heartbeat in spawn-workers
nohup scripts/swarm/heartbeat-worker.sh > /dev/null 2>&1 &
echo $! > .swarm/pids/heartbeat_${WORKER_NAME}.pid
```

---

### 3.2 .done Senza Output

**Problema:** Worker crea `.done` ma non scrive `_output.md`.

**Rischio:** MEDIO (Regina assume successo ma non ha dati)

**Test consigliato:**
```bash
# HARDTEST: Worker che fa touch .done senza scrivere output
# Regina: come reagisce?
```

**Mitigazione proposta:**
```python
# In watcher-regina.sh, verificare:
if [ -f "${TASK}.done" ] && [ ! -s "${TASK}_output.md" ]; then
    echo "WARNING: Task completato ma output vuoto!"
fi
```

---

## 4. CONFLITTI GIT

### 4.1 Merge Conflicts da Lavoro Parallelo

**Problema:** Worker in branch diversi modificano stesso file, merge conflict.

**Status CervellaSwarm:**
- Worktrees studiati ma NON implementati
- Attualmente: lavoro sequenziale o file separati

**Se worktrees attivati:**
```
Branch feature/backend + Branch feature/frontend
   \                     /
    \                   /
     \                 /
      --> MERGE <----
          CONFLICT!
```

**Mitigazione (da GUIDA_WORKTREES.md):**
- Assegnare file scope a ogni branch
- Review PRIMA di merge
- Fallback: Regina risolve manualmente

---

## 5. MEMORY/CONTEXT OVERFLOW

### 5.1 Context Compaction durante Task

**Problema:** Claude Code compatta context mentre worker sta lavorando.

**Rischio:** CRITICO (lavoro perso se in Task tool)

**Protezione attuale:**
- REGOLA 13: "VIETATO Task tool per cervella-*"
- Hook `block_task_for_agents.py` con exit 2

**Questo problema e RISOLTO dal design:**
- Worker in finestre separate = context ISOLATO
- Se Worker compatta, Regina NON e impattata
- AUTO-HANDOFF per passaggio consegne

---

### 5.2 MCP Token Overhead (da Anthropic 2025)

**Problema:** Tool definitions consumano token prima ancora di usarli.

**Dato reale:**
> "5-server setup with 58 tools consuming ~55K tokens before conversation starts"
> "At Anthropic, we've seen tool definitions consume 134K tokens before optimization"

**Rischio CervellaSwarm:** MEDIO
- 16 agent = 16 tool definitions
- Ogni spawn carica definizioni

**Mitigazione potenziale:**
- Lazy loading tool definitions
- Tool grouping per specializzazione

---

## 6. HOOK FAILURES

### 6.1 Exit Code Sbagliato

**Problema:** Hook ritorna exit 1 invece di exit 2 per bloccare.

**Status:** RISOLTO - Documentato in `ISSUE_HOOK_EXIT_CODE.md`

**Lezione:**
| Exit Code | Significato |
|-----------|-------------|
| 0 | OK - permetti |
| 1 | Errore generico - NON blocca! |
| **2** | **BLOCCO** |

---

### 6.2 Hook Crash

**Problema:** Hook Python crasha (exception non gestita).

**Rischio:** BASSO (Claude Code default = permetti)

**Test consigliato:**
```python
# HARDTEST: Hook che fa raise Exception()
# Verificare: azione passa o blocca?
```

---

## 7. NETWORK ISSUES

### 7.1 Connessione Cade durante Task

**Problema:** Internet cade mentre worker sta facendo WebSearch o WebFetch.

**Rischio:** BASSO
- Worker fa retry automatico (Claude Code built-in)
- Task fallisce gracefully

**Gap:** Nessun retry esplicito lato CervellaSwarm.

---

## 8. CONCURRENT SPAWNS

### 8.1 Troppi Worker Contemporanei

**Problema:** Regina spawna 10 worker, sistema rallenta o crasha.

**Rischio:** MEDIO (macOS puo gestire ~10 Terminal windows)

**Dati:**
- Ogni finestra Terminal.app: ~100MB RAM
- Ogni Claude Code: ~300MB RAM + API calls
- 10 worker = ~4GB RAM

**Mitigazione proposta:**
```bash
# In spawn-workers, aggiungere:
MAX_WORKERS=5
CURRENT=$(ls .swarm/tasks/*.working 2>/dev/null | wc -l)
if [ $CURRENT -ge $MAX_WORKERS ]; then
    echo "WARNING: Max workers reached ($MAX_WORKERS)"
    exit 1
fi
```

---

## 9. FILE LOCKING

### 9.1 Accesso Simultaneo ai File

**Problema:** Due processi scrivono stesso file, dati corrotti.

**Status CervellaSwarm:**
- Design evita problema (file separati per worker)
- REGOLA 2 previene sovrapposizione

**Ma attenzione a:**
- `.swarm/status/` files (heartbeat, worker status)
- `reports/` directory (se piu worker generano report)

**Mitigazione:**
```bash
# Usare nomi file con timestamp/PID
report_$(date +%Y%m%d_%H%M%S)_$$.json
```

---

## 10. STATE INCONSISTENCY

### 10.1 Stati Incoerenti

| Stato | File Presenti | Problema |
|-------|---------------|----------|
| READY | .md + .ready | OK |
| WORKING | .md + .working | OK |
| DONE | .md + .done + _output.md | OK |
| **BROKEN** | .md + .working + .done | **CHI HA VINTO?** |
| **ORPHAN** | .working senza processo | **STUCK** |
| **GHOST** | .done senza _output.md | **DATI PERSI** |

**Test consigliato:**
```bash
# HARDTEST: Creare stati incoerenti manualmente
touch TASK_TEST.working TASK_TEST.done
# Verificare: come reagisce il sistema?
```

---

## 11. BEST PRACTICES DA LETTERATURA 2025-2026

### 11.1 Google ADK Multi-Agent Patterns

1. **Start Simple:** Non costruire nested loop system al giorno 1
2. **Clear Roles:** Ogni agent ha UN ruolo chiaro
3. **Flexible Communication:** Protocolli adattabili
4. **Autonomy Balance:** Decidere quando agent puo procedere vs chiedere

**CervellaSwarm alignment:** ALTO (REGOLA 10 Decision Autonomy)

### 11.2 MAST Framework - Failure Modes

Paper 2025 "Why Do Multi-Agent LLM Systems Fail?" identifica:
1. **Weak Verification:** Verifier agent non cattura errori
2. **Communication Breakdown:** Agent non condividono context
3. **Cascade Failures:** Un errore propaga a tutti

**CervellaSwarm alignment:**
- REGOLA 4: Verifica Attiva Post-Agent
- REGOLA 6: Comunicazione via File
- REGOLA 9: Retry + Abort

### 11.3 Distributed Locking Best Practices

1. **Lock ordering:** Sempre stessa sequenza per evitare deadlock
2. **TTL/Lease:** Lock auto-expire per evitare stuck
3. **Avoid lock coupling:** Non acquisire lock tenendo altro lock

**Applicazione CervellaSwarm:**
- File `.working` e come un "lease" - ma senza TTL automatico
- Proposta: Aggiungere timestamp e auto-cleanup

---

## 12. SUGGERIMENTI PER HARDTEST

### HARDTEST Priorita ALTA

| # | Test | Cosa Verifica | Come |
|---|------|---------------|------|
| 1 | Race Condition File | 2 worker su stesso file | Spawn parallelo con stesso target |
| 2 | Task Orphan | .working senza processo | Kill worker mid-task |
| 3 | State Inconsistency | .done senza output | touch .done senza scrivere output |
| 4 | Hook Crash | Hook exception | Modificare hook per crash |

### HARDTEST Priorita MEDIA

| # | Test | Cosa Verifica | Come |
|---|------|---------------|------|
| 5 | Max Workers | Sistema sotto stress | Spawn 10 worker insieme |
| 6 | Circular Wait | Deadlock detection | Task A aspetta B, B aspetta A |
| 7 | Git Conflict | Merge conflict handling | 2 branch, stesso file, merge |

---

## 13. CONCLUSIONI

### Edge Cases GIA Gestiti

1. **Context compaction** - REGOLA 13 + spawn-workers
2. **File conflict** - REGOLA 2 (UN FILE = UNA API)
3. **Hook exit code** - Documentato e fixato
4. **Execution order** - REGOLA 3

### Edge Cases DA Monitorare

1. **Task orphani** - Heartbeat false positive documentato
2. **State inconsistency** - Nessun auto-cleanup
3. **Max workers** - Nessun limite esplicito

### Edge Cases DA Implementare Protezione

1. **File locking** per operazioni critiche
2. **TTL per .working** files
3. **Validation .done** con output

---

## RIFERIMENTI

### Fonti Web (2025-2026)

- [Google ADK Multi-Agent Patterns](https://developers.googleblog.com/developers-guide-to-multi-agent-patterns-in-adk/)
- [Why Multi-Agent LLM Systems Fail (MAST)](https://arxiv.org/html/2503.13657v1)
- [Distributed Locking Practical Guide](https://www.architecture-weekly.com/p/distributed-locking-a-practical-guide)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Deadlock in Distributed Systems](https://www.geeksforgeeks.org/computer-networks/deadlock-handling-strategies-in-distributed-system/)

### File Interni CervellaSwarm

- `docs/SWARM_RULES.md` - Regole dello sciame
- `docs/known-issues/ISSUE_HEARTBEAT_FALSE_POSITIVE.md` - Heartbeat issue
- `docs/known-issues/ISSUE_HOOK_EXIT_CODE.md` - Exit code issue

---

*"Nulla e complesso - solo non ancora studiato!"*

**cervella-researcher** - 8 Gennaio 2026
