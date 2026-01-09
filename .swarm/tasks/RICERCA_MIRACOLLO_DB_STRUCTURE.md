# Ricerca: Struttura Dati Miracollo per Revenue Intelligence

**Data**: 2026-01-09
**Researcher**: Cervella Researcher
**Target**: Sistema Revenue Intelligence / Sistema Bucchi

---

## TL;DR

Miracollo ha GIA tutto per calcolare occupancy/RevPAR. Schema DB ben strutturato con:
- Tabelle `bookings`, `rooms`, `booking_rooms` per occupancy
- Tabella `daily_rates` per pricing dinamico
- Sistema `room_assignments` per segmenti multipli
- Rateboard con logica AI/pattern analysis GIA implementata

**Raccomandazione**: Integrare con sistema bucchi esistente, NON ricostruire da zero.

---

## 1. SCHEMA DATABASE - Tabelle Rilevanti

### 1.1 Rooms (Camere Fisiche)
```sql
CREATE TABLE rooms (
    id INTEGER PRIMARY KEY,
    hotel_id INTEGER,
    room_type_id INTEGER,
    room_number TEXT,
    floor INTEGER,
    housekeeping_status TEXT,  -- 'clean', 'dirty', 'cleaning', 'maintenance'
    is_active INTEGER DEFAULT 1
)
```

**Campo Chiave**: `is_active` per calcolo camere disponibili totali.

### 1.2 Bookings (Prenotazioni)
```sql
CREATE TABLE bookings (
    id INTEGER PRIMARY KEY,
    hotel_id INTEGER,
    booking_number TEXT,
    check_in_date TEXT,
    check_out_date TEXT,
    nights INTEGER,
    status TEXT,  -- 'confirmed', 'checked_in', 'checked_out', 'cancelled', 'no_show'
    total REAL,
    amount_paid REAL,
    amount_pending REAL,
    payment_status TEXT
)
```

**Campi Chiave**:
- `check_in_date` / `check_out_date` → range occupancy
- `status` → escludere 'cancelled', 'no_show'
- `total` → revenue per ADR/RevPAR

### 1.3 Booking_Rooms (Camere Prenotate)
```sql
CREATE TABLE booking_rooms (
    id INTEGER PRIMARY KEY,
    booking_id INTEGER,
    room_type_id INTEGER,
    room_id INTEGER,  -- Camera fisica assegnata
    rate_plan_id INTEGER,
    adults INTEGER,
    children INTEGER,
    rate_per_night REAL,
    total_room REAL
)
```

**Nota**: Una prenotazione può avere più camere (gruppi).

### 1.4 Room_Assignments (Segmenti - Cambio Camera)
```sql
CREATE TABLE room_assignments (
    id INTEGER PRIMARY KEY,
    booking_id INTEGER,
    room_id INTEGER,
    start_date TEXT,
    end_date TEXT,
    segment_order INTEGER,  -- 1, 2, 3... per cambi camera
    change_reason TEXT
)
```

**Importante**: Priorità su `booking_rooms` per calcolo occupancy!
Se esiste room_assignment, quella è la verità per quel range di date.

### 1.5 Daily_Rates (Matrice Prezzi)
```sql
CREATE TABLE daily_rates (
    id INTEGER PRIMARY KEY,
    hotel_id INTEGER,
    room_type_id INTEGER,
    rate_plan_id INTEGER,
    date TEXT,  -- YYYY-MM-DD
    price REAL,
    min_stay INTEGER,
    is_closed INTEGER  -- 0/1
)
```

**Index**: `(hotel_id, room_type_id, rate_plan_id, date)` per lookup rapido.

---

## 2. RATEBOARD ESISTENTE - Come Funziona

**Path**: `backend/routers/rateboard.py`

### 2.1 Endpoint Disponibili

| Endpoint | Funzione |
|----------|----------|
| `GET /api/rateboard/matrix/{year}/{month}` | Matrice prezzi mensile (heatmap) |
| `PUT /api/rateboard/bulk-update` | Aggiornamento massivo prezzi |
| `GET /api/rateboard/suggestions` | Suggerimenti AI (LOGICA REALE!) |
| `GET /api/rateboard/yoy/{date}` | Confronto Year-over-Year |
| `GET /api/rateboard/competitors` | Prezzi competitor |

### 2.2 Logica Calcolo Occupancy (GIA Implementata!)

**Funzione**: `calculate_daily_metrics()`
**Path**: `backend/routers/rateboard.py:415`

