# RICERCA ANTICOMPACT 01 - Output

**Task ID:** RICERCA_ANTICOMPACT_01
**Worker:** cervella-scienziata
**Data:** 2026-01-04
**Status:** COMPLETATO

---

## SOLUZIONI TROVATE

### 1. Tool CLI Esistenti (PRONTI ALL'USO!)

| Tool | Descrizione | Installazione |
|------|-------------|---------------|
| **cccontext** | Monitor contesto per sessione singola o multiple | `npx cccontext` |
| **ccusage** | Analisi usage da file JSONL, dashboard live | `npx ccusage` |
| **ccstatusline** | Status line customizzabile con token usage | `npx ccstatusline` |
| **@aegntic/cldcde-context-tracker** | Monitor persistente sotto input text | npm package |

**cccontext** e il piu semplice:
```bash
# Sessione singola
npx cccontext

# Multi-sessione live
npx cccontext sessions --live

# Lista tutte le sessioni
npx cccontext --list
```

**ccusage** per dashboard in tempo reale:
```bash
npx ccusage blocks --live
```

### 2. Continuous-Claude-v2 (SOLUZIONE COMPLETA!)

Repository: https://github.com/parcadei/Continuous-Claude-v2

Questo progetto risolve ESATTAMENTE il nostro problema con:

- **StatusLine colorata**: 45.2K 23% | main U:3 | Focus attuale
- **File temporaneo**: `/tmp/claude-context-pct-{SESSION_ID}.txt`
- **Notifiche graduate**:
  - Verde (<60%): Tutto ok
  - Giallo (60-79%): "Considera handoff presto"
  - Rosso (>=80%): "Esegui /create_handoff ORA!"
  - 90%+: Icona warning!
- **Ledgers**: Salva stato in `CONTINUITY_CLAUDE-<session>.md`
- **Handoffs**: Crea handoff dettagliati per passaggio sessione

**Hook usato**: `UserPromptSubmit` - legge % e mostra avvisi prima di ogni prompt.

### 3. Hooks Claude Code Disponibili

| Hook | Quando scatta | Puo bloccare? |
|------|---------------|---------------|
| **PreCompact** | Prima di compact (manual/auto) | NO (solo stderr) |
| **PostToolUse** | Dopo tool completato | Si |
| **UserPromptSubmit** | Prima di processare prompt utente | Si |
| **SessionStart** | Inizio sessione / dopo /clear | Si (output in context) |
| **Notification** | Quando Claude notifica | Si |
| **PreToolUse** | Prima di eseguire tool | Si |
| **Stop** | Quando Claude finisce risposta | No |
| **SubagentStop** | Quando subagent finisce | No |
| **SessionEnd** | Fine sessione | No |

**PROBLEMA NOTO**: PreCompact hook ha BUG! Issue #13572 - non scatta correttamente.

### 4. Intercettazione Terminale VS Code

**Status API**: PROPOSTA, non stabile!
- `window.onDidWriteTerminalData` - solo VS Code Insiders
- Richiederebbe estensione custom
- Shell integration per catturare output

**Conclusione**: NON e la strada giusta - troppo complesso e instabile.

---

## FATTIBILITA

### Approccio A: Usare Tool Esistenti (IMMEDIATO)
- **cccontext/ccusage**: GIA FUNZIONANTI
- Setup: 1 comando npm
- Limitazione: Monitoring passivo, devi guardare tu

### Approccio B: Fork Continuous-Claude-v2 (1-2 ore)
- Loro sistema e COMPLETO
- Ha notifiche automatiche via hook
- Richiede adattamento al nostro workflow

### Approccio C: Script Custom con Hook (2-4 ore)
- Usare `UserPromptSubmit` hook
- Leggere % da cccontext o file JSONL
- Notifica macOS quando <15%

### Approccio D: Intercettare Terminale (SCONSIGLIATO)
- API non stabile
- Richiede estensione VS Code custom
- Troppo fragile

---

## RACCOMANDAZIONE

### STEP 1: IMMEDIATO (5 minuti)
```bash
# Installa cccontext globalmente
npm install -g cccontext

# In un pannello iTerm/tmux dedicato:
npx cccontext sessions --live
```

Tieni sempre visibile il context usage mentre lavori.

### STEP 2: QUESTA SETTIMANA
Studia **Continuous-Claude-v2** e adatta:
- Il loro `UserPromptSubmit` hook
- Il sistema di notifiche graduali
- Il file `/tmp/claude-context-pct-*.txt`

### STEP 3: SOLUZIONE DEFINITIVA
Crea hook custom in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/context-check.sh"
          }
        ]
      }
    ]
  }
}
```

Lo script `context-check.sh`:
1. Legge % da cccontext o file JSONL
2. Se <12%: notifica macOS + output warning
3. Claude riceve warning nel contesto

---

## FONTI

### Tool e Repository
- [cccontext - Blog post](https://fubar1346.com/blog/claude-code-context)
- [ccusage - GitHub](https://github.com/ryoppippi/ccusage)
- [Continuous-Claude-v2 - GitHub](https://github.com/parcadei/Continuous-Claude-v2)

### Documentazione Claude Code
- [Hooks Reference - Claude Docs](https://code.claude.com/docs/en/hooks)
- [Claude Code Hooks Blog](https://claude.com/blog/how-to-configure-hooks)

### GitHub Issues Rilevanti
- [#13572 - PreCompact hook not triggered](https://github.com/anthropics/claude-code/issues/13572)
- [#14258 - PostCompact Hook Feature Request](https://github.com/anthropics/claude-code/issues/14258)
- [#6689 - Add --no-auto-compact switch](https://github.com/anthropics/claude-code/issues/6689)
- [#10691 - Add autoCompact settings](https://github.com/anthropics/claude-code/issues/10691)

### VS Code Terminal API
- [Issue #190941 - API access to terminal output](https://github.com/microsoft/vscode/issues/190941)
- [Terminal Capture Extension](https://marketplace.visualstudio.com/items?itemName=devwright.vscode-terminal-capture)

---

## CONCLUSIONE

**NON dobbiamo reinventare la ruota!**

La community ha gia risolto questo problema. Le soluzioni esistono:
1. **cccontext/ccusage** per monitoring
2. **Continuous-Claude-v2** per automazione completa
3. **Hook UserPromptSubmit** per integrazione custom

La strada dell'intercettazione terminale e SCONSIGLIATA - troppo fragile.

Il `PreCompact` hook ha bug noti e non puo bloccare l'operazione.

La soluzione migliore e combinare **cccontext** (monitoring) + **hook UserPromptSubmit** (notifiche).

---

*"Siamo nel 2026, non anni 80!"* - La soluzione esiste gia, usiamola!

*Cervella-Scienziata*
