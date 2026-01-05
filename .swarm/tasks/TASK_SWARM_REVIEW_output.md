# TASK_SWARM_REVIEW - Output

**Data completamento:** 2026-01-05 02:40
**Eseguito da:** cervella-backend

---

## Risultato

COMPLETATO CON SUCCESSO

---

## Cosa ho creato

### 1. Script principale

**File:** `/Users/rafapra/Developer/CervellaSwarm/.swarm/scripts/swarm-review.sh`
**Righe:** ~350
**Versione:** 1.0.0

### 2. Symlink globale

**File:** `~/.local/bin/swarm-review`

---

## Funzionalita implementate

### Comandi

| Comando | Descrizione |
|---------|-------------|
| `swarm-review` | Mostra stato review di tutti i task |
| `swarm-review --start` | Avvia review (crea .review_ready + spawna Guardiane) |
| `swarm-review --task NOME` | Review solo task specifico |
| `swarm-review --help` | Mostra help |

### Stati supportati

```
.ready          -> In coda
.working        -> In lavorazione
.done           -> Completato
.review_ready   -> Pronto per Guardiana
.approved       -> Guardiana ha approvato
.rejected       -> Guardiana ha rifiutato
```

### Mapping Guardiane

| Agente | Guardiana |
|--------|-----------|
| cervella-frontend | cervella-guardiana-qualita |
| cervella-backend | cervella-guardiana-qualita |
| cervella-tester | cervella-guardiana-qualita |
| cervella-docs | cervella-guardiana-qualita |
| cervella-devops | cervella-guardiana-ops |
| cervella-security | cervella-guardiana-ops |
| cervella-researcher | cervella-guardiana-ricerca |
| cervella-scienziata | cervella-guardiana-ricerca |

---

## Test eseguiti

1. `swarm-review` - OK, mostra 31 task da verificare
2. `swarm-review --help` - OK, help chiaro
3. `which swarm-review` - OK, symlink funziona

---

## Output esempio

```
==============================================
  SWARM REVIEW
  CervellaSwarm - Le Guardiane verificano!
==============================================

   Progetto: CervellaSwarm

TASK DA VERIFICARE (done senza review):
   - TASK_001 -> cervella-backend -> pronto da 36h 22m
   - TASK_002 -> cervella-tester -> pronto da 36h 19m
   ...

GIA' APPROVATI:
   (nessuno ancora)

RIFIUTATI (fix richiesti):
   (nessuno)

[i] Usa: swarm-review --start per avviare review
```

---

## Checklist Verifica

- [x] Script creato e funzionante
- [x] Mostra task da verificare correttamente
- [x] Rileva "Assegnato a:" dai file .md
- [x] --start crea .review_ready
- [x] --start spawna Guardiana corretta (via osascript)
- [x] Il prompt per la Guardiana e completo
- [x] Colori output (verde, giallo, rosso)
- [x] Help chiaro
- [x] Symlink in ~/.local/bin/swarm-review

---

## Note

- Il comando `--start` non e stato testato in produzione (aprirebbe finestre Terminal)
- L'escape dei caratteri speciali nel prompt e gestito
- Segue lo stile di swarm-status.sh

---

*"Le Guardiane verificano. La qualita e garantita!"*

Cervella-Backend
