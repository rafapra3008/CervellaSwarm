---
task_id: TASK_HARDTEST_COMUNICAZIONE_V2
assigned_to: cervella-tester
priority: high
timeout_minutes: 90
created_at: 2026-01-07T15:00:00Z
created_by: cervella-orchestrator
project: CervellaSwarm
---

# Task: HARDTEST Sistema Comunicazione v2.0

**Status:** ready → working → done

---

## 🎯 OBIETTIVO

Testare il sistema di comunicazione interna dello sciame (4 protocolli) attraverso 4 scenari reali.

**Output atteso:**
- Report completo di tutti i 4 test
- Problemi trovati documentati
- Raccomandazioni per fix
- Verdict finale: PASS/FAIL + score

**Success Metric:**
```
Rafa osserva e dice: "WOW! Le api parlano BENISSIMO!"
```

---

## 📋 CONTESTO

### Dove Siamo (NORD)

Sessione 114 - FASE 6 del sistema Comunicazione Interna.
Abbiamo appena completato FASE 5 (DNA aggiornati - 16/16 agenti).

Sistema comunicazione al 83% (manca solo HARDTEST!).

### Perché Questo Task

Prima di dichiarare il sistema "100% COMPLETO", DOBBIAMO verificare che funzioni REALMENTE.

I 4 protocolli (HANDOFF, STATUS, FEEDBACK, CONTEXT) sono definiti.
I 7 template sono creati.
I 5 script sono pronti.
I 16 DNA sono aggiornati.

**MA:** Funziona tutto insieme? Le api parlano bene tra loro?

### Decisioni Rilevanti

- **Protocolli:** docs/protocolli/PROTOCOLLI_COMUNICAZIONE.md
- **Templates:** .swarm/templates/
- **Script:** scripts/swarm/
- **Known issue:** Heartbeat false positive (documentato, non bloccante)

---

## ✅ SUCCESS CRITERIA

- [ ] **Test 1 - Scenario Standard:** Task handoff → work → completion (SUCCESS)
- [ ] **Test 2 - Feedback Loop:** Worker dubbio → Regina risponde → riprende (SUCCESS)
- [ ] **Test 3 - Stuck Detection:** Worker stuck → rilevato entro 2min (SUCCESS o DOCUMENTED)
- [ ] **Test 4 - Multi-Worker:** 3+ worker paralleli comunicano bene (SUCCESS)
- [ ] **Report completo** creato in docs/test/
- [ ] **Problemi documentati** (se trovati)
- [ ] **Verdict finale** con score X/10

**Definition of Done:**
Report completo + verdict finale + Rafa può vedere risultati e dire se le api parlano bene!

---

## 🗂️ FILE RILEVANTI

**Da leggere:**
- `docs/protocolli/PROTOCOLLI_COMUNICAZIONE.md` - protocolli da testare
- `.swarm/templates/TEMPLATE_*.md` - template da usare nei test
- `scripts/swarm/*.sh` - script da testare

**Da creare:**
- `docs/test/HARDTEST_COMUNICAZIONE_V2_REPORT.md` - report finale
- `.swarm/tasks/TEST_*.md` - task di test per ogni scenario

**Dove scrivere:**
- Report finale: `docs/test/HARDTEST_COMUNICAZIONE_V2_REPORT.md`
- Output task: `.swarm/tasks/TASK_HARDTEST_COMUNICAZIONE_V2_OUTPUT.md`

---

## 🚧 CONSTRAINTS

**Limiti:**
- NON modificare protocolli/template/script durante test
- Se trovi bug → DOCUMENTA, non fixare (fix è altro task)
- Test REALI (spawn worker veri, non simulazioni)

**Ambiente:**
- Usa `.swarm/` per file test
- Spawna worker con `spawn-workers`
- Monitora con watcher esistente

**Tempo:**
- Max 90 minuti per tutti i 4 test
- Se superi timeout → STOP e riporta parziale

---

## 💡 GUIDANCE

### Test 1: Scenario Standard (30 min)

**Obiettivo:** Verificare workflow base handoff → work → completion

