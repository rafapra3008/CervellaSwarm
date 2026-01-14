# REPORT: ML Fixes + Training - Sessione 203

**Data:** 14 Gennaio 2026
**Worker:** Regina (orchestrazione) + cervella-backend
**Progetto:** Miracollo

---

## EXECUTIVE SUMMARY

```
+================================================================+
|                                                                |
|   FIX CRITICI ML + PRIMO MODELLO TRAINATO!                     |
|                                                                |
|   Bug fixati:                                                  |
|   1. Filename mismatch (model_hotel_X vs hotel_X_model)        |
|   2. pickle vs joblib incompatibility                          |
|                                                                |
|   Training completato:                                         |
|   - 15,245 samples                                             |
|   - R2 Score: 0.383                                            |
|   - CV R2: 0.361 (+/- 0.061)                                   |
|                                                                |
+================================================================+
```

---

## BUG 1: Filename Mismatch

### Problema
```
confidence_scorer.py cercava:
  - hotel_{id}_model.pkl
  - hotel_{id}_scaler.pkl

model_trainer.py salvava:
  - model_hotel_{id}.pkl
  - scaler_hotel_{id}.pkl

RISULTATO: Model non trovato -> fallback 50.0 sempre!
```

### Fix
```python
# confidence_scorer.py - righe 66-67, 88-89
# PRIMA:
model_path = MODELS_DIR / f"hotel_{hotel_id}_model.pkl"
# DOPO:
model_path = MODELS_DIR / f"model_hotel_{hotel_id}.pkl"
```

---

## BUG 2: pickle vs joblib

### Problema
```
model_trainer.py: joblib.dump(model, path)
confidence_scorer.py: pickle.load(f)

ERRORE: invalid load key, '\x07'
```

### Fix
```python
# confidence_scorer.py - riga 27
# PRIMA:
import pickle
# DOPO:
import joblib

# righe 91-93
# PRIMA:
with open(model_path, 'rb') as f:
    model = pickle.load(f)
# DOPO:
model = joblib.load(model_path)
```

---

## TRAINING RISULTATI

```
Hotel ID:        1
Samples:         15,245
Train/Test:      12,196 / 3,049 (80/20 split)
Features:        36 (dopo one-hot encoding)

METRICHE:
  R2 Score:      0.383
  MAE:           0.52
  RMSE:          0.60
  CV R2:         0.361 (+/- 0.061)

TOP 5 FEATURES:
  1. is_weekend        24.3%
  2. day_of_week       20.7%
  3. tipo_prezzo       15.6%
  4. days_to_arrival   13.7%
  5. day_of_week_6.0   10.0%

FILES CREATI:
  - backend/ml/models/model_hotel_1.pkl
  - backend/ml/models/scaler_hotel_1.pkl
  - backend/ml/models/metadata_hotel_1.json
```

---

## ISSUE APERTA: Variance Pipeline

### Problema Attuale
```
get_model_variance_confidence() costruisce manualmente 6 features:
  - old_price, new_price, sconto_percent
  - days_to_arrival, occupancy_at_change, adr_at_change

Ma il modello richiede 36 features (one-hot encoded + derived)

RISULTATO: Variance confidence usa fallback 50.0
```

### Impatto
```
PRIMA (pre-fix):
  Total Confidence = 50.0 (tutto fallback)

DOPO (post-fix):
  Total Confidence = 67.0%
    - Variance:   50.0% (fallback - da refactorare)
    - Acceptance: 100.0% (REALE!)
    - Quality:    60.0% (REALE!)

MIGLIORAMENTO: 2 su 3 componenti ora usano dati REALI!
```

### TODO Future
```
[ ] Refactoring get_model_variance_confidence() per usare
    prepare_features() + get_feature_matrix() dal pipeline
[ ] Richiede: stay_date, change_date nel suggestion_data
[ ] Effort stimato: 4-6 ore
```

---

## FILES MODIFICATI

```
miracollogeminifocus/backend/ml/
├── confidence_scorer.py  (MODIFICATO - fix filename + joblib)
└── models/
    ├── model_hotel_1.pkl     (NUOVO - trained model)
    ├── scaler_hotel_1.pkl    (NUOVO - feature scaler)
    └── metadata_hotel_1.json (NUOVO - training metadata)
```

---

## PROSSIMI STEP

```
QUICK:
[ ] Test confidence in produzione
[ ] Verificare log di fallback ridotti

MEDIUM:
[ ] Refactoring variance pipeline
[ ] Aggiungere re-training schedulato (settimanale?)

LATER:
[ ] Hyperparameter tuning (n_estimators, max_depth)
[ ] Feature selection (rimuovere features poco importanti)
```

---

*"Fatto BENE > Fatto VELOCE"*
*"Una cosa alla volta, fino al 100000%!"*

*Report creato: 14 Gennaio 2026 - Sessione 203*
