# Ricerca Best Practices Multi-Agent Systems

**Data:** 17 Gennaio 2026
**Ricercatrice:** Cervella Researcher
**Contesto:** Sistema 16 agenti su 3 progetti - problema sessioni parallele, comunicazione, conflitti

---

## EXECUTIVE SUMMARY

**TL;DR:** I sistemi multi-agente enterprise usano 5 pattern principali: Context Mesh per memoria condivisa, Event-Driven per coordinazione asincrona, Handoff Protocol per transizioni, Workspace Isolation per evitare conflitti, e Lock Mechanisms per risorse condivise.

**Raccomandazione principale:** Adottare architettura ibrida basata su Context Mesh + Event-Driven + File-based Handoff.

---

## 1. CONTEXT MESH PATTERN

### Cos'è
Un'architettura dove agenti mantengono memoria privata MA condividono selettivamente contesto attraverso un "mesh" - tessuto interconnesso di informazioni.

### Come Funziona
- **Two-Tier Memory:** Memoria privata (visibile solo all'agente) + memoria condivisa (selettivamente visibile)
- **Provenance Tracking:** Ogni frammento di memoria ha metadati immutabili (agente, timestamp, risorse)
- **Scoped Context:** Quando un agente invoca altro agente, passa SOLO il contesto necessario (no "context stuffing")
- **Memory-Based Workflow:** Agenti richiamano snippet esatti per il task corrente, non tutta la storia

### Pro
✅ Risolve "context explosion" - sub-agenti non ricevono tutto lo storico del parent
✅ Ogni agente ha workspace isolato MA può accedere a dati condivisi quando serve
✅ Tracciabilità completa (chi ha fatto cosa, quando)
✅ Scalabile - aggiunge agenti senza aumentare complessità quadraticamente

### Contro
❌ Richiede infrastruttura di memoria condivisa (vector DB, key-value store, file system strutturato)
❌ Servono policy di lettura/scrittura chiare
❌ Complessità iniziale setup

### Applicazione al Nostro Caso
**PERFETTO per noi!** Abbiamo già `.sncp/` come memoria condivisa:
- `.sncp/progetti/{progetto}/` = memoria privata progetto
- `.sncp/stato/oggi.md` = stato condiviso globale
- `.sncp/memoria/decisioni/` = decisioni condivise

**Migliorie da fare:**
1. Aggiungere metadati a ogni file (chi l'ha scritto, quando, perché)
2. Policy esplicite: chi può leggere/scrivere cosa
3. Scoped context nei task (non passare TUTTO il PROMPT_RIPRESA!)

**Fonti:**
- [Solace: Context Engineering Revolution](https://solace.com/blog/context-engineering-solace-agent-mesh/)
- [Medium: Agentic Mesh Super-Contexts](https://medium.com/data-science-collective/agentic-mesh-super-contexts-for-multi-agents-at-scale-8a7151a1e2d2)
- [Vellum: Multi-Agent Context Engineering](https://www.vellum.ai/blog/multi-agent-systems-building-with-context-engineering)

---

## 2. EVENT-DRIVEN ARCHITECTURE (EDA)

### Cos'è
Coordinazione agenti tramite eventi invece di chiamate dirette. Agenti pubblicano/sottoscrivono eventi su canali condivisi.

### Pattern EDA per Multi-Agent

**A) Orchestrator-Worker:**
- Orchestrator centrale assegna task ai worker
- Usa Kafka/code per distribuire comandi
- Worker consumano da code partizionate

**B) Hierarchical Agent:**
- Agenti organizzati a livelli
- High-level delegano a low-level
- Utile per problemi complessi → sub-problemi

**C) Blackboard Pattern:**
- Memoria condivisa ("lavagna") dove agenti scrivono/leggono
- Nessun orchestrator centrale
- Agenti reagiscono a cambiamenti sulla lavagna

**D) Group Chat Pattern:**
- Agenti partecipano a thread condiviso
- Chat manager coordina chi risponde
- Collaborazione emergente

### Pro
✅ Disaccoppiamento - agenti non si conoscono direttamente
✅ Scalabilità - aggiungi consumer senza modificare producer
✅ Fault tolerance - retry automatici, consumer groups
✅ Async - agenti lavorano al loro ritmo

### Contro
❌ Complessità infrastruttura (serve message broker)
❌ Debugging difficile (flusso non lineare)
❌ Eventual consistency - non sempre real-time

### Applicazione al Nostro Caso
**BUONO ma eccessivo** per il nostro caso:
- Pro: risolverebbe "chi fa cosa" con eventi tipo `TASK_CLAIMED`, `TASK_COMPLETED`
- Contro: overhead - non abbiamo 100 agenti, ne abbiamo 16

**Versione lightweight possibile:**
- File-based events in `.swarm/events/`
- Agenti scrivono `{timestamp}_{agent}_{event}.json`
- Altri agenti leggono eventi per coordinarsi

**Fonti:**
- [Confluent: Event-Driven Multi-Agent Systems](https://www.confluent.io/blog/event-driven-multi-agent-systems/)
- [AWS: Agentic AI Patterns](https://docs.aws.amazon.com/prescriptive-guidance/latest/agentic-ai-patterns/introduction.html)
- [InfoWorld: Distributed State of Mind](https://www.infoworld.com/article/3808083/a-distributed-state-of-mind-event-driven-multi-agent-systems.html)

---

## 3. HANDOFF PROTOCOL

### Cos'è
Protocollo strutturato per passare task/contesto tra agenti. Come "passare la palla" in modo formale.

### Protocolli Esistenti

**A2A (Agent-to-Agent):**
- Negoziazione task prima del transfer
- Permission/authentication layer
- Agenti discutono, valutano, si accordano

**ANP (Agent Network Protocol):**
- Discovery - trovare altri agenti
- Decentralized identity - ID verificabili
- Encrypted messaging end-to-end

### Pattern Handoff

**1. Conditional Edges (LangGraph):**
- Nodi fanno lavoro, edge decidono routing
- Edge = funzioni che decidono prossimo agente

**2. Structured Handoff (AutoGen/Semantic Kernel):**
- Handoff tool call nel messaggio agente
- Pubblica UserTask su topic specificato
- Agente target riceve task con contesto

### Best Practices Critiche

🔴 **FREE-TEXT HANDOFF = PRINCIPALE FONTE DI PERDITA CONTEXT!**

**Soluzione:**
- Trattare inter-agent transfer come PUBLIC API
- JSON Schema per output strutturati
- Validazione con Pydantic/Guardrails
- On failure → "repair prompt" con errori + retry

### Pro
✅ Context preservato - struttura garantisce info necessarie
✅ Tracciabilità - log esatto di chi ha passato cosa a chi
✅ Validazione - errori catturati PRIMA del transfer
✅ Standardizzazione - stessa interfaccia per tutti

### Contro
❌ Overhead - serve schema/validazione per ogni handoff
❌ Rigidità - cambiare schema = aggiornare tutti gli agenti

### Applicazione al Nostro Caso
**CRITICO - dobbiamo adottarlo ORA!**

Attualmente:
- ❌ Regina passa task in free-text
- ❌ Worker rispondono in formati diversi
- ❌ Zero validazione

Miglioria:
```json
{
  "task_id": "TASK_001",
  "from_agent": "cervella-regina",
  "to_agent": "cervella-backend",
  "context": {
    "project": "miracollo",
    "files": ["/path/to/file.py"],
    "objective": "Fix bug X",
    "success_criteria": ["Tests pass", "No console errors"]
  },
  "handoff_time": "2026-01-17T10:30:00Z"
}
```

**Fonti:**
- [Microsoft AutoGen: Handoffs](https://microsoft.github.io/autogen/stable/user-guide/core-user-guide/design-patterns/handoffs.html)
- [Semantic Kernel: Agent Orchestration](https://learn.microsoft.com/en-us/semantic-kernel/frameworks/agent/agent-orchestration/handoff)
- [Skywork: Best Practices Handoffs](https://skywork.ai/blog/ai-agent-orchestration-best-practices-handoffs/)

---

## 4. WORKSPACE ISOLATION

### Cos'è
Separazione fisica workspace per evitare conflitti quando agenti lavorano in parallelo sullo stesso codebase.

### Tecniche

**A) Git Worktrees:**
- Ogni agente ha worktree separato
- Stesso repo, checkout indipendenti
- Merge quando completato

**B) Remote Machines/Containers:**
- Ogni agente in macchina virtuale/container
- Isolamento completo risorse
- Orchestrazione via Docker/K8s

**C) Session Isolation:**
- Dedicated compute environment per sessione
- Memory isolation (AWS AgentCore)
- Session ID univoco con stato salvato

**D) Port Isolation:**
- Ogni agente su porta dedicata
- Orchestration layer alloca automaticamente
- Evita conflitti su servizi locali

### Pro
✅ Zero conflitti - impossibile sovrascrivere lavoro altrui
✅ Parallelismo vero - N agenti lavorano contemporaneamente
✅ Rollback facile - scarta worktree se fallisce
✅ Testing sicuro - ogni agente testa in isolamento

### Contro
❌ Resource intensive - N copie del codebase
❌ Sync overhead - merge tra worktrees
❌ Complessità setup - orchestration layer necessario

### Applicazione al Nostro Caso
**MEDIO VALORE - dipende da uso:**

Caso corrente:
- 16 agenti MA raramente > 2-3 attivi in parallelo
- Git clone separato GIÀ PRESENTE (`~/Developer/CervellaSwarm/`)
- Spawn-workers usa stesso filesystem

**Quando serve:**
- ✅ Se task paralleli modificano stessi file → worktrees
- ❌ Se task su file diversi → worktrees overkill
- ✅ Se task > 1 ora → worktrees (per sicurezza)

**Implementazione leggera:**
```bash
# Per task paralleli grossi
git worktree add ../CervellaSwarm-task001
spawn-worker --backend --worktree=../CervellaSwarm-task001
```

**Fonti:**
- [Microsoft Aspire: Scaling AI Agents](https://devblogs.microsoft.com/aspire/scaling-ai-agents-with-aspire-isolation/)
- [MassGen: Multi-Agent Scaling](https://docs.massgen.ai/en/latest/)
- [AWS: Production-Ready Agents](https://aws.amazon.com/blogs/machine-learning/enabling-customers-to-deliver-production-ready-ai-agents-at-scale/)

---

## 5. DISTRIBUTED LOCK MECHANISMS

### Cos'è
Meccanismi per garantire che solo 1 agente alla volta possa accedere/modificare una risorsa condivisa.

### Pattern di Lock

**A) Origin/Data Owner Model:**
- File creato → nodo creatore = Origin
- Origin traccia chi ha il lock
- Nodo con lock = Data Owner (Authoritative Write Node)
- Altri nodi chiedono permission a Origin

**B) Agent-Based Distributed Locks:**
- Multiple agents fungono da lock servers (P2P)
- Lock info cached localmente su ogni agent
- Check lock availability = locale (veloce)
- No single point of failure

**C) Traditional Centralized Locks:**
- Server centrale ("traffic cop")
- Tutti i lock gestiti centralmente
- SPOF (single point of failure)

### Strategie Anti-Conflitto

**Rate Limiting + Exponential Backoff:**
- Agente acquisisce lock → attende
- Retry con delay esponenziale
- Previene "thundering herd"

**Timeout Mechanisms:**
- Lock auto-rilasciato dopo timeout
- Previene deadlock da crash
- Configurable per tipo task

**Priority-Based:**
- Agenti hanno priorità
- High-priority ottiene lock prima
- Useful per task critici

### Pro
✅ Garantisce consistency - nessun double-write
✅ Previene race conditions
✅ Auditable - log chiaro di chi ha avuto lock quando

### Contro
❌ Performance - locking rallenta operazioni
❌ Deadlock risk - se implementato male
❌ Complessità - serve infrastruttura lock service

### Applicazione al Nostro Caso
**NECESSARIO ma implementazione LEGGERA:**

Problema attuale:
- 2 agenti modificano stesso `PROMPT_RIPRESA.md` → conflict
- Nessun meccanismo per dire "sto lavorando qui"

**Soluzione file-based (NO infrastruttura):**

```bash
# .swarm/locks/PROMPT_RIPRESA_miracollo.lock
{
  "agent": "cervella-researcher",
  "pid": 12345,
  "timestamp": "2026-01-17T10:30:00Z",
  "expires_at": "2026-01-17T11:30:00Z"
}
```

Script helper:
```bash
scripts/swarm/acquire-lock.sh PROMPT_RIPRESA_miracollo
# → crea lock file, aspetta se occupato, timeout 5min
scripts/swarm/release-lock.sh PROMPT_RIPRESA_miracollo
# → rimuove lock file
```

**Policy:**
- Lock auto-expires dopo 1h (previene deadlock)
- Lock check PRIMA di write a file condivisi
- Lock rilasciato DOPO write completato

**Fonti:**
- [Panzura: Distributed File Locking](https://panzura.com/technology/distributed-file-locking)
- [Martin Kleppmann: How to do Distributed Locking](https://martin.kleppmann.com/2016/02/08/how-to-do-distributed-locking.html)
- [Resilio: Distributed File Locking](https://www.resilio.com/blog/distributed-file-locking)

---

## COMPARAZIONE PATTERN

| Pattern | Complessità | Valore per Noi | Urgenza | Costo Implementazione |
|---------|-------------|----------------|---------|----------------------|
| **Context Mesh** | Media | 🔥 ALTO | Alta | Basso (abbiamo già .sncp) |
| **Event-Driven** | Alta | Medio | Bassa | Alto (serve infra) |
| **Handoff Protocol** | Media | 🔥 CRITICO | **URGENTE** | Medio (JSON schema) |
| **Workspace Isolation** | Alta | Basso | Media | Alto (worktrees setup) |
| **Lock Mechanisms** | Bassa | 🔥 ALTO | Alta | Basso (file-based) |

---

## RACCOMANDAZIONE FINALE

### Architettura Proposta: Context Mesh + Handoff + Locks

**FASE 1 - IMMEDIATE (questa settimana):**

1. **Handoff Protocol Strutturato**
   - JSON schema per task assignment
   - Template in `.swarm/schemas/handoff.schema.json`
   - Validazione obbligatoria pre-handoff

2. **File-Based Locks**
   - Script `acquire-lock.sh` / `release-lock.sh`
   - Lock su PROMPT_RIPRESA, stato.md, file critici
   - Auto-expire 1h

3. **Metadata nei File SNCP**
   - Header YAML in ogni file:
   ```yaml
   ---
   created_by: cervella-researcher
   created_at: 2026-01-17T10:30:00Z
   last_modified_by: cervella-regina
   last_modified_at: 2026-01-17T12:00:00Z
   project: miracollo
   ---
   ```

**FASE 2 - BREVE TERMINE (prossime 2 settimane):**

4. **Context Mesh Policies**
   - Documento `.sncp/POLICIES.md`:
     - Chi può leggere cosa
     - Chi può scrivere cosa
     - Quando serve lock
     - Formato handoff

5. **Scoped Context nei Task**
   - Task contiene SOLO:
     - Obiettivo
     - File coinvolti
     - Success criteria
     - Link a context (non context inline!)

6. **Event Log File-Based**
   - `.swarm/events/{date}/`
   - Agenti scrivono eventi JSON
   - Script `get-events.sh` per query

**FASE 3 - MEDIO TERMINE (quando serve):**

7. **Workspace Isolation (on-demand)**
   - Script `spawn-worker-isolated.sh`
   - Crea worktree SOLO se task richiede
   - Cleanup automatico post-task

8. **Monitoring & Observability**
   - Dashboard eventi/locks
   - Alert su deadlock
   - Metrics context usage

### Perché Questa Architettura

✅ **Risolve problema attuale:** Sessioni parallele non si pestano i piedi
✅ **Scalabile:** Funziona con 16 agenti, funzionerà con 50
✅ **Incrementale:** Fase 1 implementabile in 1-2 giorni
✅ **File-based:** Sfrutta .sncp esistente, no infra complessa
✅ **Provata:** Pattern usati da Google, Microsoft, AWS
✅ **Debuggable:** Tutto su filesystem, ispezionabile

### Metriche di Successo

Dopo implementazione dovremmo avere:
- ✅ Zero conflitti git da agenti paralleli
- ✅ Zero "ho perso il lavoro di X" tra sessioni
- ✅ 100% task con handoff strutturato
- ✅ Audit trail completo (chi ha fatto cosa)
- ✅ Context < 50K token per agente (no explosion)

---

## PROSSIMI STEP SUGGERITI

1. **Regina review:** Approva architettura proposta
2. **Guardiana Ingegnera:** Design dettagliato Fase 1
3. **Backend Worker:** Implementa script lock + handoff schema
4. **Tester:** Test race conditions con lock
5. **Documentazione:** Aggiorna CLAUDE.md con nuove policy

---

## FONTI COMPLETE

### Context Mesh & Memory
- [Solace: Context Engineering Revolution](https://solace.com/blog/context-engineering-solace-agent-mesh/)
- [Medium: Agentic Mesh Super-Contexts](https://medium.com/data-science-collective/agentic-mesh-super-contexts-for-multi-agents-at-scale-8a7151a1e2d2)
- [Vellum: Multi-Agent Context Engineering](https://www.vellum.ai/blog/multi-agent-systems-building-with-context-engineering)
- [Arxiv: Collaborative Memory](https://arxiv.org/html/2505.18279v1)

### Multi-Agent Patterns
- [InfoQ: Google's Multi-Agent Design Patterns](https://www.infoq.com/news/2026/01/multi-agent-design-patterns/)
- [Microsoft Azure: AI Agent Orchestration](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/ai-agent-design-patterns)
- [Google Developers: Multi-Agent Patterns ADK](https://developers.googleblog.com/developers-guide-to-multi-agent-patterns-in-adk/)

### Handoff Protocols
- [Microsoft AutoGen: Handoffs](https://microsoft.github.io/autogen/stable/user-guide/core-user-guide/design-patterns/handoffs.html)
- [Microsoft Semantic Kernel: Agent Orchestration](https://learn.microsoft.com/en-us/semantic-kernel/frameworks/agent/agent-orchestration/handoff)
- [Skywork: Best Practices Handoffs](https://skywork.ai/blog/ai-agent-orchestration-best-practices-handoffs/)

### Event-Driven Architecture
- [Confluent: Event-Driven Multi-Agent Systems](https://www.confluent.io/blog/event-driven-multi-agent-systems/)
- [AWS: Agentic AI Patterns](https://docs.aws.amazon.com/prescriptive-guidance/latest/agentic-ai-patterns/introduction.html)
- [InfoWorld: Distributed State of Mind](https://www.infoworld.com/article/3808083/a-distributed-state-of-mind-event-driven-multi-agent-systems.html)

### Workspace Isolation
- [Microsoft Aspire: Scaling AI Agents](https://devblogs.microsoft.com/aspire/scaling-ai-agents-with-aspire-isolation/)
- [MassGen: Multi-Agent Scaling](https://docs.massgen.ai/en/latest/)
- [AWS: Production-Ready Agents](https://aws.amazon.com/blogs/machine-learning/enabling-customers-to-deliver-production-ready-ai-agents-at-scale/)

### Distributed Locks
- [Panzura: Distributed File Locking](https://panzura.com/technology/distributed-file-locking)
- [Martin Kleppmann: How to do Distributed Locking](https://martin.kleppmann.com/2016/02/08/how-to-do-distributed-locking.html)
- [Resilio: Distributed File Locking](https://www.resilio.com/blog/distributed-file-locking)

### General Frameworks
- [Swarms AI: Enterprise Multi-Agent](https://www.swarms.ai/)
- [GitHub: Claude Flow](https://github.com/ruvnet/claude-flow)
- [Kanerika: AI Agent Orchestration 2026](https://kanerika.com/blogs/ai-agent-orchestration/)

---

**Fine Ricerca**
*Cervella Researcher - 17 Gennaio 2026*
