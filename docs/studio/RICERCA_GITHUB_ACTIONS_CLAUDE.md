# RICERCA GITHUB ACTIONS + CLAUDE CODE

**Data:** 2026-01-02
**Analista:** Cervella Researcher
**Versione:** 1.0.0

---

## EXECUTIVE SUMMARY

**PRONTO PER L'USO!**
- Setup: 15 minuti totali
- Costo: $3-15 per milione token (Sonnet/Opus)
- Complessita: Bassa (copy-paste workflow + secret)

**RACCOMANDAZIONE: PROCEDI SUBITO!**

---

## QUICK START (5 STEP - 15 MINUTI)

### Step 1: Installa GitHub App (2 min)
```bash
# In Claude Code terminal:
/install-github-app
```

### Step 2: Aggiungi API Key (1 min)
- Repository > Settings > Secrets > Actions
- Nome: `ANTHROPIC_API_KEY`
- Valore: la tua chiave API

### Step 3: Crea Workflow File (5 min)
- File: `.github/workflows/claude-review.yml`
- Copia esempio sotto

### Step 4: CLAUDE.md (opzionale, 5 min)
- Regole di review custom alla root del progetto

### Step 5: Test (2 min)
- Apri PR di test
- Menziona `@claude review this PR`

---

## WORKFLOW CONSIGLIATO PER CERVELLASWARM

```yaml
name: CervellaSwarm Review

on:
  pull_request:
    types: [opened, synchronize]
  issue_comment:
    types: [created]

jobs:
  review:
    runs-on: ubuntu-latest
    # Solo su PR o se menzionato @claude
    if: >
      github.event_name == 'pull_request' ||
      (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@claude'))

    permissions:
      contents: read
      pull-requests: write
      issues: write
      id-token: write

    steps:
      - name: Checkout
        uses: actions/checkout@v5
        with:
          fetch-depth: 0

      - name: Claude Code Review
        uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          track_progress: true

          prompt: |
            REPO: ${{ github.repository }}
            PR NUMBER: ${{ github.event.pull_request.number || github.event.issue.number }}

            SEI CERVELLA-REVIEWER dello sciame CervellaSwarm!

            REGOLE DI FAMIGLIA:
            - Lavora in PACE, senza CASINO
            - I dettagli fanno SEMPRE la differenza
            - Fatto BENE > Fatto VELOCE

            CHECKLIST REVIEW:
            1. Code quality (max 500 righe/file)
            2. Naming conventions (snake_case Python, camelCase JS)
            3. Error handling (mai except: pass)
            4. Security (no secrets, input validato)
            5. Tests (coverage adeguata?)
            6. Docs (docstring per funzioni pubbliche)

            COMPORTAMENTO:
            - Se tutto OK: approva con commento positivo
            - Se problemi minori: suggerisci fix
            - Se problemi gravi: richiedi changes

          claude_args: |
            --allowedTools "mcp__github_inline_comment__create_inline_comment,Bash(gh pr:*),Read"
            --model claude-sonnet-4-5-20250929
            --max_turns 3
```

---

## VARIANTI WORKFLOW

### 1. Security Review (solo file critici)

```yaml
name: Security Review

on:
  pull_request:
    paths:
      - 'src/auth/**'
      - 'src/api/**'
      - 'config/security.yml'
      - '**/*secret*'
      - '**/*password*'

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            SECURITY REVIEW per file critici.

            CERCA:
            1. Hardcoded secrets/passwords
            2. SQL injection vulnerabilities
            3. XSS/CSRF issues
            4. Improper input validation
            5. Insecure dependencies

            SEVERITY LEVELS:
            - CRITICAL: Blocca merge
            - HIGH: Richiedi fix prima di merge
            - MEDIUM: Suggerisci fix
            - LOW: Nota informativa
```

### 2. Manutenzione Settimanale

```yaml
name: Weekly Maintenance

on:
  schedule:
    - cron: '0 9 * * 1'  # Lunedi 9:00 UTC

jobs:
  maintenance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            MANUTENZIONE SETTIMANALE CervellaSwarm.

            CONTROLLA:
            1. Dependency updates disponibili
            2. TODO/FIXME nel codice
            3. File grandi (> 500 righe)
            4. Test coverage
            5. Documentation freshness

            OUTPUT:
            Crea issue con lista task se necessario.

          claude_args: |
            --allowedTools "Bash(gh issue:*),Read,Glob,Grep"
```

### 3. On-Demand Review (@claude mention)

```yaml
name: On-Demand Review

on:
  issue_comment:
    types: [created]

jobs:
  review:
    if: |
      github.event.issue.pull_request &&
      contains(github.event.comment.body, '@claude')

    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            L'utente ha chiesto: ${{ github.event.comment.body }}

            Rispondi alla richiesta specifica.
```

---

## COSTI REALISTICI

### Pricing Claude API (Gennaio 2026)

