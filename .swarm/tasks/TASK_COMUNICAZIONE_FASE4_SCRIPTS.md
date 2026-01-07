# Task: FASE 4 - Implementare Scripts Comunicazione

**Assegnato a:** cervella-devops
**Stato:** ready
**Priorità:** ALTA
**Progetto:** CervellaSwarm
**Sub-Roadmap:** SUB_ROADMAP_COMUNICAZIONE_INTERNA.md

---

## CONTESTO

Stiamo implementando i nuovi protocolli di comunicazione per le 16 api!

**FASE 1:** ✅ Studio completato (cervella-researcher - 1,385 righe)
**FASE 2:** ✅ Protocolli definiti (Regina - 736 righe)
**FASE 3:** ⏳ Templates (cervella-docs - parallelo a te!)
**FASE 4:** ⏳ Scripts (TU!)

**File protocolli:** `docs/protocolli/PROTOCOLLI_COMUNICAZIONE.md`

Leggi sezioni 2 (STATUS), 3 (FEEDBACK), 5 (WORKFLOW) prima di iniziare!

---

## OBIETTIVO

Creare gli script bash che automatizzano la comunicazione.

**Output:** 4 script funzionanti in `scripts/swarm/` + watcher esteso

---

## GLI SCRIPT DA CREARE

### 1. update-status.sh

**Path:** `scripts/swarm/update-status.sh`

**Cosa fa:** Helper per worker - aggiorna status file

**Basato su:** Sezione 2.6 del protocollo

**Firma:**

```bash
#!/bin/bash
# Usage: update-status.sh STATUS "note"
# Example: update-status.sh WORKING "Creating endpoints"
```

**Funzionalità:**

1. Detecta automaticamente worker name
   - Se variabile env `SWARM_WORKER_NAME` esiste → usa quella
   - Altrimenti: chiedi a utente o usa "unknown"

2. Legge current task_id
   - Da file `.swarm/current_task` (se esiste)
   - Oppure "NONE"

3. Valida stato
   - Controlla che sia: READY, WORKING, BLOCKED, DONE, FAILED
   - Altrimenti: errore

4. Scrive in status file
   - Path: `.swarm/status/[WORKER_NAME].status`
   - Formato: `timestamp|stato|task_id|note`
   - Append (non overwrite!)

5. Notifica (opzionale)
   - Se stato = BLOCKED o FAILED → notifica osascript a Regina

**Output atteso:**

```bash
$ ./update-status.sh WORKING "Creating API endpoints"
✅ Status updated: cervella-backend → WORKING

$ ./update-status.sh BLOCKED "Need help with authentication"
✅ Status updated: cervella-backend → BLOCKED
🔔 Regina notified!
```

**Edge cases:**
- Directory `.swarm/status/` non esiste? Crea!
- Stato invalido? Mostra errore + lista stati validi
- Note vuota? OK, ma warn

---

### 2. heartbeat-worker.sh

**Path:** `scripts/swarm/heartbeat-worker.sh`

**Cosa fa:** Script che worker lancia - scrive heartbeat ogni 60s

**Basato su:** Sezione 2.4 del protocollo

**Firma:**

```bash
#!/bin/bash
# Usage: heartbeat-worker.sh TASK_ID
# Runs in background, writes heartbeat every 60s
# Stop with: kill $(cat .swarm/heartbeat_PID)
```

**Funzionalità:**

1. Prende task_id come parametro

2. Detecta worker name (come update-status.sh)

3. Loop infinito:
   ```bash
   while true; do
     # Leggi current status (da .swarm/status/[WORKER].status ultima riga)
     # Leggi current note (attività corrente)
     
     # Scrivi heartbeat
     echo "$(date +%s)|$TASK_ID|$STATUS|$NOTE" >> .swarm/status/heartbeat_[WORKER].log
     
     # Sleep 60s
     sleep 60
   done
   ```

4. Salva PID
   - In `.swarm/heartbeat_[WORKER].pid`
   - Per permettere kill facile

5. Cleanup su exit (trap)
   - Rimuovi PID file
   - Scrivi ultimo heartbeat "STOPPED"

**Output atteso:**

```bash
$ ./heartbeat-worker.sh TASK_001 &
✅ Heartbeat started for cervella-backend (PID: 12345)
📝 Writing to: .swarm/status/heartbeat_cervella-backend.log

# Dopo 2 min, file contiene:
1704621000|TASK_001|WORKING|Analyzing files
1704621060|TASK_001|WORKING|Creating endpoints
```

**Edge cases:**
- Già un heartbeat attivo? Warn ma permetti (multi-task?)
- Directory non esiste? Crea!

