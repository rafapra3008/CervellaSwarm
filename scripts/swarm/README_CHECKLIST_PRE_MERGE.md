# Checklist Pre-Merge - 4 Quality Gates

Script di verifica a 4 livelli prima di ogni merge nello sciame CervellaSwarm.

## Quick Start

```bash
# Verifica completa (tutti i gate)
./scripts/swarm/checklist-pre-merge.sh

# Verifica senza test (sviluppo veloce)
./scripts/swarm/checklist-pre-merge.sh --skip-tests

# Verifica con auto-fix lint (se disponibile)
./scripts/swarm/checklist-pre-merge.sh --auto-fix
```

## I 4 Gate

### GATE 1: SYNTAX CHECK
Verifica che tutti i file siano sintatticamente corretti.

**Cosa controlla:**
- Python files (`.py`) - parsing con `py_compile`
- Bash scripts (`.sh`) - parsing con `bash -n`
- JSON files (`.json`) - parsing con `json.load`

**Risultato:**
- ✅ PASS: Tutti i file parsabili
- ❌ FAIL: Errori di sintassi trovati

### GATE 2: LINT CHECK
Verifica assenza errori critici di linting.

**Cosa controlla:**
- Python: `flake8` (solo errori E, F critici)
- Bash: `shellcheck` (solo severity error)
- Warning non bloccanti vengono segnalati ma non fermano

**Tool richiesti:**
```bash
pip install flake8
brew install shellcheck  # macOS
```

**Risultato:**
- ✅ PASS: No errori critici
- ⚠️ WARN: Warning presenti (non bloccanti)
- ❌ FAIL: Errori critici trovati

### GATE 3: TEST CHECK
Esegue tutti i test esistenti.

**Cosa controlla:**
- Test Python: `pytest tests/` (se esiste directory tests/)
- Test Bash: `tests/bash/test_*.sh` (se esistono)

**Tool richiesti:**
```bash
pip install pytest
```

**Opzioni:**
- `--skip-tests`: Salta questo gate (per sviluppo veloce)

**Risultato:**
- ✅ PASS: Tutti i test passati
- ⚠️ WARN: Nessun test trovato (pass by default)
- ❌ FAIL: Test falliti

### GATE 4: HUMAN REVIEW
Richiede conferma umana prima di procedere.

**Checklist umana:**
1. File modificati verificati?
2. Codice leggibile e documentato?
3. No secret/credential committati?
4. Commit message chiari?

**Risultato:**
- ✅ PASS: Review approvata (y)
- ❌ FAIL: Review rifiutata (n) - blocca merge

## Output

```
╔══════════════════════════════════════════════════╗
║         PRE-MERGE CHECKLIST - 4 GATES           ║
╚══════════════════════════════════════════════════╝

GATE 1: SYNTAX CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [PASS] Python files OK
  [PASS] Bash files OK
  [PASS] JSON files OK

GATE 2: LINT CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [PASS] No critical Python errors
  [WARN] Python warnings: 12 (non bloccanti)
  [PASS] No critical Bash errors

GATE 3: TEST CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [WAIT] Running pytest...
  [PASS] 23 tests passed

GATE 4: HUMAN REVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [WAIT] Waiting for human confirmation...

Domande di review:
  1. Hai verificato i file modificati?
  2. Il codice è leggibile e ben documentato?
  3. Non ci sono secret/credential committati?
  4. I commit message sono chiari?

Tutte le verifiche sono OK? [y/N] y
  [PASS] Human review approved

═══════════════════════════════════════════════════
RESULT: 4/4 GATES PASSED ✅
═══════════════════════════════════════════════════

✅ Pronto per merge!
```

## Gestione Errori

Se un gate fallisce, lo script chiede conferma:

```
  [FAIL] Python syntax errors:
    - utils.py

Gate SYNTAX fallito.
Continuare comunque? [y/N]
```

Opzioni:
- `y`: Continua con gate successivi (forzatura)
- `n`: Blocca e esce (raccomandato)

## Exit Codes

- `0`: Tutti i gate passati (o forzati)
- `1`: Gate fallito e non forzato / Review rifiutata

## Best Practices

### Pre-Merge Workflow
```bash
# 1. Completa il lavoro
git add file1.py file2.py

# 2. Esegui checklist
./scripts/swarm/checklist-pre-merge.sh

# 3. Se tutto OK, merge
git commit -m "feat: nuova feature"
git push
```

### Durante Sviluppo
```bash
# Check veloce senza test
./scripts/swarm/checklist-pre-merge.sh --skip-tests

# Fix rapido e re-check
./scripts/swarm/checklist-pre-merge.sh --auto-fix
```

### Prima di PR
```bash
# Verifica completa (tutti i gate)
./scripts/swarm/checklist-pre-merge.sh

# Review umana attenta!
# Questo è il momento per:
# - Verificare ogni file modificato
# - Controllare commit message
# - Assicurarsi no secret committati
```

## Integrazione CI/CD

Lo script può essere integrato in pipeline CI/CD:

```yaml
# .github/workflows/pre-merge.yml
- name: Quality Gates
  run: ./scripts/swarm/checklist-pre-merge.sh --skip-tests
  # Test vengono eseguiti separatamente nella CI
```

## Personalizzazione

### Aggiungere Nuovi Check

Modificare `/scripts/swarm/checklist-pre-merge.sh`:

```bash
# Aggiungere funzione gate
gate5_custom_check() {
    print_gate_header "5" "CUSTOM CHECK"

    # Tua logica qui

    if [ "$check_passed" = true ]; then
        gate_passed
    else
        gate_failed
        ask_continue "CUSTOM"
    fi
}

# Aggiungere chiamata in main()
gate5_custom_check
```

### Configurare Linter

File `.flake8` nel project root:
```ini
[flake8]
max-line-length = 100
exclude = .git,__pycache__,venv
```

File `.shellcheckrc`:
```
disable=SC2086,SC2162
```

## Troubleshooting

### "flake8 non installato"
```bash
pip install flake8
```

### "shellcheck non installato"
```bash
# macOS
brew install shellcheck

# Linux
apt install shellcheck
```

### "pytest non installato"
```bash
pip install pytest
```

### "Test falliti ma sono OK"
Usa `--skip-tests` durante sviluppo:
```bash
./scripts/swarm/checklist-pre-merge.sh --skip-tests
```

## File Correlati

- `spawn-workers.sh` - Apertura worker paralleli
- `shutdown-sequence.sh` - Chiusura graceful
- `triple-ack.sh` - Sistema ACK task
- `task_manager.py` - Gestione task sciame

---

**Versione:** 1.0.0
**Data:** 2026-01-03
**Sprint:** 9.2 - Quick Wins Apple Style
**Cervella & Rafa** - CervellaSwarm 🐝
