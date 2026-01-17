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

## 4. GAP ANALYSIS (Aggiornato Sessione 250)

> **IMPORTANTE:** Audit del 17 Gen 2026 ha rivelato che molto codice
> è scritto ma NON deployato. "SU CARTA" != "REALE"!

### 4.1 Score Attuale vs Target

```
+================================================================+
|   AREA                          | CODICE | DEPLOY | REALE      |
+================================================================+
|   MCP Server base               | 9/10   | 0/10   | 4/10       |
|   BYOK implementation           | 9/10   | 0/10   | 4/10       |
|   Sampling implementation       | 0/10   | 0/10   | 0/10       |
|   Dual-mode architecture        | 0/10   | 0/10   | 0/10       |
|   Billing/metering (codice)     | 9/10   | 0/10   | 4/10       |
|   CLI commands                  | 9/10   | 0/10   | 4/10       |
|   Stripe integration (codice)   | 9/10   | 0/10   | 4/10       |
|   API deploy (Fly.io)           | 8/10   | 0/10   | 0/10       |
|   Test API                      | 0/10   | -      | 0/10       |
+================================================================+
|   MEDIA CODICE                  | 6.7/10                       |
|   MEDIA REALE (production)      | 2.2/10                       |
|   TARGET                        | 9.5/10                       |
+================================================================+
```

### 4.2 Task Prioritizzati (RIVISTI)

| Priority | Task | Status Codice | Status Deploy | Effort |
|----------|------|---------------|---------------|--------|
| **P0** | Test API (webhook, checkout) | 0% | - | 1 giorno |
| **P0** | Deploy API su Fly.io | 90% | 0% | 0.5 giorno |
| **P0** | npm publish CLI | 100% | 0% | 0.5 giorno |
| **P0** | npm publish MCP | 100% | 0% | 0.5 giorno |
| P1 | Test end-to-end flusso upgrade | 0% | - | 1 giorno |
| P2 | Sampling implementation | 0% | - | 3 giorni |
| P2 | Database production (non lowdb) | 0% | - | 2 giorni |
| P3 | Monitoring/alerting | 0% | - | 1 giorno |

**TOTALE per REALE:** ~10 giorni (NON 23, codice già scritto!)

---

## 5. ROADMAP IMPLEMENTAZIONE (Aggiornata Sessione 250)

> **NOTA:** Audit ha rivelato che Sprint 1-3 hanno CODICE completo
> ma mancano DEPLOY e TEST. Roadmap rivista per "REALE".

```
+================================================================+
|   SPRINT 1: BYOK POLISH - CODICE FATTO!                        |
+================================================================+
|   [x] API key validation con test call     (config/manager.ts) |
|   [x] Error messages user-friendly         (completato)        |
|   [x] Config persistenza (conf package)    (completato)        |
|   [x] cervellaswarm doctor command         (doctor.js)         |
|                                                                |
|   CODICE: 100% | DEPLOY: 0% (npm publish mancante!)            |
+================================================================+

+================================================================+
|   SPRINT 2: METERING & LIMITS - CODICE FATTO!                  |
+================================================================+
|   [x] Usage tracking (calls/month)         (billing/usage.ts)  |
|   [x] Tier limits enforcement              (billing/tiers.ts)  |
|   [x] Usage storage (local file)           (completato)        |
|   [x] Upgrade prompts when limit           (billing/messages)  |
|                                                                |
|   CODICE: 100% | DEPLOY: 0% (npm publish mancante!)            |
+================================================================+

+================================================================+
|   SPRINT 3: STRIPE INTEGRATION - CODICE FATTO!                 |
+================================================================+
|   [x] Stripe account setup                 (fatto)             |
|   [?] Product/price creation               (verificare Stripe) |
|   [x] Checkout flow                        (routes/checkout)   |
|   [x] Webhook handler                      (routes/webhooks)   |
|   [x] Billing command CLI                  (commands/billing)  |
|                                                                |
|   CODICE: 90% | DEPLOY: 0% (Fly.io + secrets mancanti!)        |
+================================================================+

+================================================================+
|   SPRINT 3.5: DEPLOY & TEST (NUOVO - BLOCCANTE!)               |
+================================================================+
|   [ ] Test API (webhook, checkout)         PRIORITA P0!        |
|   [ ] Deploy API su Fly.io                 fly deploy          |
|   [ ] Secrets Stripe su Fly.io             fly secrets set     |
|   [ ] npm publish CLI                      npm publish         |
|   [ ] npm publish MCP                      npm publish         |
|   [ ] Test end-to-end upgrade flow         REALE!              |
|                                                                |
|   GATE: Sistema funziona con utente REALE                      |
+================================================================+

+================================================================+
|   SPRINT 4: SAMPLING (dopo Sprint 3.5)                         |
+================================================================+
|   [ ] MCP Sampling implementation                               |
|   [ ] Dual-mode config                                          |
|   [ ] Auto mode selection                                       |
|   [ ] Fallback BYOK se sampling non disponibile                 |
|                                                                |
|   GATE: Entrambe modalita funzionano                           |
+================================================================+

+================================================================+
|   SPRINT 5: PRODUCTION-READY                                   |
+================================================================+
|   [ ] Database production (PostgreSQL/Turso, non lowdb)         |
|   [ ] Monitoring/alerting (Sentry/LogFlare)                     |
|   [ ] Documentation utente completa                             |
|   [ ] Security audit finale                                     |
|                                                                |
|   GATE: Score 9.5/10, REALE production-ready                   |
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
