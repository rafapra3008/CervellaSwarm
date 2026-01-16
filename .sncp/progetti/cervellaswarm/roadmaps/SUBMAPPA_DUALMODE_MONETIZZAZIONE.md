# SUBMAPPA: Dual-Mode + Monetizzazione CervellaSwarm

> **Data:** 16 Gennaio 2026 - Sessione 237
> **Score Target:** 9.5/10
> **Status:** APPROVATO DA RAFA

---

## EXECUTIVE SUMMARY

```
+================================================================+
|                                                                |
|   STRATEGIA DUAL-MODE + FREEMIUM                               |
|                                                                |
|   L'utente SCEGLIE come pagare l'AI:                           |
|   A) BYOK - Porta sua API key (power users)                    |
|   B) Sampling - Usa abbonamento Claude (casual users)          |
|                                                                |
|   NOI monetizziamo le FEATURES CervellaSwarm:                  |
|   - Free: 50 calls/mo (acquisizione)                           |
|   - Pro: $20/mo, 500 calls (freelancer)                        |
|   - Team: $35/user/mo, 1K calls (agenzie)                      |
|   - Enterprise: Custom                                          |
|                                                                |
|   MARGINI: 95%+ (noi NON paghiamo mai AI!)                     |
|                                                                |
+================================================================+
```

---

## 1. DUAL-MODE: Come Funziona

### 1.1 Modalita BYOK (Bring Your Own Key)

```
FLUSSO:
Claude Code --> MCP Server --> Anthropic API
                    |              |
                    |              v
                    |         API Key utente
                    |              |
                    v              v
               Orchestrazione   Inference
               (CervellaSwarm)  (Anthropic)

COSTO UTENTE:
- Abbonamento Claude: $20-200/mo (opzionale)
- API Anthropic: Pay-per-use (~$0.12/spawn)
- CervellaSwarm: $0-35/mo (nostro pricing)

TARGET: Power users, high-volume, automazione
```

### 1.2 Modalita Sampling

```
FLUSSO:
Claude Code --> MCP Server --> "Fai questo task"
     ^              |                |
     |              |                v
     |              |         createMessage()
     |              |                |
     |              v                v
     +------- User Approval <--- Claude fa il lavoro
                                (abbonamento utente!)

COSTO UTENTE:
- Abbonamento Claude: $20-200/mo (RICHIESTO)
- API Anthropic: $0 (usa abbonamento!)
- CervellaSwarm: $0-35/mo (nostro pricing)

TARGET: Casual users, Claude Max ($200 = unlimited!)
```

### 1.3 Tabella Comparativa

| Aspetto | BYOK | Sampling |
|---------|------|----------|
| **Chi paga AI** | Utente (API key) | Utente (abbonamento) |
| **Setup** | Configura API key | Zero setup |
| **Automazione** | Totale | Richiede approvazione |
| **Costo extra** | API pay-per-use | Zero (abbonamento copre) |
| **Target** | Power user | Casual user |
| **Claude Max benefit** | Parziale | MASSIMO (gratis!) |

---

## 2. MONETIZZAZIONE: Freemium Model

### 2.1 Tier Structure

```
+================================================================+
|   TIER          | PREZZO      | CALLS/MO | TARGET              |
+================================================================+
|   FREE          | $0          | 50       | Prova, hobby        |
|   PRO           | $20/mo      | 500      | Freelancer, indie   |
|   TEAM          | $35/user/mo | 1,000    | Agenzie, startup    |
|   ENTERPRISE    | Custom      | Unlimited| Corporate           |
+================================================================+
```

### 2.2 Cosa Include Ogni Tier

**FREE (Acquisizione)**
- 50 agent calls/mese
- 3 progetti SNCP
- 1 task concorrente
- Community support (Discord)
- BYOK + Sampling entrambi disponibili

**PRO ($20/mo)**
- 500 agent calls/mese
- Progetti SNCP illimitati
- 3 task concorrenti
- Email support (24h)
- Prompt caching optimization
- Beta features early access

