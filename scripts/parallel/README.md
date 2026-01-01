# 🧠 Parallel Execution Scripts - CervellaSwarm

Analizzatori intelligenti di task per decidere la strategia di esecuzione ottimale.

## 📋 Script Disponibili

| Script | Scopo | Output |
|--------|-------|--------|
| `task_analyzer.py` | Analisi tecnica completa | Dettagli + gruppi paralleli |
| `suggest_pattern.py` | **Suggerimento pattern user-friendly** | Raccomandazione + warnings |

**Usa `suggest_pattern.py` per quick start!** 🚀

## 🎯 Cosa Fa

Analizza un task (lista di file) e decide:
- **Sequential**: 1 agente alla volta (file correlati/dipendenti)
- **Parallel**: 3-5 agenti in parallelo (sweet spot)
- **Worktrees**: Isolamento completo per 6+ file indipendenti

## 📊 Decision Matrix

| File | Domini | Dipendenze | Tempo | → Strategia |
|------|--------|------------|-------|-------------|
| 1-2 | any | any | <30min | SEQUENTIAL |
| 3-5 | diversi | basse | any | PARALLEL |
| 3-5 | stesso | alte | any | SEQUENTIAL |
| 6+ | diversi | basse | >60min | WORKTREES |
| 6+ | diversi | alte | any | SEQUENTIAL + Split |

## 🚀 Uso

### Quick Start: suggest_pattern.py (Raccomandato!)

```bash
# Uso base - Suggerimento veloce
./suggest_pattern.py api/main.py components/Header.jsx tests/test.py

# Con tempo stimato custom
./suggest_pattern.py --time 60 backend/*.py

# Output JSON (per automazione)
./suggest_pattern.py --json api/*.py > pattern.json

# Output semplice (no box)
./suggest_pattern.py --simple file1.py file2.css
```

### Analisi Completa: task_analyzer.py

```bash
# Analisi base con dettagli tecnici
./task_analyzer.py file1.jsx file2.py file3.md

# Con tempo stimato
./task_analyzer.py file1.jsx file2.py --time 60

# Output JSON (per automazione)
./task_analyzer.py file1.jsx file2.py --json
```

### Output Esempio - suggest_pattern.py

```
╔════════════════════════════════════════════════════════════════╗
║  🧠 PATTERN SUGGESTION                                        ║
╠════════════════════════════════════════════════════════════════╣
║  🔀 Pattern Raccomandato: PARALLEL
║  📝 Motivo: Sweet spot: 3-5 file, domini diversi
║  ⚡ Speedup Stimato: 1.36x
║  ⏱️  Tempo Stimato: 45 min → 33 min
║
║  🐝 AGENTI SUGGERITI:
║     • cervella-frontend (1 file)
║     • cervella-backend (1 file)
║     • cervella-tester (1 file)
║
║  ⚠️  WARNING:
║     cervella-docs ha 12 file - considera split in batch
╚════════════════════════════════════════════════════════════════╝
```

### Output Esempio - task_analyzer.py

```
╔══════════════════════════════════════════════════════════════════╗
║  🧠 TASK ANALYSIS RESULT                                        ║
╠══════════════════════════════════════════════════════════════════╣
║  🔀 Strategia: PARALLEL
║  📝 Motivo: Sweet spot: 3-5 file, domini diversi, basse dipendenze
║  ⚡ Speedup atteso: 1.36x
║
║  📂 DISTRIBUZIONE DOMINI:
║     • frontend: 1 file
║     • backend: 1 file
║     • docs: 1 file
║
║  🐝 AGENTI SUGGERITI:
║     • cervella-frontend
║     • cervella-backend
║     • cervella-docs
║
║  🔀 GRUPPI PARALLELI:
║     Gruppo 1: App.jsx
║     Gruppo 2: main.py
║     Gruppo 3: README.md
╚══════════════════════════════════════════════════════════════════╝
```

## 🎨 Domini Riconosciuti

| Dominio | Pattern | Agente |
|---------|---------|--------|
| Frontend | `.jsx`, `.tsx`, `.css`, `components/` | cervella-frontend |
| Backend | `.py`, `api/`, `services/` | cervella-backend |
| Database | `.sql`, `migrations/`, `models/` | cervella-data |
| Test | `test_*.py`, `*.test.js`, `__tests__/` | cervella-tester |
| Docs | `.md`, `docs/`, `README` | cervella-docs |
| Config | `.json`, `.yaml`, `.env`, `config/` | cervella-devops |

## ⚡ Speedup Atteso

| Strategia | Speedup Base | Con N Gruppi |
|-----------|--------------|--------------|
| Sequential | 1.0x | - |
| Parallel | 1.36x | 1 + (N-1) × 0.2 |
| Worktrees | 1.5-2.0x | 1 + (N-1) × 0.3 |

## 🔬 Esempio Python

### Uso suggest_pattern.py

```python
from suggest_pattern import suggest_pattern

# Suggerimento rapido
files = ["api/main.py", "components/Header.jsx", "tests/test.py"]
suggestion = suggest_pattern(files, estimated_time=45)

print(f"Pattern: {suggestion.pattern}")
print(f"Speedup: {suggestion.speedup}x")
print(f"Tempo: {suggestion.time_original} → {suggestion.time_optimized} min")
print(f"Agenti: {', '.join(suggestion.agents)}")

if suggestion.warnings:
    print(f"Warnings: {len(suggestion.warnings)}")
```

### Uso task_analyzer.py

```python
from task_analyzer import analyze_task, ExecutionStrategy

# Analisi completa
analysis = analyze_task([
    "src/App.jsx",
    "api/main.py",
    "test_api.py"
], estimated_time=45)

# Controlla strategia
if analysis.strategy == ExecutionStrategy.PARALLEL:
    print(f"Speedup atteso: {analysis.estimated_speedup:.2f}x")
    print(f"Agenti: {', '.join(analysis.suggested_agents)}")
    print(f"Gruppi paralleli: {len(analysis.parallel_groups)}")
```

## 📝 Note

- **TEST domain ha priorità**: `test_api.py` → TEST (non BACKEND)
- **Dipendenze rilevate**: Analisi import/require automatica
- **JSON output**: Perfetto per integrare con orchestratore
- **Exit codes (suggest_pattern)**: 0 = OK, 2 = OK con warning, 1 = errore

## ⚠️ Warning System (suggest_pattern.py)

| Warning | Significato |
|---------|-------------|
| `agente ha >5 file` | Troppi file per un agente - considera split in batch |
| `Speedup < 1.2x` | Overhead parallel non giustificato |
| `Dipendenze rilevate` | Verifica ordine esecuzione per evitare conflitti |

---

**Versione**: 1.0.0
**Data**: 2026-01-01
**Autore**: Cervella Backend 🐝⚙️
