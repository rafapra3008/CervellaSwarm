# Output: TASK_HEADLESS_SPAWN

**Worker:** cervella-backend
**Data:** 2026-01-08
**Stato:** COMPLETATO

## Modifiche Effettuate

### File Modificato
`~/.local/bin/spawn-workers`

### Versione
**2.9.0 -> 3.0.0**

### Changelog Entry
```
v3.0.0: HEADLESS MODE! --headless usa tmux invece di Terminal.app. Zero finestre!
```

## Dettaglio Modifiche

### 1. Variabile HEADLESS_MODE (linea 54-56)
```bash
# ============================================================================
# HEADLESS MODE (v3.0.0) - tmux invece di Terminal.app
# ============================================================================
HEADLESS_MODE=false
```

### 2. Parsing Argomenti (linea 768-772)
```bash
--headless)
    HEADLESS_MODE=true
    ;;
--window)
    HEADLESS_MODE=false
    ;;
```

### 3. Funzione spawn_worker_headless() (linea 632-697)
Nuova funzione che:
- Usa `tmux new-session -d` per sessione detached
- Salva session name in `.swarm/status/worker_NAME.session`
- Log in `.swarm/logs/worker_NAME_TIMESTAMP.log`
- Imposta `remain-on-exit on` per catturare output dopo fine
- Scrive `WORKER_DONE` nel log quando termina

### 4. Loop Spawn Modificato (linea 880-896)
Il loop ora controlla `HEADLESS_MODE`:
```bash
if [ "$HEADLESS_MODE" = true ]; then
    spawn_worker_headless "$worker"
else
    spawn_worker "$worker"
fi
```

### 5. show_usage() Aggiornato (linea 721-733)
Aggiunte opzioni:
```
--headless             Usa tmux headless (no finestre Terminal)
--window               Usa Terminal.app (default)
```

Aggiunto esempio:
```
spawn-workers --headless --backend    # Backend in tmux (no finestre!)
```

## Come Usare

```bash
# Spawna backend in modalita headless (tmux)
spawn-workers --headless --backend

# Verifica sessione creata
tmux list-sessions | grep swarm_backend

# Vedi output live
tmux capture-pane -t swarm_backend_* -p -S -

# Attacca alla sessione per vedere interazione
tmux attach-session -t swarm_backend_*

# Termina sessione
tmux kill-session -t swarm_backend_*
```

## Note

- La modalita headless usa tmux, che deve essere installato
- Le sessioni tmux persistono anche dopo logout SSH
- I log vengono salvati in `.swarm/logs/`
- Il session name include timestamp per univocita

---

*Task completato da cervella-backend - Sessione 122*
