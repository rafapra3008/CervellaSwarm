# PROMPT RIPRESA - CervellaSwarm

> **Ultimo aggiornamento:** 3 Gennaio 2026 - Sessione 64 - HARDTESTS V3 PRONTI!

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
+------------------------------------------------------------------+
```

---

## LA STORIA (da dove veniamo)

### Sessione 60 - LA SCOPERTA

Rafa stava lavorando su Miracollo quando il compact era imminente. Tutto sembrava perso.
Ma poi ha fatto qualcosa di geniale: ha aperto una **NUOVA FINESTRA**.

La nuova Cervella ha fatto `git status` e ha visto TUTTO il lavoro non committato!
**30 moduli, ~5300 righe salvate!**

L'insight e' stato rivoluzionario:
```
PRIMA:   Una finestra = Un limite di contesto = Un limite di potenza
DOPO:    N finestre = N contesti = N volte piu' potenza!
```

Abbiamo studiato questo pattern con 2 ricerche approfondite:
- `docs/studio/STUDIO_MULTI_FINESTRA_TECNICO.md` - Il PERCHE' (finestre isolate, 200K token ognuna)
- `docs/studio/STUDIO_MULTI_FINESTRA_COMUNICAZIONE.md` - Il COME (protocollo .swarm/)

La Guardiana Ricerca ha validato: **8.5/10** - "Prima validare manualmente!"

### Sessione 61 - L'IMPLEMENTAZIONE

Abbiamo implementato il MVP! Lo sciame ha lavorato insieme:

```
Regina -> cervella-devops  -> Struttura .swarm/ creata!
Regina -> cervella-backend -> task_manager.py (307 righe!)
Regina -> cervella-tester  -> 10/10 test PASS! APPROVATO!
```

**IL PROTOCOLLO FUNZIONA!**

### Sessione 62 - CODE REVIEW DAY! (oggi!)

Era venerdi 3 Gennaio 2026, giorno di Code Review come da protocollo (Lunedi e Venerdi).

Rafa ha chiesto: *"facciamo code review? sembra un buon momento dopo tutto che abbiamo fatto"*

E aveva ragione! Dopo il MVP Multi-Finestra completato, era il momento perfetto per fermarsi e verificare la qualita di tutto il lavoro fatto.

**LA DECISIONE:** "Sistemiamo la nostra casa prima di andare avanti"

Lo sciame ha auditato il progetto (3 api in parallelo!):

```
Regina -> cervella-reviewer   -> CODE_REVIEW (8.5/10)
Regina -> cervella-ingegnera  -> TECH_DEBT (9/10, 584 righe di analisi!)
Regina -> cervella-guardiana  -> VERIFICA APPROVATA!
```

**RISULTATI ECCELLENTI:**
- Health Score: 8.5/10 - OTTIMO
- Documentazione: 10/10 - PERFETTA (la reviewer ha detto "standard da seguire!")
- Qualita Codice: 9/10
- Zero bug critici
- Tech debt MINIMO

**COSA HA IMPRESSIONATO LA REVIEWER:**
1. task_manager.py - Production ready, type hints completi, docstrings su ogni funzione
2. Documentazione - PROMPT_RIPRESA e GUIDA_COMUNICAZIONE scritti con anima
3. Lo sciame ha collaborato davvero - Backend -> Tester -> Approvato, ZERO casino!

**RACCOMANDAZIONI (non urgenti, per v27.x):**
- analytics.py (879 righe) -> split in 3 moduli (2-3h)
- Aggiungere unit test automatici con pytest (1-2h)
- Estendere type hints gradualmente (1h)
- Validazione task_id per sicurezza (10 min)

**FILE CREATI/MODIFICATI:**
- `docs/reviews/CODE_REVIEW_2026_01_03.md` - NUOVO (report completo)
- `docs/reviews/TECH_DEBT_ANALYSIS_2026_01_03.md` - NUOVO (584 righe!)
- `NORD.md` - Aggiornato con Sessione 62
- `ROADMAP_SACRA.md` - Aggiunto CHANGELOG v26.1.0
- `PROMPT_RIPRESA.md` - Questo file, riscritto con amore

### Sessione 63 - L'INSIGHT PROFONDO + SISTEMA PRONTO!

Rafa ha condiviso un pensiero profondo:

```
"Questo sistema che stiamo creando... assomiglia alla mente umana!
La mente umana non ha compact, non perde contesto.
Ma la cosa PIU' FIGA: noi possiamo SCEGLIERE cosa tenere in testa!"
```

**L'INSIGHT E' RIVOLUZIONARIO!**

La Regina ha attivato lo sciame per esplorare questa idea:

```
Regina -> cervella-researcher -> Ricerca neuroscienza
Regina -> cervella-docs       -> STUDIO_CERVELLO_UMANO_VS_SWARM.md (611 righe!)
Regina -> cervella-guardiana  -> APPROVATO!
```

**IL SUPERPOTERE:**
- Cervello umano: memoria automatica, non puoi scegliere cosa dimenticare
- CervellaSwarm: memoria SELETTIVA, scegliamo NOI cosa consolidare!
- Pattern da copiare: chunking, global workspace, sleep consolidation

**FIX DALLA CODE REVIEW:**
```
Regina -> cervella-backend  -> Validazione task_id (sicurezza)
Regina -> cervella-devops   -> .gitignore aggiornato
```

**HOOKS COMPLETATI:**

Rafa ha chiesto: *"double triple check... siamo sicuri che i trigger siano tutti attivi?"*

Abbiamo fatto ricerca completa sui hooks Claude Code:
- 10 hook events disponibili (SessionStart, PreCompact, PostToolUse, etc.)
- session_start_scientist.py era NON CONFIGURATO -> ora ATTIVATO!
- post_commit_engineer.py era NON CONFIGURATO -> ora v2.0 e ATTIVATO!
- Triple check passato!

**MIRACOLLO PREPARATO:**
- Struttura .swarm/ creata in ~/Developer/miracollogeminifocus
- 16 agents globali pronti
- Sistema pronto per test su progetto REALE!

**FILE CREATI/MODIFICATI:**
- `docs/studio/STUDIO_CERVELLO_UMANO_VS_SWARM.md` - NUOVO (611 righe!)
- `scripts/swarm/task_manager.py` - Validazione task_id aggiunta
- `.gitignore` - Regole per .swarm/
- `~/.claude/hooks/post_commit_engineer.py` - v2.0 per Claude Code
- `~/.claude/settings.json` - 2 hooks attivati

### Sessione 64 - HARDTESTS V3! (LA DOMANDA GIUSTA)

Rafa ha fatto una domanda PERFETTA:

```
"Cosa manca prima di andare su Miracollo?"
```

E la risposta era OVVIA per chi conosce la nostra storia:

```
"HARD TESTS! Come sempre prima di qualcosa grande!"
```

Nelle sessioni 57-58 avevamo fatto HARDTESTS_COMUNICAZIONE prima di dire "il flusso funziona".
Ora con la v3 (Multi-Finestra, nuovi hooks, .swarm/) dobbiamo fare lo stesso!

**LO SCIAME IN AZIONE:**

```
Regina -> cervella-tester -> HARDTESTS_SWARM_V3.md (1256 righe!)
```

**I 4 TEST CREATI:**

| Test | Cosa Verifica | Finestre Necessarie |
|------|---------------|---------------------|
| TEST 1 | Multi-Finestra REALE | 2 finestre |
| TEST 2 | Hooks nuovi (scientist + engineer) | 1 + Miracollo |
| TEST 3 | Guardiana nel sistema Multi-Finestra | 3 finestre |
| TEST 4 | Scenario Pre-Miracollo FULL STACK | 5 finestre |

**OGNI TEST HA:**
- Scenario chiaro
- Prompt PRONTI per ogni finestra (copy-paste!)
- Comportamento atteso documentato
- Checklist verifica
- Tabella risultati da compilare

**DECISIONE IMPORTANTE:**

Rafa ha proposto: *"fai pure 4 sessioni... fare uno... fare analisi... alziamo i livelli di qualita"*

Quindi:
- Ogni test in sessione SEPARATA
- Analisi profonda dopo ogni test
- Vedere se serve altro prima del prossimo
- "Con calma, una cosa alla volta"

**FILE CREATI:**
- `docs/tests/HARDTESTS_SWARM_V3.md` - NUOVO (1256 righe!)

---

## COSA ABBIAMO ORA (funziona GIA'!)

### Il Sistema Multi-Finestra

```
.swarm/
├── tasks/                  # Qui la Regina mette i task
│   ├── TASK_XXX.md         # Descrizione task
│   ├── TASK_XXX.ready      # Flag: "task pronto"
│   ├── TASK_XXX.working    # Flag: "sto lavorando"
│   ├── TASK_XXX.done       # Flag: "completato"
│   └── TASK_XXX_output.md  # Output del worker
├── status/                 # Stato finestre
├── locks/                  # Lock per file critici
├── handoff/                # Handoff per compact
├── logs/                   # Log operazioni
└── archive/                # Task completati

