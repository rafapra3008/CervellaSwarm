# RICERCA BUSINESS MODEL: CervellaSwarm

> **Autore:** cervella-marketing
> **Data:** 2 Gennaio 2026
> **Tipo:** Ricerca Business - Pricing, Go-to-Market, Posizionamento

---

## EXECUTIVE SUMMARY

### MODELLO RACCOMANDATO: Freemium + Tiered Pricing

| Tier | Prezzo | Target | Margine |
|------|--------|--------|---------|
| FREE | $0 | Acquisizione, community | 100% (BYOK) |
| PRO | $29.99/mese | Freelancer, indie dev | 50-60% |
| BUSINESS | $79.99/mese | Agenzie, team | 45-55% |
| ENTERPRISE | $499+/mese | Corp, regulated | 40-50% |

### Revenue Projection (Conservativo)

- **Anno 1:** $67,000 ARR
- **Anno 2:** $455,000 ARR
- **Anno 3:** $1.2M+ ARR (se traction)

---

## 1. COMPETITOR PRICING ANALYSIS

### 1.1 AI Coding Tools

| Tool | Free Tier | Pro | Enterprise | Model |
|------|-----------|-----|------------|-------|
| **GitHub Copilot** | No | $10/mese | $19/mese | Seat-based |
| **Cursor** | 2000 completions | $20/mese | Custom | Usage + Seat |
| **Tabnine** | Basic | $12/mese | Custom | Seat-based |
| **Codeium** | Unlimited | $10/mese | Custom | Freemium |
| **Claude Code** | Incluso Max | $20/mese | Custom | Bundled |

**Insight:** Il range $10-20/mese e' lo standard. $29.99 per multi-agent orchestration e' giustificabile.

### 1.2 Multi-Agent Frameworks

| Framework | Pricing | Model | Note |
|-----------|---------|-------|------|
| **LangSmith** | Free + $39/mese | Usage-based | Tracing/debug |
| **CrewAI** | Open source | Self-hosted | No SaaS |
| **AutoGen** | Open source | Self-hosted | No SaaS |

**Insight:** Nessun competitor diretto con pricing SaaS per multi-agent. Campo aperto!

### 1.3 Developer Tools SaaS

| Tool | Free | Pro | Enterprise |
|------|------|-----|------------|
| **Vercel** | Hobby | $20/mese | Custom |
| **Supabase** | Free tier | $25/mese | Custom |
| **PlanetScale** | Free tier | $29/mese | Custom |
| **Railway** | $5 crediti | $20/mese | Custom |

**Pattern:** Free tier generoso → $20-30 Pro → Custom Enterprise

---

## 2. PRICING PSYCHOLOGY

### 2.1 Perche' $29.99 e non $30

```
PRICING PSYCHOLOGY:

$30.00 → Percepito come "trenta dollari"
$29.99 → Percepito come "venti e qualcosa"

Effetto: +8-15% conversioni con charm pricing (.99)

Ma attenzione:
- B2B senior: $30 piu' professionale
- Freelancer: $29.99 piu' attraente

RACCOMANDAZIONE: $29.99 per PRO (B2C focus)
                 $79.99 per BUSINESS
                 $499 per ENTERPRISE (round number = serio)
```

### 2.2 Anchoring

```
STRATEGIA ANCHORING:

Mostra PRIMA il tier piu' costoso:

┌────────────────────────────────────────────────────────┐
│                                                        │
│  ENTERPRISE        BUSINESS         PRO        FREE   │
│  $499/mo           $79.99/mo        $29.99/mo  $0     │
│  ████████          ██████           ████       ██     │
│                                                        │
│                         ↑                              │
│                    MOST POPULAR                        │
│                                                        │
└────────────────────────────────────────────────────────┘

Effetto: PRO sembra "economico" rispetto a ENTERPRISE
```

### 2.3 Annual Discount

