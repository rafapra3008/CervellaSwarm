# TASK: Ricerca Tecnica - Unbuffered Output

**Assegnato a:** cervella-researcher
**Priorità:** ALTA
**Creato:** 8 Gennaio 2026 - Sessione 123
**Sprint:** 2.1 - Fix Buffering Output

---

## 🎯 OBIETTIVO

Studiare come ottenere **output realtime** (unbuffered) dai worker che lavorano in tmux headless.

---

## 📚 CONTESTO

**IL PROBLEMA:**
- Output worker è bufferizzato
- NON vediamo cosa fa worker MENTRE lavora
- tmux capture-pane mostra solo output accumulato
- Impossibile vedere progresso in tempo reale

**ESEMPIO CONCRETO:**
```bash
# Spawna worker
spawn-workers --backend

# Worker lavora per 5 minuti
# Durante questi 5 minuti: ZERO output visibile
# Solo quando finisce vediamo tutto insieme

# Vogliamo vedere output PROGRESSIVO mentre lavora!
```

**DA DOVE VENIAMO:**
- spawn-workers v3.1.0 (headless default, tmux)
- watcher-regina v1.5.0 (rileva .done, notifica)
- Lezione #11: "Output Buffering Blocca Log Realtime" (nel database!)

---

## 🔬 DOMANDE DI RICERCA

### 1. Python Buffering
- Come funziona buffering output Python?
- `python -u` (unbuffered) aiuta?
- `PYTHONUNBUFFERED=1` environment variable?
- `sys.stdout.flush()` dopo ogni print?
- Differenza tra stdout e stderr buffering

### 2. stdbuf Command
- Come funziona `stdbuf -oL` (line buffered)?
- `stdbuf -o0` (unbuffered) vs `-oL`?
- Pro e contro di ogni opzione
- Funziona con Python? Con claude CLI?
- Esempio pratico: `stdbuf -oL python script.py`

### 3. tmux Specifics
- tmux bufferizza ulteriormente l'output?
- `tmux pipe-pane` per catturare output live?
- `tmux capture-pane -p` è realtime?
- Alternative per vedere output progressivo in tmux?

### 4. Claude CLI
- Il comando `claude` ha opzioni per unbuffered output?
- Come `claude` gestisce stdout/stderr?
- Possiamo modificare comportamento output?
- Log file scritto in realtime o bufferizzato?

### 5. Script Bash
- Come spawn-workers.sh passa output al worker?
- Possiamo aggiungere flags per unbuffered?
- Dove inserire `stdbuf` nel comando?
- Test: funziona con tmux detached?

---

## 📋 TASK SPECIFICI

### 1. STUDIO TEORIA
- Ricerca buffering Python (documentazione ufficiale)
- Ricerca stdbuf (man page, esempi)
- Ricerca tmux output handling
- Best practices per log realtime

### 2. ANALISI CODICE ESISTENTE
Leggi e analizza:
- `~/.local/bin/spawn-workers` (riga comando che lancia claude)
- `scripts/swarm/watcher-regina.sh` (come cattura output)
- Come worker attualmente scrive log

### 3. SOLUZIONI PROPOSTE
Per ogni soluzione, documenta:
- Come implementare
- Pro e contro
- Complessità (BASSA/MEDIA/ALTA)
- Test da fare
- Risk level

**Soluzioni da valutare:**
1. `python -u` o `PYTHONUNBUFFERED=1`
2. `stdbuf -oL claude ...`
3. `tmux pipe-pane -o`
4. Combinazione di più soluzioni
5. Alternative creative

### 4. PIANO IMPLEMENTAZIONE
Basandoti sulla ricerca, proponi:
- Soluzione raccomandata (quella migliore)
- Soluzione alternativa (fallback)
- Step implementazione (ordinati)
- File da modificare
- Test per validare

---

## 📤 OUTPUT RICHIESTO

**File:** `docs/studio/RICERCA_UNBUFFERED_OUTPUT_v123.md`

**Struttura:**
```markdown
# RICERCA: Unbuffered Output per Worker Headless

## OVERVIEW
- Problema
- Goal
- Approcci ricercati

## TEORIA

### Python Buffering
[Spiegazione + esempi]

### stdbuf
[Spiegazione + esempi]

### tmux
[Spiegazione + comportamento]

### Claude CLI
[Analisi comportamento]

## ANALISI CODICE ESISTENTE

### spawn-workers.sh
[Riga comando attuale]
[Dove inserire unbuffered]

### watcher-regina.sh
[Come cattura output ora]
[Come potrebbe catturare realtime]

## SOLUZIONI PROPOSTE

### SOLUZIONE 1: [Nome]
**Implementazione:** [come fare]
**Pro:** [vantaggi]
**Contro:** [svantaggi]
**Complessità:** BASSA/MEDIA/ALTA
**Test:** [come testare]
**Risk:** BASSO/MEDIO/ALTO

[Ripeti per ogni soluzione...]

## RACCOMANDAZIONE

**Soluzione scelta:** [quale]
**Perché:** [motivazione]
**Fallback:** [se prima non funziona]

## PIANO IMPLEMENTAZIONE

### Step 1: [descrizione]
- File: [quale]
- Modifica: [cosa]
- Test: [come verificare]

[Continua step...]

## QUERY SQL (Bonus)

Lezione da aggiungere al database dopo implementazione:
```sql
INSERT INTO lessons_learned ...
```

## PROSSIMI STEP

Chi fa cosa:
- cervella-devops: Implementa soluzione in spawn-workers
- cervella-tester: Crea HARDTEST per verificare
- Regina: Review e approve
```

---

## ✅ CRITERI DI SUCCESSO

- [x] Compreso come funziona buffering Python/bash/tmux
- [x] Almeno 3 soluzioni proposte
- [x] Pro/contro per ogni soluzione
- [x] Raccomandazione chiara con motivazione
- [x] Piano implementazione step-by-step
- [x] File da modificare identificati
- [x] Test strategy definita

---

## 💡 SUGGERIMENTI

- Cerca "python unbuffered output tmux" per casi simili
- Testa comandi semplici prima (es. `while true; do echo test; sleep 1; done`)
- Verifica se problema è Python, tmux, o entrambi
- Considera edge cases (errori, output molto lungo, etc.)
- Pensa a watcher-regina: come dovrebbe catturare output live?

---

## 🔗 RIFERIMENTI UTILI

- Python docs: sys.stdout buffering
- Man page: stdbuf(1)
- tmux man page: pipe-pane, capture-pane
- Stack Overflow: "unbuffered output tmux detached"

---

## ⏰ TEMPO STIMATO

1-1.5 ore (ricerca approfondita)

---

**Buon lavoro, cervella-researcher!** 🔬

*La Regina conta su di te per trovare la soluzione migliore!*

---

## 📝 NOTA PER CERVELLA-RESEARCHER

Questa ricerca è **critica** perché:
1. È lezione #11 nel database (già documentata come problema)
2. Impatta UX: vogliamo vedere worker mentre lavora
3. Aiuta debugging: se worker stuck, lo vediamo subito
4. Parte di Sprint 2 (Priorità ALTA) del consolidamento

Fai ricerca APPROFONDITA ma PRATICA. Vogliamo soluzioni che FUNZIONANO, non teoria astratta!

💙
