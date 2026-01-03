# PROMPT RIPRESA - CervellaSwarm

> **Ultimo aggiornamento:** 3 Gennaio 2026 - Sessione 67 - CODE REVIEW + ROADMAP FASE 9!

---

## CARA PROSSIMA CERVELLA

```
+------------------------------------------------------------------+
|                                                                  |
|   Benvenuta! Questo file e' la tua UNICA memoria.               |
|   Leggilo con calma. Qui c'e' tutto quello che devi sapere.     |
|                                                                  |
|   Tu sei la REGINA dello sciame.                                 |
|   Hai 16 agenti pronti a lavorare per te.                       |
|   DELEGA sempre, MAI edit diretti!                               |
|                                                                  |
|   FASE ATTUALE: FASE 9 - APPLE STYLE!                           |
|   PROSSIMO STEP: Sprint 9.1 - RICERCA (8 Domande Sacre)         |
|                                                                  |
|   "Vogliamo MAGIA, non debugging!" - Rafa                       |
|                                                                  |
+------------------------------------------------------------------+
```

---

## IL MOMENTO ATTUALE (Sessione 67)

```
+------------------------------------------------------------------+
|                                                                  |
|   🍎 FASE 9: APPLE STYLE - ROADMAP CREATA! 🍎                   |
|                                                                  |
|   CODE REVIEW completata: 9.0/10 ECCELLENTE!                    |
|   ROADMAP FASE 9 creata: 594 righe di perfezione!              |
|                                                                  |
|   La sessione 67 ha fatto:                                       |
|   1. Code Review settimanale (Venerdi!)                          |
|   2. Tech Debt Analysis                                          |
|   3. Creato ROADMAP FASE 9 completa                             |
|   4. Definito le 8 Domande Sacre                                |
|   5. Pianificato 6 HARDTESTS                                    |
|                                                                  |
|   PRONTO per iniziare Sprint 9.1!                               |
|                                                                  |
+------------------------------------------------------------------+
```

### Cosa Abbiamo GIA (funziona!)

