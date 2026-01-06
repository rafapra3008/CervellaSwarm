# STUDIO: Architettura Multi-Progetto CervellaSwarm

**Data:** 6 Gennaio 2026
**Autore:** cervella-ingegnera
**Stato:** Completato

---

## EXECUTIVE SUMMARY

Questo studio analizza come rendere il lavoro multi-progetto di CervellaSwarm un sistema ORCHESTRATO invece che una coincidenza. Proponiamo 4 opzioni architetturali con pro/contro, e identifichiamo un Quick Win implementabile in 1-2 ore.

---

## 1. ANALISI STATO ATTUALE

### 1.1 Cosa Funziona Oggi

```
ARCHITETTURA CORRENTE:
+------------------+     +------------------+     +------------------+
|  CervellaSwarm   |     |    Miracollo     |     |   Contabilita    |
|  .swarm/tasks/   |     |  .swarm/tasks/   |     |  .swarm/tasks/   |
|  .swarm/status/  |     |  .swarm/status/  |     |  .swarm/status/  |
|  .swarm/logs/    |     |  .swarm/logs/    |     |  .swarm/logs/    |
+--------+---------+     +--------+---------+     +--------+---------+
         |                        |                        |
         v                        v                        v
   spawn-workers            spawn-workers            spawn-workers
   (dal progetto)           (dal progetto)           (dal progetto)
```

**Componenti Esistenti:**

| Componente | Path | Funzione |
|------------|------|----------|
| `spawn-workers` | `~/.local/bin/` | Spawna worker per progetto corrente |
| `watcher-regina.sh` | `~/.claude/scripts/` | Notifica quando worker finiscono |
| `~/.swarm/config` | Globale | Lista progetti + configurazione |
| `~/.swarm/projects.txt` | Globale | Lista path progetti |
| `swarm-roadmaps` | `~/.local/bin/` | Vista aggregata NORD.md/ROADMAP |
| `swarm-status` | `~/.local/bin/` | Stato task (singolo progetto) |
| `swarm-progress` | `~/.local/bin/` | Progresso worker |

### 1.2 Come Funziona spawn-workers

```bash
# Logica semplificata:
1. Trova PROJECT_ROOT (cerca .swarm/ nella directory corrente o superiori)
2. Legge prompt dal progetto: .swarm/prompts/worker_NAME.txt
3. Apre nuova finestra Terminal
4. Lancia Claude CLI con prompt specifico
5. Worker cerca task in .swarm/tasks/ del SUO progetto
```

**Punto Critico:** spawn-workers e PROJECT-AWARE (v1.9.0) ma lavora SOLO nel progetto corrente.

### 1.3 Limiti Attuali

| Limite | Descrizione | Impatto |
|--------|-------------|---------|
| **Isolamento completo** | Ogni Regina vede SOLO il suo progetto | Nessuna vista globale |
| **Duplicazione worker** | Posso spawnare 2x backend (uno per progetto) | Spreco risorse |
| **Nessun coordinamento** | Se worker A su Miracollo finisce, CervellaSwarm non lo sa | Opportunita perse |
| **Status separati** | devo aprire 3 terminali per vedere 3 progetti | UX povera |
| **Priorita non gestite** | Non posso dire "prima Miracollo, poi CervellaSwarm" | Caos |
| **MAX_WORKERS globale assente** | Limite e per singola chiamata spawn-workers | Sovraccarico possibile |

### 1.4 Cosa si Romperebbe con Multi-Progetto Naive

Se semplicemente lanciassimo worker su progetti diversi:

```
RISCHI:
1. 10 worker contemporanei = macchina lenta
2. Watcher notifica solo il progetto corrente
3. Regina A non sa che Regina B ha bisogno di aiuto
4. Nessuna prioritizzazione tra progetti
5. Log sparpagliati in 3 posti diversi
```

---

## 2. OPZIONI ARCHITETTURALI

### OPZIONE A: Vista Globale (Solo Monitoraggio)

```
                    +--------------------+
                    | swarm-global-status|
                    |   (legge tutti i   |
                    |    .swarm/)        |
                    +--------------------+
                             |
         +-------------------+-------------------+
         v                   v                   v
   CervellaSwarm        Miracollo          Contabilita
```

**Implementazione:**
- Nuovo script `swarm-global-status` che itera su `~/.swarm/projects.txt`
- Legge `.swarm/tasks/` e `.swarm/status/` di ogni progetto
- Mostra dashboard aggregata

