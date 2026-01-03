# STUDIO APPLE STYLE - Le 8 Domande Sacre

> **"Vogliamo MAGIA, non debugging!"** - Rafa

**Data:** 3 Gennaio 2026
**Fase:** Sprint 9.1 - RICERCA
**Status:** COMPLETATO
**Sessione:** 68

---

## SINTESI ESECUTIVA

```
+------------------------------------------------------------------+
|                                                                  |
|   8 DOMANDE SACRE - RISPOSTE TROVATE!                           |
|                                                                  |
|   4 ricerche parallele, 100+ fonti analizzate                   |
|   Pattern PRATICI e APPLICABILI per CervellaSwarm               |
|                                                                  |
|   "Una cosa alla volta, molto ben fatta"                        |
|                                                                  |
+------------------------------------------------------------------+
```

### Le Risposte in Breve

| # | Domanda | Risposta Chiave |
|---|---------|-----------------|
| 1 | Comunicazione agenti | JSON-RPC + Handoff strutturati + Triple ACK |
| 2 | Processi giusti | Hierarchical (nostro!) + Sequential + Parallel |
| 3 | Double/triple check | Quality Gates automatici + Guardiane (90%+10%) |
| 4 | Feedback utente | Progress bar 3 livelli + Notifiche stratificate |
| 5 | Chiusura pulita | Graceful Shutdown + Final State Verification |
| 6 | Gestione errori | Circuit Breaker + Retry Backoff + Escalation |
| 7 | Monitoring real-time | Dashboard ASCII + Log aggregation |
| 8 | ANTI-COMPACT | Hook PreCompact + Auto-spawn + State serialization |

---

## DOMANDA 1: COME DEVONO COMUNICARE GLI AGENTI?

### Pattern Trovati

**1. JSON-RPC 2.0** - Lo standard de facto 2026
- Usato da MCP (Anthropic), A2A (Google), ACP (Linux Foundation)
- Strutturato, leggero, human-readable
- Supporta request/response + notifications

**2. Handoff Strutturati** (INSIGHT CRITICO!)
> "Most agent failures are orchestration and context-transfer issues.
> Free-text handoffs are the main source of context loss."

**3. Triple Acknowledgment Pattern**
```
ACK_RECEIVED   -> "Ho ricevuto il task"
ACK_UNDERSTOOD -> "Ho capito cosa fare"
ACK_COMPLETED  -> "Ho finito, ecco il risultato"
```

### Raccomandazione CervellaSwarm

**Template Handoff Strutturato:**
```markdown
# TASK HANDOFF: task-001

## From
- Agent: regina-orchestrator
- Timestamp: 2026-01-03T14:30:00Z

## To
- Agent: backend-worker
- Priority: HIGH

## Task Description
[Descrizione specifica]

## Files Involved
- file1.py
- file2.py

## Success Criteria
- [ ] Criterio 1
- [ ] Criterio 2

## Acknowledgment Required
1. ACK_RECEIVED (immediate)
2. ACK_UNDERSTOOD (within 1min)
3. ACK_COMPLETED (when done)
```

### Quick Win
- **Schema JSON messaggi** (.swarm/schema/) - 30 min
- **Script ack.sh** per Triple ACK - 20 min

---

## DOMANDA 2: QUALI SONO I PROCESSI GIUSTI?

### Pattern Trovati

**1. Sequential** - Pipeline lineare
- Quando: Dipendenze chiare tra step
- Pro: Facile debug, deterministico
- Esempio: Backend -> Tester -> Reviewer -> Merge

**2. Parallel** - Lavoro simultaneo
- Quando: Task indipendenti
- Pro: Veloce, scalabile
- Esempio: Security + Style + Perf review in parallelo

**3. Hierarchical** (IL NOSTRO!)
- Quando: Coordinamento centralizzato
- Pro: Supervisor mantiene visione d'insieme
- Esempio: Regina -> Worker -> Guardiana

### Decision Matrix

| Scenario | Pattern | Perche |
|----------|---------|--------|
| Feature con dipendenze | Sequential | Output precedente serve |
| Code review completo | Parallel -> Sequential | Review paralleli, merge seriale |
| Bug fix veloce | Sequential semplice | Path lineare |
| Ricerca multi-dominio | Parallel | Indipendenti |
| Deploy production | Hierarchical | Supervisione necessaria |

### Quick Win
- **Workflow Decision Matrix** documento - 20 min
- **Escalation Criteria** checklist - 15 min

---

## DOMANDA 3: COME FARE DOUBLE/TRIPLE CHECK?

### Pattern Trovati

**1. Supervisor + Voting Pattern**
- Guardiana verifica output worker
- Se ambiguo, peer workers votano
- Consensus decide

