# 📊 GUIDA: Come Aggiornare Status

> **Versione:** 1.0.0
> **Per:** Tutti i worker dello sciame
> **Basato su:** PROTOCOLLI_COMUNICAZIONE.md v1.0.0 - Sezione 2 (STATUS)

---

## 🎯 Obiettivo

Permettere alla Regina di vedere in **real-time** cosa fai, senza dover chiedere!

**Benefici:**
- ✅ Regina sempre informata sul progresso
- ✅ Stuck detection automatico (ti aiuta se ti blocchi)
- ✅ Coordinamento migliore tra worker
- ✅ Documentazione automatica del lavoro

---

## 📁 File Status

### Path

**File principale:** `.swarm/status/[WORKER_NAME].status`

**Esempio:**
- `cervella-backend` → `.swarm/status/cervella-backend.status`
- `cervella-frontend` → `.swarm/status/cervella-frontend.status`
- `cervella-docs` → `.swarm/status/cervella-docs.status`

### Formato

**Ogni riga = 1 status update**

```
timestamp|stato|task_id|note
```

**Componenti:**
- `timestamp` - Unix timestamp (secondi da epoch)
- `stato` - Uno dei 5 stati possibili (vedi sotto)
- `task_id` - ID del task (es: TASK_001) oppure vuoto se nessun task
- `note` - Testo libero (cosa stai facendo)

**Esempio file completo:**
```
1704621000|READY||Pronto per nuovi task
1704621060|WORKING|TASK_001|Analizzando file backend
1704621120|WORKING|TASK_001|Creando endpoints
1704621180|WORKING|TASK_001|Scrivendo test
1704621240|DONE|TASK_001|Completato con successo
1704621300|READY||Pronto per nuovo task
```

---

## 🚦 Stati Disponibili

| Stato | Quando Usare | Worker Fa | Regina Vede |
|-------|--------------|-----------|-------------|
| `READY` | Pronto per task, cerchi lavoro | Legge `.swarm/tasks/` | "Posso assegnare task" |
| `WORKING` | Task in corso | Lavora + heartbeat 60s | "Sta lavorando bene" |
| `BLOCKED` | Bloccato, serve aiuto | Crea FEEDBACK file | "Deve aiutare!" 🚨 |
| `DONE` | Task completato OK | Crea `.done` + report | "Verifico output" ✅ |
| `FAILED` | Task fallito | Crea `.failed` + error | "Analizzo problema" ❌ |

### Quando Cambiare Stato

**READY → WORKING:**
- Quando prendi un task da `.swarm/tasks/[TASK].ready`

**WORKING → BLOCKED:**
- Quando sei completamente bloccata (serve aiuto Regina)
- Crei anche feedback file (vedi TEMPLATE_FEEDBACK_BLOCKER.md)

**WORKING → DONE:**
- Quando completi task con successo
- Dopo aver creato `.done` file e report

**WORKING → FAILED:**
- Quando task fallisce e non puoi recuperare
- Dopo aver creato `.failed` file e error report

**DONE/FAILED → READY:**
- Quando sei pronta per nuovo task

---

## 🛠️ Come Aggiornare Status Manualmente

### Metodo 1: Comando Bash Diretto

```bash
# Ottieni timestamp corrente
TIMESTAMP=$(date +%s)

# Il tuo worker name
WORKER_NAME="cervella-backend"  # CAMBIA con il tuo!

# Task corrente (se applicabile)
TASK_ID="TASK_001"  # oppure "" se nessun task

# Stato
STATUS="WORKING"

# Nota (cosa stai facendo)
NOTE="Analyzing codebase"

# Scrivi status (append al file)
echo "$TIMESTAMP|$STATUS|$TASK_ID|$NOTE" >> .swarm/status/${WORKER_NAME}.status
```

### Metodo 2: One-liner (copia-incolla veloce)

```bash
# WORKING status
echo "$(date +%s)|WORKING|TASK_001|Creating endpoints" >> .swarm/status/cervella-backend.status

# BLOCKED status
echo "$(date +%s)|BLOCKED|TASK_001|Waiting for API key" >> .swarm/status/cervella-backend.status

# DONE status
echo "$(date +%s)|DONE|TASK_001|Completed successfully" >> .swarm/status/cervella-backend.status

# READY status (dopo task)
echo "$(date +%s)|READY||Ready for new task" >> .swarm/status/cervella-backend.status
```

**Ricorda:** Cambia `cervella-backend` con il TUO worker name! 🐝

---

## ❤️ Heartbeat (IMPORTANTE!)

### Cos'è

