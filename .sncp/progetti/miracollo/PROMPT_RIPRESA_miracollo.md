# PROMPT RIPRESA - Miracollo

> **Ultimo aggiornamento:** 18 Gennaio 2026 - Sessione 261
> **Status:** PRODUZIONE STABILE - VCC in testing

---

## SESSIONE 261: TEST VCC

### Cosa Abbiamo Fatto

```
1. STRIPE CONFIGURATO SULLA VM:
   - Chiavi esistevano in .env ma container non le leggeva
   - Fix: docker compose down + up (non solo restart!)
   - /api/payments/stripe-config -> enabled: true

2. TEST VCC INIZIATO:
   - Frontend: Stripe Elements funziona
   - Carta 4242 4242 4242 4242 riconosciuta come Visa
   - Backend: trovato BUG nella query!

3. BUG TROVATO (DA FIXARE):
   - payments.py riga 378-383
   - Query cerca b.guest_name ma tabella bookings non ce l'ha
   - Nome ospite e in tabella GUESTS (JOIN necessario!)
```

### Fix Da Applicare (Prossima Sessione)

```python
# VECCHIO (SBAGLIATO):
SELECT b.id, b.booking_number, b.total, b.amount_paid, b.hotel_id,
       (b.first_name || ' ' || b.last_name) AS guest_name, b.source
FROM bookings b WHERE b.id = ?

# NUOVO (CORRETTO):
SELECT b.id, b.booking_number, b.total, b.amount_paid, b.hotel_id,
       (g.first_name || ' ' || g.last_name) AS guest_name,
       c.name as source
FROM bookings b
LEFT JOIN guests g ON b.guest_id = g.id
LEFT JOIN channels c ON b.channel_id = c.id
WHERE b.id = ?
```

---

## ARCHITETTURA DB (Riferimento)

```
bookings: guest_id (FK) -> guests.id
bookings: channel_id (FK) -> channels.id
guests: first_name, last_name
```

---

## STATO MODULO VCC

```
Backend endpoint:  /api/payments/charge-vcc
Frontend UI:       Stripe Elements + "VCC Booking" button
Stripe account:    acct_1Sqrxk7aXUHP1bna (Test Mode)
Carta test:        4242 4242 4242 4242

STATUS: Frontend OK, Backend BUG da fixare
```

---

## INFRASTRUTTURA

```
VM MIRACOLLO (34.27.179.164):
- miracollo-backend-1 (healthy)
- miracollo-nginx (healthy)
- Stripe: ABILITATO (dopo down+up)
```

---

## PROSSIMI STEP

```
1. Fix query VCC (JOIN guests + channels)
2. Deploy fix
3. Re-test VCC
4. Documentare VCC funzionante
```

---

## FILE CHIAVE

| File | Scopo |
|------|-------|
| `backend/routers/payments.py` | Endpoint VCC (riga 356-480) |
| `frontend/js/planning/modal-payment.js` | UI Stripe Elements |
| `backend/services/stripe_service.py` | Logica Stripe |

---

*"Fatto BENE > Fatto veloce"*
