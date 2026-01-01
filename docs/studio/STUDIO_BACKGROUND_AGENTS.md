# STUDIO 3+4: Background Agents 🔬⚙️

> *"La Regina non si blocca. Mai."* - CervellaSwarm

**Data Studio:** 1 Gennaio 2026
**Fase:** 8 - La Corte Reale
**Status:** ✅ COMPLETATO

---

## TL;DR - Executive Summary

**Problema:** Task lunghe (ricerche, refactoring massivi) bloccano la Regina
**Soluzione:** Background Agents che lavorano in parallelo mentre la Regina continua
**Tool:** Claude Code ha già `run_in_background: true` nel Task tool!

---

## 1. Pattern Async Emergenti (2024-2026)

### Agent Broker Pattern
- Hub centrale per message distribution
- Workflow distribuito
- Ogni agent lavora indipendentemente

### Asynchronous Choreography
- Event-driven multi-agent workflow
- Autonomo senza orchestratore centrale
- Comunicazione via eventi/messaggi

### Deep Agents Architecture
- Planning esplicito + delegazione gerarchica
- Persistent memory tra sessioni
- Ideale per task multi-step

---

## 2. Claude SDK - La Soluzione Già Esiste!

### Context Compaction
- Summarization automatica quando token limit si avvicina
- Mantiene context pulito

### Background Task ID
- `Bash` tool con `run_in_background: true` ritorna ID tracciabile
- `TaskOutput` per recuperare risultati

### Multi-session Pattern
- Initializer agent + coding agent
- Artifacts persistenti tra sessioni

---

## 3. Use Cases Produzione Reale

| Case | Risultato |
|------|-----------|
| Adrian Cockcroft (Netflix) | 5-agent swarm = 150,000 righe in 48h |
| Developer report | 20 agent paralleli = app production-ready in 1 settimana (800 commits!) |
| Google Jules | Async coding assistant che clona repo e lavora in background |

---

## 4. Problema Risolto: Context Rot

**Scoperta Anthropic:** Context windows PIÙ LUNGHI peggiorano le cose!

**Soluzioni:**
- Summaries strutturate (non tutto il contesto)
- Just-in-time retrieval (solo ciò che serve)
- Structured note-taking (`claude-progress.txt`)

---

## 5. Framework Enterprise-Ready

| Framework | Caratteristiche |
|-----------|-----------------|
| **Swarms AI** | Production-ready multi-agent orchestration |
| **Trigger.dev** | TypeScript AI workflows con retries + queues |
| **Azure App Service** | Agent Framework per long-running tasks (30s-minuti) |

---

## 6. Proposta Architettura Background Agents

### Background Research Agent (Studio 3)

**Scopo:** Ricerche approfondite senza bloccare la Regina

**Use Cases:**
- "Studia best practices authentication 2025"
- "Analizza competitor X Y Z"
- "Ricerca pattern per problema W"

**Pattern:**
```
Regina → Task(run_in_background: true) → Research Agent
Regina continua a lavorare...
Regina → TaskOutput(block: false) → Check status
...quando pronto...
Regina → TaskOutput(block: true) → Recupera risultati
```

### Background Technical Agent (Studio 4)

**Scopo:** Task tecnici pesanti in parallelo

**Use Cases:**
- "Migra tutti i test da Jest a Vitest"
- "Fai refactor di tutti i file > 500 righe"
- "Genera documentazione per 20 endpoint"

**Pattern:**
```
Regina identifica task massivo
Regina → Task(run_in_background: true) → Technical Agent
Regina continua su altro task
Technical Agent → Scrive risultati in file .md
Regina → Legge risultati quando serve
```

---

## 7. Decisioni Chiave

| Decisione | Risposta |
|-----------|----------|
| Quali task per background? | > 10 minuti stimati |
| Come monitorare? | TaskOutput(block: false) + file progress |
| Timeout? | 30 min default, estendibile |
| Error handling | Scrive errore in file, Regina decide |
| Checkpoint? | Scrive stato ogni 5 minuti in file |

---

## 8. Implementazione Suggerita

### Passo 1: Template Prompt Background Research

```
Task tool con:
- subagent_type: "cervella-researcher"
- run_in_background: true
- prompt: Include "Scrivi risultati in [path]/RESEARCH_[topic].md"
```

### Passo 2: Template Prompt Background Technical

```
Task tool con:
- subagent_type: "cervella-backend" o altro specialista
- run_in_background: true
- prompt: Include "Scrivi log progresso ogni 5 min"
```

### Passo 3: Monitoring Pattern

```
Ogni 10 minuti, Regina:
1. TaskOutput(block: false) → check status
2. Se completed → leggi risultati
3. Se running → continua altro lavoro
4. Se failed → decide: retry o abort
```

---

## 9. Rischi e Mitigazioni

| Rischio | Mitigazione |
|---------|-------------|
| Agent in background fa danni | Limitare a task read-only o su branch separato |
| Timeout troppo lungo | Max 30 min, poi checkpoint obbligatorio |
| Risultati persi | Sempre scrivere in file .md, mai solo output |
| Context pollution | Agent separato = context separato |

---

## 10. Metriche di Successo

| Metrica | Target |
|---------|--------|
| **Regina blocking time** | < 5% del tempo totale |
| **Task completati in background** | > 80% success rate |
| **Qualità output** | Uguale a task sincroni |

---

## 11. Raccomandazione Finale

✅ **Implementare subito** - Claude Code lo supporta già!
✅ **Start con Research Agent** - più sicuro (read-only)
✅ **Poi Technical Agent** - su branch separati
✅ **Pattern file-based** - risultati sempre in .md

---

## Fonti

- Async AI agent patterns research
- Claude Code Task tool documentation
- Trigger.dev, Swarms AI, Azure Agent Framework
- Multi-agent orchestration best practices 2024-2025

---

*"La Regina non si blocca. Lo sciame lavora in parallelo."* 🐝⚡

*Studio completato: 1 Gennaio 2026*
