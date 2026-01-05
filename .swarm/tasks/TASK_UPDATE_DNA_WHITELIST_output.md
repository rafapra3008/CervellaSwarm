# Output: TASK_UPDATE_DNA_WHITELIST

**Completato da:** cervella-docs
**Data:** 5 Gennaio 2026
**Stato:** DONE

---

## Cosa Ho Fatto

### 1. Aggiornato cervella-orchestrator.md

Aggiunta **Regola 15: WHITELIST FILE** dopo la Regola 14.

La nuova regola definisce:
- **5 file/pattern** che la Regina puo modificare direttamente
- Comando `quick-task` come alternativa
- Comando `spawn-workers` per task complessi
- Regola "SE IN DUBBIO -> quick-task!"

### 2. Aggiornato CHECKLIST_AZIONE.md

Aggiunta sezione **"PRIMA DI OGNI EDIT (Whitelist Check!)"** con:
- Checklist visiva della whitelist
- Comandi pronti da copiare
- Logica decisionale chiara

---

## File Modificati

| File | Azione |
|------|--------|
| `~/.claude/agents/cervella-orchestrator.md` | Aggiunta Regola 15 (righe 422-448) |
| `~/.claude/CHECKLIST_AZIONE.md` | Aggiunta sezione Whitelist (righe 83-106) |

---

## Whitelist Finale

| File/Pattern | Motivo |
|--------------|--------|
| `NORD.md` | Bussola progetto |
| `PROMPT_RIPRESA.md` | Memoria sessione |
| `ROADMAP_SACRA.md` | Changelog |
| `.swarm/tasks/*.md` | Creare task per worker |
| `.swarm/handoff/*.md` | Comunicazione guardiane |

---

## Checklist Verifica

- [x] Regola 15 aggiunta a cervella-orchestrator.md
- [x] Whitelist chiara e memorizzabile
- [x] Comando quick-task documentato
- [x] CHECKLIST_AZIONE aggiornata
- [x] Nessuna duplicazione con sezioni esistenti

---

*Task completato da cervella-docs*
