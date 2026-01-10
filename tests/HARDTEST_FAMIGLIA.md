# HARDTEST FAMIGLIA - Suite di Test Completa

> **Data:** 10 Gennaio 2026
> **Scopo:** Verificare che tutta la famiglia funzioni correttamente
> **Tempo stimato:** 30-45 minuti

---

## Pre-Requisiti

```bash
# Verifica stdbuf installato
which stdbuf  # Deve mostrare path

# Verifica tmux
which tmux    # Deve mostrare path

# Verifica spawn-workers
which spawn-workers  # Deve mostrare path

# Verifica API key
echo $ANTHROPIC_API_KEY | head -c 10  # Deve mostrare inizio key
```

---

## TEST 1: Spawn Worker Base

**Obiettivo:** Verificare che spawn-workers funzioni

```bash
cd ~/Developer/CervellaSwarm
spawn-workers --list
```

**Expected:** Lista di tutti i worker disponibili

**Risultato:** [ ] PASS / [ ] FAIL

---

## TEST 2: Spawn Headless

**Obiettivo:** Verificare spawn in tmux

```bash
# Crea task di test
mkdir -p .swarm/tasks
cat > .swarm/tasks/TASK_TEST_001.md << 'EOF'
# Task: Test Spawn
**Assegnato a:** cervella-tester
**Obiettivo:** Verifica che lo spawn funzioni
**Success criteria:** Rispondere "SPAWN TEST OK"
EOF
touch .swarm/tasks/TASK_TEST_001.ready

# Spawn tester
spawn-workers --tester

# Attendi 30 secondi
sleep 30

# Verifica sessione tmux
tmux list-sessions | grep swarm_tester
```

**Expected:** Sessione tmux attiva

**Risultato:** [ ] PASS / [ ] FAIL

---

## TEST 3: Output Real-Time (stdbuf)

**Obiettivo:** Verificare che output sia unbuffered

```bash
# Durante spawn, guarda il log in tempo reale
tail -f .swarm/logs/worker_tester_*.log
```

**Expected:** Output appare riga per riga, non a blocchi

**Risultato:** [ ] PASS / [ ] FAIL

---

## TEST 4: Researcher Post-Write Verification

**Obiettivo:** Verificare che researcher verifichi i file scritti

```bash
# Crea task per researcher
cat > .swarm/tasks/TASK_RESEARCHER_TEST.md << 'EOF'
# Task: Test Write Verification
**Assegnato a:** cervella-researcher
**Obiettivo:** Scrivi un file di test e VERIFICA che esista
**Success criteria:**
1. Scrivi file in .sncp/test/TEST_WRITE.md
2. Usa Read per verificare che esista
3. Conferma "File salvato e verificato"
EOF
touch .swarm/tasks/TASK_RESEARCHER_TEST.ready

# Spawn researcher
spawn-workers --researcher

# Attendi completamento
sleep 60

# Verifica file esiste
ls -la .sncp/test/TEST_WRITE.md
```

**Expected:** File esiste E log mostra "verificato"

**Risultato:** [ ] PASS / [ ] FAIL

---

## TEST 5: Guardiana Review

**Obiettivo:** Verificare workflow Guardiana

```bash
# Crea task per guardiana
cat > .swarm/tasks/TASK_REVIEW_TEST.md << 'EOF'
# Task: Review Test
**Assegnato a:** cervella-guardiana-qualita
**Obiettivo:** Verifica che cervella-backend.md rispetti gli standard
**Success criteria:** Score e verdetto
EOF
touch .swarm/tasks/TASK_REVIEW_TEST.review_ready

# Spawn guardiana
spawn-workers --guardiana-qualita

# Attendi
sleep 60

# Verifica output
cat .swarm/tasks/TASK_REVIEW_TEST_output.md
```

**Expected:** Output con Score e Verdetto

**Risultato:** [ ] PASS / [ ] FAIL

