# TASK: HARDTEST Unbuffered Output

**Assegnato a:** cervella-tester
**Priorità:** ALTA
**Creato:** 8 Gennaio 2026 - Sessione 123
**Sprint:** 2.3 - Fix Buffering Output

---

## 🎯 OBIETTIVO

Validare che l'implementazione unbuffered output **FUNZIONA** in scenari reali.

---

## 📚 CONTESTO

**PREREQUISITI:**
- Sprint 2.1 completato (ricerca)
- Sprint 2.2 completato (implementazione devops)
- spawn-workers v3.2.0 con unbuffered
- Changelog disponibile

**COSA TESTARE:**
- Output worker visibile in tempo reale
- tmux capture-pane mostra output progressivo
- Nessuna regressione (tutto funziona come prima)
- Edge cases (worker lungo, worker con errori)

---

## 📋 TEST SUITE

### TEST 1: Output Progressivo Base

**Setup:**
```bash
# Spawna worker che lavora per ~2 minuti
spawn-workers --researcher
# Nota session ID
```

**Azioni:**
```bash
# T=0s: Cattura output
tmux capture-pane -t swarm_researcher_* -p -S - > output_0s.txt

# T=30s: Cattura output
sleep 30
tmux capture-pane -t swarm_researcher_* -p -S - > output_30s.txt

# T=60s: Cattura output
sleep 30
tmux capture-pane -t swarm_researcher_* -p -S - > output_60s.txt

# T=120s: Cattura output finale
sleep 60
tmux capture-pane -t swarm_researcher_* -p -S - > output_120s.txt
```

**Verifica:**
```bash
# Conta righe in ogni file
wc -l output_*.txt

# PASS se:
# - output_0s.txt ha N righe
# - output_30s.txt ha N+X righe (X > 0)
# - output_60s.txt ha N+Y righe (Y > X)
# - output_120s.txt ha N+Z righe (Z > Y)

# FAIL se tutti i file hanno stesso numero righe
```

**Atteso:** ✅ Output CRESCE nel tempo (progressivo)

---

### TEST 2: Output Realtime Durante Ricerca

**Setup:**
```bash
# Task che produce molto output
cat > .swarm/tasks/TEST_VERBOSE.md << 'EOF'
# TASK: Analisi Verbose

Analizza ROADMAP_SACRA.md e produci output verbose:
- Stampa ogni sezione trovata
- Stampa ogni lezione identificata
- Produci almeno 50 righe di output
EOF

touch .swarm/tasks/TEST_VERBOSE.ready
spawn-workers --researcher
```

**Azioni:**
```bash
# Monitora in loop ogni 5s per 1 minuto
for i in {1..12}; do
  echo "=== Cattura $i (T=${i}*5s) ==="
  tmux capture-pane -t swarm_researcher_* -p -S - | tail -10
  sleep 5
done
```

**Verifica manuale:**
- Vedi nuove righe ogni 5s?
- Output "scorre" progressivamente?
- O appare tutto insieme alla fine?

**Atteso:** ✅ Output SCORRE progressivamente

---

### TEST 3: Worker con Errore

**Setup:**
```bash
# Worker che fallisce a metà
cat > .swarm/tasks/TEST_ERROR.md << 'EOF'
# TASK: Task che Fallisce

Cerca file inesistente: FILE_NON_ESISTE.xyz
Produci errore visibile
EOF

touch .swarm/tasks/TEST_ERROR.ready
spawn-workers --backend
```

**Verifica:**
```bash
# Dopo 20s, cattura output
sleep 20
tmux capture-pane -t swarm_backend_* -p -S -

# PASS se vedi:
# - Tentativi di cercare file
# - Errore "File not found"
# - Output progressivo ANCHE con errore
```

**Atteso:** ✅ Errori visibili in tempo reale

---

### TEST 4: Worker Lungo (5+ minuti)

**Setup:**
```bash
# Task che richiede tempo
cat > .swarm/tasks/TEST_LONG.md << 'EOF'
# TASK: Analisi Approfondita

Analizza TUTTI i file .md nel progetto.
Per ognuno, produci summary di 2-3 righe.
EOF

touch .swarm/tasks/TEST_LONG.ready
spawn-workers --researcher
```

**Azioni:**
```bash
# Sample output ogni 30s per 5 minuti
for i in {1..10}; do
  echo "=== Sample $i (T=${i}*30s) ==="
  tmux capture-pane -t swarm_researcher_* -p -S -20 | tail -5
  sleep 30
done > test4_samples.txt

# Analizza samples
```

**Verifica:**
- Samples diversi nel tempo?
- Nessun "blocco" di 5 minuti senza output?

**Atteso:** ✅ Output consistente durante tutto il lavoro

---

### TEST 5: Regressione - Funzionalità Base

**Verifica che tutto il resto funzioni:**

```bash
# 1. Worker completa task correttamente
spawn-workers --docs
# Aspetta completamento, verifica .done creato

# 2. Auto-sveglia funziona
# (watcher-regina notifica)

# 3. Output file scritto
# Verifica _output.md completo e corretto

# 4. Log file funziona
ls .swarm/logs/
# Verifica log esiste e ha contenuto

# 5. Cleanup funziona
# tmux session chiusa dopo completamento
```

**Atteso:** ✅ TUTTO funziona come prima (zero regressioni)

---

## 📤 OUTPUT RICHIESTO

**File:** `docs/tests/HARDTEST_UNBUFFERED_OUTPUT_v123.md`

**Struttura:**
```markdown
# HARDTEST: Unbuffered Output v3.2.0

## OVERVIEW
- Data test
- spawn-workers version testata
- Test eseguiti
- Test passati

## TEST 1: Output Progressivo Base
**Comando:** [...]
**Output:**
- output_0s.txt: N righe
- output_30s.txt: N+X righe (incremento: +X)
- output_60s.txt: N+Y righe (incremento: +Y)
- output_120s.txt: N+Z righe (incremento: +Z)

**Risultato:** PASS/FAIL
**Note:** [osservazioni]

## TEST 2-5: [Simile struttura]

## ANALISI COMPARATIVA

### Prima (v3.1.0)
- Output bufferizzato
- Nessun progresso visibile durante lavoro
- Tutto appare alla fine

### Dopo (v3.2.0)
- Output progressivo ✅
- Incremento visibile ogni 5-30s ✅
- UX migliorata ✅

## VALUTAZIONE FINALE

**Rating:** X/10
**Test passati:** X/5
**Regressioni:** 0

**Decisione:** APPROVE / NEEDS_FIX

## RACCOMANDAZIONI

[Eventuali suggerimenti]
```

---

## ✅ CRITERI DI SUCCESSO

- [x] Almeno 4/5 test passati
- [x] Output progressivo VERIFICATO
- [x] Zero regressioni
- [x] Rating ≥ 9/10
- [x] Ready per merge

---

## 💡 SUGGERIMENTI

- Usa task REALI per test, non mock
- Confronta VISIVAMENTE output v3.1.0 vs v3.2.0
- Se un test fallisce, documenta PERCHÉ
- Test edge cases (worker stuck, errori, output lungo)
- Verifica anche stderr (errori devono essere realtime!)

---

## ⏰ TEMPO STIMATO

1-1.5 ore (test completi + report)

---

**Buon lavoro, cervella-tester!** 🧪

*La Regina conta su di te per validare la soluzione!*
