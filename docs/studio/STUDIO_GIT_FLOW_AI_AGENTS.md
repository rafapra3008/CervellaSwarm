# STUDIO: Git Flow per AI Agents - Best Practices

> **Ricerca:** 19 Gennaio 2026 - Sessione 270
> **Scope:** Aider patterns + Conventional Commits + Attribution per CervellaSwarm 2.0

---

## TL;DR - COSA COPIARE DA AIDER

```
✅ Auto-commit con descriptive messages
✅ Conventional Commits (feat:/fix:/docs:)
✅ Co-authored-by attribution standard
✅ /undo = git reset --hard HEAD^ (safe rollback)
✅ Dirty files? Commit PRIMA separatamente
✅ Pre-commit hooks? Skippa di default (--no-verify)
```

---

## 1. AIDER AUTO-COMMIT PATTERN

### Come Funziona

```python
# PRIMA di editare file "dirty"
git commit -m "chore: Save user's work before aider edits"

# DOPO ogni edit dell'AI
git commit -m "feat: Add login form validation"  # Conventional Commits!
```

### Opzioni Implementazione

| Flag | Comportamento |
|------|---------------|
| `--auto-commits` (DEFAULT) | Commit automatico ogni edit |
| `--no-auto-commits` | Disabilita auto-commit (manuale) |
| `--no-dirty-commits` | Non toccare file non committed |
| `--git-commit-verify` | Esegui pre-commit hooks (default: skip) |

**LEZIONE:** Skippa pre-commit hooks per AI (speed). Linter DOPO, non durante.

---

## 2. CONVENTIONAL COMMITS - I TIPI

### Standard Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Tipi Core (MUST)

| Tipo | Quando | Esempio |
|------|--------|---------|
| **feat** | Nuova feature | `feat(worker): Add git auto-commit` |
| **fix** | Bug fix | `fix(mcp): Handle empty repo error` |

### Tipi Extended (Aider usa questi)

| Tipo | Quando | Esempio |
|------|--------|---------|
| **docs** | Solo documentazione | `docs(readme): Add git flow section` |
| **style** | Formatting (no logic) | `style: Format code with prettier` |
| **refactor** | Refactoring (no behavior change) | `refactor(cli): Extract git utils` |
| **test** | Test aggiunti/modificati | `test(worker): Add git commit tests` |
| **chore** | Maintenance tasks | `chore(deps): Update dependencies` |
| **perf** | Performance | `perf(cli): Cache git status calls` |
| **ci** | CI/CD changes | `ci: Add commit message linter` |
| **build** | Build system | `build: Update rollup config` |

### Breaking Changes

```
feat(api)!: Rename spawn() to spawnWorkers()

BREAKING CHANGE: spawn() method renamed to spawnWorkers()
```

**! = breaking change** (Semantic Versioning major bump)

---

## 3. ATTRIBUTION - COME MARCARE "AI-GENERATED"

### Metodo 1: Co-authored-by (RACCOMANDATO)

```bash
git commit -m "feat: Add authentication

Co-authored-by: CervellaSwarm (claude-sonnet-4-5) <noreply@cervellaswarm.com>"
```

**PRO:** Standard GitHub, visibile in contributor graphs, informativo

### Metodo 2: Author/Committer Name

```bash
# Git metadata
Author: Rafa (CervellaSwarm) <rafapra@gmail.com>
Committer: Rafa (CervellaSwarm) <rafapra@gmail.com>
```

**PRO:** Visibile in git log, non richiede corpo messaggio

### Metodo 3: Commit Message Prefix

```bash
git commit -m "cervellaswarm: feat: Add login form"
```

**PRO:** Immediato grep/filter, no formatting rules

### Aider Implementation (da copiare)

```python
# Nel loro codice
if self.args.attribute_co_authored_by:
    model_name = self.main_model.name if self.main_model else "ai"
    trailers.append(f"Co-authored-by: aider ({model_name}) <noreply@aider.chat>")
```

**RACCOMANDAZIONE:** Usa Co-authored-by + model name esatto per trasparenza.

---

## 4. /UNDO COMMAND - ROLLBACK SICURO

### Come Aider Lo Implementa

```bash
# Comando user
/undo

# Esegue
git reset --hard HEAD^
```

**Cosa fa:**
1. `HEAD^` = commit precedente
2. `--hard` = scarta TUTTI i cambiamenti (working dir + staged)
3. Muove branch pointer indietro di 1

### Safety Features di Aider