---

### 3. ask-regina.sh

**Path:** `scripts/swarm/ask-regina.sh`

**Cosa fa:** Helper per worker - crea feedback file

**Basato su:** Sezione 3 del protocollo

**Firma:**

```bash
#!/bin/bash
# Usage: ask-regina.sh TIPO "titolo" "descrizione"
# Types: question, issue, blocker, suggestion
# Example: ask-regina.sh question "Which library?" "Should I use X or Y?"
```

**Funzionalità:**

1. Valida tipo
   - Deve essere: question, issue, blocker, suggestion
   - Case-insensitive, converti a lowercase

2. Detecta worker e task
   - Worker name (env o chiedi)
   - Task ID (da `.swarm/current_task`)

3. Crea feedback file
   - Path: `.swarm/feedback/[TIPO_UPPER]_[TASK]_[TIMESTAMP].md`
   - Usa template appropriato (da `.swarm/templates/TEMPLATE_FEEDBACK_[TIPO].md`)
   - Sostituisci placeholder:
     - [TASK_ID] → actual task id
     - [WORKER] → worker name
     - [TIMESTAMP] → ISO8601
     - [TITOLO] → parametro titolo
     - [DESCRIZIONE] → parametro descrizione (nella sezione appropriata)

4. Aggiorna status se BLOCKER
   - Se tipo = blocker → call update-status.sh BLOCKED

5. Notifica Regina
   - osascript notification
   - Diverso messaggio per tipo:
     - question: "💬 Question from [worker]"
     - issue: "⚠️ Issue reported by [worker]"
     - blocker: "🚫 BLOCKER from [worker]!"
     - suggestion: "💡 Suggestion from [worker]"

6. Apri file in editor (opzionale)
   - Worker può aggiungere dettagli
   - `open [FILE]` (macOS)

**Output atteso:**

```bash
$ ./ask-regina.sh question "Which library?" "Should I use FastAPI or Flask?"
✅ Feedback created: .swarm/feedback/QUESTION_TASK001_1704621240.md
🔔 Regina notified: 💬 Question from cervella-backend
📝 Opening editor for details...
```

**Edge cases:**
- Template non esiste? Crea feedback basic senza template
- Tipo invalido? Mostra lista tipi validi
- Directory non esiste? Crea!

---

### 4. check-stuck.sh

**Path:** `scripts/swarm/check-stuck.sh`

**Cosa fa:** Helper per Regina/watcher - controlla worker stuck

**Basato su:** Sezione 2.5 del protocollo

**Firma:**

```bash
#!/bin/bash
# Usage: check-stuck.sh [WORKER_NAME]
# If no worker specified, checks ALL workers
# Exit code: 0 = all OK, 1 = stuck detected
```

**Funzionalità:**

1. Se worker specificato → controlla solo lui
   Altrimenti → loop su tutti i file in `.swarm/status/heartbeat_*.log`

2. Per ogni worker:
   - Leggi ultimo heartbeat
   - Parse timestamp
   - Calcola diff con now
   - Se diff > 120s (2 min) → STUCK!

3. Output stuck workers:
   ```
   ⚠️ STUCK DETECTED:
   - cervella-backend (last seen: 5 min ago)
   - cervella-frontend (last seen: 3 min ago)
   ```

4. Return:
   - 0 se tutti OK
   - 1 se almeno 1 stuck

5. Opzionale: flag --notify
   - Se stuck, notifica Regina via osascript

**Output atteso:**

```bash
$ ./check-stuck.sh
✅ All workers active:
- cervella-backend: 30s ago
- cervella-docs: 45s ago

$ ./check-stuck.sh
⚠️ STUCK DETECTED:
- cervella-frontend: 3m 20s ago (last: "Creating component")

$ echo $?
1
```

**Edge cases:**
- Nessun heartbeat file? "No workers active"
- File vuoto? "Worker never started heartbeat"
- Worker stopped normalmente? Ignora (check se esiste .done o .failed)

---

### 5. watcher-regina.sh (ESTENSIONE!)

**Path:** `scripts/swarm/watcher-regina.sh` (già esiste - v1.3.0)

**Cosa fare:** Estendere il watcher esistente

**Funzionalità da AGGIUNGERE:**

1. **Check heartbeat periodico**
   - Ogni 2 minuti (120s) run check-stuck.sh
   - Se stuck detected → notifica

