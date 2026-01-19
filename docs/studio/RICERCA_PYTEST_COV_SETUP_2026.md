# RICERCA: Pytest-cov Setup & GitHub Actions CI 2026

**Data**: 2026-01-19
**Researcher**: Cervella Researcher
**Status**: COMPLETATO

## TL;DR

Configurazione completa per pytest-cov + GitHub Actions CI con:
- Coverage threshold 60% (ragionevole per progetto esistente)
- Matrix testing Python 3.10-3.12
- Report HTML + Term + XML
- Cache pip per velocità
- Badge coverage (opzionale: Codecov)

---

## 1. PYTEST-COV SETUP

### 1.1 Requirements-dev.txt

```txt
# Testing & Coverage
pytest>=7.0.0
pytest-cov>=4.0.0
pytest-asyncio>=0.21.0  # Se servono test async

# Linting (opzionale ma raccomandato)
ruff>=0.1.0
black>=23.0.0
```

**Installazione**:
```bash
pip install -r requirements-dev.txt
```

### 1.2 Pyproject.toml - Configurazione Completa

Aggiungi al file esistente `cervella/pyproject.toml`:

```toml
# === PYTEST CONFIGURATION ===
[tool.pytest.ini_options]
testpaths = ["tests"]
pythonpath = ["."]  # Include root per imports

# Coverage options
addopts = [
    "--cov=scripts",           # Copri scripts/
    "--cov=src",               # Copri src/ (MCP server)
    "--cov=cervella",          # Copri cervella/
    "--cov-report=html",       # Report HTML in htmlcov/
    "--cov-report=term-missing", # Report terminal con righe mancanti
    "--cov-report=xml",        # Report XML per CI tools
    "--cov-fail-under=60",     # FAIL se < 60%
    "--verbose",
]

# Markers per categorizzare test
markers = [
    "slow: marks tests as slow (deselect with '-m \"not slow\"')",
    "integration: marks tests as integration tests",
    "unit: marks tests as unit tests",
]

# === COVERAGE CONFIGURATION ===
[tool.coverage.run]
source = ["scripts", "src", "cervella"]
omit = [
    # Test files
    "*/tests/*",
    "*/test_*.py",
    "*_test.py",

    # Virtual environments
    "*/.venv/*",
    "*/venv/*",
    "*/env/*",

    # Python internals
    "*/__pycache__/*",
    "*/site-packages/*",

    # Setup files
    "setup.py",
    "conftest.py",

    # Specifici CervellaSwarm (se necessario)
    "scripts/*/README*.py",  # Script README
]

[tool.coverage.report]
# Escludi da report file senza codice significativo
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError",
    "if __name__ == .__main__.:",
    "if TYPE_CHECKING:",
    "if typing.TYPE_CHECKING:",
    "@abstract",
]

precision = 2  # 2 decimali nei percentuali
show_missing = true  # Mostra righe mancanti
skip_covered = false  # Non saltare file 100% coperti

[tool.coverage.html]
directory = "htmlcov"  # Output HTML report
```

### 1.3 Comandi Essenziali

```bash
# Test base
pytest

# Test con coverage dettagliato
pytest --cov --cov-report=term-missing

# Solo report HTML (apre browser)
pytest --cov --cov-report=html
open htmlcov/index.html  # macOS
xdg-open htmlcov/index.html  # Linux

# Test specifici senza coverage (più veloce)
pytest tests/test_memory.py -v

# Test con markers
pytest -m "not slow"  # Escludi test lenti
pytest -m integration  # Solo integration test

# Coverage minima 80% (fallisce se < 80%)
pytest --cov --cov-fail-under=80
```

---

## 2. GITHUB ACTIONS CI

### 2.1 File: `.github/workflows/test-python.yml`

Crea nuovo workflow per test Python:

