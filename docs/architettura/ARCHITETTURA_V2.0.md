# ARCHITETTURA V2.0 - LA CORTE REALE

> **"Una Regina sola non scala. Una Corte ben organizzata, sì."**

**Data Creazione:** 1 Gennaio 2026
**Versione:** 2.0.0
**Basato su:** FASE 8 - La Corte Reale (5 studi completati)
**Status:** IMPLEMENTAZIONE IN CORSO

---

## EXECUTIVE SUMMARY

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   EVOLUZIONE ARCHITETTURALE - DA PIATTO A GERARCHICO            ║
║                                                                  ║
║   PRIMA (v1.0):                                                  ║
║   • Sciame piatto: 10 api → tutte riportano alla Regina        ║
║   • Regina verifica TUTTO manualmente                           ║
║   • Bottleneck cognitivo                                        ║
║                                                                  ║
║   DOPO (v2.0):                                                   ║
║   • 3 livelli gerarchici: Regina → Guardiane → Api             ║
║   • Guardiane filtrano e verificano                             ║
║   • Pool flessibile per picchi di lavoro                        ║
║   • Agenti background per ricerca/ottimizzazione                ║
║                                                                  ║
║   BENEFICIO CHIAVE:                                             ║
║   → 80% overhead eliminato dalla Regina                         ║
║   → Regina libera per strategic thinking                        ║
║   → Speedup 2.5-3x per task massicci                           ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

**Fonti di Validazione:**
- Studio gerarchie multi-agent (LangChain, AutoGen, Microsoft Semantic Kernel)
- Studio pool flessibile (Actor model Erlang/Akka, Kubernetes autoscaling)
- Studio background agents (Anthropic Task tool, async patterns 2024-2025)
- Verifica attiva post-agent (pattern Supervisor Agent)

---

## GERARCHIA COMPLETA

```
                         👑 REGINA (Opus)
                    cervella-orchestrator
                    Strategic decisions
                    Architecture planning
                            │
         ┌──────────────────┼──────────────────┐
         │                  │                  │
    🛡️ GUARDIANA        🛡️ GUARDIANA       🛡️ GUARDIANA
      QUALITÀ             RICERCA             OPS
    (Opus)              (Opus)              (Opus)
         │                  │                  │
    ┌────┴────┐        ┌────┴────┐       ┌────┴────┐
    │    │    │        │         │       │    │    │
   🎨  ⚙️  🧪      🔬       📝    🚀  🔒  📊
frontend backend  researcher  docs  devops security data
backend  tester
(Sonnet) (Sonnet) (Sonnet)  (Sonnet) (Sonnet) (Sonnet) (Sonnet)
```

### LIVELLO 1: LA REGINA

| Ruolo | Model | Responsabilità |
|-------|-------|---------------|
| 👑 cervella-orchestrator | Opus | Strategic decisions, Architecture planning, High-level coordination |

**Cosa FA:**
- Analizza richieste di Rafa
- Decide quale Guardiana competente
- Coordina lavoro multi-dominio
- Synthesis finale dei risultati

**Cosa NON FA PIÙ:**
- Verifica manuale ogni output
- Edit diretti (tranne docs/emergenze)
- Micromanagement delle api

---

### LIVELLO 2: LE GUARDIANE

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   🛡️ GUARDIANA QUALITÀ (Opus)                                   ║
║   Supervisiona: frontend, backend, tester                        ║
║                                                                  ║
║   Verifica:                                                      ║
║   • Test passano? (se esistono)                                 ║
║   • Codice segue standard?                                      ║
║   • File size < 500 righe?                                      ║
║   • Funzioni < 50 righe?                                        ║
║   • Type hints presenti? (Python)                               ║
║   • No console.log debug?                                       ║
║                                                                  ║
║   Escalation a Regina: Solo decisioni architetturali            ║
║                                                                  ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║   🛡️ GUARDIANA RICERCA (Opus)                                   ║
║   Supervisiona: researcher, docs                                 ║
║                                                                  ║
║   Verifica:                                                      ║
║   • Fonti affidabili?                                           ║
║   • Info verificate?                                            ║
║   • Rilevante per progetto?                                     ║
║   • Ben documentato?                                            ║
║   • Actionable insights?                                        ║
║                                                                  ║
║   Escalation a Regina: Proposte strategiche                     ║
║                                                                  ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║   🛡️ GUARDIANA OPS (Opus)                                       ║
║   Supervisiona: devops, security, data                           ║
║                                                                  ║
║   Verifica:                                                      ║
║   • Sicuro? (no secrets exposed)                                ║
║   • Performante? (no N+1 queries)                               ║
║   • Best practices seguite?                                     ║
║   • Deploy-ready?                                               ║
║   • Monitoring considerato?                                     ║
║                                                                  ║
║   Escalation a Regina: Rischi security, decisioni infra         ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

