# STUDIO: Stripe Integration per SaaS CLI Tool

> **Ricerca:** Cervella Researcher
> **Data:** 16 Gennaio 2026
> **Progetto:** CervellaSwarm Sprint 3
> **Contesto:** Tool CLI MCP con tier Free/Pro/Team già implementato

---

## TL;DR

✅ **Pattern raccomandato:** Checkout Session + Customer Portal + Webhook sync
✅ **Architettura:** Local-first con sync periodico via API
✅ **Libreria:** `stripe` (stripe-node) v15+ con TypeScript
✅ **5 webhook essenziali** per subscription lifecycle
⚠️ **Gotcha critico:** Webhook signature verification con raw body

**Stima complessità:** Media (3-5 giorni Sprint 3)

---

## 1. STRIPE SUBSCRIPTIONS BEST PRACTICES 2026

### 1.1 Scelta Implementazione: Checkout Session (Raccomandato)

**Opzioni disponibili:**

| Approccio | Pro | Contro | Per CervellaSwarm |
|-----------|-----|--------|-------------------|
| **Checkout Session** | Hosted, sicuro, gestisce tax/compliance | Redirect esterno | ✅ **RACCOMANDATO** |
| Payment Links | No-code, veloce | Meno flessibile | Alternativa rapida |
| Embedded Checkout | UX integrata | Richiede frontend complesso | ❌ Overkill per CLI |

**Decisione:** Checkout Session perché:
- CLI tool → può aprire browser con URL
- Zero frontend da mantenere
- Tax/compliance automatico
- 38% recovery rate involuntary churn (Smart Retries)

### 1.2 Customer Portal (Self-Service)

✅ **Obbligatorio implementare subito** - non optional!

**Cosa offre:**
- Update payment method
- Upgrade/downgrade piano
- Cancel subscription
- Download invoices
- Update billing info

**Setup:** No-code tramite Dashboard Stripe + API per creare session

```typescript
const session = await stripe.billingPortal.sessions.create({
  customer: customerId,
  return_url: 'https://cervellaswarm.com/account',
});
// Apri session.url nel browser
```

**Configurazione Dashboard:**
- Abilitare invoice history
- Abilitare upgrade/downgrade (max 10 prodotti)
- Abilitare cancellation con feedback
- Configurare retention coupons

### 1.3 Webhook Essenziali

**5 eventi da gestire OBBLIGATORIAMENTE:**

| Evento | Quando | Azione |
|--------|--------|--------|
| `checkout.session.completed` | Pagamento completato | Salvare customer_id + subscription_id + tier |
| `invoice.paid` | Billing cycle OK | Refresh access, reset quota mensile |
| `invoice.payment_failed` | Pagamento fallito | Notifica user + downgrade a Free |
| `customer.subscription.updated` | Upgrade/downgrade | Update tier locale |
| `customer.subscription.deleted` | Cancellazione | Downgrade a Free |

**Eventi secondari (nice-to-have):**
- `payment_method.attached/detached` - Sync metodo pagamento
- `customer.updated` - Sync billing info

**CRITICO:** Stripe NON garantisce ordine eventi! Gestire con timestamp.

---

## 2. PATTERN PER CLI/MCP TOOL (Local-First)

### 2.1 Architettura Raccomandata

```
┌─────────────────────────────────────────────────────────────┐
│  CLI Tool (Local)                                            │
│                                                              │
│  config.json:                                                │
│    - customerId: "cus_xxx"                                   │
│    - tier: "pro"                                             │
│    - subscriptionId: "sub_xxx"                               │
│    - lastSync: 1705401234                                    │
│    - quotaCached: 500                                        │
│                                                              │
│  Logica:                                                     │
│  1. Check tier locale (immediato)                            │
│  2. Se online: sync ogni 24h o su richiesta                  │
│  3. Cache tier per offline                                   │
│  4. Fallback graceful se API fail                            │
└─────────────────────────────────────────────────────────────┘
                         ↕ (Sync periodico)
┌─────────────────────────────────────────────────────────────┐
│  Backend Mini (Webhook Listener)                             │
│                                                              │
│  Endpoints:                                                  │
│  - POST /webhooks/stripe (riceve eventi)                     │
│  - GET /api/subscription/:customerId (verifica tier)         │
│                                                              │
│  Storage:                                                    │
│  - DB minimale: customerId → tier mapping                    │
│    (può essere Redis, SQLite, Postgres)                      │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Flow Implementazione CLI

**A. Primo Setup (comando `cervellaswarm upgrade`):**

```bash
$ cervellaswarm upgrade pro

