# Studio: Come Monitorare i Worker e Cosa Fare Mentre Lavorano

> **Data:** 5 Gennaio 2026
> **Autore:** cervella-researcher
> **Task ID:** TASK_20260105_042827_studio_come_monitorare_i

---

## Indice

1. [Strumenti di Monitoraggio Esistenti](#1-strumenti-di-monitoraggio-esistenti)
2. [Come Usare il Dashboard](#2-come-usare-il-dashboard)
3. [Cosa Fare Mentre i Worker Lavorano](#3-cosa-fare-mentre-i-worker-lavorano)
4. [Pattern Consigliati](#4-pattern-consigliati)
5. [Comandi Rapidi](#5-comandi-rapidi)

---

## 1. Strumenti di Monitoraggio Esistenti

Lo swarm CervellaSwarm ha **4 strumenti** di monitoraggio gia pronti:

### 1.1 Dashboard Python (CONSIGLIATO!)

```bash
# Visualizzazione singola
python3 scripts/swarm/dashboard.py

# Monitoring LIVE (refresh ogni 2 secondi)
python3 scripts/swarm/dashboard.py --watch

# Output JSON (per script/automazioni)
python3 scripts/swarm/dashboard.py --json
```

**Cosa mostra:**
- Stato di tutti i 16 worker (ACTIVE/READY/IDLE)
- Task corrente per ogni worker
- Statistiche task queue (pending, in progress, completed)
- Ultimi 5 eventi (con timestamp)

### 1.2 Monitor Status (script bash)

```bash
./scripts/swarm/monitor-status.sh
```

**Cosa mostra:**
- Lista semplice di tutti i task con stato emoji
- DONE, ERROR, WORKING, READY, CREATED

### 1.3 Task Manager (script Python)

```bash
# Lista tutti i task
python3 scripts/swarm/task_manager.py list

# Status singolo task
python3 scripts/swarm/task_manager.py status TASK_ID
```

**Output esempio:**
```
TASK_ID      STATUS     ACK     AGENT                     FILE
TASK_001     working    -/-/-   cervella-backend         .swarm/tasks/TASK_001.md
TASK_002     ready      ✓/-/-   cervella-frontend        .swarm/tasks/TASK_002.md
```

### 1.4 Log Files

```bash
# Spawn log (chi e stato spawnato quando)
cat .swarm/logs/spawn.log

# Log worker specifico (output completo della sessione)
cat .swarm/logs/worker_YYYYMMDD_HHMMSS.log

# Ultimi log
ls -lt .swarm/logs/*.log | head -5
```

---

## 2. Come Usare il Dashboard

### Setup Consigliato

Apri **3 finestre Terminal**:

```
+-----------------------+------------------------+
|                       |                        |
|   FINESTRA 1          |    FINESTRA 2          |
|   Regina Claude Code  |    Dashboard Watch     |
|                       |                        |
|   $ claude            |    $ python3 ...       |
|                       |      dashboard.py      |
|                       |      --watch           |
|                       |                        |
+-----------------------+------------------------+
|                                                |
|   FINESTRA 3+: Worker spawnati                 |
|   (si aprono automaticamente con spawn-workers)|
|                                                |
+------------------------------------------------+
```

### Interpretare il Dashboard

```
╔══════════════════════════════════════════════════════════════════╗
║                   CERVELLASWARM DASHBOARD                        ║
╠══════════════════════════════════════════════════════════════════╣
║  WORKERS STATUS                                                  ║
║  ┌──────────────────────┬──────────┬─────────────────────────┐   ║
║  │ Worker               │ Status   │ Current Task            │   ║
║  ├──────────────────────┼──────────┼─────────────────────────┤   ║
║  │ backend              │ ● ACTIVE │ TASK_001: Create API... │   ║  ← LAVORANDO
║  │ frontend             │ ◐ READY  │ 2 task pending          │   ║  ← HA TASK, NON INIZIATO
║  │ tester               │ ○ IDLE   │ -                       │   ║  ← NIENTE DA FARE
║  └──────────────────────┴──────────┴─────────────────────────┘   ║
╚══════════════════════════════════════════════════════════════════╝
```

**Legenda:**
- `● ACTIVE` (verde): Worker sta lavorando su un task
- `◐ READY` (giallo): Ha task assegnati ma non li ha ancora presi
- `○ IDLE` (grigio): Nessun task assegnato

---

## 3. Cosa Fare Mentre i Worker Lavorano

### 3.1 Attivita Utili per la Regina

| Attivita | Descrizione | Quando Farla |
|----------|-------------|--------------|
| **Monitorare dashboard** | Guardare lo stato dei worker | Ogni 1-2 minuti |
| **Preparare task successivi** | Scrivere .md dei prossimi task | Se pipeline lunga |
| **Aggiornare documentazione** | NORD.md, PROMPT_RIPRESA.md | Se tempo |
| **Pianificare** | Ragionare sui prossimi step | Sempre utile |
| **Review output completati** | Leggere *_output.md dei task .done | Appena disponibili |
| **Rispondere a Rafa** | Tenere informato | Se ci sono domande |

### 3.2 Cosa NON Fare

```
+------------------------------------------------------------------+
|                                                                  |
|   ❌ NON fare edit su file che i worker stanno modificando       |
|   ❌ NON spawnare lo stesso worker due volte                     |
|   ❌ NON modificare task .working                                |
|   ❌ NON fare il lavoro dei worker (la Regina delega!)           |
|                                                                  |
+------------------------------------------------------------------+
```

### 3.3 Workflow Consigliato

```
1. Spawna worker necessari
   $ spawn-workers --backend --frontend

2. Apri dashboard in watch mode (altra finestra)
   $ python3 scripts/swarm/dashboard.py --watch

3. Mentre aspetti:
   - Prepara task successivi
   - Controlla output dei task completati
   - Aggiorna PROMPT_RIPRESA.md con progressi

4. Quando vedi task .done:
   - Leggi l'output: cat .swarm/tasks/TASK_XXX_output.md
   - Verifica: il risultato e' corretto?
   - Se OK: procedi con task successivi
   - Se NON OK: crea task di fix

5. Ripeti
```

---

## 4. Pattern Consigliati

### Pattern A: Pipeline Sequenziale

```
Regina crea:
- TASK_001 backend (ready)
- TASK_002 frontend (ready)  # Dipende da 001
- TASK_003 tester (ready)    # Dipende da 002

Spawn:
$ spawn-workers --backend

Quando TASK_001 .done:
$ spawn-workers --frontend

Quando TASK_002 .done:
$ spawn-workers --tester
```

### Pattern B: Lavoro Parallelo

```
Regina crea:
- TASK_BACKEND_001 (ready)
- TASK_FRONTEND_001 (ready)
- TASK_DOCS_001 (ready)

Spawn tutti insieme:
$ spawn-workers --all
# Oppure:
$ spawn-workers --backend --frontend --docs

Monitorare con dashboard finche tutti .done
```

### Pattern C: Con Guardiana

```
1. Worker completa task (TASK_001.done)

2. Regina crea task review:
   TASK_001_REVIEW per guardiana-qualita

3. Spawn guardiana:
   $ spawn-workers --guardiana-qualita

4. Guardiana verifica e scrive report

5. Se OK: merge
   Se NON OK: crea TASK_001_FIX per worker
```

---

## 5. Comandi Rapidi

### Cheat Sheet

```bash
# === MONITORAGGIO ===
python3 scripts/swarm/dashboard.py --watch   # Dashboard live
./scripts/swarm/monitor-status.sh            # Status rapido
python3 scripts/swarm/task_manager.py list   # Lista task

# === SPAWN WORKER ===
spawn-workers --backend                      # Solo backend
spawn-workers --frontend                     # Solo frontend
spawn-workers --tester                       # Solo tester
spawn-workers --all                          # backend+frontend+tester
spawn-workers --guardiana-qualita            # Guardiana Qualita
spawn-workers --list                         # Vedi tutti disponibili

# === LOGS ===
tail -f .swarm/logs/spawn.log               # Chi e' stato spawnato
ls -lt .swarm/logs/worker_*.log | head -5    # Ultimi log

# === TASK STATUS ===
ls .swarm/tasks/*.ready                      # Task pronti
ls .swarm/tasks/*.working                    # Task in lavorazione
ls .swarm/tasks/*.done                       # Task completati

# === OUTPUT ===
cat .swarm/tasks/TASK_XXX_output.md          # Leggi output specifico
```

### Alias Utili (da aggiungere a ~/.zshrc)

```bash
alias swarm-dash='python3 scripts/swarm/dashboard.py --watch'
alias swarm-status='./scripts/swarm/monitor-status.sh'
alias swarm-tasks='python3 scripts/swarm/task_manager.py list'
alias swarm-ready='ls .swarm/tasks/*.ready 2>/dev/null || echo "Nessun task ready"'
alias swarm-working='ls .swarm/tasks/*.working 2>/dev/null || echo "Nessun task in lavorazione"'
alias swarm-done='ls .swarm/tasks/*.done 2>/dev/null || echo "Nessun task completato"'
```

---

## Riepilogo

```
+------------------------------------------------------------------+
|                                                                  |
|   REGOLE D'ORO DEL MONITORAGGIO                                  |
|                                                                  |
|   1. USA IL DASHBOARD in watch mode mentre aspetti               |
|   2. NON INTERROMPERE i worker                                   |
|   3. PREPARA il lavoro successivo mentre aspetti                 |
|   4. LEGGI gli output appena sono .done                          |
|   5. La Regina COORDINA, non fa il lavoro!                       |
|                                                                  |
+------------------------------------------------------------------+
```

---

## Checklist Verifica

- [x] Strumenti di monitoraggio documentati
- [x] Uso dashboard spiegato
- [x] Attivita della Regina mentre aspetta
- [x] Pattern consigliati
- [x] Comandi rapidi pronti

---

*Studio completato da cervella-researcher*
*5 Gennaio 2026*