```python
def calculate_daily_metrics(conn, hotel_id: int, target_date: str, total_rooms: int):
    # Count bookings for this date
    cursor = conn.execute("""
        SELECT
            COUNT(*) as rooms_sold,
            COALESCE(SUM(total), 0) as revenue
        FROM bookings
        WHERE hotel_id = ?
          AND check_in_date <= ?
          AND check_out_date > ?
          AND status NOT IN ('cancelled', 'no_show')
    """, (hotel_id, target_date, target_date))

    row = cursor.fetchone()
    rooms_sold = row["rooms_sold"] or 0
    revenue = row["revenue"] or 0

    # Calculate metrics
    occupancy = round(rooms_sold / total_rooms * 100, 1)
    adr = round(revenue / rooms_sold, 2) if rooms_sold > 0 else 0
    revpar = round(revenue / total_rooms, 2)

    return {
        "occupancy": occupancy,
        "adr": adr,
        "revpar": revpar,
        "revenue": revenue,
        "rooms_sold": rooms_sold
    }
```

**Metriche Calcolate**:
- **Occupancy** = rooms_sold / total_rooms * 100
- **ADR** (Average Daily Rate) = revenue / rooms_sold
- **RevPAR** (Revenue per Available Room) = revenue / total_rooms

### 2.3 Sistema AI Suggestions (Sprint 3.7d - REALE!)

**Path**: `backend/services/rateboard_ai.py` (presumibilmente)

Basato su:
- Storico prenotazioni (pattern giorno settimana/mese)
- Eventi speciali (calendario italiano)
- Confronto YoY (delta significativi)
- Pattern weekend vs feriali

**Confidence Score**: Basato su quantità dati storici (data_points >= 30).

---

## 3. LOGICA DISPONIBILITA (Booking Engine)

**Path**: `backend/routers/public/helpers.py:74`

### 3.1 Funzione `get_room_availability()`

**Logica**:
1. Get tutti room_types attivi
2. Get camere fisiche per room_type
3. Get camere già prenotate nel periodo → `booked_room_ids`
4. Conta camere disponibili = total - booked
5. Get daily_rates per calcolo prezzi
6. Return lista room_types con available_count e rates

**Query Camere Prenotate**:
```sql
SELECT DISTINCT r.room_id
FROM bookings b
JOIN booking_rooms r ON b.id = r.booking_id
WHERE b.hotel_id = ?
  AND b.check_in_date < ?
  AND b.check_out_date > ?
  AND b.status NOT IN ('cancelled', 'no_show')
  AND r.room_id IS NOT NULL
```

**Nota**: Check anche `room_assignments` per prenotazioni con cambio camera!

---

## 4. MODELLI PYTHON ESISTENTI

**Path**: `backend/models/`

### 4.1 Room Models
```python
class RoomType(BaseModel):
    id: int
    hotel_id: int
    code: str
    name: str
    base_occupancy: int
    max_occupancy: int
    is_active: bool = True
```

### 4.2 Booking Models
```python
class Booking(BookingBase):
    id: int
    booking_number: str
    nights: Optional[int] = None
    amount_paid: float = 0
    amount_pending: Optional[float] = None
    payment_status: str = "pending"
    created_at: str
```

### 4.3 Tariff Models
```python
class DailyRate(DailyRateBase):
    id: int
    hotel_id: int
    room_type_id: int
    rate_plan_id: int
    date: str
    price: float
    min_stay: int = 1
    is_closed: int = 0
```

---

## 5. API ESISTENTI PER OCCUPANCY

### 5.1 Planning Endpoint
**Path**: `/api/planning/{hotel_code}?from_date=X&to_date=Y`

Ritorna:
- Camere con housekeeping status
- Prenotazioni nel range
- Room assignments (segmenti)
- Blocchi camera

### 5.2 Dashboard Stats (Presumibile)
**Path**: `backend/models/hotel.py` → `DashboardStats`

Modello per statistiche dashboard (da verificare implementazione).

---

## 6. CAMPI DISPONIBILI PER CALCOLO OCCUPANCY

### Per Singolo Giorno:
- **Total Rooms**: `COUNT(*) FROM rooms WHERE hotel_id = ? AND is_active = 1`
- **Rooms Sold**: Query bookings con range date + status filter
- **Revenue**: `SUM(total) FROM bookings` per range
- **Occupancy %**: rooms_sold / total_rooms * 100
- **ADR**: revenue / rooms_sold
- **RevPAR**: revenue / total_rooms

### Per Range Periodo:
- Iterare su ogni data nel range
- Calcolare metriche giornaliere
- Aggregare per totali periodo

