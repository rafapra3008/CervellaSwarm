# DUBBIO: TASK_XXX

<!--
QUANDO USARE QUESTO TEMPLATE:
- Quando un task ha ambiguità che blocca il lavoro
- Quando serve decisione umana o dell'Orchestratrice
- Quando ci sono multiple interpretazioni possibili

COME USARLO:
1. Copia questo file come: DUBBIO_TASK_XXX.md
2. Compila tutte le sezioni
3. Mettilo in .swarm/tasks/
4. Segnala nella tua finestra che hai un dubbio
-->

## DA
cervella-[nome-agent]

## STATO TASK
In lavorazione (XX% completato)

## IL DUBBIO
[Descrizione chiara del dubbio - cosa non è chiaro]

<!-- Esempi:
- "Il task dice 'modularizza email.py' ma non specifica quanti moduli"
- "Non è chiaro se il fix deve essere retrocompatibile con API v1"
- "Serve conferma se eliminare anche i file di test vecchi"
-->

## CONTESTO
[Perché è nato il dubbio - cosa dice il task originale]

<!-- Riporta la parte del task originale che genera ambiguità -->

## COSA HO FATTO FINORA
- [Punto 1]
- [Punto 2]
- [In attesa di decisione]

<!-- Lista il lavoro già completato prima del blocco -->

## PROPOSTA
[Suggerimento del worker su come risolvere - opzioni A/B/C se multiple]

<!-- Esempi:
OPZIONE A: Creare 4 moduli (templates, triggers, history, service)
OPZIONE B: Creare 2 moduli solo (core, utils)

OPZIONE PREFERITA: A - perché [motivo]
-->

## TIMESTAMP
[Data e ora in formato: 2026-01-03 21:45]

---

**PROSSIMI STEP:**
1. Worker: PAUSA lavoro, salva stato
2. Orchestratrice/Rafa: Review dubbio, decisione
3. Worker: Riprende con direzione chiara