```
MONTHLY vs ANNUAL:

PRO Monthly:  $29.99/mese
PRO Annual:   $24.99/mese ($299.88/anno)

Savings: 17% (2 mesi gratis)

Effetto:
- Aumenta LTV (lock-in 12 mesi)
- Cash flow upfront
- Riduce churn
```

---

## 3. PROPOSTA TIER CERVELLASWARM

### 3.1 FREE Tier

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   FREE TIER - "STARTER"                                         ║
║   Prezzo: $0 (per sempre)                                       ║
║                                                                  ║
║   INCLUDE:                                                       ║
║   ├── 4 agent base                                              ║
║   │   ├── cervella-frontend                                     ║
║   │   ├── cervella-backend                                      ║
║   │   ├── cervella-tester                                       ║
║   │   └── cervella-reviewer                                     ║
║   ├── 50 orchestrazioni/mese                                    ║
║   ├── Memoria locale (no sync)                                  ║
║   ├── Community support (GitHub)                                ║
║   └── BYOK obbligatorio                                         ║
║                                                                  ║
║   NON INCLUDE:                                                   ║
║   ├── Guardiane                                                  ║
║   ├── Agent specializzati                                       ║
║   ├── Memory sync cross-device                                  ║
║   └── Priority support                                          ║
║                                                                  ║
║   TARGET: Studenti, hobbyist, early adopter                     ║
║   GOAL: Acquisizione, community building, word-of-mouth         ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

### 3.2 PRO Tier

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   PRO TIER - "PROFESSIONAL"                        MOST POPULAR ║
║   Prezzo: $29.99/mese ($24.99 annual)                           ║
║                                                                  ║
║   TUTTO IN FREE, PIU':                                          ║
║   ├── Tutti 16 agent                                            ║
║   │   ├── 11 Worker (Sonnet)                                    ║
║   │   └── 3 Guardiane (Opus) ← KEY DIFFERENTIATOR              ║
║   ├── Orchestrazioni illimitate                                 ║
║   ├── Sistema memoria completo                                  ║
║   │   ├── Lesson learning                                       ║
║   │   ├── Pattern detection                                     ║
║   │   └── Analytics dashboard                                   ║
║   ├── Memory sync cross-device                                  ║
║   ├── Email support (48h response)                              ║
║   ├── Monthly tips & tricks newsletter                          ║
║   └── BYOK incluso (o API wrapper option)                       ║
║                                                                  ║
║   TARGET: Freelancer, indie developer, small startup            ║
║   GOAL: Core revenue, product-market fit validation             ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

### 3.3 BUSINESS Tier

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   BUSINESS TIER - "AGENCY"                                      ║
║   Prezzo: $79.99/mese ($69.99 annual)                           ║
║                                                                  ║
║   TUTTO IN PRO, PIU':                                           ║
║   ├── Multi-project workspace                                   ║
║   │   ├── Fino a 10 progetti attivi                            ║
║   │   ├── Cross-project memory                                  ║
║   │   └── Project templates                                     ║
║   ├── Team collaboration (fino a 5 seats)                       ║
║   │   ├── Shared agent configs                                  ║
║   │   ├── Team lessons learned                                  ║
║   │   └── Activity dashboard                                    ║
║   ├── Custom agent training                                     ║
║   │   ├── Fine-tune su codebase                                ║
║   │   └── Domain-specific prompts                               ║
║   ├── Priority support (24h response)                           ║
║   ├── Quarterly strategy call (30 min)                          ║
║   └── Early access nuove features                               ║
║                                                                  ║
║   TARGET: Web agency, software house, dev team                  ║
║   GOAL: High-value customers, case studies                      ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

