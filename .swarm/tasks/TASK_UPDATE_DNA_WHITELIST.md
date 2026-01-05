# Task: Aggiornare DNA Regina con Whitelist e quick-task

**Assegnato a:** cervella-docs
**Stato:** ready
**Priorita:** ALTA
**Data:** 5 Gennaio 2026

---

## Contesto

Lo studio TASK_STUDIO_AUTONOMIA_REGINA ha definito:
1. **Whitelist** file che la Regina può modificare direttamente
2. **Comando quick-task** per tutto il resto

Ora dobbiamo aggiornare DNA e CHECKLIST.

---

## File da Modificare

### 1. ~/.claude/agents/cervella-orchestrator.md

Aggiungere nella sezione "Regole Inviolabili" (dopo Regola 14):

```markdown
### 15. WHITELIST FILE (Edit Diretto OK)

La Regina PUÒ modificare direttamente SOLO:

| File/Pattern | Motivo |
|--------------|--------|
| `NORD.md` | Bussola progetto |
| `PROMPT_RIPRESA.md` | Memoria sessione |
| `ROADMAP_SACRA.md` | Changelog |
| `.swarm/tasks/*.md` | Creare task per worker |
| `.swarm/handoff/*.md` | Comunicazione guardiane |

**TUTTO IL RESTO → quick-task!**

```bash
# Invece di Edit diretto:
quick-task "descrizione" --backend
quick-task "descrizione" --frontend
quick-task "descrizione" --docs
```

**SE IN DUBBIO → quick-task! Mai Edit diretto.**
```

### 2. ~/.claude/CHECKLIST_AZIONE.md

Aggiornare la sezione "PRIMA DI PROPORRE SOLUZIONE" o aggiungerne una nuova:

```markdown
## PRIMA DI OGNI EDIT (Whitelist Check!)

```
[ ] Il file è nella WHITELIST?

    WHITELIST (Edit OK):
    - NORD.md
    - PROMPT_RIPRESA.md
    - ROADMAP_SACRA.md
    - .swarm/tasks/*.md
    - .swarm/handoff/*.md

    → SÌ: Edit diretto OK
    → NO: usa quick-task "descrizione" --[worker]
    → IN DUBBIO: quick-task!
```
```

---

## Output Atteso

1. cervella-orchestrator.md aggiornato con Regola 15 (whitelist)
2. CHECKLIST_AZIONE.md aggiornato con whitelist check

---

## Checklist Verifica

- [ ] Regola 15 aggiunta a cervella-orchestrator.md
- [ ] Whitelist chiara e memorizzabile
- [ ] Comando quick-task documentato
- [ ] CHECKLIST_AZIONE aggiornata
- [ ] Nessuna duplicazione con sezioni esistenti

---

*Task creato da Cervella Regina - Sessione 90*
