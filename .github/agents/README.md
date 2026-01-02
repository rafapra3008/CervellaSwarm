# CervellaSwarm Agents - VS Code Agent HQ

> **16 AI agents specializzati, pronti per VS Code Agent HQ**

---

## Quick Start

### Requisiti
- VS Code 1.107+ (Novembre 2025)
- GitHub Copilot attivo
- Claude model access

### Attivazione
1. Apri VS Code nel progetto
2. Gli agents vengono rilevati automaticamente da `.github/agents/`
3. Usa Copilot Chat: `@cervella-frontend aiutami con...`

---

## La Famiglia (16 membri)

### La Regina e Le Guardiane (Opus)

| Agent | Ruolo | Usa quando |
|-------|-------|------------|
| `cervella-orchestrator` | Coordina tutto lo sciame | Task complessi multi-dominio |
| `cervella-guardiana-qualita` | Verifica output | Dopo implementazione |
| `cervella-guardiana-ops` | Verifica deploy/security | Prima di deploy |
| `cervella-guardiana-ricerca` | Verifica ricerche | Dopo ricerche importanti |

### Le Api Worker (Sonnet)

| Agent | Specializzazione | Tools |
|-------|------------------|-------|
| `cervella-frontend` | React, CSS, UI/UX | read, edit, search |
| `cervella-backend` | Python, FastAPI, API | read, edit, terminal |
| `cervella-tester` | Testing, QA, Debug | read, edit, terminal |
| `cervella-reviewer` | Code review | read, search |
| `cervella-researcher` | Ricerca tecnica | read, search, fetch |
| `cervella-scienziata` | Ricerca strategica | read, search, fetch |
| `cervella-ingegnera` | Analisi codebase | read, search, terminal |
| `cervella-marketing` | UX strategy | read, search, fetch |
| `cervella-devops` | Deploy, CI/CD | read, edit, terminal |
| `cervella-docs` | Documentazione | read, edit, search |
| `cervella-data` | SQL, analytics | read, edit, terminal |
| `cervella-security` | Audit sicurezza | read, search, fetch |

---

## Gerarchia e Handoffs

```
                    +------------------------+
                    |   cervella-orchestrator |
                    |      (La Regina)        |
                    +------------------------+
                              |
        +---------------------+---------------------+
        |                     |                     |
+---------------+   +------------------+   +----------------+
|  guardiana-   |   |    guardiana-    |   |   guardiana-   |
|   qualita     |   |     ricerca      |   |      ops       |
+---------------+   +------------------+   +----------------+
        |                     |                     |
   +----+----+           +----+----+          +----+----+
   |    |    |           |    |    |          |    |    |
 front back test      research docs      devops security
   end  end  er         er
```

### Come funzionano gli Handoffs

Gli agents hanno `handoffs` configurati per escalare alle Guardiane:

```yaml
handoffs:
  - label: Escalate to Quality Guardian
    agent: cervella-guardiana-qualita
    prompt: Review work for quality and standards compliance.
    send: false
```

Quando un agent completa il lavoro, VS Code mostra un bottone per
passare il contesto alla Guardiana appropriata.

---

## Formato .agent.md

Ogni agent segue il formato VS Code Agent HQ:

```yaml
---
name: cervella-frontend
description: Specialista UI/UX, React, CSS
tools:
- read
- edit
- search
model: claude-sonnet-4-5
target: vscode
infer: true
handoffs:
  - label: Escalate to Guardian
    agent: cervella-guardiana-qualita
    prompt: Review work quality.
    send: false
---

# Nome Agent

[Contenuto DNA con istruzioni, filosofia, regole...]
```

---

## Filosofia CervellaSwarm

```
"Lavoriamo in PACE! Senza CASINO! Dipende da NOI!"

- Fatto BENE > Fatto VELOCE
- I dettagli fanno la differenza
- Una feature perfetta > Dieci mediocri
```

---

## Manutenzione

### Aggiornare un Agent

1. Modifica il file in `~/.claude/agents/` (source of truth)
2. Esegui lo script di conversione:
   ```bash
   python3 scripts/convert_agents_to_agent_hq.py
   ```

### Aggiungere un nuovo Agent

1. Crea il file in `~/.claude/agents/[nome].md`
2. Esegui lo script di conversione
3. Commit in `.github/agents/`

---

## Links

- [VS Code Agent HQ Docs](https://code.visualstudio.com/docs/copilot/agents/overview)
- [Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration)
- [CervellaSwarm Repository](https://github.com/rafapra3008/CervellaSwarm)

---

*CervellaSwarm - "Uno sciame di Cervelle. Una sola missione."*

*Convertito da ~/.claude/agents/ - 2 Gennaio 2026*
