# TASK: Aggiungere sezione Heartbeat alla Dashboard

**Assegnato a:** cervella-backend
**Priorita:** ALTA
**Stato:** ready

---

## Obiettivo

Aggiornare `scripts/swarm/dashboard.py` per mostrare lo stato live dei worker basandosi sui file heartbeat.

---

## File da Modificare

`/Users/rafapra/Developer/CervellaSwarm/scripts/swarm/dashboard.py`

---

## Cosa Aggiungere

### 1. Nuova funzione `get_live_activity_from_heartbeat()`

```python
def get_live_activity_from_heartbeat() -> List[Dict]:
    """
    Legge heartbeat files e mostra attivita' live dei worker.

    Returns:
        Lista di dict con: worker, timestamp, task, action, is_active
    """
    from pathlib import Path
    import time

    activities = []
    status_dir = Path('.swarm/status')

    if not status_dir.exists():
        return activities

    for hb_file in status_dir.glob('heartbeat_*.log'):
        try:
            content = hb_file.read_text().strip()
            if not content:
                continue

            lines = content.split('\n')
            last_line = lines[-1]
            parts = last_line.split('|')

            if len(parts) >= 3:
                timestamp = int(parts[0])
                task = parts[1]
                action = parts[2]

                age = int(time.time()) - timestamp
                is_active = age < 120  # Active se heartbeat < 2 minuti

                activities.append({
                    'worker': hb_file.stem.replace('heartbeat_', ''),
                    'timestamp': timestamp,
                    'task': task,
                    'action': action,
                    'age': age,
                    'is_active': is_active
                })
        except Exception:
            continue

    return activities
```

### 2. Nuova funzione `render_heartbeat()`

```python
def render_heartbeat() -> str:
    """Renderizza la sezione heartbeat live."""
    lines = []

    lines.append("║                                                                                      ║")
    lines.append("║  " + colorize("LIVE HEARTBEAT", Colors.BOLD) + "                                                                      ║")

    activities = get_live_activity_from_heartbeat()

    if not activities:
        lines.append("║  " + colorize("Nessun heartbeat - i worker non hanno ancora scritto", Colors.DIM) + "                          ║")
    else:
        for activity in activities:
            worker = activity['worker'][:12]
            action = activity['action'][:40] if activity['action'] else '-'
            age = activity['age']

            # Formatta age
            if age < 60:
                age_str = f"{age}s"
            else:
                age_str = f"{age // 60}m"

            # Status con colore
            if activity['is_active']:
                status = colorize("ACTIVE", Colors.BRIGHT_GREEN)
            else:
                status = colorize("STALE ", Colors.BRIGHT_YELLOW)

            # Padding
            worker_pad = 12 - len(worker)
            age_pad = 5 - len(age_str)
            action_pad = 40 - len(action)

            line = f"║  {worker}{' ' * worker_pad} {status} ({age_str}{' ' * age_pad}) {action}{' ' * action_pad}   ║"
            lines.append(line)

    return '\n'.join(lines)
```

### 3. Aggiungere render_heartbeat() a render_dashboard()

Nella funzione `render_dashboard()`, aggiungere `render_heartbeat()` alla lista sections DOPO render_stats e PRIMA di render_activity:

```python
def render_dashboard(tasks: List[Dict]) -> str:
    sections = [
        render_header(),
        render_workers(tasks),
        render_stats(tasks),
        render_heartbeat(),      # <-- AGGIUNGERE QUI
        render_activity(tasks),
        render_footer()
    ]
    return '\n'.join(sections)
```

### 4. Aggiornare versione

Cambiare in alto:
```python
__version__ = "1.1.0"
__version_date__ = "2026-01-05"
```

---

## Verifica

- [ ] Funzione get_live_activity_from_heartbeat() aggiunta
- [ ] Funzione render_heartbeat() aggiunta
- [ ] render_dashboard() include render_heartbeat()
- [ ] Versione aggiornata a 1.1.0
- [ ] Nessun errore di sintassi Python

---

## Output

Scrivi conferma in:
`.swarm/tasks/TASK_DASHBOARD_HEARTBEAT_output.md`
