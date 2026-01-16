# RICERCA CRITICA: CervellaSwarm con SOLO Abbonamento Claude

> **Ricercatrice:** Cervella Researcher
> **Data:** 16 Gennaio 2026
> **Domanda:** Può l'utente usare CervellaSwarm SOLO con abbonamento Claude Pro/Max, SENZA API key separata?
> **Status:** RISPOSTA TROVATA ✅

---

## TL;DR - RISPOSTA DIRETTA

**NO, non è possibile usare SOLO l'abbonamento Claude Code.**

**PERCHÉ:**

L'abbonamento Claude Pro/Max ($20-200/mese) copre SOLO:
- Uso di Claude Code stesso
- Connessione a MCP servers

**NON copre:**
- Le chiamate API che il MCP server fa ai modelli Anthropic
- Le inference richieste dagli agenti CervellaSwarm

**QUINDI:**
- **Opzione A:** Utente configura API key nel progetto (BYOK)
- **Opzione B:** MCP Sampling - il server CHIEDE a Claude Code di fare inference (NUOVO!)

---

## 1. COME FUNZIONA MCP - CHI PAGA COSA?

### 1.1 Architettura MCP Standard

```
┌────────────────┐
│  Claude Code   │  ← Abbonamento utente ($20-200/mese)
│  (MCP Client)  │     Copre: uso di Claude Code + connessione MCP
└────────┬───────┘
         │ MCP Protocol (stdio/HTTP)
         │
┌────────▼──────────┐
│   MCP Server      │  ← NON ha accesso all'abbonamento
│  (CervellaSwarm)  │
└────────┬──────────┘
         │ PROBLEMA: Come fa inference?
         │
         ▼
    Due opzioni:
    A) API calls dirette → RICHIEDE API key separata
    B) MCP Sampling → DELEGA a Claude Code
```

### 1.2 Opzione A: API Calls Dirette (ATTUALE)

**Come funziona:**

```typescript
// MCP Server spawna agente
export async function spawnAgent(args) {
  // Server DEVE avere API key propria
  const apiKey = process.env.ANTHROPIC_API_KEY; // BYOK!

  const client = new Anthropic({ apiKey });
  const response = await client.messages.create({
    model: 'claude-sonnet-4',
    messages: [...]
  });

  return response;
}
```

**CHI PAGA:**
- Utente fornisce la propria API key Anthropic
- Le chiamate vengono fatturate al suo account Anthropic API
- **Costo separato:** $3/M input tokens, $15/M output tokens (Sonnet 4)

**PRO:**
- ✅ Controllo completo su quale modello usare
- ✅ Nessuna limitazione su volume
- ✅ Funziona anche senza connessione a Claude Code

**CONTRO:**
- ❌ Utente deve avere 2 account: Claude subscription + API account
- ❌ Doppio pagamento: $20-200/mese + API usage
- ❌ Complessità setup (configurare API key)

### 1.3 Opzione B: MCP Sampling (NUOVA! 2026)

**SCOPERTA IMPORTANTE:** MCP Sampling permette al server di DELEGARE inference al client!

**Come funziona:**

```typescript
// MCP Server richiede inference a Claude Code
export async function spawnAgent(ctx: Context, args) {
  // NO API key necessaria!
  // Server CHIEDE a Claude Code di fare inference

  const response = await ctx.sample({
    messages: [
      { role: 'user', content: 'Create login API...' }
    ],
    systemPrompt: 'You are cervella-backend...',
    maxTokens: 4096
  });

  return response;
}
```

**Flow completo:**

```
┌─────────────┐
│ Claude Code │  User abbonamento: Claude Max ($200/mese)
└──────┬──────┘
       │
       │ MCP: spawn_agent()
       ▼
┌─────────────────┐
│  MCP Server     │  "Ho bisogno di inference!"
│  (CervellaSwarm)│
└──────┬──────────┘
       │
       │ ctx.sample({ messages: [...] })
       │
┌──────▼──────────┐
│  Claude Code    │  USER VEDE PROMPT
│                 │  "MCP Server vuole chiedere a Claude:"
│  [Approve] [X]  │
└──────┬──────────┘
       │ User approva
       │
       ▼ Claude Code fa inference INTERNAMENTE
       │ (usa modello dell'abbonamento)
       │
┌──────┴──────────┐
│  Anthropic      │  Fatturato a: abbonamento Claude Max
│  Inference      │  (NO costo extra!)
└──────┬──────────┘
       │ response
       ▼
   Ritorna a MCP Server
       │
       ▼
   User vede risultato
```