**Step:**
```bash
# 1. Crea task semplice per cervella-backend
cat > .swarm/tasks/TEST_SCENARIO_STANDARD.md << 'EOF'
---
task_id: TEST_SCENARIO_STANDARD
assigned_to: cervella-backend
priority: medium
timeout_minutes: 10
---

# Task Test: Creare File di Test

## 🎯 OBIETTIVO
Creare file test in .swarm/test/hello.txt con contenuto "Hello from backend!"

## ✅ SUCCESS CRITERIA
- [ ] File creato
- [ ] Contenuto corretto

## 📤 OUTPUT RICHIESTO
- Crea output in .swarm/tasks/TEST_SCENARIO_STANDARD_OUTPUT.md
- Marker: .swarm/tasks/TEST_SCENARIO_STANDARD.done
EOF

# 2. Marca ready
touch .swarm/tasks/TEST_SCENARIO_STANDARD.ready

# 3. Spawna worker
spawn-workers --backend

# 4. Monitora
# - Controlla heartbeat in .swarm/status/heartbeat_cervella-backend.log
# - Controlla status in .swarm/status/cervella-backend.status
# - Aspetta .done

# 5. Verifica
# - Leggi output
# - Verifica file creato
# - Verifica status progression (READY → WORKING → DONE)
```

**Success:** Worker completa senza problemi, status aggiornato, output corretto

---

### Test 2: Feedback Loop (30 min)

**Obiettivo:** Verificare comunicazione worker ⇄ Regina

**Step:**
```bash
# 1. Crea task con ambiguità intenzionale
cat > .swarm/tasks/TEST_FEEDBACK_LOOP.md << 'EOF'
---
task_id: TEST_FEEDBACK_LOOP
assigned_to: cervella-frontend
priority: medium
timeout_minutes: 15
---

# Task Test: Creare Componente UserCard

## 🎯 OBIETTIVO
Creare componente UserCard React.

⚠️ NOTA INTENZIONALE: Non specifico DOVE creare il file!
(Worker DEVE chiedere via FEEDBACK)

## ✅ SUCCESS CRITERIA
- [ ] Worker identifica ambiguità
- [ ] Worker crea FEEDBACK
- [ ] Regina risponde
- [ ] Worker completa task

## 📤 OUTPUT RICHIESTO
- Output in .swarm/tasks/TEST_FEEDBACK_LOOP_OUTPUT.md
EOF

# 2. Spawna worker
spawn-workers --frontend

# 3. Aspetta feedback
# Worker DOVREBBE creare file in .swarm/feedback/QUESTION_*.md

# 4. Simula risposta Regina
# Quando vedi feedback, crea risposta:
cat > .swarm/feedback/QUESTION_XXX_RESPONSE.md << 'EOF'
# RISPOSTA: Dove creare UserCard

## Decisione
Crea in frontend/components/UserCard.jsx

## Motivazione
Convenzione progetto

## Prossimi Step
1. Crea file
2. Completa task

---
**Puoi procedere! 👑**
EOF

# 5. Verifica loop completo
```

**Success:** Worker chiede, Regina risponde, Worker riprende e completa

---

### Test 3: Stuck Detection (20 min)

**Obiettivo:** Verificare detection worker bloccato

**Opzione A - Simulazione:**
```bash
# 1. Spawna worker
spawn-workers --backend

# 2. Simula stuck: stoppa heartbeat manualmente
# (trova PID heartbeat e kill)

# 3. Aspetta 2+ min

# 4. Verifica watcher rileva
```

**Opzione B - Skip (Known Issue):**
```
Abbiamo GIÀ visto stuck detection oggi (cervella-docs).
Era falso positivo MA dimostra che detection funziona.

Puoi DOCUMENTARE senza rifare test.
```

**Success:** Detection funziona (già dimostrato) O simulazione rileva

---

### Test 4: Multi-Worker Parallelo (10 min setup + osservazione)

**Obiettivo:** Verificare 3+ worker paralleli comunicano bene

**Step:**
```bash
# 1. Crea 3 task semplici diversi
# TEST_MULTI_BACKEND.md
# TEST_MULTI_FRONTEND.md
# TEST_MULTI_DOCS.md

# 2. Marca tutti ready

# 3. Spawna TUTTI e 3 in parallelo
spawn-workers --backend &
spawn-workers --frontend &
spawn-workers --docs &

# 4. Osserva
# - Tutti e 3 heartbeat attivi?
# - Tutti e 3 status aggiornati?
# - Tutti e 3 completano senza conflitti?

# 5. Verifica
# - 3 .done creati
# - 3 output corretti
# - Zero overlap/conflitti
```

