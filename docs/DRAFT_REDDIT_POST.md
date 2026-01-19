# Draft Reddit Post - CervellaSwarm

> **Status:** DRAFT - Da approvare
> **Target:** r/ClaudeAI (principale), r/LocalLLaMA (adattato)
> **Timing:** 26 Gennaio 2026, 6-8 AM USA (12:00-14:00 Italia)
> **Basato su:** Ricerca `.sncp/ricerca/RICERCA_LANCIO_SOCIAL_MEDIA.md`

---

## POST per r/ClaudeAI

### TITOLO (max 300 chars)

```
I built CervellaSwarm: 16 AI agents + 3 quality guardians using MCP - after 260+ sessions with Claude
```

### BODY

```markdown
**TL;DR:** Multi-agent AI system for professional developers. 16 specialized workers + 3 Opus guardians that check quality. MCP-native. Apache-2.0 open source.

---

## The Problem

I'm a solo developer who went deep on Claude. 260+ work sessions in 6 months. And I kept hitting the same walls:

- Context gets lost in complex projects
- One AI = one perspective (even if it's smart)
- No quality checks - you're the reviewer
- Switching between tools = lost momentum

I needed AI that works like a real dev team, not a single assistant.

---

## What I Built

**CervellaSwarm** = 16 specialized AI agents coordinated like a team:

| Role | Agents | Model |
|------|--------|-------|
| Orchestrator | 1 "Regina" | Opus |
| Quality Guardians | 3 (quality, security, ops) | Opus |
| Specialized Workers | 12 (frontend, backend, tester, researcher, devops, etc.) | Sonnet |

**The key insight:** Workers BUILD, Guardians VERIFY. Every output gets checked.

---

## How It Works

```bash
# Install
npx cervellaswarm init

# Spawn a backend specialist
npx cervellaswarm task "add user authentication with JWT"

# Or use with Claude Desktop via MCP
# The agents coordinate automatically
```

**Demo:** See hero image in README - real terminal workflow

![CLI Workflow](https://raw.githubusercontent.com/rafapra3008/CervellaSwarm/main/docs/demo/cli_workflow_en.png)

---

## Tech Stack (for the curious)

- **Protocol:** MCP (Model Context Protocol) - native integration
- **Workers:** Claude Sonnet 4.5 (fast, specialized)
- **Guardians:** Claude Opus 4.5 (deep review)
- **Memory:** SNCP - persistent state across sessions
- **License:** Apache-2.0 (fully open source)

---

## Why MCP?

MCP is Anthropic's standard protocol. It means CervellaSwarm works with:
- Claude Desktop
- Cursor
- Windsurf
- Any MCP-compatible client

No lock-in. Protocol > platform.

---

## What's Different vs Cursor/Aider?

| Feature | Cursor | Aider | CervellaSwarm |
|---------|--------|-------|---------------|
| Agents | 1 | 1 | 16 |
| Quality layer | No | No | 3 Guardians |
| MCP native | Partial | No | Yes |
| Specialization | Generic | Git-focused | Role-based |

Not saying better - different approach. Multi-agent + quality checks.

---

## Honest Limitations

- **Beta quality** - actively developed, expect rough edges
- **CLI first** - no VS Code extension yet
- **Solo dev** - me + Claude built this
- **Claude-only** - no OpenAI/local models yet (roadmap)

---

## Try It

- **GitHub:** https://github.com/rafapra3008/CervellaSwarm
- **npm CLI:** `npx cervellaswarm init`
- **npm MCP:** `@cervellaswarm/mcp-server`

---

## What I Need

Honest feedback:

1. Does this solve a real problem for you?
2. What would make you actually use it vs regular Claude?
3. Architecture concerns?

I'm here to answer questions. Built this because I needed it - hope it helps others too.

---

*This entire launch (including the research, posts, and coordination) was prepared using CervellaSwarm. Dogfooding is real.*
```

### PRIMO COMMENTO (post entro 5 min)

```markdown
**More context:**

**Pricing:** Free tier uses your own Anthropic API key directly. No middleman, no hidden limits. Typical cost: $0.01-0.05 per task, ~$30/month for daily use.

**Privacy:** Your code stays 100% local. Only task prompts go to Anthropic API. We never see your code.

**Why "CervellaSwarm"?** "Cervella" = brain in Italian. It's a swarm of specialized brains working together. Cheesy? Maybe. Accurate? Definitely.

**My story:** Two years ago I was stuck in a job that didn't fit, moved from Brazil to Italy after COVID. Needed change. Found Claude. Started building. 260+ sessions later, this is the result.

Happy to answer any questions!
```

---

## POST per r/LocalLLaMA (ADATTATO)

### TITOLO

```
CervellaSwarm: Multi-agent system with MCP protocol - looking for feedback on architecture
```

### BODY (tech-focused version)

```markdown
**TL;DR:** Open source multi-agent system using MCP protocol. Currently Claude-only but architecture is model-agnostic. Looking for feedback from the local LLM community.

---

## Architecture Overview

Built a coordinated multi-agent system with:

- **16 specialized agents** with role-based system prompts
- **3 guardian agents** for quality verification
- **MCP protocol** for tool/resource coordination
- **SNCP** (persistent memory system across sessions)

```
User Request
    ↓
Regina (Orchestrator)
    ↓
Spawn Worker(s) → Guardian Review → Output
```

---

## Why I'm Posting Here

The system is Claude-only today (Opus for guardians, Sonnet for workers), but the architecture is **model-agnostic by design**.

I'm interested in:
1. Has anyone built similar multi-agent coordination with local models?
2. Challenges with MCP + Ollama/LM Studio?
3. Which local models handle agent coordination well?

---

## Tech Stack

- MCP (Model Context Protocol) native
- FastAPI orchestration layer
- Role-based agent definitions
- Persistent state (file-based, no cloud)
- Apache-2.0 license

---

## Code

https://github.com/rafapra3008/CervellaSwarm

Looking at the `agents/` directory might be interesting for those building similar systems.

---

## Roadmap: Local Model Support

Planning to add:
- Ollama integration
- OpenAI-compatible endpoints
- Local model worker options

But want community input first. What would make this useful for local model users?
```

---

## CHECKLIST PRE-POST

### Account Reddit (@rafapra?)

- [ ] Account age > 30 days
- [ ] Karma > 25 points
- [ ] Participated in r/ClaudeAI discussions (2+ weeks)
- [ ] Participated in r/LocalLLaMA discussions (2+ weeks)
- [ ] No recent self-promo (90/10 rule)

### Post Assets

- [ ] Demo GIF/PNG ready (cli_workflow_en.png)
- [ ] GitHub link verified working
- [ ] npm packages verified working
- [ ] First comment drafted

### Timing

- [ ] Post at 6-8 AM USA time (12:00-14:00 Italia)
- [ ] Sunday = good engagement day
- [ ] First comment within 5 minutes
- [ ] Monitor every 30 min for first 2 hours

---

## NOTE

**IMPORTANTE:** Adattare il tono per ogni subreddit:
- r/ClaudeAI = più personal story, Claude-focused
- r/LocalLLaMA = più tecnico, architecture-focused, local model roadmap

**NON crosspostare identico!** Reddit penalizza.

---

*"Autenticita > Marketing polish"*
*Ricerca fonte: .sncp/ricerca/RICERCA_LANCIO_SOCIAL_MEDIA.md*
