# RICERCA: Integrazione VS Code Terminal

**Task ID:** RICERCA_VSCODE_TERMINAL
**Completato da:** cervella-researcher
**Data:** 2026-01-04

---

## SOLUZIONI TROVATE

### 1. VS Code `sendSequence` (Built-in - NO extension)

**Come funziona:**
Il comando `workbench.action.terminal.sendSequence` invia sequenze di testo al terminale, inclusi escape sequences.

**Esempio keybindings.json:**
```json
{
  "key": "cmd+shift+c",
  "command": "workbench.action.terminal.sendSequence",
  "args": {
    "text": "claude\n"
  }
}
```

Il `\n` alla fine equivale a premere Enter!

**Pro:**
- Built-in, nessuna extension
- Supporta variabili (`${file}`, etc.)
- Supporta escape sequences (`\u001b` per ESC, `\n` per Enter)

**Contro:**
- Richiede che il terminale sia gia aperto e focused
- Non puo essere invocato da script esterni

---

### 2. VS Code Tasks (`tasks.json`) - SOLUZIONE RACCOMANDATA

**Come funziona:**
Crea un task che apre terminale ed esegue comando automaticamente.

**File `.vscode/tasks.json`:**
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Spawn Claude Worker",
      "type": "shell",
      "command": "claude --prompt 'Controlla task assegnati'",
      "presentation": {
        "reveal": "always",
        "panel": "new",
        "focus": true
      },
      "runOptions": {
        "runOn": "folderOpen"
      }
    }
  ]
}
```

**Pro:**
- Puo avviarsi automaticamente all'apertura folder (`runOn: folderOpen`)
- Ogni task = nuovo terminale (`panel: new`)
- Built-in, nessuna extension
- Puoi avere multipli task per multipli worker

**Contro:**
- Richiede permesso utente la prima volta ("Allow Automatic Tasks")
- E' legato alla cartella/progetto

**Come abilitare:**
1. Apri Command Palette (Cmd+Shift+P)
2. Digita "Tasks: Allow Automatic Tasks in Folder"
3. Seleziona "Allow"

---

### 3. Extension Terminal API (`terminal.sendText`)

**Come funziona:**
Una extension VS Code puo creare terminali e inviare comandi.

```javascript
const terminal = vscode.window.createTerminal('Claude Worker');
terminal.show();
terminal.sendText("claude --prompt 'Inizia lavoro'", true);
// true = aggiungi newline (Enter)
```

**Pro:**
- Controllo totale programmatico
- Puo essere triggerato da eventi
- Puo creare multipli terminali

**Contro:**
- Richiede creare una extension custom
- Non puo leggere output del terminale (solo inviare)

---

### 4. iTerm2 + AppleScript - ALTERNATIVA ESTERNA

**Come funziona:**
iTerm2 ha supporto AppleScript nativo con `write text`.

**Script:**
```applescript
#!/usr/bin/osascript
tell application "iTerm2"
  create window with default profile
  tell current session of current tab of current window
    write text "cd ~/Developer/CervellaSwarm && claude --prompt 'Worker attivo'"
  end tell
end tell
```

**Pro:**
- `write text` funziona PERFETTAMENTE (include Enter)
- Puo creare tab, split, finestre
- Nessun problema con keystroke

**Contro:**
- Non e' integrato in VS Code
- Finestra separata dall'editor

---

### 5. Multi-Command Keybinding (Built-in)

**Come funziona:**
Combina piu comandi in un unico keybinding.

```json
{
  "key": "cmd+shift+w",
  "command": "runCommands",
  "args": {
    "commands": [
      "workbench.action.terminal.new",
      {
        "command": "workbench.action.terminal.sendSequence",
        "args": { "text": "claude\n" }
      }
    ]
  }
}
```

**Pro:**
- Built-in (VS Code 1.77+)
- Un solo keybinding per tutto
- Nessuna extension

**Contro:**
- Manuale (richiede premere tasto)
- Timing potrebbe essere problema (terminale deve essere pronto)

---

## SOLUZIONE RACCOMANDATA

### Per CervellaSwarm: **Combinazione Tasks + iTerm2**

**Perche:**

1. **Per spawn automatico all'avvio:** Usa `tasks.json` con `runOn: folderOpen`
2. **Per spawn da script esterni:** Usa iTerm2 + AppleScript

**Implementazione Suggerita:**

#### A. Tasks per Auto-Spawn (in VS Code)

Crea `.vscode/tasks.json`:
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Spawn Regina",
      "type": "shell",
      "command": "claude --prompt 'Sei la Regina. Inizia sessione.'",
      "presentation": {
        "reveal": "always",
        "panel": "dedicated",
        "focus": true
      }
    },
    {
      "label": "Spawn Worker Frontend",
      "type": "shell",
      "command": "claude --agent cervella-frontend",
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    },
    {
      "label": "Spawn Worker Backend",
      "type": "shell",
      "command": "claude --agent cervella-backend",
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    }
  ]
}
```

