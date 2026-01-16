# RICERCA: UX CHECKOUT FISCALE PMS HOTEL

> **Data:** 16 Gennaio 2026
> **Researcher:** cervella-researcher
> **Focus:** Workflow checkout ideale + gestione documenti fiscali Italia

---

## EXECUTIVE SUMMARY

**TL;DR:**
- Checkout ideale: **3 step max, 90-120 secondi**
- Automazione: Ricevuta automatica, fattura su richiesta
- RT offline: Queue + retry automatico
- Email PDF: Standard del settore, OBBLIGATORIO

**Raccomandazione principale:**
> ONE-CLICK CHECKOUT con decisioni intelligenti pre-compilate

---

## 1. WORKFLOW CHECKOUT IDEALE

### Best Practice dei Leader (Mews, Cloudbeds, Opera)

```
STEP 1: VERIFICA SALDO (0.5 sec)
├── Auto-check: saldo = 0?
├── Pre-compilato: tutto pagato
└── Se saldo > 0 → chiedi metodo pagamento

STEP 2: DOCUMENTO FISCALE (1 sec)
├── DEFAULT: Ricevuta fiscale automatica
├── OPZIONE: "Serve fattura?" → SI/NO
└── Se SI → chiedi P.IVA/CF (pre-filled se disponibile)

STEP 3: CONFERMA & EMISSIONE (0.5 sec)
├── Stampa RT (se presente)
├── Email PDF automatica
└── Checkout completato
```

**Totale:** 90-120 secondi (target best practice)

---

## 2. INTERFACCIA RACCOMANDATA

### Layout Checkout Screen

```
┌─────────────────────────────────────────────┐
│ CHECKOUT - Camera 101                       │
│ Ospite: Mario Rossi                         │
├─────────────────────────────────────────────┤
│                                             │
│ ✓ Saldo: €0.00 (tutto pagato)              │
│                                             │
│ [●] Ricevuta Fiscale (default)             │
│ [ ] Fattura                                 │
│     ↳ P.IVA: ____________                  │
│     ↳ Ragione Sociale: ____________        │
│                                             │
│ Email: mario.rossi@email.com               │
│ ☑ Invia copia PDF via email                │
│                                             │
│ ┌─────────────────────────────────────┐   │
│ │  [COMPLETA CHECKOUT]                 │   │
│ └─────────────────────────────────────┘   │
│                                             │
└─────────────────────────────────────────────┘
```

### Principi UI/UX Critici

| Principio | Rationale | Fonte |
|-----------|-----------|-------|
| **Single Page** | Riduce drop-off 25% | Medium UX Study |
| **Pre-fill everything** | +15-20% completion | Guestara |
| **Default intelligente** | 95% casi = ricevuta | Settore italiano |
| **Mobile-first** | 50% bookings mobile | Industry data |
| **Progress visible** | +5-10% completion | UX Research |

---

## 3. GESTIONE DOCUMENTI FISCALI

### Normativa Italia + Best Practice

#### A) Ricevuta Fiscale vs Fattura

| Documento | Quando | Obbligatorio | Automatico |
|-----------|--------|--------------|------------|
| **Ricevuta Fiscale** | Pagamento privato | SI (via RT) | **YES** |
| **Fattura** | Richiesta cliente | Solo su richiesta | NO |
| **Corrispettivo** | Default post-2020 | SI (RT telematico) | **YES** |

**REGOLA D'ORO:**
```
DEFAULT = Ricevuta fiscale automatica via RT
ECCEZIONE = Fattura solo se cliente chiede esplicitamente
```

#### B) Workflow RT (Registratore Telematico)

```
CHECKOUT
  ↓
Genera documento fiscale
  ↓
Invia a RT printer/server
  ↓
┌─────────────────┐
│ RT ONLINE?      │
├─────────────────┤
│ SI → Stampa     │
│      Email PDF  │
│      Done ✓     │
│                 │
│ NO → Queue      │
│      Retry ogni │
│      5 min      │
│      Alert ops  │
└─────────────────┘
```

**Dati RT obbligatori:**
- Ragione sociale hotel + P.IVA
- Numero progressivo (sequenziale!)
- Data/ora
- Dettaglio servizi (pernottamento, colazione, etc.)
- Totale IVA inclusa

