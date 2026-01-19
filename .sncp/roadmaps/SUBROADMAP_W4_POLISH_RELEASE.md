# SUBROADMAP W4 - Polish + v2.0-beta Release

> **Creata:** 19 Gennaio 2026 - Sessione 284
> **Obiettivo:** Stabilita + Lancio v2.0-beta
> **Standard:** Minimo 9.5/10
> **Ricerca:** `.swarm/tasks/TASK_W4_PLANNING_OUTPUT.md`
> **Guardiane:** Ingegnera + Qualita APPROVED

---

## PERCHE W4

```
+================================================================+
|   STATO ATTUALE:                                               |
|   W1-W3 completati (9.75/10 media)                            |
|   Health Score: 9.2/10                                         |
|   85 test manuali esistenti                                    |
|   connect_db() duplicata 4 volte                               |
|   Test coverage: NON MISURATO                                  |
|   CI Python: MANCANTE                                          |
|                                                                |
|   OBIETTIVO W4:                                                |
|   Consolidamento PRIMA di lancio pubblico                      |
|   DRY codebase (debito tecnico zero)                          |
|   Test coverage misurato (baseline 60%+)                       |
|   CI completo (Node + Python)                                  |
|   Release v2.0-beta (momentum pubblico)                        |
|                                                                |
|   FILOSOFIA: SOLIDITA > FEATURES                               |
|   "Fatto BENE > Fatto VELOCE"                                  |
+================================================================+
```

---

## ORDINE (Guardiane approved)

```
Day 1:   Apple Polish DRY (4h)        <- Base pulita
Day 2-3: Test Coverage + CI (6h)      <- Sicurezza
Day 4:   Release v2.0-beta (3h)       <- Lancio!

Totale: ~13h (4 giorni)
```

**Motivazione:**
- DRY piccolo (4h) = si puo fare prima
- Test dopo = baseline su codice pulito
- Release finale = momentum

---

## DAY 1: APPLE POLISH DRY (4h)

### Obiettivo

Eliminare duplicazioni critiche. Health 9.2 -> 9.5+

### Tasks

| # | Task | REQ | Effort | File |
|---|------|-----|--------|------|
| 1 | Centralizza `connect_db()` | REQ-01 | 1.5h | `scripts/common/db.py` |
| 2 | Centralizza ANSI colors | REQ-02 | 1h | `scripts/common/colors.py` |
| 3 | Centralizza config constants | REQ-03 | 30m | `scripts/common/config.py` |
| 4 | Cleanup reports JSON duplicati | REQ-04 | 30m | `reports/` |
| 5 | Verifica import corretti | REQ-05 | 30m | Tutti i file migrati |

### Dettaglio REQ-01: connect_db()

**Problema:** Duplicata in 4 file
- `scripts/memory/analytics.py:95`
- `scripts/memory/weekly_retro.py`
- `scripts/memory/pattern_detector.py`
- `scripts/memory/suggestions.py`

**Soluzione:**
```python
# scripts/common/db.py (NUOVO)
from pathlib import Path
from common.paths import get_db_path
import sqlite3

def connect_db() -> sqlite3.Connection:
    """Connessione centralizzata al database swarm_memory.db"""
    db_path = get_db_path()

    if not db_path.exists():
        raise FileNotFoundError(
            f"Database non trovato: {db_path}\n"
            f"Esegui: cd scripts/memory && ./init_db.py"
        )

    conn = sqlite3.connect(str(db_path))
    conn.row_factory = sqlite3.Row
    return conn
```

**Migrazione:** Sostituire in tutti i 4 file con:
```python
from common.db import connect_db
```

### Dettaglio REQ-02: ANSI Colors

**Problema:** Definiti 3 volte
- `analytics.py` (righe 53-62)
- `suggestions.py`
- `weekly_retro.py`

