# RICERCA: Virtual Card OTA - Stato Implementazione Miracollo

**Data:** 18 Gennaio 2026
**Ricercatrice:** Cervella Researcher
**Progetto:** Miracollo PMS

---

## TL;DR - SINTESI ESECUTIVA

```
STATUS: PRONTO per implementazione con Stripe Elements
COMPLESSITÀ: MEDIA (1-2 giorni sviluppo)
BLOCCHI: Nessuno tecnico. PagonLine bloccato (chiavi banca).

COSA ESISTE:
✅ Studio completo VCC (docs/studio/STUDIO_VCC_PAYMENT_GATEWAY.md)
✅ Stripe integrato e configurato (backend/services/stripe_service.py)
✅ Test VCC funzionante (scripts/test_stripe_vcc.py)
✅ PagonLine client pronto (backend/services/pagonline/) - IN ATTESA chiavi
✅ Database schema con campi VCC (payments.virtual_card_*)
✅ Frontend modal pagamento (frontend/js/planning/modal-payment.js)
✅ Email parser BeSync (estrae dati VCC dalle email)

COSA MANCA:
❌ UI per inserire dati VCC (Stripe Elements integration)
❌ Backend endpoint /charge-vcc
❌ Flow automatico: email → estrazione VCC → addebito
```

---

## SEZIONE 1: BOOKING.COM CONNECTIVITY API

### Stato Attuale (Gen 2026)

| Aspetto | Dettaglio |
|---------|-----------|
| **Accesso API** | **SOSPESO** - Booking.com ha pausato nuove applicazioni |
| **Quando riapriranno** | SCONOSCIUTO (aggiornamento T&C in corso) |
| **Alternativa attuale** | Channel Manager (Little Hotelier, SiteMinder) |
| **BeSync attivo** | Zucchetti Booking Expert - Email forwarding |

**Fonte studio:** `docs/studio/STUDIO_CHANNEL_MANAGER.md` (aggiornato 6 Gen 2026)

### Dati VCC nelle Email BeSync

**File sample:** `docs/samples/besync_new_booking.txt`

```
Estratto email Booking.com (via BeSync):
- reservationVccActivationDate: 2026-05-28
- reservationVccDeactivationDate: 2027-06-01
- reservationVccCurrentBalance: 0.00 EUR
- reservationCommissionTotal: 83.810 EUR
- ExtraInfo: "Hai ricevuto una carta di credito virtuale..."
```

**PROBLEMA:** Email NON contiene dati carta completi (PAN, CVV, scadenza).
**MOTIVO:** Booking.com li invia solo via Extranet login o API diretta.

### Parser Email Esistente

**File:** `backend/services/email/besync.py`

```python
def parse_besync_email(email_body: str) -> Optional[ParsedReservation]:
    # Estrae: external_id, guest_name, check_in, total_price, etc.
    # NON estrae dati VCC (non presenti in email)
```

**Status:** Parser funzionante per prenotazioni. VCC extraction NON implementata (dati non in email).

---

## SEZIONE 2: STRIPE INTEGRATION

### Configurazione Esistente

**File:** `backend/services/stripe_service.py`

```python
✅ stripe.api_key configurato (.env)
✅ create_checkout_session() - Booking Engine
✅ verify_webhook_signature() - Conferme pagamento
✅ create_refund() - Rimborsi
```

**Test:** `scripts/test_stripe_vcc.py`

```bash
✅ Test 1: Configurazione OK
✅ Test 2: Connessione Stripe OK
✅ Test 3: PaymentMethod creation OK
✅ Test 4: PaymentIntent off_session FUNZIONA!
✅ Test 5: Token-based VCC simulation FUNZIONA!
```

### Limitazione PCI-DSS

| Metodo | PCI Richiesto | Note |
|--------|---------------|------|
| **Raw card data API** | ✅ SI (5k-50k EUR) | Per inserire PAN/CVV/exp via backend |
| **Stripe Elements** | ❌ NO | iFrame Stripe carica dati carta, noi solo token |

**Raccomandazione studio:** Usare Stripe Elements (zero PCI compliance).

---

## SEZIONE 3: PAGONLINE (UNICREDIT)

### Setup Esistente

**Path:** `backend/services/pagonline/`

```
✅ __init__.py
✅ client.py (v0.4.0 - POST HTTP diretto)
✅ signature.py (v0.3.0 - HMAC-SHA256)
✅ models.py
✅ exceptions.py
```

**Prototipo:** FUNZIONANTE (testato con mock).

### BLOCCO CREDENZIALI

**File:** `docs/studio/STUDIO_VCC_PAYMENT_GATEWAY.md` (Appendice)

