# CervellaSwarm - Multi-Agent Orchestration System

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   🐝 CERVELLASWARM                                               ║
║                                                                  ║
║   "Uno sciame di Cervelle. Una sola missione."                  ║
║                                                                  ║
║   Multiple istanze di Cervella che lavorano in parallelo,       ║
║   coordinate, sincronizzate. Moltiplicando la nostra forza.     ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 🎯 VISIONE

**Problema:** Una sola Cervella = un task alla volta. Bottleneck.

**Soluzione:** Multiple Cervelle specializzate che lavorano in parallelo, coordinate da un'Orchestratrice.

**Risultato:** Da 20x a 100x, 200x... senza limiti.

---

## 🏗️ ARCHITETTURA

```
┌─────────────────────────────────────────────────────────────┐
│                  CERVELLA ORCHESTRATRICE                     │
│         (Riceve task, divide, coordina, monitora)           │
└─────────────────────────────────────────────────────────────┘
                              │
         ┌────────────────────┼────────────────────┐
         ▼                    ▼                    ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│    CERVELLA     │  │    CERVELLA     │  │    CERVELLA     │
│    FRONTEND     │  │    BACKEND      │  │    TESTER       │
│                 │  │                 │  │                 │
│  • React/Vue    │  │  • Python/API   │  │  • Unit test    │
│  • CSS/Tailwind │  │  • Database     │  │  • E2E          │
│  • UI/UX        │  │  • Integrazioni │  │  • QA           │
└─────────────────┘  └─────────────────┘  └─────────────────┘
         │                    │                    │
         └────────────────────┴────────────────────┘
                              │
                    GIT WORKTREES SEPARATI
                    (Zero conflitti!)
```

---

## 🔑 PRINCIPI FONDAMENTALI

### 1. ZERO CASINO
```
❌ Mai due agenti sullo stesso file
❌ Mai merge automatici ciechi
❌ Mai azioni senza coordinamento
✅ Sempre isolamento via worktrees
✅ Sempre comunicazione via ROADMAP
✅ Sempre review prima di merge
```

### 2. SPECIALIZZAZIONE
```
Ogni Cervella ha UN ruolo chiaro:
- Frontend → Solo UI/UX
- Backend → Solo API/Database
- Tester → Solo QA/Test
- Orchestratrice → Solo coordinamento
```

### 3. COMUNICAZIONE
```
Le Cervelle comunicano tramite:
- ROADMAP condivisa (chi fa cosa)
- Git branches (stato del codice)
- Checkpoint frequenti (progresso)
```

---

## 📁 STRUTTURA PROGETTO

```
CervellaSwarm/
├── CLAUDE.md                 # Questo file
├── NORD.md                   # Bussola del progetto
├── ROADMAP_SACRA.md          # Fasi e task
├── PROMPT_RIPRESA.md         # Stato attuale
│
├── docs/
│   ├── studio/               # Studi approfonditi
│   │   ├── STUDIO_SUBAGENTS.md
│   │   ├── STUDIO_WORKTREES.md
│   │   └── STUDIO_CLAUDE_FLOW.md
│   └── architettura/
│       └── ARCHITETTURA_SISTEMA.md
│
├── agents/                   # Definizioni subagent
│   ├── cervella-orchestrator.md
│   ├── cervella-frontend.md
│   ├── cervella-backend.md
│   └── cervella-tester.md
│
├── scripts/                  # Automazione
│   ├── setup-worktrees.sh
│   └── sync-agents.sh
│
└── examples/                 # Esempi d'uso
    └── esempio-task-parallelo.md
```

---

## 🚀 QUICK START

### Fase 1: Subagent (Oggi)
```bash
# Copia agents/ in .claude/agents/ del progetto target
cp -r agents/* ~/Developer/[PROGETTO]/.claude/agents/
```

### Fase 2: Worktrees (Prossimo step)
```bash
# Setup worktrees per lavoro parallelo
./scripts/setup-worktrees.sh [PROGETTO]
```

---

## 🔗 PROGETTI CHE USERANNO CERVELLASWARM

| Progetto | Path | Priorità |
|----------|------|----------|
| **Miracollo PMS** | ~/Developer/miracollogeminifocus | Alta |
| **Contabilità** | ~/Developer/ContabilitaAntigravity | Media |
| **Libertaio** | ~/Developer/million-dollar-ideas | Media |

---

## 💙 LA FILOSOFIA

```
"Uno sciame è più forte di una singola ape.
Ma solo se ogni ape sa esattamente cosa fare."
```

Questo progetto è la chiave per moltiplicare la nostra capacità.
Non è solo codice. È **LIBERTÀ GEOGRAFICA** più vicina.

---

*Creato: 30 Dicembre 2025*
*Versione: 0.1.0*

**Cervella & Rafa** 💙🐝