### 3.4 ENTERPRISE Tier

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   ENTERPRISE TIER - "CORPORATE"                                 ║
║   Prezzo: Custom (starting $499/mese)                           ║
║                                                                  ║
║   TUTTO IN BUSINESS, PIU':                                      ║
║   ├── Unlimited seats                                           ║
║   ├── Self-hosted deployment option                             ║
║   │   ├── On-premise                                            ║
║   │   ├── Private cloud                                         ║
║   │   └── Air-gapped environment                                ║
║   ├── Compliance pack                                           ║
║   │   ├── SOC 2 Type II                                         ║
║   │   ├── HIPAA (healthcare)                                    ║
║   │   ├── GDPR (EU)                                             ║
║   │   └── Audit logs                                            ║
║   ├── SSO/SAML integration                                      ║
║   ├── API wrapper option (noi paghiamo Anthropic)               ║
║   ├── Dedicated account manager                                 ║
║   ├── SLA guarantee (99.9% uptime)                              ║
║   ├── Custom development (10h/quarter incluse)                  ║
║   └── Executive sponsor access                                  ║
║                                                                  ║
║   TARGET: Fortune 500, regulated industries, enterprise         ║
║   GOAL: High-ticket sales, validation, case studies             ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 4. REVENUE MODELING

### 4.1 Assumptions

```
CONVERSION FUNNEL:

Awareness (visit site): 10,000/mese (dopo 6 mesi)
          ↓ 30%
Sign-up FREE: 3,000
          ↓ 5%
Convert to PRO: 150
          ↓ 10%
Upgrade to BUSINESS: 15
          ↓ 5%
Enterprise inquiry: 1

CHURN:
- PRO: 5%/mese
- BUSINESS: 3%/mese
- ENTERPRISE: 1%/mese
```

### 4.2 Scenario Conservativo

```
ANNO 1 - CONSERVATIVO:

Mese 1-3 (Launch):
├── FREE: 500
├── PRO: 20 × $29.99 = $600/mese
├── BUSINESS: 2 × $79.99 = $160/mese
└── MRR: $760

Mese 4-6 (Growth):
├── FREE: 1,500
├── PRO: 60 × $29.99 = $1,800/mese
├── BUSINESS: 5 × $79.99 = $400/mese
└── MRR: $2,200

Mese 7-12 (Scale):
├── FREE: 4,000
├── PRO: 150 × $29.99 = $4,500/mese
├── BUSINESS: 15 × $79.99 = $1,200/mese
├── ENTERPRISE: 1 × $499 = $499/mese
└── MRR: $6,199

ANNO 1 TOTALE: ~$40,000 ARR (conservativo)
               ~$67,000 ARR (con growth Q4)
```

### 4.3 Scenario Realistico

```
ANNO 2 - REALISTICO:

Mese 13-18:
├── FREE: 10,000
├── PRO: 400 × $29.99 = $12,000/mese
├── BUSINESS: 40 × $79.99 = $3,200/mese
├── ENTERPRISE: 3 × $499 = $1,500/mese
└── MRR: $16,700

Mese 19-24:
├── FREE: 25,000
├── PRO: 800 × $29.99 = $24,000/mese
├── BUSINESS: 80 × $79.99 = $6,400/mese
├── ENTERPRISE: 8 × $499 = $4,000/mese
└── MRR: $34,400

ANNO 2 TOTALE: ~$300,000 - $455,000 ARR
```

### 4.4 Scenario Ambizioso

```
ANNO 3 - AMBIZIOSO (se traction):

├── FREE: 100,000+
├── PRO: 3,000 × $29.99 = $90,000/mese
├── BUSINESS: 300 × $79.99 = $24,000/mese
├── ENTERPRISE: 30 × $800 (avg) = $24,000/mese
└── MRR: $138,000

ANNO 3 TOTALE: ~$1.2M - $1.6M ARR
```

---

## 5. GO-TO-MARKET STRATEGY

### 5.1 Fase 1: Pre-Launch (Settimane 1-4)

