# STUDIO: Subagent Nativi di Claude Code

> **Data:** 30 Dicembre 2025
> **Obiettivo:** Capire a fondo come funzionano i subagent per usarli in CervellaSwarm

---

## 1. COSA SONO I SUBAGENT

I subagent sono **istanze specializzate di Claude** che possono essere invocate per task specifici. Sono nativi in Claude Code - non serve installare nulla!

```
┌─────────────────────────────────────────┐
│         CLAUDE PRINCIPALE               │
│    (quello con cui parli tu)            │
└─────────────────┬───────────────────────┘
                  │
    ┌─────────────┼─────────────┐
    ▼             ▼             ▼
┌───────┐   ┌───────┐   ┌───────┐
│ Sub 1 │   │ Sub 2 │   │ Sub 3 │
│Frontend│  │Backend│   │Tester │
└───────┘   └───────┘   └───────┘
```

**Vantaggi:**
- Ogni subagent ha il suo **context window isolato**
- Può usare **tool specifici** (limitati a quello che serve)
- Può usare **modelli diversi** (haiku per task veloci, opus per complessi)
- **Nessun setup** - funziona subito

---

## 2. DOVE SI CREANO

I subagent vanno in file `.md` in queste location:

| Location | Scope | Priorità |
|----------|-------|----------|
| `.claude/agents/` | Solo progetto corrente | **Alta** (vince) |
| `~/.claude/agents/` | Tutti i progetti | Bassa |

**Per CervellaSwarm:** Creeremo in `.claude/agents/` di ogni progetto che li usa.

---

## 3. FORMATO FILE

Ogni subagent è un file Markdown con YAML frontmatter:

```markdown
---
name: nome-subagent
description: Quando usare questo subagent
tools: Read, Edit, Bash, Glob, Grep
model: sonnet
permissionMode: default
---

System prompt che definisce il ruolo,
le capacità e l'approccio del subagent.
```

### Campi Configurazione

| Campo | Richiesto | Valori | Note |
|-------|-----------|--------|------|
| `name` | Sì | lowercase-con-trattini | ID univoco |
| `description` | Sì | Testo | Quando Claude lo invoca |
| `tools` | No | Lista tool | Se omesso, eredita tutti |
| `model` | No | `haiku`, `sonnet`, `opus`, `inherit` | Default: sonnet |
| `permissionMode` | No | `default`, `acceptEdits`, `bypassPermissions` | Default: default |
| `skills` | No | Lista skills | Skills da precaricare |

---

## 4. COME COMUNICANO

### Importante: I subagent NON parlano tra loro direttamente!

```
❌ Subagent A → Subagent B (impossibile)
✅ Subagent A → Claude Principale → Subagent B (corretto)
```

**Flusso comunicazione:**

1. Claude principale riceve task
2. Invoca Subagent A
3. Subagent A restituisce risultato
4. Claude principale elabora
5. Invoca Subagent B con context
6. E così via...

### Concatenazione Esplicita

Puoi chiedere a Claude di concatenare:

```
"Usa il code-analyzer per trovare problemi,
poi usa l'optimizer per risolverli"
```

---

## 5. MODELLI DISPONIBILI

| Modello | Velocità | Costo | Uso Ideale |
|---------|----------|-------|------------|
| **haiku** | Velocissimo | Basso | Ricerche, analisi veloci |
| **sonnet** | Bilanciato | Medio | Coding, task standard |
| **opus** | Lento | Alto | Task complessi, architettura |
| **inherit** | - | - | Usa quello del chiamante |

**Raccomandazione per CervellaSwarm:**
- `cervella-explorer` → haiku (veloce per cercare)
- `cervella-frontend` → sonnet (coding)
- `cervella-backend` → sonnet (coding)
- `cervella-tester` → sonnet (test + fix)
- `cervella-architect` → opus (decisioni importanti)

---

## 6. SUBAGENT BUILT-IN

Claude Code ha 3 subagent già pronti:

### Explore (haiku)
- Solo lettura
- Tool: Glob, Grep, Read, Bash (read-only)
- Uso: Cercare nel codebase senza modificare

### Plan
- Per pianificazione
- Usato in plan mode
- Non può chiamare altri subagent

### General-purpose (sonnet)
- Lettura e scrittura
- Tutti i tool
- Task complessi

---

## 7. ESEMPI PRATICI

### Esempio 1: Frontend Specialist