> Apertura browser per checkout...
> Stripe Checkout Session: https://checkout.stripe.com/...
> [User completa pagamento]
> ✅ Upgrade completato! Tier: PRO (500 calls/mo)
```

**Dietro le quinte:**
1. CLI chiama endpoint backend: `POST /api/create-checkout-session`
2. Backend crea Checkout Session con `client_reference_id` (user email/ID)
3. CLI apre URL nel browser (`open` su macOS, `xdg-open` Linux, `start` Windows)
4. User completa pagamento
5. Webhook `checkout.session.completed` → backend salva tier
6. CLI poller verifica stato ogni 2s (max 5 min) → rileva upgrade → aggiorna config locale

**B. Verifica Tier (ogni chiamata agent):**

```typescript
async function checkTier(): Promise<Tier> {
  // 1. Leggi config locale (immediato)
  const localTier = config.get('tier') as Tier;
  const lastSync = config.get('lastSync') as number;

  // 2. Se sync recente (< 24h), usa cache
  if (Date.now() - lastSync < 24 * 60 * 60 * 1000) {
    return localTier;
  }

  // 3. Sync con backend
  try {
    const customerId = config.get('customerId');
    const response = await fetch(`${API_URL}/api/subscription/${customerId}`);
    const { tier } = await response.json();

    // Aggiorna cache locale
    config.set('tier', tier);
    config.set('lastSync', Date.now());

    return tier;
  } catch (error) {
    // 4. Fallback: usa tier locale se API fail
    console.warn('Stripe API unavailable, using cached tier');
    return localTier;
  }
}
```

**C. Customer Portal (comando `cervellaswarm billing`):**

```bash
$ cervellaswarm billing

> Apertura Customer Portal...
> https://billing.stripe.com/p/session/...
```

### 2.3 Caching Strategy

**Obiettivo:** Tool funziona offline, sync quando possibile.

```typescript
interface StripeCache {
  customerId: string;
  tier: Tier;  // 'free' | 'pro' | 'team'
  subscriptionId?: string;
  lastSync: number;  // timestamp
  quotaLimit: number;  // da TIER_LIMITS
}
```

**Regole:**
- Cache valida per 24h
- Refresh a ogni `cervellaswarm upgrade/billing`
- Refresh su API error 402 (payment required)
- Fallback graceful: se API fail, usa cache (con warning)

**Edge case:**
- User cancella sub su portal → webhook aggiorna DB → prossimo sync CLI rileva downgrade
- CLI offline per 3+ giorni → continua a usare cache (UX > accuratezza)

---

## 3. IMPLEMENTAZIONE MINIMA MA ROBUSTA

### 3.1 Backend Endpoints (Minimo Necessario)

**Tecnologie raccomandate:**
- Node.js + Express (già familiarità)
- TypeScript (type safety con Stripe)
- Hosting: Vercel/Railway/Fly.io (webhook support)

**File structure:**

```
backend/
├── src/
│   ├── routes/
│   │   ├── checkout.ts      # POST /api/create-checkout-session
│   │   ├── portal.ts         # POST /api/create-portal-session
│   │   ├── subscription.ts   # GET /api/subscription/:customerId
│   │   └── webhooks.ts       # POST /webhooks/stripe
│   ├── db/
│   │   └── index.ts          # customerId → tier mapping
│   └── index.ts
├── package.json
└── tsconfig.json
```

**Endpoint 1: Create Checkout Session**

```typescript
// routes/checkout.ts
import Stripe from 'stripe';
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

