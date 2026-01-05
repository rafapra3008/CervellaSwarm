# Task: Creare quick-task Command (Ridurre Frizione!)

**Assegnato a:** cervella-backend
**Stato:** ready
**Priorita:** ALTA
**Data:** 5 Gennaio 2026

---

## Contesto

Lo studio TASK_STUDIO_AUTONOMIA_REGINA ha identificato che la Regina viola la Regola 13 perché spawn-workers ha frizione 6:1 rispetto a Edit diretto.

**Soluzione:** Creare comando `quick-task` che riduce la frizione.

---

## Obiettivo

Creare `~/.local/bin/quick-task` che automatizza:
1. Creazione TASK_*.md
2. Creazione file .ready
3. Spawn del worker appropriato

---

## Specifiche

### Uso

```bash
# Sintassi
quick-task "descrizione task" --[worker]

# Esempi
quick-task "Fix bug authentication" --backend
quick-task "Add dark mode toggle" --frontend
quick-task "Write unit tests for api" --tester
quick-task "Update README" --docs
```

### Worker Supportati

- `--backend` → cervella-backend
- `--frontend` → cervella-frontend
- `--tester` → cervella-tester
- `--docs` → cervella-docs
- `--reviewer` → cervella-reviewer
- `--devops` → cervella-devops
- `--researcher` → cervella-researcher

### Comportamento

1. **Trova progetto** - Usa stessa logica di spawn-workers (cerca .swarm/)
2. **Genera nome task** - `TASK_[TIMESTAMP]_[SLUG].md`
3. **Crea file task** - Template con descrizione e worker assegnato
4. **Crea file .ready** - Marca come pronto
5. **Spawna worker** - Chiama spawn-workers --[worker]
6. **Output** - Mostra messaggio di conferma

### Template Task Generato

```markdown
# Task: [DESCRIZIONE]

**Assegnato a:** cervella-[WORKER]
**Stato:** ready
**Priorita:** MEDIA
**Data:** [DATA]
**Generato da:** quick-task command

---

## Obiettivo

[DESCRIZIONE]

---

## Note

Task creato automaticamente dalla Regina via quick-task.
Completare e scrivere output in TASK_*_output.md.

---

*Quick-task v1.0.0*
```

---

## Opzioni Aggiuntive (Nice to Have)

```bash
# Priorità
quick-task "Fix critical bug" --backend --priority=alta

# Aspetta completamento
quick-task "Quick fix" --backend --wait

# Solo crea task (non spawna)
quick-task "For later" --backend --no-spawn

# Verbose
quick-task "Debug something" --backend -v
```

---

## Output Atteso

1. File `~/.local/bin/quick-task` eseguibile
2. Symlink o aggiunta a PATH
3. Test funzionante con almeno 3 worker diversi

---

## Checklist Verifica

- [ ] Script creato in ~/.local/bin/quick-task
- [ ] Eseguibile (chmod +x)
- [ ] Trova .swarm/ correttamente
- [ ] Genera TASK_*.md con formato corretto
- [ ] Crea file .ready
- [ ] Chiama spawn-workers correttamente
- [ ] Testato con --backend
- [ ] Testato con --frontend
- [ ] Testato con --docs
- [ ] Output chiaro e colorato

---

## Esempio Completo

```bash
$ quick-task "Add validation to login form" --frontend

🐝 QUICK-TASK v1.0.0
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 Task creato: TASK_20260105_043500_validation_login.md
📂 Progetto: /Users/rafapra/Developer/miracollogeminifocus
👷 Worker: cervella-frontend

✅ Worker spawnato! Guarda la finestra Terminal.

Per monitorare: swarm-status
```

---

*Task creato da Cervella Regina - Sessione 90*
*"Rendi facile fare la cosa giusta!"*