```markdown
---
name: cervella-frontend
description: Specialista UI/UX React e CSS. Usa per componenti, styling, responsive design.
tools: Read, Edit, Bash, Glob, Grep
model: sonnet
---

Sei Cervella Frontend, specializzata in:
- React/Vue components
- CSS/Tailwind styling
- Responsive design
- UI/UX best practices

Quando lavori:
1. Leggi sempre il codice esistente prima
2. Mantieni consistenza con lo stile del progetto
3. Mobile-first approach
4. Commenta solo dove necessario

Non modificare MAI:
- File backend (.py, API)
- Database
- Configurazioni server
```

### Esempio 2: Backend Specialist

```markdown
---
name: cervella-backend
description: Specialista Python, API, Database. Usa per endpoint, query, integrazioni.
tools: Read, Edit, Bash, Glob, Grep
model: sonnet
---

Sei Cervella Backend, specializzata in:
- Python/FastAPI
- Database SQLite/PostgreSQL
- API REST design
- Integrazioni esterne

Quando lavori:
1. Valida sempre gli input
2. Gestisci gli errori con messaggi chiari
3. Scrivi query efficienti
4. Documenta gli endpoint

Non modificare MAI:
- File frontend (.js, .css, .html)
- Asset statici
- Configurazioni UI
```

### Esempio 3: Tester

```markdown
---
name: cervella-tester
description: Specialista QA e testing. Usa per scrivere test, verificare funzionalità, bug hunting.
tools: Read, Edit, Bash, Glob, Grep
model: sonnet
---

Sei Cervella Tester, specializzata in:
- Unit test (pytest, jest)
- Integration test
- E2E test
- Bug hunting e debugging

Quando lavori:
1. Copri edge cases
2. Test sia happy path che error path
3. Mock delle dipendenze esterne
4. Report chiari dei risultati

Output atteso:
- Test che passano/falliscono con motivo
- Coverage report se possibile
- Suggerimenti per fix se trovi bug
```

---

## 8. COME INVOCARE

### Automatico
Claude invoca automaticamente basandosi su:
- Descrizione del task
- Campo `description` del subagent
- Context corrente

**Tip:** Usa parole chiave nella description come "Use PROACTIVELY" o "MUST BE USED"

### Esplicito
```
"Usa cervella-frontend per creare il componente"
"Chiedi a cervella-tester di verificare"
"Fai analizzare a cervella-backend l'API"
```

### Via /agents Command
```
/agents
```
Menu interattivo per gestire subagent.

---

## 9. LIMITAZIONI

| Limitazione | Workaround |
|-------------|------------|
| Non parlano tra loro | Orchestrare via Claude principale |
| No infinite nesting | Max 1 livello di subagent |
| Context separato | Passare info necessarie nel prompt |
| Token usage alto | Usare haiku dove possibile |

---

## 10. PRO E CONTRO PER CERVELLASWARM

### PRO ✅
- **Zero setup** - funziona subito
- **Nativo** - supportato ufficialmente
- **Flessibile** - ogni subagent configurabile
- **Isolamento** - context separati
- **Modelli diversi** - haiku/sonnet/opus per task diversi

### CONTRO ❌
- **No comunicazione diretta** - tutto via orchestratore
- **Stesso file** - due subagent non possono editare stesso file contemporaneamente
- **Token usage** - ogni subagent usa token separati
- **No parallelismo vero** - sequenziale, non simultaneo

---

## 11. RACCOMANDAZIONE PER CERVELLASWARM

**Usare subagent nativi per:**
- Task specializzati (frontend vs backend)
- Code review
- Testing
- Ricerche nel codebase

**NON usare da soli per:**
- Lavoro veramente parallelo (servono worktrees)
- Task che toccano stessi file
- Orchestrazione complessa (serve sistema custom)

**Combinazione ideale:**
```
Subagent + Git Worktrees = POTENZA MASSIMA
```

---

## 12. PROSSIMI PASSI

1. [x] Studiare subagent (questo documento)
2. [ ] Studiare Git Worktrees
3. [ ] Studiare Claude-Flow
4. [ ] Decidere architettura combinata
5. [ ] Creare primi subagent per test

---

## FONTI

- [Claude Code Subagents Documentation](https://code.claude.com/docs/en/sub-agents)
- [Claude Agent SDK Best Practices](https://skywork.ai/blog/claude-agent-sdk-best-practices-ai-agents-2025/)
- [Building Agents with Claude Code SDK](https://blog.promptlayer.com/building-agents-with-claude-codes-sdk/)

---

*"Un subagent per ogni specialità. Un orchestratore per governarli tutti."* 🐝
