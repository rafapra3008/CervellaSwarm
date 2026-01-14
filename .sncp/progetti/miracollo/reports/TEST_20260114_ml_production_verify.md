# TEST PLAN - ML Confidence Production Verification

**Status**: READY
**Data**: 2026-01-14
**Tester**: Cervella Tester
**Obiettivo**: Verificare se ML Confidence v1.1.0 è deployato in produzione

---

## CONTESTO

### ML Confidence v1.1.0
- **PRIMA**: 67.0% confidence (50.0% variance fallback)
- **DOPO**: 91.8% confidence (99.5% variance REALE!)
- **File**: `confidence_scorer.py` v1.1.0 (commit ec8e129)
- **Modello**: `models/model_hotel_1.pkl` trainato (R2: 0.383, 15,245 samples)

### Come Funziona
Confidence composta da 3 componenti:
1. **Model Variance** (50% peso): Da RandomForest trees variance
2. **Acceptance Rate** (30% peso): Storico suggerimenti accettati
3. **Data Quality** (20% peso): Numero samples training

---

## ENDPOINT DA TESTARE

### 1. Revenue Suggestions (Principale)
```bash
GET https://miracollo.com/api/revenue/suggestions?hotel_code=NL
```

**Cosa cercare:**
- Ogni suggerimento ha campo `confidence_score`
- Valore dovrebbe essere ~91.8 se ML v1.1.0 deployato
- Valore sarà ~67.0 se ancora vecchia versione
- Valore sarà 50.0 se ML fallisce (fallback)

**Risposta attesa:**
```json
{
  "suggestions": [
    {
      "id": "sugg_prezzo_abc123",
      "tipo": "prezzo",
      "confidence_score": 91.8,
      "confidence_level": "molto_alta",
      ...
    }
  ]
}
```

---

### 2. ML Model Info
```bash
GET https://miracollo.com/api/ml/model-info?hotel_id=1
```

**Cosa cercare:**
- Model version
- R2 score: dovrebbe essere ~0.383
- Samples: dovrebbe essere ~15,245
- Trained_at: recente (14 Gen 2026)

**Risposta attesa:**
```json
{
  "hotel_id": 1,
  "model_version": "v_xxx",
  "trained_at": "2026-01-14T...",
  "samples": {"total": 15245},
  "metrics": {"r2_score": 0.383}
}
```

---

### 3. ML Confidence Test (Direct)
```bash
POST https://miracollo.com/api/ml/confidence?hotel_id=1
Content-Type: application/json

{
  "tipo": "prezzo",
  "old_price": 100.0,
  "new_price": 85.0,
  "days_to_arrival": 15,
  "occupancy_at_change": 65.0,
  "adr_at_change": 95.0
}
```

**Cosa cercare:**
- Confidence: dovrebbe essere 80-95% se ML funziona
- Confidence: sarà ~50% se fallback attivo

**Risposta attesa:**
```json
{
  "hotel_id": 1,
  "tipo": "prezzo",
  "confidence": 91.8,
  "level": "VERY_HIGH"
}
```

---

### 4. ML Confidence Breakdown (Debug)
```bash
GET https://miracollo.com/api/ml/confidence-breakdown?hotel_id=1&suggestion_id=sugg_xxx
```

**Cosa cercare:**
- `components.prediction_variance.score`: dovrebbe essere ~99.5 (NON 50.0!)
- Se 50.0 = ancora fallback (ML non deployato)

**Risposta attesa:**
```json
{
  "total_confidence": 91.8,
  "components": {
    "prediction_variance": {
      "score": 99.5,
      "weight": 0.5,
      "contribution": 49.75
    },
    "acceptance_rate": {
      "score": 80.0,
      "weight": 0.3,
      "contribution": 24.0
    },
    "data_quality": {
      "score": 90.0,
      "weight": 0.2,
      "contribution": 18.0
    }
  }
}
```

---

## TEST ESISTENTI

### Unit Test
**File**: `backend/tests/test_confidence_scorer.py`
**Run**: `pytest backend/tests/test_confidence_scorer.py -v`

**Test coverage:**
- `test_calculate_confidence_basic()`
- `test_model_variance_from_r2()`
- `test_acceptance_rate_calculation()`
- `test_confidence_breakdown_structure()`

### Integration Test
**File**: `backend/test_suggestions.py`
**Run**: `python backend/test_suggestions.py`

**Output atteso:**
```
Confidence: 91.8% (molto_alta)  ← SE ML v1.1.0 deployato
Confidence: 67.0% (alta)        ← SE ancora vecchia versione
```

---

## COME VERIFICARE

### Opzione 1: Via API (NON richiede SSH)
```bash
# Test endpoint suggestions
curl https://miracollo.com/api/revenue/suggestions?hotel_code=NL \
  | jq '.suggestions[0].confidence_score'

# Expected: 91.8 (ML OK) o 67.0 (vecchia) o 50.0 (fallback)
```

### Opzione 2: Verifica File su VM (richiede SSH)
```bash
# Check file version
ssh vm
cat /app/miracollo/backend/ml/confidence_scorer.py | head -25

# Expected line 20:
__version__ = "1.1.0"

# Check modello exists
ls -lah /app/miracollo/backend/ml/models/model_hotel_1.pkl
```

### Opzione 3: Log Analysis
```bash
# Check log per "REAL, not fallback"
ssh vm
tail -f /app/miracollo/logs/app.log | grep "variance confidence"

# Expected:
# "confidence=91.8% (REAL, not fallback!)"
# NOT: "using fallback confidence"
```

---

## CRITERI SUCCESSO

| Criterio | Target | Come Verificare |
|----------|--------|-----------------|
| **Confidence Score** | 91.8% | API suggestions |
| **Variance Component** | 99.5% | API breakdown |
| **Model Exists** | True | API model-info |
| **No Fallback Log** | 0 occurrenze | Logs |
| **File Version** | v1.1.0 | SSH check |

---

## FAILURE MODES

| Symptom | Causa Probabile | Fix |
|---------|-----------------|-----|
| Confidence = 67.0% | File v1.0.0 deployato | Re-deploy v1.1.0 |
| Confidence = 50.0% | Model file mancante | Check models/ folder |
| Variance = 50.0% | Fallback attivo | Check logs per errori |
| API 404 /ml/* | Router non caricato | Check main.py imports |

---

## PROSSIMI STEP

SE ML NON DEPLOYATO:
1. Verificare commit ec8e129 in produzione
2. Verificare file `confidence_scorer.py` v1.1.0
3. Verificare presenza modello `models/model_hotel_1.pkl`
4. Re-deploy se necessario

SE ML DEPLOYATO:
1. Monitorare confidence medio nelle prossime 24h
2. Verificare feedback utenti
3. Celebrare +24.8 punti confidence!

---

**Fatto**: Lista endpoint + test + criteri
**Run**: `curl https://miracollo.com/api/revenue/suggestions?hotel_code=NL`
**Next**: Aspetto istruzioni da Regina per eseguire test

*"Se non è testato, non funziona!"*
*Cervella Tester - 14 Gennaio 2026*