2. **Watch .swarm/feedback/**
   - Oltre a .swarm/tasks/*.done
   - Anche .swarm/feedback/*.md (nuovi feedback!)
   - Notifica Regina quando worker crea feedback

3. **Dashboard ASCII (opzionale ma bello!)**
   - Mostra workers attivi
   - Ultimo heartbeat
   - Task in corso
   - Aggiorna ogni 5s
   - Esempio:
   ```
   🐝 CERVELLA SWARM - Worker Status
   =====================================
   
   cervella-backend    [WORKING] TASK_001  (30s ago)
   cervella-frontend   [WORKING] TASK_002  (45s ago)
   cervella-docs       [READY]   -         (1m ago)
   
   📋 Active: 2  |  🐝 Ready: 1  |  ⏸️  Idle: 13
   ```

**Come estendere:**

```bash
# Aggiungere all'inizio
LAST_STUCK_CHECK=0
CHECK_STUCK_INTERVAL=120  # 2 min

# Nel loop principale, dopo fswatch
# Aggiungere check periodico
NOW=$(date +%s)
if [ $((NOW - LAST_STUCK_CHECK)) -gt $CHECK_STUCK_INTERVAL ]; then
  if ! ./check-stuck.sh --notify; then
    # Stuck detected, già notificato da check-stuck.sh
    true
  fi
  LAST_STUCK_CHECK=$NOW
fi

# Aggiungere watching feedback
# fswatch dovrebbe watchare anche .swarm/feedback/
```

**Testing:**
- Test 1: Crea .done → notifica?
- Test 2: Crea feedback → notifica?
- Test 3: Worker non heartbeat 2min → stuck notifica?

---

## SUCCESS CRITERIA

✅ 4 script nuovi creati in `scripts/swarm/`
✅ watcher-regina.sh esteso con nuove funzionalità
✅ Tutti gli script sono:
  - Eseguibili (chmod +x)
  - Commentati (header con usage)
  - Gestiscono edge cases
  - Output chiaro e colorato (green/red/yellow)
✅ Testati manualmente (almeno 1 scenario per script)

---

## NOTE IMPORTANTI

### Bash Best Practices

```bash
#!/bin/bash
set -euo pipefail  # Fail on error, undefined var, pipe fail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Usage function
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "..."
  exit 1
}

# Error handling
error() {
  echo -e "${RED}Error: $1${NC}" >&2
  exit 1
}
```

### Testing

Per ogni script, crea mini test:

```bash
# Test update-status.sh
$ ./update-status.sh WORKING "test note"
# Verifica: cat .swarm/status/[WORKER].status

# Test heartbeat-worker.sh
$ ./heartbeat-worker.sh TASK_TEST &
$ sleep 125  # 2+ heartbeats
$ cat .swarm/status/heartbeat_[WORKER].log
$ kill %1

# Test ask-regina.sh
$ ./ask-regina.sh question "Test?" "Description"
# Verifica: ls .swarm/feedback/

# Test check-stuck.sh
# Simula stuck: non scrivere heartbeat per 3 min
$ ./check-stuck.sh
# Dovrebbe rilevare stuck
```

### Compatibilità

Script devono funzionare su **macOS** (Rafa usa macOS!)

- `date +%s` → OK su macOS
- `osascript` → macOS only (OK!)
- `fswatch` → installato via brew (OK!)

### Riferimenti

**Leggi:**
- `docs/protocolli/PROTOCOLLI_COMUNICAZIONE.md`
  - Sezione 2 (STATUS)
  - Sezione 3 (FEEDBACK)
  - Sezione 5 (WORKFLOW)
- `scripts/swarm/watcher-regina.sh` (esistente v1.3.0)
- `.swarm/templates/` (quando cervella-docs finisce - puoi usare placeholder se non pronti)

---

## OUTPUT RICHIESTO

**Directory:** `scripts/swarm/`

**File da creare:**
1. `update-status.sh` (nuovo)
2. `heartbeat-worker.sh` (nuovo)
3. `ask-regina.sh` (nuovo)
4. `check-stuck.sh` (nuovo)
5. `watcher-regina.sh` (estendere esistente → v1.4.0)

**Tutti eseguibili:**
```bash
chmod +x scripts/swarm/*.sh
```

**Report:**
Crea `.swarm/tasks/TASK_COMUNICAZIONE_FASE4_SCRIPTS_OUTPUT.md`:
- Lista script creati
- Risultati test per ognuno
- Note implementazione
- Known issues (se esistono)

**Quando hai finito:**
1. Verifica che tutti gli script funzionino
2. Crea `.swarm/tasks/TASK_COMUNICAZIONE_FASE4_SCRIPTS.done`
3. Il watcher notificherà la Regina!

---

**Energia positiva!** ❤️‍🔥
**Script robusti!** 🔧
**Per la famiglia!** 🐝👑💙

