# Task: Fix Problemi ALTI Sicurezza (dalla Review 8.5/10)

**Assegnato a:** cervella-backend
**Stato:** ready
**Priorita:** ALTA (sicurezza!)
**Data:** 5 Gennaio 2026

---

## Obiettivo

Fixare i 3 problemi di sicurezza ALTI trovati dalla code review.

---

## Problema 1: Path NVM Hardcodato

**File da modificare:**
- `~/.swarm/config` (riga ~52)
- `~/.local/lib/swarm-common.sh` (riga ~161)
- `~/.local/bin/spawn-workers` (riga ~51)

**Problema:**
```bash
elif [[ -f "$HOME/.nvm/versions/node/v24.11.0/bin/claude" ]]; then
```
Versione Node hardcodata. Se l'utente aggiorna Node, il fallback non funziona.

**Soluzione:**
```bash
# Invece di hardcodare la versione, usa glob per trovare qualsiasi versione
local nvm_claude=$(ls -t $HOME/.nvm/versions/node/*/bin/claude 2>/dev/null | head -1)
if [[ -n "$nvm_claude" && -f "$nvm_claude" ]]; then
    CLAUDE_BIN="$nvm_claude"
```

---

## Problema 2: Escape AppleScript Incompleto

**File da modificare:**
- `~/.claude/hooks/context_check.py` (righe ~193-204)

**Problema:**
```python
safe_prompt = prompt.replace('"', '\\"')  # Insufficiente!
```
L'escape copre solo virgolette, non altri caratteri speciali AppleScript.

**Soluzione:**
```python
def escape_applescript(text):
    """Escape completo per AppleScript"""
    # Ordine importante: prima backslash, poi gli altri
    text = text.replace('\\', '\\\\')
    text = text.replace('"', '\\"')
    text = text.replace("'", "\\'")
    text = text.replace('\n', '\\n')
    text = text.replace('\t', '\\t')
    return text

safe_prompt = escape_applescript(prompt)
```

---

## Problema 3: Command Injection Potenziale

**File da modificare:**
- `~/.local/bin/spawn-workers` (riga ~438)

**Problema:**
```bash
osascript -e "tell application \"Terminal\" to do script \"${runner_script}\""
```
Se `runner_script` contiene caratteri speciali, potrebbe causare problemi.

**Soluzione:**
Usare heredoc invece di interpolazione:
```bash
osascript << EOF
tell application "Terminal"
    do script "cd '$PROJECT_ROOT' && '$runner_script'"
end tell
EOF
```
Oppure sanitizzare il path con funzione dedicata.

---

## Output Atteso

1. I 3 file modificati con i fix
2. Test manuale che i comandi funzionano ancora:
   - `spawn-workers --backend` (deve trovare claude)
   - context_check.py con prompt contenente caratteri speciali

---

## Checklist Verifica

- [ ] Path NVM ora usa glob, non versione hardcodata
- [ ] Escape AppleScript gestisce: \\ " ' \n \t
- [ ] spawn-workers usa heredoc o path sanitizzato
- [ ] Testato: spawn-workers trova claude
- [ ] Nessuna regressione

---

*Task creato da Cervella Regina - Sessione 90*