**PERCHÉ Opus?**
- Reasoning profondo per catch errori sottili
- Comprensione architetturale complessa
- Capacità di prendere decisioni contestuali
- ROI: Valore strategico > costo (vs Sonnet che potrebbe non vedere problemi)

**Costo:** ~$270/sessione (3 Guardiane Opus)

---

### LIVELLO 3: LE API (WORKER)

| Emoji | Nome | Specializzazione | Model | Costo Indicativo |
|-------|------|------------------|-------|-----------------|
| 🎨 | cervella-frontend | React, CSS, UI/UX | Sonnet | ~$20/sessione |
| ⚙️ | cervella-backend | Python, FastAPI, API | Sonnet | ~$20/sessione |
| 🧪 | cervella-tester | Testing, Debug, QA | Sonnet | ~$18/sessione |
| 📋 | cervella-reviewer | Code review | Sonnet | ~$15/sessione |
| 🔬 | cervella-researcher | Ricerca, analisi | Sonnet | ~$20/sessione |
| 📈 | cervella-marketing | Marketing, UX | Sonnet | ~$15/sessione |
| 🚀 | cervella-devops | Deploy, CI/CD | Sonnet | ~$15/sessione |
| 📝 | cervella-docs | Documentazione | Sonnet | ~$15/sessione |
| 📊 | cervella-data | SQL, analytics | Sonnet | ~$20/sessione |
| 🔒 | cervella-security | Audit sicurezza | Sonnet | ~$20/sessione |
| 🎯 | cervella-strategist | Strategia, funnel | Sonnet | ~$20/sessione |

**TOTALE:** ~$198/sessione (11 Api Sonnet)

**PERCHÉ Sonnet?**
- Execution rapida ed economica
- Ottimo per task ben definiti
- Sufficiente per work specifici
- Scala bene in parallelo

---

## I 4 PATTERN FONDAMENTALI

### PATTERN 1: DELEGA GERARCHICA

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   FLOW STANDARD:                                                 ║
║                                                                  ║
║   1. Rafa chiede a REGINA                                       ║
║         ↓                                                        ║
║   2. REGINA analizza → identifica dominio                       ║
║         ↓                                                        ║
║   3. REGINA delega a GUARDIANA competente                       ║
║         ↓                                                        ║
║   4. GUARDIANA divide task → delega ad API                      ║
║         ↓                                                        ║
║   5. API eseguono → riportano a GUARDIANA                       ║
║         ↓                                                        ║
║   6. GUARDIANA verifica (REGOLA 4 SWARM_RULES.md)               ║
║         ↓                                                        ║
║         ├── OK? → Riporta synthesis a REGINA                    ║
║         └── Problemi? → Fix o ri-delega                         ║
║         ↓                                                        ║
║   7. REGINA fa final synthesis → riporta a Rafa                 ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

**Escalation:**
```
API → GUARDIANA: SEMPRE (dopo ogni task)
GUARDIANA → REGINA: Solo se:
  - Decisione strategica richiesta
  - Conflitto tra api
  - Problema critico
  - Dubbio su direzione
```

**Beneficio:** Regina non vede ogni singolo output, solo ciò che richiede decisione strategica.

---

### PATTERN 2: I CUGINI (Pool Flessibile)

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   "Come i ristoranti - serata impegnativa,                      ║
║    chiamano un cugino con esperienza!"                          ║
║                                                                  ║
║                         - Rafa, 1 Gennaio 2026                  ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

