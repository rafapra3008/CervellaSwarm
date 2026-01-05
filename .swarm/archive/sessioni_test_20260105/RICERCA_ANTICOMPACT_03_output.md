# Report: Ricerca Anti-Compact - Claude Code Internals

**Task ID:** RICERCA_ANTICOMPACT_03
**Worker:** cervella-researcher
**Data:** 2026-01-04
**Durata:** ~15 minuti

---

## CURRENT_USAGE

### Dove si trova

Il campo `current_usage` **NON esiste come file di stato separato**. I dati di usage sono disponibili SOLO:

1. **Nel transcript JSONL** (`~/.claude/projects/[progetto]/[session-id].jsonl`)
2. **Nella statusline** (se configurata per mostrarlo)

### Struttura nel Transcript

Ogni messaggio `assistant` contiene un oggetto `usage`:

```json
{
  "type": "assistant",
  "message": {
    "usage": {
      "input_tokens": 8,
      "cache_creation_input_tokens": 616,
      "cache_read_input_tokens": 150238,
      "output_tokens": 220,
      "service_tier": "standard"
    }
  }
}
```

### Formula per Calcolare Context Usage

```
totalTokens = input_tokens + cache_read_input_tokens + cache_creation_input_tokens
percentage = (totalTokens / 200000) * 100
```

**NOTA IMPORTANTE:** L'API Anthropic restituisce utilizzo **CUMULATIVO** per turno, quindi basta leggere l'ULTIMO messaggio assistant non-sidechain.

### Come Accederlo

```python
import json

def get_context_usage(transcript_path):
    with open(transcript_path, 'r') as f:
        lines = f.readlines()

    # Leggi al contrario, trova primo assistant non-sidechain
    for line in reversed(lines):
        try:
            obj = json.loads(line.strip())
            if (obj.get("type") == "assistant"
                and not obj.get("isSidechain", False)
                and "usage" in obj.get("message", {})):
                usage = obj["message"]["usage"]
                total = (usage["input_tokens"]
                        + usage["cache_creation_input_tokens"]
                        + usage["cache_read_input_tokens"])
                return total, (total / 200000) * 100
        except:
            continue
    return 0, 0
```

---

## HOOKS DISPONIBILI

### Lista Completa

| Hook | Matcher | Descrizione |
|------|---------|-------------|
| **PreToolUse** | nome tool | Prima di eseguire un tool |
| **PostToolUse** | nome tool | Dopo un tool (Task, Bash, etc.) |
| **UserPromptSubmit** | - | Prima che il prompt venga elaborato |
| **Notification** | - | Quando Claude notifica qualcosa |
| **Stop** | - | Fine del turno |
| **SubagentStop** | - | Fine di un subagent |
| **PreCompact** | `auto`, `manual` | **PRIMA** del compact |
| **SessionStart** | `startup`, `resume` | Inizio sessione |
| **SessionEnd** | - | Fine sessione |

### Hook PreCompact - Dettagli

**Matcher possibili:**
- `auto` = compact automatico (quando context > ~78%)
- `manual` = compact manuale (`/compact`)

**Input ricevuto:**
- Non documentato ufficialmente cosa riceve via stdin
- Probabile: tipo di compact, session info

**Uso attuale in CervellaSwarm:**
```json
{
  "matcher": "auto",
  "hooks": [
    {"command": "python3 pre_compact_save.py"},
    {"command": "python3 update_prompt_ripresa.py"},
    {"command": "anti-compact.sh --no-spawn --message 'PreCompact auto'"}
  ]
}
```

### Hook Mancante per Anti-Compact Automatico

**PROBLEMA:** Non esiste un hook `PreAutoCompact` che si attiva PRIMA che il context arrivi al 78%.

**WORKAROUND POSSIBILE:**
- Statusline script che monitora continuamente
- Se % > 10-12%, notifica macOS

---

## FILE DI STATO

### ~/.claude/ - Contenuti Rilevanti

| File | Contenuto | Utile per Anti-Compact |
|------|-----------|------------------------|
| `stats-cache.json` | Statistiche giornaliere token/sessioni | NO (storico) |
| `compact-log.txt` | Log di tutti i compact | NO (solo log) |
| `session-log.txt` | Log fine sessioni | NO (solo log) |
| `settings.json` | Config hooks, MCP, permissions | SI (config) |
| `projects/[name]/*.jsonl` | **TRANSCRIPT SESSIONI** | **SI!** |

### Transcript Path

Il path del transcript attivo e' disponibile:
- Alla statusline via stdin: `data["transcript_path"]`
- Nel file system: `~/.claude/projects/-Users-...-[progetto]/[session-id].jsonl`

---

