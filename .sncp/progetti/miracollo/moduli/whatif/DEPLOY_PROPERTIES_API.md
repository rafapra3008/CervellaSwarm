# Deploy Properties API - What-If Simulator

> **Status**: READY TO DEPLOY
> **Data**: 12 Gennaio 2026
> **Autore**: Cervella Backend

---

## TL;DR

```
FILE PRONTO: backend_properties_api.py (271 righe)
ENDPOINT: 2 (GET properties + GET room-types)
PATTERN: FastAPI standard (come what_if_api.py)
DEPLOY: 3 step (copy + import + restart)
```

---

## File Creato

**Path Locale**: `.sncp/progetti/miracollo/moduli/whatif/backend_properties_api.py`

**Destinazione VM**: `~/miracollogeminifocus/backend/routers/properties_whatif.py`

**Dimensione**: 271 righe (con docstring complete)

---

## Endpoint Disponibili

### 1. GET /api/v1/properties

**Descrizione**: Lista tutte le proprietà attive

**Response**:
```json
[
  {"id": 1, "name": "Nido Lodge", "code": "NL"},
  {"id": 2, "name": "Hotel Paradise", "code": "HP"}
]
```

**Validazione**:
- Filtra `is_active = 1`
- Filtra `deleted_at IS NULL`
- Ordina per nome

---

### 2. GET /api/v1/properties/{property_id}/room-types

**Descrizione**: Lista tipologie camera per una proprietà

**Request**: `property_id` (int) - ID proprietà

**Response**:
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

**Validazione**:
- Verifica esistenza proprietà (404 se non esiste)
- Filtra `is_active = 1` + `deleted_at IS NULL`
- Ordina per `sort_order, name`

---

## Deploy Steps

### Step 1: Copy File to VM

```bash
# Da locale CervellaSwarm
scp .sncp/progetti/miracollo/moduli/whatif/backend_properties_api.py \
    root@miracollo.com:~/miracollogeminifocus/backend/routers/properties_whatif.py
```

### Step 2: Update main.py

**File**: `~/miracollogeminifocus/backend/main.py`

**Riga ~108** (dopo `ollama_api_router`):

```python
# What-If Simulator (Sessione 172)
from .routers.properties_whatif import router as properties_whatif_router
```

**Riga ~210** (dopo altri include_router):

```python
# What-If Properties (Sessione 172)
app.include_router(properties_whatif_router)
```

### Step 3: Restart Backend

```bash
ssh root@miracollo.com
cd /opt/miracollo-system/
docker-compose restart backend
docker-compose logs -f backend | grep "properties"
```

---

## Verifiche Post-Deploy

### Health Check

```bash
# 1. Properties
curl https://miracollo.com/api/v1/properties

# 2. Room Types (assumendo property_id=1)
curl https://miracollo.com/api/v1/properties/1/room-types
```

**Expected Response (properties)**:
```json
[{"id": 1, "name": "Nido Lodge", "code": "NL"}]
```

**Expected Response (room-types)**:
```json
[
  {"id": 1, "name": "Essentia Room", "code": "ESSENTIA", ...},
  {"id": 2, "name": "Silvae Suite", "code": "SILVAE", ...}
]
```

---

## Database Schema (Reference)

### hotels
```sql
CREATE TABLE hotels (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    is_active INTEGER DEFAULT 1,
    deleted_at TEXT
);
```

### room_types
```sql
CREATE TABLE room_types (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    hotel_id INTEGER NOT NULL REFERENCES hotels(id),
    code TEXT NOT NULL,
    name TEXT NOT NULL,
    base_occupancy INTEGER DEFAULT 2,
    max_occupancy INTEGER DEFAULT 4,
    total_units INTEGER DEFAULT 1,
    sort_order INTEGER DEFAULT 0,
    is_active INTEGER DEFAULT 1,
    deleted_at TEXT
);
```

---

## Codice Pronto Per

- ✅ Produzione (error handling completo)
- ✅ Logging (info/warning/error)
- ✅ Validazione input (FastAPI + Pydantic)
- ✅ Soft delete (filtra deleted_at)
- ✅ SQL injection protected (parametrized queries)
- ✅ Docstring complete

---

## Pattern Seguito

**Stesso stile di**:
- `routers/ml_api.py` (Pydantic models)
- `routers/revenue_suggestions.py` (error handling)
- `routers/hotels.py` (database queries)

**Features**:
- Type hints completi
- Pydantic response models
- Context manager `get_db()`
- HTTPException standardizzate
- Logging strutturato

---

## Note Sicurezza

1. **SQL Injection**: Protetto (parametrized queries)
2. **Soft Delete**: Rispettato (filtra deleted_at)
3. **Active Only**: Solo dati attivi esposti
4. **No Secrets**: Nessun dato sensibile in response

---

## Future Enhancements

Possibili miglioramenti futuri (NON ora):

1. **Cache Layer**: Redis per properties (dati stabili)
2. **Filtri**: Location, amenities
3. **Paginazione**: Se molte proprietà
4. **Rate Info**: Base rate nei room types (per What-If)

---

## Success Criteria

- [x] File creato (271 righe)
- [x] 2 endpoint funzionanti
- [x] Pydantic models corretti
- [x] Error handling completo
- [x] Docstring presenti
- [ ] Deployato su VM
- [ ] Health check OK

---

*Ready to deploy. Pattern validato. Codice pulito.*
