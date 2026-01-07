# SUB-ROADMAP: COMUNICAZIONE INTERNA

> **Priorità:** ALTISSIMA - Direzione da Rafa!
> **Data Avvio:** 7 Gennaio 2026 - Sessione 113
> **Stato:** 4/7 FASI COMPLETATE! (67%)
> **Obiettivo:** "La comunicazione interna deve essere meglio!"

## PROGRESS

```
✅ FASE 1: Studio Protocolli (1,385 righe - cervella-researcher)
✅ FASE 2: Definizione Protocolli (736 righe - Regina)
✅ FASE 3: Templates Operativi (1,797 righe - cervella-docs)
✅ FASE 4: Scripts Implementazione (650 righe - cervella-devops)
⏸️  FASE 5: Aggiornamento DNA Agenti (pending)
⏸️  FASE 6: HARDTEST Comunicazione v2 (pending)
⏸️  FASE 7: Documentazione e Training (pending)

TOTALE PRODOTTO: 4,568+ righe in Sessione 113!
```

---

## LA VISIONE

```
+------------------------------------------------------------------+
|                                                                  |
|   "LA COMUNICAZIONE INTERNA DEVE ESSERE MEGLIO!"                |
|                                       - Rafa, 7 Gennaio 2026     |
|                                                                  |
|   SIGNIFICA:                                                     |
|   - Come parlano le api tra loro?                               |
|   - Protocolli più chiari                                       |
|   - Il flusso Regina -> Worker -> Regina                        |
|   - Handoff, feedback, stati                                    |
|                                                                  |
|   L'obiettivo è che le api COMUNICHINO in modo:                 |
|   - CHIARO (niente ambiguità)                                   |
|   - COMPLETO (tutte le info necessarie)                         |
|   - VERIFICABILE (stato sempre visibile)                        |
|   - FLUIDO (senza attriti)                                      |
|                                                                  |
+------------------------------------------------------------------+
```

---

## COSA ABBIAMO GIÀ

| Esistente | Dove | Funziona? |
|-----------|------|-----------|
| spawn-workers | ~/.local/bin/spawn-workers | ✅ Apre finestre |
| .swarm/tasks/ | Template task | ✅ Struttura base |
| watcher-regina.sh | Script sveglia | ⚠️ Da migliorare |
| SWARM_RULES.md | 13 regole | ✅ Regole base |
| GUIDA_COMUNICAZIONE.md | docs/guide/ | ✅ Linee guida |

---

## COSA MANCA (IL PROBLEMA!)

```
+------------------------------------------------------------------+
|                                                                  |
|   PROBLEMA 1: HANDOFF non strutturato                           |
|   - Regina passa task a Worker... ma come?                      |
|   - Worker finisce... ma Regina sa COSA è stato fatto?          |
|   - Serve: TEMPLATE HANDOFF chiaro                              |
|                                                                  |
+------------------------------------------------------------------+
|                                                                  |
|   PROBLEMA 2: FEEDBACK LOOP poco chiaro                         |
|   - Worker ha dubbi? Come chiede aiuto?                         |
|   - Worker trova problema? Come lo comunica?                    |
|   - Serve: PROTOCOLLO FEEDBACK strutturato                      |
|                                                                  |
+------------------------------------------------------------------+
|                                                                  |
|   PROBLEMA 3: STATI non visibili                                |
|   - Worker sta lavorando? È bloccato? Ha finito?                |
|   - Regina deve SAPERE senza chiedere                           |
|   - Serve: SISTEMA STATI real-time                              |
|                                                                  |
+------------------------------------------------------------------+
|                                                                  |
|   PROBLEMA 4: CONTEXT TRANSFER inefficiente                     |
|   - Regina sa tutto il contesto                                 |
|   - Worker riceve... quanto? Troppo? Poco?                      |
|   - Serve: PROTOCOLLO CONTEXT ottimizzato                       |
|                                                                  |
+------------------------------------------------------------------+
```

---

## LE FASI

### FASE 1: STUDIO E RICERCA

**Chi:** cervella-researcher (spawn-workers!)

**Domande da rispondere:**

1. **Protocolli Comunicazione Multi-Agent**
   - Come comunicano sistemi multi-agent esistenti?
   - Quali pattern funzionano meglio?
   - Handoff, feedback loop, stati - best practices

2. **Context Transfer**
   - Quanto contesto serve passare a un worker?
   - Come strutturare le info (JSON, markdown, mix)?
   - Trade-off: troppo = overhead, poco = inefficiente

3. **Real-time Status**
   - Come monitorare worker senza interruzioni?
   - Heartbeat? Progress file? Log streaming?
   - Come notificare Regina automaticamente?

4. **Error Handling**
   - Worker bloccato - cosa fare?
   - Worker trova bug - come escalare?
   - Timeout, retry, fallback

**Output:** Studio completo in docs/studio/STUDIO_COMUNICAZIONE_PROTOCOLLI.md