**Soluzione:**
```python
# scripts/common/colors.py (NUOVO)
"""ANSI color constants per output CLI"""

class Colors:
    RED = "\033[91m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    BLUE = "\033[94m"
    CYAN = "\033[96m"
    MAGENTA = "\033[95m"
    RESET = "\033[0m"
    BOLD = "\033[1m"
    DIM = "\033[2m"

# Shortcut per compatibility
RED = Colors.RED
GREEN = Colors.GREEN
YELLOW = Colors.YELLOW
BLUE = Colors.BLUE
CYAN = Colors.CYAN
RESET = Colors.RESET
BOLD = Colors.BOLD
```

### Dettaglio REQ-03: Config Constants

**Problema:** Magic numbers sparsi
- `SIMILARITY_THRESHOLD = 0.7` (4 posti)
- `MIN_PATTERN_OCCURRENCES = 3`
- `DEFAULT_EVENT_LIMIT = 10`

**Soluzione:**
```python
# scripts/common/config.py (NUOVO)
"""Configuration constants per CervellaSwarm"""

# Pattern Detection
SIMILARITY_THRESHOLD = 0.7
MIN_PATTERN_OCCURRENCES = 3

# Analytics
DEFAULT_EVENT_LIMIT = 10
WEEK_DAYS = 7

# Database
DB_FILENAME = "swarm_memory.db"
```

---

## DAY 2-3: TEST COVERAGE + CI PYTHON (6h)

### Obiettivo

Coverage misurato (60%+) + CI per 85 test Python esistenti.

### Tasks

| # | Task | REQ | Effort | File |
|---|------|-----|--------|------|
| 1 | Setup pytest-cov | REQ-06 | 1h | `requirements-dev.txt`, `pyproject.toml` |
| 2 | Baseline coverage report | REQ-07 | 1h | `pytest --cov` |
| 3 | GitHub Actions Python CI | REQ-08 | 2h | `.github/workflows/test-python.yml` |
| 4 | Coverage threshold 60% | REQ-09 | 1h | CI config |
| 5 | Fix test failures se presenti | REQ-10 | 1h | Test suite |

### Dettaglio REQ-06: Setup pytest-cov

**File:** `requirements-dev.txt`
```
pytest>=7.0.0
pytest-cov>=4.0.0
pytest-timeout>=2.0.0
```

**File:** `pyproject.toml` (aggiungere sezione)
```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
addopts = "-v --tb=short"

[tool.coverage.run]
source = ["scripts"]
omit = ["scripts/learning/*", "scripts/engineer/*"]

[tool.coverage.report]
fail_under = 60
show_missing = true
```

### Dettaglio REQ-08: GitHub Actions Python CI

**File:** `.github/workflows/test-python.yml` (NUOVO)
```yaml
name: Python Tests

on:
  push:
    branches: [main]
    paths:
      - 'scripts/**'
      - 'tests/**'
      - 'pyproject.toml'
  pull_request:
    branches: [main]
    paths:
      - 'scripts/**'
      - 'tests/**'

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements-dev.txt

      - name: Run tests with coverage
        run: |
          pytest tests/ --cov=scripts --cov-report=xml --cov-report=term

      - name: Check coverage threshold
        run: |
          coverage report --fail-under=60
```

---

## DAY 4: RELEASE v2.0-beta (3h)

### Obiettivo

Tag release + npm publish + announcement pubblico.

### Tasks

| # | Task | REQ | Effort | File |
|---|------|-----|--------|------|
| 1 | Scrivere CHANGELOG.md completo | REQ-11 | 1h | `CHANGELOG.md` |
| 2 | Version bump packages | REQ-12 | 30m | `package.json` |
| 3 | npm publish CLI + MCP | REQ-13 | 30m | npm registry |
| 4 | Git tag v2.0.0-beta | REQ-14 | 15m | git |
| 5 | Announcement draft | REQ-15 | 45m | Show HN, Twitter |

### Dettaglio REQ-11: CHANGELOG.md

**Struttura:**
```markdown
# Changelog

## [2.0.0-beta] - 2026-01-XX

### Added
- **W1 Git Flow 2.0**: Worker attribution, auto-commit
- **W2 Tree-sitter**: AST parsing, PageRank ranking
- **W3 Semantic Search**: find_symbol, find_callers, estimate_impact
- **W3 Architect Pattern**: Planning before implementation
- **W4 DRY Polish**: Centralized db, colors, config

### Changed
- Test coverage now measured (60%+ baseline)
- CI pipeline includes Python tests

### Fixed
- connect_db() duplication eliminated
- ANSI colors centralized

## [0.1.2] - 2026-01-19
...precedenti release...
```