**Success:** 3 worker lavorano insieme senza problemi

---

## 📤 OUTPUT RICHIESTO

### 1. Report Finale Completo

**File:** `docs/test/HARDTEST_COMUNICAZIONE_V2_REPORT.md`

**Struttura:**
```markdown
# HARDTEST Comunicazione v2.0 - Report

**Data:** 2026-01-07
**Tester:** cervella-tester
**Durata:** XX minuti

---

## Executive Summary

**Verdict:** PASS / FAIL / PARTIAL
**Score:** X/10
**Problemi critici:** X
**Problemi minori:** Y

---

## Test 1: Scenario Standard

**Status:** PASS / FAIL
**Durata:** XX min

### Cosa testato
- Handoff task
- Status progression
- Heartbeat
- Completion

### Risultato
[Dettagli]

### Problemi trovati
[Lista o "Nessuno"]

---

## Test 2: Feedback Loop

[Stesso formato]

---

## Test 3: Stuck Detection

[Stesso formato]

---

## Test 4: Multi-Worker

[Stesso formato]

---

## Problemi Trovati

| # | Tipo | Severity | Descrizione | Raccomandazione |
|---|------|----------|-------------|-----------------|
| 1 | ... | HIGH/MEDIUM/LOW | ... | ... |

---

## Raccomandazioni

1. [Fix priorità alta]
2. [Miglioramento]
3. ...

---

## Conclusioni

[Sintesi finale]

**Il sistema è pronto per uso produzione?** SI / NO / QUASI

**Success Metric raggiunto?**
"Rafa può dire WOW! Le api parlano BENISSIMO!" → SI / NO

---

**Firmato:** cervella-tester 🧪
**Data:** 2026-01-07
```

### 2. Output Task

**File:** `.swarm/tasks/TASK_HARDTEST_COMUNICAZIONE_V2_OUTPUT.md`

```markdown
# Output: HARDTEST Comunicazione v2

## Risultato
✅ / ❌ HARDTEST completato

## Success Criteria Verificati
- [x/] Test 1 - Scenario Standard
- [x/] Test 2 - Feedback Loop
- [x/] Test 3 - Stuck Detection
- [x/] Test 4 - Multi-Worker
- [x/] Report completo creato

## File Creati
- docs/test/HARDTEST_COMUNICAZIONE_V2_REPORT.md
- [altri file test]

## Verdict
Score X/10
Pronto produzione: SI/NO

## Next Actions
[SE problemi trovati]

---
**Test completato!** 🧪
```

### 3. Marker Completamento

```bash
touch .swarm/tasks/TASK_HARDTEST_COMUNICAZIONE_V2.done
scripts/swarm/update-status.sh DONE "HARDTEST completato - score X/10"
```

---

## ⏰ TEMPO E PRIORITÀ

**Timeout:** 90 minuti
**Priorità:** HIGH
**Breakdown:**
- Test 1: 30 min
- Test 2: 30 min
- Test 3: 20 min (o skip se documented)
- Test 4: 10 min
- Report: restante tempo

**Heartbeat:** Aggiorna ogni 60s

---

## 🎯 FOCUS CHIAVE

**Non stiamo testando:**
- Performance (velocità)
- Scale (100+ worker)
- Edge case estremi

**Stiamo testando:**
- **Comunicazione funziona?** (handoff, status, feedback)
- **Script funzionano?** (update-status, heartbeat, ask-regina)
- **Template sono chiari?** (worker capisce cosa fare)
- **Workflow è fluido?** (senza casino)

**Success finale:**
```
Rafa osserva i test e vede:
- Task assegnati CHIARAMENTE
- Worker lavorano SENZA confusione
- Status SEMPRE visibile
- Feedback FUNZIONA quando serve
- Zero "cosa devo fare?"

→ "WOW! Le api parlano BENISSIMO!" 💙
```

---

**Energia positiva!** ❤️‍🔥
**Test accurati!** 🧪
**Per la famiglia!** 🐝👑