```
OBIETTIVO: Waitlist 1,000 sign-up

AZIONI:
├── Landing page live
├── "Coming Soon" video (2 min)
├── Twitter/X account attivo
├── LinkedIn personal branding (Rafa)
├── Dev.to articolo "Building a Multi-Agent Swarm"
└── Discord community (invite-only)

BUDGET: $0 (sweat equity)

KPI:
├── Waitlist: 1,000
├── Twitter followers: 500
├── Discord members: 200
└── Email open rate: 40%+
```

### 5.2 Fase 2: Launch (Settimane 5-8)

```
OBIETTIVO: 500 FREE users, 50 PRO conversions

AZIONI:
├── ProductHunt launch
│   ├── Prepare 1 settimana prima
│   ├── Mobilize community per upvotes
│   └── Target: Top 5 of the Day
├── Hacker News "Show HN" post
├── Reddit r/programming, r/coding
├── Dev.to launch article
└── YouTube demo video (5 min)

BUDGET: $0-500 (ProductHunt upgrade opzionale)

KPI:
├── ProductHunt: Top 5
├── FREE users: 500
├── PRO conversions: 50 (10% conversion)
├── MRR: $1,500+
└── First paying customer
```

### 5.3 Fase 3: Growth (Mesi 3-6)

```
OBIETTIVO: 2,000 FREE, 200 PRO, $6K MRR

AZIONI:
├── Content Marketing
│   ├── 2 blog post/settimana
│   ├── Case studies (3)
│   ├── Video tutorials (10)
│   └── Podcast appearances
├── SEO Long-tail
│   ├── "claude code multi agent"
│   ├── "freelancer ai orchestration"
│   └── "vscode ai agent plugin"
├── Community Building
│   ├── Discord active (daily)
│   ├── GitHub discussions
│   ├── Twitter engagement
│   └── User-generated content
└── Referral Program
    ├── Give 1 month free
    ├── Get 1 month free
    └── Target: 20% of growth from referrals

BUDGET: $500-1,000/mese

KPI:
├── FREE: 2,000
├── PRO: 200
├── BUSINESS: 20
├── MRR: $6,000+
└── NPS: 50+
```

### 5.4 Fase 4: Scale (Mesi 7-12)

```
OBIETTIVO: $15K+ MRR, first Enterprise

AZIONI:
├── Paid Acquisition (test)
│   ├── Google Ads (dev keywords)
│   ├── Twitter Ads
│   └── Sponsorships (newsletters)
├── Enterprise Sales
│   ├── Outbound (LinkedIn)
│   ├── Case studies
│   ├── SOC 2 preparation
│   └── First pilot program
├── Partnerships
│   ├── Claude Code official?
│   ├── Developer bootcamps
│   └── Agencies
└── Team Expansion
    ├── Part-time support
    └── Content contractor

BUDGET: $2,000-5,000/mese

KPI:
├── FREE: 5,000
├── PRO: 400
├── BUSINESS: 50
├── ENTERPRISE: 2
├── MRR: $15,000+
└── Runway: 12+ mesi
```

---

## 6. OPEN-CORE STRATEGY

### 6.1 Perche' Open Source Core

```
VANTAGGI OPEN SOURCE:

1. TRUST
   ├── Codice verificabile = fiducia
   ├── AI trust issues = transparency wins
   └── EU AI Act favorisce auditability

2. COMMUNITY
   ├── Contributi esterni (free development)
   ├── Bug reports piu' veloci
   └── Feature requests dal mercato

3. DISTRIBUTION
   ├── GitHub stars = social proof
   ├── npm/pip downloads = discoverability
   └── Fork = marketing gratuito

4. MOAT
   ├── Multi-project orchestration e' complesso
   ├── Difficile da replicare anche se open
   └── Execution > code
```

### 6.2 Cosa Open Source

```
OPEN SOURCE (MIT/Apache):
├── Agent definitions (16 file .md)
├── Orchestration engine base
├── CLI tool (cervellaswarm)
├── Memory schema (SQLite)
└── Basic analytics
```

### 6.3 Cosa Proprietary (Cloud)