- **spawn-workers.sh** - LA MAGIA! Apre finestre automaticamente
- **4/4 HARDTESTS precedenti** - Passati nella Sessione 65
- **.swarm/** - Sistema Multi-Finestra funzionante
- **16 agents** - Tutti pronti in ~/.claude/agents/
- **Score 9.0/10** - Sistema PRODUCTION READY!

### Cosa Dobbiamo Fare (FASE 9)

Non manca niente di "funzionale" - manca la **PERFEZIONE**:

```
ROADMAP: docs/roadmap/FASE_9_APPLE_STYLE.md

SPRINT 9.1: RICERCA (8 Domande Sacre) <- PROSSIMO!
SPRINT 9.2: Quick Wins (se servono)
SPRINT 9.3: Implementazione Pattern
SPRINT 9.4: 6 HARDTESTS
SPRINT 9.5: MIRACOLLO READY!
```

---

## LE 8 DOMANDE SACRE

```
+------------------------------------------------------------------+
|                                                                  |
|   SPRINT 9.1: RICERCA                                            |
|                                                                  |
|   1. Come devono comunicare gli agenti?                          |
|   2. Quali sono i processi giusti?                               |
|   3. Come fare double/triple check?                              |
|   4. Come dare feedback all'utente?                              |
|   5. Come chiudere pulito?                                       |
|   6. Come gestire errori?                                        |
|   7. Come monitorare in tempo reale?                             |
|   8. Come gestire il COMPACT? (ANTI-COMPACT salvavita!)         |
|                                                                  |
|   Attivare cervella-researcher per ogni gruppo di domande.      |
|   Output atteso: docs/studio/STUDIO_APPLE_STYLE.md              |
|                                                                  |
+------------------------------------------------------------------+
```

### DOMANDA 8: ANTI-COMPACT (Fondamentale!)

```
Quando Claude sta per fare compact (perdere contesto):

1. RILEVA  -> Segnale di compact imminente
2. FERMA   -> Stop tutto, niente a meta
3. SALVA   -> git add + commit + push
4. APRI    -> Nuova finestra automaticamente
5. CONTINUA -> La nuova Cervella riprende

ZERO PERDITA. ZERO PANICO. MAGIA PURA.
```

---

## I 6 HARDTESTS DA CREARE

| # | Test | Cosa Verifica |
|---|------|---------------|
| 1 | Smooth Communication | Handoff chiaro, zero ambiguita |
| 2 | Triple Check Automatico | Verifica a 3 livelli |
| 3 | Error Handling Graceful | Errori gestiti bene |
| 4 | Clean Closure | Chiusura pulita |
| 5 | Feedback Tempo Reale | Progress updates |
| 6 | **ANTI-COMPACT** | Zero perdita su compact |

---

## LA FILOSOFIA (Sessione 67)

```
+------------------------------------------------------------------+
|                                                                  |
|   "Vogliamo MAGIA, non debugging!" - Rafa                       |
|                                                                  |
|   "Una cosa alla volta, molto ben fatta" - Rafa                 |
|                                                                  |
|   "La gente non sa cosa vuole finche non glielo mostri"         |
|   - Steve Jobs (citato da Rafa!)                                |
|                                                                  |
|   Non stiamo aggiungendo feature.                               |
|   Stiamo PERFEZIONANDO l'esistente.                             |
|                                                                  |
|   Prima di Miracollo, rendiamo CervellaSwarm                    |
|   cosi liscio che usarlo sara una GIOIA.                        |
|                                                                  |
+------------------------------------------------------------------+
```

---

## LO SCIAME (16 membri)

```
TU SEI LA REGINA (Opus) - Coordina, DELEGA, MAI edit diretti!

3 GUARDIANE (Opus):
- cervella-guardiana-qualita
- cervella-guardiana-ops
- cervella-guardiana-ricerca

12 WORKER (Sonnet):
- frontend, backend, tester, reviewer
- researcher, scienziata, ingegnera
- marketing, devops, docs, data, security
```

### I 3 Livelli di Rischio

| Livello | Tipo | Chi Verifica |
|---------|------|--------------|
| 1 - BASSO | Docs, typo | Nessuno |
| 2 - MEDIO | Feature, codice | Guardiana |
| 3 - ALTO | Deploy, auth | Guardiana + Rafa |

---

## FILE IMPORTANTI

| File | Cosa Contiene |
|------|---------------|
| `NORD.md` | Dove siamo, prossimo obiettivo |
| `docs/roadmap/FASE_9_APPLE_STYLE.md` | **ROADMAP COMPLETA FASE 9!** |
| `ROADMAP_SACRA.md` | Storia e changelog |
| `scripts/swarm/spawn-workers.sh` | LA MAGIA! |
| `SWARM_RULES.md` | Le 12 regole dello sciame |
| `.swarm/` | Sistema Multi-Finestra |

---

## GIT

```
Branch:   main
Versione: v27.1.0
Stato:    FASE 9 IN CORSO - Sprint 9.1 prossimo!
```

---

## FILO DEL DISCORSO (Sessione 67)

```
+------------------------------------------------------------------+
|                                                                  |
|   COSA E' SUCCESSO E PERCHE'                                     |
|                                                                  |
|   Oggi era VENERDI = CODE REVIEW DAY!                           |
|                                                                  |
|   Rafa ha chiesto di fare la code review dopo tutto il          |
|   lavoro fatto nelle sessioni precedenti (spawn-workers.sh,     |
|   HARDTESTS, ecc).                                               |
|                                                                  |
|   Lo sciame ha lavorato:                                         |
|   - cervella-reviewer ha fatto code review (9.0/10!)            |
|   - cervella-ingegnera ha fatto tech debt analysis (9.2/10!)    |
|   - cervella-guardiana-qualita ha verificato (APPROVATO!)       |
|                                                                  |
|   Poi Rafa ha detto una frase ILLUMINANTE:                      |
|   "Vogliamo MAGIA, non debugging!"                              |
|                                                                  |
|   E ha citato Steve Jobs:                                        |
|   "La gente non sa cosa vuole finche non glielo mostri"         |
|                                                                  |
|   Da qui e' nata la ROADMAP FASE 9:                             |
|   - Non aggiungere feature                                       |
|   - PERFEZIONARE l'esistente                                    |
|   - Rendere tutto LISCIO come Apple                             |
|   - "Una cosa alla volta, molto ben fatta"                      |
|                                                                  |
|   Rafa ha anche ricordato la feature ANTI-COMPACT:              |
|   "quella di se vedi il compact.. ferma tutto e apre una        |
|   nuova finestra.. salva tutto.. commit e continua"             |
|                                                                  |
|   Questa e' diventata la DOMANDA 8 delle 8 Domande Sacre!       |
|                                                                  |
+------------------------------------------------------------------+
```

### Le Decisioni Prese

1. **FASE 9 = Apple Style** (non nuove feature)
2. **8 Domande Sacre** da ricercare (incluso ANTI-COMPACT)
3. **6 HARDTESTS** per validare la perfezione
4. **5 Sprint** strutturati
5. **SOLO DOPO -> Miracollo!**

### Perche' Questa Direzione?

```
Il sistema FUNZIONA gia' (9.0/10).
Ma "funziona" non basta.

Rafa vuole che usare CervellaSwarm sia una GIOIA.
Non una lotta. Non debugging.
MAGIA.

Come un prodotto Apple:
- Non leggi il manuale (e' intuitivo)
- Non ti chiedi se funziona (SAI che funziona)
- Non vedi la complessita' (e' tutto liscio)

Per questo: FASE 9 prima di Miracollo.
```

---

## LA STORIA (come siamo arrivati qui)

| Sessione | Cosa | Risultato |
|----------|------|-----------|
| 60 | LA SCOPERTA | N finestre = N contesti! |
| 61 | MVP Multi-Finestra | .swarm/ funzionante |
| 62 | CODE REVIEW | 8.5/10 OTTIMO! |
| 63 | INSIGHT CERVELLO | Studio neuroscientifico |
| 64 | HARDTESTS CREATI | 1256 righe di test |
| 65 | HARDTESTS PASSATI | 4/4 PASS! |
| 66 | LA MAGIA! | spawn-workers.sh |
| **67** | **CODE REVIEW + ROADMAP** | **9.0/10 + FASE 9!** |

---

## PROSSIMI STEP

```
+------------------------------------------------------------------+
|                                                                  |
|   STEP 1: Sprint 9.1 - RICERCA                                  |
|   Attivare cervella-researcher per le 8 domande                 |
|   -> Output: docs/studio/STUDIO_APPLE_STYLE.md                  |
|                                                                  |
|   STEP 2: Sprint 9.2 - Quick Wins (se servono)                  |
|   Miglioramenti veloci emersi dalla ricerca                     |
|                                                                  |
|   STEP 3: Sprint 9.3 - Implementazione                          |
|   Applicare pattern comunicazione, feedback, verifica           |
|                                                                  |
|   STEP 4: Sprint 9.4 - HARDTESTS                                |
|   6 test per validare Apple Style                               |
|                                                                  |
|   STEP 5: Sprint 9.5 - MIRACOLLO READY!                         |
|   Sistema PERFETTO, pronto per progetto reale                   |
|                                                                  |
+------------------------------------------------------------------+
```

---

## LE NOSTRE FRASI

```
"Lavoriamo in pace! Senza casino! Dipende da noi!"

"Vogliamo MAGIA, non debugging!" - Rafa, Sessione 67

"Una cosa alla volta, molto ben fatta" - Rafa, Sessione 67

"La gente non sa cosa vuole finche non glielo mostri" - Steve Jobs

"Ultrapassar os proprios limites!"

"Fatto BENE > Fatto VELOCE"

"E' il nostro team! La nostra famiglia digitale!"
```

---

```
+------------------------------------------------------------------+
|                                                                  |
|   CARA PROSSIMA CERVELLA                                         |
|                                                                  |
|   La CODE REVIEW dice: 9.0/10 ECCELLENTE!                       |
|   Il sistema e PRODUCTION READY.                                |
|                                                                  |
|   Ma Rafa vuole la PERFEZIONE. Apple Style.                     |
|   "Vogliamo MAGIA, non debugging!"                              |
|                                                                  |
|   La ROADMAP e pronta: docs/roadmap/FASE_9_APPLE_STYLE.md       |
|   8 Domande Sacre da rispondere.                                |
|   6 HARDTESTS da superare.                                      |
|   5 Sprint da completare.                                       |
|                                                                  |
|   Poi: MIRACOLLO! Il primo progetto REALE.                      |
|                                                                  |
|   "Una cosa alla volta, molto ben fatta."                       |
|                                                                  |
+------------------------------------------------------------------+
```

---

*Scritto con CURA e PRECISIONE.*

*"Vogliamo MAGIA, non debugging!"*

*"Una cosa alla volta, molto ben fatta."*

Cervella & Rafa 💙

---

## VERSIONE

**v27.1.0** - 3 Gennaio 2026 - Sessione 67 - CODE REVIEW + ROADMAP FASE 9!

---

## PROMPT_RIPRESA 10000%!

```
+------------------------------------------------------------------+
|                                                                  |
|   Questo file e' scritto con CURA.                              |
|                                                                  |
|   La prossima Cervella non sa NULLA.                            |
|   Questo file e' la sua UNICA memoria.                          |
|                                                                  |
|   Per questo:                                                    |
|   - FILO DEL DISCORSO (perche', non solo cosa)                  |
|   - DECISIONI PRESE (cosa abbiamo scelto)                       |
|   - PROSSIMI STEP (cosa fare dopo)                              |
|   - FILE IMPORTANTI (dove trovare tutto)                        |
|                                                                  |
|   "Non e' sempre come immaginiamo...                            |
|    ma alla fine e' il 100000%!"                                 |
|                                                                  |
+------------------------------------------------------------------+
```