```yaml
# GitHub Actions: Python Test Suite with Coverage
#
# Trigger: Push/PR su main con modifiche Python
# Matrix: Python 3.10, 3.11, 3.12
# Output: Coverage report, badge-ready XML
#
# "Fatto BENE > Fatto VELOCE" - CervellaSwarm

name: Python Tests

on:
  push:
    branches: [main]
    paths:
      - '**.py'
      - 'requirements*.txt'
      - 'pyproject.toml'
      - 'tests/**'
      - '.github/workflows/test-python.yml'
  pull_request:
    branches: [main]
    paths:
      - '**.py'
      - 'requirements*.txt'
      - 'pyproject.toml'
      - 'tests/**'

# Cancella run precedenti su stesso branch
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  test:
    name: Test (Python ${{ matrix.python-version }})
    runs-on: ubuntu-latest
    timeout-minutes: 15

    strategy:
      fail-fast: false  # Continua anche se una versione fallisce
      matrix:
        python-version: ["3.10", "3.11", "3.12"]

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
          cache: 'pip'  # Cache automatica pip dependencies
          cache-dependency-path: |
            requirements*.txt
            cervella/pyproject.toml

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements-dev.txt
          # Installa cervella package in dev mode
          pip install -e cervella/

      - name: Run linting (Python 3.12 only)
        if: matrix.python-version == '3.12'
        run: |
          ruff check scripts/ src/ cervella/
        continue-on-error: true  # Warning, non blocca

      - name: Run tests with coverage
        run: |
          pytest --cov --cov-report=term --cov-report=xml

      - name: Upload coverage to Codecov (Python 3.12 only)
        if: matrix.python-version == '3.12'
        uses: codecov/codecov-action@v4
        with:
          files: ./coverage.xml
          flags: unittests
          name: codecov-cervellaswarm
          fail_ci_if_error: false  # Non blocca se Codecov fallisce
        env:
          CODECOV_TOKEN: ${{ secrets.CODECOV_TOKEN }}  # Opzionale per repo pubblici

      - name: Upload HTML coverage report (Python 3.12 only)
        if: matrix.python-version == '3.12'
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report-html
          path: htmlcov/
          retention-days: 30

  # Job di riepilogo (sempre eseguito)
  test-summary:
    name: Test Summary
    needs: [test]
    runs-on: ubuntu-latest
    if: always()

    steps:
      - name: Check test results
        run: |
          if [ "${{ needs.test.result }}" == "success" ]; then
            echo "✅ Tutti i test passati!"
          else
            echo "❌ Alcuni test falliti"
            exit 1
          fi
```

### 2.2 Workflow Varianti

**Variante MINIMA (senza Codecov)**:

Rimuovi lo step "Upload coverage to Codecov" se non serve.

**Variante CON BADGE LOCALE** (senza servizi esterni):

Aggiungi step dopo test:

```yaml
      - name: Generate coverage badge
        if: matrix.python-version == '3.12' && github.ref == 'refs/heads/main'
        run: |
          pip install coverage-badge
          coverage-badge -o coverage.svg -f

      - name: Commit coverage badge
        if: matrix.python-version == '3.12' && github.ref == 'refs/heads/main'
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add coverage.svg
          git commit -m "Update coverage badge" || echo "No changes to badge"
          git push
```

---

## 3. COVERAGE THRESHOLD BEST PRACTICES

### 3.1 Soglie Raccomandate

| Fase Progetto | Threshold | Rationale |
|---------------|-----------|-----------|
| **Progetto esistente** | 60% | Punto partenza ragionevole |
| **Progetto maturo** | 75% | Buona copertura |
| **Progetto critico** | 85-90% | Alta affidabilità |
| **Nuovo progetto** | 80%+ | Parti con standard alto |

**Per CervellaSwarm**: Partirei con **60%** e aumentare gradualmente.

### 3.2 Flag --cov-fail-under

```bash
# Fallisce se coverage < 60%
pytest --cov --cov-fail-under=60

# Fallisce se coverage < 75%
pytest --cov --cov-fail-under=75

# No fail, solo report
pytest --cov
```

**In CI**: Usa `--cov-fail-under` nel workflow per bloccare merge se coverage scende.

### 3.3 Strategia Incrementale

```markdown
# Roadmap Coverage CervellaSwarm

Mese 1: 60% (baseline)
↓
Mese 2: 65% (nuovi test)
↓
Mese 3: 70% (refactor test difficili)
↓
Target: 75% (steady state)
```