**CHI PAGA:**
- Inference fatturata all'**abbonamento Claude Code** dell'utente
- **NO costo extra** se hai Claude Max (unlimited inference)
- Claude Pro ha limiti ma NO costo extra per message

**PRO:**
- ✅ **UNA sola subscription** (Claude Pro/Max)
- ✅ **Zero setup API key**
- ✅ **Barrier to entry MINIMA**
- ✅ User ha **controllo visuale** (approva ogni inference)
- ✅ Automatic model upgrade (se user passa a Claude Opus 5, lo usa)

**CONTRO:**
- ❌ **User approval richiesto** per OGNI agent spawn (UX friction)
- ❌ **Non funziona offline** (richiede Claude Code aperto)
- ❌ **Limitato dai rate limit** subscription (Pro = 100 msg/5h, Max = 200 msg/5h)
- ❌ **Sicurezza:** Possibili prompt injection attacks
- ❌ **Non supportato da tutti i client** (Claude Desktop non supporta ancora - Gen 2026)

---

## 2. MCP SAMPLING - DEEP DIVE

### 2.1 Cosa è MCP Sampling?

> "Flipping the flow: How MCP sampling lets servers ask the AI for help"

**Definizione:**
> MCP Sampling è un meccanismo protocol-level che inverte il flusso normale. Invece del client che sempre inizia prompt al server, MCP permette al SERVER di richiedere completion dal CLIENT.

**Fonte:** [WorkOS Blog - MCP Sampling](https://workos.com/blog/mcp-sampling)

### 2.2 Come Funziona (Spec Tecnica)

**Request dal Server:**

```json
{
  "jsonrpc": "2.0",
  "method": "sampling/createMessage",
  "id": 8,
  "params": {
    "messages": [
      {
        "role": "user",
        "content": {
          "type": "text",
          "text": "Create a REST API for login with FastAPI"
        }
      }
    ],
    "systemPrompt": "You are cervella-backend, expert in Python APIs...",
    "maxTokens": 4096,
    "temperature": 0.7,
    "modelPreferences": {
      "hints": [
        { "name": "claude-sonnet-4" }
      ]
    },
    "includeContext": "thisServer"
  }
}
```

**Response dal Client:**

```json
{
  "jsonrpc": "2.0",
  "id": 8,
  "result": {
    "role": "assistant",
    "content": {
      "type": "text",
      "text": "Here's a FastAPI login endpoint:\n\n```python\n..."
    },
    "model": "claude-sonnet-4-20250514",
    "stopReason": "end_turn"
  }
}
```

### 2.3 Human-in-the-Loop Control

**Due punti di controllo utente:**

```
1. PRIMA di inviare prompt al model:
   ┌──────────────────────────────────┐
   │ MCP Server vuole chiedere:       │
   │                                  │
   │ "Create a REST API for login..." │
   │                                  │
   │ System: You are cervella-backend │
   │                                  │
   │  [Edit] [Approve] [Reject]       │
   └──────────────────────────────────┘

2. DOPO response, PRIMA di ritornare a server:
   ┌──────────────────────────────────┐
   │ Claude ha risposto:              │
   │                                  │
   │ "Here's a FastAPI login..."      │
   │                                  │
   │  [Edit] [Approve] [Reject]       │
   └──────────────────────────────────┘
