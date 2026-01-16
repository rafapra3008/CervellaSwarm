# PROMPT RIPRESA - CervellaSwarm

> **Ultimo aggiornamento:** 16 Gennaio 2026 - Sessione 240
> **FASE ATTUALE:** Sprint 3 Stripe IN CORSO (70% fatto!)

---

## SESSIONE 240 - SPRINT 3 STRIPE

```
+================================================================+
|   COMPLETATO (70%)                                              |
|                                                                |
|   packages/api/ (Backend Fly.io) - NUOVO!                      |
|   ├── src/index.ts              Express server                 |
|   ├── src/routes/checkout.ts    POST create-checkout-session   |
|   ├── src/routes/portal.ts      POST create-portal-session     |
|   ├── src/routes/subscription.ts GET subscription status       |
|   ├── src/routes/webhooks.ts    5 webhook handlers             |
|   ├── src/db/index.ts           JSON database (lowdb)          |
|   ├── Dockerfile                Multi-stage build              |
|   └── fly.toml                  Frankfurt region               |
|                                                                |
|   packages/cli/ (Comandi billing)                              |
|   ├── src/commands/upgrade.js   cervellaswarm upgrade pro/team |
|   ├── src/commands/billing.js   cervellaswarm billing          |
|   └── src/config/manager.js     +tier, customerId, email       |
|                                                                |
|   BUILD: OK (api + cli)                                        |
+================================================================+
```

---

## DA FARE (30%) - Sessione 241

```
1. STRIPE DASHBOARD (con Rafa)
   - Creare Product "CervellaSwarm Pro" → $20/month
   - Creare Product "CervellaSwarm Team" → $35/month
   - Copiare Price IDs (price_xxx)
   - Rafa ha bisogno di aiuto!

2. DEPLOY FLY.IO
   - fly auth login
   - fly launch (nel folder packages/api)
   - fly secrets set STRIPE_SECRET_KEY=sk_test_xxx
   - fly secrets set STRIPE_WEBHOOK_SECRET=whsec_xxx
   - fly secrets set STRIPE_PRICE_PRO=price_xxx
   - fly secrets set STRIPE_PRICE_TEAM=price_xxx

3. TEST END-TO-END
   - cervellaswarm upgrade pro → apre checkout
   - Pagamento test (4242 4242 4242 4242)
   - Webhook ricevuto → tier aggiornato
```

---

## ROADMAP AGGIORNATA

```
Sprint 1: BYOK Polish              [COMPLETATO] Sessione 238
Sprint 2: Metering & Limits        [COMPLETATO] Sessione 239
Sprint 3: Stripe Integration       [70%] Sessione 240-241
Sprint 4: Sampling Implementation  [PROSSIMO]
Sprint 5: Polish

Score attuale: ~5/10 -> Target: 9.5/10
```

---

## MAPPA SESSIONI

```
237: MCP funziona + Dual-Mode + Freemium
 |
238: Sprint 1 BYOK Polish COMPLETATO
 |
239: Sprint 2 Metering COMPLETATO + Context Guard discovery
 |
240: Sprint 3 Stripe IN CORSO (backend + CLI pronti)  <-- OGGI!
 |
241: Sprint 3 Stripe COMPLETAMENTO (Stripe Dashboard + Deploy)
```

---

## TL;DR

**Sessione 240:** Backend API + CLI commands PRONTI. Manca solo Stripe Dashboard + Deploy.

**Prossimo (241):** Aiutare Rafa con Stripe, Deploy Fly.io, Test e2e.

*"Un progresso al giorno = 365 progressi all'anno!"*