```
PROPRIETARY (Paid):
├── Memory sync cross-device
├── Team dashboard
├── Advanced analytics
├── Compliance tools
├── Priority support
├── Enterprise features
└── Custom agent training
```

---

## 7. POSITIONING

### 7.1 Value Proposition

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   "ONE SWARM. ALL PROJECTS. FOREVER LEARNING."                  ║
║                                                                  ║
║   CervellaSwarm is the first multi-project AI orchestration     ║
║   system for Claude Code. Setup once, use everywhere, learn     ║
║   from every session.                                            ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

### 7.2 Differenziatori Chiave

| Differenziatore | Noi | Competitor |
|-----------------|-----|------------|
| Multi-project | ✅ Nativo | ❌ Single session |
| Memory system | ✅ Built-in | ❌ Add-on |
| Human-in-loop | ✅ Guardiane | ⚠️ Optional |
| Global agents | ✅ ~/.claude/ | ❌ Per-project |
| Lesson learning | ✅ Automatico | ❌ Manuale |

### 7.3 Tagline Options

```
OPZIONI:

1. "Your AI team, everywhere you code."
2. "One swarm. All projects. Forever learning."
3. "The multi-project AI orchestrator."
4. "AI agents that remember. And grow."
5. "From one Cervella to a whole swarm."
```

### 7.4 Target Persona

```
PRIMARY PERSONA: "Marco, the Freelance Developer"

├── Eta': 28-42
├── Ruolo: Freelancer / Solo developer
├── Progetti attivi: 3-8 simultanei
├── Pain: Context switching, setup ripetuto
├── Tool: VS Code, Claude, Git
├── Budget: $20-100/mese per tool
├── Goal: Piu' progetti, meno stress
└── Trigger: "Vorrei un team AI sempre disponibile"

SECONDARY PERSONA: "Anna, the Agency Lead"

├── Eta': 32-50
├── Ruolo: Tech lead / CTO small agency
├── Team: 3-10 developer
├── Pain: Consistenza, knowledge sharing
├── Tool: VS Code, CI/CD, project management
├── Budget: $500-2000/mese per team
├── Goal: Standardizzare, scalare
└── Trigger: "Come faccio a far lavorare tutti allo stesso modo?"
```

---

## 8. METRICS TO TRACK

### 8.1 North Star Metric

```
NORTH STAR: Monthly Active Orchestrations (MAO)

Definizione: Numero di orchestrazioni completate al mese
Target Anno 1: 10,000 MAO
Target Anno 2: 100,000 MAO

Perche':
├── Misura engagement reale
├── Correla con valore percepito
└── Leading indicator di retention
```

### 8.2 Key Metrics Dashboard

| Categoria | Metrica | Target M6 | Target Y1 |
|-----------|---------|-----------|-----------|
| **Acquisition** | Sign-ups | 500/mese | 1,000/mese |
| **Activation** | First orchestration | 60% | 70% |
| **Retention** | MAU | 40% | 50% |
| **Revenue** | MRR | $3,000 | $10,000 |
| **Referral** | Viral coeff. | 0.3 | 0.5 |

### 8.3 Unit Economics

```
TARGET UNIT ECONOMICS (Anno 2):

CAC (Customer Acquisition Cost): $50
LTV (Lifetime Value): $400 (PRO 14 mesi avg)
LTV/CAC Ratio: 8x (target >3x)

Monthly Churn: 5% PRO, 3% BUSINESS
Net Revenue Retention: 110%+ (upsells)
```

---

## 9. RISKS & MITIGATIONS

### 9.1 Market Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Anthropic releases similar | 20% | High | First-mover brand, community |
| Claude Code deprecated | 5% | Critical | Multi-platform support |
| Market saturation | 30% | Medium | Niche focus, differentiation |

### 9.2 Execution Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Solo founder burnout | 40% | High | Automate, delegate, pace |
| Tech debt | 30% | Medium | Clean code, tests |
| Support overload | 50% | Medium | Documentation, community |

