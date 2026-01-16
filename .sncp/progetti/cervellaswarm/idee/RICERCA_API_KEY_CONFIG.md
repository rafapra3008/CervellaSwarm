# Ricerca: Configurazione API Key per CervellaSwarm MCP Server

**Data**: 16 Gennaio 2026
**Ricercatrice**: Cervella Researcher
**Status**: ✅ Completata

---

## TL;DR - LA RISPOSTA

**Subscription Claude Pro/Max NON include crediti API.**

Per usare CervellaSwarm (che spawna agenti via API Anthropic):
- Serve billing API SEPARATO su console.anthropic.com
- Subscription = Claude chat/web/code
- API = Chiamate programmatiche (il nostro MCP server)

**Raccomandazione**: Aggiungere API key in `.mcp.json` (env locale al processo MCP).

---

## 1. Subscription vs API - La Verità

### Sono PRODOTTI SEPARATI

```
Claude Pro/Max ($20-200/mese)
  ├─ Accesso Claude web app
  ├─ Accesso Claude desktop app
  ├─ Accesso Claude Code CLI
  └─ NON include API credits

Claude API (pay-per-use)
  ├─ Console separata (console.anthropic.com)
  ├─ Billing separato
  ├─ API key SK-ANT-API03-...
  └─ Prezzi: $3/1M token (Sonnet), $15/1M (Opus)
```

**Fonte ufficiale Anthropic**:
> "A paid Claude subscription doesn't include access to the Claude API or Console."

### Perché Sono Separati?

- **Subscription**: Uso personale, interfaccia grafica, limiti fissati
- **API**: Uso programmatico, applicazioni custom, pay-per-token

---

## 2. Il Nostro Caso - CervellaSwarm MCP

### Come Funziona il MCP Server

```typescript
// packages/mcp-server/src/config/manager.ts

export function getApiKey(): string | null {
  // 1. ENVIRONMENT variable ha priorità
  const envKey = process.env.ANTHROPIC_API_KEY;
  if (envKey) {
    return envKey;
  }

  // 2. Fall back a config salvata (cervellaswarm init)
  const savedKey = getConfig().get("apiKey");
  return savedKey || null;
}
```

**Attuale**: L'MCP cerca API key in:
1. Variabile ambiente `ANTHROPIC_API_KEY`
2. Config salvata (`~/.config/cervellaswarm/config.json`)

### Cosa Succede Quando Spawniamo un Agente?

```
Regina (Claude Code) → spawn_worker tool
  ↓
MCP Server (Node.js) → chiama API Anthropic
  ↓
Crea conversazione con claude-sonnet-4-5
  ↓
Consuma token (BILLING API!)
```

**Questo NON usa l'abbonamento Claude Code!**
Usa API billing separato.

---

## 3. Perché la Key è Commentata in .zshrc

```bash
# Riga 76 di .zshrc
# export ANTHROPIC_API_KEY="sk-ant-api03-..."  # commentata
```

**Commento**: "per usare subscription"

### Analisi

Probabilmente confusione su come funziona Claude Code:
- **Claude Code** (il CLI) usa subscription se lanciato con `claude`
- **MCP Server** (il nostro spawn-worker) usa API separata

La key commentata NON serve per Claude Code normale.
Ma SERVE per il nostro MCP server!

---

## 4. Opzioni di Configurazione

### Opzione A: Environment in .mcp.json (MIGLIORE)

```json
{
  "mcpServers": {
    "cervellaswarm": {
      "command": "node",
      "args": [
        "/Users/rafapra/Developer/CervellaSwarm/packages/mcp-server/dist/index.js"
      ],
      "env": {
        "ANTHROPIC_API_KEY": "sk-ant-api03-..."
      }
    }
  }
}
```

**PRO**:
- API key SOLO per il processo MCP
- Non esposta globalmente
- Non interfiere con altri tool
- Sicurezza migliore (scope limitato)

**CONTRO**:
- File .mcp.json non va in git (aggiungere a .gitignore!)

---