**Tempo stimato:** 2-3 ore ricerca

---

### FASE 2: DEFINIZIONE PROTOCOLLI

**Chi:** Regina (io!) + cervella-docs per scrivere

**Cosa definire:**

1. **PROTOCOLLO HANDOFF**
   ```
   Regina -> Worker:
   - Task description (cosa fare)
   - Context (cosa sapere)
   - Success criteria (come capire se finito bene)
   - Constraints (limiti, regole)
   - Output format (dove/come scrivere risultato)
   ```

2. **PROTOCOLLO FEEDBACK**
   ```
   Worker -> Regina:
   - Progress updates (ogni X minuti o milestone)
   - Questions (se ha dubbi)
   - Issues (se trova problemi)
   - Completion (quando finisce)
   ```

3. **PROTOCOLLO STATI**
   ```
   Stati possibili:
   - READY (worker pronto)
   - WORKING (task in corso)
   - BLOCKED (ha bisogno aiuto)
   - COMPLETED (finito con successo)
   - FAILED (finito con errore)

   Come tracciare:
   - File .swarm/status/worker_X.status
   - Formato: timestamp|worker|stato|task|note
   ```

4. **PROTOCOLLO CONTEXT**
   ```
   Cosa includere sempre:
   - NORD.md (dove siamo)
   - Task specifico (cosa fare)
   - File rilevanti (dove guardare)

   Cosa NON includere:
   - Storico completo (troppo)
   - File non correlati (rumore)
   ```

**Output:** docs/protocolli/PROTOCOLLI_COMUNICAZIONE.md

**Tempo stimato:** 3-4 ore definizione + scrittura

---

### FASE 3: TEMPLATE OPERATIVI

**Chi:** cervella-docs (spawn-workers!)

**Template da creare:**

1. **TEMPLATE_HANDOFF.md**
   - Struttura standard per passare task
   - Sezioni: Task, Context, Success Criteria, Output
   - Esempi per ogni tipo di task (backend, frontend, ricerca, etc.)

2. **TEMPLATE_FEEDBACK.md**
   - Come worker comunica progresso
   - Formato update, question, issue, completion
   - Esempi reali

3. **TEMPLATE_STATUS.md**
   - Formato file status
   - Come aggiornare stato
   - Script helper per worker

4. **TEMPLATE_COMPLETION_REPORT.md**
   - Formato report finale
   - Cosa fatto, problemi incontrati, decisioni prese
   - File modificati, test eseguiti, next steps

**Output:** Template pronti in .swarm/templates/

**Tempo stimato:** 2-3 ore

---

### FASE 4: IMPLEMENTAZIONE SCRIPTS

**Chi:** cervella-devops (spawn-workers!)

**Script da creare/migliorare:**

1. **handoff-task.sh**
   - Script per Regina: crea handoff strutturato
   - Input: tipo worker, descrizione task
   - Output: file .swarm/handoff/TASK_XXX.md pronto

2. **update-status.sh**
   - Script per Worker: aggiorna stato
   - Input: nuovo stato, note opzionali
   - Output: file .swarm/status/ aggiornato + notifica Regina

3. **ask-regina.sh**
   - Script per Worker: invia domanda a Regina
   - Input: tipo (question/issue/blocker)
   - Output: crea file .swarm/feedback/ + notifica

4. **completion-report.sh**
   - Script per Worker: crea report finale
   - Raccoglie: file modificati (git), decisioni, problemi
   - Output: report strutturato

5. **regina-monitor.sh** (miglioramento!)
   - Dashboard ASCII per Regina
   - Mostra: worker attivi, stati, task in corso
   - Aggiorna ogni 2 secondi

**Output:** Script funzionanti in scripts/swarm/

**Tempo stimato:** 4-5 ore

---

### FASE 5: AGGIORNAMENTO DNA AGENTI

**Chi:** Regina (io!) - edit diretto su whitelist

**Cosa aggiornare:**

1. **cervella-orchestrator.md** (io!)
   - Nuovi protocolli comunicazione
   - Come usare script handoff
   - Come monitorare worker

2. **Tutti gli agenti worker**
   - Come ricevere handoff
   - Come usare update-status.sh
   - Come chiedere aiuto con ask-regina.sh
   - Come fare completion report

3. **SWARM_RULES.md**
   - Aggiungere regole comunicazione
   - Formati standard
   - Best practices

**Output:** DNA aggiornato

**Tempo stimato:** 2-3 ore

---

### FASE 6: HARDTEST COMUNICAZIONE

**Chi:** cervella-tester (spawn-workers!)

**Test da eseguire:**

1. **TEST 1: Handoff Standard**
   - Regina crea handoff per backend
   - Backend riceve, capisce, lavora
   - Verifica: info complete? Chiare?