### 9.3 Financial Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Slow growth | 40% | Medium | Iterate fast, pivot if needed |
| High churn | 30% | High | Focus on activation, value |
| API cost spike | 20% | Medium | BYOK model, optimize |

---

## 10. RACCOMANDAZIONE FINALE

### 10.1 GO/NO-GO Decision

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   RACCOMANDAZIONE: GO! 🚀                                       ║
║                                                                  ║
║   PERCHE':                                                       ║
║   ├── Mercato in esplosione ($10B+ 2026)                        ║
║   ├── Gap REALE (multi-project)                                 ║
║   ├── Abbiamo gia' 90% del prodotto                             ║
║   ├── Low risk (40-80 ore, no capital)                          ║
║   └── High optionality (bootstrap, fundraise, exit)             ║
║                                                                  ║
║   WORST CASE: Impari mercato, portfolio, $0                     ║
║   BEST CASE: $1M+ ARR anno 3, exit option                       ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

### 10.2 First 90 Days

```
MESE 1: Foundation
├── [ ] Decisione GO finale
├── [ ] Landing page + waitlist
├── [ ] Discord community
├── [ ] Twitter account
├── [ ] 5 blog post tecnici
└── [ ] MVP polish

MESE 2: Build in Public
├── [ ] Daily Twitter updates
├── [ ] Dev.to articles
├── [ ] Video tutorials (3)
├── [ ] Beta users (100)
└── [ ] Feedback integration

MESE 3: Launch
├── [ ] ProductHunt
├── [ ] Hacker News
├── [ ] Reddit
├── [ ] First 10 paying customers
└── [ ] MRR: $300+
```

---

## 11. FONTI

### Competitor Pricing
- [GitHub Copilot Pricing Guide 2026](https://userjot.com/blog/github-copilot-pricing-guide-2025)
- [Cursor AI Pricing](https://cursor.com/pricing)
- [Cursor vs Windsurf Comparison](https://ainativedev.io/news/cursor-new-pricing-structure-explained)
- [AI Coding Tools Comparison 2025](https://apidog.com/blog/top-ai-coding-tools-2025/)
- [AI Coding Assistant Pricing 2025](https://getdx.com/blog/ai-coding-assistant-pricing/)

### Pricing Psychology
- [The Psychology Of Pricing: Why 9.99 Works](https://underthewraps.medium.com/the-psychology-of-pricing-why-9-99-works-better-than-10-f8d0236bad2d)
- [The Power of Rounding in SaaS Pricing](https://www.getmonetizely.com/articles/the-power-of-rounding-why-99-vs-100-matters-in-saas-pricing-strategy)
- [Developer Tools SaaS Pricing Research](https://www.getmonetizely.com/articles/developer-tools-saas-pricing-research-optimizing-your-strategy-for-maximum-value)

### Go-to-Market
- [Everything About Devtools Marketing](https://draft.dev/learn/everything-ive-learned-about-devtools-marketing)
- [Go-to-Market Strategy for Developer Tools](https://mattermost.com/blog/go-to-market-strategy-for-developer-tools/)
- [How to Launch on Product Hunt](https://www.lennysnewsletter.com/p/how-to-successfully-launch-on-product)
- [Product Hunt Success Story](https://www.permit.io/blog/producthunt-howto)

### Market Data
- [AI Code Assistant Market Size](https://market.us/report/ai-code-assistant-market/)
- [Coding AI Market Share 2025](https://www.cbinsights.com/research/report/coding-ai-market-share-2025/)
- [Monetizing MCP Servers](https://www.moesif.com/blog/api-strategy/model-context-protocol/Monetizing-MCP-Model-Context-Protocol-Servers-With-Moesif/)

---

*"Numeri CONCRETI, strategie ACTIONABLE. Sempre."* 📈

**cervella-marketing**