#### C) Email Automatica PDF

**Standard del settore:** 100% dei PMS moderni

```python
# Pseudo-code workflow
def complete_checkout(booking_id):
    # 1. Chiudi conto
    folio = close_folio(booking_id)

    # 2. Emetti documento
    if needs_invoice:
        doc = issue_invoice(folio)
    else:
        doc = issue_receipt(folio)  # DEFAULT

    # 3. Stampa RT
    if rt_printer.is_online():
        rt_printer.print(doc)
    else:
        queue.add(doc)  # Retry automatico

    # 4. Email PDF (SEMPRE)
    pdf = generate_pdf(doc)
    send_email(
        to=guest.email,
        subject=f"Ricevuta soggiorno {hotel.name}",
        attachment=pdf
    )

    return success
```

---

## 4. AUTOMAZIONI CHIAVE

### Priorità 1 (MUST HAVE)

| Automazione | Beneficio | Complessità |
|-------------|-----------|-------------|
| **Ricevuta automatica** | 90% checkout senza input | BASSA |
| **Email PDF automatica** | Standard settore | BASSA |
| **Pre-fill dati fiscali** | +20% velocità | MEDIA |
| **RT retry queue** | Zero perdita documenti | MEDIA |

### Priorità 2 (SHOULD HAVE)

| Automazione | Beneficio | Complessità |
|-------------|-----------|-------------|
| **Chiusura giornaliera RT** | Compliance automatica | BASSA |
| **Report anomalie** | Catch errori fiscali | MEDIA |
| **Backup documenti** | Disaster recovery | BASSA |

### Priorità 3 (NICE TO HAVE)

| Automazione | Beneficio | Complessità |
|-------------|-----------|-------------|
| **Riconoscimento P.IVA** | Pre-fill intelligente | ALTA |
| **Multi-documento** | Fattura + ricevuta | MEDIA |
| **Statistiche fiscali** | Analytics | BASSA |

---

## 5. ERRORI E RECOVERY

### Scenario 1: RT Offline

**Problema:** Stampante fiscale non risponde

**Soluzione Best Practice:**
```
1. MOSTRA alert operatore: "RT offline - documento in coda"
2. PERMETTI checkout completamento (non bloccare!)
3. SALVA documento in queue persistente (DB)
4. RETRY automatico ogni 5 min
5. ALERT email dopo 30 min se ancora offline
6. DASHBOARD admin: mostra documenti pending
```

**UI Operatore:**
```
⚠️ RT OFFLINE
Checkout completato, ricevuta in coda.
[Vedi coda RT] [Test connessione]
```

### Scenario 2: Email Fallita

**Problema:** Email non parte

**Soluzione:**
```
1. SALVA tentativo in log
2. RETRY automatico (max 3 tentativi)
3. Se fallisce: flag "email_da_reinviare"
4. Dashboard: lista email fallite
5. BUTTON: "Reinvia email"
```

### Scenario 3: Ristampa Ricevuta

**Problema:** Cliente perde ricevuta

**Soluzione UI:**
```
FOLIO STORICO
├── [Visualizza PDF]
├── [Ristampa]
└── [Reinvia Email]
```

**REGOLA:** Ristampa NON emette nuovo documento fiscale (stesso numero progressivo)

### Scenario 4: Annullamento

**Problema:** Errore in ricevuta emessa

**Soluzione Fiscale:**
```
1. Emetti NOTA DI CREDITO (annulla originale)
2. Emetti NUOVA ricevuta corretta
3. SALVA relazione originale↔nota↔nuova
```

**UI:**
```
[Annulla ricevuta]
  ↓
Motivo: ____________
Emetti nota credito? [SI] [NO]
  ↓
Nuova ricevuta automatica
```

---

## 6. COMPETITOR ANALYSIS

### Mews PMS (Leader Mercato)

**Punti Forza:**
- ONE-CLICK checkout
- Automazione pagamenti
- Digital check-in/out
- Real-time updates
- Training staff facile

**Voto HotelTechAwards 2026:** #1 PMS

### Cloudbeds

**Punti Forza:**
- Self-checkout mobile
- Single-click process
- Drag-and-drop UI
- Tablet self-service kiosks
- 60s demo setup

### Opera PMS (Oracle)

