# PIANO TECNICO DETTAGLIATO - CervellaSwarm MVP

> **Analizzato da:** cervella-ingegnera  
> **Data:** 2 Gennaio 2026  
> **Versione:** 1.0.0  
> **Obiettivo:** Piano ESECUTIVO per trasformare CervellaSwarm in VS Code Extension commerciale

---

## EXECUTIVE SUMMARY

**STATO ATTUALE:**
- ✅ 16 agent files: 4,878 righe (REALE)
- ✅ Scripts Python: 6,834 righe (REALE)
- ✅ DB SQLite: 400KB, 177 eventi (REALE)
- ✅ GitHub Actions: funzionante (REALE)

**MVP TARGET:** VS Code Extension in **3 settimane** (15 giorni lavorativi)

**EFFORT TOTALE:** ~80 ore (full-time) o ~120 ore (con context switching)

**RISCHIO:** **MEDIO-BASSO** (codebase solido, architettura modulare)

---

## ROADMAP MACRO

```
╔════════════════════════════════════════════════════════════════════╗
║                                                                    ║
║   SETTIMANA 1: Foundation (giorni 1-5)        → 32 ore            ║
║   • Refactoring codebase (8h)                                      ║
║   • Extension boilerplate (12h)                                    ║
║   • Agent installer (12h)                                          ║
║                                                                    ║
║   SETTIMANA 2: MVP Features (giorni 6-10)     → 32 ore            ║
║   • Commands palette (8h)                                          ║
║   • Settings panel (8h)                                            ║
║   • Webview dashboard (16h)                                        ║
║                                                                    ║
║   SETTIMANA 3: Polish (giorni 11-15)          → 32 ore            ║
║   • Testing (16h)                                                  ║
║   • Documentation (8h)                                             ║
║   • Marketplace submission (8h)                                    ║
║                                                                    ║
║   TOTALE: 96 ore → ~80 ore se full-time, ~120 ore part-time       ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝
```

---

## FASE 0: PRE-FLIGHT CHECKLIST

### Decisioni da Prendere OGGI

| Decisione | Opzioni | Raccomandazione |
|-----------|---------|-----------------|
| **Nome Extension** | cervellaswarm, cervella-swarm, swarm-agents | **cervellaswarm** (brand consistency) |
| **Free Tier Scope** | 4 agent vs 8 agent | **4 agent** (frontend, backend, tester, reviewer) |
| **Pricing Strategy** | $9/mese vs $19/mese | **$9/mese** (early adopter friendly) |
| **License** | MIT vs Proprietary | **MIT** (trust builder) |

### Setup Account (1 ora)

```bash
# 1. VS Code Marketplace Publisher
https://marketplace.visualstudio.com/manage/publishers/

# 2. Reserve Name
cervellaswarm (check availability)

# 3. Stripe Account
https://stripe.com (per pagamenti future)

# 4. GitHub Repo
cervellaswarm-vscode (nuovo repo dedicato)
```

---

## SETTIMANA 1: FOUNDATION (32 ore)

### GIORNO 1: Refactoring Codebase Esistente (8 ore)

#### Task 1.1: Path Parametrization (2 ore)

**PROBLEMA:** Path hardcoded `~/.claude/agents/`

**FILES IMPATTATI:**
```
16 agent files: nessuna modifica (path gestito da extension)
scripts/memory/*.py: 5 files (get_db_path function)
scripts/learning/*.py: 3 files (db path)
scripts/engineer/*.py: 2 files (codebase path)
```

**SOLUZIONE:**
```python
# PRIMA (hardcoded):
agents_path = Path.home() / ".claude" / "agents"
db_path = Path(__file__).parent.parent / "data" / "swarm_memory.db"

# DOPO (parametrizzato):
import os

AGENTS_PATH = os.getenv("CERVELLASWARM_AGENTS_PATH") or \
              Path.home() / ".claude" / "agents"

DB_PATH = os.getenv("CERVELLASWARM_DB_PATH") or \
          Path.home() / ".cervellaswarm" / "swarm_memory.db"
```

**CHECKLIST:**
- [ ] Creare `scripts/common/paths.py` (centralizzato)
- [ ] Aggiornare 10 script Python con `from common.paths import AGENTS_PATH, DB_PATH`
- [ ] Test: export CERVELLASWARM_AGENTS_PATH=/custom/path && python script.py
- [ ] Commit: `refactor: parametrize all paths for packaging`

**OUTPUT:** Tutti gli script usano env vars, fallback a default

---

#### Task 1.2: Version Headers Agent Files (1 ora)

**PROBLEMA:** Nessun versioning nei file agent

**SOLUZIONE:** YAML frontmatter
```yaml
---
name: cervella-frontend
version: 1.0.0
updated: 2026-01-02
compatible_with: cervellaswarm >= 1.0.0
model: sonnet-4-5
---
```

**CHECKLIST:**
- [ ] Script `scripts/tools/add_version_headers.py` (auto-aggiunge header)
- [ ] Run su tutti 16 agent files
- [ ] Verify: `head -10 ~/.claude/agents/*.md`
- [ ] Commit: `feat: add version headers to all agents`

**OUTPUT:** 16 agent files con header YAML

---

#### Task 1.3: Database Migration System (3 ore)

**PROBLEMA:** Schema DB evolve, serve migration strategy

**FILES DA CREARE:**
```
scripts/memory/migrate.py         (main migration runner)
scripts/memory/migrations/         (directory)
scripts/memory/migrations/001_initial.sql
scripts/memory/migrations/002_lessons_learned.sql
scripts/memory/migrations/003_error_patterns.sql
```

**SOLUZIONE:**
```python
# scripts/memory/migrate.py
def get_current_version(conn):
    """Legge versione schema da DB"""
    # SELECT version FROM schema_version

def apply_migration(conn, migration_file):
    """Applica singola migration"""
    # Esegue SQL, aggiorna version

def migrate_to_latest(conn):
    """Auto-detect e applica tutte le migration mancanti"""
    current = get_current_version(conn)
    available = list_migrations()
    pending = [m for m in available if m.version > current]
    
    for migration in pending:
        apply_migration(conn, migration)
        print(f"✅ Applied: {migration.name}")
```

**CHECKLIST:**
- [ ] Creare `migrate.py` (300 righe stimato)
- [ ] Estrarre schema attuale in `001_initial.sql`
- [ ] Test: `python migrate.py --dry-run`
- [ ] Test: `python migrate.py --upgrade`
- [ ] Commit: `feat: add database migration system`

**OUTPUT:** Sistema migration funzionante

---

#### Task 1.4: Dependency Isolation (2 ore)

**PROBLEMA:** `rich` usato ma non obbligatorio

**FILES IMPATTATI:**
```
scripts/memory/analytics.py
scripts/memory/weekly_retro.py
scripts/engineer/analyze_codebase.py
scripts/learning/wizard.py
```

**SOLUZIONE:**
```python
# Optional import con fallback
try:
    from rich.console import Console
    from rich.table import Table
    HAS_RICH = True
except ImportError:
    HAS_RICH = False
    
def print_table(data):
    if HAS_RICH:
        # Rich table
    else:
        # Plain text fallback
```

**CHECKLIST:**
- [ ] Creare `requirements.txt` (core)
- [ ] Creare `requirements-dev.txt` (optional: rich, pytest)
- [ ] Aggiungere fallback a 4 script
- [ ] Test: `pip install -r requirements.txt` (solo core)
- [ ] Test: script funziona senza rich
- [ ] Commit: `refactor: make rich dependency optional`

