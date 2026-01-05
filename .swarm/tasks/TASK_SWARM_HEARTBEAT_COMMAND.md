# TASK: Creare comando swarm-heartbeat

**Assegnato a:** cervella-backend
**Priorita:** ALTA
**Stato:** ready

---

## Obiettivo

Creare nuovo comando `~/.local/bin/swarm-heartbeat` che mostra lo stato live dei worker basandosi sui file heartbeat.

---

## File da Creare

`~/.local/bin/swarm-heartbeat`

---

## Specifiche

### Comportamento

1. Legge tutti i file `.swarm/status/heartbeat_*.log`
2. Per ogni file, estrae l'ultima riga
3. Calcola quanto tempo fa e' stato scritto
4. Mostra stato: ACTIVE se < 120s, STALE altrimenti

### Output Atteso

```
$ swarm-heartbeat
[backend]  ACTIVE (15s ago) - Analizzando file X
[frontend] ACTIVE (8s ago)  - Creando componente Y
[tester]   STALE  (5m ago)  - Ultimo task completato
```

Se nessun heartbeat:
```
$ swarm-heartbeat
Nessun heartbeat trovato. I worker non hanno ancora scritto.
```

### Codice Base

```bash
#!/bin/bash
# swarm-heartbeat - Mostra stato live dei worker
# CervellaSwarm v1.0.0
#
# Uso: swarm-heartbeat
#      swarm-heartbeat --watch  (refresh ogni 2s)

set -e

# Trova project root
find_project_root() {
    local dir="$(pwd)"
    for i in {1..5}; do
        if [ -d "${dir}/.swarm" ]; then
            echo "${dir}"
            return 0
        fi
        [ "$dir" = "/" ] && break
        dir="$(dirname "$dir")"
    done
    echo "$(pwd)"
}

PROJECT_ROOT="$(find_project_root)"
SWARM_DIR="${PROJECT_ROOT}/.swarm"
STATUS_DIR="${SWARM_DIR}/status"

# Colori
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

show_heartbeats() {
    local found=0

    for hb in "${STATUS_DIR}"/heartbeat_*.log 2>/dev/null; do
        [ -f "$hb" ] || continue
        found=1

        worker=$(basename "$hb" .log | sed 's/heartbeat_//')
        last_line=$(tail -1 "$hb" 2>/dev/null)

        if [ -n "$last_line" ]; then
            timestamp=$(echo "$last_line" | cut -d'|' -f1)
            task=$(echo "$last_line" | cut -d'|' -f2)
            action=$(echo "$last_line" | cut -d'|' -f3)

            now=$(date +%s)
            age=$((now - timestamp))

            if [ $age -lt 120 ]; then
                printf "${GREEN}[%s]${NC} ACTIVE (%ds ago) - %s\n" "$worker" "$age" "$action"
            else
                # Converti in minuti se > 60s
                if [ $age -gt 60 ]; then
                    age_display="$((age / 60))m"
                else
                    age_display="${age}s"
                fi
                printf "${YELLOW}[%s]${NC} STALE  (%s ago) - %s\n" "$worker" "$age_display" "$action"
            fi
        fi
    done

    if [ $found -eq 0 ]; then
        echo "Nessun heartbeat trovato. I worker non hanno ancora scritto."
    fi
}

# Watch mode
if [ "$1" = "--watch" ]; then
    echo "swarm-heartbeat --watch (Ctrl+C per uscire)"
    echo ""
    while true; do
        clear
        echo "=== SWARM HEARTBEAT $(date +%H:%M:%S) ==="
        echo ""
        show_heartbeats
        sleep 2
    done
else
    show_heartbeats
fi
```

---

## Verifica

- [ ] Script creato in ~/.local/bin/swarm-heartbeat
- [ ] Permessi eseguibili (chmod +x)
- [ ] Funziona da qualsiasi progetto con .swarm/
- [ ] Modalita --watch funziona
- [ ] Colori corretti (ACTIVE verde, STALE giallo)

---

## Output

Scrivi conferma in:
`.swarm/tasks/TASK_SWARM_HEARTBEAT_COMMAND_output.md`