**Pro:**
- Semplicissimo da implementare (2 ore)
- Non cambia nulla dell'architettura esistente
- Zero rischio di regressioni
- Estende swarm-roadmaps gia esistente

**Contro:**
- Solo lettura, nessun coordinamento attivo
- Le Regine restano isolate
- Non risolve duplicazione worker

**Complessita:** Bassa

---

### OPZIONE B: Coordinatore Centrale

```
                    +------------------------+
                    |   SWARM COORDINATOR    |
                    |   (demone sempre attivo)|
                    |   - Pool worker globale |
                    |   - Priorita progetti   |
                    |   - Load balancing      |
                    +------------------------+
                             |
         +-------------------+-------------------+
         v                   v                   v
   CervellaSwarm        Miracollo          Contabilita
   (invia task)         (invia task)       (invia task)
```

**Implementazione:**
- Demone Python che gira sempre
- Tutte le Regine inviano task al coordinatore
- Coordinatore decide chi spawna cosa e quando
- Worker pool condiviso tra progetti

**Pro:**
- Massimo controllo e ottimizzazione
- Prioritizzazione intelligente
- Un solo punto di verita

**Contro:**
- Complessita alta (1-2 settimane)
- Nuovo punto di failure
- Richiede refactoring spawn-workers
- Le Regine perdono autonomia

**Complessita:** Alta

---

### OPZIONE C: Regine P2P (Comunicazione Diretta)

```
   +-------------+     messaggio     +-------------+
   | Regina      |<----------------->| Regina      |
   | CervellaSwarm|                  | Miracollo   |
   +-------------+                   +-------------+
         ^                                 ^
         |          +-------------+        |
         +--------->| Regina      |<-------+
                    | Contabilita |
                    +-------------+
```

**Implementazione:**
- Ogni Regina puo leggere .swarm/ degli altri progetti
- File condiviso `~/.swarm/broadcast.txt` per messaggi
- Watcher globale che notifica TUTTE le Regine

**Pro:**
- Decentralizzato (nessun single point of failure)
- Ogni Regina resta autonoma
- Comunicazione leggera

**Contro:**
- Sincronizzazione complessa
- Race condition possibili
- Chi decide in caso di conflitto?

**Complessita:** Media-Alta

---

### OPZIONE D: Ibrida (Vista + Pool Soft)

```
                    +------------------------+
                    | swarm-global-status    |
                    | swarm-global-spawn     |
                    +------------------------+
                             |
         +-------------------+-------------------+
         |                   |                   |
   CervellaSwarm        Miracollo          Contabilita
   .swarm/tasks/       .swarm/tasks/       .swarm/tasks/
```

**Implementazione:**
1. `swarm-global-status`: Vista aggregata (OPZIONE A)
2. `swarm-global-spawn`: Spawna worker specificando progetto
3. MAX_WORKERS_GLOBAL in ~/.swarm/config
4. Watcher globale opzionale

**Pro:**
- Incrementale (posso fare un pezzo alla volta)
- Mantiene autonomia Regine
- Aggiunge controllo quando serve
- Basso rischio

**Contro:**
- Non e vera coordinazione
- Le priorita sono manuali

**Complessita:** Media

---

## 3. CONFRONTO OPZIONI

| Criterio | A (Vista) | B (Coord.) | C (P2P) | D (Ibrida) |
|----------|-----------|------------|---------|------------|
| Complessita | 2 ore | 2 settimane | 1 settimana | 3-4 ore |
| Rischio | Nullo | Alto | Medio | Basso |
| Visibilita | SI | SI | SI | SI |
| Coordinamento | NO | SI (max) | SI (parziale) | Manuale |
| Prioritizzazione | NO | SI | Possibile | Manuale |
| Pool Worker | NO | SI | NO | Soft |
| Autonomia Regina | 100% | 0% | 80% | 95% |
| Estendibilita | Alta | Media | Media | Alta |

---

## 4. RACCOMANDAZIONE

### Approccio Consigliato: OPZIONE D (Ibrida) in Fasi

**Fase 1 - Quick Win (2 ore):**
- Implementare `swarm-global-status`
- Estendere `~/.swarm/config` con MAX_WORKERS_GLOBAL

**Fase 2 - Controllo (4 ore):**
- `swarm-global-spawn --project miracollo --backend`
- Check MAX_WORKERS_GLOBAL prima di spawn

**Fase 3 - Watcher Globale (2 ore):**
- watcher che monitora TUTTI i `.swarm/tasks/`
- Notifica unica aggregata