### Dettaglio REQ-15: Announcement

**Show HN Update:**
```
Hi HN! Update on CervellaSwarm (AI Team for developers).

Since launch we've shipped:
- Semantic code search (find symbols, callers, impact)
- Architect pattern (AI plans before coding)
- 60%+ test coverage
- Tree-sitter AST parsing with PageRank

Try it: npx cervellaswarm init

GitHub: github.com/rafapra3008/cervellaswarm
```

---

## W4 TEST SUITE (T01-T12)

| Test | Cosa Verifica | Expected |
|------|---------------|----------|
| T01 | connect_db() unica definizione | 1 file only |
| T02 | Colors importati da common | 0 definizioni locali |
| T03 | Config constants centralizzati | 1 file only |
| T04 | pytest-cov installato | `pip show pytest-cov` OK |
| T05 | Coverage report generato | `.coverage` file exists |
| T06 | Coverage >= 60% | `coverage report` pass |
| T07 | CI Python workflow esiste | `.github/workflows/test-python.yml` |
| T08 | CI passa su main | GitHub Actions green |
| T09 | CHANGELOG.md completo | Sezione 2.0.0-beta |
| T10 | npm packages pubblicati | `npm view cervellaswarm` OK |
| T11 | Git tag v2.0.0-beta | `git tag` contains |
| T12 | No regressioni W3 | 85 test PASS |

---

## W4 ACCEPTANCE CRITERIA

| # | Criterio | Peso | Threshold |
|---|----------|------|-----------|
| AC1 | DRY completato | 20% | T01-T03 PASS |
| AC2 | Coverage setup | 20% | T04-T06 PASS |
| AC3 | CI Python | 20% | T07-T08 PASS |
| AC4 | Release artifacts | 20% | T09-T11 PASS |
| AC5 | No regressioni | 20% | T12 PASS (85 test) |

### Formula Score W4

```
Score = (AC1*0.2 + AC2*0.2 + AC3*0.2 + AC4*0.2 + AC5*0.2) * 10
Target: >= 9.5/10
```

---

## FILE DA CREARE/MODIFICARE

### Nuovi File

| File | Scopo | Day |
|------|-------|-----|
| `scripts/common/db.py` | Connessione DB centralizzata | 1 |
| `scripts/common/colors.py` | ANSI colors centralizzati | 1 |
| `scripts/common/config.py` | Config constants | 1 |
| `requirements-dev.txt` | Dev dependencies | 2 |
| `.github/workflows/test-python.yml` | CI Python | 2 |
| `CHANGELOG.md` | Release notes | 4 |

### File da Modificare

| File | Modifica | Day |
|------|----------|-----|
| `scripts/memory/analytics.py` | Import da common/ | 1 |
| `scripts/memory/weekly_retro.py` | Import da common/ | 1 |
| `scripts/memory/pattern_detector.py` | Import da common/ | 1 |
| `scripts/memory/suggestions.py` | Import da common/ | 1 |
| `pyproject.toml` | pytest + coverage config | 2 |
| `packages/cli/package.json` | Version 2.0.0-beta | 4 |
| `packages/mcp-server/package.json` | Version 2.0.0-beta | 4 |

---

## DIPENDENZE

```
W4 dipende da:
├── W1 Git Flow ✅ DONE
├── W2 Tree-sitter ✅ DONE
├── W3 Semantic + Architect ✅ DONE
└── GitHub repo pubblico ✅ DONE
```

---

## METRICHE SUCCESSO W4

| Metrica | Baseline | Target | Come |
|---------|----------|--------|------|
| Health Score | 9.2/10 | 9.5+/10 | Post-audit |
| connect_db() duplicati | 4 | 0 | grep count |
| Test coverage | N/A | 60%+ | pytest-cov |
| CI status | Node only | Node + Python | GitHub Actions |
| npm version | 0.1.2 | 2.0.0-beta | npm view |