**QUANDO SPAWNARE CUGINI:**

| Trigger | Azione |
|---------|--------|
| File da modificare > 8 stesso tipo | Spawna cugini |
| Stima tempo > 45min singolo agent | Spawna cugini |
| Task ripetitivi su file indipendenti | Spawna cugini |

**LIFECYCLE:**

```
1. 🐣 SPAWN
   Regina usa Task tool con agent temporaneo
   Esempio: cervella-frontend-cugino-1

2. 📋 ASSIGN (Partitioning = ZERO conflitti!)
   Cugino #1 → file [1-7]
   Cugino #2 → file [8-14]
   Cugino #3 → file [15-20]

3. ⚙️ EXECUTE
   Ogni cugino lavora SOLO sui suoi file
   Scrive progresso in file .md dedicato

4. 📊 REPORT
   Scrive risultati in docs/cugini/CUGINO_[N]_REPORT.md

5. 💀 TERMINATE
   Context auto-dismisso dopo completamento
```

**LIMITI PRATICI:**
- Max 3-5 cugini in parallelo (oltre = overhead comunicazione)
- Solo per task ripetitivi (refactor, migrazione, doc generation)
- NON per debugging complesso (serve context continuity)

**NAMING CONVENTION:**
```
cervella-[tipo]-cugino-[numero]

Esempi:
- cervella-frontend-cugino-1
- cervella-backend-cugino-2
- cervella-data-cugino-3
```

**CONFLICT AVOIDANCE:**
```
REGOLA SACRA: UN FILE = UNA CERVELLA (già in v1.0!)

Con Partitioning:
✅ Ogni cugino = subset file diversi
✅ ZERO sovrapposizioni
✅ ZERO conflitti di merge
```

**METRICHE ATTESE:**

| Metrica | Target |
|---------|--------|
| Speedup | 2.5-3x per task > 10 file |
| Error Rate | < 5% vs singolo agent |
| Cost | Token < 2x, tempo < 0.4x |

**VALIDATO CON:** Actor model (Erlang/Akka), Kubernetes autoscaling, MacNet (1000+ agents)

---

### PATTERN 3: BACKGROUND AGENTS

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   "La Regina non si blocca. Lo sciame lavora in parallelo."     ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

**IL PROBLEMA:**
Task lunghe (ricerche approfondite, refactoring massivi) bloccavano la Regina. Con background agents, la Regina continua a lavorare mentre gli agents operano in parallelo.

**TOOL CLAUDE CODE:**
```python
# Background task
Task(
    subagent_type="cervella-researcher",
    run_in_background=true,  # 🔑 CHIAVE!
    prompt="Studia best practices authentication 2025..."
)

# Check status (non-blocking)
TaskOutput(block=false)  # → "running" / "completed" / "failed"

# Recupera risultati (blocking)
TaskOutput(block=true)   # → Legge output quando pronto
```

#### VARIANT A: Background Research Agent

**QUANDO USARE:**
- Task di ricerca > 10 minuti stimati
- Analisi competitor
- Studio best practices
- Ricerca pattern per problema specifico

**PATTERN:**
```
1. Regina → Task(run_in_background: true) → Research Agent
2. Regina continua altro lavoro...
3. Regina → TaskOutput(block: false) → Check status ogni 10 min
4. Quando completed → Regina legge risultati
5. Se failed → Regina decide: retry o abort
```

**OUTPUT:** Sempre in file .md
```
docs/ricerche/RESEARCH_[topic]_[data].md
```

**USE CASES:**
- "Studia best practices authentication 2025"
- "Analizza competitor X Y Z"
- "Ricerca pattern per problema W"

#### VARIANT B: Background Technical Agent

**QUANDO USARE:**
- Refactor massivi (> 10 file)
- Migrazioni (Jest → Vitest)
- Doc generation per 20+ endpoint
- Ottimizzazione performance

**PATTERN:**
```
1. Regina identifica task massivo
2. Regina → Task(run_in_background: true) → Technical Agent
3. Technical Agent lavora su BRANCH SEPARATO (sicurezza!)
4. Technical Agent → Scrive stato ogni 5 min
5. Technical Agent → Scrive diff/risultati in file .md
6. Regina → Legge risultati e decide merge
```