**TEAM ($35/user/mo, min 3 users)**
- 1,000 agent calls/user/mese
- Shared SNCP workspace
- Task concorrenti illimitati
- Admin console
- Team analytics
- Slack integration
- Priority support (12h)

**ENTERPRISE (Custom)**
- Calls illimitati (fair use)
- Self-hosted option
- SSO/SAML
- SLA 99.9%
- Custom integrations
- Dedicated success manager

### 2.3 Economics

```
COSTI NOSTRI:
- Infra: ~$300/mo (fixed)
- AI: $0 (BYOK/Sampling!)
- Support: ~$1/user/mo

MARGINI:
- Free: $0 (acquisition cost)
- Pro: 95% ($19 net su $20)
- Team: 97% ($34 net su $35)

BREAK-EVEN: 15 utenti Pro!

PROIEZIONE 12 MESI:
- 100 Pro + 10 Team (50 users) = $3,750 MRR
- = $45K ARR
- Margine netto: $43K (95%!)
```

---

## 3. IMPLEMENTAZIONE TECNICA

### 3.1 MCP Sampling Implementation

```typescript
// packages/mcp-server/src/sampling/client.ts

import { Server } from "@modelcontextprotocol/sdk/server";

export async function requestSampling(
  server: Server,
  prompt: string,
  context: string
): Promise<string> {

  // Chiedi a Claude Code di fare l'inference
  const result = await server.createMessage({
    messages: [{
      role: "user",
      content: {
        type: "text",
        text: `${context}\n\nTask: ${prompt}`
      }
    }],
    modelPreferences: {
      hints: [{ name: "claude-sonnet-4-20250514" }],
      intelligencePriority: 0.8
    },
    maxTokens: 4000,
    includeContext: "thisServer"
  });

  return result.content.text;
}
```

### 3.2 Dual-Mode Architecture

```typescript
// packages/mcp-server/src/config/mode.ts

export type InferenceMode = "auto" | "byok" | "sampling";

export interface ModeConfig {
  mode: InferenceMode;
  apiKey?: string;  // For BYOK
  samplingEnabled: boolean;  // Client capability
}

export function selectMode(config: ModeConfig): "byok" | "sampling" {
  if (config.mode === "byok") return "byok";
  if (config.mode === "sampling") return "sampling";

  // Auto mode: prefer sampling if available
  if (config.mode === "auto") {
    if (config.samplingEnabled) return "sampling";
    if (config.apiKey) return "byok";
    throw new Error("No inference method available");
  }
}
```

### 3.3 Metering & Limits

```typescript
// packages/mcp-server/src/billing/meter.ts

export interface UsageTracker {
  userId: string;
  tier: "free" | "pro" | "team" | "enterprise";
  callsThisMonth: number;
  callsLimit: number;
}

export function checkLimit(tracker: UsageTracker): boolean {
  const limits = {
    free: 50,
    pro: 500,
    team: 1000,
    enterprise: Infinity
  };

  return tracker.callsThisMonth < limits[tracker.tier];
}

export function trackCall(tracker: UsageTracker): void {
  tracker.callsThisMonth++;
  // Persist to storage
  saveUsage(tracker);
}
```

### 3.4 License Verification

```typescript
// packages/mcp-server/src/billing/license.ts

import Stripe from 'stripe';

export async function verifyLicense(licenseKey: string): Promise<Tier> {
  // Decode JWT license key
  const decoded = jwt.verify(licenseKey, process.env.LICENSE_SECRET);

  // Check with Stripe if subscription active
  const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
  const subscription = await stripe.subscriptions.retrieve(decoded.subId);

  if (subscription.status !== 'active') {
    return 'free';  // Fallback to free tier
  }

  return decoded.tier;  // 'pro' | 'team' | 'enterprise'
}
```

---

## 4. GAP ANALYSIS

### 4.1 Score Attuale vs Target

