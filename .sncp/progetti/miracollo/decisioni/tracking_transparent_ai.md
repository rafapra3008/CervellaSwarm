# Decisione: Tracking Transparent AI

**Data:** 12 Gennaio 2026
**Decisore:** Cervella Backend
**Contesto:** Misurare l'impatto della trasparenza AI sulle decisioni utente

---

## Il Problema

Abbiamo implementato Transparent AI (confidence breakdown, explanation, demand curve, narrative), ma NON sappiamo se funziona davvero:

- Gli utenti guardano le spiegazioni?
- Cambiano le loro decisioni?
- La trasparenza aumenta l'acceptance rate?

Senza dati, stiamo investendo in feature "su carta", non "reali".

---

## La Soluzione

### 1. Database Schema

**Due tabelle:**

1. `ai_explanation_interactions` - Traccia ogni vista explanation
2. `ai_decision_tracking` - Traccia decisioni correlate

**Privacy-first:**
- No PII
- Solo aggregati
- User_id opzionale (future)

### 2. API Endpoints

**Tracking:**
- `POST /api/analytics/ai-interaction` - Traccia vista explanation
- `POST /api/analytics/ai-decision` - Traccia decisione

**Analytics:**
- `GET /api/analytics/ai-transparency-report` - Report impatto

### 3. Metriche Misurate

**Engagement:**
- Quanti vedono explanations? (%)
- Quali explanation più viste?

**Impact:**
- Acceptance rate WITH explanation vs WITHOUT
- Time to decision WITH vs WITHOUT
- Correlazione confidence score → acceptance

**Insights automatici:**
- "Explanations boost acceptance by 27% points"
- "Users decide 64% faster with explanations"

---

## Perché È REALE

1. **Misurabile** - Numeri concreti, non sensazioni
2. **Actionable** - Sappiamo dove migliorare
3. **Privacy-safe** - No PII, solo aggregati
4. **Non-blocking** - Se tracking fallisce, UI continua

---

## File Creati

| File | Cosa |
|------|------|
| `migrations/037_ai_transparency_tracking.sql` | Schema database |
| `database/apply_037.py` | Script apply migration |
| `routers/ai_transparency.py` | API endpoints (270 righe) |
| `docs/AI_TRANSPARENCY_TRACKING.md` | Integration guide completa |

**Modificati:**
- `routers/__init__.py` - Export router
- `main.py` - Mount router (40 routers totali ora)

---

## Frontend Integration (da fare)

**Quando:**
- Tooltip confidence apre → `trackInteraction('viewed_confidence_breakdown')`
- "?" cliccato → `trackInteraction('viewed_explanation')`
- Demand curve vista → `trackInteraction('viewed_demand_curve')`
- Decisione presa → `trackDecision(action, timeElapsed, viewedExplanations)`

**Esempio React:**
```jsx
const handleAction = async (action) => {
    const timeToDecision = (Date.now() - viewStartTime) / 1000;

    await trackDecision({
        suggestion_id: suggestion.id,
        action_taken: action,
        time_to_decision: timeToDecision,
        had_viewed_explanation: viewedExplanations.length > 0,
        explanation_types_viewed: viewedExplanations
    });
};
```

**Documentazione completa:** `backend/docs/AI_TRANSPARENCY_TRACKING.md`

---

## Test API

```bash
# Apply migration
python backend/database/apply_037.py

# Track interaction
curl -X POST http://localhost:8001/api/analytics/ai-interaction \
  -H "Content-Type: application/json" \
  -d '{"hotel_id": 1, "suggestion_id": "test_001",
       "interaction_type": "viewed_confidence_breakdown"}'

# Get report
curl http://localhost:8001/api/analytics/ai-transparency-report?hotel_id=1&days=30
```

---

## Prossimi Step

1. **Applica migration** - `python backend/database/apply_037.py`
2. **Integra frontend** - Add tracking hooks in RateBoard
3. **Monitora 7 giorni** - Raccogli dati
4. **Analizza report** - Decisioni basate su dati REALI

---

## Impatto Atteso

**Scenario conservativo:**
- 30% utenti vedono explanations
- +10% acceptance rate con explanations
- Decisioni 20% più veloci

**Scenario ottimistico:**
- 60% utenti vedono explanations
- +25% acceptance rate
- Decisioni 50% più veloci

**Dopo 30 giorni sapremo quale scenario è REALE.**

---

**Status:** Backend READY
**Next:** Frontend integration + Data collection
**Owner:** Cervella Backend → Cervella Frontend

---

*"Misura l'impatto. Non assumere. Sapere."*
