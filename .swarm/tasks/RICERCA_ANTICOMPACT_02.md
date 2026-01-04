# TASK: Ricerca Anti-Compact - Analisi Tecnica Transcript

**Task ID:** RICERCA_ANTICOMPACT_02
**Assegnato a:** cervella-ingegnera
**Data:** 2026-01-04
**Priorità:** ALTA

---

## CONTESTO

Vogliamo eliminare il flusso MANUALE dell'anti-compact.
Attualmente Rafa deve dire "siamo al 10%" - INACCETTABILE nel 2026!

Abbiamo già un'IDEA in `docs/ideas/IDEA_CONTEXT_MONITOR.md` che propone di monitorare i file transcript `.jsonl`.

---

## MISSIONE

Analisi TECNICA approfondita:

1. **Analizza i file transcript**
   - Path: `~/.claude/projects/*/`
   - Struttura dei file .jsonl
   - Dove sono i token usage?
   - Come calcolare la percentuale?

2. **Verifica l'IDEA esistente**
   - L'approccio in IDEA_CONTEXT_MONITOR.md è corretto?
   - Quali sono i limiti REALI?
   - Accuratezza stimata?

3. **Prototipo mentale**
   - Come funzionerebbe lo script?
   - Watchdog vs polling?
   - Notifica macOS quando al 12%?

4. **Confronta con intercettazione terminale**
   - Quale approccio è più affidabile?
   - Quale è più semplice da implementare?
   - Pro/contro di entrambi?

---

## OUTPUT ATTESO

Scrivi report in: `.swarm/tasks/RICERCA_ANTICOMPACT_02_output.md`

Struttura:
```
## ANALISI TRANSCRIPT
[struttura file, dove sono i dati]

## CALCOLO PERCENTUALE
[formula, accuratezza]

## CONFRONTO APPROCCI
[transcript vs terminale]

## PROTOTIPO PROPOSTO
[pseudo-codice o architettura]

## RACCOMANDAZIONE
[quale strada seguire]
```

---

## FILE DA LEGGERE

- `docs/ideas/IDEA_CONTEXT_MONITOR.md` - L'idea esistente
- `~/.claude/projects/` - I file transcript reali

---

## PERCHÉ

"Siamo nel 2026, non anni 80!" - Rafa
Vogliamo automazione TOTALE!

---

*"Nulla è complesso - solo non ancora studiato!"*