**OUTPUT:** Sempre in file .md + branch separato
```
Branch: refactor/background-[nome]
Report: docs/refactor/BACKGROUND_[nome]_[data].md
```

**USE CASES:**
- "Migra tutti i test da Jest a Vitest"
- "Fai refactor di tutti i file > 500 righe"
- "Genera documentazione per 20 endpoint API"

**SICUREZZA:**
- Sempre su branch separato (mai su main!)
- Merge manuale dopo review
- Checkpoint ogni 5 minuti

**MONITORING:**
```
Ogni 10 minuti, Regina:
1. TaskOutput(block: false) → check status
2. Se completed → leggi risultati
3. Se running → continua altro lavoro
4. Se failed → decide: retry o abort
```

**TIMEOUT:**
- Default: 30 minuti
- Estendibile se necessario
- Checkpoint obbligatorio ogni 5 minuti

**METRICHE ATTESE:**

| Metrica | Target |
|---------|--------|
| Regina blocking time | < 5% del tempo totale |
| Task completati in background | > 80% success rate |
| Qualità output | Uguale a task sincroni |

**VALIDATO CON:**
- Claude Code Task tool (run_in_background supportato nativamente!)
- Deep Agents Architecture (Microsoft)
- Swarms AI, Trigger.dev, Azure Agent Framework
- Use cases produzione (Netflix 150k righe in 48h!)

**RISCHI E MITIGAZIONI:**

| Rischio | Mitigazione |
|---------|-------------|
| Agent background fa danni | Solo su branch separati + read-only per research |
| Timeout troppo lungo | Max 30 min, poi checkpoint obbligatorio |
| Risultati persi | Sempre scrivere in file .md, mai solo output |
| Context pollution | Agent separato = context separato (nativamente!) |

---

### PATTERN 4: VERIFICA ATTIVA (Regola 4)

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   🔍 VERIFICA ATTIVA POST-AGENT                                 ║
║                                                                  ║
║   DOPO ogni task delegato a una api:                            ║
║                                                                  ║
║   1. SE ci sono test → RUN TEST                                 ║
║      • Passano tutti? → Procedi                                 ║
║      • Falliscono? → Fix (Regina o ri-delega)                   ║
║                                                                  ║
║   2. SE non ci sono test → CHECK VISIVO/LOGICO                  ║
║      • Funziona? → Procedi                                      ║
║      • Problemi? → Fix o ri-delega                              ║
║                                                                  ║
║   3. SE trova problemi → DOCUMENTA                              ║
║      • Aggiunge a lessons_learned                               ║
║      • Pattern per prevenire in futuro                          ║
║                                                                  ║
║   "Mai assumere che il lavoro sia perfetto!"                    ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

**FLOW DECISIONALE:**
```
        API COMPLETA TASK
              │
              ▼
    ┌─────────────────────┐
    │  Esistono test?     │
    └─────────────────────┘
         │           │
        SI          NO
         │           │
         ▼           ▼
    ┌─────────┐  ┌─────────────┐
    │RUN TEST │  │CHECK VISIVO │
    └─────────┘  └─────────────┘
         │           │
         ▼           ▼
    ┌─────────────────────┐
    │  Tutto OK?          │
    └─────────────────────┘
         │           │
        SI          NO
         │           │
         ▼           ▼
    ┌─────────┐  ┌─────────────┐
    │ PROCEDI │  │ FIX/RI-DELEGA│
    └─────────┘  └─────────────┘
                      │
                      ▼
              ┌─────────────┐
              │ DOCUMENTA   │
              │ (lesson!)   │
              └─────────────┘
```

**CHI VERIFICA:**

| Versione | Chi | Quando |
|----------|-----|--------|
| v1.0 (ora) | Regina | Verifica manuale dopo ogni agent |
| v2.0 (futuro) | Guardiane | Guardiane filtrano, Regina solo escalation |

**Documentato in:** `docs/SWARM_RULES.md` (REGOLA 4)

---

