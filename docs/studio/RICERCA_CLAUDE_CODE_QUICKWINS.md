# RICERCA: Claude Code CLI - 15 Quick Wins

> *Ricerca recuperata da agent transcript - 2 Gennaio 2026*

---

## SINTESI ESECUTIVA

```
15 QUICK WINS TROVATI!

TOP 3:
1. Skills Auto-Activation → GAME CHANGER!
2. MCP GitHub Integration → LIBERTA totale!
3. Custom Commands → Instant productivity!
```

---

## QUICK WINS CATEGORIZZATI

### IMMEDIATE (30 min totali!)

| # | Quick Win | Tempo | Impatto |
|---|-----------|-------|---------|
| 1 | Custom commands con $ARGUMENTS | 10 min | Alto |
| 2 | Terminal profiles ottimizzati | 10 min | Medio |
| 3 | /clear habit dopo compact | 5 min | Medio |
| 4 | Alias per continue mode | 5 min | Medio |

### GAME CHANGERS (1.5 ore)

| # | Quick Win | Tempo | Impatto |
|---|-----------|-------|---------|
| 5 | Skills auto-activation | 45 min | ENORME |
| 6 | MCP GitHub integration | 45 min | ENORME |
| 7 | MCP Filesystem | 30 min | Alto |

### AUTOMATION (3+ ore)

| # | Quick Win | Tempo | Impatto |
|---|-----------|-------|---------|
| 8 | PermissionRequest hook | 30 min | Medio |
| 9 | SessionStart migliorato | 1 ora | Alto |
| 10 | Model auto-switching | 1 ora | Alto |
| 11 | Auto-formatting hooks | 30 min | Medio |

### ADVANCED (when needed)

| # | Quick Win | Tempo | Impatto |
|---|-----------|-------|---------|
| 12 | Extended thinking | 30 min | Situazionale |
| 13 | Subagents ottimizzati | 2 ore | Alto |
| 14 | Memory hooks | 1 ora | Alto |
| 15 | Context windowing | 1 ora | Alto |

---

## TOP 3 DETTAGLIATI

### 1. SKILLS AUTO-ACTIVATION

**Cos'e:** Skills che si attivano automaticamente dal contesto!

**Esempio:**
```markdown
# .claude/skills/checkpoint.md
---
trigger: when user says "checkpoint" or "salva" or "pausa"
---

Esegui checkpoint completo:
1. Aggiorna NORD.md
2. Aggiorna ROADMAP_SACRA.md
3. Aggiorna PROMPT_RIPRESA.md
4. Git commit + push
```

**ROI:** 10x - risparmi 30+ minuti/giorno

### 2. MCP GITHUB INTEGRATION

**Cos'e:** Claude legge/scrive issues e PR direttamente!

**Setup:**
```json
// ~/.claude/settings.json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@github/mcp-server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_..."
      }
    }
  }
}
```

**ROI:** 5x - elimina context switching

### 3. CUSTOM COMMANDS CON $ARGUMENTS

**Cos'e:** Comandi personalizzati con parametri!

**Esempio:**
```markdown
# .claude/commands/review.md
Fai code review del file: $ARGUMENTS

Focus su:
- Security
- Performance
- Best practices
```

**Uso:** `/review src/api/users.py`

**ROI:** 3x - risparmio 5-10min per task

---

## PIANO IMPLEMENTAZIONE

### SESSIONE 1 (30 min - OGGI)
```
1. Custom commands con $ARGUMENTS
2. Terminal setup
3. /clear habit
4. Continue mode alias
```

### SESSIONE 2 (1.5 ore - DOMANI)
```
5. Skills auto-activation (checkpoint, reality-check)
6. MCP GitHub setup
```

### SESSIONE 3 (3 ore - SETTIMANA PROSSIMA)
```
10. SessionStart migliorato
11. Model auto-switching
```

---

## FONTI

- [Claude Code Best Practices for Agentic Coding](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Shipyard Claude Code CLI Cheatsheet](https://shipyard.build/blog/claude-code-cheat-sheet/)
- [Get Started with Claude Code Hooks](https://code.claude.com/docs/en/hooks-guide)
- [MCP Servers - Model Context Protocol](https://github.com/modelcontextprotocol/servers)
- [GitHub MCP Server Official](https://github.com/github/github-mcp-server)
- [Agent Skills - Claude Code Docs](https://code.claude.com/docs/en/skills)
- [Prompt Caching - Claude Docs](https://docs.claude.com/en/docs/build-with-claude/prompt-caching)

---

*Ricerca: 2 Gennaio 2026*
*Ricercatrice: Cervella Researcher*

*"Quick wins = momentum per cose piu grandi!"*