---

## RISCHI & MITIGAZIONI

| Rischio | Mitigazione |
|---------|-------------|
| Coverage scopre bug | BENE! Fix prima di release |
| DRY rompe import | Test T12 li protegge |
| CI Python fallisce | Fix prima di merge |
| Announcement timing | Draft pronto, pubblica dopo CI green |

---

## STIMA TOTALE

| Componente | Effort |
|------------|--------|
| Day 1: Apple Polish DRY | 4h |
| Day 2-3: Test Coverage + CI | 6h |
| Day 4: Release v2.0-beta | 3h |
| **TOTALE** | **13h (4 giorni)** |

---

## POST-W4: FASI FUTURE

### v2.1 - Maintenance Sprint (Post-feedback utenti)

| Item | Effort | Priorita |
|------|--------|----------|
| Split analytics.py (879 -> 3 moduli) | 4h | ALTA |
| Split weekly_retro.py (694 -> 2 moduli) | 3h | ALTA |
| Coverage target 80% | 4h | MEDIA |
| Rich Output centralizzato | 3h | MEDIA |
| Error handling standardizzato | 2h | MEDIA |

### v2.2 - User Experience

| Item | Effort | Priorita |
|------|--------|----------|
| Documentation tutorial 15min | 3h | ALTA |
| 3 use case examples | 3h | ALTA |
| Video walkthrough 5min | 2h | MEDIA |
| FAQ update post-feedback | 2h | MEDIA |

### v2.3 - Monitoring & Observability

| Item | Effort | Priorita |
|------|--------|----------|
| `swarm-status` CLI | 2h | ALTA |
| Health endpoint API | 3h | ALTA |
| `check-stuck-workers.sh` | 1h | MEDIA |
| Log aggregation | 3h | MEDIA |

### v3.0 - Advanced Features (FASE 8+)

| Item | Effort | Priorita |
|------|--------|----------|
| Visual Plan (Mermaid) | 2 giorni | NICE-TO-HAVE |
| Background Agents Pattern | 3 giorni | NICE-TO-HAVE |
| Multi-project memory globale | 4h | NICE-TO-HAVE |
| Auto-context refresh avanzato | 2 giorni | NICE-TO-HAVE |

---

## NICE-TO-HAVE BACKLOG

Questi item sono stati valutati ma **rimandati** per focus su stabilita:

| Item | Perche Rimandato | Quando |
|------|------------------|--------|
| Visual Plan (Mermaid) | Estetico, non funzionale | v3.0+ |
| Auto-Context Refresh | Gia fatto in W2.5! | N/A |
| Background Agents | Architettura avanzata | FASE 8 |
| Template task pronti | Nice-to-have per DX | v2.2 |
| Quick start guide altri progetti | Post-beta | v2.2 |

---

## AUDIT CHECKLIST

Dopo ogni Day, verificare:

- [ ] **Day 1:** `grep -r "def connect_db" scripts/` -> solo common/db.py
- [ ] **Day 1:** `grep -r "RED = " scripts/` -> solo common/colors.py
- [ ] **Day 2:** `pytest tests/ --cov` -> report generato
- [ ] **Day 3:** GitHub Actions -> Python job green
- [ ] **Day 4:** `npm view cervellaswarm` -> version 2.0.0-beta
- [ ] **Day 4:** `git tag` -> v2.0.0-beta presente

---

## DECISIONI GUARDIANE

**Ingegnera (9/10):**
- Test DOPO Polish piccolo = OK
- Split file grandi = v2.1
- Focus = DRY + Coverage + Release

**Guardiana Qualita (9/10):**
- Piano COMPLETO
- Gap CI Python identificato e incluso
- Ordine esecuzione corretto

**Consenso:** APPROVED per esecuzione

---

*"W4 = Stabilita + Lancio. Il sistema e gia potente!"*
*"Fatto BENE > Fatto VELOCE"*
*"Minimo 9.5 di score!"*

**Cervella & Rafa - Sessione 284**