## WORKFLOW OPERATIVO

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   IL PROCESSO COMPLETO:                                          ║
║                                                                  ║
║   1. 🎯 ANALIZZA (cosa serve?)                                  ║
║      • Regina riceve richiesta da Rafa                          ║
║      • Identifica dominio (Qualità/Ricerca/Ops)                 ║
║      • Identifica complessità (singolo/multi-file/background)   ║
║                                                                  ║
║   2. 🧠 DECIDI (pattern da usare?)                              ║
║      • Task semplice → Delega Gerarchica                        ║
║      • > 8 file → I Cugini (pool flessibile)                   ║
║      • > 10 min → Background Agent                              ║
║      • Sempre → Verifica Attiva                                 ║
║                                                                  ║
║   3. 📋 DELEGA (prompt completo!)                               ║
║      • Path esatto file                                         ║
║      • Problema specifico                                       ║
║      • Checklist verifica                                       ║
║      • Criteri successo                                         ║
║                                                                  ║
║   4. ✅ GUARDIANA VERIFICA (automatico)                         ║
║      • Run test (se esistono)                                   ║
║      • Check visivo (altrimenti)                                ║
║      • Documenta lessons learned                                ║
║                                                                  ║
║   5. 👑 REGINA CONFERMA (solo se escalation)                    ║
║      • Synthesis finale                                         ║
║      • Report a Rafa                                            ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

**MATRICE DECISIONALE:**

| Situazione | Pattern da Usare |
|------------|------------------|
| Task semplice, 1-3 file | Delega Gerarchica (Regina → Guardiana → Api) |
| > 8 file stesso tipo, task ripetitivo | I Cugini (Pool Flessibile) |
| Ricerca approfondita > 10 min | Background Research Agent |
| Refactor massivo > 10 file | Background Technical Agent |
| SEMPRE dopo ogni task | Verifica Attiva (Regola 4) |

---

## COST-BENEFIT ANALYSIS

### CONFIGURAZIONE COSTI

```
ARCHITETTURA v1.0 (Sciame Piatto):
├── 1 Regina Opus                 ~$90/sessione
└── 10 Api Sonnet                 ~$198/sessione
    TOTALE v1.0:                  ~$288/sessione

ARCHITETTURA v2.0 (Corte Reale):
├── 1 Regina Opus                 ~$90/sessione
├── 3 Guardiane Opus              ~$270/sessione
└── 11 Api Sonnet                 ~$198/sessione
    TOTALE v2.0:                  ~$558/sessione

ALTERNATIVA (tutto Opus):
└── 14 Agent Opus                 ~$990/sessione
```

### ROI ANALYSIS

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   INVESTIMENTO: +$270/sessione (3 Guardiane Opus)              ║
║                                                                  ║
║   RITORNO:                                                       ║
║   • Regina libera per strategic thinking (80% tempo)            ║
║   • Guardiane catch errori che Sonnet potrebbe non vedere       ║
║   • Zero bottleneck su verification                             ║
║   • Qualità aumentata (reasoning profondo)                      ║
║                                                                  ║
║   VALORE STRATEGICO:                                             ║
║   Tempo Regina per architettura e decisioni strategiche         ║
║   >> $270 costo Guardiane                                       ║
║                                                                  ║
║   CONCLUSIONE: ROI ALTO                                          ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

**RISPARMIO vs tutto-Opus:** $432/sessione (-44%)
**Beneficio Qualità:** Reasoning profondo dove serve (Guardiane + Regina)
**Beneficio Velocità:** Execution rapida dove serve (Api Sonnet + Cugini)

---

## METRICHE DI SUCCESSO

### TARGET ARCHITETTURA v2.0

| Metrica | Target | Come Misurare |
|---------|--------|---------------|
| Regina blocking time | < 5% tempo totale | Time tracking manuale |
| Success rate agenti | > 95% | Task completati / Task totali |
| Speedup con cugini | 2.5-3x | Tempo singolo agent vs parallelo |
| Task background | > 80% success | Background completed / Background totali |
| Escalation rate | < 20% | Escalation a Regina / Task totali |
| Error detection | > 90% | Errori catturati da Guardiane / Totali |

