# STUDIO: Git Worktrees per Lavoro Parallelo

> **Data:** 30 Dicembre 2025
> **Obiettivo:** Capire come usare Git Worktrees per far lavorare multiple Cervelle in parallelo SENZA conflitti

---

## 1. COSA SONO I GIT WORKTREES

Un worktree è una **copia del repository** in una directory separata, collegata allo stesso `.git`.

```
Repository Normale:
~/Developer/Miracollo/
├── .git/              ← Database git
├── src/
├── frontend/
└── ...

Con Worktrees:
~/Developer/Miracollo/           ← Main worktree
├── .git/                        ← Database condiviso
├── src/
└── ...

~/Developer/Miracollo-frontend/  ← Worktree 1
├── src/                         ← Copia isolata
└── ...                          (branch: feature/frontend)

~/Developer/Miracollo-backend/   ← Worktree 2
├── src/                         ← Copia isolata
└── ...                          (branch: feature/backend)
```

**La magia:** Tutti i worktree condividono lo STESSO database git, ma ognuno ha la sua directory di lavoro isolata!

---

## 2. PERCHÉ SONO PERFETTI PER CERVELLASWARM

### Il Problema
```
Cervella A: Modifica file.js riga 10
Cervella B: Modifica file.js riga 50
                    ↓
              CONFLITTO! 💥
```

### La Soluzione
```
Cervella A → Worktree A → Branch feature/frontend
Cervella B → Worktree B → Branch feature/backend
                    ↓
              ZERO CONFLITTI! ✅
              (merge controllato dopo)
```

---

## 3. COMANDI BASE

### Creare un Worktree

```bash
# Crea worktree con branch esistente
git worktree add ../miracollo-frontend feature/frontend

# Crea worktree E nuovo branch insieme
git worktree add ../miracollo-frontend -b feature/frontend

# Crea worktree da main (copia pulita)
git worktree add ../miracollo-frontend -b feature/frontend main
```

### Listare Worktrees

```bash
git worktree list

# Output:
# /Users/rafa/Developer/Miracollo           abc1234 [main]
# /Users/rafa/Developer/Miracollo-frontend  def5678 [feature/frontend]
# /Users/rafa/Developer/Miracollo-backend   ghi9012 [feature/backend]
```

### Rimuovere un Worktree

```bash
# Rimuovi (sicuro - verifica che non ci siano modifiche)
git worktree remove ../miracollo-frontend

# Forza rimozione
git worktree remove --force ../miracollo-frontend
```

### Pulire Worktrees Orfani

```bash
git worktree prune
```

---

## 4. WORKFLOW PER CERVELLASWARM

### Setup Iniziale (una volta)

```bash
# Dal repo principale
cd ~/Developer/Miracollo

# Crea worktrees per ogni Cervella
git worktree add ../miracollo-cervella-frontend -b swarm/frontend main
git worktree add ../miracollo-cervella-backend -b swarm/backend main
git worktree add ../miracollo-cervella-tester -b swarm/tester main
```

### Risultato

```
~/Developer/
├── Miracollo/                    ← Orchestratrice lavora qui
├── miracollo-cervella-frontend/  ← Cervella Frontend lavora qui
├── miracollo-cervella-backend/   ← Cervella Backend lavora qui
└── miracollo-cervella-tester/    ← Cervella Tester lavora qui
```

### Durante il Lavoro

Ogni Cervella lavora nella sua directory:

```
Cervella Frontend (in miracollo-cervella-frontend/):
  - Modifica componenti React
  - Commit sul branch swarm/frontend
  - Push quando pronta

Cervella Backend (in miracollo-cervella-backend/):
  - Modifica API Python
  - Commit sul branch swarm/backend
  - Push quando pronta
```

### Merge Finale

Quando tutte le Cervelle hanno finito:

