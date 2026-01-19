# OVERVIEW CervellaSwarm 2.0 - 4 Settimane

> **Inizio:** 20 Gennaio 2026 (post Show HN)
> **Fine:** 16 Febbraio 2026
> **Obiettivo:** v2.0-beta release

---

## TIMELINE VISIVA

```
        GENNAIO 2026                    FEBBRAIO 2026
   20  21  22  23  24  25  26    27  28  29  30  31   1   2    3   4   5   6   7   8   9   10-16
   |___|___|___|___|___|___|_____|___|___|___|___|___|___|_____|___|___|___|___|___|___|_____|______|
   |       SETTIMANA 1          |       SETTIMANA 2         |       SETTIMANA 3         | W4     |
   |     GIT FLOW               |     TREE-SITTER           |     ARCHITECT/EDITOR      | POLISH |
   |     + Attribution          |     Repo Mapping          |     Pattern               | +TEST  |
```

---

## SETTIMANA 1: GIT FLOW + ATTRIBUTION (20-26 Gen)

**Obiettivo:** Auto-commit professionale per ogni worker

| Giorno | Task | Deliverable |
|--------|------|-------------|
| Lun 20 | Setup + Script base | `git_worker_commit.sh` |
| Mar 21 | Conventional Commits | Parser tipo + scope |
| Mer 22 | Attribution | Co-authored-by mapping |
| Gio 23 | Integrazione CLI | spawn-workers integration |
| Ven 24 | Undo command | `/undo` con safety |
| Sab-Dom | Docs + Polish | `docs/GIT_ATTRIBUTION.md` |

**Output:** Commit automatici con formato `feat(scope): message (worker-name)`

---

## SETTIMANA 2: TREE-SITTER REPO MAPPING (27 Gen - 2 Feb)

**Obiettivo:** -80% token usage tramite mappa codice intelligente

| Giorno | Task | Deliverable |
|--------|------|-------------|
| Lun 27 | Setup py-tree-sitter | Dipendenze installate |
| Mar 28 | Parser Python/JS/TS | `treesitter_parser.py` |
| Mer 29 | Repo mapper core | `repo_mapper.py` |
| Gio 30 | Integrazione spawn | Worker ricevono mappa |
| Ven 31 | Test su CervellaSwarm | Benchmark token usage |
| Sab-Dom | Docs + Polish | `docs/REPO_MAPPING.md` |

**Output:** Worker ricevono ~2k token invece di ~10k per task

---

## SETTIMANA 3: ARCHITECT/EDITOR PATTERN (3-9 Feb)

**Obiettivo:** +15% accuracy separando ragionamento da implementazione

| Giorno | Task | Deliverable |
|--------|------|-------------|
| Lun 3 | Agent cervella-architect | `~/.claude/agents/cervella-architect.md` |
| Mar 4 | Flow orchestration | `architect_editor_flow.py` |
| Mer 5 | Integrazione Regina | Routing 2-step |
| Gio 6 | Benchmark 5 task | Metriche accuracy |
| Ven 7 | Benchmark 5 task | Confronto 1-step vs 2-step |
| Sab-Dom | Tuning + Docs | `docs/ARCHITECT_EDITOR.md` |

**Output:** Task complessi passano prima da Architect poi a Editor

---

## SETTIMANA 4: POLISH + v2.0-BETA (10-16 Feb)

**Obiettivo:** Release stabile v2.0-beta

| Giorno | Task | Deliverable |
|--------|------|-------------|
| Lun 10 | Integration test | Tutte le feature insieme |
| Mar 11 | Bug fix | Issues trovati |
| Mer 12 | Performance test | Benchmark finali |
| Gio 13 | Docs finali | README v2.0 |
| Ven 14 | npm publish | cervellaswarm@2.0.0-beta |
| Sab-Dom | Annuncio | Update HN, Reddit, Twitter |

**Output:** v2.0-beta su npm, pronta per early adopters

---

## METRICHE SUCCESSO COMPLESSIVE

| Metrica | Baseline | Target W4 |
|---------|----------|-----------|
| Token usage/task | 10k | 2k (-80%) |
| Task success rate | 70% | 85% (+15%) |
| Commit quality | Manual | 100% conventional |
| Git history | Confusa | Professionale |

---

## RISCHI E MITIGAZIONI

| Rischio | Prob | Impatto | Mitigazione |
|---------|------|---------|-------------|
| Tree-sitter parsing errors | Media | Alto | Fallback a file interi |
| Architect loop infinito | Bassa | Medio | Timeout + max iterations |
| Git hook conflicts | Media | Basso | Flag --no-verify option |

---

## FILE DI RIFERIMENTO

| File | Contenuto |
|------|-----------|
| `SUBROADMAP_CERVELLASWARM_2.0_AIDER_FEATURES.md` | Dettagli tecnici feature |
| `TASK_BREAKDOWN_2.0_W1_GIT_FLOW.md` | Task giornalieri W1 |
| `docs/studio/STUDIO_GIT_FLOW_AI_AGENTS.md` | Ricerca Aider |
| `docs/studio/RICERCA_AIDER_APPROFONDITA.md` | Ricerca completa Aider |

---

## CHECKPOINT

| Data | Milestone |
|------|-----------|
| 26 Gen | W1 completa - Git Flow funzionante |
| 2 Feb | W2 completa - Tree-sitter funzionante |
| 9 Feb | W3 completa - Architect/Editor funzionante |
| 16 Feb | v2.0-beta released! |

---

*"Un progresso al giorno. 4 settimane. v2.0-beta."*

*Creato: 19 Gennaio 2026 - Sessione 270*
*Post Show HN Launch Day!*
