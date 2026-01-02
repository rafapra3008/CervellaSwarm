# Ricerca: Come Testare Agent HQ in VS Code

> **Data:** 2 Gennaio 2026 - Sessione 52
> **Ricercatrice:** cervella-researcher
> **Confidenza:** 95%

---

## Executive Summary

```
RISPOSTA: SI, POSSIAMO TESTARE SUBITO!

Requisiti:
- VS Code 1.107+ (Novembre 2025)
- GitHub Copilot Pro+ attivo
- File .agent.md in .github/agents/ (gia creati!)
```

---

## 1. Requisiti Tecnici

### VS Code Version

| Requisito | Dettaglio |
|-----------|-----------|
| **Versione minima** | 1.106 (Ottobre 2025) |
| **Versione consigliata** | 1.107+ (Novembre 2025) |

**Verifica:** `code --version`

### GitHub Copilot Subscription

| Piano | Custom Agents | Handoffs |
|-------|---------------|----------|
| **Free** | NO | NO |
| **Pro** ($10/mese) | SI | SI |
| **Pro+** ($39/mese) | SI | SI |
| **Business/Enterprise** | SI | SI |

**IMPORTANTE:** Serve almeno Copilot **Pro**.

### Formato File

**Posizione:** `.github/agents/*.agent.md`

**Formato YAML frontmatter:**
```yaml
---
name: cervella-frontend
description: Specialista UI/UX
tools: ['read', 'edit', 'search']
model: claude-sonnet-4-5
target: vscode
infer: true
handoffs:
  - label: Escalate to Guardian
    agent: cervella-guardiana-qualita
    prompt: Review work quality.
    send: false
---

# Agent Instructions
[Markdown content...]
```

---

## 2. Test Step-by-Step

### TEST 1: VS Code Rileva Agents

```
1. Apri VS Code nel workspace CervellaSwarm
   cd ~/Developer/CervellaSwarm && code .

2. Apri Copilot Chat (Cmd+Shift+I)

3. Clicca dropdown "Select an agent"

PASS: Vedi cervella-frontend, cervella-backend, etc.
FAIL: Vedi solo @workspace, @vscode, @terminal
```

### TEST 2: Usa Agent Custom

```
1. Seleziona "cervella-frontend" dal dropdown

2. Invia: "Analizza Header.jsx e dimmi best practices"

3. Verifica risposta

PASS: Risponde al FEMMINILE secondo DNA
FAIL: Risposta generica
```

### TEST 3: Verifica Handoffs

```
1. Seleziona "cervella-frontend"

2. Invia: "Crea componente Button.jsx"

3. Cerca bottone "Escalate to Quality Guardian"

PASS: Bottone visibile
FAIL: Nessun bottone
```

### TEST 4: Multi-Agent

```
1. Task per cervella-frontend: "Crea UserCard.jsx"
2. Task per cervella-tester: "Scrivi test per UserCard.jsx"
3. Verifica Agent Sessions View

PASS: Entrambi completano senza conflitti
FAIL: Errori o conflitti
```

---

## 3. Limitazioni Conosciute

| Feature | VS Code | GitHub.com |
|---------|---------|------------|
| Custom agents | SI | SI |
| Handoffs | SI | NO |
| `model` property | SI | Ignorata |
| MCP tools custom | SI | Limitato |

**NOTA:** Handoffs NON supportati su GitHub.com (solo IDE).

---

## 4. Troubleshooting

### Agents Non Appaiono

1. Verifica path: `.github/agents/` (non `agents/`)
2. Verifica estensione: `.agent.md` (non `.md`)
3. Riavvia VS Code: `Developer: Reload Window`
4. Verifica Copilot: `GitHub Copilot: Check Status`

### Agent Non Segue DNA

**PROBLEMA:** VS Code NON legge `@~/.claude/COSTITUZIONE.md`

**SOLUZIONE:** DNA deve essere INCLUSO nel file .agent.md stesso (standalone).

---

## 5. Fonti

- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [VS Code 1.106 Release Notes](https://code.visualstudio.com/updates/v1_106)
- [GitHub Custom Agents Config](https://docs.github.com/en/copilot/reference/custom-agents-configuration)
- [Agent HQ Blog Post](https://github.blog/news-insights/company-news/welcome-home-agents/)

---

*"Nulla e complesso - solo non ancora studiato!"* 🔬