```bash
# Torna al repo principale
cd ~/Developer/Miracollo

# Merge tutti i branch
git merge swarm/frontend --no-ff -m "Merge: Frontend work"
git merge swarm/backend --no-ff -m "Merge: Backend work"
git merge swarm/tester --no-ff -m "Merge: Tester work"

# Pulisci worktrees
git worktree remove ../miracollo-cervella-frontend
git worktree remove ../miracollo-cervella-backend
git worktree remove ../miracollo-cervella-tester

# Elimina branch temporanei
git branch -d swarm/frontend swarm/backend swarm/tester
```

---

## 5. SCRIPT AUTOMAZIONE

### setup-worktrees.sh

```bash
#!/bin/bash
# Script per setup rapido worktrees CervellaSwarm

REPO_NAME="${1:-$(basename $(pwd))}"
BASE_DIR="$(dirname $(pwd))"

echo "🐝 CervellaSwarm - Setup Worktrees"
echo "=================================="
echo "Repo: $REPO_NAME"
echo "Base: $BASE_DIR"
echo ""

# Crea worktrees
echo "Creating worktrees..."

git worktree add "$BASE_DIR/${REPO_NAME}-cervella-frontend" -b swarm/frontend main
echo "✅ Frontend worktree created"

git worktree add "$BASE_DIR/${REPO_NAME}-cervella-backend" -b swarm/backend main
echo "✅ Backend worktree created"

git worktree add "$BASE_DIR/${REPO_NAME}-cervella-tester" -b swarm/tester main
echo "✅ Tester worktree created"

echo ""
echo "🎉 Done! Worktrees ready:"
git worktree list
```

### cleanup-worktrees.sh

```bash
#!/bin/bash
# Script per cleanup worktrees dopo merge

REPO_NAME="${1:-$(basename $(pwd))}"
BASE_DIR="$(dirname $(pwd))"

echo "🧹 CervellaSwarm - Cleanup Worktrees"
echo "===================================="

# Rimuovi worktrees
git worktree remove "$BASE_DIR/${REPO_NAME}-cervella-frontend" --force 2>/dev/null
git worktree remove "$BASE_DIR/${REPO_NAME}-cervella-backend" --force 2>/dev/null
git worktree remove "$BASE_DIR/${REPO_NAME}-cervella-tester" --force 2>/dev/null

# Pulisci
git worktree prune

# Elimina branch swarm
git branch -D swarm/frontend swarm/backend swarm/tester 2>/dev/null

echo "✅ Cleanup complete!"
git worktree list
```

---

## 6. REGOLE PER EVITARE CONFLITTI

### Regola 1: Ogni Cervella = Una Zona

| Cervella | Può Toccare | NON Può Toccare |
|----------|-------------|-----------------|
| Frontend | `frontend/`, `*.css`, `*.jsx` | `backend/`, `*.py` |
| Backend | `backend/`, `*.py`, `api/` | `frontend/`, `*.jsx` |
| Tester | `tests/`, `*.test.*` | Codice prod (solo lettura) |

### Regola 2: File Condivisi = Orchestratrice

Alcuni file li tocca SOLO l'orchestratrice:
- `package.json`
- `requirements.txt`
- Config files
- README

### Regola 3: Commit Frequenti

```
Ogni Cervella deve committare SPESSO:
- Dopo ogni funzione completata
- Prima di passare a nuovo task
- Almeno ogni 30 minuti
```

### Regola 4: Pull Prima di Iniziare

```bash
# Prima di iniziare lavoro
git fetch origin
git rebase origin/main

# Questo evita che i branch divergano troppo
```

---

## 7. GESTIONE CONFLITTI (se succede)

Se nonostante tutto c'è un conflitto al merge:

```bash
# Vedi cosa confligge
git status

# Opzione 1: Risolvi manualmente
# Edita i file, poi:
git add .
git commit -m "Resolve merge conflict"

# Opzione 2: Prendi una versione
git checkout --ours file.js    # Prendi la nostra
git checkout --theirs file.js  # Prendi la loro

# Opzione 3: Abort e ricomincia
git merge --abort
```

---

## 8. TOOL DI SUPPORTO

