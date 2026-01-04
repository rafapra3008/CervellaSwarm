# .swarm/ - Sistema Multi-Finestra CervellaSwarm

Questa directory contiene il sistema di comunicazione tra finestre Claude Code.

## Quick Start

```bash
# Spawna un worker backend
spawn-workers --backend

# Spawna frontend + backend + tester
spawn-workers --all

# Lista tutti i worker disponibili
spawn-workers --list

# Spawna guardiane (Opus)
spawn-workers --guardiane
```

**NOTA:** `spawn-workers` è GLOBALE! Funziona da qualsiasi progetto con `.swarm/`

## Struttura
- `tasks/` - Task queue con flag files
- `status/` - Stato delle finestre attive
- `locks/` - Lock per file critici
- `handoff/` - File per handoff su compact
- `logs/` - Log operazioni
- `archive/` - Task completati (archiviati)
- `acks/` - Acknowledgment files
- `prompts/` - Prompt templates per worker
- `runners/` - Runner scripts temporanei

## Flag Files
- `.ready` - Task pronto per essere preso
- `.working` - Task in lavorazione
- `.done` - Task completato
- `.error` - Task fallito

## Come Creare un Task

```bash
# 1. Crea file task
cat > .swarm/tasks/TASK_NOME.md << 'EOF'
# Task: Descrizione

**Assegnato a:** cervella-backend
**Stato:** ready

## Obiettivo
Descrizione del task...

## Output
Scrivi in TASK_NOME_output.md
EOF

# 2. Marca come ready
touch .swarm/tasks/TASK_NOME.ready

# 3. Spawna worker
spawn-workers --backend
```

## Worker Disponibili

| Worker | Specializzazione |
|--------|------------------|
| backend | Python, FastAPI, API REST |
| frontend | React, CSS, Tailwind |
| tester | Testing, Debug, QA |
| docs | Documentazione |
| reviewer | Code review |
| devops | Deploy, CI/CD |
| researcher | Ricerca tecnica |
| data | SQL, analytics |
| security | Sicurezza, audit |
| scienziata | Ricerca strategica, mercato |
| ingegnera | Analisi codebase, tech debt |

## Guardiane (Opus)

| Guardiana | Ruolo |
|-----------|-------|
| guardiana-qualita | Verifica output agenti |
| guardiana-ops | Supervisiona devops/security |
| guardiana-ricerca | Verifica ricerche |

## Setup per Altri Progetti

1. Crea struttura `.swarm/`:
```bash
mkdir -p .swarm/{tasks,logs,status,locks,handoff,archive,acks,prompts,runners}
```

2. `spawn-workers` è già globale in `~/.local/bin/`

3. Pronto!

---

*CervellaSwarm v1.9.0 - "È proprio magia!"*
