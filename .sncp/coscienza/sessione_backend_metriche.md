# Sessione Backend: Metrics Calculator

**Data**: 2026-01-10
**Agente**: cervella-backend
**Task**: Implementare sistema calcolo metriche performance

---

## Fatto

1. **Creato** `backend/services/metrics_calculator.py`
   - Implementate 4 metriche: occupancy, ADR, RevPAR, pickup_rate
   - Query step-by-step separate (più semplici e manutenibili)
   - Edge cases gestiti: division by zero, no bookings, no rooms
   - Logging dettagliato per debug

2. **Aggiornato** `backend/services/pricing_tracking_service.py`
   - `_get_current_metrics()` ora usa metrics_calculator
   - Gestione errori con fallback a None

---

## Query Implementate

**Query esatte dall'analisi**:
1. Total rooms: `SELECT COUNT(*) FROM rooms WHERE hotel_id=? AND is_active=1`
2. Blocked rooms: `JOIN room_blocks rb con rooms r`
3. Bookings + Revenue: `JOIN bookings b con booking_rooms br` (usa rate_per_night)
4. Pickup rate: Bookings con `created_at >= datetime('now', '-7 days')`

**ADR**: Usa `booking_rooms.rate_per_night` (preciso per camera)
**RevPAR**: `revenue_totale / camere_disponibili`
**Pickup**: `new_bookings_7d / 7.0`

---

## Edge Cases Gestiti

- ✅ Division by zero: Se camere_disponibili=0 → 0.0
- ✅ No bookings: Revenue e ADR = 0.0
- ✅ No active rooms: Ritorna metriche vuote
- ✅ All rooms blocked: Log warning + metriche vuote
- ✅ Multi-room bookings: `COUNT(DISTINCT b.id)` per occupancy
- ✅ Multi-night bookings: `rate_per_night` invece di subtotal

---

## Note Tecniche

**Status bookings considerati**:
- Occupancy/ADR/RevPAR: Solo `confirmed` + `checked_in`
- Pickup rate: Include anche `pending`

**Pickup rate**: Default 7 giorni (può essere parametrizzato in futuro)

**Logging**: Ogni calcolo logga risultato per debug

---

## Prossimi Step (Non in questo task)

- Test unitari su `test_metrics_calculator.py`
- Test su dati reali Naturae Lodge
- Eventuale batch version per range di date

---

Status: ✅ COMPLETO