---

## TEST 6: Multi-Worker Parallelo

**Obiettivo:** Verificare 3 worker in parallelo

```bash
# Crea 3 task diversi
for worker in backend frontend tester; do
cat > .swarm/tasks/TASK_PARALLEL_${worker}.md << EOF
# Task: Parallel Test ${worker}
**Assegnato a:** cervella-${worker}
**Obiettivo:** Rispondi con il tuo nome
EOF
touch .swarm/tasks/TASK_PARALLEL_${worker}.ready
done

# Spawn tutti insieme
spawn-workers --backend --frontend --tester

# Attendi
sleep 90

# Verifica tutti completati
ls .swarm/tasks/TASK_PARALLEL_*.done
```

**Expected:** 3 file .done creati

**Risultato:** [ ] PASS / [ ] FAIL

---

## TEST 7: Notifiche macOS

**Obiettivo:** Verificare notifiche funzionino

**Durante i test precedenti:**
- [ ] Notifica appare quando worker inizia
- [ ] Notifica appare quando worker finisce
- [ ] Suono "Glass" per successo
- [ ] Click su notifica apre output

**Risultato:** [ ] PASS / [ ] FAIL

---

## TEST 8: Auto-Sveglia Regina

**Obiettivo:** Verificare watcher funzioni

```bash
# Verifica watcher attivo
cat .swarm/status/watcher.pid
ps aux | grep watcher-regina
```

**Expected:** PID esiste e processo attivo

**Risultato:** [ ] PASS / [ ] FAIL

---

## Cleanup Post-Test

```bash
# Pulisci file di test
rm -f .swarm/tasks/TASK_TEST_*.md
rm -f .swarm/tasks/TASK_TEST_*.ready
rm -f .swarm/tasks/TASK_TEST_*.done
rm -f .swarm/tasks/TASK_TEST_*_output.md

rm -f .swarm/tasks/TASK_RESEARCHER_*.md
rm -f .swarm/tasks/TASK_RESEARCHER_*.ready
rm -f .swarm/tasks/TASK_RESEARCHER_*.done

rm -f .swarm/tasks/TASK_REVIEW_*.md
rm -f .swarm/tasks/TASK_REVIEW_*.review_ready
rm -f .swarm/tasks/TASK_REVIEW_*.done

rm -f .swarm/tasks/TASK_PARALLEL_*.md
rm -f .swarm/tasks/TASK_PARALLEL_*.ready
rm -f .swarm/tasks/TASK_PARALLEL_*.done

rm -rf .sncp/test/

# Kill sessioni tmux di test
tmux kill-session -t swarm_tester 2>/dev/null
tmux kill-session -t swarm_backend 2>/dev/null
tmux kill-session -t swarm_frontend 2>/dev/null
```

---

## Risultati Finali

| Test | Risultato | Note |
|------|-----------|------|
| 1. Spawn Base | | |
| 2. Spawn Headless | | |
| 3. Output Real-Time | | |
| 4. Researcher Verification | | |
| 5. Guardiana Review | | |
| 6. Multi-Worker | | |
| 7. Notifiche | | |
| 8. Auto-Sveglia | | |

**Score Finale:** ___/8

---

## Se Test Falliscono

### Test 1-2 Falliscono
- Verifica `which spawn-workers`
- Verifica `which tmux`
- Verifica `.swarm/` esiste nel progetto

### Test 3 Fallisce
- `brew install coreutils` per stdbuf
- Verifica `which stdbuf`

### Test 4 Fallisce
- Verifica DNA researcher ha regola verifica post-write
- Leggi log per errori

### Test 5-6 Falliscono
- Verifica API key valida
- Verifica crediti Anthropic disponibili

### Test 7-8 Falliscono
- Verifica terminal-notifier installato
- Verifica permessi notifiche macOS

---

*"Nulla è complesso - solo non ancora studiato!"*
