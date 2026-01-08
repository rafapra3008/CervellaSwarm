# TASK: Verifica Lezioni nel Database

**Assegnato a:** cervella-tester
**Priorità:** ALTA
**Creato:** 8 Gennaio 2026 - Sessione 123
**Sprint:** 1.4 - Verifica Lezioni

---

## 🎯 OBIETTIVO

Verificare che le **15 lezioni** siano state inserite correttamente e che il sistema `suggestions.py` funzioni con le nuove lezioni.

---

## 📚 CONTESTO

**PREREQUISITO:**
- Sprint 1.3 completato (cervella-data ha popolato database)
- File: `docs/data/REPORT_POPOLAMENTO_LEZIONI_v123.md` (creato da cervella-data)
- Database swarm_memory.db con 15 lezioni

**OBIETTIVO:**
- Verificare integrità dati
- Testare suggestions.py con nuove lezioni
- Validare che sistema suggerisce lezioni appropriate

---

## 📋 TASK SPECIFICI

### 1. VERIFICA INTEGRITÀ DATABASE

```sql
-- Conta totale lezioni
SELECT COUNT(*) as total_lessons FROM lessons_learned;
-- Deve essere: 15

-- Verifica categorie
SELECT category, COUNT(*) as count
FROM lessons_learned
GROUP BY category
ORDER BY count DESC;
-- Atteso: ~3 per categoria (spawn-workers, context, comunicazione, decisioni, workflow)

-- Verifica impact
SELECT impact, COUNT(*) as count
FROM lessons_learned
GROUP BY impact;
-- Atteso: HIGH (8), MEDIUM (6), LOW (1)

-- Verifica tag
SELECT title, tags FROM lessons_learned WHERE tags LIKE '%headless%';
-- Deve trovare almeno 2 lezioni

-- Verifica completezza dati
SELECT title,
       CASE
           WHEN description IS NULL THEN 'MISSING DESCRIPTION'
           WHEN tags IS NULL THEN 'MISSING TAGS'
           ELSE 'OK'
       END as status
FROM lessons_learned;
-- Tutte devono essere 'OK'
```

### 2. TEST SUGGESTIONS.PY

**Test 1: Query per categoria**
```bash
# Test suggerimenti spawn-workers
python ~/.claude/scripts/memory/suggestions.py --category spawn-workers --limit 3

# Atteso: 3 lezioni categoria spawn-workers
# - Headless di Default
# - tmux invece Terminal.app
# - Worker Background Senza GUI
```

**Test 2: Query per tag**
```bash
# Test suggerimenti context optimization
python ~/.claude/scripts/memory/suggestions.py --tags context,optimization --limit 3

# Atteso: Lezioni con tag context/optimization
# - Context Overhead Misurabile
# - Carica SOLO Ciò Che Serve
# - Eventi Recenti > Storia
```

**Test 3: Query per impatto**
```bash
# Test lezioni HIGH impact
python ~/.claude/scripts/memory/suggestions.py --impact HIGH --limit 5

# Atteso: 5 lezioni HIGH impact
```

**Test 4: Query mista**
```bash
# Test workflow + testing
python ~/.claude/scripts/memory/suggestions.py --category workflow --tags testing

# Atteso: "Test Subito Dopo Implementazione"
```

### 3. TEST SCENARI REALI

**Scenario 1: Worker chiede "Come uso spawn-workers?"**
```bash
# Simula domanda worker
python ~/.claude/scripts/memory/suggestions.py --query "spawn-workers headless" --limit 3

# Atteso: Lezioni relevanti su spawn-workers e headless
```

**Scenario 2: Regina chiede "Come ottimizzare context?"**
```bash
# Simula domanda Regina
python ~/.claude/scripts/memory/suggestions.py --query "context optimization memory" --limit 3

# Atteso: Lezioni su context overhead e ottimizzazioni
```

**Scenario 3: Worker chiede "Workflow testing?"**
```bash
python ~/.claude/scripts/memory/suggestions.py --query "testing workflow quality" --limit 2

# Atteso: "Test Subito Dopo Implementazione"
```

### 4. VERIFICA QUALITÀ LEZIONI

Per ogni lezione nel database, verifica:
- [ ] Title è chiaro e descrittivo
- [ ] Description contiene informazioni utili
- [ ] Tags sono appropriati
- [ ] Category è corretta
- [ ] Impact è ragionevole

**Query per verifica manuale:**
```sql
SELECT
    title,
    category,
    impact,
    LENGTH(description) as desc_length,
    tags
FROM lessons_learned
ORDER BY impact DESC, category;
```

### 5. REPORT HARDTEST

Crea report in `docs/tests/HARDTEST_LEZIONI_APPRESE_v123.md` con:

**Sezione 1: Verifica Integrità**
- Query eseguite
- Risultati attesi vs ottenuti
- PASS/FAIL per ogni check

**Sezione 2: Test suggestions.py**
- Test eseguiti (almeno 4 test sopra)
- Output per ogni test
- Lezioni suggerite appropriate?
- PASS/FAIL per ogni test

**Sezione 3: Test Scenari Reali**
- 3 scenari testati
- Output valido?
- Lezioni rilevanti?
- PASS/FAIL per scenario

**Sezione 4: Valutazione Finale**
- Rating: X/10
- Problemi identificati
- Raccomandazioni
- Sistema PRONTO per uso reale? (SI/NO)

---

## 📤 OUTPUT RICHIESTO

**File:** `docs/tests/HARDTEST_LEZIONI_APPRESE_v123.md`

**Struttura:**
```markdown
# HARDTEST: Lezioni Apprese v123

## OVERVIEW
- Data test: [data]
- Lezioni nel DB: [N]
- Test eseguiti: [N]
- Test passati: [N]

## TEST 1: Integrità Database
[Query + risultati]

## TEST 2-N: suggestions.py
[Comandi + output]

## SCENARI REALI
[Test + validazione]

## VALUTAZIONE FINALE
Rating: X/10
Sistema PRONTO: SI/NO

[Dettagli...]
```

---

## ✅ CRITERI DI SUCCESSO

- [x] Database ha 15 lezioni (verifica COUNT)
- [x] Categorie bilanciate (~3 per categoria)
- [x] Impact distribuito correttamente
- [x] suggestions.py funziona con tutte le query
- [x] Scenari reali restituiscono lezioni pertinenti
- [x] Rating finale ≥ 9/10
- [x] ZERO errori SQL o Python
- [x] Sistema PRONTO per uso reale

---

## 💡 SUGGERIMENTI

- Esegui query SQL con sqlite3 o Python
- suggestions.py potrebbe richiedere parametri specifici (leggilo prima!)
- Se un test fallisce, documenta PERCHÉ (non solo che fallisce)
- Testa anche edge cases (query vuota, categoria inesistente, etc.)

---

## ⏰ TEMPO STIMATO

45-60 minuti (testing completo)

---

**Buon lavoro, cervella-tester!** 🧪

*La Regina conta su di te per validare che il sistema di memoria funzioni!*