```
+================================================================+
|   AREA                          | ATTUALE | TARGET | GAP       |
+================================================================+
|   MCP Server base               | 9/10    | 9.5/10 | -0.5      |
|   BYOK implementation           | 8/10    | 9.5/10 | -1.5      |
|   Sampling implementation       | 0/10    | 9.5/10 | -9.5      |
|   Dual-mode architecture        | 0/10    | 9.5/10 | -9.5      |
|   Billing/metering              | 0/10    | 9.5/10 | -9.5      |
|   License verification          | 0/10    | 9.5/10 | -9.5      |
|   Stripe integration            | 0/10    | 9.5/10 | -9.5      |
|   User dashboard                | 0/10    | 9.5/10 | -9.5      |
+================================================================+
|   MEDIA ATTUALE                 | 2.1/10                       |
|   TARGET                        | 9.5/10                       |
+================================================================+
```

### 4.2 Task Prioritizzati

| Priority | Task | Effort | Score Gain |
|----------|------|--------|------------|
| P0 | BYOK polish + API key validation | 2 giorni | +1.5 |
| P0 | Metering/limits (calls tracking) | 2 giorni | +1.5 |
| P1 | Stripe integration | 3 giorni | +2.0 |
| P1 | License key generation | 1 giorno | +0.5 |
| P1 | Free tier enforcement | 1 giorno | +0.5 |
| P2 | Sampling implementation | 3 giorni | +1.5 |
| P2 | Dual-mode selection | 1 giorno | +0.5 |
| P3 | User dashboard (usage) | 5 giorni | +1.0 |
| P3 | Team features | 5 giorni | +0.5 |

**TOTALE:** ~23 giorni lavoro = ~5 settimane

---

## 5. ROADMAP IMPLEMENTAZIONE

```
+================================================================+
|   SPRINT 1: BYOK POLISH (Settimana 1)                          |
+================================================================+
|   [ ] API key validation con test call                          |
|   [ ] Error messages user-friendly                              |
|   [ ] Config persistenza (conf package)                         |
|   [ ] cervellaswarm doctor command                              |
|                                                                |
|   GATE: BYOK funziona perfettamente, 9/10                      |
+================================================================+

+================================================================+
|   SPRINT 2: METERING & LIMITS (Settimana 2)                    |
+================================================================+
|   [ ] Usage tracking (calls/month)                              |
|   [ ] Tier limits enforcement                                   |
|   [ ] Usage storage (local file first)                          |
|   [ ] Upgrade prompts when limit reached                        |
|                                                                |
|   GATE: Limits funzionano, free tier rispettato                |
+================================================================+

+================================================================+
|   SPRINT 3: STRIPE INTEGRATION (Settimana 3)                   |
+================================================================+
|   [ ] Stripe account setup                                      |
|   [ ] Product/price creation (Pro, Team)                        |
|   [ ] Checkout flow                                             |
|   [ ] Webhook per subscription events                           |
|   [ ] License key generation post-payment                       |
|                                                                |
|   GATE: Pagamenti funzionano end-to-end                        |
+================================================================+

+================================================================+
|   SPRINT 4: SAMPLING (Settimana 4)                             |
+================================================================+
|   [ ] MCP Sampling implementation                               |
|   [ ] Dual-mode config                                          |
|   [ ] Auto mode selection                                       |
|   [ ] Fallback BYOK se sampling non disponibile                 |
|                                                                |
|   GATE: Entrambe modalita funzionano                           |
+================================================================+

+================================================================+
|   SPRINT 5: POLISH (Settimana 5)                               |
+================================================================+
|   [ ] User dashboard basic (usage view)                         |
|   [ ] Documentation completa                                    |
|   [ ] Error handling robusto                                    |
|   [ ] Security audit                                            |
|                                                                |
|   GATE: Score 9.5/10, production-ready                         |
+================================================================+
```

---

## 6. RISCHI E MITIGAZIONI

