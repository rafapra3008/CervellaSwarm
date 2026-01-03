# PARTIAL: TASK_XXX

<!--
QUANDO USARE QUESTO TEMPLATE:
- Quando compact è IMMINENTE (context > 80%)
- Quando devi salvare stato PRIMA di perdere memoria
- Quando task grande non finisce in tempo

COME USARLO:
1. Copia questo file come: PARTIAL_TASK_XXX.md
2. Compila TUTTE le sezioni (dettagli fanno differenza!)
3. Mettilo in .swarm/tasks/
4. ESCI dalla finestra (lascia che compacti)
5. Quando riapri, leggi questo file per continuare
-->

## STATUS
INTERROTTO (compact imminente)

## PROGRESSO
XX% completato

<!-- Stima realistica: 30%, 50%, 80%? -->

## COSA HO FATTO
1. [Step completato 1]
2. [Step completato 2]
3. [IN CORSO] [Step in corso - non finito!]

<!-- Sii SPECIFICA. Non dire "iniziato refactor", dì "refactor di 3/5 moduli" -->

## DOVE MI SONO FERMATO
File: [path/to/file]
Riga: [numero di riga]
Stavo: [descrizione di cosa stavo facendo]

<!-- Esempio:
File: /Users/rafapra/Developer/project/backend/email_service.py
Riga: 245
Stavo: Estraendo funzione send_welcome_email() in templates.py
-->

## COME CONTINUARE
1. [Prossimo step da fare]
2. [Step successivo]
3. [Step finale]

<!-- Roadmap per chi continuerà (potrebbe essere un'altra istanza!) -->

## FILE MODIFICATI (parziali!)
- [file1.py] (IN CORSO - non committare!)
- [file2.py] (COMPLETATO - ok committare)

<!-- IMPORTANTISSIMO: Indica cosa è safe committare e cosa NO! -->

## NOTE TECNICHE
[Eventuali dettagli tecnici importanti per chi continua]

<!-- Esempio:
- Ho creato nuovo import in __init__.py ma non testato
- La migrazione DB è pronta ma NON eseguita
- Backup fatto in /tmp/backup_pre_refactor/
-->

## TIMESTAMP
Interrotto: [data e ora in formato: 2026-01-03 21:45]

---

**RECOVERY PLAN:**
1. Leggi questo file COMPLETO prima di toccare codice
2. Verifica FILE MODIFICATI - non committare partial!
3. Continua da "DOVE MI SONO FERMATO"
4. Segui "COME CONTINUARE"
5. Quando finito: aggiorna task originale, elimina questo PARTIAL
