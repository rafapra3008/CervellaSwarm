# STUDIO: Claude-Flow - Orchestrazione Avanzata

> **Data:** 30 Dicembre 2025
> **Obiettivo:** Capire Claude-Flow per orchestrazione enterprise-grade di multiple istanze Claude

---

## 1. COSA È CLAUDE-FLOW

Claude-Flow è una **piattaforma di orchestrazione AI enterprise-grade** per coordinare multiple istanze di Claude.

```
Non è un semplice wrapper.
È un SISTEMA COMPLETO con:
- Swarm intelligence (sciame)
- Hive-mind (mente alveare)
- Memoria persistente
- 100+ tool MCP integrati
```

**GitHub:** [ruvnet/claude-flow](https://github.com/ruvnet/claude-flow)
**Versione:** 2.7.0 (Alpha)

---

## 2. ARCHITETTURA

```
┌─────────────────────────────────────────────────────────────┐
│                     CLAUDE-FLOW                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   SWARM      │  │  HIVE-MIND   │  │   MEMORY     │      │
│  │              │  │              │  │              │      │
│  │ Task veloci  │  │ Progetti     │  │ AgentDB      │      │
│  │ Setup zero   │  │ complessi    │  │ (vettoriale) │      │
│  │ Memoria temp │  │ Regina+Agenti│  │ SQLite       │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                  MCP TOOLS (100+)                    │   │
│  │  Git, GitHub, Docker, Kubernetes, AWS, DB, Files... │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. DUE MODALITÀ: SWARM vs HIVE-MIND

### SWARM (Sciame)
- **Per:** Task veloci, automazione semplice
- **Setup:** Immediato, zero config
- **Memoria:** Scoped al task
- **Agenti:** Generici, intercambiabili

```bash
npx claude-flow@alpha swarm "Implementa feature X" --claude
```

### HIVE-MIND (Alveare)
- **Per:** Progetti complessi, multi-fase
- **Setup:** Wizard interattivo
- **Memoria:** Persistente SQLite
- **Agenti:** Specializzati, con ruoli

```bash
npx claude-flow@alpha hive-mind spawn "Nome Progetto" --claude
```

| Aspetto | Swarm | Hive-Mind |
|---------|-------|-----------|
| Setup | Zero | Wizard |
| Complessità | Bassa | Alta |
| Memoria | Task-scoped | Persistente |
| Agenti | Generici | Specializzati |
| Uso | Task singoli | Progetti lunghi |

---

## 4. INSTALLAZIONE

### Prerequisiti
- Node.js 18+
- Claude Code installato (`npm install -g @anthropic-ai/claude-code`)

### Installazione

```bash
# Opzione 1: npx (consigliato per provare)
npx claude-flow@alpha init --force

# Opzione 2: Installazione globale
npm install -g claude-flow@alpha
claude-flow init
```

### Verifica

```bash
npx claude-flow@alpha --version
# Output: claude-flow v2.7.0
```

---

## 5. COMANDI PRINCIPALI

### Swarm - Task Veloci

```bash
# Task semplice
npx claude-flow@alpha swarm "Analizza questo codebase" --claude

# Con più agenti
npx claude-flow@alpha swarm "Refactora il modulo auth" --agents 3 --claude
```

### Hive-Mind - Progetti Complessi

```bash
# Avvia wizard interattivo
npx claude-flow@alpha hive-mind spawn "MioProgetto" --claude

# Lista progetti attivi
npx claude-flow@alpha hive-mind list

# Continua progetto esistente
npx claude-flow@alpha hive-mind resume "MioProgetto" --claude
```

### Memoria Semantica

```bash
# Cerca nella memoria
npx claude-flow@alpha memory vector-search "come funziona l'auth"

# Salva nella memoria
npx claude-flow@alpha memory store "Decisione: usiamo JWT" --tags "auth,security"
```

---

## 6. PERFORMANCE

| Metrica | Valore |
|---------|--------|
| Ricerca semantica | 96x-164x più veloce (AgentDB v1.3.9) |
| Latenza query | 2-3ms |
| Riduzione memoria | 4-32x via quantizzazione |
| SWE-Bench solve rate | 84.8% |

---

## 7. FEATURES AVANZATE

### 25 Claude Skills
Attivazione automatica con linguaggio naturale:
- Development skills
- GitHub integration
- Memory management
- Automation workflows

### 100+ MCP Tools
Integrati via Model Context Protocol:
- File system
- Git/GitHub
- Docker
- Kubernetes
- Database
- AWS/Cloud

### Memoria Ibrida
- **AgentDB:** Ricerca vettoriale veloce
- **ReasoningBank:** SQLite per reasoning persistente

---

## 8. ESEMPIO PRATICO: FEATURE IMPLEMENTATION

```bash
# 1. Avvia hive-mind per feature complessa
npx claude-flow@alpha hive-mind spawn "Dashboard Analytics" --claude

# 2. Il sistema crea automaticamente:
#    - Regina (orchestratore)
#    - Agenti specializzati per:
#      - Frontend
#      - Backend
#      - Database
#      - Testing

# 3. Ogni agente lavora in parallelo
#    - Frontend crea componenti
#    - Backend crea API
#    - Database crea schema
#    - Testing scrive test

# 4. Regina coordina e verifica

# 5. Risultato finale mergiato
```

---

## 9. CONFIGURAZIONE CUSTOM

### File di Configurazione

```yaml
# .claude-flow/config.yaml
version: "2.7"
project:
  name: "MioProgetto"
  type: "hive-mind"

agents:
  frontend:
    model: "sonnet"
    tools: ["file", "git"]
    focus: "frontend/**"

  backend:
    model: "sonnet"
    tools: ["file", "git", "docker"]
    focus: "backend/**"

  tester:
    model: "haiku"
    tools: ["file", "bash"]
    focus: "tests/**"

memory:
  type: "hybrid"
  vector_db: "agentdb"
  sqlite: true

orchestration:
  mode: "queen"
  auto_merge: false
  review_required: true
```

---

## 10. PRO E CONTRO PER CERVELLASWARM

### PRO ✅
- **Enterprise-ready** - Testato, robusto
- **Memoria persistente** - Non perde contesto tra sessioni
- **Parallelismo vero** - Più agenti contemporaneamente
- **100+ tool** - Tutto integrato
- **Ricerca semantica** - Trova info velocemente
- **Coordinamento automatico** - Regina gestisce tutto

### CONTRO ❌
- **Complessità** - Curva di apprendimento ripida
- **Alpha** - Ancora in sviluppo, possibili bug
- **Overhead** - Per task semplici è overkill
- **Dipendenza** - Se cambia/muore, problemi
- **Token usage** - Alto con molti agenti
- **Setup** - Richiede configurazione

---

## 11. QUANDO USARE CLAUDE-FLOW

| Scenario | Usare? | Alternativa |
|----------|--------|-------------|
| 5+ agenti in parallelo | ✅ SÌ | - |
| Progetto multi-settimana | ✅ SÌ | - |
| Task singolo veloce | ❌ NO | Subagent nativo |
| 2-3 agenti paralleli | 🤔 Forse | Worktrees + Subagent |
| Memoria tra sessioni critica | ✅ SÌ | - |
| Setup rapido necessario | ❌ NO | Subagent nativo |

---

## 12. CONFRONTO FINALE

| Aspetto | Subagent Nativi | Worktrees | Claude-Flow |
|---------|-----------------|-----------|-------------|
| Setup | Zero | 10 min | 30+ min |
| Complessità | Bassa | Media | Alta |
| Parallelismo | Sequenziale | Vero | Vero |
| Memoria | Nessuna | Git | Persistente |
| Scalabilità | 2-3 agent | 3-5 agent | 10+ agent |
| Maturità | Stabile | Stabile | Alpha |
| Per noi ora | ✅ Iniziare | ✅ Fase 2 | 🔮 Futuro |

---

## 13. RACCOMANDAZIONE PER CERVELLASWARM

### Fase Attuale (Dicembre 2025)
```
❌ NON usare Claude-Flow ora
   - Troppo complesso per iniziare
   - Alpha = possibili problemi
   - Overhead eccessivo
```

### Fase Futura (quando avremo 5+ agenti)
```
✅ CONSIDERARE Claude-Flow quando:
   - Abbiamo testato subagent + worktrees
   - Servono 5+ agenti paralleli
   - Serve memoria persistente forte
   - Claude-Flow è in versione stabile
```

### Strategia Consigliata
```
1. ORA: Subagent nativi (imparare le basi)
2. PRESTO: + Git Worktrees (vero parallelismo)
3. FUTURO: + Claude-Flow (se serve scalare)
```

---

## 14. RISORSE

- **GitHub:** https://github.com/ruvnet/claude-flow
- **Docs:** (in sviluppo)
- **NPM:** `npx claude-flow@alpha`

---

## 15. PROSSIMI PASSI

1. [x] Studiare subagent
2. [x] Studiare worktrees
3. [x] Studiare Claude-Flow (questo documento)
4. [ ] Decidere architettura per CervellaSwarm
5. [ ] Implementare Fase 1

---

*"Claude-Flow è potente, ma la potenza va usata quando serve."* 🐝⚡