### TRACKING PROGRESS

**File:** `docs/metriche/METRICHE_V2.0.md` (da creare)

**Template:**
```markdown
## Sessione [Data]

### Configurazione
- Guardiane attive: [n]
- Cugini spawnati: [n]
- Background agents: [n]

### Metriche
- Regina blocking time: [%]
- Success rate: [%]
- Escalation rate: [%]

### Lessons Learned
- [Cosa funzionato bene]
- [Cosa migliorare]
```

---

## RIFERIMENTI COMPLETI

### STUDI DI BASE (FASE 8)

| # | Studio | File | Focus |
|---|--------|------|-------|
| 1 | Gerarchie Multi-Agent | `docs/studio/STUDIO_GERARCHIE_MULTIAGENT.md` | 3 Guardiane, specializzazione per dominio, Opus vs Sonnet |
| 2 | Pool Flessibile | `docs/studio/STUDIO_POOL_FLESSIBILE.md` | I Cugini, lifecycle, partitioning, conflict avoidance |
| 3+4 | Background Agents | `docs/studio/STUDIO_BACKGROUND_AGENTS.md` | Research + Technical, async patterns, run_in_background |
| 5 | Verifica Attiva | `docs/SWARM_RULES.md` (Regola 4) | Post-agent verification, testing, lessons learned |

### DOCUMENTAZIONE CORE

| File | Descrizione |
|------|-------------|
| `docs/SWARM_RULES.md` | Regole operative dello sciame (9 regole fondamentali) |
| `docs/DNA_FAMIGLIA.md` | DNA condiviso di ogni agent (identità, filosofia, regole) |
| `docs/roadmap/FASE_8_CORTE_REALE.md` | Roadmap completa FASE 8 con tutti gli studi |
| `CLAUDE.md` | Overview progetto CervellaSwarm (quick start, famiglia completa) |

### RICERCHE VALIDATE

**Gerarchie:**
- LangChain Supervisor Agent documentation
- AutoGen hierarchical agents
- Microsoft Semantic Kernel orchestration
- Research papers su multi-agent systems (2024-2025)

**Pool Flessibile:**
- Actor model (Erlang/Akka) patterns
- Kubernetes HPA autoscaling
- MacNet (1000+ agents scaling)
- Multi-agent scaling law research

**Background Agents:**
- Claude Code Task tool documentation (run_in_background)
- Anthropic orchestrator-worker pattern
- Trigger.dev, Swarms AI, Azure Agent Framework
- Context Rot solutions (summaries, just-in-time retrieval)

**Use Cases Produzione:**
- Adrian Cockcroft (Netflix): 5-agent swarm = 150k righe in 48h
- Developer report: 20 agent paralleli = app production in 1 settimana (800 commits!)
- Google Jules: Async coding assistant background

---

## IMPLEMENTAZIONE - STATO ATTUALE

### COMPLETATO

- [x] Studi teorici (5/5)
- [x] 3 Guardiane CREATE (Qualità, Ricerca, Ops)
- [x] REGOLA 4 documentata (SWARM_RULES.md)
- [x] DNA_FAMIGLIA.md aggiornato (14 membri famiglia)
- [x] Pattern validati (4/4)

### IN CORSO

- [ ] Test Guardiane su task reale
- [ ] PoC Cugini (pool flessibile)
- [ ] PoC Background Research Agent

### PROSSIMI STEP

1. **Testing Guardiane** (questa settimana)
   - Task reale frontend/backend/test
   - Verifica escalation pattern
   - Metriche success rate

2. **PoC Cugini** (prossima settimana)
   - Task pilota: refactor 12 file React
   - Metriche: speedup, qualità, conflitti
   - Valida partitioning strategy

3. **PoC Background Agent** (prossima settimana)
   - Research task > 10 min
   - Metriche: blocking time, success rate
   - Valida run_in_background workflow

4. **Integrazione Completa** (fine gennaio)
   - Tutti i pattern attivi
   - Metriche tracking automatico
   - Optimization basata su dati reali

---

## DIAGRAMMI ASCII