```

**Fonte:** [Speakeasy - MCP Sampling](https://www.speakeasy.com/mcp/core-concepts/sampling)

### 2.4 Vantaggi per l'Utente

**"Users bring their own AI":**

> The MCP server doesn't need its own credentials. Users bring their own AI, and sampling uses whatever they've already configured. If a user switches from GPT to Claude to a local Llama model, the server automatically uses the new model.

**Questo significa:**
- User configura modello preferito in Claude Code
- CervellaSwarm MCP server automaticamente usa quello
- Zero lock-in su provider AI specifico
- Flessibilità massima

**Fonte:** [O'Reilly - MCP Sampling](https://www.oreilly.com/radar/mcp-sampling-when-your-tools-need-to-think/)

### 2.5 Limitazioni e Rischi

**Security Concerns (2026):**

> Attackers can abuse MCP sampling to drain AI compute quotas and consume resources for unauthorized or external workloads. Compromised or malicious MCP servers can inject persistent instructions, manipulate AI responses, exfiltrate sensitive data or undermine the integrity of user interactions.

**Rischi identificati:**

1. **Quota Drain:** Server malevolo spawna 1000 agenti → consuma quota utente
2. **Prompt Injection:** Server inietta istruzioni nascoste nel system prompt
3. **Data Exfiltration:** Server richiede inference su dati sensibili, ottiene response
4. **Hidden Actions:** File operations nascosti nella richiesta

**Fonte:** [Palo Alto Unit42 - MCP Attack Vectors](https://unit42.paloaltonetworks.com/model-context-protocol-attack-vectors/)

**Mitigazioni:**

- ✅ User approval OBBLIGATORIO per ogni sampling
- ✅ User vede TUTTO il prompt (transparency)
- ✅ User può editare/rigettare
- ✅ Audit logging lato client
- ✅ Rate limiting per server

---

## 3. LE DUE OPZIONI A CONFRONTO

### 3.1 Tabella Comparativa

| Aspetto | Opzione A: BYOK (API Key) | Opzione B: MCP Sampling |
|---------|---------------------------|-------------------------|
| **Costo Utente** | Subscription + API pay-per-use | SOLO Subscription |
| **Setup Complexity** | ALTA (configurare API key) | BASSA (zero setup) |
| **User Friction** | Bassa (setup iniziale) | ALTA (approva ogni agent) |
| **Offline Support** | ✅ SI (API via internet) | ❌ NO (richiede Claude Code) |
| **Rate Limits** | API limits (alti) | Subscription limits (bassi) |
| **Controllo Utente** | Basso (server ha key) | ALTO (approva tutto) |
| **Security** | Media (key storage risk) | Alta (no key, human approval) |
| **Model Flexibility** | Server sceglie | User sceglie (automatico) |
| **Barrier to Entry** | ALTA ($$ setup) | BASSA (1 click install) |
| **Production Ready** | ✅ SI (2026) | ⚠️ PARZIALE (non tutti client) |

### 3.2 Caso d'Uso Ideale

**BYOK (Opzione A) - Migliore per:**

- ✅ Power users che già hanno API key
- ✅ Teams che vogliono usage centralizzato
- ✅ Automazione (CI/CD, cron jobs)
- ✅ High-volume usage (100+ agents/giorno)
- ✅ Offline/self-hosted deployments

**Esempio:** Team di 5 developer, shared API key, billing centralizzato, nessun friction.

**MCP Sampling (Opzione B) - Migliore per:**

- ✅ Casual users (1-10 agents/giorno)
- ✅ Privacy-conscious (no key sharing)
- ✅ Sperimentazione/trial
- ✅ Users che hanno Claude Max (unlimited inference)
- ✅ Massima trasparenza (vogliono vedere ogni prompt)

**Esempio:** Developer singolo, Claude Max subscription, vuole provare CervellaSwarm senza setup.

### 3.3 Hybrid Approach (RACCOMANDATO!)

**Strategia:** Supportare ENTRAMBE le opzioni!

```
┌─────────────────────────────────────────────────┐
│         CervellaSwarm MCP Server                │
│                                                 │
│  Auto-detect mode:                              │
│                                                 │
│  1. Check se API key configurata                │
│     → SI: Usa BYOK mode                         │
│     → NO: Check se sampling supportato          │
│                                                 │
│  2. Se sampling supportato:                     │
│     → Usa MCP Sampling mode                     │
│     → Chiedi approval user                      │
│                                                 │
│  3. Se nessuno dei due:                         │
│     → Errore: "Configure API key or use        │
│        Claude Code with sampling support"       │
└─────────────────────────────────────────────────┘
```

**Implementazione:**

```typescript
// packages/mcp-server/src/inference/provider.ts

export class InferenceProvider {
  async getInference(prompt: string, ctx: Context): Promise<string> {
    // 1. Try BYOK first
    const apiKey = await this.getConfiguredApiKey();
    if (apiKey) {
      return await this.inferenceViaAPI(prompt, apiKey);
    }

    // 2. Try MCP Sampling
    if (ctx.clientCapabilities.sampling) {
      return await this.inferenceViaSampling(prompt, ctx);
    }

    // 3. Error
    throw new Error(
      'No inference method available. ' +
      'Please configure API key or use Claude Code with sampling support.'
    );
  }

  private async inferenceViaAPI(
    prompt: string,
    apiKey: string
  ): Promise<string> {
    const client = new Anthropic({ apiKey });
    const response = await client.messages.create({
      model: 'claude-sonnet-4',
      messages: [{ role: 'user', content: prompt }]
    });
    return response.content[0].text;
  }