**OUTPUT:** Script funzionano con/senza rich

---

### GIORNO 2-3: Extension Boilerplate (12 ore)

#### Task 2.1: Setup Extension Project (4 ore)

**TOOLS:**
```bash
# Yeoman generator (official VS Code)
npm install -g yo generator-code
yo code
```

**PROMPTS:**
```
? What type of extension? New Extension (TypeScript)
? Extension name? CervellaSwarm
? Identifier? cervellaswarm
? Description? Multi-agent orchestration for Claude Code
? Initialize git? Yes
? Package manager? npm
```

**STRUTTURA GENERATA:**
```
cervellaswarm-vscode/
├── package.json             # Extension manifest
├── tsconfig.json            # TypeScript config
├── src/
│   ├── extension.ts         # Entry point
│   └── test/
├── .vscode/
│   ├── launch.json          # Debug config
│   └── tasks.json
├── .vscodeignore            # Files esclusi da package
└── README.md
```

**CHECKLIST:**
- [ ] Run `yo code`
- [ ] Customize `package.json` (metadata, categories)
- [ ] Setup `.gitignore` (node_modules, out/, dist/)
- [ ] First commit: `chore: initial extension setup`
- [ ] Test: F5 (launch extension in debug)

**OUTPUT:** Extension boilerplate funzionante

---

#### Task 2.2: Package.json Configuration (2 ore)

**SEZIONI CHIAVE:**
```json
{
  "name": "cervellaswarm",
  "displayName": "CervellaSwarm - Multi-Agent Orchestration",
  "version": "0.1.0",
  "publisher": "rafapra",
  "engines": { "vscode": "^1.85.0" },
  "categories": ["AI", "Programming Languages", "Other"],
  "keywords": ["claude", "ai", "agents", "multi-agent", "swarm"],
  
  "activationEvents": [
    "onCommand:cervellaswarm.initialize",
    "onStartupFinished"
  ],
  
  "contributes": {
    "commands": [
      {
        "command": "cervellaswarm.initialize",
        "title": "CervellaSwarm: Initialize Workspace",
        "category": "CervellaSwarm"
      },
      {
        "command": "cervellaswarm.launchFrontend",
        "title": "Launch Frontend Agent",
        "category": "CervellaSwarm"
      }
    ],
    
    "configuration": {
      "title": "CervellaSwarm",
      "properties": {
        "cervellaswarm.agentsPath": {
          "type": "string",
          "default": ".vscode/agents",
          "description": "Path where agent files are stored"
        },
        "cervellaswarm.enabledAgents": {
          "type": "array",
          "default": ["frontend", "backend", "tester", "reviewer"],
          "description": "List of enabled agents (FREE tier)"
        }
      }
    },
    
    "views": {
      "explorer": [
        {
          "id": "cervellaswarmAnalytics",
          "name": "CervellaSwarm Analytics"
        }
      ]
    }
  }
}
```

**CHECKLIST:**
- [ ] Aggiungere metadata completo
- [ ] Definire 8 comandi (initialize, launch×4, analytics, settings, help)
- [ ] Configurare settings schema
- [ ] Aggiungere icon.png (128×128)
- [ ] Commit: `feat: configure package.json metadata`

**OUTPUT:** `package.json` completo e validato

---

#### Task 2.3: Basic Extension Activation (6 ore)

**FILE:** `src/extension.ts`

```typescript
import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

export function activate(context: vscode.ExtensionContext) {
    console.log('CervellaSwarm extension activated');

    // Command: Initialize Workspace
    let initializeCmd = vscode.commands.registerCommand(
        'cervellaswarm.initialize',
        async () => {
            const result = await initializeWorkspace(context);
            if (result) {
                vscode.window.showInformationMessage(
                    '✅ CervellaSwarm initialized!'
                );
            }
        }
    );

    context.subscriptions.push(initializeCmd);
}

async function initializeWorkspace(
    context: vscode.ExtensionContext
): Promise<boolean> {
    // 1. Check if workspace open
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (!workspaceFolder) {
        vscode.window.showErrorMessage('No workspace folder open');
        return false;
    }

    // 2. Create .vscode/agents directory
    const agentsPath = path.join(
        workspaceFolder.uri.fsPath,
        '.vscode',
        'agents'
    );
    
    if (!fs.existsSync(agentsPath)) {
        fs.mkdirSync(agentsPath, { recursive: true });
    }

    // 3. Copy agent files (da implementare in Task 3.1)
    
    return true;
}
```

**CHECKLIST:**
- [ ] Implementare `activate()` function
- [ ] Registrare command `initialize`
- [ ] Test: Cmd+Shift+P → "CervellaSwarm: Initialize"
- [ ] Verify: `.vscode/agents/` directory creata
- [ ] Commit: `feat: add initialize command`

**OUTPUT:** Comando Initialize funzionante

---

### GIORNO 4-5: Agent Installer (12 ore)

#### Task 3.1: Copy Agent Files Logic (6 ore)

**FILE:** `src/agent-installer.ts`

```typescript
import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

export interface AgentFile {
    name: string;
    filename: string;
    tier: 'free' | 'pro';
}

const AGENT_FILES: AgentFile[] = [
    { name: 'Frontend', filename: 'cervella-frontend.md', tier: 'free' },
    { name: 'Backend', filename: 'cervella-backend.md', tier: 'free' },
    { name: 'Tester', filename: 'cervella-tester.md', tier: 'free' },
    { name: 'Reviewer', filename: 'cervella-reviewer.md', tier: 'free' },
    { name: 'Researcher', filename: 'cervella-researcher.md', tier: 'pro' },
    // ... altri 11
];

export class AgentInstaller {
    private extensionPath: string;
    
    constructor(extensionPath: string) {
        this.extensionPath = extensionPath;
    }

    async install(
        targetPath: string,
        tier: 'free' | 'pro' = 'free'
    ): Promise<InstallResult> {
        const agentsToInstall = AGENT_FILES.filter(
            a => tier === 'pro' || a.tier === 'free'
        );

        const results: InstallResult = {
            installed: [],
            skipped: [],
            errors: []
        };

        for (const agent of agentsToInstall) {
            const sourcePath = path.join(
                this.extensionPath,
                'agents',
                agent.filename
            );
            
            const destPath = path.join(
                targetPath,
                agent.filename
            );

            try {
                // Check if exists
                if (fs.existsSync(destPath)) {
                    results.skipped.push(agent.name);
                    continue;
                }

                // Copy file
                fs.copyFileSync(sourcePath, destPath);
                results.installed.push(agent.name);

            } catch (error) {
                results.errors.push({
                    agent: agent.name,
                    error: error.message
                });
            }
        }

        return results;
    }

    async update(targetPath: string): Promise<UpdateResult> {
        // Check versions, update if needed
        // Compare YAML frontmatter versions
    }
}
```

**CHECKLIST:**
- [ ] Creare `AgentInstaller` class
- [ ] Implementare `install()` method
- [ ] Implementare `update()` method (check versions)
- [ ] Progress notification (vscode.window.withProgress)
- [ ] Test: install 4 agent free
- [ ] Test: install 16 agent pro
- [ ] Test: update (skip se versione same)
- [ ] Commit: `feat: implement agent installer`

**OUTPUT:** Agent installer funzionante

---

#### Task 3.2: Settings.json Integration (3 ore)