### Segmentazione Disponibile:
- Per room_type_id (tipologia camera)
- Per channel_id (canale distribuzione)
- Per rate_plan_id (tariffa applicata)
- Per weekday vs weekend

---

## 7. COME RATEBOARD CALCOLA DISPONIBILITA

**Non calcola disponibilità diretta!**

Rateboard mostra:
- Prezzi configurati (daily_rates)
- Suggerimenti basati su storico
- Confronto competitor

**Disponibilità** calcolata da:
- Planning (`/api/planning`) → vista grafica
- Booking Engine (`/api/public/availability`) → prenotazioni online

**Formula Integrazione**:
```
Rateboard (pricing) + Planning (occupancy) = Revenue Intelligence Dashboard
```

---

## 8. SUGGERIMENTI INTEGRAZIONE SISTEMA BUCCHI

### 8.1 Dati Già Disponibili ✅
- Total rooms per hotel
- Bookings con date/status
- Revenue per booking
- Room_assignments per segmenti

### 8.2 Da Aggiungere (se mancanti)
- **Occupancy cache table** → Precalcolo giornaliero per performance
- **Forecast table** → Proiezioni future
- **Pickup tracking** → Velocità prenotazioni

### 8.3 Query Ottimizzate per Dashboard

**Occupancy Last 30 Days**:
```sql
WITH RECURSIVE dates(date) AS (
  SELECT date('now', '-30 days')
  UNION ALL
  SELECT date(date, '+1 day') FROM dates WHERE date < date('now')
)
SELECT
  d.date,
  COUNT(b.id) as rooms_sold,
  (SELECT COUNT(*) FROM rooms WHERE hotel_id = ? AND is_active = 1) as total_rooms,
  ROUND(COUNT(b.id) * 100.0 / (SELECT COUNT(*) FROM rooms WHERE hotel_id = ? AND is_active = 1), 1) as occupancy_pct
FROM dates d
LEFT JOIN bookings b ON
  b.hotel_id = ? AND
  b.check_in_date <= d.date AND
  b.check_out_date > d.date AND
  b.status NOT IN ('cancelled', 'no_show')
GROUP BY d.date
ORDER BY d.date
```

**Revenue Trend (YoY)**:
```sql
SELECT
  strftime('%Y-%m', check_in_date) as month,
  COUNT(*) as bookings_count,
  SUM(total) as revenue,
  AVG(total) as avg_booking_value
FROM bookings
WHERE hotel_id = ?
  AND status NOT IN ('cancelled', 'no_show')
  AND check_in_date >= date('now', '-24 months')
GROUP BY month
ORDER BY month
```

### 8.4 Endpoint Consigliati da Creare

**NEW**: `/api/revenue/dashboard`
- Occupancy oggi/settimana/mese
- RevPAR trend
- ADR evolution
- Forecast prossimi 30gg

**NEW**: `/api/revenue/bucchi`
- Matrice bucchi (date x room_types)
- Color coding per occupancy %
- Click to rateboard per price adjust

**EXTEND**: `/api/rateboard/suggestions`
- Includere dati occupancy real-time
- Suggerimenti basati su bucchi vuoti

---

## 9. CONCLUSIONI

### Schema Database: ECCELLENTE ✅
- Struttura normalizzata
- Indici performanti
- Room_assignments per flessibilità

### Sistema Esistente: MATURO ✅
- Rateboard funzionante con AI
- Calcolo metriche già implementato
- Booking engine integrato

### Gap da Colmare: MINIMI 🟡
- Dashboard visuale bucchi (frontend)
- Cache occupancy per performance
- Forecast model (opzionale)

### Next Steps Consigliati:
1. **Studiare** `backend/services/rateboard_analytics.py` per pattern analysis
2. **Creare** endpoint `/api/revenue/bucchi` con matrice occupancy
3. **Integrare** rateboard + bucchi in single dashboard
4. **Frontend** per visualizzazione "sistema bucchi" (heatmap)

---

## FONTI

- `/Users/rafapra/Developer/miracollogeminifocus/backend/database/schema.sql`
- `/Users/rafapra/Developer/miracollogeminifocus/backend/models/*.py`
- `/Users/rafapra/Developer/miracollogeminifocus/backend/routers/rateboard.py`
- `/Users/rafapra/Developer/miracollogeminifocus/backend/routers/public/availability.py`
- `/Users/rafapra/Developer/miracollogeminifocus/backend/routers/planning.py`
- `/Users/rafapra/Developer/miracollogeminifocus/backend/database/migrations/003_add_room_assignments.sql`

---

**FINE RICERCA**