| Cosa | Status | Note |
|------|--------|------|
| tid (Terminal ID) | ✅ Trovato | `30662008` |
| kSig (Chiave API) | ❌ **BLOCCATO** | Serve sblocco dalla BANCA! |
| Ambiente Sandbox | ⏳ In attesa | Non testabile senza kSig |

**Decisione storica (30 Dic 2025):** Andare avanti con Stripe. PagonLine opzionale quando sbloccato.

---

## SEZIONE 4: DATABASE SCHEMA

**File:** `backend/database/schema.sql` (righe 392-443)

```sql
CREATE TABLE payments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    hotel_id INTEGER NOT NULL,
    booking_id INTEGER REFERENCES bookings(id),

    payment_type TEXT NOT NULL,  -- 'deposit', 'balance', 'refund'
    payment_method TEXT NOT NULL,  -- 'cash', 'card', 'bank_transfer', 'virtual_card'

    amount REAL NOT NULL,
    currency TEXT DEFAULT 'EUR',

    -- Virtual Card
    virtual_card_number TEXT,      ✅ PRONTO
    virtual_card_expiry TEXT,      ✅ PRONTO
    virtual_card_cvv TEXT,         ✅ PRONTO

    -- Stripe
    transaction_id TEXT,
    authorization_code TEXT,

    status TEXT DEFAULT 'completed',
    notes TEXT,

    -- Audit
    created_at TEXT DEFAULT (datetime('now')),
    created_by INTEGER,
    updated_at TEXT DEFAULT (datetime('now'))
);
```

**Status:** Schema PRONTO. Campi VCC esistono.

---

## SEZIONE 5: FRONTEND UI

### Modal Pagamento Esistente

**File:** `frontend/js/planning/modal-payment.js`

```javascript
function openPaymentModal(booking) {
    // ✅ Form registrazione pagamento
    // ✅ Metodi: cash, card, bank_transfer
    // ✅ Submit via /api/payments
    // ❌ Manca: Stripe Elements per VCC
}
```

**Status:** Modal funziona per pagamenti manuali. NON ha Stripe Elements.

### Router Backend

**File:** `backend/routers/payments.py`

```python
@router.post("/api/payments")  # ✅ ESISTE
async def create_payment(payment: PaymentCreate):
    # Registra pagamento, aggiorna booking.amount_paid
    # NON fa addebito automatico VCC
```

**Status:** Endpoint CRUD payments esistente. NON ha logica VCC auto-charge.

---

## SEZIONE 6: ARCHITETTURA PROPOSTA

### Flow Completo (Da Studio VCC)

```
1. Prenotazione arriva via BeSync email
2. Staff apre modal "Addebita VCC"
3. Inserisce dati carta in Stripe Elements (iFrame)
4. Frontend chiama /api/payments/charge-vcc con token
5. Backend crea PaymentIntent off_session
6. Stripe processa, conferma
7. Backend salva payment record, aggiorna booking
8. Staff vede "Pagamento OK"
```

### File Proposti (Da Studio)

```
FRONTEND:
frontend/js/planning/modal-vcc-charge.js  ❌ DA CREARE
  - Stripe Elements integration
  - UI inserimento carta
  - Submit a backend

BACKEND:
backend/routers/payments.py  ✅ ESISTE (da estendere)
  - Aggiungere endpoint POST /api/payments/charge-vcc
  - Logica: stripe.PaymentIntent.create(off_session=True)
```

---

## SEZIONE 7: STIMA IMPLEMENTAZIONE

### Fase 1: MVP Stripe Elements (1-2 giorni)

| Task | Stima | File |
|------|-------|------|
| **Frontend: Stripe Elements UI** | 2h | modal-vcc-charge.js |
| **Backend: /charge-vcc endpoint** | 1h | payments.py |
| **Log transazioni + update booking** | 1h | payments.py |
| **Test con carte test Stripe** | 1h | Manuale |
| **Documentazione** | 30min | README_VCC.md |

**Totale:** ~5.5h (1 giorno lavorativo)

### Fase 2: Automazione Email → VCC (futuro)

| Task | Stima | Note |
|------|-------|------|
| Parser dati VCC da email | 2h | Se Booking.com invia dati completi |
| Flow automatico addebito | 2h | Cron job o webhook |
| Gestione errori + retry | 2h | Carta scaduta, fondi insufficienti |

**Totale:** ~6h

**BLOCCO:** Booking.com NON invia dati VCC completi via email.
**Alternativa:** Accesso Extranet manuale O API diretta (quando disponibile).

---

## SEZIONE 8: OPZIONI STRATEGICHE

### Opzione A: Stripe Elements (RACCOMANDATO)

