# Task: Ottimizzare load_context.py

**Assegnato a:** cervella-backend
**Stato:** ready
**Priorità:** ALTA
**Data:** 2026-01-08

## Obiettivo

Ridurre il context overhead di load_context.py del **37-59%**.

## Perché

Ogni sessione parte con 19% di context già usato. Ottimizzando questo script possiamo risparmiare tokens preziosi.

## File da Modificare

`~/.claude/scripts/memory/load_context.py` (versione attuale: 2.0.1)

## Modifiche Specifiche

### 1. get_recent_events() - Linea 36

```python
# PRIMA
def get_recent_events(conn: sqlite3.Connection, limit: int = 20) -> list:
    ...
    "task": row[2][:100] if row[2] else "",  # Max 100 char

# DOPO
def get_recent_events(conn: sqlite3.Connection, limit: int = 5) -> list:
    ...
    "task": row[2][:50] if row[2] else "",  # Max 50 char
```

### 2. get_agent_stats() - Linea 75

Modificare per ritornare SOLO top 5 agent per task count:

```python
def get_agent_stats(conn: sqlite3.Connection, limit: int = 5) -> dict:
    """
    Statistiche per agent - TOP N per task count.
    """
    cursor = conn.cursor()

    # Prima trova i top N agent
    cursor.execute("""
        SELECT agent_name, COUNT(*) as total
        FROM swarm_events
        WHERE agent_name IS NOT NULL
        GROUP BY agent_name
        ORDER BY total DESC
        LIMIT ?
    """, (limit,))

    top_agents = [row[0] for row in cursor.fetchall()]

    # Poi recupera statistiche solo per loro
    if not top_agents:
        return {}

    placeholders = ','.join(['?' for _ in top_agents])
    cursor.execute(f"""
        SELECT
            agent_name,
            COUNT(*) as total_tasks,
            SUM(success) as successful_tasks,
            project
        FROM swarm_events
        WHERE agent_name IN ({placeholders})
        GROUP BY agent_name, project
        ORDER BY total_tasks DESC
    """, top_agents)

    stats = {}
    for row in cursor.fetchall():
        agent = row[0]
        if agent not in stats:
            stats[agent] = {
                "total_tasks": 0,
                "successful_tasks": 0,
                "projects": [],
            }

        stats[agent]["total_tasks"] += row[1] or 0
        stats[agent]["successful_tasks"] += row[2] or 0
        if row[3] and row[3] not in stats[agent]["projects"]:
            stats[agent]["projects"].append(row[3])

    return stats
```

### 3. get_lessons_learned() - Linea 138

```python
# PRIMA
LIMIT 10

# DOPO
LIMIT 3
```

### 4. format_context() - Linea 376

```python
# PRIMA
for evt in events[:10]:  # Max 10

# DOPO
for evt in events[:5]:  # Max 5
```

### 5. Aggiornare version

```python
__version__ = "2.1.0"
__version_date__ = "2026-01-08"
# v2.1.0 - Ottimizzazione context: -37% tokens (5 eventi, 50 char, top 5 agent, 3 lezioni)
```

## Test

Dopo le modifiche, esegui:

```bash
python3 ~/.claude/scripts/memory/load_context.py
```

Verifica che l'output sia più compatto (meno righe).

## Output

- File modificato: `~/.claude/scripts/memory/load_context.py`
- Versione: 2.1.0
- Scrivi conferma in `TASK_OPTIMIZE_LOAD_CONTEXT_output.md`

---

*Regina - Sessione 122*
