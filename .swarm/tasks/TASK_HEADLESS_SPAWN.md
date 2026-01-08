# Task: Aggiungere --headless a spawn-workers

**Assegnato a:** cervella-backend
**Stato:** ready
**Priorità:** ALTA
**Data:** 2026-01-08

## Obiettivo

Aggiungere supporto `--headless` a spawn-workers che usa **tmux** invece di Terminal.app.

## Perché

- "Aprire finestre è anni 80!" (Rafa)
- tmux permette worker in background SENZA finestre visibili
- Context isolato per ogni worker
- Output catturabile con `tmux capture-pane -p -S -`

## File da Modificare

`~/.local/bin/spawn-workers` (versione attuale: 2.9.0)

## Cosa Aggiungere

### 1. Variabile globale (dopo MAX_WORKERS)

```bash
# ============================================================================
# HEADLESS MODE (v3.0.0) - tmux invece di Terminal.app
# ============================================================================
HEADLESS_MODE=false
```

### 2. Parsing argomento (nel case statement)

```bash
--headless)
    HEADLESS_MODE=true
    ;;
--window)
    HEADLESS_MODE=false
    ;;
```

### 3. Nuova funzione spawn_worker_headless()

```bash
spawn_worker_headless() {
    local worker_name="$1"
    local prompt
    prompt=$(get_worker_prompt "$worker_name")

    if [ -z "$prompt" ]; then
        print_error "Worker '$worker_name' non trovato!"
        return 1
    fi

    print_info "Spawning cervella-${worker_name} (headless)..."

    # Salva prompt in file temporaneo
    local prompt_file="${SWARM_DIR}/prompts/worker_${worker_name}.txt"
    mkdir -p "${SWARM_DIR}/prompts"
    printf '%s' "$prompt" > "$prompt_file"

    # Nome sessione tmux univoco
    local session_name="swarm_${worker_name}_$(date +%s)"

    # Trova claude
    local claude_path
    claude_path=$(get_claude_bin)
    if [[ -z "$claude_path" ]]; then
        print_error "Claude CLI non trovato!"
        return 1
    fi

    # Crea directories
    mkdir -p "${SWARM_DIR}/status"
    mkdir -p "${SWARM_DIR}/logs"

    # Prompt iniziale
    local initial_prompt="Controlla .swarm/tasks/ per task .ready assegnati a te e inizia a lavorare. Se non ci sono task, termina dicendo 'Nessun task per me'."

    # Log file
    local log_file="${SWARM_DIR}/logs/worker_${worker_name}_$(date +%Y%m%d_%H%M%S).log"

    # Salva session name per tracking
    echo "$session_name" > "${SWARM_DIR}/status/worker_${worker_name}.session"

    # Salva timestamp start
    date +%s > "${SWARM_DIR}/status/worker_${worker_name}.start"

    # Spawn in tmux detached (NESSUNA FINESTRA!)
    tmux new-session -d -s "$session_name" \
        "cd ${PROJECT_ROOT} && \
         export CERVELLASWARM_WORKER=1 && \
         ${claude_path} -p --append-system-prompt \"\$(cat ${prompt_file})\" \"${initial_prompt}\" 2>&1 | tee \"${log_file}\"; \
         echo 'WORKER_DONE' >> \"${log_file}\""

    # Imposta remain-on-exit per catturare output dopo fine
    tmux set-option -t "$session_name" remain-on-exit on 2>/dev/null

    if tmux has-session -t "$session_name" 2>/dev/null; then
        print_success "cervella-${worker_name} spawned (headless)! Session: ${session_name}"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - SPAWNED (headless): cervella-${worker_name} [${session_name}]" >> "${SWARM_DIR}/logs/spawn.log"
        return 0
    else
        print_error "Errore spawn headless cervella-${worker_name}"
        return 1
    fi
}
```

### 4. Modificare il loop di spawn nel main

Dopo la riga `for worker in $workers_to_spawn; do`:

```bash
for worker in $workers_to_spawn; do
    if [ "$HEADLESS_MODE" = true ]; then
        if spawn_worker_headless "$worker"; then
            spawned=$((spawned + 1))
        else
            failed=$((failed + 1))
        fi
    else
        if spawn_worker "$worker"; then
            spawned=$((spawned + 1))
        else
            failed=$((failed + 1))
        fi
    fi
    # Piccola pausa tra spawn
    sleep 0.5
done
```

### 5. Aggiornare show_usage()

Aggiungere:
```
echo "  --headless             Usa tmux headless (no finestre Terminal)"
echo "  --window               Usa Terminal.app (default)"
```

### 6. Aggiornare header e versione

- Versione: 3.0.0
- CHANGELOG: v3.0.0: HEADLESS MODE! --headless usa tmux invece di Terminal.app. Zero finestre!

## Test da Fare

Dopo le modifiche, testare:

```bash
# Test headless
spawn-workers --headless --backend

# Verifica sessione creata
tmux list-sessions | grep swarm_backend

# Verifica output
tmux capture-pane -t swarm_backend_* -p -S -

# Cleanup
tmux kill-session -t swarm_backend_*
```

## Output

- File modificato: `~/.local/bin/spawn-workers`
- Versione: 3.0.0
- Scrivi conferma in `TASK_HEADLESS_SPAWN_output.md`

---

*Regina - Sessione 122*