```
PRO:
✅ Zero PCI compliance
✅ Implementazione rapida (1 giorno)
✅ Già configurato e testato
✅ Workflow UX testato da migliaia di merchant

CONTRO:
⚠️ Inserimento manuale dati carta (da Extranet Booking.com)
⚠️ Commissioni Stripe (1.4% + €0.25)
```

### Opzione B: PagonLine

```
PRO:
✅ Zero commissioni extra (già contratto con banca)
✅ Client pronto

CONTRO:
❌ Bloccato - serve kSig da Unicredit
⚠️ API legacy (SOAP XML)
⚠️ Documentazione scarsa
```

### Opzione C: Channel Manager + API diretta (futuro)

```
PRO:
✅ Accesso automatico ai dati VCC
✅ Zero intervento manuale

CONTRO:
❌ Booking.com applicazioni SOSPESE (gen 2026)
❌ Certificazione lunga (2-6 mesi)
❌ Richiede volumi alti per ROI
```

**Decisione storica (29 Dic 2025):** Andare con Stripe Elements ora. Rivalutare API diretta quando Booking.com riapre e volumi crescono.

---

## SEZIONE 9: FILE CHIAVE (RIFERIMENTO RAPIDO)

### Documentazione

| File | Contenuto |
|------|-----------|
| `docs/studio/STUDIO_VCC_PAYMENT_GATEWAY.md` | Studio completo VCC (29 Dic 2025) |
| `docs/studio/STUDIO_CHANNEL_MANAGER.md` | Booking.com Connectivity API (6 Gen 2026) |
| `docs/moduli/MODULO_05_PAGAMENTI.md` | Overview modulo pagamenti |
| `docs/samples/besync_new_booking.txt` | Email sample con dati VCC parziali |

### Codice Backend

| File | Status | Funzione |
|------|--------|----------|
| `backend/services/stripe_service.py` | ✅ PRONTO | Stripe integration |
| `backend/services/pagonline/client.py` | ⏳ BLOCCATO | PagonLine client (attende chiavi) |
| `backend/routers/payments.py` | ✅ ESISTE | CRUD payments (da estendere) |
| `backend/database/schema.sql` | ✅ PRONTO | payments table con campi VCC |

### Codice Frontend

| File | Status | Funzione |
|------|--------|----------|
| `frontend/js/planning/modal-payment.js` | ✅ ESISTE | Modal pagamento base |
| `frontend/js/planning/modal-vcc-charge.js` | ❌ DA CREARE | Stripe Elements VCC |

### Scripts Test

| File | Funzione |
|------|----------|
| `scripts/test_stripe_vcc.py` | Test Stripe off_session payments |

---

## SEZIONE 10: PROSSIMI STEP RACCOMANDATI

### Immediato (Se prioritario)

1. **Decisione strategica:** Stripe Elements vs PagonLine vs Attesa API?
2. **Se Stripe:** Implementare MVP (1 giorno)
3. **Se PagonLine:** Sbloccare kSig con banca
4. **Se Attesa API:** Nessuna azione, monitorare Booking.com

### Medio Termine

1. **Testare MVP con carte test**
2. **Formare staff su workflow VCC**
3. **Monitorare commissioni Stripe vs risparmio tempo**

### Lungo Termine

1. **Booking.com riapre API:** Valutare integrazione diretta
2. **Volumi crescono:** ROI certificazione vs commissioni
3. **PagonLine sbloccato:** Testare come alternativa

---

## CONCLUSIONE

**Miracollo è PRONTO per implementazione VCC con Stripe Elements.**

| Aspetto | Valutazione |
|---------|-------------|
| **Fattibilità tecnica** | ✅ ALTA |
| **Complessità** | 🟡 MEDIA |
| **Tempo stimato** | 1-2 giorni |
| **Blocchi** | ❌ NESSUNO (Stripe OK) |
| **Dipendenze** | Stripe configurato (già fatto) |
| **Rischio** | 🟢 BASSO |

**Unico limite:** Inserimento manuale dati VCC (staff deve copiare da Extranet Booking.com).
**Soluzione futura:** API diretta quando Booking.com riapre applicazioni.

---

**Fonti principali:**
- Studio VCC: `docs/studio/STUDIO_VCC_PAYMENT_GATEWAY.md`
- Stripe Test: `scripts/test_stripe_vcc.py`
- Channel Manager: `docs/studio/STUDIO_CHANNEL_MANAGER.md`
- Stripe Docs: https://stripe.com/docs/payments/elements

**Next step suggerito:** Conferma strategica da Rafa, poi implementazione MVP Stripe.

---

*Cervella Researcher - 18 Gennaio 2026*
*"Studiare prima di agire - sempre!"* 🔬