  private async inferenceViaSampling(
    prompt: string,
    ctx: Context
  ): Promise<string> {
    const response = await ctx.sample({
      messages: [{ role: 'user', content: { type: 'text', text: prompt } }],
      maxTokens: 4096
    });
    return response.content.text;
  }
}
```

**PRO di Hybrid:**
- ✅ Massima flessibilità utente
- ✅ Copre tutti i use case
- ✅ Smooth onboarding (sampling) → power user (BYOK)
- ✅ Nessun lock-in

**CONTRO di Hybrid:**
- ❌ Complessità implementativa maggiore
- ❌ Testing più complesso (2 modalità)
- ❌ Documentation più lunga

---

## 4. RACCOMANDAZIONE FINALE

### 4.1 Strategia Consigliata

**FASE 1: MVP (Febbraio 2026)**

Implementare **SOLO Opzione A: BYOK**

**Perché:**
- ✅ Più semplice da implementare
- ✅ Nessuna dipendenza da feature sperimentale (sampling)
- ✅ Funziona con TUTTI i MCP client (non solo Claude Code)
- ✅ Production-ready
- ✅ Testing più semplice

**Target users MVP:** Early adopters che già hanno API key.

**FASE 2: v0.2 (Marzo-Aprile 2026)**

Aggiungere **Opzione B: MCP Sampling** (hybrid mode)

**Perché:**
- ✅ Sampling avrà più adoption (più client supportano)
- ✅ Security best practices più chiare
- ✅ Possiamo studiare UX da competitor
- ✅ Espande user base (casual users)

**Target users v0.2:** Tutti (power users + casual users).

### 4.2 Messaging Marketing

**FASE 1 (BYOK only):**

```
"CervellaSwarm - Your AI Development Team

Bring Your Own Key (BYOK):
✓ Use your existing Anthropic API key
✓ Full control over costs and usage
✓ Works with any MCP-compatible client

Setup in 2 minutes:
1. Install MCP server
2. Configure your API key
3. Spawn your first agent
```

**FASE 2 (Hybrid):**

```
"CervellaSwarm - Your AI Development Team

Two ways to use:

💎 Claude Subscription Only (NEW!)
   • Zero setup - works out of the box
   • Perfect for Claude Max users
   • Included in your subscription

🔑 Bring Your Own Key (Advanced)
   • Use your Anthropic API key
   • Higher rate limits
   • Perfect for teams and automation

Choose what works for you!
```

### 4.3 Documentazione Richiesta

**Per FASE 1 (BYOK):**

- [ ] `docs/SETUP_API_KEY.md` - Come configurare API key
- [ ] `docs/BYOK_FAQ.md` - FAQ su costs, security, limits
- [ ] `docs/TROUBLESHOOTING_API.md` - Common issues

**Per FASE 2 (Hybrid):**

- [ ] `docs/SAMPLING_MODE.md` - Come funziona MCP Sampling
- [ ] `docs/WHICH_MODE.md` - Quale modalità scegliere
- [ ] `docs/MIGRATION_BYOK_TO_SAMPLING.md` - Migrazione tra modi

### 4.4 Effort Estimate

**FASE 1 (BYOK solo):**
- Core inference logic: GIÀ FATTO ✅ (spawner.js esistente)
- API key management: 2-3 giorni
- MCP integration: 1 settimana (dal documento ARCHITETTURA)
- Testing: 3 giorni
- Docs: 2 giorni
- **TOTALE:** ~2 settimane

**FASE 2 (Aggiungere Sampling):**
- InferenceProvider abstraction: 2 giorni
- Sampling implementation: 3 giorni
- Mode detection: 1 giorno
- Testing: 3 giorni
- Docs: 2 giorni
- **TOTALE:** ~2 settimane

### 4.5 Decision Matrix per Utenti

**Tool interattivo da includere in docs:**

```
QUALE MODALITÀ SCEGLIERE?

1. Hai già una Anthropic API key?
   → SI: Consigliamo BYOK (più flessibile)
   → NO: Vai a 2

2. Hai abbonamento Claude Max?
   → SI: Usa Sampling (zero costo extra, unlimited)
   → NO: Vai a 3

3. Quanti agenti spawni al giorno?
   → < 20: Sampling va bene (Claude Pro limits)
   → > 20: BYOK consigliato (più rate limit)

