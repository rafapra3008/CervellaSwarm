# Output: TASK_QUICK_TASK_COMMAND

**Worker:** cervella-backend
**Data completamento:** 5 Gennaio 2026 04:27
**Stato:** COMPLETATO

---

## Cosa Ho Fatto

### 1. Creato script `~/.local/bin/quick-task`

Script bash completo che:
- Trova automaticamente la root del progetto (cerca `.swarm/`)
- Genera nome task con timestamp + slug descrizione
- Crea file `TASK_*.md` con template completo
- Crea file `.ready` per marcare come pronto
- Spawna automaticamente il worker appropriato

### 2. Caratteristiche Implementate

**Uso base:**
```bash
quick-task "Fix bug authentication" --backend
quick-task "Add dark mode toggle" --frontend
quick-task "Write unit tests" --tester
```

**Worker supportati:**
- `--backend` - cervella-backend
- `--frontend` - cervella-frontend
- `--tester` - cervella-tester
- `--docs` - cervella-docs
- `--reviewer` - cervella-reviewer
- `--devops` - cervella-devops
- `--researcher` - cervella-researcher
- `--data` - cervella-data
- `--security` - cervella-security
- `--scienziata` - cervella-scienziata
- `--ingegnera` - cervella-ingegnera

**Opzioni aggiuntive:**
- `--priority=alta|media|bassa` - Imposta priorita
- `--no-spawn` - Solo crea task, non spawna worker
- `-v, --verbose` - Output dettagliato
- `-h, --help` - Mostra help

### 3. Test Eseguiti

1. **--backend** - OK - Task creato, formato corretto
2. **--frontend** - OK - Task creato, formato corretto
3. **--tester con --priority=alta** - OK - Priorita impostata correttamente

Tutti i test passati!

---

## File Creato

```
~/.local/bin/quick-task  (eseguibile, 287 righe)
```

---

## Checklist Verifica

- [x] Script creato in ~/.local/bin/quick-task
- [x] Eseguibile (chmod +x)
- [x] Trova .swarm/ correttamente
- [x] Genera TASK_*.md con formato corretto
- [x] Crea file .ready
- [x] Chiama spawn-workers correttamente
- [x] Testato con --backend
- [x] Testato con --frontend
- [x] Testato con --tester (con --priority=alta)
- [x] Output chiaro e colorato

---

## Come Usare

La Regina ora puo usare:

```bash
# Invece di:
# 1. Creare TASK_*.md a mano
# 2. Scrivere contenuto
# 3. touch .ready
# 4. spawn-workers --backend

# Ora basta:
quick-task "Descrizione task" --backend
```

**Frizione ridotta da 6 passi a 1!**

---

## Note

- Lo script e gia nel PATH (`~/.local/bin/` dovrebbe essere nel PATH)
- Se `spawn-workers` non e nel PATH, lo cerca in:
  - `~/.local/bin/spawn-workers`
  - `[project_root]/scripts/swarm/spawn-workers.sh`

---

*Task completato da cervella-backend*
*"Rendi facile fare la cosa giusta!"*