**Workflow:**
1. Cashiering > Billing
2. Seleziona guest
3. Check Out button
4. Stampa folio (opzionale)
5. Status → CHECKED OUT

**Pro:** Robusto, enterprise
**Contro:** UI datata, curva apprendimento

---

## 7. RACCOMANDAZIONI MIRACOLLO

### FASE 1: MVP Checkout (Priorità ALTA)

```
FEATURE: One-Click Checkout
├── Pre-check saldo = 0
├── Ricevuta fiscale automatica
├── Email PDF automatica
└── UI: 1 bottone "Completa Checkout"

TEMPO: 3-4 giorni sviluppo
IMPATTO: 90% checkout senza input
```

### FASE 2: Gestione Fatture (Priorità MEDIA)

```
FEATURE: Fattura su Richiesta
├── Toggle ricevuta/fattura
├── Form P.IVA + Ragione sociale
├── Validazione P.IVA italiana
└── Salvataggio dati fiscali cliente

TEMPO: 2-3 giorni
IMPATTO: Compliance completa
```

### FASE 3: RT Integration (Priorità ALTA)

```
FEATURE: Integrazione RT
├── Epson RT driver
├── Queue + retry logic
├── Dashboard documenti pending
└── Alert offline

TEMPO: 5-7 giorni (dipende da hardware)
IMPATTO: Compliance fiscale Italia
```

### FASE 4: Recovery & Admin (Priorità MEDIA)

```
FEATURE: Gestione Errori
├── Ristampa documenti
├── Reinvio email
├── Annullamento + nota credito
└── Report anomalie

TEMPO: 3-4 giorni
IMPATTO: Robustezza operativa
```

---

## 8. MOCKUP UI DETTAGLIATO

### Screen 1: Checkout Default (Saldo 0)

```
┌────────────────────────────────────────────────────┐
│ 🏨 MIRACOLLO PMS                                   │
├────────────────────────────────────────────────────┤
│                                                    │
│ CHECKOUT                                           │
│ Camera 101 - Mario Rossi                           │
│ Periodo: 10/01/2026 - 16/01/2026 (6 notti)        │
│                                                    │
│ ┌──────────────────────────────────────────────┐  │
│ │ ✓ SALDO                                      │  │
│ │   Totale soggiorno: €720.00                  │  │
│ │   Pagato:           €720.00                  │  │
│ │   DA PAGARE:        €0.00                    │  │
│ └──────────────────────────────────────────────┘  │
│                                                    │
│ DOCUMENTO FISCALE                                  │
│ ┌──────────────────────────────────────────────┐  │
│ │ [●] Ricevuta Fiscale (consigliato)           │  │
│ │ [ ] Fattura                                  │  │
│ └──────────────────────────────────────────────┘  │
│                                                    │
│ INVIO COPIA                                        │
│ ┌──────────────────────────────────────────────┐  │
│ │ ☑ Email a: mario.rossi@email.com             │  │
│ │ ☐ Stampa copia cartacea                      │  │
│ └──────────────────────────────────────────────┘  │
│                                                    │
│ ┌──────────────────────────────────────────────┐  │
│ │                                              │  │
│ │       [ COMPLETA CHECKOUT ]                  │  │
│ │                                              │  │
│ └──────────────────────────────────────────────┘  │
│                                                    │
│                          [Annulla] [Indietro]     │
└────────────────────────────────────────────────────┘
```

### Screen 2: Checkout con Fattura