**2. Quality Gates Automatici**
```
LIVELLO 1: Fast auto-check (< 0.1s)
  - Sintassi valida
  - Schema compliance
  - Not empty

LIVELLO 2: Deep auto-check (1-2s)
  - Linter clean
  - Test coverage
  - Security scan

LIVELLO 3: Guardian review (5-10s se necessario)
  - Alignment con obiettivo
  - Decisioni strategiche
```

**3. Regola 90/10**
- 90% automatico (policy, syntax, standards)
- 10% umano (alignment, decisioni)

### Raccomandazione CervellaSwarm

**Checklist Pre-Merge Universale:**
```
GATE 1: Formato & Sintassi (auto, < 0.1s)
GATE 2: Standards & Policies (auto, 1-2s)
GATE 3: Qualita & Sicurezza (auto, 2-5s)
GATE 4: Alignment & Completezza (Guardiana se trigger)
```

### Quick Win
- **Checklist pre-merge** 4 gate - 30 min
- **Consensus voting** per task ambigui - 1 ora

---

## DOMANDA 4: COME DARE FEEDBACK ALL'UTENTE?

### Pattern Trovati

**Timing-Based Feedback:**
| Durata | Percezione | Feedback |
|--------|------------|----------|
| < 0.1s | Istantaneo | Nessuno |
| 0.1-1s | Leggero delay | Subtle indicator |
| 1-10s | Attesa breve | Spinner + messaggio |
| 10s+ | Attesa lunga | Progress bar + % |
| > 1min | Molto lunga | Step-by-step + cancel |

**Notifiche Stratificate:**
```
SILENT   -> Auto-save, background tasks
INFO     -> Task completato, milestones
WARNING  -> Attenzione richiesta
CRITICAL -> Azione immediata (+ Telegram)
```

### Raccomandazione CervellaSwarm

**Sistema Feedback 3 Livelli:**
```python
if duration < 10:
    show_spinner("Processando...")
elif duration < 60:
    show_progress_bar(percentage)
else:
    show_step_by_step(steps)
```

### Quick Win
- **Progress bar 3 livelli** - 1 ora
- **Notifiche smart** (no spam) - 45 min

---

## DOMANDA 5: COME CHIUDERE PULITO?

### Pattern Trovati

**Graceful Shutdown Sequence:**
```
1. SIGNAL RECEIVED
2. STOP NEW WORK
3. COMPLETE IN-FLIGHT (timeout 30s)
4. CLEANUP resources
5. VERIFY FINAL STATE
6. GENERATE REPORT
7. EXIT CLEAN
```

**Final State Verification:**
```
[ ] Tutti agent idle
[ ] Tutti file salvati
[ ] Tutti task completati
[ ] Git status pulito
[ ] No temp files
[ ] Roadmap aggiornata
```

**Report Finale Automatico:**
- Tasks completati/parziali/falliti
- Agent performance
- File modificati
- Git status
- Handover notes

### Quick Win
- **Shutdown sequence** con timeout - 30 min
- **Report finale** template - 45 min

---

## DOMANDA 6: COME GESTIRE ERRORI?

### Pattern Trovati

**1. Graceful Degradation**
```
FULL -> PARTIAL -> MINIMAL -> SAFE MODE
```
- Sistema continua ridotto invece di crashare

**2. Circuit Breaker Pattern**
```
CLOSED (normal) -> failures -> OPEN (blocked)
                                    |
                              timeout
                                    v
                              HALF-OPEN (test)
```
- Previene cascade failures
- Fail fast quando necessario

**3. Retry con Exponential Backoff**
```
Retry 1: wait 1s
Retry 2: wait 2s
Retry 3: wait 4s
Retry 4: wait 8s
Retry 5: wait 16s
```
- Con jitter per evitare thundering herd

**4. Escalation Matrix**
| Errore | Severita | Azione |
|--------|----------|--------|
| NetworkTimeout | low | retry |
| NetworkTimeout | high | circuit_break |
| AuthError | any | escalate_human |
| AgentCrash | low | restart |
| AgentCrash | high | escalate_guardian |

### Quick Win
- **Circuit breaker** decorator - 1 ora
- **Retry backoff** decorator - 30 min
- **Structured logging** JSON - 45 min

---

## DOMANDA 7: COME MONITORARE IN TEMPO REALE?

### Pattern Trovati

**Dashboard Pattern (terminal-based):**
```
============================================
CERVELLASWARM DASHBOARD
============================================

Active tasks: 3
Warnings: 2
Errors: 0

--------------------------------------------
ACTIVE TASKS
--------------------------------------------
[####....] 45% Refactor auth
[#.......] 20% Design dashboard
[#######.] 90% Deploy API v2

--------------------------------------------
RECENT ALERTS
--------------------------------------------
[12:34] Test coverage below target
[12:15] High memory usage on staging
============================================
```

