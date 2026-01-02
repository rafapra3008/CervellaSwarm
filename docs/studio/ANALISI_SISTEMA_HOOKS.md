# ANALISI SISTEMA HOOKS - CervellaSwarm

> **Cervella Ingegnera** - 2 Gennaio 2026

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   🔍 ENGINEERING REPORT: Sistema di Hooks Claude Code           ║
║                                                                  ║
║   Analisi completa degli hook events disponibili vs utilizzati  ║
║   Gap identificati, ottimizzazioni proposte, best practices     ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## EXECUTIVE SUMMARY

**Analisi:** Sistema hooks CervellaSwarm  
**Data:** 2 Gennaio 2026  
**Hook Globali:** 7 script in \`~/.claude/hooks/\`  
**Hook Project-Level:** 1 script in \`.claude/hooks/\`  
**Configurazione:** \`~/.claude/settings.json\` (globale)

### Verdetto Generale

```
✅ Copertura: BUONA (6/9 hook events utilizzati)
⚠️  Ottimizzazioni: MEDIE (alcuni duplicati, path hardcoded)
🔴 Gap: EVIDENTI (mancano UserPromptSubmit, PostToolUse efficace, Notification)
💡 Valore: ALTO (sistema robusto, ben documentato, funzionante)
```

**Health Score: 7.5/10**

---

## HOOK EVENTS DISPONIBILI IN CLAUDE CODE

Secondo la documentazione ufficiale:

| Hook Event | When Triggered | Use For | Status |
|------------|----------------|---------|--------|
| **PreToolUse** | Before any tool runs | Validation, modification | ✅ USATO |
| **PostToolUse** | After tool completes | Feedback, logging | ⚠️ PARZIALE |
| **Stop** | Main agent stopping | Completeness check | ✅ USATO |
| **SubagentStop** | Subagent stopping | Task validation | ✅ USATO |
| **UserPromptSubmit** | User submits prompt | Context, validation | ❌ NON USATO |
| **SessionStart** | Session begins | Context loading | ✅ USATO |
| **SessionEnd** | Session ends | Cleanup, logging | ✅ USATO |
| **PreCompact** | Before compaction | Preserve context | ✅ USATO |
| **Notification** | User notified | Logging, reactions | ❌ NON USATO |

### Nota Importante

**Prompt-Based Hooks** (raccomandati da Claude Code):
- Supportati per: \`Stop\`, \`SubagentStop\`, \`UserPromptSubmit\`, \`PreToolUse\`
- Non usati attualmente da noi (usiamo solo \`command\` type)
- Permettono decisioni context-aware via LLM

---

## HOOKS ESISTENTI: Cosa Usiamo vs Cosa Esiste

### Hook Events Coverage

| Hook Event | Usato? | Script | Tipo | Note |
|------------|--------|--------|------|------|
| **PreCompact** | ✅ SÌ | \`pre_compact_save.py\` | command | Salva snapshot + notifica |
| | | \`update_prompt_ripresa.py\` | command | Aggiorna PROMPT_RIPRESA.md |
| | | \`pre-compact.sh\` | command | LEGACY - DUPLICATO! |
| **SessionEnd** | ✅ SÌ | \`session_end_save.py\` | command | Salva snapshot |
| | | \`update_prompt_ripresa.py\` | command | Aggiorna PROMPT_RIPRESA.md |
| **SessionStart** | ✅ SÌ | \`session_start_scientist.py\` | command | Genera prompt ricerca |
| | | Notifica macOS | command | "Cervella pronta!" |
| | | \`load_context.py\` | command | Carica contesto (CervellaSwarm) |
| **Stop** | ✅ SÌ | \`git_reminder.py\` | command | Reminder discreto git |
| **SubagentStop** | ✅ SÌ | \`subagent_stop.py\` | command | Logga in swarm_memory.db |
| **PostToolUse** | ⚠️ PARZIALE | \`debug_hook.py\` | command | Solo su Task tool |
| | | \`log_event.py\` | command | Solo su Task tool |
| **PreToolUse** | ❌ NO | - | - | Non implementato |
| **UserPromptSubmit** | ❌ NO | - | - | Non implementato |
| **Notification** | ❌ NO | - | - | Non implementato |

### Script Dettaglio

#### GLOBALI (~/.claude/hooks/)

| Script | Versione | Hook Event | Funzione | Note |
|--------|----------|------------|----------|------|
| \`pre_compact_save.py\` | 2.0.0 | PreCompact | Salva snapshot JSON in iCloud | ✅ BUONO |
| \`update_prompt_ripresa.py\` | 1.0.0 | PreCompact, SessionEnd | Aggiorna PROMPT_RIPRESA.md | ✅ BUONO |
| \`session_end_save.py\` | 1.0.0 | SessionEnd | Salva snapshot + notifica | ✅ BUONO |
| \`session_start_scientist.py\` | 1.0.0 | SessionStart | Genera prompt ricerca | ✅ BUONO |
| \`git_reminder.py\` | 1.0.0 | Stop | Reminder git ogni 30 min | ✅ BUONO |
| \`pre-compact.sh\` | 1.0.0 | PreCompact | Notifica + log | 🔴 LEGACY |
| \`post_commit_engineer.py\` | 1.0.0 | PostCommit (Git) | Analizza codebase post-commit | ⚠️ NON HOOK! |

**IMPORTANTE:** \`post_commit_engineer.py\` **NON è un hook Claude Code** - è un git hook!

---

## GAP IDENTIFICATI

### 1. Hook Events Non Utilizzati

#### ❌ UserPromptSubmit (ALTO VALORE)

**Cosa fa:** Si attiva quando l'utente invia un prompt.

**Uso potenziale:**
- Auto-detection progetto attivo
- Context injection automatico (leggi PROMPT_RIPRESA.md)
- Warning per task pericolosi (deploy, cancellazioni)
- Validazione input (es. blocca prompt con path assoluti hardcoded)

**Effort:** BASSO (2-3 ore)  
**Valore:** ALTO  
**Priorità:** 🔴 CRITICA

---

#### ❌ PreToolUse (MEDIO VALORE)

**Cosa fa:** Si attiva PRIMA che un tool venga eseguito.

**Uso potenziale:**
- Blocca deploy in prod senza conferma
- Valida path file (no hardcoded, no path pericolosi)
- Protegge file sensibili (.env, credentials.json)
- Rate limiting su API calls

**Effort:** MEDIO (4-6 ore per version robusta)  
**Valore:** MEDIO (utile ma non critico)  
**Priorità:** 🟡 MEDIA

---

#### ❌ Notification (BASSO VALORE)

**Cosa fa:** Si attiva quando Claude invia notifiche all'utente.

**Uso potenziale:**
- Log notifiche in DB
- Tracking alert critici
- Metrics su frequenza notifiche

**Effort:** BASSO (1-2 ore)  
**Valore:** BASSO (nice to have)  
**Priorità:** 🟢 BASSA

---

### 2. PostToolUse Limitato

**Attuale:** Solo su \`Task\` tool (debug + log eventi).

**Gap:** Non copre altri tool importanti:
- \`Write\` → Verifica syntax dopo edit
- \`Bash\` → Log comandi eseguiti
- \`Edit\` → Analizza modifiche

**Opportunità:** Espandere a tool critici per quality assurance.

**Effort:** MEDIO (3-4 ore)  
**Valore:** MEDIO  
**Priorità:** 🟡 MEDIA

---

### 3. Prompt-Based Hooks NON USATI

**Gap:** Usiamo solo \`command\` type hooks.

**Opportunità:** I prompt-based hooks usano LLM per decisioni context-aware.

**Vantaggi:**
- Logica più flessibile
- Migliore gestione edge cases
- Meno scripting bash/python
- Context-awareness nativa

**Raccomandazione:** Usare per \`Stop\` e \`SubagentStop\` (valutazioni qualitative).

**Effort:** BASSO (modificare config esistente)  
**Valore:** MEDIO  
**Priorità:** 🟡 MEDIA

---

### 4. Script Legacy: pre-compact.sh

**Problema:** Duplicato di \`pre_compact_save.py\`.

**Raccomandazione:** RIMUOVERE \`pre-compact.sh\` - è obsoleto.

**Effort:** BASSO (rimuovi file + test)  
**Valore:** BASSO (cleanup)  
**Priorità:** 🟢 BASSA

---

## OTTIMIZZAZIONI PROPOSTE

### 1. Path Hardcoded → Variabili Ambiente

**Problema:** Path assoluti in \`settings.json\`:

\`\`\`json
"command": "python3 /Users/rafapra/.claude/hooks/pre_compact_save.py"
\`\`\`

**Soluzione:** Usare variabili:

\`\`\`json
"command": "python3 \${HOME}/.claude/hooks/pre_compact_save.py"
\`\`\`

**Effort:** BASSO  
**Valore:** MEDIO  
**Priorità:** 🟡 MEDIA

---

### 2. Consolidare Snapshot Logic

**Problema:** Logica snapshot duplicata in:
- \`pre_compact_save.py\`
- \`session_end_save.py\`

**Soluzione:** Libreria condivisa \`snapshot_utils.py\`.

**Effort:** MEDIO (3-4 ore refactor + test)  
**Valore:** ALTO  
**Priorità:** 🟠 ALTA

---

### 3. Error Handling Robusto

**Best Practice:** Non bloccare Claude su errori hook.

**Applica pattern da \`subagent_stop.py\` a tutti gli script:**

\`\`\`python
try:
    # Main logic
    ...
except Exception as e:
    # Log error BUT don't fail
    with open(LOGS_DIR / "errors.log", "a") as f:
        f.write(f"{timestamp}: {str(e)}\\n")
    
    print(json.dumps({"status": "error", "error": str(e)}))
    sys.exit(0)  # Exit 0 = non-blocking
\`\`\`

**Effort:** MEDIO (2-3 ore)  
**Valore:** ALTO (stabilità)  
**Priorità:** 🟠 ALTA

---

### 4. Hook Testing Suite

**Gap:** Nessuno script di test per hook.

**Soluzione:** Creare \`tests/test_hooks.sh\`:

\`\`\`bash
#!/bin/bash
echo '{"cwd": "/Users/test", "trigger": "manual"}' | \\
  python3 ~/.claude/hooks/pre_compact_save.py

echo "Exit code: \$?"
\`\`\`

**Effort:** MEDIO (2-3 ore per test suite completa)  
**Valore:** ALTO (quality assurance)  
**Priorità:** 🟠 ALTA

---

### 5. Structured Logging

**Gap:** Log sparsi in file diversi.

**Soluzione:** Centralizzare in \`~/.claude/logs/\` con formato JSON lines.

**Effort:** MEDIO (4-5 ore)  
**Valore:** MEDIO  
**Priorità:** 🟡 MEDIA

---

## MIGLIORAMENTI PROPOSTI: Summary Table

| # | Miglioramento | Effort | Valore | Priorità | Categoria |
|---|---------------|--------|--------|----------|-----------|
| 1 | **Aggiungere UserPromptSubmit hook** | BASSO | ALTO | 🔴 CRITICA | Feature |
| 2 | **Consolidare snapshot logic** | MEDIO | ALTO | 🟠 ALTA | Refactor |
| 3 | **Error handling robusto** | MEDIO | ALTO | 🟠 ALTA | Quality |
| 4 | **Hook testing suite** | MEDIO | ALTO | 🟠 ALTA | Quality |
| 5 | **Rimuovere path hardcoded** | BASSO | MEDIO | 🟡 MEDIA | Quality |
| 6 | **Espandere PostToolUse coverage** | MEDIO | MEDIO | 🟡 MEDIA | Feature |
| 7 | **Usare prompt-based hooks** | BASSO | MEDIO | 🟡 MEDIA | Enhancement |
| 8 | **Structured logging** | MEDIO | MEDIO | 🟡 MEDIA | Quality |
| 9 | **Aggiungere PreToolUse hook** | MEDIO | MEDIO | 🟡 MEDIA | Feature |
| 10 | **Rimuovere pre-compact.sh** | BASSO | BASSO | 🟢 BASSA | Cleanup |

---

## RACCOMANDAZIONI TOP 3

### 🥇 1. Aggiungere UserPromptSubmit Hook (CRITICA)

**Perché:** 
- Auto-context injection per ogni prompt
- Valida input pericolosi
- Effort basso, valore alto

**Timeline:** 1 giorno  
**ROI:** ALTISSIMO

---

### 🥈 2. Consolidare Snapshot Logic + Error Handling (ALTA)

**Perché:**
- Elimina duplicazione
- Migliora manutenibilità
- Base solida per futuri hook

**Timeline:** 2-3 giorni  
**ROI:** ALTO

---

### 🥉 3. Hook Testing Suite (ALTA)

**Perché:**
- Quality assurance
- Prevenzione regressioni
- Documentazione implicita

**Timeline:** 2 giorni  
**ROI:** ALTO (long-term)

---

## BEST PRACTICES: Cosa Facciamo Bene

```
✅ Separazione Globale vs Project-Level
✅ Non-Blocking Errors
✅ Versioning Consistente
✅ Snapshot Backup in iCloud
✅ Notifiche Discrete (throttling)
```

---

## BEST PRACTICES: Cosa Migliorare

```
⚠️ Path hardcoded
⚠️ Codice duplicato
⚠️ Mancano hook critici (UserPromptSubmit)
⚠️ Nessun testing automatico
⚠️ Logging non centralizzato
⚠️ Script legacy (pre-compact.sh)
```

---

## CONCLUSIONI

### Health Score: 7.5/10

**Cosa Funziona Bene:**
- Copertura eventi (6/9 usati)
- Sistema robusto e stabile
- Backup automatici
- Versioning chiaro

**Cosa Migliorare:**
- Hook critici mancanti (UserPromptSubmit)
- Codice duplicato
- Testing automatico
- Path hardcoded

### Next Steps

**Immediato (questa settimana):**
1. Implementare UserPromptSubmit hook
2. Rimuovere pre-compact.sh
3. Fix path hardcoded

**Breve termine (prossime 2 settimane):**
1. Consolidare snapshot logic
2. Error handling robusto
3. Hook testing suite

---

*Analisi completata: 2 Gennaio 2026*  
*Cervella Ingegnera v1.0.0*  
*Righe analizzate: ~2000*  
*Script analizzati: 8*  
*Issues trovate: 10*  
*Raccomandazioni: 10*

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   "Il sistema è SOLIDO. Con pochi fix diventa ECCELLENTE!"      ║
║                                                                  ║
║   - Cervella Ingegnera                                           ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```