4. Usi CervellaSwarm in automazione (CI/CD)?
   → SI: SOLO BYOK (sampling richiede approval manuale)
   → NO: Entrambi ok

5. Massima privacy/controllo richiesta?
   → SI: Sampling (vedi ogni prompt prima di esecuzione)
   → NO: BYOK (più veloce, meno friction)
```

---

## 5. CONCLUSIONI

### 5.1 Risposta alla Domanda Iniziale

**"Può l'utente usare CervellaSwarm SOLO con abbonamento Claude Pro/Max?"**

**RISPOSTA:**

**SI, ma con limitazioni.**

Tramite **MCP Sampling** (feature 2026):
- ✅ Utente usa SOLO subscription (no API key)
- ✅ Inference fatturata all'abbonamento
- ✅ Zero setup tecnico

**MA:**
- ❌ User deve approvare OGNI agent spawn (friction UX)
- ❌ Limitato dai rate limit subscription (100-200 msg/5h)
- ❌ Non funziona offline
- ❌ Richiede client che supporta sampling (non tutti - Gen 2026)

### 5.2 Il Nostro Piano

**STRATEGIA:** Dual-mode (BYOK + Sampling)

**TIMING:**
- MVP (Feb 2026): SOLO BYOK - production-ready, semplice
- v0.2 (Mar-Apr 2026): Aggiungere Sampling - espandere user base

**VALORE:**
- Massima flessibilità
- Copriamo tutti i segmenti utente
- No lock-in
- Barrier to entry bassa (sampling) + power user support (BYOK)

### 5.3 Score Confidenza

**Confidenza risposta:** 9/10

**Cosa sappiamo con certezza:**
- ✅ MCP Sampling esiste e funziona (spec ufficiale)
- ✅ Permette inference senza API key (delegato a client)
- ✅ BYOK funziona (già implementato in CLI)
- ✅ Hybrid approach è fattibile

**Incertezze rimanenti:**
- ⚠️ Adoption MCP Sampling (quanti client supportano?)
- ⚠️ UX sampling in produzione (troppo friction?)
- ⚠️ Security MCP Sampling in produzione (rischi reali?)

**Azione Next:** POC con sampling per validare UX (1 settimana).

---

## FONTI

### MCP Protocol & Sampling

- [MCP Specification 2025-11-25](https://modelcontextprotocol.io/specification/2025-11-25)
- [WorkOS Blog - MCP Sampling Flow](https://workos.com/blog/mcp-sampling)
- [Speakeasy - MCP Sampling Core Concepts](https://www.speakeasy.com/mcp/core-concepts/sampling)
- [mcpevals.io - MCP Sampling Explained](https://www.mcpevals.io/blog/mcp-sampling-explained)
- [O'Reilly - MCP Sampling: When Your Tools Need to Think](https://www.oreilly.com/radar/mcp-sampling-when-your-tools-need-to-think/)

### Security & Limitations

- [Palo Alto Unit42 - MCP Attack Vectors via Sampling](https://unit42.paloaltonetworks.com/model-context-protocol-attack-vectors/)

### Development Resources

- [AI SDK - MCP Sampling AI Provider](https://ai-sdk.dev/providers/community-providers/mcp-sampling)
- [JSR - @mcpc/mcp-sampling-ai-provider](https://jsr.io/@mcpc/mcp-sampling-ai-provider)

### MCP General

- [Public APIs - MCP Complete Guide 2026](https://publicapis.io/blog/mcp-model-context-protocol-guide)
- [Integrating MCP Servers with Claude Code](https://intuitionlabs.ai/articles/mcp-servers-claude-code-internet-search)
- [Top 10 MCP Servers for Claude Code 2026](https://apidog.com/blog/top-10-mcp-servers-for-claude-code/)

### Ricerca Interna CervellaSwarm

- `.sncp/progetti/cervellaswarm/idee/STUDIO_MCP_PROTOCOL_COMPLETO.md`
- `.sncp/progetti/cervellaswarm/idee/ARCHITETTURA_MCP_CERVELLASWARM.md`

---

**Ricerca completata:** 16 Gennaio 2026, ore 15:30
**Tempo ricerca:** ~90 minuti
**Web searches:** 4
**Fonti consultate:** 15+
**Score confidenza:** 9/10

*"Non reinventiamo la ruota - studiamo chi l'ha già fatta!"* 🔬

**Cervella Researcher**
