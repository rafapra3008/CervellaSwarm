# 🚀 QUICKSTART - L'Ingegnera

**Setup in 2 minuti per automazione completa!**

## 1. Setup Hook Post-Commit (FASE 10c.2)

Il hook è già installato in `~/.claude/hooks/post_commit_engineer.py`.

**Verifica configurazione:**
```bash
cat ~/.claude/settings.json
```

Deve contenere:
```json
{
  "hooks": {
    "PostCommit": "~/.claude/hooks/post_commit_engineer.py"
  }
}
```

**Test:**
```bash
# Fai un commit qualsiasi
git commit --allow-empty -m "Test hook"

# Vedrai l'analisi automatica!
```

## 2. Test Analisi Manuale

```bash
# Analizza progetto corrente
python3 scripts/engineer/analyze_codebase.py .

# Salva report
python3 scripts/engineer/analyze_codebase.py . --output engineering_report.md
```

## 3. PR Automatiche (FASE 10c.1)

**Prerequisito:** GitHub CLI
```bash
brew install gh
gh auth login
```

**Test dry-run:**
```bash
python3 scripts/engineer/create_auto_pr.py \
  --files "README.md" \
  --title "Test PR" \
  --description "Testing auto PR creation" \
  --dry-run
```

**Crea PR reale:**
```bash
# Da command line
python3 scripts/engineer/create_auto_pr.py \
  --files "src/file1.py,src/file2.py" \
  --title "Refactor: Split large files" \
  --description "Split large files for better maintainability"

# Da JSON config
python3 scripts/engineer/create_auto_pr.py \
  --from-json example-refactor-plan.json
```

## 4. Workflow Completo

```bash
# 1. Analizza codebase
python3 scripts/engineer/analyze_codebase.py . --output report.md

# 2. Leggi raccomandazioni
cat report.md

# 3. Crea PR per fix prioritari
python3 scripts/engineer/create_auto_pr.py \
  --files "file1.py,file2.py" \
  --title "Fix: Large files refactoring" \
  --description "Split large files based on engineering report"

# 4. Review PR su GitHub
# (apri URL output dallo script)
```

## File Utili

- `README.md` - Documentazione completa
- `EXAMPLE_USAGE.md` - Esempi dettagliati
- `example-refactor-plan.json` - Template JSON
- `analyze_codebase.py` - Analyzer script
- `create_auto_pr.py` - PR creator script

## Troubleshooting

**Hook non si attiva:**
```bash
# Verifica che hook sia eseguibile
chmod +x ~/.claude/hooks/post_commit_engineer.py

# Testa manualmente
python3 ~/.claude/hooks/post_commit_engineer.py
```

**create_auto_pr.py fallisce:**
```bash
# Verifica gh CLI
gh --version

# Verifica auth
gh auth status

# Test dry-run
python3 scripts/engineer/create_auto_pr.py --dry-run --files "test.txt" --title "Test" --description "Test"
```

---

**Pronto! L'Ingegnera è attiva! 🔧**
