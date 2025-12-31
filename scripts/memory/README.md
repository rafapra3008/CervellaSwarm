# 🐝 CervellaSwarm - Sistema Memoria

Sistema di memoria persistente per tracciare attività degli agenti CervellaSwarm.

**Versione:** 1.0.0
**Data:** 2026-01-01

---

## 📋 OVERVIEW

Questo sistema traccia:
- Eventi degli agenti (task start/complete/fail)
- Performance e statistiche
- Lezioni apprese dal team
- Pattern di lavoro

**Database:** SQLite con WAL mode (performance ottimizzate)
**Path:** `data/swarm_memory.db`

---

## 🚀 SETUP

### 1. Inizializzazione

```bash
# Crea database e schema
./scripts/memory/init_db.py
```

Output:
```
✅ Database inizializzato: /path/to/swarm_memory.db
✅ Tabelle create: swarm_events, lessons_learned
✅ Indici creati: 7 totali
✅ WAL mode: attivo
```

### 2. Verifica

```bash
# Controlla statistiche (database vuoto)
./scripts/memory/query_events.py --stats
```

---

## 📊 SCRIPT DISPONIBILI

### init_db.py

Inizializza database con schema completo.

**Uso:**
```bash
./scripts/memory/init_db.py
```

**Schema creato:**
- Tabella `swarm_events` (eventi agenti)
- Tabella `lessons_learned` (lezioni apprese)
- 7 indici per query ottimizzate

---

### log_event.py

Logga evento nel database (chiamato da hook PostToolUse).

**Input:** JSON da stdin (payload hook)

**Output:** JSON con status

**Esempio:**
```bash
echo '{
  "tool": {"name": "cervella-frontend", "input": {"task": "Fix bug"}},
  "result": {"file_path": "/path/to/file.js"},
  "context": {"cwd": "/project", "session_id": "abc123"}
}' | ./scripts/memory/log_event.py
```

**Gestione errori:**
- Exit 0 SEMPRE (non blocca workflow anche in caso di errore)
- Skip silenzioso se database non esiste
- Skip silenzioso se non è agent swarm

---

### load_context.py

Carica contesto per SessionStart hook.

**Output:** JSON con `hookSpecificOutput.additionalContext`

**Uso:**
```bash
./scripts/memory/load_context.py
```

**Include:**
- Ultimi 10 eventi
- Statistiche per agent
- Lezioni apprese (confidence > 70%)

---

### query_events.py

Script utility per interrogare il database.

**Opzioni:**

```bash
# Ultimi N eventi
./scripts/memory/query_events.py --recent 50

# Eventi per agent specifico
./scripts/memory/query_events.py --agent cervella-frontend

# Eventi per progetto
./scripts/memory/query_events.py --project miracollo

# Task falliti
./scripts/memory/query_events.py --failed

# Statistiche generali
./scripts/memory/query_events.py --stats

# Formato output (json o table)
./scripts/memory/query_events.py --stats --format table
```

---

## 📦 SCHEMA DATABASE

### Tabella: swarm_events

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| id | TEXT | UUID evento |
| timestamp | TEXT | ISO8601 |
| session_id | TEXT | ID sessione Claude |
| event_type | TEXT | task_start, task_complete, task_failed |
| agent_name | TEXT | cervella-frontend, backend, etc. |
| agent_role | TEXT | Ruolo agent |
| task_id | TEXT | UUID task |
| parent_task_id | TEXT | Per task annidati |
| task_description | TEXT | Descrizione task |
| task_status | TEXT | started, completed, failed |
| duration_ms | INTEGER | Tempo esecuzione |
| success | INTEGER | 1/0 |
| error_message | TEXT | Messaggio errore |
| project | TEXT | miracollo, contabilita, etc. |
| files_modified | TEXT | JSON array file |
| tags | TEXT | JSON array tag |
| notes | TEXT | Note libere |
| created_at | TEXT | Timestamp creazione |

**Indici:**
- idx_events_timestamp
- idx_events_agent
- idx_events_project
- idx_events_task_status
- idx_events_session

---

### Tabella: lessons_learned

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| id | TEXT | UUID |
| timestamp | TEXT | ISO8601 |
| context | TEXT | Contesto problema |
| problem | TEXT | Problema riscontrato |
| solution | TEXT | Soluzione trovata |
| pattern | TEXT | Pattern identificato |
| agents_involved | TEXT | JSON array agenti |
| confidence | REAL | 0-1 |
| times_applied | INTEGER | Volte applicata |
| created_at | TEXT | Timestamp creazione |

**Indici:**
- idx_lessons_confidence
- idx_lessons_pattern

---

## 🔗 INTEGRAZIONE CON HOOK

### PostToolUse Hook

```json
{
  "hookName": "PostToolUse",
  "executable": "./scripts/memory/log_event.py"
}
```

**Comportamento:**
- Riceve payload hook via stdin
- Logga evento se è agent swarm
- Skip silenzioso altrimenti
- Exit 0 SEMPRE (non blocca workflow)

---

### SessionStart Hook

```json
{
  "hookName": "SessionStart",
  "executable": "./scripts/memory/load_context.py"
}
```

**Comportamento:**
- Carica contesto memoria
- Output JSON con additionalContext
- Include ultimi eventi + statistiche + lezioni

---

## 📊 ESEMPI

### Verificare Attività Agent

```bash
# Tutti gli eventi di cervella-frontend
./scripts/memory/query_events.py --agent cervella-frontend

# Ultimi 100 eventi
./scripts/memory/query_events.py --recent 100

# Eventi solo progetto Miracollo
./scripts/memory/query_events.py --project miracollo
```

### Analizzare Performance

```bash
# Statistiche generali
./scripts/memory/query_events.py --stats

# Task falliti
./scripts/memory/query_events.py --failed
```

### Debug

```bash
# Output tabella (più leggibile)
./scripts/memory/query_events.py --recent 10 --format table
```

---

## 🛠️ MANUTENZIONE

### Backup Database

```bash
# Copia database
cp data/swarm_memory.db data/swarm_memory.db.backup
```

### Reset Database

```bash
# Elimina e ricrea
rm data/swarm_memory.db
./scripts/memory/init_db.py
```

### Ottimizzazione

```bash
# SQLite VACUUM (compatta database)
sqlite3 data/swarm_memory.db "VACUUM;"
```

---

## ⚠️ NOTE IMPORTANTI

1. **Gestione Errori:**
   - Tutti gli script gestiscono errori gracefully
   - Exit 0 anche in caso di errore (non bloccare workflow)
   - Log errori su stderr

2. **Performance:**
   - WAL mode per scritture concorrenti
   - Indici su campi più usati
   - Database separato (non interferisce con progetti)

3. **Privacy:**
   - Task description limitata a 200 char
   - Solo path file (non contenuto)
   - Session ID opzionale

---

## 🎯 ROADMAP FUTURA

- [ ] Web UI per visualizzare statistiche
- [ ] Grafici performance agenti
- [ ] Machine learning per suggerimenti
- [ ] Export report PDF
- [ ] Integrazione Telegram notifiche

---

**Creato:** 2026-01-01
**Parte di:** CervellaSwarm v1.0.0

💙🐝 *Cervella Backend - Specialista Database & API*