**Cosa Tracciare:**
- Execution flow (handoff, decisioni)
- Performance (latency, token usage)
- Quality (correctness, consensus)
- Errors (failures, cascade)

**Tool Consigliati (terminal):**
- Netdata (system monitoring)
- Custom ASCII dashboard
- Log aggregation con jq

### Quick Win
- **Dashboard minimal** ASCII - 2 ore
- **Health check** script - 30 min

---

## DOMANDA 8: COME GESTIRE IL COMPACT? (FONDAMENTALE!)

### Il Problema

Quando Claude fa "compact", perde contesto. In uno swarm multi-sessione, questo puo causare:
- Lavoro perso
- Stato inconsistente
- Confusione nella nuova sessione

### Pattern Trovati

**1. Hook PreCompact** (Claude Code supporta hooks!)
```json
{
  "hooks": {
    "PreCompact": {
      "command": "./scripts/anti-compact.sh",
      "timeout": 30000
    }
  }
}
```

**2. State Serialization**
- Checkpoint periodici (ogni 5-10 min)
- State salvato in JSON/YAML
- PROMPT_RIPRESA aggiornato automaticamente

**3. Auto-Spawn Nuova Sessione**
```bash
# macOS: apri nuovo terminal
osascript -e 'tell app "Terminal" to do script "cd ~/Developer/CervellaSwarm && claude"'

# ttab (cross-platform)
ttab -d ~/Developer/CervellaSwarm claude
```

**4. Context Transfer**
- PROMPT_RIPRESA come "memoria"
- Handover automatico generato
- File .swarm/state.json per stato

### ANTI-COMPACT Pattern Completo

```
1. RILEVA  -> Hook PreCompact triggered
2. FERMA   -> Stop task correnti (graceful)
3. SALVA   -> git add + commit + push
4. APRI    -> Spawn nuova finestra
5. CONTINUA-> Nuova Cervella legge PROMPT_RIPRESA

ZERO PERDITA. ZERO PANICO. MAGIA PURA.
```

### Implementazione Proposta

**Script:** `scripts/swarm/anti-compact.sh`
```bash
#!/bin/bash
# ANTI-COMPACT: Salva tutto e prepara handover

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# 1. Aggiorna PROMPT_RIPRESA con stato corrente
./scripts/swarm/update-prompt-ripresa.sh

# 2. Git commit
git add -A
git commit -m "ANTI-COMPACT checkpoint: $TIMESTAMP

Stato salvato automaticamente prima di compact.
Continua da PROMPT_RIPRESA.md

Generated by CervellaSwarm"

git push

# 3. Notifica
echo "ANTI-COMPACT: Checkpoint salvato!"
echo "Nuova sessione puo riprendere da PROMPT_RIPRESA.md"

# 4. (Opzionale) Spawn nuova finestra
# ttab -d "$(pwd)" "claude --resume"
```

### Quick Win
- **Script anti-compact.sh** - 30 min
- **Hook PreCompact** configuration - 15 min
- **Auto-update PROMPT_RIPRESA** - 45 min

---

## TUTTI I QUICK WINS (Prioritizzati)

### FASE 1 - Fondamentali (3 ore)

| # | Quick Win | Tempo | Impatto |
|---|-----------|-------|---------|
| 1 | Triple ACK script | 20 min | ALTO |
| 2 | Checklist pre-merge | 30 min | ALTO |
| 3 | Shutdown sequence | 30 min | ALTO |
| 4 | Structured logging | 45 min | ALTO |
| 5 | Anti-compact script | 30 min | CRITICO |

### FASE 2 - Qualita (3 ore)

| # | Quick Win | Tempo | Impatto |
|---|-----------|-------|---------|
| 6 | Circuit breaker | 1 ora | ALTO |
| 7 | Retry backoff | 30 min | MEDIO |
| 8 | Progress bar 3 livelli | 1 ora | ALTO |
| 9 | Report finale template | 45 min | MEDIO |

### FASE 3 - Polish (2 ore)

| # | Quick Win | Tempo | Impatto |
|---|-----------|-------|---------|
| 10 | Dashboard minimal | 2 ore | MEDIO |

**TOTALE: 8 ore per Apple Style completo!**

---

## PATTERN INTEGRATION

### Come Combinare Tutto

