---
task_id: TEST_SCENARIO_STANDARD
assigned_to: cervella-backend
priority: medium
timeout_minutes: 10
created_at: 2026-01-07T15:40:00Z
created_by: cervella-tester
project: CervellaSwarm
---

# Task Test: Creare File di Test

**Status:** ready

---

## OBIETTIVO

Creare un file di test in `.swarm/test/hello_backend.txt` con contenuto:
```
Hello from cervella-backend!
Timestamp: [DATA ATTUALE]
Task ID: TEST_SCENARIO_STANDARD
```

**Output atteso:**
- File creato correttamente
- Output report creato

---

## SUCCESS CRITERIA

- [ ] File `.swarm/test/hello_backend.txt` creato
- [ ] Contenuto contiene "Hello from cervella-backend!"
- [ ] Output report creato in `.swarm/tasks/TEST_SCENARIO_STANDARD_OUTPUT.md`
- [ ] Marker `.swarm/tasks/TEST_SCENARIO_STANDARD.done` creato

**Definition of Done:**
File esiste con contenuto corretto, output creato, marker .done presente.

---

## FILE RILEVANTI

**Da creare:**
- `.swarm/test/hello_backend.txt` - file di test
- `.swarm/tasks/TEST_SCENARIO_STANDARD_OUTPUT.md` - report

---

## OUTPUT RICHIESTO

1. Crea il file di test
2. Crea output report con cosa hai fatto
3. Crea marker `.swarm/tasks/TEST_SCENARIO_STANDARD.done`

---

## TEMPO

**Timeout:** 10 minuti
**Priorita:** medium
**Heartbeat:** Ogni 60s

---

**Task semplice di test!** 🧪