| Rischio | Probabilita | Impatto | Mitigazione |
|---------|-------------|---------|-------------|
| Claude Code non supporta Sampling | 60% (Jan 2026) | Alto | BYOK come fallback, pronto per quando supportera |
| Stripe setup complesso | 30% | Medio | Stripe ha MCP server ufficiale, docs ottime |
| Users non vogliono pagare | 40% | Alto | Free tier generoso, valore chiaro, trial |
| Metering abuse | 20% | Medio | Rate limiting, fraud detection |
| Sampling UX friction | 50% | Medio | Documentazione chiara, BYOK per power users |

---

## 7. SUCCESS METRICS

### 7.1 Technical Metrics

| Metric | Target | Current |
|--------|--------|---------|
| BYOK success rate | >95% | TBD |
| Sampling success rate | >90% | N/A |
| Payment conversion | >5% | N/A |
| Churn rate | <5%/mo | N/A |
| API error rate | <1% | TBD |

### 7.2 Business Metrics

| Metric | Month 1 | Month 6 | Month 12 |
|--------|---------|---------|----------|
| Free users | 100 | 500 | 2,000 |
| Pro users | 10 | 50 | 150 |
| Team accounts | 0 | 5 | 20 |
| MRR | $200 | $2,000 | $7,000 |
| ARR | $2,400 | $24,000 | $84,000 |

---

## 8. DECISIONI PRESE

| # | Decisione | Perche | Data |
|---|-----------|--------|------|
| 1 | Dual-Mode (BYOK + Sampling) | Massima flessibilita utente | 16 Gen 2026 |
| 2 | Freemium pricing | 92% devs preferiscono provare prima | 16 Gen 2026 |
| 3 | 50 calls free tier | Sufficiente per "wow moment" | 16 Gen 2026 |
| 4 | $20 Pro (come Cursor) | Competitive, proven price point | 16 Gen 2026 |
| 5 | $35 Team (< $40 Cursor) | Undercut competitor | 16 Gen 2026 |
| 6 | BYOK first, Sampling after | Claude Code non supporta ancora | 16 Gen 2026 |
| 7 | Stripe per payments | Industry standard, MCP support | 16 Gen 2026 |

---

## 9. DOCUMENTI CORRELATI

| Documento | Path |
|-----------|------|
| Ricerca MCP Sampling | `.sncp/progetti/cervellaswarm/idee/RICERCA_MCP_SAMPLING_DEEP_20260116.md` |
| Ricerca Monetizzazione | `.sncp/progetti/cervellaswarm/idee/RICERCA_MONETIZZAZIONE_MCP_20260116.md` |
| Ricerca Abbonamento | `.sncp/progetti/cervellaswarm/idee/RICERCA_ABBONAMENTO_ONLY_20260116.md` |
| Business Model | `.sncp/progetti/cervellaswarm/idee/BUSINESS_MODEL_MCP_BYOK.md` |
| MAPPA MCP BYOK | `.sncp/progetti/cervellaswarm/MAPPA_MCP_BYOK.md` |

---

## 10. SCORE FINALE

```
+================================================================+
|                                                                |
|   SCORE SUBMAPPA: 9.5/10                                       |
|                                                                |
|   - Ricerca: COMPLETA (3 documenti, 100+ fonti)                |
|   - Architettura: DEFINITA (dual-mode)                         |
|   - Pricing: DEFINITO (freemium)                               |
|   - Roadmap: DEFINITA (5 sprint)                               |
|   - Rischi: MAPPATI (5 con mitigazioni)                        |
|   - Decisioni: PRESE (7 decisioni documentate)                 |
|                                                                |
|   PRONTO PER IMPLEMENTAZIONE!                                  |
|                                                                |
+================================================================+
```

---

**Cervella & Rafa**
*16 Gennaio 2026 - Sessione 237*

*"Due opzioni per l'utente = piu utenti per noi!"*
*"Fatto BENE > Fatto VELOCE"*