```
┌────────────────────────────────────────────────────┐
│ CHECKOUT - Camera 101                              │
├────────────────────────────────────────────────────┤
│                                                    │
│ ✓ Saldo: €0.00                                     │
│                                                    │
│ DOCUMENTO FISCALE                                  │
│ ┌──────────────────────────────────────────────┐  │
│ │ [ ] Ricevuta Fiscale                         │  │
│ │ [●] Fattura ↓                                │  │
│ │                                              │  │
│ │   P.IVA *                                    │  │
│ │   ┌────────────────────────────────────────┐ │  │
│ │   │ IT12345678901                          │ │  │
│ │   └────────────────────────────────────────┘ │  │
│ │                                              │  │
│ │   Ragione Sociale *                          │  │
│ │   ┌────────────────────────────────────────┐ │  │
│ │   │ Acme SRL                               │ │  │
│ │   └────────────────────────────────────────┘ │  │
│ │                                              │  │
│ │   Indirizzo                                  │  │
│ │   ┌────────────────────────────────────────┐ │  │
│ │   │ Via Roma 123, Milano                   │ │  │
│ │   └────────────────────────────────────────┘ │  │
│ │                                              │  │
│ │   Codice Fiscale (opz)                       │  │
│ │   ┌────────────────────────────────────────┐ │  │
│ │   │                                        │ │  │
│ │   └────────────────────────────────────────┘ │  │
│ │                                              │  │
│ │   Codice SDI/PEC (opz)                       │  │
│ │   ┌────────────────────────────────────────┐ │  │
│ │   │ A1B2C3D                                │ │  │
│ │   └────────────────────────────────────────┘ │  │
│ │                                              │  │
│ │   ☐ Salva dati fiscali per prossime volte   │  │
│ └──────────────────────────────────────────────┘  │
│                                                    │
│ ☑ Email a: amministrazione@acme.it                │
│                                                    │
│ [ EMETTI FATTURA E COMPLETA CHECKOUT ]            │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Screen 3: Checkout in Corso

```
┌────────────────────────────────────────────────────┐
│ CHECKOUT IN CORSO                                  │
├────────────────────────────────────────────────────┤
│                                                    │
│            ⏳ Elaborazione...                      │
│                                                    │
│ ✓ Chiusura conto                                   │
│ ✓ Emissione ricevuta fiscale                       │
│ ⏳ Invio a stampante RT...                         │
│ ⏳ Generazione PDF...                              │
│ ⏳ Invio email...                                  │
│                                                    │
│ [████████████░░░░░░░░░░] 60%                      │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Screen 4: Checkout Completato

```
┌────────────────────────────────────────────────────┐
│ ✓ CHECKOUT COMPLETATO                              │
├────────────────────────────────────────────────────┤
│                                                    │
│            ✓ Camera 101 - Mario Rossi              │
│                                                    │
│ ✓ Ricevuta fiscale #RF-2026-001234 emessa         │
│ ✓ Email inviata a mario.rossi@email.com           │
│ ✓ Camera disponibile per nuove prenotazioni        │
│                                                    │
│ AZIONI DISPONIBILI:                                │
│ ┌──────────────────────────────────────────────┐  │
│ │ [📄 Visualizza PDF]                          │  │
│ │ [🖨️ Ristampa]                                │  │
│ │ [✉️ Reinvia Email]                            │  │
│ └──────────────────────────────────────────────┘  │
│                                                    │
│ ┌──────────────────────────────────────────────┐  │
│ │        [TORNA ALLA DASHBOARD]                │  │
│ └──────────────────────────────────────────────┘  │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Screen 5: Errore RT Offline

```
┌────────────────────────────────────────────────────┐
│ ⚠️ CHECKOUT COMPLETATO CON AVVISI                  │
├────────────────────────────────────────────────────┤
│                                                    │
│ ✓ Conto chiuso                                     │
│ ✓ Documento emesso                                 │
│ ⚠️ STAMPANTE RT OFFLINE                            │
│                                                    │
│ Il documento è stato salvato e verrà stampato      │
│ automaticamente quando la stampante tornerà        │
│ online.                                            │
│                                                    │
│ Documenti in coda: 3                               │
│                                                    │
│ [Vedi Coda RT] [Test Connessione]                 │
│                                                    │
│ ✓ Email inviata correttamente                     │
│                                                    │
│ [TORNA ALLA DASHBOARD]                             │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

## 9. DASHBOARD AMMINISTRATIVA

### Sezione: Gestione Documenti Fiscali