```python
# Prima di permettere /undo
if not commit_marked_as_aider_commit:
    print("⚠️ Can't undo - last commit not by aider")
    return

# Verifica che sia UN COMMIT AIDER
if "(aider)" in commit_author or "(aider)" in commit_committer:
    git reset --hard HEAD^
```

**LEZIONE:** Marca i commit AI per safe undo!

### Alternative a --hard (più safe)

| Comando | Cosa Mantiene | Quando Usare |
|---------|---------------|--------------|
| `git reset --soft HEAD^` | Staged + Working | Vuoi ricommitare diversamente |
| `git reset --mixed HEAD^` | Solo Working | Vuoi restage i file |
| `git reset --hard HEAD^` | Nulla | Full undo (Aider usa questo) |
| `git revert HEAD` | History intatta | Public branches |

**Per CervellaSwarm:** `--hard` è ok per Worker commits (private branches).

---

## 5. GENERAZIONE COMMIT MESSAGE - AIDER APPROACH

### Usa "Weak Model" per Speed

```python
# Aider pattern
commit_message = weak_model.generate(
    prompt=commit_prompt_template,
    diff=git_diff,
    chat_history=last_n_messages
)
```

**PERCHÉ weak model:**
- Commit messages = task semplice
- Speed > Quality per questa task
- Risparmio costi/token

### Prompt Template Aider

```
Analyze this diff and chat history.
Generate a commit message following Conventional Commits.

Format: <type>(<scope>): <subject>

Types: feat, fix, docs, style, refactor, test, chore
Keep subject under 50 chars.
```

**RACCOMANDAZIONE:** Usa Haiku/GPT-4o-mini per commit messages.

---

## 6. BEST PRACTICES 2026

### Da Addy Osmani (Google Chrome)

```
✅ Commit early and often (più che hand-coding)
✅ Treat each self-contained change as separate commit
✅ Break agent output into digestible commits (no mega-commits)
✅ Clear messages after each small task
✅ Be transparent about AI involvement (builds trust)
```

### Statistiche 2025

```
41% di tutti i commit = AI-assisted
84% developers use AI coding tools
82M+ monthly pushes
43M+ merged PRs

→ Attribution NON è più "nice to have" - è NECESSARIA!
```

---

## 7. IMPLEMENTATION CHECKLIST per CervellaSwarm

### Phase 1: Auto-Commit Foundation

```
[ ] Worker riceve task + file list
[ ] PRIMA: Commit dirty files separatamente
    git commit -m "chore: Save user work before worker edit"
[ ] Worker applica modifiche
[ ] DOPO: Commit con Conventional Commits
    git commit -m "feat(worker): Implement requested changes"
```

### Phase 2: Attribution

```
[ ] Aggiungi Co-authored-by ai commit Worker
    Format: "Co-authored-by: CervellaSwarm ({worker-type}) <noreply@cervellaswarm.com>"
[ ] Includere model name specifico:
    - Backend Worker: claude-sonnet-4-5
    - Frontend Worker: claude-sonnet-4-5
    - Guardiane: claude-opus-4-5
```

### Phase 3: Rollback Safety

```
[ ] Implementa /undo command
[ ] Verifica marker "(CervellaSwarm)" in commit author
[ ] Se ultimo commit è Worker → git reset --hard HEAD^
[ ] Se ultimo commit è User → errore + avviso
```

### Phase 4: Message Generation

```
[ ] Usa Haiku per generare commit messages
[ ] Template prompt con Conventional Commits rules
[ ] Input: diff + task description
[ ] Output: type(scope): subject format
[ ] Validazione: lunghezza < 72 chars
```

---

## 8. ESEMPIO COMMIT IDEALE

### Worker: Backend

```bash
git commit -m "feat(api): Add authentication endpoints

Implemented:
- POST /auth/login with JWT
- POST /auth/register with validation
- GET /auth/me for current user

Co-authored-by: CervellaSwarm (backend-worker/claude-sonnet-4-5) <noreply@cervellaswarm.com>"
```

### Worker: Frontend

```bash
git commit -m "feat(ui): Add login form component

Created LoginForm.tsx with:
- Email/password inputs
- Validation feedback
- Loading states
- Error handling

Co-authored-by: CervellaSwarm (frontend-worker/claude-sonnet-4-5) <noreply@cervellaswarm.com>"
```

### Guardiana: Review Fix

```bash
git commit -m "fix(security): Add rate limiting to auth endpoints

Security review found missing rate limiting.
Added express-rate-limit middleware.

Co-authored-by: CervellaSwarm (guardiana-security/claude-opus-4-5) <noreply@cervellaswarm.com>"
```

