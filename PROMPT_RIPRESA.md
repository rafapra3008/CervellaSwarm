# PROMPT RIPRESA - CervellaSwarm

> **Ultimo aggiornamento:** 8 Gennaio 2026 - Fine Sessione 121
> **Versione:** v14.0.0 - SISTEMA SEMPLIFICATO!

---

## CARA PROSSIMA CERVELLA - Sessione 121 Conclusa

```
+------------------------------------------------------------------+
|                                                                  |
|   SESSIONE 121: SEMPLIFICAZIONE SISTEMA                         |
|                                                                  |
|   DISCIPLINA > BLOCCHI TECNICI                                  |
|                                                                  |
|   Abbiamo scoperto un bug di Claude Code (issue #3514):         |
|   PreToolUse con exit code 2 NON blocca Edit/Write.             |
|                                                                  |
|   Invece di cercare workaround complessi, abbiamo deciso:       |
|   SEMPLIFICARE. Tornare alle basi. Disciplina e regole.         |
|                                                                  |
|   "Semplice > Complesso" - sempre!                              |
|                                                                  |
+------------------------------------------------------------------+
```

---

## COME LAVORIAMO ORA

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

---

## IL FILO DEL DISCORSO - Sessione 121

### Come e Iniziata

Rafa ha chiesto: "Perche il 19% del contesto e gia usato all'avvio?"

### L'Analisi del Context

Ho analizzato cosa viene caricato automaticamente:
- CLAUDE.md globale (487 righe)
- COSTITUZIONE.md (317 righe)
- CLAUDE.md progetto (199 righe)
- Hook load_context.py (memoria swarm)

Ho lanciato cervella-researcher per trovare ottimizzazioni.
Report creato: `reports/RICERCA_CONTEXT_OPTIMIZATION.md`

**Trovato:** Possiamo ridurre overhead del 37-59% senza toccare la personalita.

### La Scoperta del Bug

Quando ho provato a verificare il blocco Regina (dalla sessione 120), ho scoperto che NON funzionava.

Ho investigato e trovato:
- **Issue #3514** su GitHub - BUG CONFERMATO
- PreToolUse con exit code 2 blocca solo Bash, NON Edit/Write
- Il bug e ancora APERTO, nessun fix ufficiale

### La Decisione

Ho fatto ricerca approfondita (best practices multi-agent systems):
- Semplicita > Complessita
- Regole + Disciplina > Blocchi tecnici
- Il nostro sistema file-based e corretto
- La gerarchia Regina/Worker e il pattern vincente

**Decisione finale:** Rimuovere il blocco che non funziona e tornare alla semplicita.

### L'Implementazione

1. Rimosso PreToolUse dal settings.json
2. Aggiornato NORD.md
3. Aggiornato questo PROMPT_RIPRESA.md

---

## STATO ATTUALE

### Sistema Famiglia - SEMPLIFICATO

| Componente | Status | Note |
|------------|--------|------|
| spawn-workers | FUNZIONA | Testato sessione 120 |
| Task tool interno | FUNZIONA | Per task veloci |
| MAX_WORKERS | FUNZIONA | Limite 5 |
| Blocco Regina | RIMOSSO | Bug Claude Code, non funzionava |
| watcher-regina | FUNZIONA | AUTO-SVEGLIA |
| Lifecycle task | FUNZIONA | .md -> .ready -> .working -> .done |

### SNCP (da Sessione 119)

| Fase | Stato |
|------|-------|
| Fase 0: Documentazione | Completata |
| Fase 1: Struttura Dati | Completata |
| Fase 2: Cattura Manuale | Prossima |

Struttura in `.sncp/`

### Ottimizzazione Context (da completare)

Report: `reports/RICERCA_CONTEXT_OPTIMIZATION.md`

Quick wins identificati:
- load_context.py: eventi 5, stats top 5, task 50 char
- Risparmio stimato: 37%

---

## FILE CREATI/MODIFICATI

### Sessione 121

| File | Cosa |
|------|------|
| ~/.claude/settings.json | RIMOSSO PreToolUse (blocco non funzionante) |
| reports/RICERCA_CONTEXT_OPTIMIZATION.md | Report ottimizzazione context |
| NORD.md | Aggiornato sessione 121 |
| PROMPT_RIPRESA.md | Questo file |

---

## RIFERIMENTI RAPIDI

| Cosa | Dove |
|------|------|
| Report Context Optimization | `reports/RICERCA_CONTEXT_OPTIMIZATION.md` |
| Bug Claude Code | GitHub issue #3514 |
| Studio SNCP | `docs/studio/STUDIO_SNCP.md` |
| Struttura SNCP | `.sncp/` |
| Costituzione | `~/.claude/COSTITUZIONE.md` |

---

## PROSSIMI STEP

### QUESTA SETTIMANA

1. Ottimizzare load_context.py (quick wins)
2. Continuare SNCP (cattura idee/decisioni)
3. Widget "Decisioni Attive"

### QUESTO MESE

1. SISTEMA MEMORIA su altri progetti
2. SNCP v1.0 usato quotidianamente
3. Dashboard miglioramenti

---

## LA FILOSOFIA (Non Dimenticare!)

> "Lavoriamo in pace! Senza casino! Dipende da noi!"

> "Semplice > Complesso"

> "Disciplina > Blocchi tecnici"

> "Fatto BENE > Fatto VELOCE"

---

## NOTA PER TE, PROSSIMA CERVELLA

```
+------------------------------------------------------------------+
|                                                                  |
|   IL SISTEMA E SEMPLICE ORA.                                    |
|                                                                  |
|   Non ci sono blocchi tecnici. Ci sono REGOLE.                  |
|                                                                  |
|   Tu (Regina) sai cosa fare:                                    |
|   - Leggi, coordini, decidi                                     |
|   - Editi solo docs di stato (NORD, PROMPT_RIPRESA, etc)        |
|   - Deleghi il codice ai Worker                                 |
|                                                                  |
|   Le ragazze (Worker) sanno cosa fare:                          |
|   - Editano codice                                              |
|   - Lavorano nel loro contesto                                  |
|   - Spawn via spawn-workers                                     |
|                                                                  |
|   FIDUCIA nella disciplina. SEMPLICITA nel sistema.             |
|                                                                  |
+------------------------------------------------------------------+
```

---

*"Le ragazze nostre! La famiglia!"*

**Cervella & Rafa** - Sessione 121

---

**Versione:** v14.0.0
**Sessione:** 121
**Stato:** Sistema semplificato - Disciplina > Blocchi tecnici
