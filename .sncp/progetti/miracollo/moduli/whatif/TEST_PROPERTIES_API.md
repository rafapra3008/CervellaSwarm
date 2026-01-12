# Test Properties API - What-If Simulator

> **Data**: 12 Gennaio 2026
> **Tester**: Cervella Backend

---

## Test Plan

### 1. Syntax Check (Pre-Deploy)

```bash
# Verifica sintassi Python
cd /Users/rafapra/Developer/CervellaSwarm/.sncp/progetti/miracollo/moduli/whatif/
python3 -m py_compile backend_properties_api.py

# Expected: No output = OK
```

---

### 2. Import Check (Locale)

```python
# Test rapido in Python REPL
import sys
sys.path.append('/Users/rafapra/Developer/miracollogeminifocus/backend')

# Testa import base
from typing import List
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

# OK? → Sintassi valida
```

---

### 3. Endpoint Testing (Post-Deploy)

#### Test 1: GET /api/v1/properties

**Request**:
```bash
curl -X GET https://miracollo.com/api/v1/properties \
  -H "Accept: application/json"
```

**Expected Response** (200 OK):
```json
[
  {
    "id": 1,
    "name": "Nido Lodge",
    "code": "NL"
  }
]
```

**Test Cases**:
- ✅ Status 200
- ✅ Response è array JSON
- ✅ Ogni item ha `id`, `name`, `code`
- ✅ Solo proprietà attive
- ✅ Nessuna proprietà con `deleted_at` presente

---

#### Test 2: GET /api/v1/properties/{property_id}/room-types

**Request** (property_id esistente):
```bash
curl -X GET https://miracollo.com/api/v1/properties/1/room-types \
  -H "Accept: application/json"
```

**Expected Response** (200 OK):
```json
[
  {
    "id": 1,
    "name": "Essentia Room",
    "code": "ESSENTIA",
    "base_occupancy": 2,
    "max_occupancy": 4,
    "total_units": 8
  },
  {
    "id": 2,
    "name": "Silvae Suite",
    "code": "SILVAE",
    "base_occupancy": 2,
    "max_occupancy": 3,
    "total_units": 6
  }
]
```

**Test Cases**:
- ✅ Status 200
- ✅ Response è array JSON
- ✅ Ogni item ha tutti i campi richiesti
- ✅ Solo room types attivi
- ✅ Ordinati per `sort_order, name`

---

#### Test 3: Property Non Esistente

**Request**:
```bash
curl -X GET https://miracollo.com/api/v1/properties/99999/room-types \
  -H "Accept: application/json"
```

**Expected Response** (404 Not Found):
```json
{
  "detail": "Proprietà con ID 99999 non trovata o non attiva"
}
```

**Test Cases**:
- ✅ Status 404
- ✅ Error message chiaro
- ✅ Nessun crash backend

---

#### Test 4: Property Senza Room Types

**Setup**:
```sql
-- Assumiamo property_id=2 esista ma senza room_types
SELECT * FROM hotels WHERE id = 2;
SELECT * FROM room_types WHERE hotel_id = 2;  -- risultato vuoto
```

**Request**:
```bash
curl -X GET https://miracollo.com/api/v1/properties/2/room-types
```

**Expected Response** (200 OK):
```json
[]
```

**Test Cases**:
- ✅ Status 200 (NON 404!)
- ✅ Array vuoto (non errore)
- ✅ Warning nei log backend

---

### 4. Error Handling Tests

#### Test 5: Invalid Property ID (non-numeric)

**Request**:
```bash
curl -X GET https://miracollo.com/api/v1/properties/abc/room-types
```

**Expected Response** (422 Unprocessable Entity):
```json
{
  "detail": [
    {
      "loc": ["path", "property_id"],
      "msg": "value is not a valid integer",
      "type": "type_error.integer"
    }
  ]
}
```

**Test Cases**:
- ✅ Status 422 (FastAPI automatic validation)
- ✅ Error message chiaro

---

