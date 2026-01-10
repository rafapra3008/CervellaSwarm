# PROTOCOLLI COMUNICAZIONE SWARM v1.0.0

> **Questo file contiene i protocolli COMPLETI.**
> **Gli agenti hanno una versione compatta con reference qui.**

---

## Quick Reference per Agenti

Copia questo blocco nel tuo agent file invece dei protocolli lunghi:

```markdown
## PROTOCOLLI COMUNICAZIONE SWARM v1.0.0

**Documentazione completa:** docs/protocolli/PROTOCOLLI_BASE.md

### Quick Reference

**Script Status:**
- `scripts/swarm/update-status.sh WORKING "descrizione"`
- `scripts/swarm/heartbeat-worker.sh &`
- `scripts/swarm/update-status.sh DONE "completato"`

**Feedback alla Regina:**
- `scripts/swarm/ask-regina.sh QUESTION "domanda"`
- `scripts/swarm/ask-regina.sh ISSUE "problema"`
- `scripts/swarm/ask-regina.sh BLOCKER "bloccante"`

**Workflow Standard:**
1. Leggi task: `.swarm/tasks/TASK_*.md`
2. update-status.sh WORKING + heartbeat.sh &
3. LAVORA sul task
4. Crea output: `.swarm/tasks/TASK_*_OUTPUT.md`
5. touch `.swarm/tasks/TASK_*.done`
6. update-status.sh DONE
```

---

## SEZIONE COMPLETA: Status Updates

### Script Helper

```bash
# Avvio task
scripts/swarm/update-status.sh WORKING "Descrizione breve"

# Heartbeat automatico (ogni 60s)
scripts/swarm/heartbeat-worker.sh &

# Completamento
scripts/swarm/update-status.sh DONE "Cosa ho fatto"

# Errore
scripts/swarm/update-status.sh ERROR "Cosa è andato storto"
```

### Status Possibili

| Status | Quando | Colore |
|--------|--------|--------|
| IDLE | In attesa di task | Grigio |
| WORKING | Task in corso | Blu |
| DONE | Task completato | Verde |
| ERROR | Problema | Rosso |
| BLOCKED | In attesa di input | Giallo |

---

## SEZIONE COMPLETA: Feedback alla Regina

### Tipi di Feedback

```bash
# Domanda (non bloccante)
scripts/swarm/ask-regina.sh QUESTION "Quale scope per questa ricerca?"

# Problema (attenzione richiesta)
scripts/swarm/ask-regina.sh ISSUE "Ho trovato un problema in X"

# Bloccante (stop finché non risolto)
scripts/swarm/ask-regina.sh BLOCKER "Non posso procedere senza Y"
```

### Quando Usare Quale

| Tipo | Esempio | Regina Deve |
|------|---------|-------------|
| QUESTION | "Includo anche X?" | Rispondere quando può |
| ISSUE | "Ho trovato bug in Y" | Notare, decidere priorità |
| BLOCKER | "Manca accesso a Z" | Risolvere prima di continuare |

---

## SEZIONE COMPLETA: Workflow Task

### 1. Ricevo Task

```
.swarm/tasks/TASK_001_descrizione.md
```

Contiene:
- Obiettivo
- Success criteria
- File coinvolti
- Deadline (se presente)

### 2. Avvio Lavoro

```bash
# Segnalo che sto lavorando
scripts/swarm/update-status.sh WORKING "Descrizione task"

# Avvio heartbeat (prova che sono viva)
scripts/swarm/heartbeat-worker.sh &
```

### 3. Lavoro sul Task

- Leggo file necessari
- Faccio modifiche
- Verifico risultato
- Se dubbi → ask-regina.sh

### 4. Completo

```bash
# Creo output
cat > .swarm/tasks/TASK_001_OUTPUT.md << 'EOF'
# Output: [Nome Task]

## Risultato
✅ Completato | ⚠️ Parziale | ❌ Fallito

## Cosa Ho Fatto
- [lista azioni]

## File Modificati
- [lista file con path]

## Note
- [info importanti]

## Next
- [se serve follow-up]
EOF

# Segnalo completamento
touch .swarm/tasks/TASK_001.done
scripts/swarm/update-status.sh DONE "Task completato"
```

---

## SEZIONE COMPLETA: Comunicazione Inter-Agente

### Passaggio di Consegne

Se devo passare lavoro a altro agente:

```bash
cat > .swarm/handoff/HANDOFF_$(date +%Y%m%d_%H%M%S).md << 'EOF'
# Handoff: [Da Chi] → [A Chi]

## Contesto
[Cosa stavo facendo]

## Stato Attuale
[Dove sono arrivata]

## Da Fare
[Cosa deve fare il prossimo agente]

## File Importanti
- [lista file rilevanti]

## Note
- [info utili]
EOF
```

### Richiesta Aiuto Specifico

```bash
# Chiedo aiuto a agente specifico
scripts/swarm/ask-help.sh cervella-backend "Ho bisogno di endpoint per X"
```

---

## SEZIONE COMPLETA: Error Handling

### Se Task Fallisce

```bash
# 1. Documenta errore
cat > .swarm/tasks/TASK_001_ERROR.md << 'EOF'
# Errore: [Nome Task]

## Problema
[Descrizione errore]

## Causa Probabile
[Cosa penso sia successo]

## Tentato
[Cosa ho provato]

## Suggerimento
[Come risolvere]
EOF

# 2. Segnala
scripts/swarm/update-status.sh ERROR "Task fallito: [motivo]"
scripts/swarm/ask-regina.sh BLOCKER "Task fallito, serve aiuto"
```

### Se Stuck >15 Minuti

```bash
# Segnala che sono bloccata
scripts/swarm/ask-regina.sh ISSUE "Stuck da 15+ min su [cosa]"
```

---

## SEZIONE COMPLETA: File Locations

### Input
- Task: `.swarm/tasks/TASK_*.md`
- Contesto: `.swarm/context/`
- Config: `.swarm/config/`

### Output
- Risultati: `.swarm/tasks/TASK_*_OUTPUT.md`
- Completamento: `.swarm/tasks/TASK_*.done`
- Errori: `.swarm/tasks/TASK_*_ERROR.md`

### Comunicazione
- Handoff: `.swarm/handoff/`
- Status: `.swarm/status/`
- Logs: `.swarm/logs/`

---

## Versioning

| Versione | Data | Cambiamenti |
|----------|------|-------------|
| 1.0.0 | 7 Gen 2026 | Versione iniziale |
| 1.0.1 | 10 Gen 2026 | Aggiunto Quick Reference |

---

*"La comunicazione interna deve essere meglio!"* - Rafa, 7 Gennaio 2026
