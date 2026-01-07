# Known Issue: Heartbeat False Positive durante Task Multipli

**Data:** 7 Gennaio 2026 - Sessione 114
**Severity:** LOW (non blocca funzionalità)
**Status:** DOCUMENTED (fix planned dopo HARDTEST)

---

## Problema

Durante task che richiedono **Edit multipli** (es: 11 file DNA), il watcher rileva "Worker stuck" anche se il worker sta lavorando correttamente.

### Caso Specifico

**Task:** `TASK_DNA_UPDATE_11_WORKERS` (cervella-docs)
- 11 file da editare sequenzialmente
- Worker completato con successo
- **MA** 2x alert "Worker stuck detected"

**Output:**
```
[!] Worker stuck detected
[!] Worker stuck detected
[!] Rilevato: TASK_DNA_UPDATE_11_WORKERS completato!
```

**Risultato:** ✅ Task completato, ma alert spurii

---

## Causa (Ipotesi)

### Ipotesi 1: Heartbeat non si avvia in spawned worker
- `spawn-workers` crea nuova finestra
- `heartbeat-worker.sh &` potrebbe non partire automaticamente
- Worker lavora SENZA heartbeat → stuck detection

### Ipotesi 2: Edit multipli bloccano heartbeat
- Worker fa 11 Edit consecutivi (~30 min)
- Heartbeat si ferma durante operazioni intensive
- Timeout 2min scatta → falso positivo

### Ipotesi 3: Timeout troppo stretto
- Regola attuale: no heartbeat 2min = stuck
- Task complessi (11 Edit) richiedono 3-5min continuativi
- Timeout inadeguato per task lunghi

---

## Impact

**Funzionale:** ZERO (task completa correttamente)

**UX:** BASSO (alert confondono ma non bloccano)

**Confidence:** MEDIO (possiamo ignorare se task completa)

---

## Workaround Attuale

**Per Regina:**
```
SE vedo "Worker stuck" MA task poi completa:
→ È falso positivo
→ Verifico output task (.done + _OUTPUT.md)
→ Se output OK → ignoro alert
```

**Per Worker:**
```
Nessuna azione richiesta
(heartbeat dovrebbe essere automatico)
```

---

## Fix Proposti (DA IMPLEMENTARE)

### Fix 1: Auto-start Heartbeat in spawn-workers ⭐ (RACCOMANDATO)

**File:** `~/.claude/scripts/spawn-workers`

**Modificare per:**
```bash
# Dopo spawn worker, auto-start heartbeat
nohup scripts/swarm/heartbeat-worker.sh > /dev/null 2>&1 &
echo $! > .swarm/pids/heartbeat_${WORKER_NAME}.pid
```

**Pro:**
- Garantisce heartbeat sempre attivo
- Fix una tantum nello script spawn
- Funziona per TUTTI i worker

**Contro:**
- Richiede test per verificare funzionamento

---

### Fix 2: Heartbeat Indipendente

**Creare:** `scripts/swarm/heartbeat-daemon.sh`

**Logica:**
```bash
# Background daemon che NON si ferma mai
# Scrive heartbeat anche durante Edit/operazioni pesanti
# PID salvato in .swarm/pids/ per kill
```

**Pro:**
- Heartbeat robusto
- Non impatta performance worker

**Contro:**
- Più complesso da implementare

---

### Fix 3: Timeout Dinamico

**Modificare:** `scripts/swarm/check-stuck.sh`

**Logica:**
```bash
# Timeout basato su complessità task
# Se task ha "multiple files" → timeout 5min
# Altrimenti → timeout 2min
```

**Pro:**
- Riduce falsi positivi
- Facile da implementare

**Contro:**
- Maschera problema vero (heartbeat dovrebbe funzionare!)

---

## Piano Fix

**Priorità:** DOPO HARDTEST comunicazione v2

**Step:**
1. Completare HARDTEST (FASE 6)
2. Studio approfondito heartbeat (cervella-researcher)
3. Implementare Fix 1 (auto-start in spawn-workers)
4. Test con task multipli
5. Documentare in CHANGELOG

**Owner:** cervella-devops (implementazione)
**Reviewer:** cervella-guardiana-ops (verifica sicurezza)

---

## Riferimenti

- **Task originale:** `.swarm/tasks/TASK_DNA_UPDATE_11_WORKERS.md`
- **Output task:** `.swarm/tasks/TASK_DNA_UPDATE_11_WORKERS_OUTPUT.md`
- **Watcher:** `scripts/swarm/watcher-regina.sh`
- **Heartbeat:** `scripts/swarm/heartbeat-worker.sh`
- **Spawn:** `~/.claude/scripts/spawn-workers`

---

**Conclusione:** Falso positivo NOTO e GESTIBILE. Fix pianificato post-HARDTEST.

💙 *Documentato con CURA dalla Regina - 7 Gen 2026*