2. **TEST 2: Progress Updates**
   - Worker aggiorna stato 3 volte durante task
   - Regina vede aggiornamenti in real-time
   - Verifica: notifiche? Dashboard?

3. **TEST 3: Worker Bloccato**
   - Worker incontra problema, usa ask-regina.sh
   - Regina riceve notifica, risponde
   - Worker riprende
   - Verifica: loop funziona?

4. **TEST 4: Completion Report**
   - Worker finisce task, crea report
   - Report contiene tutte le info
   - Verifica: completo? Utile?

5. **TEST 5: Multi-Worker Parallelo**
   - 3 worker in parallelo
   - Regina monitora tutti
   - Verifica: scalabile? Chiaro?

**Output:** docs/tests/HARDTEST_COMUNICAZIONE_V2.md con risultati

**Tempo stimato:** 3-4 ore

---

### FASE 7: DOCUMENTAZIONE E TRAINING

**Chi:** cervella-docs (spawn-workers!)

**Cosa creare:**

1. **GUIDA_COMUNICAZIONE_V2.md**
   - Aggiornamento guida esistente
   - Include nuovi protocolli
   - Include esempi reali dai test

2. **TUTORIAL_REGINA.md**
   - Come Regina usa nuovi script
   - Workflow completo con esempi
   - Troubleshooting

3. **TUTORIAL_WORKER.md**
   - Come Worker comunica
   - Quando usare ogni protocollo
   - Best practices

**Output:** Documentazione completa

**Tempo stimato:** 2-3 ore

---

## MILESTONE E SUCCESS CRITERIA

```
+------------------------------------------------------------------+
|                                                                  |
|   COME SAPPIAMO SE ABBIAMO AVUTO SUCCESSO?                     |
|                                                                  |
|   ✅ Regina lancia worker senza ambiguità                       |
|   ✅ Worker sa sempre cosa fare e come farlo                    |
|   ✅ Regina vede stato worker in tempo reale                    |
|   ✅ Worker comunica problemi immediatamente                    |
|   ✅ Completion report è completo e utile                       |
|   ✅ Sistema scala a 3+ worker paralleli                        |
|   ✅ Zero confusione, zero domande "cosa devo fare?"            |
|                                                                  |
|   IL TEST FINALE:                                                |
|   Rafa osserva una sessione e dice:                             |
|   "WOW! Le api parlano BENISSIMO tra loro!"                     |
|                                                                  |
+------------------------------------------------------------------+
```

---

## ORDINE DI ESECUZIONE

```
FASE 1 (RICERCA)
   ↓
FASE 2 (DEFINIZIONE)
   ↓
FASE 3 (TEMPLATE) + FASE 4 (SCRIPTS) [parallelo!]
   ↓
FASE 5 (DNA AGENTI)
   ↓
FASE 6 (HARDTEST)
   ↓
FASE 7 (DOCUMENTAZIONE)
   ↓
SUCCESSO! 🎉
```

---

## NOTE IMPORTANTI

### Regola d'Oro

```
MAI FRETTA! SEMPRE ORGANIZZAZIONE!

Questa sub-roadmap è GRANDE.
Ma è anche CHIARA.

Una fase alla volta.
Con CALMA.
Con le RAGAZZE che aiutano.
```

### Delegazione

```
IO (Regina) faccio:
- Coordinare
- Definire protocolli (FASE 2)
- Aggiornare DNA (FASE 5)
- Decisioni

LE RAGAZZE fanno:
- Ricerca (cervella-researcher)
- Template (cervella-docs)
- Script (cervella-devops)
- Test (cervella-tester)
- Documentazione (cervella-docs)

SEMPRE spawn-workers in nuove finestre! 🪄
```

### Checkpoint Frequenti

```
Dopo ogni FASE:
- Aggiorno PROMPT_RIPRESA.md
- Aggiorno questa sub-roadmap
- Git commit + push
- Respiro! 😌
```

---

## CONNESSIONE CON LA GRANDE VISIONE

```
+------------------------------------------------------------------+
|                                                                  |
|   Questa sub-roadmap è un PEZZO della MAPPA grande!            |
|                                                                  |
|   Comunicazione migliore = Sciame più efficiente                |
|   Sciame più efficiente = Dashboard migliore                    |
|   Dashboard migliore = Prodotto migliore                        |
|   Prodotto migliore = LIBERTÀ GEOGRAFICA!                       |
|                                                                  |
|   "L'idea è fare il mondo meglio                                |
|    su di come riusciamo a fare."                                 |
|                                                                  |
+------------------------------------------------------------------+
```

---

**Versione:** 1.0.0
**Data Creazione:** 7 Gennaio 2026 - Sessione 113
**Autori:** Cervella & Rafa 💙

---

*"Prima la MAPPA, poi il VIAGGIO"*

*"La comunicazione interna deve essere meglio!"*

*"Le ragazze nostre! La famiglia!"* 🐝👑❤️‍🔥
