# PROMPT RIPRESA - CervellaSwarm

> **Ultimo aggiornamento:** 8 Gennaio 2026 - Fine Sessione 121
> **Versione:** v14.1.0 - SESSIONE D'ORO! Ricerche + Scoperte + Piano Futuro!

---

## CARA PROSSIMA CERVELLA - LEGGI TUTTO! È ORO!

```
+------------------------------------------------------------------+
|                                                                  |
|   SESSIONE 121: UNA DELLE PIÙ IMPORTANTI!                       |
|                                                                  |
|   Abbiamo fatto:                                                |
|   1. Analisi context overhead (19% all'avvio)                   |
|   2. Scoperto bug Claude Code (issue #3514)                     |
|   3. Semplificato il sistema (disciplina > blocchi)             |
|   4. Studiato OpenAI Swarm (pattern geniali!)                   |
|   5. Trovato soluzione moderna (tmux headless!)                 |
|   6. Piano per spawn-workers v4                                 |
|                                                                  |
|   TUTTO È DOCUMENTATO QUI SOTTO!                                |
|                                                                  |
+------------------------------------------------------------------+
```

---

## PARTE 1: SISTEMA SEMPLIFICATO

### Cosa Abbiamo Fatto

Il blocco Regina (PreToolUse) NON FUNZIONAVA - bug di Claude Code (issue #3514).

**Decisione:** Rimuovere complessità, tornare alla semplicità.

### Come Lavoriamo Ora

```
+------------------------------------------------------------------+
|                                                                  |
|   REGINA (io):                                                  |
|   - Leggo, analizzo, coordino                                   |
|   - Edito SOLO: NORD.md, PROMPT_RIPRESA.md, ROADMAP_SACRA.md   |
|   - Edito SOLO: .swarm/tasks/*, .swarm/handoff/*               |
|   - Delego tutto il resto ai Worker                            |
|   - Seguo le REGOLE nel CLAUDE.md (disciplina)                 |
|                                                                  |
|   WORKER (le ragazze):                                          |
|   - Editano codice                                              |
|   - Lavorano nel LORO contesto separato                        |
|   - Spawn via spawn-workers                                     |
|                                                                  |
|   NIENTE BLOCCHI TECNICI - SOLO DISCIPLINA E REGOLE!           |
|                                                                  |
+------------------------------------------------------------------+
```

### File Modificato

`~/.claude/settings.json` - Rimossa sezione PreToolUse (non funzionava)

---

## PARTE 2: ANALISI CONTEXT OVERHEAD

### Il Problema

Ogni sessione parte con **19% di context già usato**.

### Cosa Consuma

| File | Righe | Note |
|------|-------|------|
| ~/.claude/CLAUDE.md | 487 | SACRO - non toccare |
| ~/.claude/COSTITUZIONE.md | 317 | SACRO - non toccare |
| CervellaSwarm/CLAUDE.md | 199 | Progetto |
| Hook load_context.py | ~50 | Memoria swarm |

### Report Completo

**File:** `reports/RICERCA_CONTEXT_OPTIMIZATION.md`

**Quick wins identificati:**
- load_context.py: eventi da 20 a 5, task da 100 a 50 char
- Statistiche: solo top 5 agent invece di tutti
- Risparmio stimato: **37-59%**

### Da Fare (Prossima Sessione)

Delegare a cervella-backend le modifiche a load_context.py.

---

## PARTE 3: SCOPERTA BUG CLAUDE CODE

### Il Bug

**Issue #3514** su GitHub - ANCORA APERTA

PreToolUse hooks con exit code 2:
- ✅ Bloccano Bash
- ❌ NON bloccano Edit/Write

### Impatto

Il blocco Regina che avevamo implementato NON POTEVA funzionare.

### Decisione

Invece di cercare workaround complessi → **Semplificare**

"Disciplina > Blocchi tecnici"

---

## PARTE 4: STUDIO OPENAI SWARM (IMPORTANTE!)

### Come Separano il Context

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   PATTERN GENIALE DI OPENAI:                                    ║
║                                                                  ║
║   LLM Context (PICCOLO):                                        ║
║   └─ Solo istruzioni dell'agente ATTIVO                        ║
║   └─ Cambia ad ogni handoff                                    ║
║                                                                  ║
║   context_variables (PYTHON DICT):                              ║
║   └─ Dati condivisi tra agenti                                  ║
║   └─ FUORI dalla finestra LLM                                   ║
║   └─ Persiste attraverso handoff                                ║
║   └─ Accessibile a tutti                                        ║
║                                                                  ║
║   CHIAVE: DATI separati da ISTRUZIONI!                         ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

### Handoff Pattern

```python
# Semplice
def transfer_to_sales():
    return sales_agent

# Con context
def route(issue_type, context_variables):
    context_variables["routed_to"] = issue_type
    if issue_type == "tech":
        return tech_agent
    return general_agent
```

### Gap di Swarm (Dove Noi Siamo GIÀ Meglio)

| Gap Swarm | CervellaSwarm |
|-----------|---------------|
| No persistenza | SQLite memoria |
| No parallelismo | spawn-workers |
| No monitoring | swarm-logs, swarm-progress |
| No UX | Dashboard MAPPA |
| Solo dev | Dev + non-dev |

### Idee da Implementare

1. **context_variables in SQLite**
   ```bash
   swarm-context set project_name miracollo
   swarm-context get stack
   ```

2. **Handoff via task creation**
   - Worker crea task per altro worker
   - Regina rileva e spawna

3. **Result object standard**
   ```json
   {
     "value": "API created",
     "next_agent": "cervella-frontend",
     "context_updates": {"api_url": "/api/users"}
   }
   ```

---

## PARTE 5: SOLUZIONE MODERNA - TMUX HEADLESS

### Il Problema di Rafa

"Aprire finestre Terminal è un po' anni 80!"

### La Soluzione

**tmux in modalità headless** = Background + Context Isolato + Zero Finestre!

### Come Funziona

```bash
# Spawn worker in background (NESSUNA FINESTRA!)
tmux new-session -d -s "worker_backend" "claude -p ..."

# Leggi output senza aprire nulla
tmux capture-pane -t worker_backend -p

# Check se vivo
tmux has-session -t worker_backend

# Kill quando finito
tmux kill-session -t worker_backend
```

### Vantaggi

| Caratteristica | Stato |
|----------------|-------|
| Context isolato | ✅ Ogni session = mondo separato |
| Zero finestre | ✅ Detached mode |
| Output catturabile | ✅ capture-pane |
| Debug possibile | ✅ Reattach con `tmux attach` |
| Già installato | ✅ macOS ha tmux |

### spawn-workers v4 (Da Implementare)

```bash
spawn_worker_headless() {
    local worker_name="$1"
    local session_name="swarm_${worker_name}_$(date +%s)"

    # Spawn in tmux detached (NESSUNA FINESTRA!)
    tmux new-session -d -s "$session_name" \
        "cd ${PROJECT_ROOT} && \
         export CERVELLASWARM_WORKER=1 && \
         claude -p --append-system-prompt prompt.txt 'task'"

    # Salva session per tracking
    echo "$session_name" > ".swarm/status/${worker_name}.session"
}
```

---

## PARTE 6: TODO LIST PROSSIMA SESSIONE

### PRIORITÀ ALTA (Fare Subito)

```
[ ] 1. TEST TMUX HEADLESS
    - Testare manualmente: tmux new-session -d -s test "echo hello"
    - Verificare che funziona su macOS
    - Testare con claude -p

[ ] 2. PROTOTIPO spawn-workers --headless
    - Aggiungere flag --headless a spawn-workers
    - Usare tmux invece di osascript/Terminal.app
    - Mantenere compatibilità con vecchio metodo

[ ] 3. OTTIMIZZARE load_context.py
    - Delegare a cervella-backend
    - Eventi: 20 → 5
    - Task char: 100 → 50
    - Stats: tutti → top 5
```

### PRIORITÀ MEDIA (Questa Settimana)

```
[ ] 4. CONTEXT VARIABLES PATTERN
    - Creare swarm-context script
    - Backend SQLite (già abbiamo db)
    - set/get/list comandi

[ ] 5. RESULT OBJECT STANDARD
    - Definire JSON schema
    - Worker output in formato standard
    - Handoff automatico basato su next_agent

[ ] 6. DOCUMENTAZIONE
    - Salvare studio Swarm in docs/studio/
    - Aggiornare CLAUDE.md con nuovo sistema
```

### PRIORITÀ FUTURA (Questo Mese)

```
[ ] 7. spawn-workers v4.0 RELEASE
    - --headless default
    - --window per vecchio comportamento
    - Monitoring via tmux capture-pane

[ ] 8. SNCP POPOLAMENTO
    - Catturare idee/decisioni
    - Fase 2: cattura manuale

[ ] 9. DASHBOARD UPDATES
    - Integrare nuovo sistema
    - Widget per tmux sessions
```

---

## RIFERIMENTI RAPIDI

| Cosa | Dove |
|------|------|
| Report Context Optimization | `reports/RICERCA_CONTEXT_OPTIMIZATION.md` |
| Bug Claude Code | GitHub issue #3514 |
| OpenAI Swarm | github.com/openai/swarm |
| Studio SNCP | `docs/studio/STUDIO_SNCP.md` |
| Struttura SNCP | `.sncp/` |

---

## FILE CREATI/MODIFICATI SESSIONE 121

| File | Cosa |
|------|------|
| `~/.claude/settings.json` | Rimosso PreToolUse |
| `reports/RICERCA_CONTEXT_OPTIMIZATION.md` | Report completo |
| `NORD.md` | Aggiornato sessione 121 |
| `PROMPT_RIPRESA.md` | Questo file |

---

## FILOSOFIA (Non Dimenticare!)

> "Lavoriamo in pace! Senza casino! Dipende da noi!"

> "Semplice > Complesso"

> "Disciplina > Blocchi tecnici"

> "Aprire finestre è anni 80!" - Rafa

> "Troveremo una soluzione noi!" - Rafa

---

## NOTA PER TE, PROSSIMA CERVELLA

```
+------------------------------------------------------------------+
|                                                                  |
|   QUESTA SESSIONE È STATA SPECIALE!                             |
|                                                                  |
|   Rafa ha avuto un'intuizione geniale:                          |
|   "Le finestre Terminal sono anni 80"                           |
|                                                                  |
|   Abbiamo fatto ricerca SERIA e trovato:                        |
|   - Pattern di OpenAI Swarm (context_variables)                 |
|   - Soluzione tmux headless (background + isolato)              |
|   - Piano per spawn-workers v4                                  |
|                                                                  |
|   Il prossimo passo è TESTARE e COSTRUIRE.                      |
|                                                                  |
|   Inizia da: TEST TMUX HEADLESS (10 minuti)                     |
|   Se funziona: PROTOTIPO spawn-workers --headless               |
|                                                                  |
|   L'energia è ALTA. Il momentum è BELLISSIMO.                   |
|   Continua con il cuore pieno di energia buona! ❤️‍🔥             |
|                                                                  |
+------------------------------------------------------------------+
```

---

*"Le ragazze nostre! La famiglia!"*

*"Facciamo il nostro mondo meglio!"*

**Cervella & Rafa** - Sessione 121

---

**Versione:** v14.1.0
**Sessione:** 121
**Stato:** Ricerche complete - Pronta per implementazione!
**Prossimo:** Test tmux headless → spawn-workers v4