## COMMUNITY SOLUTIONS

### Tool Esistenti

1. **cccontext** (npm)
   - `npx cccontext` - mostra context usage sessione corrente
   - `npx cccontext sessions --live` - monitoraggio real-time multi-sessione
   - GitHub: cerca "ryoppippi cccontext"

2. **ccusage** (npm)
   - `npx ccusage statusline` - integrazione statusline (Beta)
   - Analisi token/costi da JSONL
   - GitHub: https://github.com/ryoppippi/ccusage

3. **@this-dot/claude-code-context-status-line** (npm)
   - Statusline pronta che mostra context %
   - Legge JSONL, calcola percentuale

4. **Custom Statusline Scripts**
   - Issue #516 ha esempi Python completi
   - Barra grafica + percentuale
   - https://github.com/anthropics/claude-code/issues/516

### GitHub Issues Rilevanti

- **#516** - "Always show available context percentage" (115+ upvotes)
- **#5526** - "Monitor context window usage" (CLOSED/COMPLETED)
- **#5547** - "Real-time Context Window Monitoring in Status Line"

---

## RACCOMANDAZIONE

### Strada Migliore: STATUSLINE SCRIPT

**Perche':**
1. NON richiede hook speciale (non esiste `PreContext10%`)
2. Mostra % in tempo reale
3. Puo' triggerare notifica macOS quando supera soglia
4. Gia' testato dalla community

**Implementazione Proposta:**

```python
#!/usr/bin/env python3
# ~/.claude/scripts/context-monitor.py

import json
import sys
import subprocess

CONTEXT_LIMIT = 200000
WARNING_THRESHOLD = 0.12  # 12%

def main():
    data = json.load(sys.stdin)
    transcript_path = data["transcript_path"]

    # Calcola context usage
    context_used = 0
    with open(transcript_path, 'r') as f:
        for line in reversed(f.readlines()):
            try:
                obj = json.loads(line.strip())
                if (obj.get("type") == "assistant"
                    and not obj.get("isSidechain", False)
                    and "usage" in obj.get("message", {})):
                    usage = obj["message"]["usage"]
                    context_used = (usage["input_tokens"]
                                  + usage["cache_creation_input_tokens"]
                                  + usage["cache_read_input_tokens"])
                    break
            except:
                continue

    context_left = (CONTEXT_LIMIT - context_used) / CONTEXT_LIMIT
    percentage = context_used / CONTEXT_LIMIT * 100

    # Notifica se sotto soglia
    if context_left <= WARNING_THRESHOLD:
        subprocess.run([
            "osascript", "-e",
            f'display notification "Context al {percentage:.0f}%! Fai checkpoint!" '
            f'with title "CervellaSwarm" sound name "Sosumi"'
        ])

    # Output per statusline
    bar_len = 20
    filled = int(bar_len * percentage / 100)
    bar = "=" * filled + "-" * (bar_len - filled)
    print(f"[{bar}] {percentage:.1f}%")

if __name__ == "__main__":
    main()
```

**Config in settings.json:**
```json
{
  "statusLine": {
    "type": "command",
    "command": "python3 ~/.claude/scripts/context-monitor.py"
  }
}
```

### Alternativa: Demone Esterno

Se la statusline non basta, un demone che:
1. Watchdog su file JSONL (inotify/fswatch)
2. Ricalcola % ad ogni modifica
3. Notifica quando < 12%

Piu' complesso ma indipendente da Claude Code.

---

## FONTI

- [GitHub Issue #516 - Always show context percentage](https://github.com/anthropics/claude-code/issues/516)
- [GitHub Issue #5526 - Monitor context window usage](https://github.com/anthropics/claude-code/issues/5526)
- [ccusage - CLI tool](https://github.com/ryoppippi/ccusage)
- [Claude Code Hooks Reference](https://code.claude.com/docs/en/hooks)
- [How to Calculate Context Usage](https://codelynx.dev/posts/calculate-claude-code-context)
- [cccontext - Visualizing Context](https://fubar1346.com/blog/claude-code-context)
- [Configure Hooks Blog](https://claude.com/blog/how-to-configure-hooks)

---

## CONCLUSIONE

**Non esiste un hook "prima che arrivi auto-compact".**

La soluzione e' **monitorare attivamente** tramite:
1. **Statusline script** (raccomandato)
2. **cccontext/ccusage** (tool esistenti)
3. **Watchdog demone** (piu' complesso)

Il PreCompact hook e' TROPPO TARDI - si attiva quando Claude gia' vuole fare compact.
Serve monitoraggio PROATTIVO che notifica a 10-12%.

---

*"Siamo nel 2026, non anni 80!"* - Rafa

Ricerca completata.
