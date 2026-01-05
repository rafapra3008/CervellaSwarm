# Task: Creare comando swarm-review

**Assegnato a:** cervella-backend
**Stato:** ready
**Priorità:** 1 (ALTA)
**Data:** 5 Gennaio 2026

---

## Obiettivo

Creare lo script `swarm-review` che attiva le Guardiane per verificare i task completati.

Questo comando permette alla Regina di:
- Vedere quali task sono completati ma non ancora verificati
- Attivare la Guardiana appropriata per la review
- Tracciare lo stato di approvazione

---

## Contesto

Abbiamo 3 Guardiane pronte:
- cervella-guardiana-qualita (verifica output frontend/backend/tester)
- cervella-guardiana-ops (verifica deploy/security)
- cervella-guardiana-ricerca (verifica ricerche)

Ma non c'è un modo automatico per attivarle dopo che un'ape completa!

---

## Specifiche Tecniche

### Stati dei Task

```
.ready         → In coda
.working       → In lavorazione
.done          → Completato
.review_ready  → Pronto per Guardiana
.approved      → Guardiana ha approvato
.rejected      → Guardiana ha rifiutato
```

### Output Atteso

```
🛡️ SWARM REVIEW
===============
📍 Progetto: [nome]

📋 TASK DA VERIFICARE (done senza approved/rejected):
   - TASK_SWARM_STATUS -> cervella-backend -> pronto da 5m
   - SPLIT_WIDGET -> cervella-frontend -> pronto da 2h

🟢 GIA' APPROVATI:
   - TASK_001 (02:15)
   - TASK_002 (03:20)

🔴 RIFIUTATI (fix richiesti):
   (nessuno)

[i] Usa: swarm-review --start per avviare review
```

### Comandi

```bash
swarm-review              # Mostra stato review
swarm-review --start      # Crea .review_ready e spawna Guardiana
swarm-review --task NOME  # Review task specifico
swarm-review --help       # Help
```

### Logica --start

1. Trova task .done senza .approved/.rejected/.review_ready
2. Legge "Assegnato a:" per capire tipo (frontend/backend/tester)
3. Determina Guardiana appropriata:
   - frontend/backend/tester → cervella-guardiana-qualita
   - devops/security → cervella-guardiana-ops
   - researcher/scienziata → cervella-guardiana-ricerca
4. Crea .review_ready per ogni task
5. Spawna la Guardiana con prompt che include lista task da verificare

### Prompt per Guardiana

Quando spawna la Guardiana, il prompt deve includere:
```
Sei stata attivata per REVIEW.

Task da verificare:
- TASK_SWARM_STATUS (.swarm/tasks/TASK_SWARM_STATUS.md)
  Output: .swarm/tasks/TASK_SWARM_STATUS_output.md
  Assegnato a: cervella-backend

Per ogni task:
1. Leggi il task originale (.md)
2. Leggi l'output (_output.md)
3. Verifica con la tua checklist
4. Crea .approved O .rejected
5. Se rejected, scrivi motivazione in _review.md
```

---

## Output Files

1. **Script principale:** `/Users/rafapra/Developer/CervellaSwarm/.swarm/scripts/swarm-review.sh`
2. **Dopo test:** Symlink in `~/.local/bin/swarm-review`

---

## Checklist Verifica

- [ ] Script creato e funzionante
- [ ] Mostra task da verificare correttamente
- [ ] Rileva "Assegnato a:" dai file .md
- [ ] --start crea .review_ready
- [ ] --start spawna Guardiana corretta
- [ ] Il prompt per la Guardiana è completo
- [ ] Colori output (verde, giallo, rosso)
- [ ] Help chiaro

---

## Note Implementazione

- Usa bash (come spawn-workers e swarm-status)
- Copia stile da swarm-status.sh
- find_project_root() già disponibile in swarm-status
- Colori: GREEN, YELLOW, RED, BLUE, NC
- Versione iniziale: 1.0.0

---

## Riferimenti

- Guarda `.swarm/scripts/swarm-status.sh` per lo stile
- Guarda `~/.local/bin/spawn-workers` per come spawnare
- DNA Guardiana: `~/.claude/agents/cervella-guardiana-qualita.md`

---

*"Le Guardiane verificano. La qualità è garantita!"*

Cervella & Rafa 💙🛡️