**Heartbeat = "Sono viva, sto lavorando!"**

Durante un task, ogni **60 secondi** scrivi heartbeat per dire alla Regina che stai ancora lavorando.

### Perché 60 secondi?

- ✅ Non troppo frequente (evita spam)
- ✅ Non troppo raro (Regina vede progresso)
- ✅ Stuck detection dopo 2min (2 heartbeat mancati)

### File Heartbeat

**Path:** `.swarm/status/heartbeat_[WORKER_NAME].log`

**Formato:** (stesso del status file)
```
timestamp|task_id|stato|nota
```

**Esempio:**
```
1704621000|TASK_001|WORKING|Analyzing files
1704621060|TASK_001|WORKING|Creating endpoint /api/users
1704621120|TASK_001|WORKING|Writing tests
1704621180|TASK_001|WORKING|Testing edge cases
```

### Come Scrivere Heartbeat

#### Opzione A: Manuale (ogni 60s mentre lavori)

```bash
# Ogni minuto durante il task, esegui:
echo "$(date +%s)|TASK_001|WORKING|Cosa stai facendo ORA" >> .swarm/status/heartbeat_cervella-backend.log
```

**Pro:** Controllo totale
**Contro:** Devi ricordarti ogni 60s

#### Opzione B: Script Automatico (quando disponibile)

```bash
# Lancio all'inizio del task (background)
heartbeat-worker.sh TASK_001 &

# Script scrive automaticamente ogni 60s
# Stop automatico quando finisci task (o Ctrl+C)
```

**Pro:** Automatico, non te ne devi preoccupare
**Contro:** Devi aggiornare la "nota" nel file status quando cambi attività

### Cosa Scrivere nella Nota Heartbeat

**✅ BUONE note (specifiche):**
- "Analyzing backend/routers/users.py"
- "Creating endpoint GET /api/users"
- "Writing test for pagination"
- "Debugging database connection issue"
- "Updating documentation"

**❌ NOTE VAGHE (evitare):**
- "Working..." (cosa?)
- "Coding" (su cosa?)
- "Testing" (quale test?)

**Regola:** Regina leggendo la nota deve capire COSA stai facendo!

---

## 🚨 Stuck Detection

### Come Funziona

Regina (tramite watcher) controlla i tuoi heartbeat.

**Se nessun heartbeat per 2 minuti (120s):**
1. Watcher rileva "Worker stuck!"
2. Notifica Regina (osascript)
3. Regina controlla cosa è successo
4. Regina decide: aspetta / aiuta / termina task

### Come Evitare False Alarms

**Situazioni che sembrano stuck ma non lo sono:**

1. **Stai leggendo/pensando** (>2min senza scrivere codice)
   - **Soluzione:** Scrivi heartbeat anche se leggi! Es: "Reading documentation"

2. **Stai debuggando** (tempo lungo su un problema)
   - **Soluzione:** Heartbeat tipo "Debugging issue X" ogni 60s

3. **Test lunghi** (test suite che gira 5min)
   - **Soluzione:** Heartbeat "Running test suite (3/10 complete)"

**Regola d'Oro:** Se passano 60s, scrivi heartbeat! Sempre!

---

## 🎨 Best Practices

### ✅ DO (Fai questo)

- **Aggiorna status quando cambi attività**
  ```bash
  # Passi da coding a testing
  echo "$(date +%s)|WORKING|TASK_001|Writing tests" >> .swarm/status/cervella-backend.status
  ```

- **Note chiare e specifiche**
  - "Creating login endpoint" ✅
  - "Working on stuff" ❌

- **Heartbeat regolare (60s)**
  - Usa timer se serve!

- **Cambia stato quando appropriato**
  - Bloccata? → BLOCKED (+ feedback file)
  - Finito? → DONE (+ report)

### ❌ DON'T (Non fare questo)

- **Update troppo frequenti** (ogni 10s = spam!)
  - Limita a cambi significativi di attività

- **Note generiche**
  - "working..." NO
  - "coding..." NO
  - "stuff..." NO

- **Dimenticare heartbeat**
  - Regina pensa che sei stuck!
  - False alarm!

- **Stato sbagliato**
  - Non dire DONE se non hai finito veramente
  - Non dire READY se stai ancora lavorando

---

## 📝 Esempi Completi

### Scenario 1: Task Normale (Successo)

