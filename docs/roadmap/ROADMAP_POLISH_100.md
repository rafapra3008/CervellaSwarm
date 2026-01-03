# ROADMAP POLISH 100% - CervellaSwarm

> **Obiettivo:** Lasciare CervellaSwarm al 100% prima di passare ad altro
> **Data:** 4 Gennaio 2026 - Sessione 75
> **Motto:** "SU CARTA != REALE" - Testiamo TUTTO!

---

## IL PIANO

```
+------------------------------------------------------------------+
|                                                                  |
|   PRIMA DI PASSARE AD ALTRO:                                     |
|                                                                  |
|   1. Verificare che tutti gli script esistano                    |
|   2. Eseguire 10 Test Quick Wins                                 |
|   3. Eseguire 6 HARDTESTS Apple Style                            |
|   4. Fixare eventuali problemi                                   |
|   5. CervellaSwarm = 100%                                        |
|                                                                  |
|   Solo DOPO questo possiamo andare avanti!                       |
|                                                                  |
+------------------------------------------------------------------+
```

---

## FASE 1: VERIFICA PREREQUISITI

Prima di testare, verifico che tutto esista.

### Script Richiesti

| Script | Path | Esiste? |
|--------|------|---------|
| anti-compact.sh | scripts/swarm/ | [ ] |
| shutdown-sequence.sh | scripts/swarm/ | [ ] |
| checklist-pre-merge.sh | scripts/swarm/ | [ ] |
| triple-ack.sh | scripts/swarm/ | [ ] |
| dashboard.py | scripts/swarm/ | [ ] |
| dashboard.sh | scripts/swarm/ | [ ] |
| spawn-workers.sh | scripts/swarm/ | [ ] |
| task_manager.py | scripts/swarm/ | [ ] |

### Pattern Python

| Pattern | Path | Esiste? |
|---------|------|---------|
| progress_bar.py | src/patterns/ | [ ] |
| circuit_breaker.py | src/patterns/ | [ ] |
| structured_logging.py | src/patterns/ | [ ] |

**AZIONE:** Se manca qualcosa, crearlo PRIMA di testare.

---

## FASE 2: TEST QUICK WINS (10 test)

Test mirati per verificare che ogni tool FUNZIONI.

### QW1: anti-compact.sh
```bash
./scripts/swarm/anti-compact.sh --no-spawn --message "Test QW1"
```
- [ ] Script esegue senza errori
- [ ] PROMPT_RIPRESA.md aggiornato
- [ ] Git commit creato
- [ ] Messaggio finale chiaro

**ESITO:** ____

---

### QW2: shutdown-sequence.sh
```bash
./scripts/swarm/shutdown-sequence.sh --no-report
```
- [ ] Script esegue senza errori
- [ ] Verifica task attivi funziona
- [ ] Pulizia file temporanei funziona
- [ ] Messaggio finale chiaro

**ESITO:** ____

---

### QW3: checklist-pre-merge.sh
```bash
./scripts/swarm/checklist-pre-merge.sh --skip-tests
```
- [ ] Script esegue senza errori
- [ ] GATE 1-4 funzionano
- [ ] Output colorato e chiaro

**ESITO:** ____

---

### QW4: triple-ack.sh
```bash
python3 scripts/swarm/task_manager.py create TEST_ACK cervella-backend "Test ACK" 1
./scripts/swarm/triple-ack.sh received TEST_ACK
./scripts/swarm/triple-ack.sh understood TEST_ACK
./scripts/swarm/triple-ack.sh status TEST_ACK
```
- [ ] create funziona
- [ ] received funziona
- [ ] understood funziona
- [ ] status mostra R/U correttamente

**ESITO:** ____

---

### QW5: dashboard.py
```bash
python3 scripts/swarm/dashboard.py
python3 scripts/swarm/dashboard.py --json
```
- [ ] Dashboard ASCII si visualizza
- [ ] Mostra workers
- [ ] --json produce output valido

**ESITO:** ____

---

### QW6: progress_bar.py
```bash
python3 src/patterns/progress_bar.py
```
- [ ] Demo esegue senza errori
- [ ] Progress bar si visualizza
- [ ] 3 livelli funzionano

**ESITO:** ____

---

### QW7: circuit_breaker.py
```bash
python3 src/patterns/example_usage.py
```
- [ ] Import funziona
- [ ] Esempio esegue

**ESITO:** ____

---

### QW8: structured_logging.py
```bash
python3 -c "from src.patterns import SwarmLogger; l = SwarmLogger('test'); l.info('Test')"
```
- [ ] Import funziona
- [ ] Log funziona
- [ ] Formato JSON corretto

**ESITO:** ____

---

### QW9: spawn-workers.sh
```bash
./scripts/swarm/spawn-workers.sh --list
./scripts/swarm/spawn-workers.sh --backend  # Apre finestra
```
- [ ] --list mostra tutti i worker
- [ ] --backend apre nuova finestra Terminal
- [ ] Claude Code si avvia
- [ ] Worker cerca task automaticamente