---

## 9. DIFFERENZE AIDER VS CERVELLASWARM

| Aspetto | Aider | CervellaSwarm |
|---------|-------|---------------|
| **Modello** | Singolo (user sceglie) | 16 agenti specializzati |
| **Attribution** | "(aider)" generica | Specifica ruolo (backend-worker, guardiana-ops) |
| **Commit scope** | Tutte modifiche user richiede | Per Worker (task atomici) |
| **Undo** | /undo command in chat | Via CLI o MCP |
| **Message gen** | Weak model auto | Haiku template-based |

**VANTAGGIO CervellaSwarm:** Attribution più granulare (quale Worker, quale Guardiana).

---

## 10. ANTI-PATTERNS DA EVITARE

### ❌ Mega-Commit

```bash
# NO!
git commit -m "feat: Add authentication, update UI, fix bugs, refactor API"
```

**PERCHÉ NO:** Impossibile da rollback parzialmente, storico confuso.

### ❌ Commit Senza Attribution

```bash
# NO!
git commit -m "feat: Add login"
# Author: Rafa
```

**PERCHÉ NO:** Sembra 100% human-written, manca trasparenza.

### ❌ Attribution Ambigua

```bash
# NO!
Co-authored-by: AI <ai@example.com>
```

**PERCHÉ NO:** Quale AI? Quale modello? Quale task?

### ❌ Dirty Files Non Committed PRIMA

```bash
# NO!
# User ha modifiche non salvate
# Worker edita lo stesso file
# Conflitto!
```

**PERCHÉ NO:** Perdi lavoro utente, git conflicts, casino.

---

## RACCOMANDAZIONE FINALE

### Pattern da Implementare (Priorità)

```
1. ✅ Conventional Commits (feat/fix/docs/etc)
   → Facile, standard, GitHub-friendly

2. ✅ Co-authored-by con ruolo specifico
   → Trasparenza, contributor graphs, audit trail

3. ✅ Auto-commit DOPO ogni task Worker
   → Checkpoint naturali, rollback granulare

4. ✅ Commit dirty files PRIMA di Worker edit
   → Safety, no conflitti, user work preservato

5. ✅ /undo = git reset --hard HEAD^ (con marker check)
   → Safe rollback, solo commit AI
```

### Commit Message Template (da usare)

```markdown
<type>(<scope>): <subject max 50 chars>

<optional body explaining WHAT and WHY>

Co-authored-by: CervellaSwarm ({role}/{model}) <noreply@cervellaswarm.com>
```

### Esempio Implementation (pseudocode)

```python
# In worker.py
async def execute_task(task):
    # 1. Save user work
    if git.has_uncommitted_changes():
        git.commit("chore: Save user work before worker edit")

    # 2. Execute task
    result = await self.apply_changes(task)

    # 3. Generate commit message
    commit_msg = await haiku.generate_commit_message(
        diff=git.diff(),
        task=task.description,
        format="conventional-commits"
    )

    # 4. Commit with attribution
    author = f"CervellaSwarm ({self.role}/{self.model})"
    git.commit(
        message=commit_msg,
        co_author=f"{author} <noreply@cervellaswarm.com>"
    )

    return result

# In cli.py - /undo command
def undo_last_commit():
    last_commit = git.log(n=1)

    # Safety check
    if "CervellaSwarm" not in last_commit.author:
        raise Error("Can't undo - last commit not by CervellaSwarm")

    # Safe rollback
    git.reset("--hard", "HEAD^")
    print(f"✅ Undone: {last_commit.subject}")
```

---

## FONTI

- [Aider Git Integration](https://aider.chat/docs/git.html)
- [Aider In-Chat Commands](https://aider.chat/docs/usage/commands.html)
- [Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)
- [GitHub Co-Author Commits](https://github.blog/news-insights/product-news/commit-together-with-co-authors/)
- [Claude Code Git Attribution](https://www.deployhq.com/blog/how-to-use-git-with-claude-code-understanding-the-co-authored-by-attribution)
- [Addy Osmani: LLM Coding Workflow 2026](https://addyosmani.com/blog/ai-coding-workflow/)
- [Should AI Be Listed as Co-Author?](https://www.dariuszparys.com/should-ai-be-listed-as-a-co-author-in-your-git-commits/)

---

*Studio completato: 19 Gennaio 2026*
*Ricerca: Cervella Researcher*
*Per: CervellaSwarm 2.0 - Git Flow Implementation*