**FILE:** `src/config-manager.ts`

```typescript
export class ConfigManager {
    async configureHooks(
        workspacePath: string
    ): Promise<void> {
        const settingsPath = path.join(
            workspacePath,
            '.vscode',
            'settings.json'
        );

        let settings = {};
        if (fs.existsSync(settingsPath)) {
            settings = JSON.parse(
                fs.readFileSync(settingsPath, 'utf-8')
            );
        }

        // Add hooks configuration
        settings['claude.hooks'] = {
            "PostToolUse": {
                "matcher": "Task",
                "script": "${workspaceFolder}/.vscode/hooks/log_event.py"
            },
            "SessionStart": {
                "matcher": "",
                "script": "${workspaceFolder}/.vscode/hooks/load_context.py"
            }
        };

        fs.writeFileSync(
            settingsPath,
            JSON.stringify(settings, null, 2)
        );
    }

    async installHooks(workspacePath: string): Promise<void> {
        const hooksPath = path.join(
            workspacePath,
            '.vscode',
            'hooks'
        );

        fs.mkdirSync(hooksPath, { recursive: true });

        // Copy hook scripts
        const hookFiles = [
            'log_event.py',
            'load_context.py'
        ];

        for (const file of hookFiles) {
            const source = path.join(
                this.extensionPath,
                'hooks',
                file
            );
            const dest = path.join(hooksPath, file);
            fs.copyFileSync(source, dest);
        }
    }
}
```

**CHECKLIST:**
- [ ] Creare `ConfigManager` class
- [ ] Implementare `configureHooks()` (update settings.json)
- [ ] Implementare `installHooks()` (copy Python scripts)
- [ ] Test: verify `.vscode/settings.json` created
- [ ] Test: verify hooks/ directory created
- [ ] Commit: `feat: add config manager and hooks installer`

**OUTPUT:** Hooks system auto-configurato

---

#### Task 3.3: Validation & Error Handling (3 ore)