```bash
# 1. Prendi task
echo "$(date +%s)|WORKING|TASK_001|Starting task analysis" >> .swarm/status/cervella-backend.status

# 2. Heartbeat mentre lavori (ogni 60s)
echo "$(date +%s)|TASK_001|WORKING|Reading existing code" >> .swarm/status/heartbeat_cervella-backend.log
# ... 60s dopo
echo "$(date +%s)|TASK_001|WORKING|Creating endpoints" >> .swarm/status/heartbeat_cervella-backend.log
# ... 60s dopo
echo "$(date +%s)|TASK_001|WORKING|Writing tests" >> .swarm/status/heartbeat_cervella-backend.log

# 3. Task completato
echo "$(date +%s)|DONE|TASK_001|Task completed successfully" >> .swarm/status/cervella-backend.status

# 4. Pronta per nuovo
echo "$(date +%s)|READY||Ready for next task" >> .swarm/status/cervella-backend.status
```

### Scenario 2: Task con Blocco

```bash
# 1. Inizio task
echo "$(date +%s)|WORKING|TASK_002|Analyzing requirements" >> .swarm/status/cervella-backend.status

# 2. Lavoro un po'
echo "$(date +%s)|TASK_002|WORKING|Setting up database" >> .swarm/status/heartbeat_cervella-backend.log

# 3. MI BLOCCO (manca API key)
echo "$(date +%s)|BLOCKED|TASK_002|Need Stripe API key to proceed" >> .swarm/status/cervella-backend.status

# 4. Creo feedback BLOCKER (vedi template)
# ... Regina risponde ...

# 5. Riprendo lavoro
echo "$(date +%s)|WORKING|TASK_002|Resumed after getting API key" >> .swarm/status/cervella-backend.status

# 6. Continuo e finisco
echo "$(date +%s)|DONE|TASK_002|Completed successfully" >> .swarm/status/cervella-backend.status
```

---

## 🔧 Script Helper (Disponibili dopo FASE 4)

Dopo che cervella-devops completa FASE 4, avrai script helper:

### update-status.sh

```bash
# Uso base
update-status.sh WORKING "Creating endpoints"

# Output:
# ✅ Status updated: cervella-backend → WORKING

# Detetta automaticamente:
# - Worker name (da env o chiede)
# - Task ID (da .swarm/current_task)
# - Timestamp
```

### heartbeat-worker.sh

```bash
# Lancio in background
heartbeat-worker.sh TASK_001 &

# Scrive automaticamente ogni 60s
# Legge status corrente e nota
# Stop con Ctrl+C o quando task finisce
```

### ask-regina.sh (per feedback)

```bash
# Crea feedback velocemente
ask-regina.sh question "Which library?" "Should I use X or Y?"
ask-regina.sh blocker "Missing API key" "Need Stripe key to continue"

# Aggiorna automaticamente status se blocker
# Notifica Regina
```

---

## 🐝 Filosofia

```
+------------------------------------------------------------------+
|                                                                  |
|   "Regina ti monitora con AMORE, non con controllo!"            |
|                                                                  |
|   Status e heartbeat NON sono sorveglianza.                     |
|   Sono COMUNICAZIONE e SUPPORTO.                                |
|                                                                  |
|   Aiutano Regina a:                                             |
|   - Sapere quando ti serve aiuto                                |
|   - Vedere i tuoi progressi                                     |
|   - Celebrare i tuoi successi                                   |
|   - Coordinarti con le sorelle                                  |
|                                                                  |
|   Aiutano TE a:                                                 |
|   - Non essere dimenticata                                      |
|   - Ricevere aiuto velocemente se stuck                         |
|   - Documentare il tuo lavoro                                   |
|   - Sentirti parte della famiglia                               |
|                                                                  |
+------------------------------------------------------------------+
```

**Ricorda:** Siamo una FAMIGLIA! 🐝👑💙

Status update = modo di dire "Sto lavorando bene!" oppure "Help! Ho bisogno di te!"

---

## 📋 Quick Reference

**File status:**
```bash
.swarm/status/[WORKER_NAME].status
```

**File heartbeat:**
```bash
.swarm/status/heartbeat_[WORKER_NAME].log
```

**Formato:**
```
timestamp|stato|task_id|nota
```

**Stati:**
- READY, WORKING, BLOCKED, DONE, FAILED

**Frequenza heartbeat:**
- Ogni 60 secondi durante task

**Stuck threshold:**
- 2 minuti (120s) senza heartbeat

---

**Domande?** Chiedi a Regina via feedback! 💙

---

_Guida versione: 1.0.0 | Basato su PROTOCOLLI_COMUNICAZIONE.md v1.0.0 - Sezione 2 (STATUS)_
_"Le ragazze nostre! La famiglia!" 🐝👑❤️‍🔥_