### Opzione B: Scommentare in .zshrc (SCONSIGLIATO)

```bash
export ANTHROPIC_API_KEY="sk-ant-api03-..."
```

**PRO**:
- Funziona per tutti i processi

**CONTRO**:
- Espone API key globalmente
- Rischio di leak in logs/errori
- Meno controllo su dove viene usata

---

### Opzione C: cervellaswarm init (Config File)

```bash
cervellaswarm init
# Salva in ~/.config/cervellaswarm/config.json
```

**PRO**:
- Gestione centralizzata
- CLI può fare rotate/update key

**CONTRO**:
- MCP server deve leggere file extra
- Logica più complessa

---

## 5. Raccomandazione Finale

### SOLUZIONE CONSIGLIATA

**Opzione A: Environment in .mcp.json**

```json
{
  "mcpServers": {
    "cervellaswarm": {
      "command": "node",
      "args": [
        "/Users/rafapra/Developer/CervellaSwarm/packages/mcp-server/dist/index.js"
      ],
      "env": {
        "ANTHROPIC_API_KEY": "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"
      }
    }
  }
}
```

**Poi aggiungere a .gitignore**:
```
# .gitignore (nella home)
.mcp.json
```

### Perché Questa Scelta?

1. **Sicurezza**: Key isolata al processo MCP
2. **Semplicità**: No config file extra
3. **Compatibilità**: Già supportata dal codice (riga 74-77 manager.ts)
4. **Flessibilità**: Ogni MCP può avere key diversa se serve

---

## 6. WARNING: COSTI API

### Prezzi Claude API (2026)

| Modello | Input | Output |
|---------|-------|--------|
| Claude Sonnet 4.5 | $3/1M token | $15/1M token |
| Claude Opus 4.5 | $15/1M token | $75/1M token |

### Stima Costi per CervellaSwarm

**Scenario tipico**: Spawn worker per task medio

```
Task: "Analizza questo componente React e suggerisci ottimizzazioni"

Input:
- DNA worker (~5k token)
- Contesto progetto (~10k token)
- Task description (~1k token)
= 16k token input

Output:
- Analisi + codice (~5k token)

Costo (Sonnet):
- Input: 16k * $3/1M = $0.048
- Output: 5k * $15/1M = $0.075
= $0.12 per spawn
```

**Per 100 spawn/mese**: ~$12
**Per 500 spawn/mese**: ~$60

### Budget Control

Il MCP server già traccia token (riga 102):
```typescript
`Tokens: ${result.usage?.inputTokens || 0} in / ${result.usage?.outputTokens || 0} out`
```

Potremmo aggiungere un log giornaliero:
- `.sncp/reports/api_usage_YYYY-MM-DD.json`
- Alert se > soglia impostata

---

## 7. Next Steps

### Azioni Immediate

1. **Attivare API billing** su console.anthropic.com
   - Sign up (se non fatto)
   - Aggiungere metodo pagamento
   - Generare API key

2. **Configurare .mcp.json** con env key

3. **Test** con `spawn-worker --backend "Hello test"`

4. **Monitorare costi** per prima settimana

### Possibili Evoluzioni

- **Budget guard**: Script che blocca se costi > X/mese
- **Usage dashboard**: Report mensili automatici
- **API key rotation**: Cambia key ogni 30 giorni (security)

---

## Fonti

- [Claude API vs Subscription](https://support.claude.com/en/articles/9876003-i-have-a-paid-claude-subscription-pro-max-team-or-enterprise-plans-why-do-i-have-to-pay-separately-to-use-the-claude-api-and-console)
- [Claude Pricing](https://claudelog.com/faqs/what-is-the-difference-between-claude-api-and-subscription/)
- [Using Claude Code with Pro/Max](https://support.claude.com/en/articles/11145838-using-claude-code-with-your-pro-or-max-plan)
- [Usage & Cost API](https://platform.claude.com/docs/en/build-with-claude/usage-cost-api)

---

**Cervella Researcher** - "Studiare prima di agire - sempre!" 🔬
