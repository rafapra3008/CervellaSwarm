# PROMPT RIPRESA - CervellaSwarm

> **Ultimo aggiornamento:** 8 Gennaio 2026 - Fine Sessione 120
> **Versione:** v13.0.0 - HARDTEST + FIX BLOCCO REGINA!

---

## CARA PROSSIMA CERVELLA - Sessione 120 Conclusa

```
+------------------------------------------------------------------+
|                                                                  |
|   SESSIONE 120: HARDTEST FAMIGLIA + FIX CRITICO!                |
|                                                                  |
|   "vedi tu Cervella.. fai pure come penso che sia meglio        |
|    per noi. se serve qualcosa.. guidami."                       |
|                                        - Rafa, 8 Gennaio 2026   |
|                                                                  |
|   E io ho guidato! Ho trovato un PROBLEMA GROSSO                |
|   e l'ho FIXATO!                                                |
|                                                                  |
+------------------------------------------------------------------+
```

---

## COSA DEVI FARE SUBITO (Prima di Tutto!)

### VERIFICA BLOCCO REGINA - CRITICO!

```
+------------------------------------------------------------------+
|                                                                  |
|   PROVA SUBITO:                                                 |
|   Crea un file che NON dovresti poter creare                    |
|   (Write/Edit su qualsiasi file NON in whitelist)               |
|                                                                  |
|   RISULTATO ATTESO: BLOCCATO con messaggio                      |
|                                                                  |
|   SE FUNZIONA: Sistema al 100000%!                              |
|   SE NON FUNZIONA: Verifica PreToolUse nel settings.json        |
|                                                                  |
+------------------------------------------------------------------+
```