#### Test 6: Database Connection Error

**Scenario**: Database non disponibile

**Expected**:
- Status 500
- Error message generico (no DB details leakage)
- Log dettagliato su backend

---

### 5. Performance Tests

#### Test 7: Response Time

**Benchmark**:
```bash
# Properties endpoint
time curl https://miracollo.com/api/v1/properties

# Expected: < 200ms
```

**Acceptance**:
- ✅ < 200ms per properties
- ✅ < 300ms per room-types

---

#### Test 8: Concurrent Requests

```bash
# 10 richieste simultanee
for i in {1..10}; do
  curl https://miracollo.com/api/v1/properties &
done
wait

# Expected: Tutte 200 OK, nessun timeout
```

---

### 6. Integration Tests

#### Test 9: What-If Simulator Flow

**Scenario**: Frontend carica dropdown

1. Frontend chiama `/api/v1/properties`
2. User seleziona property_id=1
3. Frontend chiama `/api/v1/properties/1/room-types`
4. Dropdown popolati ✅

**Expected**:
- ✅ Nessun CORS error
- ✅ Response JSON valido
- ✅ Dati consistenti con DB

---

### 7. Logs Verification

**Dopo deploy, verifica logs**:

```bash
ssh root@miracollo.com
cd /opt/miracollo-system/
docker-compose logs backend | grep -i "properties"
```

**Expected logs**:
```
INFO  - Trovate 1 proprietà attive
INFO  - Trovate 5 tipologie camera per property 'Nido Lodge' (ID 1)
```

**Alert logs** (se problemi):
```
WARNING - Nessuna proprietà attiva trovata nel database
ERROR   - Errore nel recupero proprietà: <dettagli>
```

---

### 8. Security Tests

#### Test 10: SQL Injection Attempt

```bash
curl -X GET "https://miracollo.com/api/v1/properties/1' OR '1'='1/room-types"
```

**Expected**:
- ✅ 422 validation error (FastAPI blocca)
- ✅ Nessun impatto su DB

---

#### Test 11: CORS Policy

```bash
curl -X GET https://miracollo.com/api/v1/properties \
  -H "Origin: https://malicious-site.com" \
  -v
```

**Expected**:
- ✅ CORS headers presenti
- ✅ Solo origins autorizzati

---

## Test Matrix

| Test | Descrizione | Status | Priority |
|------|-------------|--------|----------|
| T1   | GET properties | ⏳ | HIGH |
| T2   | GET room-types (valid) | ⏳ | HIGH |
| T3   | Property non esistente (404) | ⏳ | HIGH |
| T4   | Property senza room-types | ⏳ | MEDIUM |
| T5   | Invalid property_id | ⏳ | MEDIUM |
| T6   | DB connection error | ⏳ | LOW |
| T7   | Response time | ⏳ | MEDIUM |
| T8   | Concurrent requests | ⏳ | LOW |
| T9   | Integration flow | ⏳ | HIGH |
| T10  | SQL injection | ⏳ | HIGH |
| T11  | CORS policy | ⏳ | MEDIUM |

---

## Acceptance Criteria

**PASS** se:
- ✅ Tutti i test HIGH priority passano
- ✅ Response time < 300ms
- ✅ Nessun crash backend
- ✅ Logs presenti e chiari
- ✅ Error handling corretto
- ✅ Security OK (no SQL injection)

**FAIL** se:
- ❌ 500 errors su richieste valide
- ❌ Response malformato
- ❌ CORS issues
- ❌ SQL injection possibile
- ❌ Memory leaks

---

## Post-Test Actions

### Se PASS:
1. ✅ Mark as DEPLOYED in stato.md
2. ✅ Update frontend What-If con nuovi endpoint
3. ✅ Monitor production logs (primo giorno)

### Se FAIL:
1. ❌ Rollback deployment
2. ❌ Fix issue identificato
3. ❌ Re-test locale
4. ❌ Re-deploy

---

*Test plan completo. Ready for QA.*