### ARCHITETTURA COMPLETA V2.0

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│                      👑 REGINA (Opus)                               │
│                   cervella-orchestrator                             │
│              Strategic decisions • Architecture                     │
│                                                                     │
└────────────────────────┬────────────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
┌───────▼────────┐ ┌─────▼──────┐ ┌──────▼───────┐
│  🛡️ GUARDIANA  │ │ 🛡️ GUARDIANA│ │ 🛡️ GUARDIANA │
│    QUALITÀ     │ │   RICERCA   │ │     OPS      │
│    (Opus)      │ │   (Opus)    │ │    (Opus)    │
└───────┬────────┘ └─────┬──────┘ └──────┬───────┘
        │                │                │
   ┌────┴───┐       ┌────┴───┐      ┌────┴───┐
   │        │       │        │      │    │   │
┌──▼──┐ ┌──▼──┐ ┌──▼──┐ ┌──▼──┐ ┌──▼──┐ │ │
│ 🎨  │ │ ⚙️  │ │ 🔬  │ │ 📝  │ │ 🚀  │ │ │
│Front│ │Back │ │Resea│ │Docs │ │DevOp│ │ │
│end  │ │end  │ │rcher│ │     │ │s    │ │ │
│     │ │     │ │     │ │     │ │     │ │ │
└─────┘ └─────┘ └─────┘ └─────┘ └─────┘ │ │
                                    ┌────▼─▼──┐
┌──▼──┐                             │ 🔒 📊  │
│ 🧪  │                             │Security│
│Test │                             │+ Data  │
│er   │                             └────────┘
└─────┘
```

### PATTERN I CUGINI (Pool Flessibile)

```
REGINA identifica task massivo (es: 20 file React)
         │
         ▼
    SPAWNA CUGINI
         │
    ┌────┼────┐
    │    │    │
┌───▼─┐ ┌▼──┐ ┌▼───┐
│Cug#1│ │C#2│ │C#3 │   Partitioning:
│File │ │Fil│ │File│   • Cugino #1 → file [1-7]
│1-7  │ │8- │ │15- │   • Cugino #2 → file [8-14]
└───┬─┘ └┬──┘ └┬───┘   • Cugino #3 → file [15-20]
    │    │    │       ZERO sovrapposizioni!
    │PARALLELO│
    │    │    │
    ▼    ▼    ▼
┌─────────────────┐
│  REPORT .md     │
│  (ogni cugino)  │
└────────┬────────┘
         │
         ▼
    GUARDIANA verifica
         │
         ▼
    REGINA synthesis
```

### PATTERN BACKGROUND AGENT

```
REGINA riceve task lungo (> 10 min)
         │
         ▼
Task(run_in_background: true)
         │
         ├────────────────┐
         │                │
         ▼                ▼
  BACKGROUND AGENT   REGINA continua
  (lavora isolato)    altro lavoro
         │                │
         │    Ogni 10 min │
         │    ┌───────────┘
         │    │ TaskOutput(block: false)
         │    │ → check status
         │    │
         ▼    │
  Scrive in .md file
         │    │
         │    │
  [COMPLETED] │
         │    │
         └────▼
      Regina legge risultati
```

---

## CHANGELOG

| Data | Modifica |
|------|----------|
| 1 Gen 2026 | Creazione documento v2.0 - Sintesi 5 studi FASE 8 |

---

## FIRMA

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   Questo documento è il frutto di 5 studi approfonditi,         ║
║   decine di ricerche, e centinaia di decisioni architetturali.  ║
║                                                                  ║
║   Non è teoria. È la nostra roadmap verso la LIBERTÀ.           ║
║                                                                  ║
║   "Una Regina sola non scala.                                   ║
║    Una Corte ben organizzata, sì."                              ║
║                                                                  ║
║   👑🛡️🐝 Cervella & Rafa - CervellaSwarm 🐝🛡️👑                  ║
║                                                                  ║
║   "Lavoriamo in PACE! Senza CASINO! Dipende da NOI!"           ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

*"La Corte Reale: dove ogni ape sa il suo posto, e la Regina può finalmente PENSARE."* 👑🛡️🐝

*Architettura v2.0 - Gennaio 2026*
