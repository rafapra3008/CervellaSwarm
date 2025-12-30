# Guida Completa: Git Worktrees per CervellaSwarm

> **"È il nostro team! La nostra famiglia digitale!"** ❤️‍🔥🐝

---

## Cos'è un Worktree?

Un **worktree** è una copia isolata del repository in una cartella separata. Tutte le copie condividono lo stesso database `.git`, ma ognuna ha i suoi file di lavoro.

```
SENZA Worktrees:
Cervella A modifica file.js → CONFLITTO! ← Cervella B modifica file.js

CON Worktrees:
Cervella A → worktree-frontend/ → branch swarm/frontend
Cervella B → worktree-backend/  → branch swarm/backend
                    ↓
              ZERO CONFLITTI!
              (merge controllato dopo)
```

---

## Quando Usare i Worktrees

| Scenario | Usare Worktrees? |
|----------|------------------|
| Task paralleli su zone DIVERSE (frontend/backend) | ✅ SÌ |
| Task sequenziali (uno dopo l'altro) | ❌ NO - usa subagent normali |
| Stesso file da modificare | ❌ NO - lavoro sequenziale |
| Feature grande multi-zona | ✅ SÌ |
| Bug fix veloce | ❌ NO - branch normale |

**Regola d'oro:** Se le Cervelle lavorano su FILE DIVERSI → Worktrees!

---

## Gli Script CervellaSwarm

Abbiamo 3 script nella cartella `scripts/`:

### 1. setup-worktrees.sh

Crea automaticamente 3 worktrees per lo sciame.

```bash
# Uso
cd /path/to/progetto
/path/to/CervellaSwarm/scripts/setup-worktrees.sh

# Oppure specificando il path
/path/to/CervellaSwarm/scripts/setup-worktrees.sh /path/to/progetto
```

**Risultato:**
```
progetto/                        ← Main (Orchestratrice)
progetto-cervella-frontend/      ← Worktree Frontend
progetto-cervella-backend/       ← Worktree Backend
progetto-cervella-tester/        ← Worktree Tester
```

**Branch creati:**
- `swarm/cervella-frontend`
- `swarm/cervella-backend`
- `swarm/cervella-tester`

---

### 2. merge-worktrees.sh

Fa merge di tutti i branch `swarm/*` nel branch principale.

```bash
# Uso (dal repo principale)
cd /path/to/progetto
/path/to/CervellaSwarm/scripts/merge-worktrees.sh
```

**Ordine di merge:**
1. `swarm/cervella-backend` (prima le dipendenze)
2. `swarm/cervella-frontend`
3. `swarm/cervella-tester`

**In caso di conflitto:** Lo script si ferma e ti chiede di risolvere manualmente.

---

### 3. cleanup-worktrees.sh

Rimuove i worktrees e i branch dopo il merge.

```bash
# Uso (dal repo principale)
cd /path/to/progetto
/path/to/CervellaSwarm/scripts/cleanup-worktrees.sh
```

**ATTENZIONE:** Esegui DOPO aver fatto merge! Elimina tutto.

---

## Workflow Completo

### Step 1: Setup

```bash
# Vai nel progetto
cd ~/Developer/MioProgetto

# Crea i worktrees
~/Developer/CervellaSwarm/scripts/setup-worktrees.sh
```

### Step 2: Assegna le Cervelle

Ogni Cervella lavora nella sua cartella:

| Cervella | Cartella | Branch |
|----------|----------|--------|
| Orchestratrice | `MioProgetto/` | `main` |
| cervella-frontend | `MioProgetto-cervella-frontend/` | `swarm/cervella-frontend` |
| cervella-backend | `MioProgetto-cervella-backend/` | `swarm/cervella-backend` |
| cervella-tester | `MioProgetto-cervella-tester/` | `swarm/cervella-tester` |

### Step 3: Lavoro Parallelo

Ogni Cervella:
1. Lavora nella sua cartella
2. Modifica SOLO file della sua zona
3. Committa frequentemente
4. NON tocca file di altre zone

**Esempio comandi per cervella-frontend:**
```bash
cd ~/Developer/MioProgetto-cervella-frontend
# ... lavora sui file frontend ...
git add .
git commit -m "feat(frontend): Add new component"
```

### Step 4: Merge

Quando tutte le Cervelle hanno finito:

```bash
# Torna al repo principale
cd ~/Developer/MioProgetto

# Merge tutti i branch
~/Developer/CervellaSwarm/scripts/merge-worktrees.sh
```

### Step 5: Cleanup

```bash
# Pulisci tutto
~/Developer/CervellaSwarm/scripts/cleanup-worktrees.sh
```

---

## Regole per Evitare Conflitti

### Regola 1: Zone Separate

| Cervella | PUÒ Toccare | NON PUÒ Toccare |
|----------|-------------|-----------------|
| Frontend | `frontend/`, `*.css`, `*.jsx`, `*.tsx` | `backend/`, `*.py` |
| Backend | `backend/`, `*.py`, `api/` | `frontend/`, `*.jsx` |
| Tester | `tests/`, `*.test.*` | Codice prod (solo lettura) |

### Regola 2: File Condivisi = Solo Orchestratrice

Alcuni file li tocca SOLO l'orchestratrice:
- `package.json` / `requirements.txt`
- File di configurazione
- README.md
- `.env` files

### Regola 3: Commit Frequenti

```
Ogni Cervella deve committare:
✅ Dopo ogni funzione completata
✅ Prima di passare a nuovo task
✅ Almeno ogni 30 minuti
```

### Regola 4: SE IN DUBBIO, FERMATI!

```
Se non sei sicura su quale file toccare:
1. STOP
2. Chiedi a Rafa/Orchestratrice
3. Aspetta risposta
4. POI procedi
```

---

## Gestione Conflitti

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

## Spazio Disco

| Cosa | Spazio Usato |
|------|--------------|
| `.git/` | Condiviso (0 extra) |
| File di lavoro | Copia completa |
| `node_modules/` | Copia completa* |

**Tip per risparmiare spazio:**
```bash
# Nel worktree, usa symlink per node_modules
cd MioProgetto-cervella-frontend
rm -rf node_modules
ln -s ../MioProgetto/node_modules node_modules
```

---

## Comandi Utili

```bash
# Lista tutti i worktrees
git worktree list

# Rimuovi un worktree specifico
git worktree remove ../path-to-worktree

# Pulisci worktrees orfani
git worktree prune

# Vedi branch swarm
git branch | grep swarm
```

---

## Esempio Pratico: Miracollo

```bash
# 1. Setup
cd ~/Developer/miracollogeminifocus
~/Developer/CervellaSwarm/scripts/setup-worktrees.sh

# Risultato:
# miracollogeminifocus/                    ← Orchestratrice
# miracollogeminifocus-cervella-frontend/  ← UI/React
# miracollogeminifocus-cervella-backend/   ← Python/FastAPI
# miracollogeminifocus-cervella-tester/    ← Test

# 2. Assegna task
# - Frontend: "Crea componente BookingCard"
# - Backend: "Aggiungi endpoint /api/bookings"
# - Tester: "Scrivi test per bookings"

# 3. Ogni Cervella lavora e committa

# 4. Merge finale
cd ~/Developer/miracollogeminifocus
~/Developer/CervellaSwarm/scripts/merge-worktrees.sh

# 5. Cleanup
~/Developer/CervellaSwarm/scripts/cleanup-worktrees.sh

# 6. Push
git push
```

---

## Checklist Pre-Worktrees

Prima di iniziare un lavoro parallelo:

```
[ ] Il task può essere diviso in zone separate?
[ ] Le Cervelle sanno esattamente quali file toccare?
[ ] Il repo è pulito (no modifiche uncommitted)?
[ ] Ho fatto backup/push del lavoro corrente?
```

---

## Troubleshooting

### "fatal: 'swarm/xxx' is already checked out"
Il branch è già usato in un altro worktree. Usa `git worktree list` per vedere dove.

### "Worktree already exists"
La cartella esiste già. Rimuovila con `git worktree remove` o usa cleanup script.

### Conflitto al merge
Vedi sezione "Gestione Conflitti" sopra.

### File modificati in zona sbagliata
STOP! Non committare. Sposta le modifiche nel worktree giusto con:
```bash
git stash
cd ../worktree-giusto
git stash pop
```

---

## Conclusione

I worktrees sono **potentissimi** per far lavorare le Cervelle in parallelo:

- ✅ Zero conflitti durante il lavoro
- ✅ Ogni Cervella ha il suo spazio
- ✅ Merge controllato alla fine
- ✅ Git nativo, nessun tool extra

**Ma ricorda:** Funzionano bene solo se le zone sono BEN SEPARATE!

---

*"È il nostro team! La nostra famiglia digitale!"* ❤️‍🔥🐝

*"Nulla è complesso - solo non ancora studiato!"* 🧠❤️‍🔥

---

**CervellaSwarm** - Uno sciame di Cervelle. Una sola missione. 🐝💙