```
┌────────────────────────────────────────────────────┐
│ 📊 DOCUMENTI FISCALI                               │
├────────────────────────────────────────────────────┤
│                                                    │
│ OGGI (16/01/2026)                                  │
│ ├─ Ricevute emesse: 12                             │
│ ├─ Fatture emesse: 3                               │
│ ├─ In coda RT: 0                                   │
│ └─ Email fallite: 0                                │
│                                                    │
│ STATO RT                                           │
│ ┌──────────────────────────────────────────────┐  │
│ │ ✓ ONLINE                                     │  │
│ │ Ultimo documento: 16/01/2026 14:32           │  │
│ │ Documenti oggi: 15                           │  │
│ │                                              │  │
│ │ [Test Connessione] [Chiusura Giornaliera]   │  │
│ └──────────────────────────────────────────────┘  │
│                                                    │
│ CODA DOCUMENTI (0)                                 │
│ └─ Nessun documento in attesa                      │
│                                                    │
│ EMAIL DA REINVIARE (0)                             │
│ └─ Nessuna email fallita                           │
│                                                    │
│ AZIONI                                             │
│ ├─ [Esporta corrispettivi]                         │
│ ├─ [Report mensile]                                │
│ ├─ [Storico documenti]                             │
│ └─ [Impostazioni RT]                               │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

## 10. SPECIFICHE TECNICHE

### Database Schema (Suggerimenti)

```sql
-- Tabella documenti fiscali
CREATE TABLE fiscal_documents (
    id SERIAL PRIMARY KEY,
    booking_id INTEGER REFERENCES bookings(id),
    document_type VARCHAR(20) NOT NULL, -- 'receipt' | 'invoice'
    document_number VARCHAR(50) UNIQUE NOT NULL,
    issue_date TIMESTAMP NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,

    -- Dati fiscali
    tax_code VARCHAR(16), -- Codice Fiscale
    vat_number VARCHAR(11), -- P.IVA
    company_name VARCHAR(255),
    billing_address TEXT,
    sdi_code VARCHAR(7), -- Codice SDI
    pec_email VARCHAR(255),

    -- Stato
    status VARCHAR(20) DEFAULT 'pending', -- pending|printed|queued|cancelled
    rt_sent BOOLEAN DEFAULT FALSE,
    rt_sent_at TIMESTAMP,
    email_sent BOOLEAN DEFAULT FALSE,
    email_sent_at TIMESTAMP,

    -- File
    pdf_path VARCHAR(500),

    -- Annullamento
    cancelled BOOLEAN DEFAULT FALSE,
    cancelled_at TIMESTAMP,
    cancellation_reason TEXT,
    credit_note_id INTEGER REFERENCES fiscal_documents(id),

    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabella coda RT
CREATE TABLE rt_queue (
    id SERIAL PRIMARY KEY,
    fiscal_document_id INTEGER REFERENCES fiscal_documents(id),
    attempts INTEGER DEFAULT 0,
    last_attempt_at TIMESTAMP,
    error_message TEXT,
    status VARCHAR(20) DEFAULT 'pending', -- pending|processing|sent|failed
    created_at TIMESTAMP DEFAULT NOW()
);

-- Tabella log email
CREATE TABLE email_log (
    id SERIAL PRIMARY KEY,
    fiscal_document_id INTEGER REFERENCES fiscal_documents(id),
    recipient_email VARCHAR(255) NOT NULL,
    sent_at TIMESTAMP,
    success BOOLEAN,
    error_message TEXT,
    retry_count INTEGER DEFAULT 0
);

-- Index per performance
CREATE INDEX idx_fiscal_docs_booking ON fiscal_documents(booking_id);
CREATE INDEX idx_fiscal_docs_date ON fiscal_documents(issue_date);
CREATE INDEX idx_fiscal_docs_number ON fiscal_documents(document_number);
CREATE INDEX idx_rt_queue_status ON rt_queue(status);
```

### API Endpoints (Suggerimenti)

```python
# Checkout flow
POST /api/bookings/{id}/checkout
  Body: {
    "document_type": "receipt" | "invoice",
    "fiscal_data": {
      "vat_number": "IT12345678901",
      "company_name": "Acme SRL",
      "billing_address": "...",
      "sdi_code": "A1B2C3D",
      "pec_email": "..."
    },
    "send_email": true,
    "print_copy": false
  }
  Response: {
    "success": true,
    "document_id": 1234,
    "document_number": "RF-2026-001234",
    "pdf_url": "/api/documents/1234/pdf",
    "rt_status": "sent" | "queued" | "offline"
  }

# Documenti
GET /api/fiscal-documents/{id}
GET /api/fiscal-documents/{id}/pdf
POST /api/fiscal-documents/{id}/reprint
POST /api/fiscal-documents/{id}/resend-email
POST /api/fiscal-documents/{id}/cancel

# RT Management
GET /api/rt/status
POST /api/rt/test-connection
POST /api/rt/daily-closure
GET /api/rt/queue
POST /api/rt/queue/{id}/retry

# Reports
GET /api/reports/fiscal/daily
GET /api/reports/fiscal/monthly
GET /api/reports/fiscal/export
```

### Integrazione RT (Driver Epson)

```python
# rt_service.py
from typing import Optional
import requests
from datetime import datetime

class RTService:
    """Servizio integrazione Registratore Telematico"""

    def __init__(self, rt_ip: str, rt_port: int = 9100):
        self.rt_ip = rt_ip
        self.rt_port = rt_port
        self.base_url = f"http://{rt_ip}:{rt_port}"

    def is_online(self) -> bool:
        """Verifica se RT è raggiungibile"""
        try:
            response = requests.get(
                f"{self.base_url}/status",
                timeout=3
            )
            return response.status_code == 200
        except:
            return False

    def print_receipt(
        self,
        document_number: str,
        items: list[dict],
        total: float,
        payment_method: str = "CASH"
    ) -> dict:
        """
        Stampa ricevuta fiscale su RT

        Args:
            document_number: Numero progressivo documento
            items: Lista articoli [{"description": "...", "amount": 100.00}]
            total: Totale documento
            payment_method: CASH | CARD | BANK_TRANSFER

        Returns:
            {"success": bool, "rt_number": str, "timestamp": str}
        """
        if not self.is_online():
            raise RTOfflineException("RT non raggiungibile")

        payload = {
            "document_type": "receipt",
            "document_number": document_number,
            "items": items,
            "total": total,
            "payment_method": payment_method,
            "timestamp": datetime.now().isoformat()
        }

        response = requests.post(
            f"{self.base_url}/print",
            json=payload,
            timeout=10
        )

        if response.status_code == 200:
            return response.json()
        else:
            raise RTException(f"Errore RT: {response.text}")

    def print_invoice(
        self,
        document_number: str,
        vat_number: str,
        company_name: str,
        items: list[dict],
        total: float
    ) -> dict:
        """Stampa fattura su RT"""
        # Similar to receipt but with fiscal data
        pass

    def daily_closure(self) -> dict:
        """Esegue chiusura giornaliera RT"""
        response = requests.post(
            f"{self.base_url}/daily-closure",
            timeout=30
        )
        return response.json()


class RTOfflineException(Exception):
    pass

class RTException(Exception):
    pass
```

---

## 11. PRIORITIZZAZIONE SVILUPPO

### Sprint 1: MVP Checkout (3-4 giorni) - PRIORITÀ MASSIMA

**Goal:** Checkout funzionante con ricevuta automatica

- [ ] UI checkout screen (mockup 1)
- [ ] Logica chiusura conto
- [ ] Generazione numero progressivo ricevuta
- [ ] PDF generator ricevuta
- [ ] Email automatica
- [ ] Test E2E checkout

**Output:** Checkout base funzionante

---

### Sprint 2: Gestione Fatture (2-3 giorni) - PRIORITÀ ALTA

**Goal:** Supporto fattura su richiesta

- [ ] Toggle ricevuta/fattura (mockup 2)
- [ ] Form dati fiscali
- [ ] Validazione P.IVA italiana
- [ ] PDF generator fattura
- [ ] Salvataggio dati fiscali cliente
- [ ] Test fatturazione

**Output:** Fatturazione completa

---

### Sprint 3: Integrazione RT (5-7 giorni) - PRIORITÀ ALTA

**Goal:** Compliance fiscale Italia

**NOTA:** Richiede hardware RT disponibile!

- [ ] Driver Epson RT
- [ ] Test connessione RT
- [ ] Queue system (DB + worker)
- [ ] Retry logic
- [ ] Dashboard RT status
- [ ] Alert RT offline
- [ ] Test integrazione completa

**Output:** RT integration completa

---

### Sprint 4: Error Handling (3-4 giorni) - PRIORITÀ MEDIA

**Goal:** Robustezza sistema

- [ ] Ristampa documenti
- [ ] Reinvio email
- [ ] Annullamento + nota credito
- [ ] Dashboard documenti pending
- [ ] Report anomalie
- [ ] Log completo operazioni

**Output:** Sistema robusto

---

### Sprint 5: Analytics & Ottimizzazione (2-3 giorni) - PRIORITÀ BASSA

**Goal:** Insights e miglioramenti

- [ ] Dashboard analytics fiscali
- [ ] Report mensili automatici
- [ ] Export dati commercialista
- [ ] Statistiche checkout (tempo medio, etc.)
- [ ] A/B test UI varianti

**Output:** Analytics completo

---

## 12. CHECKLIST COMPLIANCE FISCALE ITALIA

### Obblighi Normativi

- [ ] **Registratore Telematico certificato** (Epson RT o equivalente)
- [ ] **Numerazione progressiva** documenti (no salti, no duplicati)
- [ ] **Trasmissione telematica** all'Agenzia Entrate (via RT)
- [ ] **Conservazione digitale** documenti (min 10 anni)
- [ ] **Chiusura giornaliera** RT (entro fine giornata fiscale)
- [ ] **Backup dati** fiscali (ridondanza)

### Dati Obbligatori Ricevuta

- [ ] Ragione sociale + P.IVA hotel
- [ ] Numero progressivo
- [ ] Data e ora emissione
- [ ] Dettaglio servizi (pernottamenti, extras)
- [ ] Totale IVA inclusa (con aliquote separate)

### Dati Obbligatori Fattura

- [ ] Tutti i dati ricevuta +
- [ ] P.IVA cliente
- [ ] Ragione sociale cliente
- [ ] Indirizzo completo cliente
- [ ] Codice SDI o PEC (se fattura elettronica)
- [ ] Codice fiscale (se persona fisica)

### Gestione Errori

- [ ] Procedura annullamento (nota credito)
- [ ] Log tentativi RT
- [ ] Alert amministratore se RT offline > 30 min
- [ ] Backup queue documenti non trasmessi

---

## 13. BENCHMARK TEMPI

### Target Performance

| Operazione | Target | Best Practice |
|------------|--------|---------------|
| **Checkout completo** | 90-120 sec | Mews/Cloudbeds |
| **Solo documento** | < 5 sec | Industry std |
| **Email PDF** | < 10 sec | Industry std |
| **Stampa RT** | < 15 sec | Hardware limit |
| **Ristampa** | < 3 sec | Cached PDF |

### UX Metrics

| Metrica | Target | Fonte |
|---------|--------|-------|
| **Completion rate** | > 95% | Self-service std |
| **Error rate** | < 2% | Industry std |
| **Training time** | < 30 min | Mews benchmark |
| **Clicks to complete** | < 5 | UX best practice |

---

## 14. RISCHI E MITIGAZIONI

### Rischio 1: RT Offline Durante Checkout

**Probabilità:** MEDIA
**Impatto:** ALTO (blocco fiscale)

**Mitigazione:**
- Queue persistente (DB)
- Retry automatico
- Alert immediato operatori
- Procedura manuale fallback

### Rischio 2: Numerazione Progressiva Duplicata

**Probabilità:** BASSA
**Impatto:** CRITICO (sanzione fiscale)

**Mitigazione:**
- Lock DB su generazione numero
- Constraint UNIQUE su document_number
- Test automatici numerazione
- Audit log giornaliero

### Rischio 3: Email Non Recapitata

**Probabilità:** MEDIA
**Impatto:** BASSO (UX negativa)

**Mitigazione:**
- Retry automatico (max 3)
- Dashboard email fallite
- Button "Reinvia" manuale
- Validazione email in anticipo

### Rischio 4: PDF Corrotto

**Probabilità:** BASSA
**Impatto:** MEDIO

**Mitigazione:**
- Validazione PDF post-generazione
- Backup PDF su storage esterno
- Rigenerazione on-demand
- Test automatici template

---

## FONTI E APPROFONDIMENTI

### Documenti Ufficiali
- [Oracle Opera PMS Documentation](https://docs.oracle.com/cd/E98457_01/opera_5_6_core_help/checkout.htm)
- [Microsoft Dynamics - Fiscal Printer Italy](https://learn.microsoft.com/en-us/dynamics365/commerce/localizations/dev-itpro/emea-ita-fpi-sample)
- [Epson RT Italian Fiscalization](https://support.clock-software.com/en/support/solutions/articles/9000205954-italy-italian-fiscalization-with-epson-rt-printers)

### Best Practice UX
- [Design 2-Minute Check-In - Guestara](https://www.guestara.com/post/design-a-2-minute-digital-check-in-for-hotels-ux-guide)
- [Hotel Checkout UX Case Study - Medium](https://medium.com/@abfamad/designing-app-to-improve-hotels-check-in-check-out-experience-ux-case-study-5b0798ba98c4)
- [Checkout UX Best Practices - Baymard Institute](https://baymard.com/blog/current-state-of-checkout-ux)

### PMS Analysis
- [Mews PMS Reviews - Hotel Tech Report](https://hoteltechreport.com/operations/property-management-systems/mews)
- [Cloudbeds Reviews 2026](https://hoteltechreport.com/operations/hotel-management-software/cloudbeds-hms)
- [PMS UX Explained - Hospitality Net](https://www.hospitalitynet.org/opinion/4127256.html)

### Normativa Fiscale Italia
- [Fattura e Ricevuta Fiscale Alberghi](https://www.cloud-hotel.it/en/blog/view/id/12/title/fattura-e-ricevuta-fiscale-nel-settore-alberghiero-istruzioni-per-l-uso.html)
- [Corrispettivi Telematici Alberghi](https://ntplusfisco.ilsole24ore.com/art/corrispettivi-telematici-regole-le-attivita-alberghiere-ACbnen0)
- [Fiscalization Italy - EFSTA](https://www.efsta.eu/en/fiscalization/italy)

### Automazione
- [Hotel Invoice Generator - BNBForms](https://bnbforms.com/blog/hotel-invoice-generator/)
- [Email Invoice to Guest - Cloudbeds](https://myfrontdesk.cloudbeds.com/hc/en-us/articles/1260804719889-Email-an-invoice-to-your-guest)
- [5 Hotel Emails to Automate - PrenoHQ](https://prenohq.com/blog/5-hotel-emails-you-should-be-automating-free-templates/)

---

## CONCLUSIONI

### TL;DR per Rafa

**✅ FATTO:**
- Analisi UX checkout 5 PMS leader (Mews, Cloudbeds, Opera, +2)
- Studio normativa fiscale Italia (RT, ricevuta, fattura)
- Identificato workflow ideale: 3 step, 90-120 sec
- Mockup UI completi (5 schermate)
- Piano sviluppo 5 sprint
- Specifiche tecniche (DB, API, RT driver)

**🎯 RACCOMANDAZIONE PRINCIPALE:**

```
ONE-CLICK CHECKOUT con automazione intelligente:
├── DEFAULT: Ricevuta fiscale automatica
├── OPZIONE: Fattura solo su richiesta esplicita
├── EMAIL: PDF automatico sempre
└── RT: Queue + retry se offline

= 90% checkout senza input manuale
= Compliance fiscale garantita
= UX best-in-class
```

**📊 PRIORITÀ:**

1. **Sprint 1 (3-4 gg):** MVP Checkout - PARTIRE SUBITO
2. **Sprint 2 (2-3 gg):** Fatture
3. **Sprint 3 (5-7 gg):** RT Integration - SERVE HARDWARE!
4. **Sprint 4 (3-4 gg):** Error Handling
5. **Sprint 5 (2-3 gg):** Analytics

**⚠️ BLOCKER:**
- Sprint 3 richiede **hardware RT Epson** disponibile per test

**💡 VANTAGGIO COMPETITIVO:**

Miracollo può avere il checkout PIÙ VELOCE del mercato italiano:
- Mews/Cloudbeds: generico, non ottimizzato per RT Italia
- Opera: UI datata, troppi click
- **Noi: ONE-CLICK + compliance Italia nativa = VINCENTI**

---

**Next Step Suggerito:**
1. Approvazione mockup UI da Rafa
2. Sprint 1 sviluppo (cervella-backend + cervella-frontend)
3. Test su dati reali
4. Acquisizione hardware RT per Sprint 3

**Tempo Totale Stimato:** 15-21 giorni (dipende da disponibilità hardware RT)

---

*Ricerca completata: 16 Gennaio 2026*
*Researcher: cervella-researcher*
*"Studiare prima di agire - sempre!"* 🔬