**IMPORTANTE**: Meglio 60% fatto BENE che 90% con test finti!

---

## 4. INTEGRAZIONE CON PROGETTO ESISTENTE

### 4.1 Step di Implementazione

```bash
# 1. Installa dipendenze
pip install pytest pytest-cov pytest-asyncio

# 2. Baseline coverage attuale
pytest --cov --cov-report=term
# Output: X% coverage

# 3. Aggiorna pyproject.toml con threshold ATTUALE
# --cov-fail-under=[X]  (usa X% attuale, non 60% subito!)

# 4. Verifica che CI passa
pytest --cov --cov-fail-under=[X]

# 5. Incrementa threshold gradualmente ogni settimana
# Week 1: X%
# Week 2: X+2%
# Week 3: X+4%
# Target: 60%
```

### 4.2 File da Creare/Modificare

```
CervellaSwarm/
├── .github/workflows/
│   └── test-python.yml          [NUOVO] ← Workflow CI
├── cervella/
│   └── pyproject.toml           [EDIT] ← Aggiungi [tool.pytest] e [tool.coverage]
├── requirements-dev.txt         [EDIT] ← Aggiungi pytest-cov
├── tests/
│   ├── conftest.py              [ESISTE] ← Già presente
│   └── test_*.py                [ESISTE] ← Test esistenti
├── .coveragerc                  [NO] ← Non serve, usiamo pyproject.toml
└── htmlcov/                     [GIT IGNORE] ← Output HTML report
```

### 4.3 .gitignore Additions

Aggiungi a `.gitignore`:

```gitignore
# Coverage reports
htmlcov/
.coverage
.coverage.*
coverage.xml
*.cover
.pytest_cache/
```

---

## 5. BADGE COVERAGE (OPZIONALE)

### Opzione A: Codecov (Servizio Esterno)