#### B. Script per Spawn Esterno (iTerm2)

Modifica `spawn-workers.sh` per usare iTerm2:
```bash
#!/bin/bash
osascript << 'EOF'
tell application "iTerm2"
  create window with default profile
  tell current session of current tab of current window
    write text "cd ~/Developer/CervellaSwarm && claude --agent cervella-frontend"
  end tell

  -- Crea secondo tab per backend
  tell current window
    create tab with default profile
    tell current session of current tab
      write text "cd ~/Developer/CervellaSwarm && claude --agent cervella-backend"
    end tell
  end tell
end tell
EOF
```

---

## IMPLEMENTAZIONE

### Step 1: Scegli l'approccio

| Scenario | Soluzione |
|----------|-----------|
| Vuoi tutto dentro VS Code | Tasks.json |
| Vuoi spawn da script esterni | iTerm2 + AppleScript |
| Vuoi entrambi | Combina le due |

### Step 2: Se scegli Tasks.json

1. Crea `.vscode/tasks.json` nel progetto
2. Apri VS Code
3. Cmd+Shift+P -> "Tasks: Allow Automatic Tasks"
4. Riapri la cartella

### Step 3: Se scegli iTerm2

1. Installa iTerm2 (se non presente): `brew install --cask iterm2`
2. Crea script AppleScript
3. Esegui con `osascript script.scpt`

### Step 4: Keybinding Rapido (opzionale)

Aggiungi a `keybindings.json`:
```json
{
  "key": "cmd+shift+w",
  "command": "runCommands",
  "args": {
    "commands": [
      "workbench.action.terminal.new",
      {
        "command": "workbench.action.terminal.sendSequence",
        "args": { "text": "claude\n" }
      }
    ]
  }
}
```

---

## RISPOSTE ALLE DOMANDE SPECIFICHE

### 1. `code --command` puo eseguire comandi nel terminale?
**NO.** La CLI `code` non ha un flag per eseguire comandi nel terminale integrato. Puo solo aprire file/folder.

### 2. Esiste un modo per passare comandi al terminale via CLI?
**Indirettamente.** Puoi:
- Usare Tasks.json con `runOn: folderOpen`
- Creare extension che ascolta eventi

### 3. Ci sono estensioni VS Code che permettono questo?
**SI:**
- [Run in Terminal](https://marketplace.visualstudio.com/items?itemName=kortina.run-in-terminal)
- [Terminals](https://github.com/fabiospampinato/vscode-terminals) - supporta `autorun: true`
- [vscode-commands](https://github.com/usernamehw/vscode-commands) - `runInTerminal`

### 4. Come fanno altri tool (Cursor, Windsurf)?
**Cursor:**
- Usa Extension API internamente
- Agent mode esegue comandi con `terminal.sendText`
- CLI separata (`cursor-agent`) per uso headless
- Background agents clonano repo e lavorano in branch separati

---

## CONCLUSIONE

**La soluzione piu SEMPLICE e FUNZIONANTE per CervellaSwarm:**

1. **Per VS Code:** Tasks.json con `presentation.panel: new`
2. **Per script esterni:** iTerm2 con `write text`

Il problema originale (AppleScript non riesce a inviare Return a VS Code) e REALE e non risolvibile facilmente. VS Code gestisce input in modo diverso.

**La workaround migliore:** Non usare AppleScript per VS Code terminal. Usa le API native (Tasks o Extension) oppure passa a iTerm2 per spawn esterni.

---

*"Siamo nel 2026, non anni 80!"* - e abbiamo trovato la soluzione!

**Sources:**
- [VS Code Terminal Advanced](https://code.visualstudio.com/docs/terminal/advanced)
- [VS Code Tasks](https://code.visualstudio.com/docs/debugtest/tasks)
- [iTerm2 Scripting](https://iterm2.com/documentation-scripting.html)
- [Terminal API Example](https://github.com/Tyriar/vscode-terminal-api-example)
- [Cursor Agent CLI](https://cursor.com/blog/cli)
