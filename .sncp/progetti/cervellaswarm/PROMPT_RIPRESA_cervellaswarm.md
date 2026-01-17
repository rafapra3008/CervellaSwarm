# PROMPT RIPRESA - CervellaSwarm

> **Ultimo aggiornamento:** 17 Gennaio 2026 - Sessione 244
> **FASE ATTUALE:** Casa Pulita (prima di Sprint 4)

---

## SESSIONE 244 - RIFLESSIONE FAMIGLIA

### Cosa Abbiamo Fatto
1. **Test Stripe finale** - Rafa ha testato, 3 clienti totali (test mode)
2. **Studio organizzazione** - 4 report creati dalle Cervelle
3. **Decisioni prese** - Guardiana + Regina (non Rafa!)
4. **Quick Win** - Hook inutili disabilitati (-3100 tokens)

### Problema Trovato
```
SNCP Health Score: 5.8/10

- stato.md CervellaSwarm: 700 righe (limite 500!)
- 15+ file duplicati
- Context spreca ~15k tokens/sessione
- Hook fanno warning ma non bloccano
```

### Soluzione: SUBROADMAP CASA PULITA
```
FASE 1: Quick Win         [FATTO!]
FASE 2: Pulizia SNCP      [PROSSIMO]
FASE 3: Consolidare docs  [2-3 ore]
FASE 4: DNA Agents        [4 ore]
FASE 5: Automazione       [4-6 ore]

Obiettivo: 5.8 → 9.5 Health Score
```

---

## MAPPA SESSIONI

```
238: Sprint 1 BYOK COMPLETATO
 |
239: Sprint 2 Metering COMPLETATO
 |
240-242: Sprint 3 Stripe (problemi risolti)
 |
243: Sprint 3 TEST 360 COMPLETO!
 |
244: Test Stripe + Riflessione Famiglia  <-- OGGI
 |
245: Casa Pulita (Fase 2-3)
 |
246+: Sprint 4 Sampling Implementation
```

---

## ROADMAP PROGRAMMA

```
Sprint 1: BYOK Polish              [COMPLETATO]
Sprint 2: Metering & Limits        [COMPLETATO]
Sprint 3: Stripe Integration       [COMPLETATO!]

>>> PAUSA: Casa Pulita (1-2 sessioni) <<<

Sprint 4: Sampling Implementation  [DOPO Casa Pulita]
Sprint 5: Polish
```

---

## PROSSIMA SESSIONE (245)

### CASA PULITA - Fase 2
```
1. Compattare stato.md (700 → 280 righe)
2. Archiviare reports Miracollo > 7 giorni
3. Eliminare 8 duplicati VDA
4. Creare archivio/2026-01/
```

### Report da Consultare
- `.sncp/reports/analisi_ingegnera_organizzazione.md`
- `.sncp/reports/ricerca_best_practices_multi_agent.md`
- `.sncp/reports/analisi_context_inefficienze.md`
- `.sncp/decisioni/20260117_STANDARD_SNCP_FAMIGLIA.md`
- `.sncp/roadmaps/SUBROADMAP_CASA_PULITA.md`

---

## CONFIGURAZIONE STRIPE (riferimento)

```
Account: CervellaSwarm (acct_1SqEoCDcRzSMjFE4)
Pro:  $20/month | Team: $35/month
Webhook: https://cervellaswarm-api.fly.dev/webhooks/stripe
```

---

*"Prima sistemiamo casa, poi andiamo avanti!"*