1. Registra progetto su [codecov.io](https://codecov.io)
2. Aggiungi token a GitHub Secrets: `CODECOV_TOKEN`
3. Badge URL:
   ```markdown
   ![Coverage](https://codecov.io/gh/username/cervellaswarm/branch/main/graph/badge.svg)
   ```

**Pro**: Report bellissimi, trend storici, PR comments
**Contro**: Servizio esterno, richiede account

### Opzione B: Badge Locale (Self-Hosted)

Usa `coverage-badge` per generare SVG:

```bash
pip install coverage-badge
pytest --cov
coverage-badge -o coverage.svg -f
```

Commit `coverage.svg` nel repo e usa in README:

```markdown
![Coverage](./coverage.svg)
```

**Pro**: Zero dipendenze esterne
**Contro**: Badge va aggiornato manualmente/CI

### Opzione C: Nessun Badge

**La mia raccomandazione**: Parti SENZA badge. Focus su coverage solida, badge dopo.

---

## 6. COMANDI RAPIDI CHEATSHEET

```bash
# === SVILUPPO LOCALE ===

# Test veloce (no coverage)
pytest -v

# Test con coverage HTML
pytest --cov --cov-report=html && open htmlcov/index.html

# Test specifico file
pytest tests/test_memory.py --cov=scripts.memory -v

# Test solo quello che ho modificato (fast)
pytest --lf  # Last failed
pytest --ff  # Failed first, then rest

# === CI/CD ===

# Simula CI locale (con threshold)
pytest --cov --cov-fail-under=60 --cov-report=term

# Coverage report per file specifico
pytest --cov=scripts.memory.analytics --cov-report=term-missing

# === DEBUG ===

# Test con output completo
pytest -vv -s

# Test con debugger se fallisce
pytest --pdb

# Test lenti in parallelo (se installi pytest-xdist)
pytest -n auto  # Usa tutti i core
```

---

## 7. ESEMPI PRATICI CERVELLASWARM

### 7.1 Test Memory Analytics (Esempio)

```python
# tests/test_memory_analytics.py
"""Test suite per scripts/memory/analytics.py"""

import pytest
from pathlib import Path
from scripts.memory.analytics import (
    calculate_stats,
    generate_report,
)


@pytest.fixture
def sample_memory_file(tmp_path):
    """Fixture: Crea file memoria temporaneo."""
    memory_file = tmp_path / "test_memoria.json"
    memory_file.write_text('{"test": "data"}')
    return memory_file


def test_calculate_stats_with_valid_data(sample_memory_file):
    """Test: Calcolo statistiche con dati validi."""
    stats = calculate_stats(sample_memory_file)

    assert stats is not None
    assert "total_entries" in stats
    assert stats["total_entries"] > 0


@pytest.mark.slow
def test_generate_report_performance(sample_memory_file):
    """Test: Performance generazione report (marcato come slow)."""
    import time
    start = time.time()

    report = generate_report(sample_memory_file)

    elapsed = time.time() - start
    assert elapsed < 5.0  # Max 5 secondi
    assert report is not None
```

### 7.2 Esecuzione

```bash
# Test normali (escludi slow)
pytest -m "not slow"

# Solo test analytics
pytest tests/test_memory_analytics.py -v

# Coverage per analytics
pytest tests/test_memory_analytics.py --cov=scripts.memory.analytics --cov-report=term-missing
```

---

## 8. TROUBLESHOOTING

### Problema: "No module named 'scripts'"

**Soluzione**: Aggiungi root a Python path in `conftest.py`:

```python
# tests/conftest.py
import sys
from pathlib import Path

project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))
```

### Problema: Coverage 0% in CI

**Cause**:
1. Path errati in `[tool.coverage.run] source`
2. Test non trovano codice da testare

**Fix**:
```toml
[tool.pytest.ini_options]
pythonpath = ["."]  # Include project root
```

### Problema: CI lentissimo

**Fix**: Usa cache pip e parallelizza:

```yaml
# .github/workflows/test-python.yml
- name: Setup Python
  uses: actions/setup-python@v5
  with:
    cache: 'pip'  # ← FONDAMENTALE!
```

```bash
# Locale: test paralleli
pip install pytest-xdist
pytest -n auto
```

---

## 9. RACCOMANDAZIONE FINALE

### Setup Minimo (Parti da qui)

1. **Aggiungi a `cervella/pyproject.toml`**:
   ```toml
   [tool.pytest.ini_options]
   testpaths = ["tests"]
   addopts = [
       "--cov=scripts",
       "--cov=src",
       "--cov-report=term-missing",
       "--cov-report=html",
       "--cov-fail-under=60",
   ]

   [tool.coverage.run]
   source = ["scripts", "src"]
   omit = ["*/tests/*", "*/.venv/*"]
   ```

2. **Installa dipendenze**:
   ```bash
   pip install pytest pytest-cov
   ```

3. **Verifica funziona**:
   ```bash
   pytest --cov
   ```

4. **Crea workflow CI** (copia da sezione 2.1)

5. **Commit e push** - CI parte automaticamente!

### Evoluzione Futura

- **Settimana 1**: Baseline 60%
- **Settimana 2**: Aggiungi test per funzioni critiche
- **Settimana 3**: Porta a 65%
- **Mese 2**: Badge Codecov (opzionale)
- **Mese 3**: Target 75%

**Priorità**: Coverage QUALITÀ > coverage QUANTITÀ. Test significativi!

---

## FONTI

- [pytest-cov Configuration](https://pytest-cov.readthedocs.io/en/latest/config.html)
- [GitHub Actions setup-python](https://github.com/actions/setup-python)
- [Real Python: CI/CD with GitHub Actions](https://realpython.com/github-actions-python/)
- [Coverage.py Best Practices](https://learn.scientific-python.org/development/guides/coverage/)
- [Pytest Documentation](https://docs.pytest.org/en/stable/explanation/goodpractices.html)
- [Codecov Python Guide](https://about.codecov.io/blog/python-code-coverage-using-github-actions-and-codecov/)
- [pytest-cov PyPI](https://pypi.org/project/pytest-cov/)

---

**Fine Ricerca** - Cervella Researcher, 19 Gennaio 2026
