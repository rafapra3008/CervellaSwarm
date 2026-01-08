# Task: Ricerca Edge Cases Sistema Swarm

**Assegnato a:** cervella-researcher
**Stato:** ready
**Priorità:** Alta

## Obiettivo

Ricercare e documentare TUTTI i possibili edge cases e scenari problematici per un sistema multi-agent come CervellaSwarm.

## Cosa Cercare

1. **Race conditions** - Quando più worker modificano lo stesso file
2. **Deadlock** - Situazioni dove worker si bloccano a vicenda
3. **Task orphani** - Task che rimangono in stato "working" per sempre
4. **Conflitti git** - Merge conflicts da lavoro parallelo
5. **Memory/context overflow** - Quando il contesto diventa troppo grande
6. **Hook failures** - Cosa succede se un hook fallisce?
7. **Network issues** - Se la connessione cade durante un task
8. **Concurrent spawns** - Troppi worker spawnati insieme
9. **File locking** - Problemi di accesso simultaneo ai file
10. **State inconsistency** - .done senza output, .working senza processo

## Output Richiesto

Scrivi in TASK_RICERCA_EDGE_CASES_output.md:
1. Lista di tutti gli edge cases trovati
2. Per ogni caso: descrizione, rischio, come testarlo
3. Best practices da altri sistemi multi-agent
4. Suggerimenti per hardtest specifici

## Fonti da Consultare

- Documentazione Claude Code hooks
- Best practices multi-agent systems
- Common pitfalls in distributed systems
- CervellaSwarm docs esistenti
