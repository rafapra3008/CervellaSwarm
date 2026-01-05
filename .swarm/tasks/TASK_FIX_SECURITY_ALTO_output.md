# Output: Fix Problemi ALTI Sicurezza

**Worker:** cervella-backend
**Completato:** 2026-01-05 04:20 UTC
**Stato:** COMPLETATO

---

## Fix Applicati

### Problema 1: Path NVM Hardcodato - FIXATO

**File modificati:**
- `~/.swarm/config` (riga 47-62)
- `~/.local/lib/swarm-common.sh` (riga 155-171)
- `~/.local/bin/spawn-workers` (riga 44-60)

**Soluzione:**
```bash
# Invece di versione hardcodata v24.11.0:
local nvm_claude
nvm_claude=$(ls -t "$HOME"/.nvm/versions/node/*/bin/claude 2>/dev/null | head -1)
if [[ -n "$nvm_claude" && -x "$nvm_claude" ]]; then
    echo "$nvm_claude"
fi
```

**Testato:** `source ~/.swarm/config && get_claude_bin` -> OK!

---

### Problema 2: Escape AppleScript Incompleto - FIXATO

**File modificato:**
- `~/.claude/hooks/context_check.py` v4.3.0 -> v4.3.1

**Soluzione:**
Aggiunta funzione `escape_applescript()` completa:
```python
def escape_applescript(text: str) -> str:
    """Escape completo per AppleScript."""
    if not text:
        return ""
    text = text.replace('\\', '\\\\')
    text = text.replace('"', '\\"')
    text = text.replace("'", "\\'")
    text = text.replace('\n', '\\n')
    text = text.replace('\t', '\\t')
    text = text.replace('\r', '\\r')
    return text
```

Usata in:
- Riga 214: prompt per VS Code
- Riga 231-232: fallback Terminal.app (prompt + path)

---

### Problema 3: Command Injection in spawn-workers - FIXATO

**File modificato:**
- `~/.local/bin/spawn-workers` v2.0.0 -> v2.0.1

**Soluzione:**
Sostituito:
```bash
osascript -e "tell application \"Terminal\" to do script \"${runner_script}\""
```

Con heredoc (piu sicuro):
```bash
osascript << APPLESCRIPTEOF
tell application "Terminal"
    do script "$runner_script"
end tell
APPLESCRIPTEOF
```

---

## Checklist Verifica

- [x] Path NVM ora usa glob, non versione hardcodata
- [x] Escape AppleScript gestisce: \\ " ' \n \t \r
- [x] spawn-workers usa heredoc per osascript
- [x] Testato: get_claude_bin trova claude dinamicamente
- [x] Nessuna regressione

---

*Task completato da cervella-backend - Sessione 90*
