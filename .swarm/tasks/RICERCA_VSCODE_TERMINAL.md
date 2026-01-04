# TASK: Ricerca Integrazione VS Code Terminal

**Task ID:** RICERCA_VSCODE_TERMINAL
**Assegnato a:** cervella-researcher
**Data:** 2026-01-04
**Priorità:** MEDIA

---

## CONTESTO

Vogliamo aprire automaticamente un nuovo terminale VS Code ed eseguire `claude` con un prompt.

**PROBLEMA:** AppleScript può aprire il terminale con `Ctrl+Shift+\`` ma NON riesce a inviare "Return" per eseguire il comando. VS Code intercetta i keystroke in modo diverso.

---

## MISSIONE

Trova una soluzione per:

1. **Aprire nuovo terminale in VS Code programmaticamente**
   - VS Code CLI (`code` command)
   - VS Code Tasks
   - Estensioni esistenti

2. **Eseguire comando nel terminale**
   - `sendSequence` API?
   - `workbench.action.terminal.sendSequence`?
   - Extension API?

3. **Alternative**
   - iTerm2 integration?
   - Hyper terminal?
   - VS Code extension custom (quanto è complesso?)

---

## DOMANDE SPECIFICHE

1. `code --command` può eseguire comandi nel terminale?
2. Esiste un modo per passare comandi al terminale via CLI?
3. Ci sono estensioni VS Code che permettono questo?
4. Come fanno altri tool (es. Cursor, Windsurf)?

---

## OUTPUT ATTESO

Scrivi report in: `.swarm/tasks/RICERCA_VSCODE_TERMINAL_output.md`

```
## SOLUZIONI TROVATE
[cosa hai trovato]

## SOLUZIONE RACCOMANDATA
[quale usare]

## IMPLEMENTAZIONE
[come fare]
```

---

*"Siamo nel 2026, non anni 80!"*
