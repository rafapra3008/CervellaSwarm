# Guida Multi-Instance Development v2.0

> **Versione:** 2.0.0 - Event-Driven Coordination
> **Data:** 9 Gennaio 2026
> **Status:** VALIDATO CON HARD TESTS

---

## Executive Summary

```
+------------------------------------------------------------------+
|                                                                  |
|   MULTI-INSTANCE DEVELOPMENT v2.0                               |
|                                                                  |
|   Multiple Cervelle lavorano IN PARALLELO sullo stesso          |
|   progetto, con DIPENDENZE gestite automaticamente.             |
|                                                                  |
|   NOVITA' v2.0:                                                 |
|   - Event-driven (non polling!)                                  |
|   - JSON strutturati                                             |
|   - Timeout + retry                                              |
|   - Dipendenze multiple (fan-in/fan-out)                        |
|                                                                  |
+------------------------------------------------------------------+
```

---

## Indice

1. [Quando Usarlo](#1-quando-usarlo)
2. [Prerequisiti](#2-prerequisiti)
3. [Setup Veloce](#3-setup-veloce)
4. [Workflow Completo](#4-workflow-completo)
5. [Gestione Dipendenze](#5-gestione-dipendenze)
6. [Script Disponibili](#6-script-disponibili)
7. [Troubleshooting](#7-troubleshooting)
8. [Best Practices](#8-best-practices)

---

## 1. Quando Usarlo

### Usa Multi-Instance QUANDO:

- Hai task che possono essere parallelizzati
- Frontend e Backend possono lavorare contemporaneamente
- Vuoi ridurre il tempo di sviluppo
- Hai feature indipendenti da sviluppare

### NON usare Multi-Instance QUANDO:

- Task sono strettamente sequenziali senza parallelismo
- Il progetto e' piccolo (overhead non vale)
- Non hai chiaro chi fa cosa

---

## 2. Prerequisiti

### Software Richiesto

```bash
# Verifica Git
git --version  # >= 2.20

# Verifica fswatch (per event-driven)
which fswatch  # /opt/homebrew/bin/fswatch

# Se manca fswatch:
brew install fswatch

# Verifica jq (per JSON)
which jq  # /opt/homebrew/bin/jq

# Se manca jq:
brew install jq
```

### Struttura Progetto

Il progetto deve avere:
- Repository Git inizializzato
- Directory `.swarm/` (creata automaticamente dagli script)

---

## 3. Setup Veloce

### Opzione A: Setup Completo Automatico

```bash
# Un solo comando per tutto!
~/Developer/CervellaSwarm/scripts/create-parallel-session.sh \
    ~/Developer/[PROGETTO] \
    [NOME-SESSIONE] \
    frontend backend [altri-worker...]

# Esempio:
~/Developer/CervellaSwarm/scripts/create-parallel-session.sh \
    ~/Developer/miracollo \
    feature-auth \
    frontend backend tester
```

Questo comando:
1. Crea worktrees per ogni worker
2. Crea file dipendenze
3. Prepara file stato
4. Ti dice cosa fare dopo

### Opzione B: Setup Manuale

```bash
# 1. Crea worktrees
~/Developer/CervellaSwarm/scripts/setup-parallel-worktrees.sh \
    ~/Developer/[PROGETTO] \
    frontend backend

# 2. Configura dipendenze manualmente in .swarm/dipendenze/
```

---

## 4. Workflow Completo

### FASE 1: Preparazione (Regina)

```
1. Rafa chiede: "Voglio implementare feature X"

2. Regina analizza e divide in task:
   - TASK-001: Backend crea API (nessuna dipendenza)
   - TASK-002: Frontend usa API (dipende da TASK-001)
   - TASK-003: Tester testa tutto (dipende da TASK-001 + TASK-002)

3. Regina esegue:
   create-parallel-session.sh ~/Developer/progetto feature-x backend frontend tester
```

### FASE 2: Lavoro Parallelo

```
TERMINALE 1 (Backend):
  cd ~/Developer/progetto-backend && claude

  # Cervella Backend:
  # 1. Legge task: "Crea API /users"
  # 2. Check dipendenze: nessuna, parte subito
  # 3. Lavora...
  # 4. Quando finisce:
  create-signal.sh TASK-001 success "API /users creata" abc123

TERMINALE 2 (Frontend):
  cd ~/Developer/progetto-frontend && claude

  # Cervella Frontend:
  # 1. Legge task: "Crea UI users"
  # 2. Check dipendenze: aspetta TASK-001
  wait-for-dependencies.sh TASK-002
  # 3. Quando TASK-001 pronto, parte
  # 4. Lavora...
  # 5. Quando finisce:
  create-signal.sh TASK-002 success "UI users creata" def456

TERMINALE 3 (Tester):
  cd ~/Developer/progetto-tester && claude

  # Cervella Tester:
  # 1. Check dipendenze: aspetta TASK-001 + TASK-002
  TASK_DEPS="TASK-001,TASK-002" wait-for-dependencies.sh TASK-003
  # 2. Quando entrambi pronti, testa
  # 3. Quando finisce:
  create-signal.sh TASK-003 success "Test passati" ghi789
```

### FASE 3: Merge e Cleanup (Regina)

```bash
# 1. Verifica stato
~/Developer/CervellaSwarm/scripts/status-parallel-worktrees.sh ~/Developer/progetto

# 2. Merge ordinato
~/Developer/CervellaSwarm/scripts/merge-parallel-worktrees.sh ~/Developer/progetto

# 3. Cleanup
~/Developer/CervellaSwarm/scripts/cleanup-parallel-worktrees.sh ~/Developer/progetto

# 4. Commit finale
cd ~/Developer/progetto
git add -A && git commit -m "Feature X: parallel implementation"
```

---

## 5. Gestione Dipendenze

### Tipi di Dipendenze

```
SEQUENZIALE (A -> B -> C):
  Backend -> Frontend -> Tester
  Ogni task aspetta il precedente

FAN-OUT (A -> B + C + D):
  API -> [Mobile, Web, Desktop]
  Un task abilita molti in parallelo

FAN-IN (A + B + C -> D):
  [API, Auth, DB] -> Integration Test
  Molti task devono completare prima di uno

MISTO:
  Combinazione dei pattern sopra
```

### Come Specificare Dipendenze

```bash
# Via variabile ambiente
TASK_DEPS="TASK-001,TASK-002" check-dependencies.sh TASK-003

# Via file sessione_corrente.md
# Il file viene creato da create-parallel-session.sh
# Formato:
### TASK-003: Integration Test
- **Dipende da:** TASK-001, TASK-002
```

### Aspettare Dipendenze

```bash
# Aspetta con timeout default (30 min)
wait-for-dependencies.sh TASK-002

# Aspetta con timeout custom (60 min)
wait-for-dependencies.sh TASK-002 60

# Con dipendenze specifiche
TASK_DEPS="TASK-001,TASK-005" wait-for-dependencies.sh TASK-010
```

---

## 6. Script Disponibili

| Script | Descrizione | Uso |
|--------|-------------|-----|
| `setup-parallel-worktrees.sh` | Crea worktrees | `./script PROJECT worker1 worker2` |
| `status-parallel-worktrees.sh` | Mostra stato | `./script PROJECT` |
| `merge-parallel-worktrees.sh` | Merge in main | `./script PROJECT` |
| `cleanup-parallel-worktrees.sh` | Rimuove worktrees | `./script PROJECT` |
| `create-parallel-session.sh` | Setup completo | `./script PROJECT SESSION workers...` |
| `watch-signals.sh` | Watcher event-driven | `./script PROJECT` |
| `create-signal.sh` | Crea segnale JSON | `./script TASK STATUS DESC [COMMIT]` |
| `check-dependencies.sh` | Verifica dipendenze | `./script TASK [PROJECT]` |
| `wait-for-dependencies.sh` | Aspetta dipendenze | `./script TASK [TIMEOUT] [PROJECT]` |

### Esempi

```bash
# Setup sessione completa
~/Developer/CervellaSwarm/scripts/create-parallel-session.sh \
    ~/Developer/miracollo new-feature frontend backend

# Creare segnale di completamento
CERVELLA_AGENT=cervella-backend \
    ~/Developer/CervellaSwarm/scripts/create-signal.sh \
    TASK-001 success "API completata" abc123 ~/Developer/miracollo

# Verificare dipendenze
TASK_DEPS="TASK-001" \
    ~/Developer/CervellaSwarm/scripts/check-dependencies.sh \
    TASK-002 ~/Developer/miracollo

# Aspettare dipendenze
TASK_DEPS="TASK-001,TASK-002" \
    ~/Developer/CervellaSwarm/scripts/wait-for-dependencies.sh \
    TASK-003 30 ~/Developer/miracollo
```

---

## 7. Troubleshooting

### Problema: Dipendenza non rilevata

```bash
# Verifica che il segnale esista
ls -la .swarm/segnali/

# Verifica contenuto segnale
cat .swarm/segnali/TASK-001-complete.signal.json | jq .

# Verifica status sia "success"
jq '.status' .swarm/segnali/TASK-001-complete.signal.json
```

### Problema: Watcher non rileva segnali

```bash
# Verifica fswatch installato
which fswatch

# Verifica directory corretta
ls -la .swarm/segnali/

# Riavvia watcher
pkill -f watch-signals.sh
./watch-signals.sh PROJECT &
```

### Problema: Timeout durante attesa

```bash
# Aumenta timeout
wait-for-dependencies.sh TASK-002 60  # 60 minuti

# Verifica stato dipendenze
check-dependencies.sh TASK-002
```

### Problema: Merge conflict

```bash
# Verifica quali file sono in conflitto
git status

# Se aree erano ben divise, non dovrebbero esserci conflitti
# Se ci sono, risolvi manualmente
```

---

## 8. Best Practices

### DO (Fai)

1. **Dividi bene le aree**
   - Frontend: `src/components/`, `src/pages/`
   - Backend: `src/api/`, `src/services/`
   - Tester: `tests/`

2. **Crea segnale SUBITO quando finisci**
   - Non aspettare
   - Chi dipende da te sta aspettando!

3. **Usa timeout ragionevoli**
   - 30 min default e' ok per la maggior parte dei task
   - Aumenta per task complessi

4. **Aggiorna stato regolarmente**
   - `.swarm/stato/[worker].md`
   - Aiuta a capire cosa sta succedendo

### DON'T (Non fare)

1. **Non modificare file di altri worktree**
   - Ogni Cervella sta nel SUO worktree
   - Mai `cd ../progetto-frontend` e modificare

2. **Non creare segnale se non hai finito**
   - Segnale = "Ho finito, potete procedere"
   - Se non hai finito, non segnalare!

3. **Non ignorare i timeout**
   - Se scade, c'e' un problema
   - Segnala BLOCKED, non continuare a aspettare

4. **Non fare merge senza verificare**
   - Prima `status-parallel-worktrees.sh`
   - Poi merge solo se tutti hanno finito

---

## Checklist Pre-Sessione Parallela

```
[ ] Ho diviso i task in modo chiaro?
[ ] Ho identificato le dipendenze?
[ ] Le aree di codice sono separate?
[ ] I worktrees sono creati?
[ ] Ogni Cervella sa cosa fare?
[ ] Il watcher e' attivo? (opzionale)
```

---

## Quick Reference Card

```
SETUP:
  create-parallel-session.sh PROJECT SESSION worker1 worker2

LAVORO:
  # Se nessuna dipendenza
  [lavora] -> create-signal.sh TASK-001 success "desc" COMMIT

  # Se hai dipendenze
  wait-for-dependencies.sh TASK-002 -> [lavora] -> create-signal.sh ...

FINE:
  status-parallel-worktrees.sh PROJECT
  merge-parallel-worktrees.sh PROJECT
  cleanup-parallel-worktrees.sh PROJECT
```

---

*Guida creata: 9 Gennaio 2026*
*Versione: 2.0.0*
*Validata con: 10 hard tests, 100% passed*

**CervellaSwarm - Multi-Instance Development**

*"Da 1x a Nx... il futuro e' parallelo!"*