**Fase 4 (Opzionale) - Smart Coordination:**
- Solo se Fase 1-3 non bastano
- Valutare OPZIONE B o C

---

## 5. QUICK WIN: swarm-global-status

### Proposta Concreta

```bash
#!/bin/bash
# swarm-global-status - Vista aggregata multi-progetto

# Legge ~/.swarm/projects.txt
# Per ogni progetto:
#   - Conta task .ready, .working, .done
#   - Mostra worker attivi (da .swarm/status/)
#   - Mostra ultimo heartbeat

# Output esempio:
#
# === SWARM GLOBAL STATUS ===
#
# CervellaSwarm (3 task ready, 2 worker attivi)
#   - backend: TASK_123 (working 5m)
#   - researcher: TASK_456 (working 2m)
#
# Miracollo (1 task ready, 0 worker attivi)
#   - (nessun worker)
#
# Contabilita (0 task, 0 worker)
#   - (progetto idle)
#
# TOTALE: 4 task ready, 2 worker attivi
# MAX_WORKERS_GLOBAL: 5 (disponibili: 3)
```

### Pseudocodice

```python
# swarm-global-status.py

import os
import json
from pathlib import Path

def load_projects():
    """Legge ~/.swarm/projects.txt"""
    projects_file = Path.home() / ".swarm" / "projects.txt"
    projects = []
    for line in projects_file.read_text().splitlines():
        line = line.strip()
        if line and not line.startswith("#"):
            projects.append(line)
    return projects

def get_project_status(project_path):
    """Ritorna status di un singolo progetto"""
    swarm_dir = Path(project_path) / ".swarm"

    # Conta task per stato
    tasks_dir = swarm_dir / "tasks"
    ready = len(list(tasks_dir.glob("*.ready")))
    working = len(list(tasks_dir.glob("*.working")))
    done = len(list(tasks_dir.glob("*.done")))

    # Worker attivi
    status_dir = swarm_dir / "status"
    workers = []
    for pid_file in status_dir.glob("worker_*.pid"):
        worker_name = pid_file.stem.replace("worker_", "")
        # Verifica se processo ancora vivo
        pid = int(pid_file.read_text().strip())
        if is_process_alive(pid):
            workers.append(worker_name)

    return {
        "name": Path(project_path).name,
        "ready": ready,
        "working": working,
        "done": done,
        "workers": workers
    }

def main():
    projects = load_projects()
    total_ready = 0
    total_workers = 0

    for project in projects:
        status = get_project_status(project)
        print(f"\n{status['name']} ({status['ready']} ready)")
        for w in status['workers']:
            print(f"  - {w}: working")

        total_ready += status['ready']
        total_workers += len(status['workers'])

    print(f"\nTOTALE: {total_ready} task ready, {total_workers} worker attivi")
```

---

## 6. RISCHI E MITIGAZIONI

| Rischio | Probabilita | Impatto | Mitigazione |
|---------|-------------|---------|-------------|
| Race condition su file .swarm | Bassa | Medio | Lock file per scritture |
| Troppi worker (sovraccarico) | Media | Alto | MAX_WORKERS_GLOBAL |
| Notifiche duplicate | Media | Basso | Dedup in watcher |
| Path non esistenti | Bassa | Basso | Validate in load_projects() |
| Watcher che crasha | Bassa | Medio | Auto-restart con launchd |

---

## 7. PROSSIMI PASSI

1. **Immediato (Quick Win):**
   - Creare `swarm-global-status`
   - Testare con 3 progetti

2. **Settimana prossima:**
   - `swarm-global-spawn` con check globale
   - MAX_WORKERS_GLOBAL in config

3. **Futuro (se serve):**
   - Watcher globale
   - Valutare coordinamento avanzato

---

## 8. CONCLUSIONI

Il sistema attuale funziona per COINCIDENZA perche:
- Ogni progetto e isolato
- Non c'e vista globale
- Nessun coordinamento risorse

La soluzione raccomandata e l'OPZIONE D (Ibrida) implementata in fasi:
1. Prima visibilita (swarm-global-status)
2. Poi controllo soft (MAX_WORKERS_GLOBAL)
3. Infine coordinamento se necessario

**"MAI FRETTA! SEMPRE ORGANIZZAZIONE!"** - Questo vale anche per l'architettura.

---

*Studio completato da cervella-ingegnera*
*"Ultrapassar os proprios limites!"*
