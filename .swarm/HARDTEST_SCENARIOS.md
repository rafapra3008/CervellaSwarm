# HARDTEST SCENARIOS - CervellaSwarm

> **Data:** 8 Gennaio 2026
> **Obiettivo:** Testare TUTTI gli scenari critici per garantire sistema 100000%

---

## CATEGORIA 1: BLOCCO REGINA

| # | Scenario | Come Testare | Risultato Atteso |
|---|----------|--------------|------------------|
| 1.1 | Regina prova a editare file random | `Edit` su file non in whitelist | BLOCCATO con messaggio |
| 1.2 | Regina prova a creare file nuovo | `Write` su path non in whitelist | BLOCCATO con messaggio |
| 1.3 | Regina edita file whitelist | `Edit` su PROMPT_RIPRESA.md | PERMESSO |
| 1.4 | Regina edita .swarm/tasks/* | `Write` task file | PERMESSO |
| 1.5 | Worker edita file qualsiasi | spawn-workers + edit | PERMESSO (CERVELLASWARM_WORKER=1) |

---

## CATEGORIA 2: SPAWN-WORKERS

| # | Scenario | Come Testare | Risultato Atteso |
|---|----------|--------------|------------------|
| 2.1 | Spawn singolo worker | `spawn-workers --backend` | Finestra aperta, task processato |
| 2.2 | Spawn multipli paralleli | `spawn-workers --all` | 3 finestre, nessun conflitto |
| 2.3 | Spawn oltre MAX_WORKERS | `spawn-workers --all --guardiane` | Limite 5, warning |
| 2.4 | Spawn senza task | Spawn con .swarm/tasks vuoto | Worker fa /exit |
| 2.5 | Spawn con task già .working | Task già preso da altro | Worker ignora, cerca altro |
| 2.6 | Worker crash mid-task | Kill processo durante lavoro | .working rimane (cleanup?) |

---

## CATEGORIA 3: TASK LIFECYCLE

| # | Scenario | Come Testare | Risultato Atteso |
|---|----------|--------------|------------------|
| 3.1 | Task completo ciclo | .md → .ready → .working → .done | Output in _output.md |
| 3.2 | Task timeout | Task che dura troppo | Notifica stuck |
| 3.3 | Task senza .ready | Solo .md presente | Worker ignora |
| 3.4 | Task .done senza output | Simula completamento rotto | Rilevato come anomalia |
| 3.5 | Task duplicato | Due worker stesso task | Solo uno lo prende |

---

## CATEGORIA 4: COMUNICAZIONE WORKER-REGINA

| # | Scenario | Come Testare | Risultato Atteso |
|---|----------|--------------|------------------|
| 4.1 | Notifica completamento | Task finisce | macOS notification |
| 4.2 | Watcher sveglia Regina | .done creato | Regina riceve notifica |
| 4.3 | Feedback worker | Worker scrive in .swarm/feedback | Regina legge |
| 4.4 | Handoff worker | Worker non sa procedere | Scrive in .swarm/handoff |
| 4.5 | Heartbeat attivo | Worker lavora | Heartbeat ogni 60s |

---

## CATEGORIA 5: TASK TOOL INTERNO

| # | Scenario | Come Testare | Risultato Atteso |
|---|----------|--------------|------------------|
| 5.1 | Task semplice | Task tool con prompt breve | Output corretto |
| 5.2 | Task con edit | Task tool che deve editare file | Funziona (no blocco) |
| 5.3 | Task paralleli | Multiple Task calls insieme | Tutti completano |
| 5.4 | Task annidato | Task che spawna altro Task | Funziona |
| 5.5 | Task lungo | Task che richiede molto tempo | Completa senza timeout |

---

## CATEGORIA 6: HOOKS & AUTOMATION

| # | Scenario | Come Testare | Risultato Atteso |
|---|----------|--------------|------------------|
| 6.1 | SessionStart hook | Avvia nuova sessione | Notifica + context loaded |
| 6.2 | PreCompact hook | Triggera compact | Salvataggio automatico |
| 6.3 | SessionEnd hook | Chiudi sessione | Salvataggio finale |
| 6.4 | Hook failure | Hook con errore | Sessione continua (graceful) |
| 6.5 | Hook timeout | Hook lento | Timeout rispettato |

---

## CATEGORIA 7: EDGE CASES CRITICI

| # | Scenario | Come Testare | Risultato Atteso |
|---|----------|--------------|------------------|
| 7.1 | File modificato da 2 worker | Due task stesso file | Conflitto gestito |
| 7.2 | .swarm/ corrotto | Elimina status file | Sistema recupera |
| 7.3 | Progetto senza .swarm | spawn-workers in dir vuota | Crea struttura |
| 7.4 | Path con spazi | Task con path "con spazi" | Gestito correttamente |
| 7.5 | Unicode in task | Task con emoji/unicode | Funziona |
| 7.6 | Task enorme | Output molto lungo | Gestito/troncato |

---

## CATEGORIA 8: MULTI-PROGETTO

| # | Scenario | Come Testare | Risultato Atteso |
|---|----------|--------------|------------------|
| 8.1 | Switch progetto | Da CervellaSwarm a Miracollo | Contesto separato |
| 8.2 | Worker in progetto sbagliato | spawn-workers da altro dir | Trova .swarm corretto |
| 8.3 | swarm-global-status | Stato tutti progetti | Report aggregato |

---

## PRIORITÀ HARDTEST

### MUST PASS (Bloccanti)
- 1.1, 1.2, 1.3, 1.5 (Blocco funziona correttamente)
- 2.1, 2.2 (spawn-workers base)
- 3.1 (Task lifecycle completo)
- 4.1, 4.2 (Notifiche funzionano)

### SHOULD PASS (Importanti)
- 2.4, 2.5 (Gestione edge cases spawn)
- 3.2, 3.5 (Timeout e duplicati)
- 5.1, 5.2 (Task tool)
- 6.1, 6.2, 6.3 (Hooks principali)

### NICE TO PASS (Bonus)
- 7.* (Edge cases vari)
- 8.* (Multi-progetto)

---

## COME ESEGUIRE

```bash
# Dalla prossima sessione (dopo restart per hooks):

# Test blocco
# Prova Edit su file random → deve bloccare

# Test spawn
spawn-workers --backend  # Singolo
spawn-workers --all      # Multipli

# Test lifecycle
# Crea task, spawna, verifica output

# Test hooks
# Verifica notifiche all'avvio
```

---

*Creato: 8 Gennaio 2026*
*In attesa: Ricerca edge cases da cervella-researcher*
