# CervellaSwarm

> Sistema multi-agent: 16 Cervelle coordinate dalla Regina.
> Regole operative complete: `~/.claude/CLAUDE.md`

## SNCP - Struttura Progetto

```
CervellaSwarm/.sncp/
├── progetti/
│   ├── cervellaswarm/    # PROMPT_RIPRESA, stato.md
│   ├── miracollo/        # PROMPT_RIPRESA, stato.md
│   └── contabilita/      # PROMPT_RIPRESA, stato.md
├── stato/oggi.md         # Stato globale
├── handoff/              # Handoff sessioni
└── roadmaps/             # Piani lavoro
```

**INIZIO SESSIONE:** Leggi `.sncp/progetti/{progetto}/PROMPT_RIPRESA_{progetto}.md`

## Hook Attivi (CervellaSwarm)

| Hook | Cosa Fa |
|------|---------|
| session_start_swarm.py | Carica COSTITUZIONE + PROMPT_RIPRESA |
| file_limits_guard.py | Verifica limiti (150/60/500 righe) |
| subagent_start_costituzione.py | Inietta COSTITUZIONE agli agenti |

## La Famiglia

16 agenti in `~/.claude/agents/`:
- 1 Regina (orchestrator) + 3 Guardiane (Opus)
- 12 Worker specializzati (Sonnet)

Dettagli: `docs/DNA_FAMIGLIA.md`

## File Chiave

| File | Scopo |
|------|-------|
| `NORD.md` | Direzione progetto |
| `.sncp/PROMPT_RIPRESA_MASTER.md` | Overview tutti progetti |
| `.sncp/roadmaps/` | Piani e subroadmap |

## Comandi

```bash
spawn-workers --list          # Agenti disponibili
spawn-workers --backend       # Lancia backend worker
./tests/run_all_tests.sh      # Test suite
```

## Progetti Collegati

- Miracollo: `~/Developer/miracollogeminifocus`
- Contabilita: `~/Developer/ContabilitaAntigravity`