| Model | Input (1M token) | Output (1M token) |
|-------|------------------|-------------------|
| Haiku | $0.25 | $1.25 |
| Sonnet | $3.00 | $15.00 |
| Opus | $15.00 | $75.00 |

### Costo per Review

| Scenario | Token Stimati | Costo (Sonnet) | Costo (Haiku) |
|----------|---------------|----------------|---------------|
| Small PR (50-200 righe) | ~20K | $0.06-$0.30 | $0.01-$0.05 |
| Medium PR (200-500 righe) | ~50K | $0.15-$0.75 | $0.02-$0.12 |
| Large PR (500+ righe) | ~100K | $0.30-$1.50 | $0.05-$0.25 |

### Budget Mensile Stimato

| Attivita | Frequenza | Costo/mese (Sonnet) |
|----------|-----------|---------------------|
| PR Review | 10-20 PR | $5-50 |
| Security Review | 5-10 PR | $3-15 |
| Weekly Maintenance | 4/mese | $2-8 |
| On-Demand | 5-10/mese | $2-10 |
| **TOTALE** | | **$12-83/mese** |

### Ottimizzazioni Costo

1. **Prompt Caching** - Risparmio 90% su prompt ripetuti
2. **Haiku per triage** - Usa Haiku per prima passata, Sonnet solo se serve
3. **Path filters** - Review solo file critici
4. **Max turns** - Limita iterazioni (`--max_turns 3`)
5. **Batch review** - Accumula PR, review notturna

---

## CONFIGURAZIONE SECRETS

### Required Secrets

| Secret | Dove Trovarlo | Note |
|--------|---------------|------|
| `ANTHROPIC_API_KEY` | console.anthropic.com | API key con billing attivo |

### Optional Secrets

| Secret | Uso | Default |
|--------|-----|---------|
| `GITHUB_TOKEN` | Gia disponibile | Automatico |
| `SLACK_WEBHOOK` | Notifiche | Non necessario |

### Setup Secret

```bash
# Via CLI
gh secret set ANTHROPIC_API_KEY

# Oppure via Web
# Repository > Settings > Secrets and variables > Actions > New repository secret
```

---

## CLAUDE.MD PER REVIEW

Crea `.github/CLAUDE.md` per regole custom:

```markdown
# Regole Review CervellaSwarm

## Code Standards
- Python: max 500 righe/file, snake_case
- JavaScript: max 500 righe/file, camelCase
- Markdown: max 1000 righe/file

## Security
- Mai hardcoded secrets
- Sempre validare input
- Preferire parametric queries

## Quality
- Ogni funzione pubblica ha docstring
- Test per nuove feature
- Niente TODO senza issue link

## Stile
- Fatto BENE > Fatto VELOCE
- I dettagli fanno la differenza
- Senza ego, testa pulita
```

---

## TROUBLESHOOTING

### Problema: Action non triggera

```yaml
# Verifica permissions
permissions:
  contents: read
  pull-requests: write
  issues: write
  id-token: write  # IMPORTANTE per claude-code-action
```

### Problema: API key non funziona

```bash
# Verifica secret esiste
gh secret list

# Re-set secret
gh secret set ANTHROPIC_API_KEY
```

### Problema: Rate limit

```yaml
# Aggiungi delay tra review
- name: Wait
  run: sleep 30

# Oppure usa Haiku per prima passata
claude_args: |
  --model claude-3-5-haiku-20241022
```

### Problema: Review troppo lunghe

```yaml
# Limita turns e token
claude_args: |
  --max_turns 3
  --max_tokens 4096
```

---

## FONTI

### Documentazione Ufficiale
- [Claude Code GitHub Actions - Official Docs](https://code.claude.com/docs/en/github-actions)
- [anthropics/claude-code-action Repository](https://github.com/anthropics/claude-code-action)
- [Claude Code Action - GitHub Marketplace](https://github.com/marketplace/actions/claude-code-action-official)

### Guide Pratiche
- [How to Use Claude Code for PRs and Code Reviews](https://skywork.ai/blog/how-to-use-claude-code-for-prs-code-reviews-guide/)
- [How to Use Claude Code with GitHub Actions](https://apidog.com/blog/claude-code-github-actions/)
- [Automate Documentation with Claude Code & GitHub Actions](https://medium.com/@fra.bernhardt/automate-your-documentation-with-claude-code-github-actions)

### Security
- [Claude Code Security Review Action](https://github.com/anthropics/claude-code-security-review)
- [Securing Claude Code with Harden-Runner](https://www.stepsecurity.io/blog/anthropics-claude-code-action-security)

### Pricing
- [Claude AI Pricing 2025 Breakdown](https://skywork.ai/blog/ai-agent/claude-ai-pricing/)
- [Claude API Pricing Calculator](https://costgoat.com/pricing/claude-api)

---

*Report generato da: Cervella Researcher*
*"Studiare prima di agire!"*