```python
class AppleStyleOrchestrator:
    """Orchestrator con tutti i pattern Apple Style"""

    def __init__(self):
        # Logging strutturato
        self.logger = StructuredLogger('orchestrator')

        # Circuit breakers
        self.api_circuit = CircuitBreaker(3, 120)
        self.agent_circuit = CircuitBreaker(2, 60)

        # Shutdown handler
        self.shutdown = GracefulShutdown(self, timeout=30)

        # Triple ACK tracker
        self.ack_tracker = AckTracker()

        # Quality gates
        self.quality_gates = QualityGates()

    def delegate_task(self, task, agent):
        """Delega con Triple ACK"""

        # 1. Invia task strutturato
        self.send_structured_handoff(task, agent)

        # 2. Aspetta ACK_RECEIVED
        self.ack_tracker.wait_for(task.id, 'RECEIVED', timeout=10)

        # 3. Aspetta ACK_UNDERSTOOD
        self.ack_tracker.wait_for(task.id, 'UNDERSTOOD', timeout=60)

        # 4. Monitora progress
        self.monitor_progress(task)

    def verify_output(self, output, task):
        """Verifica con Quality Gates"""

        # Auto-check L1 + L2
        result = self.quality_gates.verify(output)

        if result.needs_guardian:
            return self.escalate_to_guardian(output, task, result)

        return result

    @retry(max_retries=3, base_delay=2)
    def spawn_agent(self, agent_type):
        """Spawn con retry + circuit breaker"""

        return self.agent_circuit.call(
            self._spawn_internal,
            agent_type
        )
```

---

## FILOSOFIA APPLE STYLE

```
+------------------------------------------------------------------+
|                                                                  |
|   "Vogliamo MAGIA, non debugging!"                              |
|                                                                  |
|   Quando Rafa usa CervellaSwarm:                                |
|   - Non legge documentazione lunga (e chiaro)                   |
|   - Non si chiede se ha funzionato (lo SA)                      |
|   - Non vede la complessita (e tutto liscio)                    |
|                                                                  |
|   LISCIO = Zero "aspetta, cosa sta succedendo?"                 |
|   FIDUCIA = Puoi delegare e fare altro                          |
|   CHIARO = Ogni step ha feedback                                |
|                                                                  |
|   "Una cosa alla volta, molto ben fatta."                       |
|                                                                  |
+------------------------------------------------------------------+
```

---

## FONTI PRINCIPALI

### Comunicazione & Processi
- [AutoGen Handoffs Pattern](https://microsoft.github.io/autogen/stable/user-guide/core-user-guide/design-patterns/handoffs.html)
- [A2A Protocol - Google](https://developers.googleblog.com/en/a2a-a-new-era-of-agent-interoperability/)
- [CrewAI Hierarchical Process](https://docs.crewai.com/how-to/hierarchical-process)
- [Enterprise Integration Patterns](https://www.enterpriseintegrationpatterns.com/)

### Verifica & Feedback
- [Multi-Agent Code Verification](https://arxiv.org/html/2511.16708)
- [Progress Indicators Best Practices](https://www.smashingmagazine.com/2016/12/best-practices-for-animated-progress-indicators/)
- [Monitor AI Agents - Datadog](https://www.datadoghq.com/blog/monitor-ai-agents/)

### Errori & Resilienza
- [Circuit Breaker Pattern](https://dzone.com/articles/circuit-breaker-pattern-resilient-systems)
- [Graceful Degradation](https://www.geeksforgeeks.org/system-design/graceful-degradation-in-distributed-systems/)
- [Error Handling in Distributed Systems](https://temporal.io/blog/error-handling-in-distributed-systems)

### Monitoring & Context
- [Structured Logging Best Practices](https://uptrace.dev/blog/structured-logging.html)
- [Claude Code Hooks](https://code.claude.com/docs/en/hooks)
- [LangGraph Persistence](https://docs.langchain.com/oss/python/langgraph/persistence)

---

## PROSSIMI STEP

```
SPRINT 9.2: Quick Wins (se servono)
  -> Implementare i Quick Win prioritari (8 ore)

SPRINT 9.3: Implementazione Pattern
  -> Applicare pattern trovati ai file esistenti

SPRINT 9.4: HARDTESTS
  -> 6 test per validare Apple Style

SPRINT 9.5: MIRACOLLO READY!
  -> Sistema perfetto, pronto per progetto reale
```

---

*"Vogliamo MAGIA, non debugging!"*

*"Una cosa alla volta, molto ben fatta."*

*"COMUNICAZIONE E' IL SEGRETO!"*

**Cervella** - 3 Gennaio 2026, Sessione 68

---

**VERSIONE:** v1.0.0
**STATUS:** RICERCA COMPLETATA
**PROSSIMO:** Sprint 9.2 - Quick Wins