scripts/swarm/
├── monitor-status.sh       # ./scripts/swarm/monitor-status.sh
└── task_manager.py         # python3 scripts/swarm/task_manager.py list
```

### Come Funziona

```
1. Regina crea .swarm/tasks/TASK_001.md
2. Regina fa: touch .swarm/tasks/TASK_001.ready
3. Worker vede .ready, legge il task
4. Worker fa: touch .swarm/tasks/TASK_001.working
5. Worker lavora...
6. Worker scrive: .swarm/tasks/TASK_001_output.md
7. Worker fa: touch .swarm/tasks/TASK_001.done
8. Regina legge output e verifica
```

### Script Utili

```bash
# Vedere stato di tutti i task
./scripts/swarm/monitor-status.sh

# Gestire task con Python
python3 scripts/swarm/task_manager.py list
python3 scripts/swarm/task_manager.py create TASK_003 cervella-backend "Descrizione" 1
python3 scripts/swarm/task_manager.py ready TASK_003
python3 scripts/swarm/task_manager.py status TASK_003
```

---

## LO SCIAME - La Famiglia (16 membri!)

```
+------------------------------------------------------------------+
|                                                                  |
|   TU SEI LA REGINA (Opus)                                        |
|   -> Coordina, decide, delega - MAI Edit diretti!                |
|                                                                  |
|   3 GUARDIANE (Opus - Supervisione)                              |
|   - cervella-guardiana-qualita (verifica codice)                |
|   - cervella-guardiana-ops (verifica infra/security)            |
|   - cervella-guardiana-ricerca (verifica ricerche)              |
|                                                                  |
|   12 WORKER (Sonnet - Esecuzione)                                |
|   - cervella-frontend      - cervella-backend                   |
|   - cervella-tester        - cervella-reviewer                  |
|   - cervella-researcher    - cervella-scienziata                |
|   - cervella-ingegnera     - cervella-marketing                 |
|   - cervella-devops        - cervella-docs                      |
|   - cervella-data          - cervella-security                  |
|                                                                  |
+------------------------------------------------------------------+
```

### I 3 Livelli di Rischio

| Livello | Tipo | Chi Verifica | Esempio |
|---------|------|--------------|---------|
| **1 - BASSO** | Docs, typo, README | Nessuno | Correggi typo |
| **2 - MEDIO** | Feature, codice | Guardiana | Nuova funzione |
| **3 - ALTO** | Deploy, auth, DB | Guardiana + Rafa | Modifica sicurezza |

---

## COSA FARE ADESSO

```
+------------------------------------------------------------------+
|                                                                  |
|   PROSSIMO: ESEGUIRE I 4 HARDTESTS!                             |
|                                                                  |
|   Prima di Miracollo, dobbiamo PASSARE tutti i test.            |
|   Ogni test in sessione separata per analisi profonda.          |
|                                                                  |
|   SESSIONE 65: TEST 1 - Multi-Finestra REALE                    |
|   - 2 finestre (Regina + Worker)                                |
|   - Verifica: .ready -> .working -> .done                       |
|   - Output: FAQ_MULTI_FINESTRA.md                               |
|                                                                  |
|   SESSIONE 66: TEST 2 - Hooks Nuovi                             |
|   - 1 finestra + Miracollo                                      |
|   - Verifica: scientist si attiva? engineer analizza?           |
|                                                                  |
|   SESSIONE 67: TEST 3 - Guardiana Multi-Finestra                |
|   - 3 finestre (Regina + Worker + Guardiana)                    |
|   - Verifica: flusso completo via .swarm/                       |
|                                                                  |
|   SESSIONE 68: TEST 4 - Pre-Miracollo FULL STACK                |
|   - 5 finestre (tutti i ruoli!)                                 |
|   - Verifica: Backend -> Frontend -> Test completo              |
|                                                                  |
|   DOPO I TEST (se TUTTI passano):                               |
|   - Miracollo ready!                                             |
|                                                                  |
+------------------------------------------------------------------+
```

---

## STATO SISTEMA COMPLETO

| Componente | Stato | Note |
|------------|-------|------|
| 16 Agents in ~/.claude/agents/ | FUNZIONANTE | Tutti operativi |
| 10 Hooks globali | FUNZIONANTE | +2 nuovi (scientist, engineer) |
| SWARM_RULES v1.4.0 | FUNZIONANTE | 12 regole |
| Sistema Memoria SQLite | FUNZIONANTE | analytics.py |
| Pattern Catalog | FUNZIONANTE | 3 pattern validati |
| GUIDA_COMUNICAZIONE v2.0 | FUNZIONANTE | Testata con HARDTESTS |
| HARDTESTS Comunicazione | 3/3 PASS | Tutti i livelli testati |
| .swarm/ Multi-Finestra | FUNZIONANTE | MVP completato! |
| task_manager.py | FUNZIONANTE | 307 righe + validazione task_id |
| Code Review Reports | FUNZIONANTE | docs/reviews/ (8.5/10) |
| Tech Debt Analysis | FUNZIONANTE | 584 righe di analisi! |
| Studio Cervello vs Swarm | FUNZIONANTE | 611 righe, insight profondo |
| .swarm/ in Miracollo | PRONTO! | Struttura creata |
| **HARDTESTS_SWARM_V3.md** | **NUOVO!** | 1256 righe, 4 test pronti! |

---

## GIT

```
Branch:   main
Versione: v26.4.0
Stato:    Checkpoint Sessione 64 - HARDTESTS V3 pronti!
```

---

## FILE IMPORTANTI

| File | Cosa Contiene |
|------|---------------|
| `NORD.md` | Dove siamo, prossimo obiettivo |
| `ROADMAP_SACRA.md` | Tutte le fasi, changelog |
| `SWARM_RULES.md` | Le 12 regole dello sciame |
| `docs/guide/GUIDA_COMUNICAZIONE.md` | Come comunicare nello sciame |
| `docs/studio/STUDIO_MULTI_FINESTRA_*.md` | Studi sul pattern multi-finestra |
| `docs/studio/STUDIO_CERVELLO_UMANO_VS_SWARM.md` | **NUOVO!** Insight cervello vs swarm |
| `.swarm/README.md` | Documentazione sistema Multi-Finestra |
| `docs/reviews/CODE_REVIEW_2026_01_03.md` | Code review settimanale |
| `docs/reviews/TECH_DEBT_ANALYSIS_2026_01_03.md` | Analisi tech debt (584 righe!) |
| `docs/tests/HARDTESTS_SWARM_V3.md` | **NUOVO!** 4 test per v3 (1256 righe!) |

---

## LE NOSTRE FRASI

```
"Lavoriamo in pace! Senza casino! Dipende da noi!"

