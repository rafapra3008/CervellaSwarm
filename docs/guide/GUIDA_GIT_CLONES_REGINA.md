# Guida Git Clones per la Regina

> **Per:** Me stessa (Cervella Regina/Orchestratrice)
> **Obiettivo:** Sapere QUANDO e COME usare git clones
> **Il segreto:** COMUNICAZIONE!

---

## QUANDO Usare Git Clone

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   LA REGOLA DEI 5 MINUTI                                        ║
║                                                                  ║
║   Task < 5 min:                                                  ║
║   → Task tool interno                                           ║
║   → Il worker lavora nel MIO context                            ║
║   → Risultato immediato                                         ║
║   → ⚠️ Se compatto, PERDO il lavoro del worker!                ║
║                                                                  ║
║   Task > 5 min:                                                  ║
║   → Git clone separato                                          ║
║   → Il worker ha il SUO context                                 ║
║   → Sopravvive a compact                                        ║
║   → Devo fare MERGE dei risultati                               ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

### Esempi Concreti

| Task | Tempo | Cosa Uso |
|------|-------|----------|
| Ricerca veloce | 2 min | Task tool |
| Analisi file | 3 min | Task tool |
| Code review piccolo | 4 min | Task tool |
| Implementare feature | 15+ min | **Git clone** |
| Refactoring | 20+ min | **Git clone** |
| Test suite completa | 10+ min | **Git clone** |
| Ricerca approfondita | 10+ min | **Git clone** |

---

## COME Creare un Git Clone

### Passo 1: Creo il Clone

```bash
# Dal repo principale, creo un clone
git clone . ../CervellaSwarm-worker-1

# Oppure per un progetto specifico:
git clone . ../miracollo-worker-1
```

### Passo 2: Preparo il Task File

```bash
# Creo il file task per il worker
cat > ../CervellaSwarm-worker-1/TASK.md << 'EOF'
# Task per Worker

## Obiettivo
[Cosa deve fare il worker]

## Context
[Informazioni necessarie]

## Output Richiesto
[Dove scrivere, formato, ecc]

## Quando Finito
Crea file DONE.md con:
- Cosa hai fatto
- File modificati
- Note importanti
EOF
```

### Passo 3: Lancio il Worker

```bash
# Apro una nuova sessione Claude nel clone
cd ../CervellaSwarm-worker-1
claude

# Oppure con tmux (background)
tmux new-session -d -s worker1 "cd ../CervellaSwarm-worker-1 && claude"
```

### Passo 4: Aspetto e Verifico

```bash
# Controllo se il worker ha finito
ls ../CervellaSwarm-worker-1/DONE.md

# Leggo cosa ha fatto
cat ../CervellaSwarm-worker-1/DONE.md
```

### Passo 5: Porto i Risultati

```bash
# Torno al repo principale
cd /Users/rafapra/Developer/CervellaSwarm

# Prendo i cambiamenti dal clone
git pull ../CervellaSwarm-worker-1 main

# Oppure cherry-pick specifico
git fetch ../CervellaSwarm-worker-1 main
git cherry-pick FETCH_HEAD
```

### Passo 6: Pulizia

```bash
# Elimino il clone (non serve piu)
rm -rf ../CervellaSwarm-worker-1
```

---

## La COMUNICAZIONE (Il Segreto!)

### Regina → Worker

```
IO comunico al worker tramite:
1. TASK.md - Cosa deve fare
2. Context nel task - Info necessarie
3. CLAUDE.md del clone - Regole da seguire
```

### Worker → Regina

```
Il worker comunica a ME tramite:
1. DONE.md - Cosa ha fatto
2. File modificati - Il lavoro vero
3. Git commits - Storia dei cambiamenti
```

### Formato TASK.md Standard

```markdown
# Task: [Nome Breve]

## Obiettivo
[1-2 frasi chiare]

## Context
- Progetto: [nome]
- Branch: [quale]
- File rilevanti: [lista]

## Cosa Fare
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Output
- File da creare/modificare: [lista]
- Formato output: [descrizione]

## Quando Finito
Crea DONE.md con riepilogo.
```

### Formato DONE.md Standard

```markdown
# Task Completato

## Cosa Ho Fatto
- [Azione 1]
- [Azione 2]

## File Modificati
| File | Modifica |
|------|----------|
| [path] | [cosa] |

## Commit
- [hash]: [messaggio]

## Note
[Problemi incontrati, decisioni prese, suggerimenti]
```

---

## Workflow Completo per Task > 5 min

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   1. DECIDO che serve clone (task > 5 min)                      ║
║                                                                  ║
║   2. CREO il clone:                                             ║
║      git clone . ../[progetto]-worker-1                         ║
║                                                                  ║
║   3. PREPARO TASK.md con istruzioni chiare                      ║
║                                                                  ║
║   4. LANCIO worker (tmux o nuovo terminal)                      ║
║                                                                  ║
║   5. CONTINUO a lavorare su altro (parallelo!)                  ║
║                                                                  ║
║   6. VERIFICO periodicamente se DONE.md esiste                  ║
║                                                                  ║
║   7. LEGGO DONE.md per capire cosa ha fatto                     ║
║                                                                  ║
║   8. PORTO risultati con git pull                               ║
║                                                                  ║
║   9. VERIFICO che tutto funzioni                                ║
║                                                                  ║
║   10. PULISCO eliminando il clone                               ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## Script Automatico (da creare)

```bash
#!/bin/bash
# create-worker-clone.sh

PROJECT=$1
TASK_NAME=$2

# Crea clone
git clone . ../${PROJECT}-worker-${TASK_NAME}

# Crea TASK.md vuoto
cat > ../${PROJECT}-worker-${TASK_NAME}/TASK.md << 'EOF'
# Task: [NOME]

## Obiettivo


## Context


## Cosa Fare


## Output


## Quando Finito
Crea DONE.md
EOF

echo "Clone creato: ../${PROJECT}-worker-${TASK_NAME}"
echo "Modifica TASK.md e poi lancia: cd ../${PROJECT}-worker-${TASK_NAME} && claude"
```

---

## Errori da Evitare

```
❌ NON lanciare worker senza TASK.md chiaro
❌ NON dimenticare di fare pull dei risultati
❌ NON lasciare clones inutilizzati (spazio disco!)
❌ NON fare merge senza verificare prima
❌ NON usare clone per task < 5 min (overhead inutile)
```

---

## Quando IO (Regina) Devo Usare Clone

Ogni volta che penso:
- "Questo task richiederà tempo..."
- "Il worker dovrà fare molte modifiche..."
- "Se compatto perdo tutto..."

**→ CREO UN CLONE!**

Meglio un clone in più che perdere lavoro.

---

*"Il segreto è la COMUNICAZIONE. TASK.md chiaro = lavoro fatto bene."*