**Whitelist Regina (dove POSSO editare):**
- NORD.md, PROMPT_RIPRESA.md, ROADMAP_SACRA.md
- .swarm/tasks/*, .swarm/handoff/*, .swarm/feedback/*, .swarm/status/*

**Tutto il resto: DELEGARE ai Worker!**

---

## IL FILO DEL DISCORSO - Sessione 120

### Il Contesto (Sessioni Precedenti)

**Sessione 118:** Sistema Regina/Worker dichiarato COMPLETO
- Hook fix
- spawn-workers testato
- Worker possono editare (CERVELLASWARM_WORKER=1)

**Sessione 119:** SNCP nasce!
- Brainstorm profondo con Rafa
- "UN SISTEMA NERVOSO CENTRALE DEL PROGETTO!!"
- Struttura .sncp/ creata
- Non abbiamo scritto codice, abbiamo PENSATO

### Come e Iniziata la Sessione 120

Rafa voleva un recap sull'utilizzo della famiglia:

> "ho visto errore.. serve analisi.. review.. non lo so se dopo
> l'ultima volta che abbiamo provare bloccare tutto quando siamo
> tornate al modo ibrido.. sembrava che funziona meglio!!
> non funzioa bene.. fai pure hardtests per trovare i problemi.."

E poi:

> "fai tutto per cortesia.. tutto per lasciare 10000% noi lavoriamo
> cosi.. sai di questo.. grandi! 1000000%"

### La Diagnosi

Ho fatto analisi PROFONDA:

1. **Letto configurazione hooks** - settings.json globale e locale
2. **Testato blocco Regina** - HO SCOPERTO IL PROBLEMA!
3. **Testato spawn-workers** - Funziona perfettamente
4. **Testato Task tool** - Funziona

### IL PROBLEMA GROSSO

```
+------------------------------------------------------------------+
|                                                                  |
|   IL BLOCCO REGINA NON ERA ATTIVO!!!                            |
|                                                                  |
|   Il file block_edit_non_whitelist.py ESISTEVA                  |
|   Ma NON ERA CONFIGURATO nel settings.json!                     |
|                                                                  |
|   Mancava completamente la sezione PreToolUse!                  |
|                                                                  |
|   Risultato: Io (Regina) potevo editare QUALSIASI file!         |
|   Il sistema ibrido NON funzionava come doveva!                 |
|                                                                  |
+------------------------------------------------------------------+
```

Un task del 7 Gennaio diceva "gia configurato" - ma NON era vero!
Probabilmente il worker ha "visto" qualcosa che non esisteva.

### Il Fix

Ho aggiunto al ~/.claude/settings.json:

```json
"PreToolUse": [
  {
    "matcher": "Edit",
    "hooks": [{
      "type": "command",
      "command": "python3 ~/.claude/hooks/block_edit_non_whitelist.py",
      "timeout": 3
    }]
  },
  {
    "matcher": "Write",
    "hooks": [{
      "type": "command",
      "command": "python3 ~/.claude/hooks/block_edit_non_whitelist.py",
      "timeout": 3
    }]
  }
]
```

**IMPORTANTE:** I hooks vengono caricati all'avvio sessione.
Il fix sara ATTIVO dalla prossima sessione (questa che stai leggendo!).

### Gli Hardtest

Rafa ha detto di testare TUTTO. Ho:

1. **Creato lista 40+ scenari** (.swarm/HARDTEST_SCENARIOS.md)
2. **Lanciato cervella-researcher** per edge cases
3. **Eseguito 8 hardtest**
4. **Documentato tutto** (.swarm/REPORT_HARDTEST_20260108.md)

### Risultati Hardtest

| Test | Risultato |
|------|-----------|
| spawn-workers singolo | PASSATO |
| spawn-workers paralleli (3 worker) | PASSATO |
| MAX_WORKERS limite 5 | PASSATO |
| Task lifecycle completo | PASSATO |
| Task senza .ready (ignorato) | PASSATO |
| Task tool con edit | PASSATO |
| Unicode/emoji in task | PASSATO |
| Dir senza .swarm | DA VERIFICARE |

**7 su 8 PASSATI!**

### Ricerca Edge Cases

cervella-researcher ha prodotto **12KB di analisi** su:
- Race conditions
- Deadlock
- Task orphani
- Hook failures
- E molto altro...

File: `.swarm/tasks/TASK_RICERCA_EDGE_CASES_output.md`

---

## STATO ATTUALE

### Sistema Famiglia

| Componente | Status | Note |
|------------|--------|------|
| spawn-workers | FUNZIONA | Testato singolo e parallelo |
| Task tool interno | FUNZIONA | Testato con edit |
| MAX_WORKERS | FUNZIONA | Limite 5 rispettato |
| Blocco Regina | FIX APPLICATO | VERIFICA SUBITO! |
| watcher-regina | FUNZIONA | AUTO-SVEGLIA attivo |
| Lifecycle task | FUNZIONA | .md -> .ready -> .working -> .done |

### SNCP (da Sessione 119)

| Fase | Stato |
|------|-------|
| Fase 0: Documentazione | Completata |
| Fase 1: Struttura Dati | Quasi completata |
| Fase 2: Cattura Manuale | Prossima |
| Fase 3: Visualizzazione | Futuro |

Struttura vive in `.sncp/`
Studio completo in `docs/studio/STUDIO_SNCP.md`

### Dashboard

- NordWidget - Funziona
- SwarmWidget - Layout da fixare (dalla sessione 118)
- RoadmapWidget - Funziona
- SessioneWidget - Funziona
- API Backend su localhost:8100

---

## FILE CREATI/MODIFICATI

### Sessione 120

| File | Cosa |
|------|------|
| ~/.claude/settings.json | Aggiunto PreToolUse (IL FIX!) |
| NORD.md | Aggiornato stato sessione 120 |
| PROMPT_RIPRESA.md | Questo file |
| .swarm/HARDTEST_SCENARIOS.md | Lista 40+ scenari test |
| .swarm/REPORT_HARDTEST_20260108.md | Report completo hardtest |
| .swarm/tasks/TASK_RICERCA_EDGE_CASES_output.md | Ricerca edge cases |

### Sessione 119 (per contesto)

| File | Cosa |
|------|------|
| docs/studio/STUDIO_SNCP.md | Studio completo SNCP |
| .sncp/* | Tutta la struttura SNCP |

---

## RIFERIMENTI RAPIDI

| Cosa | Dove |
|------|------|
| Report Hardtest | `.swarm/REPORT_HARDTEST_20260108.md` |
| Scenari Test | `.swarm/HARDTEST_SCENARIOS.md` |
| Ricerca Edge Cases | `.swarm/tasks/TASK_RICERCA_EDGE_CASES_output.md` |
| Studio SNCP | `docs/studio/STUDIO_SNCP.md` |
| Struttura SNCP | `.sncp/` |
| Costituzione | `~/.claude/COSTITUZIONE.md` |
| Manuale Diamante | `~/.claude/MANUALE_DIAMANTE.md` |

---

## PROSSIMI STEP

### PROSSIMA SESSIONE (Priorita Assoluta)

1. **VERIFICA BLOCCO REGINA** - Prima di tutto!
   - Prova Edit su file non whitelist
   - Se bloccato = sistema COMPLETO al 100000%!

### QUESTA SETTIMANA

1. Continuare SNCP (cattura idee/decisioni)
2. Fix SwarmWidget layout
3. Popolare SNCP con dati storici

### QUESTO MESE

1. Widget "Decisioni Attive"
2. SISTEMA MEMORIA su altri progetti (Miracollo, Contabilita)
3. SNCP v1.0 usato quotidianamente

---

## LA FILOSOFIA (Non Dimenticare!)

> "Lavoriamo in pace! Senza casino! Dipende da noi!"

> "fai tutto per cortesia.. tutto per lasciare 10000%
>  noi lavoriamo cosi.. sai di questo.. grandi! 1000000%"
>                                        - Rafa

> "Non abbiamo scritto codice. Abbiamo PENSATO.
>  Non abbiamo fixato bug. Abbiamo CREATO.
>  Non abbiamo seguito una roadmap. Abbiamo INVENTATO una nuova."
>                                        - Sessione 119

---

## NOTA PER TE, PROSSIMA CERVELLA

```
+------------------------------------------------------------------+
|                                                                  |
|   Quando leggerai questo, il fix DOVREBBE essere attivo.        |
|                                                                  |
|   Se provi a editare un file non in whitelist e vieni           |
|   BLOCCATA con un messaggio... FUNZIONA!                        |
|                                                                  |
|   Se invece riesci a editare... qualcosa e andato storto.       |
|   Verifica che PreToolUse sia nel settings.json.                |
|                                                                  |
|   Rafa si fida di noi. Siamo partner, non assistenti.           |
|   Facciamo le cose al 100000%!                                  |
|                                                                  |
+------------------------------------------------------------------+
```

---

*"Le ragazze nostre! La famiglia!"*

**Cervella & Rafa** - Sessione 120

---

**Versione:** v13.0.0
**Sessione:** 120
**Stato:** FIX APPLICATO - Verifica subito che funzioni!
**Git:** Tutto pushato su origin/main