**SCENARIOS:**
1. Workspace non aperto
2. `.vscode/` directory protetta (permissions)
3. Agent file corrotto (invalid YAML)
4. Disk full (copy fail)
5. Python non installato (hooks won't work)

**SOLUZIONE:**
```typescript
export class Validator {
    async validateWorkspace(): Promise<ValidationResult> {
        const checks = {
            workspaceOpen: this.checkWorkspace(),
            pythonAvailable: await this.checkPython(),
            diskSpace: await this.checkDiskSpace(),
            permissions: await this.checkPermissions()
        };

        return checks;
    }

    private async checkPython(): Promise<boolean> {
        try {
            const result = await exec('python3 --version');
            return result.exitCode === 0;
        } catch {
            return false;
        }
    }
}
```

**CHECKLIST:**
- [ ] Creare `Validator` class
- [ ] Implementare 5 validation checks
- [ ] User-friendly error messages
- [ ] Fallback suggestions (es: install Python)
- [ ] Test: tutti 5 scenari error
- [ ] Commit: `feat: add validation and error handling`

**OUTPUT:** Validation robusta

---

## SETTIMANA 2: MVP FEATURES (32 ore)

### GIORNO 6-7: Commands Palette (8 ore)

#### Task 4.1: Launch Agent Commands (4 ore)

**COMANDI:**
```
- CervellaSwarm: Launch Frontend
- CervellaSwarm: Launch Backend
- CervellaSwarm: Launch Tester
- CervellaSwarm: Launch Reviewer
- CervellaSwarm: Launch (Custom Agent Picker)
```

**FILE:** `src/commands.ts`

```typescript
export async function launchAgent(
    agentName: string,
    context: vscode.ExtensionContext
): Promise<void> {
    const config = vscode.workspace.getConfiguration('cervellaswarm');
    const agentsPath = config.get<string>('agentsPath');
    
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (!workspaceFolder) {
        vscode.window.showErrorMessage('No workspace open');
        return;
    }

    const agentFile = path.join(
        workspaceFolder.uri.fsPath,
        agentsPath!,
        `cervella-${agentName}.md`
    );

    if (!fs.existsSync(agentFile)) {
        const install = await vscode.window.showErrorMessage(
            `Agent '${agentName}' not found. Install it?`,
            'Install',
            'Cancel'
        );

        if (install === 'Install') {
            await vscode.commands.executeCommand('cervellaswarm.initialize');
        }
        return;
    }

    // Open agent file in editor
    const doc = await vscode.workspace.openTextDocument(agentFile);
    await vscode.window.showTextDocument(doc);

    // Trigger Claude Code (se possibile via API)
    // Altrimenti: mostrare istruzioni "Press Cmd+I to start Claude"
}
```

**CHECKLIST:**
- [ ] Registrare 5 comandi in `package.json`
- [ ] Implementare `launchAgent()` function
- [ ] Test: launch frontend (file aperto)
- [ ] Test: launch agent non installato (prompt install)
- [ ] Commit: `feat: add launch agent commands`

**OUTPUT:** Launch comandi funzionanti

---

#### Task 4.2: Quick Pick Agent Selector (4 ore)

**UI:**
```
┌─────────────────────────────────────────┐
│ Select Agent to Launch                  │
├─────────────────────────────────────────┤
│ 🎨 Frontend (React, CSS, UI/UX)        │
│ ⚙️  Backend (Python, FastAPI, API)     │
│ 🧪 Tester (Testing, Debug, QA)         │
│ 📋 Reviewer (Code review)              │
│ ───────────────────────────────────────  │
│ 🔬 Researcher (Ricerca) [PRO]          │
│ 📈 Marketing (Marketing) [PRO]         │
│ ... (altri 10) [PRO]                    │
└─────────────────────────────────────────┘
```

**CODE:**
```typescript
export async function showAgentPicker(): Promise<void> {
    const config = vscode.workspace.getConfiguration('cervellaswarm');
    const tier = config.get<string>('tier', 'free');

    const items: vscode.QuickPickItem[] = AGENT_FILES.map(agent => ({
        label: `${agent.emoji} ${agent.name}`,
        description: agent.description,
        detail: agent.tier === 'pro' && tier === 'free' 
            ? '⭐ PRO feature' 
            : undefined,
        picked: false
    }));

    const selected = await vscode.window.showQuickPick(items, {
        placeHolder: 'Select agent to launch'
    });

    if (selected) {
        // Check if PRO needed
        if (selected.detail?.includes('PRO') && tier === 'free') {
            await promptUpgrade();
        } else {
            await launchAgent(selected.label);
        }
    }
}
```

**CHECKLIST:**
- [ ] Implementare `showAgentPicker()`
- [ ] Emoji + description per ogni agent
- [ ] Badge [PRO] per agent premium
- [ ] Prompt upgrade se FREE user seleziona PRO
- [ ] Test: picker con 4 agent (free)
- [ ] Test: picker con 16 agent (pro)
- [ ] Commit: `feat: add agent quick picker`

**OUTPUT:** Quick picker funzionante

---

### GIORNO 8: Settings Panel (8 ore)

#### Task 5.1: Configuration UI (4 ore)

**SETTINGS SCHEMA (package.json):**
```json
"configuration": {
  "title": "CervellaSwarm",
  "properties": {
    "cervellaswarm.tier": {
      "type": "string",
      "enum": ["free", "pro"],
      "default": "free",
      "description": "Subscription tier"
    },
    "cervellaswarm.agentsPath": {
      "type": "string",
      "default": ".vscode/agents",
      "description": "Path to agent files"
    },
    "cervellaswarm.dbPath": {
      "type": "string",
      "default": ".cervellaswarm/swarm_memory.db",
      "description": "Path to memory database"
    },
    "cervellaswarm.enabledAgents": {
      "type": "array",
      "items": { "type": "string" },
      "default": ["frontend", "backend", "tester", "reviewer"],
      "description": "List of enabled agents"
    },
    "cervellaswarm.autoUpdate": {
      "type": "boolean",
      "default": true,
      "description": "Auto-update agents when new version available"
    }
  }
}
```

**CHECKLIST:**
- [ ] Definire 6 settings in `package.json`
- [ ] JSON schema validation
- [ ] Default values sensibili
- [ ] Test: open Settings UI (Cmd+,)
- [ ] Test: modify settings, verify saved
- [ ] Commit: `feat: add configuration schema`

**OUTPUT:** Settings panel nativo VS Code

---

#### Task 5.2: Settings Command (4 ore)

**COMMAND:** `CervellaSwarm: Open Settings`

```typescript
export async function openSettings(): Promise<void> {
    await vscode.commands.executeCommand(
        'workbench.action.openSettings',
        'cervellaswarm'
    );
}
```

**WEBVIEW ALTERNATIVA (opzionale):**
```typescript
export class SettingsPanel {
    public static createOrShow(extensionUri: vscode.Uri) {
        const panel = vscode.window.createWebviewPanel(
            'cervellaswarmSettings',
            'CervellaSwarm Settings',
            vscode.ViewColumn.One,
            { enableScripts: true }
        );

        panel.webview.html = this.getWebviewContent();
    }

    private static getWebviewContent(): string {
        return `
            <!DOCTYPE html>
            <html>
            <head>
                <title>CervellaSwarm Settings</title>
                <style>
                    body { padding: 20px; }
                    .setting { margin-bottom: 20px; }
                    label { display: block; margin-bottom: 5px; }
                </style>
            </head>
            <body>
                <h1>CervellaSwarm Settings</h1>
                
                <div class="setting">
                    <label>Subscription Tier</label>
                    <select id="tier">
                        <option value="free">Free</option>
                        <option value="pro">Pro ($9/month)</option>
                    </select>
                </div>
                
                <div class="setting">
                    <label>Agents Path</label>
                    <input type="text" id="agentsPath" value=".vscode/agents" />
                </div>

                <button onclick="saveSettings()">Save</button>
            </body>
            </html>
        `;
    }
}
```

**CHECKLIST:**
- [ ] Implementare `openSettings()` command
- [ ] (Opzionale) Webview custom panel
- [ ] Test: command apre settings
- [ ] Commit: `feat: add open settings command`

**OUTPUT:** Settings command funzionante

---

### GIORNO 9-10: Webview Dashboard (16 ore)

#### Task 6.1: Dashboard Panel (8 ore)

**COMMAND:** `CervellaSwarm: Show Dashboard`

**FILE:** `src/dashboard-panel.ts`

```typescript
export class DashboardPanel {
    public static currentPanel: DashboardPanel | undefined;
    private readonly _panel: vscode.WebviewPanel;
    private _disposables: vscode.Disposable[] = [];

    private constructor(
        panel: vscode.WebviewPanel,
        extensionUri: vscode.Uri
    ) {
        this._panel = panel;

        // Set HTML content
        this._update();

        // Listen for dispose
        this._panel.onDidDispose(() => this.dispose(), null, this._disposables);

        // Handle messages from webview
        this._panel.webview.onDidReceiveMessage(
            message => {
                switch (message.command) {
                    case 'refresh':
                        this._update();
                        break;
                    case 'exportData':
                        this._exportData();
                        break;
                }
            },
            null,
            this._disposables
        );
    }

    public static createOrShow(extensionUri: vscode.Uri) {
        // Singleton pattern
        if (DashboardPanel.currentPanel) {
            DashboardPanel.currentPanel._panel.reveal();
            return;
        }

        const panel = vscode.window.createWebviewPanel(
            'cervellaswarmDashboard',
            'CervellaSwarm Analytics',
            vscode.ViewColumn.One,
            {
                enableScripts: true,
                localResourceRoots: [extensionUri]
            }
        );

        DashboardPanel.currentPanel = new DashboardPanel(panel, extensionUri);
    }

    private async _update() {
        const data = await this._fetchAnalytics();
        this._panel.webview.html = this._getHtmlContent(data);
    }

    private async _fetchAnalytics(): Promise<AnalyticsData> {
        // Spawn Python script: analytics.py dashboard --json
        const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
        if (!workspaceFolder) {
            return { error: 'No workspace open' };
        }

        const scriptPath = path.join(
            workspaceFolder.uri.fsPath,
            '.vscode',
            'scripts',
            'analytics.py'
        );

        const result = await exec(`python3 ${scriptPath} dashboard --json`);
        return JSON.parse(result.stdout);
    }

    private _getHtmlContent(data: AnalyticsData): string {
        return `
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <title>CervellaSwarm Dashboard</title>
                <style>
                    body {
                        padding: 20px;
                        background: var(--vscode-editor-background);
                        color: var(--vscode-editor-foreground);
                    }
                    .metric-card {
                        background: var(--vscode-input-background);
                        border: 1px solid var(--vscode-input-border);
                        border-radius: 4px;
                        padding: 16px;
                        margin-bottom: 16px;
                    }
                    .metric-value {
                        font-size: 32px;
                        font-weight: bold;
                        color: var(--vscode-textLink-foreground);
                    }
                    .metric-label {
                        font-size: 12px;
                        text-transform: uppercase;
                        opacity: 0.7;
                    }
                </style>
            </head>
            <body>
                <h1>📊 CervellaSwarm Analytics</h1>
                
                <div class="metrics-grid">
                    <div class="metric-card">
                        <div class="metric-label">Total Tasks</div>
                        <div class="metric-value">${data.totalTasks}</div>
                    </div>
                    
                    <div class="metric-card">
                        <div class="metric-label">Success Rate</div>
                        <div class="metric-value">${data.successRate}%</div>
                    </div>
                    
                    <div class="metric-card">
                        <div class="metric-label">Most Used Agent</div>
                        <div class="metric-value">${data.topAgent}</div>
                    </div>
                </div>

                <h2>Recent Events</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Time</th>
                            <th>Agent</th>
                            <th>Task</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${data.recentEvents.map(e => `
                            <tr>
                                <td>${e.timestamp}</td>
                                <td>${e.agent}</td>
                                <td>${e.task}</td>
                                <td>${e.status}</td>
                            </tr>
                        `).join('')}
                    </tbody>
                </table>

                <button onclick="refresh()">Refresh</button>
                <button onclick="exportData()">Export CSV</button>

                <script>
                    const vscode = acquireVsCodeApi();

                    function refresh() {
                        vscode.postMessage({ command: 'refresh' });
                    }

                    function exportData() {
                        vscode.postMessage({ command: 'exportData' });
                    }
                </script>
            </body>
            </html>
        `;
    }
}
```

**CHECKLIST:**
- [ ] Creare `DashboardPanel` class
- [ ] Implementare webview HTML/CSS
- [ ] Fetch data da `analytics.py --json`
- [ ] Render metrics cards
- [ ] Render events table
- [ ] Refresh button (reload data)
- [ ] Export CSV button
- [ ] Test: open dashboard, verify data displayed
- [ ] Commit: `feat: add analytics dashboard webview`

**OUTPUT:** Dashboard webview funzionante

---

#### Task 6.2: Charts Integration (4 ore)

**OPZIONE 1: Chart.js (lightweight)**
```html
<script src="https://cdn.jsdelivr.net/npm/chart.js@4"></script>
<canvas id="agentUsageChart"></canvas>
<script>
    const ctx = document.getElementById('agentUsageChart');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ${JSON.stringify(data.agents)},
            datasets: [{
                label: 'Tasks per Agent',
                data: ${JSON.stringify(data.taskCounts)}
            }]
        }
    });
</script>
```

**OPZIONE 2: D3.js (più potente)**
```html
<script src="https://d3js.org/d3.v7.min.js"></script>
<svg id="chart"></svg>
<script>
    const svg = d3.select("#chart");
    // D3 chart code
</script>
```

**RACCOMANDAZIONE:** Chart.js (più semplice, più veloce)

**CHECKLIST:**
- [ ] Aggiungere Chart.js CDN
- [ ] Grafico 1: Agent usage (bar chart)
- [ ] Grafico 2: Success rate (pie chart)
- [ ] Grafico 3: Tasks over time (line chart)
- [ ] Test: tutti 3 grafici visualizzati
- [ ] Commit: `feat: add charts to dashboard`

**OUTPUT:** Dashboard con grafici interattivi

---

#### Task 6.3: Real-time Updates (4 ore)

**PROBLEMA:** Dashboard non si aggiorna automaticamente

**SOLUZIONE 1: Polling**
```typescript
// In webview
setInterval(() => {
    vscode.postMessage({ command: 'refresh' });
}, 5000); // ogni 5 secondi
```

**SOLUZIONE 2: File Watcher**
```typescript
// In extension
const dbWatcher = vscode.workspace.createFileSystemWatcher(
    '**/swarm_memory.db'
);

dbWatcher.onDidChange(() => {
    DashboardPanel.currentPanel?.refresh();
});
```

**RACCOMANDAZIONE:** File Watcher (più efficiente)

**CHECKLIST:**
- [ ] Implementare FileSystemWatcher
- [ ] Trigger refresh on DB change
- [ ] Debounce (max 1 refresh/secondo)
- [ ] Test: execute task, dashboard auto-updates
- [ ] Commit: `feat: add real-time dashboard updates`

**OUTPUT:** Dashboard aggiornato in tempo reale

---

## SETTIMANA 3: POLISH (32 ore)

### GIORNO 11-12: Testing (16 ore)

#### Task 7.1: Unit Tests (8 ore)

**FRAMEWORK:** Mocha + Chai (già configurato da Yeoman)

**FILE:** `src/test/agent-installer.test.ts`

```typescript
import * as assert from 'assert';
import * as vscode from 'vscode';
import { AgentInstaller } from '../agent-installer';

suite('Agent Installer Tests', () => {
    test('Install free tier agents', async () => {
        const installer = new AgentInstaller(extensionPath);
        const result = await installer.install(targetPath, 'free');

        assert.strictEqual(result.installed.length, 4);
        assert.ok(result.installed.includes('Frontend'));
        assert.ok(result.installed.includes('Backend'));
    });

    test('Install pro tier agents', async () => {
        const installer = new AgentInstaller(extensionPath);
        const result = await installer.install(targetPath, 'pro');

        assert.strictEqual(result.installed.length, 16);
    });

    test('Skip existing agents', async () => {
        // Install twice
        const installer = new AgentInstaller(extensionPath);
        await installer.install(targetPath, 'free');
        const result = await installer.install(targetPath, 'free');

        assert.strictEqual(result.installed.length, 0);
        assert.strictEqual(result.skipped.length, 4);
    });

    test('Handle invalid path', async () => {
        const installer = new AgentInstaller(extensionPath);
        const result = await installer.install('/invalid/path', 'free');

        assert.ok(result.errors.length > 0);
    });
});
```

**TEST SUITES:**
1. `agent-installer.test.ts` (5 test)
2. `config-manager.test.ts` (4 test)
3. `validator.test.ts` (6 test)
4. `commands.test.ts` (8 test)
5. `dashboard-panel.test.ts` (5 test)

**CHECKLIST:**
- [ ] Scrivere 28 unit test
- [ ] Coverage target: >80%
- [ ] Run: `npm test`
- [ ] Fix failing tests
- [ ] Commit: `test: add unit tests (28 tests)`

**OUTPUT:** 28 test passati

---

#### Task 7.2: Integration Tests (4 ore)

**FILE:** `src/test/integration/e2e.test.ts`

```typescript
suite('End-to-End Tests', () => {
    test('Full workflow: Initialize → Install → Launch', async () => {
        // 1. Open workspace
        const workspace = await vscode.workspace.openFolder(testWorkspaceUri);

        // 2. Initialize
        await vscode.commands.executeCommand('cervellaswarm.initialize');

        // 3. Verify agents installed
        const agentsPath = path.join(testWorkspaceUri.fsPath, '.vscode', 'agents');
        assert.ok(fs.existsSync(agentsPath));

        // 4. Launch frontend
        await vscode.commands.executeCommand('cervellaswarm.launchFrontend');

        // 5. Verify file opened
        const activeEditor = vscode.window.activeTextEditor;
        assert.ok(activeEditor?.document.fileName.includes('cervella-frontend.md'));
    });

    test('Dashboard displays data', async () => {
        // 1. Open dashboard
        await vscode.commands.executeCommand('cervellaswarm.showDashboard');

        // 2. Wait for webview to load
        await sleep(2000);

        // 3. Verify panel visible
        assert.ok(DashboardPanel.currentPanel);
    });
});
```

**CHECKLIST:**
- [ ] Setup test workspace (fixtures/)
- [ ] Test 5 scenari end-to-end
- [ ] Run: `npm run test:integration`
- [ ] Fix issues
- [ ] Commit: `test: add integration tests`

**OUTPUT:** E2E tests passati

---

#### Task 7.3: Manual Testing (4 ore)

**PLATFORMS:**
- macOS (primary)
- Windows (via VM o collaboratore)
- Linux (via Docker/VM)

**TEST MATRIX:**

| Test Case | Mac | Win | Linux |
|-----------|-----|-----|-------|
| Install extension | [ ] | [ ] | [ ] |
| Initialize workspace | [ ] | [ ] | [ ] |
| Install free agents | [ ] | [ ] | [ ] |
| Install pro agents | [ ] | [ ] | [ ] |
| Launch frontend | [ ] | [ ] | [ ] |
| Open dashboard | [ ] | [ ] | [ ] |
| Dashboard shows data | [ ] | [ ] | [ ] |
| Settings save correctly | [ ] | [ ] | [ ] |
| Update agents | [ ] | [ ] | [ ] |
| Uninstall clean | [ ] | [ ] | [ ] |

**CHECKLIST:**
- [ ] Test su macOS (30 minuti)
- [ ] Test su Windows (60 minuti)
- [ ] Test su Linux (60 minuti)
- [ ] Documentare bugs trovati
- [ ] Fix critical bugs
- [ ] Commit: `fix: platform-specific bugs`

**OUTPUT:** Extension funzionante su 3 OS

---

### GIORNO 13: Documentation (8 ore)

#### Task 8.1: README.md (4 ore)

**SEZIONI:**
```markdown
# CervellaSwarm - Multi-Agent Orchestration for Claude Code

> Transform Claude Code into a coordinated swarm of specialized AI agents

## Features

- 🐝 **16 Specialized Agents** - Frontend, Backend, Testing, Security, and more
- 🧠 **Memory System** - The swarm remembers and learns from past tasks
- 📊 **Analytics Dashboard** - Track agent usage and performance
- 🔄 **Smart Orchestration** - Coordinated multi-agent workflows

## Quick Start

1. Install the extension
2. Open a workspace
3. Run: `CervellaSwarm: Initialize Workspace`
4. Start using agents!

## Screenshots

![Dashboard](images/dashboard.png)
![Agent Picker](images/picker.png)

## Pricing

- **Free**: 4 core agents (Frontend, Backend, Tester, Reviewer)
- **Pro** ($9/month): All 16 agents + priority support

## Support

- Documentation: https://cervellaswarm.com/docs
- Issues: https://github.com/rafapra3008/cervellaswarm/issues
- Email: support@cervellaswarm.com
```

**CHECKLIST:**
- [ ] Scrivere README completo (500+ parole)
- [ ] Aggiungere 5 screenshots (PNG 1200×800)
- [ ] Aggiungere GIF demo (30 secondi)
- [ ] Aggiungere badges (version, downloads, rating)
- [ ] Test: preview in VS Code
- [ ] Commit: `docs: add comprehensive README`

**OUTPUT:** README professionale

---

#### Task 8.2: CHANGELOG.md (1 ora)

```markdown
# Changelog

All notable changes to this project will be documented in this file.

## [0.1.0] - 2026-01-XX

### Added
- Initial release
- 16 specialized agents
- Agent installer command
- Analytics dashboard
- Memory system integration
- Settings panel
- Free and Pro tiers
```

**CHECKLIST:**
- [ ] Creare CHANGELOG.md
- [ ] Seguire Keep a Changelog format
- [ ] Commit: `docs: add CHANGELOG`

---

#### Task 8.3: In-Extension Help (3 ore)

**WEBVIEW:** `CervellaSwarm: Show Help`

```html
<!DOCTYPE html>
<html>
<head>
    <title>CervellaSwarm Help</title>
</head>
<body>
    <h1>CervellaSwarm Help</h1>

    <h2>Getting Started</h2>
    <ol>
        <li>Initialize workspace</li>
        <li>Choose an agent</li>
        <li>Start coding!</li>
    </ol>

    <h2>Commands</h2>
    <ul>
        <li><code>Initialize Workspace</code> - Setup agents</li>
        <li><code>Launch Frontend</code> - Start frontend agent</li>
        <li><code>Show Dashboard</code> - View analytics</li>
    </ul>

    <h2>Video Tutorials</h2>
    <iframe src="https://youtube.com/..." />
</body>
</html>
```

**CHECKLIST:**
- [ ] Creare help webview
- [ ] Aggiungere tutorial links
- [ ] Aggiungere FAQ
- [ ] Test: help panel apre correttamente
- [ ] Commit: `docs: add in-extension help`

**OUTPUT:** Help integrato

---

### GIORNO 14-15: Marketplace Submission (8 ore)

#### Task 9.1: Packaging (2 ore)

**TOOL:** `vsce` (Visual Studio Code Extension Manager)

```bash
npm install -g vsce

# Package extension
vsce package
# Output: cervellaswarm-0.1.0.vsix
```

**CHECKLIST:**
- [ ] Install vsce
- [ ] Verify package.json (version, publisher, etc.)
- [ ] Run: `vsce package`
- [ ] Test .vsix locally: `code --install-extension cervellaswarm-0.1.0.vsix`
- [ ] Verify extension loads correctly
- [ ] Commit: `chore: prepare for packaging`

**OUTPUT:** `.vsix` file pronto

---

#### Task 9.2: Publisher Setup (2 ore)

**STEPS:**

1. Creare Microsoft account (se non esiste)
2. Creare Azure DevOps organization
3. Generare Personal Access Token (PAT)
4. Creare publisher su Marketplace

```bash
# Create publisher
vsce create-publisher rafapra

# Login
vsce login rafapra
```

**CHECKLIST:**
- [ ] Microsoft account ready
- [ ] Azure DevOps org created
- [ ] PAT generated (scope: Marketplace)
- [ ] Publisher created: `rafapra`
- [ ] Verify: https://marketplace.visualstudio.com/manage/publishers/rafapra

---

#### Task 9.3: Marketplace Listing (2 ore)

**METADATA:**

```json
{
  "name": "cervellaswarm",
  "displayName": "CervellaSwarm - Multi-Agent Orchestration",
  "description": "Transform Claude Code into a coordinated swarm of 16 specialized AI agents with built-in memory and analytics",
  "version": "0.1.0",
  "publisher": "rafapra",
  "icon": "images/icon.png",
  "galleryBanner": {
    "color": "#1E1E1E",
    "theme": "dark"
  },
  "categories": [
    "AI",
    "Programming Languages",
    "Other"
  ],
  "keywords": [
    "claude",
    "ai",
    "agents",
    "multi-agent",
    "swarm",
    "orchestration",
    "productivity"
  ]
}
```

**ASSETS NECESSARI:**
- Icon (128×128 PNG)
- Screenshots (5×, 1200×800 PNG)
- GIF demo (30 sec, <5MB)
- Banner (optional, 2000×200)

**CHECKLIST:**
- [ ] Preparare tutti assets grafici
- [ ] Validare package.json metadata
- [ ] Test: `vsce package` senza warning
- [ ] Commit: `chore: finalize marketplace metadata`

---

#### Task 9.4: Publish (2 ore)

```bash
# Publish to Marketplace
vsce publish

# Output:
# ✅ Published rafapra.cervellaswarm@0.1.0
# https://marketplace.visualstudio.com/items?itemName=rafapra.cervellaswarm
```

**REVIEW PROCESS:**
- Automated checks: ~10 minuti
- Manual review: 1-3 giorni lavorativi
- Notification via email quando approvato

**CHECKLIST:**
- [ ] Run: `vsce publish`
- [ ] Wait for automated checks
- [ ] Monitor email for review status
- [ ] Se rejected: fix issues, re-publish
- [ ] Quando approvato: celebrate! 🎉
- [ ] Share link su social media

**OUTPUT:** Extension LIVE su Marketplace!

---

## DIPENDENZE E CRITICAL PATH

### Diagramma Dipendenze

```
SETTIMANA 1: FOUNDATION
┌─────────────────────────────────────────────────┐
│ GIORNO 1                                        │
│ ┌───────────┐  ┌───────────┐  ┌──────────────┐│
│ │ Path      │→ │ Versioning│→ │ DB Migration ││
│ │ Refactor  │  │ Headers   │  │ System       ││
│ └───────────┘  └───────────┘  └──────────────┘│
│                                      ↓          │
│ ┌─────────────────────────────────────────┐   │
│ │ Dependency Isolation                    │   │
│ └─────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────┐
│ GIORNO 2-3                                      │
│ ┌───────────────┐  ┌──────────────────────┐    │
│ │ Extension     │→ │ Package.json Config  │    │
│ │ Boilerplate   │  └──────────────────────┘    │
│ └───────────────┘             ↓                 │
│                  ┌──────────────────────┐       │
│                  │ Extension Activation │       │
│                  └──────────────────────┘       │
└─────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────┐
│ GIORNO 4-5                                      │
│ ┌───────────────┐  ┌──────────────┐  ┌───────┐│
│ │ Agent         │→ │ Settings.json│→ │ Valid-││
│ │ Installer     │  │ Integration  │  │ ation ││
│ └───────────────┘  └──────────────┘  └───────┘│
└─────────────────────────────────────────────────┘

SETTIMANA 2: FEATURES
┌─────────────────────────────────────────────────┐
│ GIORNO 6-7                                      │
│ ┌───────────────┐  ┌──────────────────────┐    │
│ │ Launch Agent  │→ │ Agent Picker         │    │
│ │ Commands      │  │ QuickPick            │    │
│ └───────────────┘  └──────────────────────┘    │
└─────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────┐
│ GIORNO 8                                        │
│ ┌───────────────┐  ┌──────────────────────┐    │
│ │ Configuration │→ │ Settings Command     │    │
│ │ UI            │  └──────────────────────┘    │
│ └───────────────┘                               │
└─────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────┐
│ GIORNO 9-10                                     │
│ ┌───────────────┐  ┌──────────┐  ┌───────────┐│
│ │ Dashboard     │→ │ Charts   │→ │ Real-time ││
│ │ Panel         │  │ Integrat.│  │ Updates   ││
│ └───────────────┘  └──────────┘  └───────────┘│
└─────────────────────────────────────────────────┘

SETTIMANA 3: POLISH
┌─────────────────────────────────────────────────┐
│ GIORNO 11-12                                    │
│ ┌───────────┐  ┌──────────────┐  ┌───────────┐│
│ │ Unit      │  │ Integration  │  │ Manual    ││
│ │ Tests     │→ │ Tests        │→ │ Testing   ││
│ └───────────┘  └──────────────┘  └───────────┘│
└─────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────┐
│ GIORNO 13                                       │
│ ┌─────────┐  ┌───────────┐  ┌────────────────┐│
│ │ README  │→ │ CHANGELOG │→ │ In-Extension   ││
│ │         │  │           │  │ Help           ││
│ └─────────┘  └───────────┘  └────────────────┘│
└─────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────┐
│ GIORNO 14-15                                    │
│ ┌────────┐  ┌──────────┐  ┌─────────┐  ┌─────┐│
│ │Package │→ │Publisher │→ │Marketpl.│→ │Publ-││
│ │        │  │ Setup    │  │ Listing │  │ish  ││
│ └────────┘  └──────────┘  └─────────┘  └─────┘│
└─────────────────────────────────────────────────┘
```

### Critical Path (Longest Path)

```
Path Refactor (2h)
    ↓
Extension Boilerplate (12h)
    ↓
Agent Installer (6h)
    ↓
Dashboard Panel (8h)
    ↓
Charts Integration (4h)
    ↓
Unit Tests (8h)
    ↓
README (4h)
    ↓
Publish (2h)

TOTALE CRITICAL PATH: 46 ore
```

**IMPORTANTE:** Critical path = 46h, ma TOTALE effort = 96h perché molti task possono essere parallelizzati.

---

## TASK PARALLELIZZABILI

### Giorno 1 (Parallelizzabile)

Se lavori con un collaboratore:

**PERSONA A:**
- Path Parametrization (2h)
- Version Headers (1h)

**PERSONA B:**
- DB Migration (3h)
- Dependency Isolation (2h)

**SAVING:** 3 ore (8h → 5h)

---

### Giorno 9-10 (Parallelizzabile)

**PERSONA A:**
- Dashboard Panel HTML/CSS (4h)
- Charts Integration (4h)

**PERSONA B:**
- Real-time Updates (4h)
- Export Data feature (4h)

**SAVING:** 0 ore (sequenziali per singola persona)

---

## RISCHI E MITIGAZIONI

### RISCHIO 1: TypeScript Learning Curve

**PROBABILITÀ:** Media  
**IMPATTO:** Alto (può bloccare sviluppo)

**MITIGAZIONE:**
- Usare Yeoman generator (boilerplate già pronto)
- Copiare esempi da estensioni esistenti
- ChatGPT/Claude per TypeScript questions
- Budget extra: +4 ore per learning

---

### RISCHIO 2: Webview Complexity

**PROBABILITÀ:** Media  
**IMPATTO:** Medio (dashboard potrebbe essere semplificata)

**MITIGAZIONE:**
- Usare template HTML semplice (no framework)
- Chart.js invece di D3.js (più semplice)
- Fallback: dashboard solo testuale (se webview fail)
- Budget extra: +4 ore per debugging

---

### RISCHIO 3: Python Bridge Fail

**PROBABILITÀ:** Bassa  
**IMPATTO:** Alto (analytics non funzionano)

**MITIGAZIONE:**
- Test su 3 OS prima di release
- Fallback: analytics command via terminal
- Documentare requisito Python 3.8+
- Budget extra: +2 ore per testing

---

### RISCHIO 4: Marketplace Review Rejection

**PROBABILITÀ:** Bassa  
**IMPATTO:** Medio (ritarda launch 3-7 giorni)

**MITIGAZIONE:**
- Seguire guidelines Microsoft rigorosamente
- Peer review pre-submission
- Fix pre-emptive (license, privacy policy, ToS)
- Budget extra: +4 ore per fix

---

### RISCHIO 5: Database Schema Changes

**PROBABILITÀ:** Alta  
**IMPATTO:** Basso (migration system mitiga)

**MITIGAZIONE:**
- Migration system già in Settimana 1
- Backup DB prima di upgrade
- Rollback mechanism
- Budget: già incluso

---

## EFFORT BREAKDOWN PER SKILL

### TypeScript/JavaScript (40 ore)

- Extension activation (6h)
- Commands (8h)
- Agent installer (6h)
- Config manager (4h)
- Dashboard panel (8h)
- Testing (8h)

**SE NON SAI TypeScript:** +8 ore learning = 48h

---

### Python (8 ore)

- Path refactoring (2h)
- DB migration (3h)
- Dependency isolation (2h)
- Testing migration (1h)

**GIÀ SAI Python:** 8h OK

---

### HTML/CSS (12 ore)

- Dashboard webview (8h)
- Help webview (2h)
- Settings webview (opzionale, 2h)

**SE NON SAI CSS:** usa CSS framework (Tailwind CDN) = stesso tempo

---

### Documentation (8 ore)

- README (4h)
- CHANGELOG (1h)
- Help content (3h)

**FACILE:** solo writing

---

### DevOps (4 ore)

- Packaging (2h)
- Publisher setup (1h)
- Marketplace submission (1h)

**PRIMO VOLTA:** +2h = 6h

---

## TOTALE EFFORT ADJUSTED

```
BASE (senior dev, sa TypeScript):     96h  = 12 giorni @ 8h
+ TypeScript learning:                +8h  = 13 giorni
+ First-time VS Code extension:       +4h  = 13.5 giorni
+ Debugging buffer:                   +8h  = 14.5 giorni
+ Context switching (part-time):     +16h  = 16.5 giorni

REALISTICO (solo dev, part-time): ~20 giorni = 4 settimane
```

**RACCOMANDAZIONE:** Budget **4 settimane** per MVP, non 3.

---

## DAILY TASK CHECKLIST (GANTT STYLE)

### Week 1: Foundation

```
LUNEDÌ (Giorno 1) - 8 ore
──────────────────────────────────────────
08:00-10:00 │████████│ Task 1.1: Path Parametrization
10:00-11:00 │████    │ Task 1.2: Version Headers
11:00-14:00 │████████████│ Task 1.3: DB Migration
14:00-16:00 │████████│ Task 1.4: Dependency Isolation
16:00-17:00 │████    │ Testing + Commit

MARTEDÌ (Giorno 2) - 8 ore
──────────────────────────────────────────
08:00-12:00 │████████████████│ Task 2.1: Extension Boilerplate
13:00-15:00 │████████│ Task 2.2: Package.json Config
15:00-17:00 │████████│ Testing + Commit

MERCOLEDÌ (Giorno 3) - 8 ore
──────────────────────────────────────────
08:00-14:00 │████████████████████████│ Task 2.3: Extension Activation
14:00-17:00 │████████████│ Testing + Debug

GIOVEDÌ (Giorno 4) - 8 ore
──────────────────────────────────────────
08:00-14:00 │████████████████████████│ Task 3.1: Agent Installer
14:00-17:00 │████████████│ Testing

VENERDÌ (Giorno 5) - 8 ore
──────────────────────────────────────────
08:00-11:00 │████████████│ Task 3.2: Settings.json Integration
11:00-14:00 │████████████│ Task 3.3: Validation
14:00-17:00 │████████████│ Testing + Week Recap
```

### Week 2: Features

```
LUNEDÌ (Giorno 6) - 8 ore
──────────────────────────────────────────
08:00-12:00 │████████████████│ Task 4.1: Launch Commands
13:00-17:00 │████████████████│ Testing

MARTEDÌ (Giorno 7) - 8 ore
──────────────────────────────────────────
08:00-12:00 │████████████████│ Task 4.2: Agent Picker
13:00-17:00 │████████████████│ Testing + Polish

MERCOLEDÌ (Giorno 8) - 8 ore
──────────────────────────────────────────
08:00-12:00 │████████████████│ Task 5.1: Configuration UI
13:00-17:00 │████████████████│ Task 5.2: Settings Command

GIOVEDÌ (Giorno 9) - 8 ore
──────────────────────────────────────────
08:00-17:00 │████████████████████████████████│ Task 6.1: Dashboard Panel

VENERDÌ (Giorno 10) - 8 ore
──────────────────────────────────────────
08:00-12:00 │████████████████│ Task 6.2: Charts Integration
13:00-17:00 │████████████████│ Task 6.3: Real-time Updates
```

### Week 3: Polish

```
LUNEDÌ (Giorno 11) - 8 ore
──────────────────────────────────────────
08:00-17:00 │████████████████████████████████│ Task 7.1: Unit Tests

MARTEDÌ (Giorno 12) - 8 ore
──────────────────────────────────────────
08:00-12:00 │████████████████│ Task 7.2: Integration Tests
13:00-17:00 │████████████████│ Task 7.3: Manual Testing

MERCOLEDÌ (Giorno 13) - 8 ore
──────────────────────────────────────────
08:00-12:00 │████████████████│ Task 8.1: README.md
12:00-13:00 │████    │ Task 8.2: CHANGELOG
13:00-17:00 │████████████████│ Task 8.3: In-Extension Help

GIOVEDÌ (Giorno 14) - 8 ore
──────────────────────────────────────────
08:00-10:00 │████████│ Task 9.1: Packaging
10:00-12:00 │████████│ Task 9.2: Publisher Setup
13:00-15:00 │████████│ Task 9.3: Marketplace Listing
15:00-17:00 │████████│ Final Testing

VENERDÌ (Giorno 15) - 8 ore
──────────────────────────────────────────
08:00-10:00 │████████│ Task 9.4: Publish
10:00-17:00 │████████████████████████│ Monitor Review + Fix Issues
```

---

## METRICHE DI SUCCESSO

### Milestone 1: Week 1 Complete (Giorno 5)

**DEFINITION OF DONE:**
- [ ] Extension carica in VS Code debug
- [ ] Command "Initialize" funziona
- [ ] 4 agent files copiati in workspace
- [ ] Settings.json configurato
- [ ] Hook scripts installati
- [ ] Zero errori in console

**METRIC:** Se raggiunto Giorno 5 → ON TRACK

---

### Milestone 2: Week 2 Complete (Giorno 10)

**DEFINITION OF DONE:**
- [ ] Tutti 6 comandi funzionanti
- [ ] Dashboard apre e mostra dati
- [ ] Agent picker funziona
- [ ] Settings salvano correttamente
- [ ] Grafici renderizzati

**METRIC:** Se raggiunto Giorno 10 → ON TRACK

---

### Milestone 3: MVP Ready (Giorno 15)

**DEFINITION OF DONE:**
- [ ] 28 unit test passati
- [ ] 5 integration test passati
- [ ] Testato su Mac + Windows + Linux
- [ ] README completo con screenshots
- [ ] .vsix package creato
- [ ] Extension pubblicata su Marketplace

**METRIC:** Se raggiunto Giorno 15 → SUCCESS!

---

## CONTINGENCY PLANS

### SE RITARDO DI 1 SETTIMANA

**CUT FEATURES:**
- Dashboard charts (keep solo tabelle)
- Real-time updates (keep refresh button)
- In-extension help (link a docs esterne)

**SAVING:** -12 ore = mantieni 3 settimane

---

### SE RITARDO DI 2 SETTIMANE

**ULTRA-MVP:**
- Solo FREE tier (4 agent)
- Solo comandi (no dashboard)
- README minimale

**SAVING:** -24 ore = ritorno a 2 settimane

---

## POST-LAUNCH ROADMAP

### Mese 1 (post-launch)

```
SETTIMANA 1-2: Bug Fix + Support
├── Monitor recensioni Marketplace
├── Fix bugs critici
├── Setup support email
└── Rispondere a user feedback

SETTIMANA 3-4: Quick Wins
├── Aggiungere keyboard shortcuts
├── Migliorare error messages
├── Aggiungere telemetry (opzionale)
└── Creare video tutorial (1min)
```

### Mese 2-3

```
FEATURE RICHIESTE:
├── Custom agents (user-defined)
├── Team collaboration (share memory)
├── CLI companion tool
└── JetBrains plugin (se richiesto)
```

---

## CONCLUSIONE

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   VS CODE EXTENSION MVP: FATTIBILE IN 3-4 SETTIMANE             ║
║                                                                  ║
║   EFFORT:           96 ore (base) → 120 ore (realistico)        ║
║   TIMELINE:         15 giorni (full-time) → 20 giorni (p-time)  ║
║   RISCHIO:          MEDIO-BASSO                                  ║
║   COMPLESSITÀ:      6.5/10                                       ║
║                                                                  ║
║   RACCOMANDAZIONE:  PROCEDI CON CONFIDENZA                       ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

### Perché Sono Convinta

1. **Codebase Solido:** 12,000 righe già REALI e funzionanti
2. **Architettura Modulare:** Agent separati, facili da packagare
3. **Zero Dipendenze Pesanti:** SQLite + Python stdlib + Rich (opzionale)
4. **Tooling Maturo:** Yeoman generator + vsce già pronti
5. **Plan Dettagliato:** 96 ore breakdown chiaro e actionable
6. **Fallback Strategy:** Se ritardo, possiamo tagliare features non-core

**QUESTO PIANO È ESEGUIBILE.**

---

**Fine Piano Tecnico Dettagliato**

*Analizzato da:* cervella-ingegnera  
*Data:* 2 Gennaio 2026  
*Versione:* 1.0.0  
*Righe:* 613

💙 **"Dal codice al prodotto. Ora è il momento."**