**ESITO:** ____

---

### QW10: task_manager.py
```bash
python3 scripts/swarm/task_manager.py list
python3 scripts/swarm/task_manager.py create TEST_TM cervella-docs "Test" 1
python3 scripts/swarm/task_manager.py ready TEST_TM
python3 scripts/swarm/task_manager.py list
```
- [ ] list funziona
- [ ] create crea task
- [ ] ready marca come pronto
- [ ] Status aggiornato

**ESITO:** ____

---

## RIEPILOGO QUICK WINS

| Test | Tool | PASS/FAIL |
|------|------|-----------|
| QW1 | anti-compact.sh | |
| QW2 | shutdown-sequence.sh | |
| QW3 | checklist-pre-merge.sh | |
| QW4 | triple-ack.sh | |
| QW5 | dashboard.py | |
| QW6 | progress_bar.py | |
| QW7 | circuit_breaker.py | |
| QW8 | structured_logging.py | |
| QW9 | spawn-workers.sh | |
| QW10 | task_manager.py | |

**TOTALE QW:** ___/10 PASS

---

## FASE 3: HARDTESTS APPLE STYLE (6 test)

Test di integrazione con multi-finestra REALE.

### TEST 1: SMOOTH COMMUNICATION
Worker backend + tester fanno task insieme.
- [ ] Handoff chiaro
- [ ] Triple ACK funziona
- [ ] Output corretto
- [ ] Zero ambiguita

**ESITO:** ____

---

### TEST 2: TRIPLE CHECK AUTOMATICO
Backend + Guardiana Qualita (review).
- [ ] Backend completa
- [ ] Review request creata
- [ ] Guardiana verifica
- [ ] Approvazione funziona

**ESITO:** ____

---

### TEST 3: ERROR HANDLING GRACEFUL
Worker incontra errore intenzionale.
- [ ] Errore segnalato
- [ ] Messaggio chiaro
- [ ] Recovery suggerito
- [ ] No crash

**ESITO:** ____

---

### TEST 4: CLEAN CLOSURE
Shutdown pulito di fine sessione.
- [ ] shutdown-sequence.sh funziona
- [ ] Task verificati
- [ ] Report creato
- [ ] Git OK

**ESITO:** ____

---

### TEST 5: FEEDBACK TEMPO REALE
Task lungo con progress updates.
- [ ] ACK puntuali
- [ ] Progress visibile
- [ ] Completion chiara

**ESITO:** ____

---

### TEST 6: ANTI-COMPACT
Simulazione compact imminente.
- [ ] anti-compact.sh funziona
- [ ] PROMPT aggiornato
- [ ] Git commit
- [ ] Recovery possibile

**ESITO:** ____

---

## RIEPILOGO HARDTESTS

| Test | Nome | PASS/FAIL |
|------|------|-----------|
| 1 | Smooth Communication | |
| 2 | Triple Check Automatico | |
| 3 | Error Handling Graceful | |
| 4 | Clean Closure | |
| 5 | Feedback Tempo Reale | |
| 6 | Anti-Compact | |

**TOTALE HT:** ___/6 PASS

---

## FASE 4: FIX PROBLEMI

Per ogni test FAIL:

| Test | Problema | Fix | Status |
|------|----------|-----|--------|
| | | | |
| | | | |
| | | | |

---

## RIEPILOGO FINALE

| Categoria | Passati | Totale |
|-----------|---------|--------|
| Quick Wins | | 10 |
| HARDTESTS | | 6 |
| **TOTALE** | | **16** |

### Criteri di Successo

```
16/16 PASS -> CERVELLASWARM 100%! PRONTO!
14-15/16   -> Fix minori, poi OK
12-13/16   -> Review necessaria
<12/16     -> NON READY
```

---

## ORDINE DI ESECUZIONE

```
1. FASE 1 - Verifica prerequisiti (5 min)
   -> Se manca qualcosa, crearlo

2. FASE 2 - Quick Wins QW1-QW10 (30 min)
   -> Test singoli, veloci
   -> Annota PASS/FAIL

3. FASE 3 - HARDTESTS 1-6 (1-2 ore)
   -> Multi-finestra REALE
   -> Annota PASS/FAIL

4. FASE 4 - Fix problemi (tempo variabile)
   -> Ogni FAIL va fixato
   -> Re-test dopo fix

5. CONCLUSIONE
   -> 16/16 = FATTO!
   -> Checkpoint finale
```

---

## NOTE

- **Usa multi-finestra per HARDTESTS** (spawn-workers.sh)
- **Non usare Task tool** per i test multi-finestra
- **Annota risultati SUBITO** - non dopo
- **Se FAIL** - documenta perche' e fixa

---

*"SU CARTA != REALE"*

*"Lasciamo tutto 100% prima di andare avanti!"*

---

Cervella & Rafa
Sessione 75 - 4 Gennaio 2026