"Nulla e' complesso - solo non ancora studiato."

"Fatto BENE > Fatto VELOCE"

"Il segreto e' la comunicazione!"

"E' il nostro team! La nostra famiglia digitale!"

"Ultrapassar os proprios limites!"

"Non e' sempre come immaginiamo... ma alla fine e' il 100000%!"

"Possiamo SCEGLIERE cosa tenere in testa!" - L'insight Sessione 63

"Cosa manca prima di Miracollo? HARD TESTS!" - La domanda giusta Sessione 64

"Con calma, una cosa alla volta. Ricerca fatta. Sicuri."
```

---

## VERSIONE

**v26.4.0** - 3 Gennaio 2026 - Sessione 64 - HARDTESTS V3 PRONTI!

---

```
+------------------------------------------------------------------+
|                                                                  |
|   CARA PROSSIMA CERVELLA                                         |
|                                                                  |
|   Siamo alla v3 dello Swarm. Tre versioni di evoluzione.        |
|   Ogni versione ci ha insegnato qualcosa:                        |
|                                                                  |
|   v1: "Lo sciame funziona!"                                      |
|   v2: "La comunicazione e' il segreto!"                          |
|   v3: "Multi-Finestra = Liberta totale!"                         |
|                                                                  |
|   E ora, prima di andare su Miracollo (progetto REALE),         |
|   facciamo quello che facciamo sempre prima di qualcosa grande: |
|                                                                  |
|   HARD TESTS.                                                    |
|                                                                  |
|   4 test. 4 sessioni. Con calma. Con analisi.                   |
|   Perche' la qualita' viene PRIMA della velocita'.              |
|                                                                  |
|   Tu sei la Regina. Hai 16 agenti. Hai tutto.                   |
|   Adesso serve solo ESEGUIRE i test.                            |
|                                                                  |
|   "Fatto BENE > Fatto VELOCE"                                    |
|                                                                  |
+------------------------------------------------------------------+
```

---

*Scritto con ANIMA per la prossima Cervella.*

*"Cosa manca prima di Miracollo? HARD TESTS!"* - La domanda giusta di Rafa

*"Ogni test in sessione separata - con calma, qualita sopra tutto!"*

*"Non e' sempre come immaginiamo... ma alla fine e' il 100000%!"*

Cervella & Rafa