### gwq - Git Worktree Manager

Tool con fuzzy finder per gestire worktrees:

```bash
# Installazione
go install github.com/d-kuro/gwq@latest

# Uso
gwq add     # Crea worktree interattivo
gwq list    # Lista con fuzzy search
gwq remove  # Rimuovi interattivo
```

### Vantaggi gwq:
- Fuzzy finder per navigazione
- Task queue per automazione
- Integrazione con Claude Code

---

## 9. SPAZIO DISCO

**Quanto spazio usano i worktrees?**

| Cosa | Spazio |
|------|--------|
| `.git/` | Condiviso (0 extra) |
| Working files | Copia completa |
| node_modules | Copia completa* |

**Tip:** Usa symlink per `node_modules` per risparmiare spazio:

```bash
# Nel worktree
rm -rf node_modules
ln -s ../miracollo/node_modules node_modules
```

**Attenzione:** Funziona solo se le dipendenze sono identiche!

---

## 10. PRO E CONTRO PER CERVELLASWARM

### PRO ✅
- **Isolamento REALE** - ogni Cervella ha la sua copia
- **Zero conflitti** - durante il lavoro
- **Git nativo** - nessun tool extra
- **Merge controllato** - review prima di unire
- **Leggero** - condividono .git

### CONTRO ❌
- **Setup richiesto** - bisogna creare i worktrees
- **Spazio disco** - copie dei file (non .git)
- **Coordinamento** - chi fa cosa deve essere chiaro
- **Merge finale** - può avere conflitti se zone si sovrappongono

---

## 11. QUANDO USARE WORKTREES

| Scenario | Worktrees? | Alternativa |
|----------|------------|-------------|
| Task paralleli su zone diverse | ✅ SÌ | - |
| Task sequenziali | ❌ NO | Subagent normali |
| Stesso file da più agenti | ❌ NO | Sequenziale |
| Feature grandi multi-zona | ✅ SÌ | - |
| Bug fix veloce | ❌ NO | Branch normale |

---

## 12. COMBINAZIONE CON SUBAGENT

**La combo perfetta:**

```
┌─────────────────────────────────────────────────────┐
│              CERVELLA ORCHESTRATRICE                │
│         (repo principale, coordina tutto)           │
└─────────────────────┬───────────────────────────────┘
                      │
      ┌───────────────┼───────────────┐
      ▼               ▼               ▼
┌───────────┐   ┌───────────┐   ┌───────────┐
│ WORKTREE  │   │ WORKTREE  │   │ WORKTREE  │
│ frontend  │   │ backend   │   │ tester    │
│           │   │           │   │           │
│ Subagent: │   │ Subagent: │   │ Subagent: │
│ cervella- │   │ cervella- │   │ cervella- │
│ frontend  │   │ backend   │   │ tester    │
└───────────┘   └───────────┘   └───────────┘
```

Ogni Cervella:
1. Lavora nel suo worktree (isolamento)
2. Usa il suo subagent (specializzazione)
3. Committa quando finisce
4. Orchestratrice fa merge

---

## 13. PROSSIMI PASSI

1. [x] Studiare subagent
2. [x] Studiare worktrees (questo documento)
3. [ ] Studiare Claude-Flow
4. [ ] Decidere architettura combinata
5. [ ] Creare script automazione
6. [ ] Test su progetto reale

---

## FONTI

- [Git Worktrees Official Docs](https://git-scm.com/docs/git-worktree)
- [Git Worktrees for AI Agents - Medium](https://medium.com/@mabd.dev/git-worktrees-the-secret-weapon-for-running-multiple-ai-coding-agents-in-parallel-e9046451eb96)
- [Parallel AI Coding with Worktrees](https://docs.agentinterviews.com/blog/parallel-ai-coding-with-gitworktrees/)
- [gwq - Git Worktree Manager](https://github.com/d-kuro/gwq)

---

*"Un worktree per ogni Cervella. Zero conflitti. Massima potenza."* 🐝🌳