app.post('/api/create-checkout-session', async (req, res) => {
  const { tier, userEmail } = req.body;  // tier: 'pro' | 'team'

  // Mapping tier → Stripe Price ID
  const priceIds = {
    pro: process.env.STRIPE_PRICE_PRO!,    // price_xxx (creato in Dashboard)
    team: process.env.STRIPE_PRICE_TEAM!,
  };

  const session = await stripe.checkout.sessions.create({
    mode: 'subscription',
    payment_method_types: ['card'],
    line_items: [{
      price: priceIds[tier],
      quantity: 1,
    }],
    success_url: `${process.env.FRONTEND_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
    cancel_url: `${process.env.FRONTEND_URL}/cancel`,
    customer_email: userEmail,
    client_reference_id: userEmail,  // Per identificare user nel webhook
    metadata: {
      tier,  // Utile nel webhook
    },
  });

  res.json({ url: session.url });
});
```

**Endpoint 2: Create Portal Session**

```typescript
// routes/portal.ts
app.post('/api/create-portal-session', async (req, res) => {
  const { customerId } = req.body;

  const session = await stripe.billingPortal.sessions.create({
    customer: customerId,
    return_url: `${process.env.FRONTEND_URL}/account`,
  });

  res.json({ url: session.url });
});
```

**Endpoint 3: Get Subscription Status**

```typescript
// routes/subscription.ts
app.get('/api/subscription/:customerId', async (req, res) => {
  const { customerId } = req.params;

  // Leggi da DB (cache webhook)
  const subscription = await db.getSubscription(customerId);

  if (!subscription) {
    return res.json({ tier: 'free' });
  }

  res.json({
    tier: subscription.tier,
    status: subscription.status,
    currentPeriodEnd: subscription.currentPeriodEnd,
  });
});
```

**Endpoint 4: Webhook Handler**

```typescript
// routes/webhooks.ts
import Stripe from 'stripe';
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

app.post('/webhooks/stripe',
  express.raw({ type: 'application/json' }),  // RAW BODY!
  async (req, res) => {
    const sig = req.headers['stripe-signature']!;
    const endpointSecret = process.env.STRIPE_WEBHOOK_SECRET!;

    let event: Stripe.Event;

    // 1. Verifica signature (CRITICO!)
    try {
      event = stripe.webhooks.constructEvent(
        req.body,  // DEVE essere raw, non parsed JSON!
        sig,
        endpointSecret
      );
    } catch (err) {
      console.error('Webhook signature verification failed', err);
      return res.status(400).send('Invalid signature');
    }

    // 2. Gestisci evento
    switch (event.type) {
      case 'checkout.session.completed': {
        const session = event.data.object as Stripe.Checkout.Session;
        await handleCheckoutCompleted(session);
        break;
      }

      case 'invoice.paid': {
        const invoice = event.data.object as Stripe.Invoice;
        await handleInvoicePaid(invoice);
        break;
      }

      case 'invoice.payment_failed': {
        const invoice = event.data.object as Stripe.Invoice;
        await handlePaymentFailed(invoice);
        break;
      }

      case 'customer.subscription.updated': {
        const subscription = event.data.object as Stripe.Subscription;
        await handleSubscriptionUpdated(subscription);
        break;
      }

      case 'customer.subscription.deleted': {
        const subscription = event.data.object as Stripe.Subscription;
        await handleSubscriptionDeleted(subscription);
        break;
      }

      default:
        console.log(`Unhandled event type: ${event.type}`);
    }

    res.json({ received: true });
  }
);

// Handler functions
async function handleCheckoutCompleted(session: Stripe.Checkout.Session) {
  const customerId = session.customer as string;
  const subscriptionId = session.subscription as string;
  const tier = session.metadata?.tier || 'pro';

  // Salva in DB
  await db.saveSubscription({
    customerId,
    subscriptionId,
    tier,
    status: 'active',
    email: session.customer_email!,
  });
}

async function handleInvoicePaid(invoice: Stripe.Invoice) {
  const customerId = invoice.customer as string;

  // Refresh tier (potrebbe essere upgrade)
  await db.updateSubscriptionStatus(customerId, 'active');
}

async function handlePaymentFailed(invoice: Stripe.Invoice) {
  const customerId = invoice.customer as string;

  // Downgrade a free dopo N tentativi falliti
  await db.updateSubscriptionStatus(customerId, 'past_due');

  // Opzionale: invia email notifica
}

async function handleSubscriptionUpdated(subscription: Stripe.Subscription) {
  const customerId = subscription.customer as string;

  // Rileva nuovo tier da subscription.items
  const priceId = subscription.items.data[0].price.id;
  const tier = mapPriceIdToTier(priceId);

  await db.updateSubscription(customerId, {
    tier,
    status: subscription.status,
  });
}

async function handleSubscriptionDeleted(subscription: Stripe.Subscription) {
  const customerId = subscription.customer as string;

  // Downgrade a free
  await db.updateSubscription(customerId, {
    tier: 'free',
    status: 'canceled',
  });
}
```

### 3.2 Database Schema (Minimale)

**Opzione 1: SQLite (Locale al backend)**

```sql
CREATE TABLE subscriptions (
  customer_id TEXT PRIMARY KEY,
  subscription_id TEXT,
  tier TEXT NOT NULL,  -- 'free' | 'pro' | 'team'
  status TEXT NOT NULL,  -- 'active' | 'past_due' | 'canceled'
  email TEXT NOT NULL,
  current_period_end INTEGER,
  created_at INTEGER,
  updated_at INTEGER
);

CREATE INDEX idx_email ON subscriptions(email);
```

**Opzione 2: Redis (Se preferisci key-value)**

```typescript
// Key: `subscription:${customerId}`
// Value: JSON stringificato
interface SubscriptionData {
  customerId: string;
  subscriptionId: string;
  tier: Tier;
  status: string;
  email: string;
  currentPeriodEnd: number;
}
```

### 3.3 CLI Integration

**Aggiungere comandi:**

```typescript
// packages/mcp-server/src/cli.ts
import { Command } from 'commander';
import open from 'open';  // npm install open

program
  .command('upgrade <tier>')
  .description('Upgrade to Pro or Team tier')
  .action(async (tier: 'pro' | 'team') => {
    const email = config.get('email') || await promptEmail();

    // 1. Crea checkout session
    const response = await fetch(`${API_URL}/api/create-checkout-session`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ tier, userEmail: email }),
    });

    const { url } = await response.json();

    // 2. Apri browser
    console.log('Opening checkout page...');
    await open(url);

    // 3. Poll per verificare completamento (opzionale)
    console.log('Waiting for payment confirmation...');
    await pollPaymentStatus(email);
  });

program
  .command('billing')
  .description('Manage billing and subscription')
  .action(async () => {
    const customerId = config.get('customerId');

    if (!customerId) {
      console.error('No active subscription found');
      process.exit(1);
    }

    // 1. Crea portal session
    const response = await fetch(`${API_URL}/api/create-portal-session`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ customerId }),
    });

    const { url } = await response.json();

    // 2. Apri browser
    console.log('Opening billing portal...');
    await open(url);
  });
```

---

## 4. SECURITY CONSIDERATIONS

### 4.1 Webhook Signature Verification (CRITICO!)

⚠️ **Errore comune #1:** Parse JSON body prima di verificare signature.

**CORRETTO:**

```typescript
// Express setup
app.use(express.json());  // DEFAULT per tutti gli endpoint

// ECCEZIONE: webhook DEVE ricevere raw body
app.post('/webhooks/stripe',
  express.raw({ type: 'application/json' }),  // Override!
  webhookHandler
);
```

**Spiegazione:** `stripe.webhooks.constructEvent()` richiede raw body string per calcolare signature. Se usi body parsed (JSON object), la signature NON match → 400 error.

### 4.2 Customer ID Storage

**Dove salvare `customerId`:**

| Opzione | Pro | Contro | Raccomandato |
|---------|-----|--------|--------------|
| Config locale | Veloce, offline | Nessuna validazione | ✅ Per CLI |
| Backend JWT | Sicuro | Richiede auth complessa | ❌ Overkill |
| Keychain/Credential Manager | Sicuro, OS-level | Implementazione complessa | 🤔 Nice-to-have v2 |

**Per Sprint 3:** Salva in config locale (`.cervellaswarm/config.json`). È sufficiente perché:
- CustomerId non è segreto (è un identifier, non credential)
- API key Stripe è server-side (sicura)
- Worst case: user modifica customerId → API verifica e fallisce

### 4.3 Test Mode vs Live Mode

**Setup:**

```typescript
// .env
STRIPE_SECRET_KEY=sk_test_xxx  # Test mode
STRIPE_WEBHOOK_SECRET=whsec_xxx  # Test webhook secret

# Live mode (dopo test)
STRIPE_SECRET_KEY_LIVE=sk_live_xxx
STRIPE_WEBHOOK_SECRET_LIVE=whsec_xxx
```

**Workflow:**
1. Sprint 3: Implementa con test mode
2. Crea prodotti/prices reali in Dashboard
3. Test con `stripe trigger` CLI
4. Switch a live mode solo dopo test completi

**Test webhook locally:**

```bash
# Terminal 1: Forward webhook a localhost
stripe listen --forward-to localhost:3000/webhooks/stripe

# Terminal 2: Trigger evento test
stripe trigger checkout.session.completed
```

### 4.4 API Key Management

**CLI side:**

```typescript
// packages/mcp-server/src/config/stripe.ts
export const STRIPE_API_URL = process.env.STRIPE_API_URL || 'https://api.cervellaswarm.com';

// MAI hardcodare API key nel client!
// CLI comunica solo con nostro backend, che usa Stripe API
```

**Backend side:**

```typescript
// backend/.env
STRIPE_SECRET_KEY=sk_test_xxx  # NEVER commit!
STRIPE_WEBHOOK_SECRET=whsec_xxx

# In production: usa environment variables del hosting provider
```

---

## 5. GOTCHAS E ERRORI COMUNI

### 5.1 Webhook Signature Fail

**Problema:** `Webhook signature verification failed`

**Cause:**
1. Body parsed (JSON) invece di raw ✅ **PIÙ COMUNE**
2. Webhook secret errato
3. Replay attack (evento già processato)

**Fix:**

```typescript
// SBAGLIATO
app.use(express.json());  // Applica a TUTTI gli endpoint
app.post('/webhooks/stripe', webhookHandler);  // Body già parsed!

// CORRETTO
app.post('/webhooks/stripe',
  express.raw({ type: 'application/json' }),  // Override!
  webhookHandler
);
app.use(express.json());  // Dopo webhook route
```

### 5.2 Eventi Out-of-Order

**Problema:** `customer.subscription.updated` arriva PRIMA di `checkout.session.completed`

**Causa:** Stripe NON garantisce ordine eventi.

**Fix:**

```typescript
// Usa timestamp per determinare evento più recente
async function handleSubscriptionUpdated(subscription: Stripe.Subscription) {
  const existing = await db.getSubscription(subscription.customer);

  if (existing && existing.updated_at > subscription.created) {
    console.log('Ignoring outdated event');
    return;
  }

  await db.updateSubscription(subscription.customer, {
    tier: mapPriceIdToTier(subscription.items.data[0].price.id),
    updated_at: subscription.created,
  });
}
```

### 5.3 Multiple Price IDs per Tier

**Problema:** Hai creato price_pro_v1, price_pro_v2 → quale mappare a 'pro'?

**Soluzione:** Usa metadata Stripe

```typescript
// Quando crei Price in Dashboard/API
const price = await stripe.prices.create({
  unit_amount: 2000,
  currency: 'usd',
  recurring: { interval: 'month' },
  product: 'prod_xxx',
  metadata: {
    tier: 'pro',  // Usa questo per mapping!
  },
});

// Nel webhook
function mapPriceIdToTier(price: Stripe.Price): Tier {
  return price.metadata?.tier as Tier || 'free';
}
```

### 5.4 Test Mode Payment Methods

**Per testing:**

| Card Number | Outcome |
|-------------|---------|
| 4242 4242 4242 4242 | Success |
| 4000 0000 0000 9995 | Decline |
| 4000 0000 0000 0341 | Requires authentication (3D Secure) |

**Più info:** https://stripe.com/docs/testing

### 5.5 HTTPS Required per Webhook

**Problema:** `localhost` non riceve webhook in live mode

**Soluzioni:**

1. **Development:** Usa Stripe CLI forward
   ```bash
   stripe listen --forward-to localhost:3000/webhooks/stripe
   ```

2. **Staging:** Deploy su Vercel/Railway con HTTPS
   - Webhook URL: `https://api-staging.cervellaswarm.com/webhooks/stripe`

3. **Production:** HTTPS obbligatorio (TLS 1.2+)

---

## 6. CODICE/LIBRERIE RACCOMANDATE

### 6.1 Dipendenze Node.js/TypeScript

```json
{
  "dependencies": {
    "stripe": "^15.0.0",
    "express": "^4.18.2",
    "dotenv": "^16.0.3",
    "open": "^10.0.3"
  },
  "devDependencies": {
    "@types/express": "^4.17.17",
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0"
  }
}
```

### 6.2 Snippet Utili

**Initialize Stripe Client:**

```typescript
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-12-18.acacia',  // Latest stable
  typescript: true,
});
```

**Polling Payment Status:**

```typescript
async function pollPaymentStatus(email: string, maxAttempts = 60) {
  for (let i = 0; i < maxAttempts; i++) {
    await new Promise(resolve => setTimeout(resolve, 2000));  // 2s

    const response = await fetch(`${API_URL}/api/subscription/by-email/${email}`);
    const data = await response.json();

    if (data.tier !== 'free') {
      console.log(`✅ Upgrade confirmed! Tier: ${data.tier.toUpperCase()}`);

      // Aggiorna config locale
      config.set('customerId', data.customerId);
      config.set('tier', data.tier);
      config.set('lastSync', Date.now());

      return true;
    }
  }

  console.error('⏱️ Payment timeout. Check your email for confirmation.');
  return false;
}
```

**Error Handling:**

```typescript
try {
  const session = await stripe.checkout.sessions.create({ ... });
} catch (error) {
  if (error instanceof Stripe.errors.StripeError) {
    console.error('Stripe error:', error.message);
    console.error('Type:', error.type);
    console.error('Code:', error.code);
  }
  throw error;
}
```

### 6.3 Testing Setup

```typescript
// tests/stripe.test.ts
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_TEST_KEY!, {
  apiVersion: '2024-12-18.acacia',
});

describe('Stripe Integration', () => {
  it('creates checkout session', async () => {
    const session = await stripe.checkout.sessions.create({
      mode: 'subscription',
      line_items: [{ price: 'price_test_xxx', quantity: 1 }],
      success_url: 'http://localhost:3000/success',
      cancel_url: 'http://localhost:3000/cancel',
    });

    expect(session.url).toBeDefined();
    expect(session.mode).toBe('subscription');
  });

  it('verifies webhook signature', () => {
    const payload = JSON.stringify({ type: 'checkout.session.completed' });
    const signature = stripe.webhooks.generateTestHeaderString({
      payload,
      secret: process.env.STRIPE_WEBHOOK_SECRET!,
    });

    const event = stripe.webhooks.constructEvent(
      payload,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET!
    );

    expect(event.type).toBe('checkout.session.completed');
  });
});
```

---

## 7. STEP NECESSARI PER SPRINT 3

### Checklist Implementazione

**FASE 1: Setup Stripe (1 giorno)**

- [ ] Crea account Stripe (se non esiste)
- [ ] Crea prodotti in Dashboard:
  - [ ] Product: "CervellaSwarm Pro" → Price: $20/month
  - [ ] Product: "CervellaSwarm Team" → Price: $35/month
- [ ] Aggiungi metadata `tier: 'pro'/'team'` ai Price
- [ ] Ottieni API keys (test mode):
  - [ ] Secret key: `sk_test_xxx`
  - [ ] Publishable key: `pk_test_xxx` (non serve per CLI)
- [ ] Configura Customer Portal in Dashboard:
  - [ ] Abilita invoice history
  - [ ] Abilita plan switching (Pro ↔ Team)
  - [ ] Abilita cancellation con feedback

**FASE 2: Backend (2 giorni)**

- [ ] Setup progetto Express + TypeScript
- [ ] Installa dipendenze (`stripe`, `express`, `dotenv`)
- [ ] Implementa endpoint:
  - [ ] `POST /api/create-checkout-session`
  - [ ] `POST /api/create-portal-session`
  - [ ] `GET /api/subscription/:customerId`
  - [ ] `POST /webhooks/stripe` (con signature verification)
- [ ] Setup database (SQLite/Redis)
- [ ] Implementa webhook handlers (5 eventi essenziali)
- [ ] Test localmente con `stripe listen --forward`
- [ ] Deploy su Vercel/Railway/Fly.io

**FASE 3: CLI Integration (1 giorno)**

- [ ] Aggiungi comandi:
  - [ ] `cervellaswarm upgrade <tier>`
  - [ ] `cervellaswarm billing`
- [ ] Implementa polling payment status
- [ ] Integra con `config.ts` esistente:
  - [ ] Salva `customerId`, `tier`, `subscriptionId`
- [ ] Update `checkTier()` con sync periodico
- [ ] Test flow completo:
  - [ ] Free → Pro upgrade
  - [ ] Pro → Team upgrade
  - [ ] Portal cancellation

**FASE 4: Testing (0.5 giorni)**

- [ ] Test checkout flow con card test
- [ ] Test webhook events con `stripe trigger`
- [ ] Test offline fallback (API down)
- [ ] Test edge cases:
  - [ ] Duplicate webhook events
  - [ ] Out-of-order events
  - [ ] Payment failure

**FASE 5: Documentation (0.5 giorni)**

- [ ] Aggiorna README con billing commands
- [ ] Documenta webhook setup
- [ ] Aggiungi troubleshooting guide

**Totale:** ~5 giorni (Sprint 3)

---

## 8. RACCOMANDAZIONE FINALE

### ✅ Approccio Raccomandato

```
ARCHITETTURA:
- Frontend: Checkout Session (hosted Stripe)
- Backend: Mini Express + 4 endpoint + 5 webhook handlers
- CLI: Comandi upgrade/billing + sync periodico
- Storage: SQLite (minimo) o Redis (se preferisci)
- Cache: Config locale con fallback graceful

IMPLEMENTAZIONE:
1. Sprint 3 Focus: Test mode completo
2. Database minimo: customerId → tier mapping
3. Webhook: 5 eventi essenziali (non tutti subito)
4. Security: Signature verification + HTTPS
5. UX: Offline-first con sync intelligente
```

### ⚠️ Gotchas da Evitare

1. ❌ Webhook body parsed → signature fail
2. ❌ Assumere ordine eventi → race condition
3. ❌ Hardcodare Price ID → usa metadata
4. ❌ Nessun fallback → API down = CLI bloccato
5. ❌ Test mode su localhost → usa Stripe CLI forward

### 📊 Confidenza Implementazione

| Aspetto | Confidenza | Note |
|---------|------------|------|
| Pattern generale | 9/10 | Consolidato, best practice Stripe 2026 |
| CLI integration | 8/10 | Polling status può essere migliorato |
| Security | 9/10 | Webhook verification ben documentato |
| Offline fallback | 7/10 | Richiede testing edge cases |
| Complessità | 6/10 | Media - gestibile in Sprint 3 |

### 🎯 Prossimi Step Suggeriti

1. **Immediate:** Setup Stripe account + crea Products/Prices
2. **Day 1-2:** Backend webhook listener + deploy staging
3. **Day 3-4:** CLI commands + integration
4. **Day 5:** Testing + polish

**Obiettivo Sprint 3:** Utente può fare upgrade Pro/Team e verificare tier funziona! 🚀

---

## FONTI

### Documentazione Ufficiale Stripe
- [Build a subscriptions integration](https://stripe.com/docs/billing/subscriptions/build-subscriptions)
- [Integrate a SaaS business on Stripe](https://docs.stripe.com/saas)
- [Using webhooks with subscriptions](https://docs.stripe.com/billing/subscriptions/webhooks)
- [Customer Portal integration](https://docs.stripe.com/customer-management/integrate-customer-portal)
- [Webhook signature verification](https://docs.stripe.com/webhooks/signature)
- [Set up and deploy a webhook](https://docs.stripe.com/webhooks/quickstart?lang=node)

### Best Practices & Guides
- [Best practices for SaaS billing](https://stripe.com/resources/more/best-practices-for-saas-billing)
- [Self-serve subscription management](https://stripe.com/resources/more/self-serve-subscription-management-and-billing-portals)
- [How to Securely Handle Stripe Webhooks - CheatCode](https://cheatcode.co/blog/how-to-securely-handle-stripe-webhooks)

### Implementation Examples
- [Stripe Node.js library GitHub](https://github.com/stripe/stripe-node)
- [Stripe Subscription Integration Node.js 2024 Guide](https://dev.to/ivanivanovv/stripe-subscription-integration-in-nodejs-2024-ultimate-guide-2ba3)
- [Create billing portal and checkout in Node.js - Medium](https://medium.com/@anitha_s/how-to-create-a-billing-portal-session-and-checkout-session-in-stripe-using-node-js-39eb8ba67757)

### Authentication & Caching Patterns
- [Azure CLI token management](https://mikhail.io/2019/07/how-azure-cli-manages-access-tokens/)
- [MSAL token caching - Microsoft](https://learn.microsoft.com/en-us/entra/identity-platform/msal-acquire-cache-tokens)

### Testing
- [Testing Stripe Billing](https://docs.stripe.com/billing/testing)
- [Stripe CLI Reference](https://docs.stripe.com/cli)

---

**Fine Studio - Ready per Sprint 3!** 🔬✅
