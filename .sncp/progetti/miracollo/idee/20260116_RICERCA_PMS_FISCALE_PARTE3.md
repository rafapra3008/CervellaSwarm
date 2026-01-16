# RICERCA PMS FISCALE - PARTE 3: Raccomandazioni per Miracollo

**Data**: 16 Gennaio 2026
**Ricercatrice**: Cervella Researcher
**Progetto**: Miracollo PMS

---

## EXECUTIVE SUMMARY

Basandosi sull'analisi di 6 PMS competitor (Ericsoft, Protel, Opera, Mews, Cloudbeds, Sysdat), questa parte presenta **l'architettura consigliata** per il modulo finanziario/fiscale di Miracollo.

### Scelte Strategiche Raccomandate

| Decisione | Raccomandazione | Rationale |
|-----------|-----------------|-----------|
| **Architettura** | API-first + Partner (Pattern B) | Flessibilità + Time-to-market |
| **SDI** | Intermediario certificato | Compliance garantita, meno rischi |
| **RT** | Middleware unified | Multi-marca, manutenzione semplice |
| **Workflow** | 3-click checkout | Best practice (Ericsoft/Opera) |
| **UX** | Smart suggestions + Preview | Error prevention |
| **Export** | Hybrid (API + CSV) | Flessibilità massima |

### Vantaggi Competitivi Miracollo

Cosa possiamo fare **MEGLIO** dei competitor:

1. **UX Moderna** - Cloud-native (vs Ericsoft/Sysdat tradizionali)
2. **Workflow Veloce** - 3 click (vs 10+ di Mews)
3. **Italia-First** - RT + SDI nativi (vs Protel/Opera/Mews che servono partner)
4. **API Aperte** - Integrazioni flessibili (vs lock-in Ericsoft)
5. **Costo Accessibile** - SMB pricing (vs enterprise Opera/Protel)

---

## 1. ARCHITETTURA CONSIGLIATA

### 1.1 Overview Sistema

```
┌─────────────────────────────────────────────────────────────────┐
│                      MIRACOLLO PMS                              │
│                                                                 │
│  ┌────────────────┐      ┌──────────────────┐                  │
│  │ Frontend React │──────│ Backend FastAPI  │                  │
│  │ (Checkout UI)  │      │ (Fiscal Module)  │                  │
│  └────────────────┘      └────────┬─────────┘                  │
│                                   │                             │
└───────────────────────────────────┼─────────────────────────────┘
                                    │
                ┌───────────────────┼───────────────────┐
                │                   │                   │
                ▼                   ▼                   ▼
         ┌────────────┐      ┌────────────┐     ┌────────────┐
         │ Fiscal API │      │ RT Middleware│   │ Accounting │
         │ Partner    │      │ (Epson/RCH/ │   │ Export API │
         │ (SDI)      │      │  Custom)     │   │            │
         └──────┬─────┘      └──────┬───────┘   └────────────┘
                │                   │
                ▼                   ▼
         ┌────────────┐      ┌────────────┐
         │    SDI     │      │ RT Hardware│
         │ (Agenzia   │      │ (Epson/    │
         │  Entrate)  │      │  Custom)   │
         └────────────┘      └────────────┘
```

### 1.2 Componenti Principali

#### A. Frontend (React) - Checkout UI

**Responsabilità:**
- Workflow checkout 3-click
- Smart document suggestion
- Preview documento
- Inline validation
- Error handling UX

**File principali:**
```
src/components/checkout/
├── CheckoutFlow.tsx           # Orchestrator checkout
├── FolioReview.tsx            # Riepilogo conto
├── DocumentSelector.tsx       # Scelta tipo documento
├── FiscalPreview.tsx          # Preview documento fiscale
├── PaymentProcessor.tsx       # Gestione pagamenti
└── CheckoutConfirmation.tsx   # Conferma finale
```

---

#### B. Backend (FastAPI) - Fiscal Module

**Responsabilità:**
- Business logic fiscale
- Validazione dati
- Generazione XML FatturaPA
- Orchestrazione invio SDI/RT
- Storico documenti fiscali
- Export contabilità

**File principali:**
```
backend/modules/fiscal/
├── __init__.py
├── models.py                  # FiscalDocument, Invoice, Receipt
├── service.py                 # FiscalService (orchestrator)
├── validators.py              # Validazione P.IVA, CF, SDI code
├── generators/
│   ├── invoice_xml.py         # Genera XML FatturaPA
│   ├── receipt.py             # Genera ricevuta fiscale
│   └── credit_note.py         # Genera nota credito
├── integrations/
│   ├── sdi_client.py          # Client SDI (via partner)
│   ├── rt_middleware.py       # Client RT middleware
│   └── accounting_export.py   # Export CSV/Excel/API
└── utils/
    ├── fiscal_codes.py        # Validazione CF/P.IVA
    └── tax_calculator.py      # Calcolo IVA/imposte
```

**API Endpoints:**

```python
# Fiscal API Routes
POST   /api/fiscal/documents                    # Crea documento fiscale
GET    /api/fiscal/documents/{id}               # Dettagli documento
GET    /api/fiscal/documents?folio_id=X         # Documenti per folio
POST   /api/fiscal/invoices/preview             # Preview fattura
POST   /api/fiscal/invoices/emit                # Emetti fattura
POST   /api/fiscal/receipts/emit                # Emetti ricevuta
POST   /api/fiscal/credit-notes                 # Nota credito
GET    /api/fiscal/daily-close                  # Chiusura giornaliera
POST   /api/fiscal/rt/status                    # Status RT
GET    /api/accounting/export                   # Export contabilità
```

---

#### C. SDI Integration (Partner API)

**Opzioni Partner Raccomandati:**

| Partner | Pro | Contro | Costo/mese |
|---------|-----|--------|------------|
| **Aruba** | Leader mercato, affidabile | Costo medio-alto | €15-25 |
| **Infocert** | Certificazione forte | Interface complessa | €20-30 |
| **TeamSystem** | Ecosistema hotel | Lock-in parziale | €10-20 |
| **Fatture in Cloud** | API moderne, SMB-friendly | Meno enterprise | €8-15 |

**Raccomandazione INIZIALE: Fatture in Cloud**
- API RESTful moderne
- Pricing SMB-friendly
- Documentazione ottima
- Support italiano

**Client Implementation:**

```python
# backend/modules/fiscal/integrations/sdi_client.py

from typing import Optional
import httpx
from datetime import datetime

class SDIClient:
    """
    Client per invio fatture a SDI tramite partner
    """

    def __init__(self, api_key: str, base_url: str):
        self.api_key = api_key
        self.base_url = base_url
        self.client = httpx.AsyncClient(
            headers={"Authorization": f"Bearer {api_key}"}
        )

    async def send_invoice(self, xml_content: str, metadata: dict) -> dict:
        """
        Invia fattura XML a SDI via partner

        Args:
            xml_content: XML FatturaPA
            metadata: {invoice_number, date, customer, etc}

        Returns:
            {
                "status": "sent" | "accepted" | "rejected",
                "sdi_id": "...",
                "tracking_url": "...",
                "errors": [...]
            }
        """
        response = await self.client.post(
            f"{self.base_url}/invoices/send",
            json={
                "xml": xml_content,
                "metadata": metadata
            }
        )

        if response.status_code == 200:
            return response.json()
        else:
            raise SDIException(f"Errore invio SDI: {response.text}")

    async def get_invoice_status(self, sdi_id: str) -> dict:
        """
        Verifica stato fattura su SDI

        Returns:
            {
                "status": "sent" | "delivered" | "rejected" | "accepted",
                "updated_at": "2026-01-16T10:30:00Z",
                "sdi_notifications": [...]
            }
        """
        response = await self.client.get(
            f"{self.base_url}/invoices/{sdi_id}/status"
        )
        return response.json()

    async def download_sdi_notification(self, notification_id: str) -> bytes:
        """
        Download notifica SDI (accettazione/rifiuto)
        """
        response = await self.client.get(
            f"{self.base_url}/notifications/{notification_id}/download"
        )
        return response.content
```

---

#### D. RT Integration (Middleware)

**Opzioni:**

1. **Sviluppo Driver Custom** (sconsigliato inizialmente)
   - ❌ Tempo sviluppo alto
   - ❌ Manutenzione multipla (ogni marca)
   - ✅ Controllo totale

2. **Middleware di Terze Parti** (RACCOMANDATO)
   - ✅ Supporto multi-marca
   - ✅ Manutenzione gestita
   - ✅ Time-to-market rapido
   - ❌ Costo licenza

3. **Partnership con Vendor RT** (medio termine)
   - ✅ Integrazione ottimizzata
   - ✅ Support diretto
   - ❌ Single-vendor (Epson o Custom)

**Raccomandazione MVP: Middleware esistente**

Opzioni da valutare:
- **Custom Engineering** (fornitore RT Custom, middleware disponibile)
- **Epson ePOS SDK** (se focus solo Epson)
- **TeamSystem RT Integration** (se partnership)

**Client Implementation (Generic Middleware):**

```python
# backend/modules/fiscal/integrations/rt_middleware.py

from typing import Optional, Literal
from datetime import date

class RTMiddleware:
    """
    Client per Registratore Telematico via middleware
    """

    def __init__(self, middleware_url: str, rt_serial: str):
        self.middleware_url = middleware_url
        self.rt_serial = rt_serial

    async def print_receipt(
        self,
        lines: list[dict],
        total: float,
        payment_method: Literal["CASH", "CARD", "MIXED"],
        customer_tax_code: Optional[str] = None
    ) -> dict:
        """
        Stampa scontrino fiscale

        Args:
            lines: [{"description": "Camera 101", "amount": 150.00, "vat": 10}]
            total: totale scontrino
            payment_method: metodo pagamento
            customer_tax_code: CF cliente (opzionale)

        Returns:
            {
                "receipt_number": 123,
                "fiscal_number": "2026/001/00123",
                "date": "2026-01-16",
                "total": 150.00,
                "status": "printed"
            }
        """
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{self.middleware_url}/rt/{self.rt_serial}/print",
                json={
                    "type": "RECEIPT",
                    "lines": lines,
                    "total": total,
                    "payment": payment_method,
                    "customer_tax_code": customer_tax_code
                }
            )

            if response.status_code == 200:
                return response.json()
            else:
                raise RTException(f"Errore stampa RT: {response.text}")

    async def print_invoice(
        self,
        invoice_data: dict
    ) -> dict:
        """
        Stampa fattura tramite RT
        (meno comune, ma alcuni RT lo supportano)
        """
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{self.middleware_url}/rt/{self.rt_serial}/print",
                json={
                    "type": "INVOICE",
                    "data": invoice_data
                }
            )
            return response.json()

    async def daily_close(self, date: Optional[date] = None) -> dict:
        """
        Chiusura fiscale giornaliera

        Returns:
            {
                "date": "2026-01-16",
                "receipts_count": 45,
                "total_amount": 6750.00,
                "vat_breakdown": {...},
                "status": "closed"
            }
        """
        target_date = date or date.today()

        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{self.middleware_url}/rt/{self.rt_serial}/daily-close",
                json={"date": str(target_date)}
            )
            return response.json()

    async def get_status(self) -> dict:
        """
        Status RT (online, carta, memoria, etc.)

        Returns:
            {
                "online": true,
                "paper_status": "OK" | "LOW" | "OUT",
                "memory_used": 45.2,  # %
                "last_receipt": 123,
                "fiscal_memory_id": "..."
            }
        """
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{self.middleware_url}/rt/{self.rt_serial}/status"
            )
            return response.json()

    async def cancel_document(self, doc_number: int, reason: str) -> dict:
        """
        Annulla documento fiscale (emette annullo)
        """
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{self.middleware_url}/rt/{self.rt_serial}/cancel",
                json={
                    "document_number": doc_number,
                    "reason": reason
                }
            )
            return response.json()

    async def reprint_duplicate(self, doc_number: int) -> dict:
        """
        Ristampa duplicato (non fiscale)
        """
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{self.middleware_url}/rt/{self.rt_serial}/reprint",
                json={"document_number": doc_number}
            )
            return response.json()
```

---

#### E. Accounting Export

**Formati da Supportare (MVP):**

1. **CSV Standard** (sempre)
2. **Excel** (opzionale ma utile)
3. **API JSON** (per integrazioni custom)

**Formati Specifici (Fase 2):**

4. **Zucchetti Spring** (molto diffuso)
5. **TeamSystem** (diffuso)
6. **Generico XML** (configurabile)

**Implementation:**

```python
# backend/modules/fiscal/integrations/accounting_export.py

from datetime import date
import csv
import io
from typing import Literal

class AccountingExporter:
    """
    Export dati fiscali per contabilità
    """

    def __init__(self, db_session):
        self.db = db_session

    async def export_csv(
        self,
        start_date: date,
        end_date: date,
        detail_level: Literal["summary", "detailed"] = "summary"
    ) -> bytes:
        """
        Export CSV standard

        Summary format:
        Data,Numero,Tipo,Cliente,Totale,IVA,Imponibile,Pagamento

        Detailed format:
        Data,Numero,Tipo,Cliente,Categoria,Descrizione,Qty,Unitario,Totale,AliquotaIVA,IVA
        """

        # Query documenti fiscali nel periodo
        documents = await self.db.query(
            FiscalDocument
        ).filter(
            FiscalDocument.date >= start_date,
            FiscalDocument.date <= end_date
        ).all()

        # Generate CSV
        output = io.StringIO()
        writer = csv.writer(output)

        if detail_level == "summary":
            # Header
            writer.writerow([
                "Data", "Numero", "Tipo", "Cliente",
                "Totale", "IVA", "Imponibile", "Pagamento", "Note"
            ])

            # Rows
            for doc in documents:
                writer.writerow([
                    doc.date.isoformat(),
                    doc.number,
                    doc.type,
                    doc.customer_name,
                    f"{doc.total:.2f}",
                    f"{doc.vat_amount:.2f}",
                    f"{doc.taxable_amount:.2f}",
                    doc.payment_method,
                    doc.notes or ""
                ])

        else:  # detailed
            # Header
            writer.writerow([
                "Data", "Numero", "Tipo", "Cliente", "Categoria",
                "Descrizione", "Quantità", "Unitario", "Totale",
                "AliquotaIVA", "IVA"
            ])

            # Rows (ogni riga documento)
            for doc in documents:
                for line in doc.lines:
                    writer.writerow([
                        doc.date.isoformat(),
                        doc.number,
                        doc.type,
                        doc.customer_name,
                        line.category,
                        line.description,
                        line.quantity,
                        f"{line.unit_price:.2f}",
                        f"{line.total:.2f}",
                        f"{line.vat_rate}%",
                        f"{line.vat_amount:.2f}"
                    ])

        return output.getvalue().encode('utf-8')

    async def export_json_api(
        self,
        start_date: date,
        end_date: date
    ) -> dict:
        """
        Export JSON per API integration

        Returns:
        {
            "period": {"start": "...", "end": "..."},
            "documents": [...],
            "summary": {
                "total_documents": 45,
                "total_amount": 23500.00,
                "total_vat": 4320.00,
                "by_type": {...},
                "by_vat_rate": {...}
            }
        }
        """
        documents = await self.db.query(FiscalDocument).filter(...).all()

        return {
            "period": {
                "start": start_date.isoformat(),
                "end": end_date.isoformat()
            },
            "documents": [doc.to_dict() for doc in documents],
            "summary": self._calculate_summary(documents)
        }

    def _calculate_summary(self, documents):
        """Calcola statistiche export"""
        total_amount = sum(d.total for d in documents)
        total_vat = sum(d.vat_amount for d in documents)

        by_type = {}
        for doc in documents:
            by_type[doc.type] = by_type.get(doc.type, 0) + 1

        return {
            "total_documents": len(documents),
            "total_amount": total_amount,
            "total_vat": total_vat,
            "by_type": by_type
        }
```

---

## 2. WORKFLOW CHECKOUT - IMPLEMENTAZIONE

### 2.1 Il Flusso 3-Click

**Step 1: SELECT FOLIO (1 click)**

```tsx
// src/components/checkout/CheckoutFlow.tsx

const CheckoutFlow = () => {
  const [step, setStep] = useState<'select' | 'review' | 'document' | 'confirm'>('select')

  // Step 1: Lista folii da chiudere oggi
  if (step === 'select') {
    return (
      <FolioList
        date={today}
        onSelect={(folio) => {
          setSelectedFolio(folio)
          setStep('review')  // Auto-advance
        }}
      />
    )
  }

  // Step 2: Review (auto-display, no click)
  if (step === 'review') {
    return (
      <FolioReview
        folio={selectedFolio}
        onNext={() => setStep('document')}
      />
    )
  }

  // Step 3: Document Selection (1 click)
  if (step === 'document') {
    return (
      <DocumentSelector
        folio={selectedFolio}
        onSelect={(docType) => {
          setDocumentType(docType)
          setStep('confirm')
        }}
      />
    )
  }

  // Step 4: Confirm (1 click)
  if (step === 'confirm') {
    return (
      <CheckoutConfirmation
        folio={selectedFolio}
        documentType={documentType}
        onConfirm={handleCheckout}
      />
    )
  }
}
```

**TOTALE: 3 click (select folio → select doc → confirm)**

---

### 2.2 Smart Document Suggestion

```tsx
// src/components/checkout/DocumentSelector.tsx

const DocumentSelector = ({ folio, onSelect }) => {
  // Smart suggestion logic
  const suggestedType = useMemo(() => {
    const guest = folio.guest

    if (guest.company && guest.vatNumber) {
      return 'INVOICE'  // Azienda con P.IVA
    } else if (guest.requestedInvoice || guest.fiscalCode) {
      return 'FISCAL_RECEIPT_INTEGRATED'  // Privato che vuole dati fiscali
    } else {
      return 'FISCAL_RECEIPT'  // Privato standard
    }
  }, [folio])

  const [selectedType, setSelectedType] = useState(suggestedType)

  return (
    <div className="space-y-4">
      <h3>Tipo Documento</h3>

      {/* Option 1: Ricevuta Fiscale */}
      <RadioOption
        value="FISCAL_RECEIPT"
        checked={selectedType === 'FISCAL_RECEIPT'}
        onChange={setSelectedType}
        label="Ricevuta Fiscale"
        description="Per privati senza richiesta dati fiscali"
      />

      {/* Option 2: Ricevuta Integrata */}
      <RadioOption
        value="FISCAL_RECEIPT_INTEGRATED"
        checked={selectedType === 'FISCAL_RECEIPT_INTEGRATED'}
        onChange={setSelectedType}
        label="Ricevuta Fiscale Integrata"
        description="Con codice fiscale cliente"
      />

      {/* Option 3: Fattura (SUGGESTED) */}
      <RadioOption
        value="INVOICE"
        checked={selectedType === 'INVOICE'}
        onChange={setSelectedType}
        label="Fattura"
        description="Per aziende/professionisti con P.IVA"
        badge={suggestedType === 'INVOICE' ? 'SUGGERITO' : null}
        badgeColor="blue"
      />

      {/* Suggestion hint */}
      {suggestedType === 'INVOICE' && (
        <Alert variant="info">
          Cliente azienda (P.IVA presente) → Fattura consigliata
        </Alert>
      )}

      <Button onClick={() => onSelect(selectedType)}>
        Continua
      </Button>
    </div>
  )
}
```

---

### 2.3 Fiscal Preview Component

```tsx
// src/components/checkout/FiscalPreview.tsx

const FiscalPreview = ({ folio, documentType }) => {
  const { data: preview } = useQuery({
    queryKey: ['fiscal-preview', folio.id, documentType],
    queryFn: () => api.post('/api/fiscal/invoices/preview', {
      folio_id: folio.id,
      document_type: documentType,
      customer_data: folio.guest
    })
  })

  if (!preview) return <LoadingSpinner />

  return (
    <div className="border rounded-lg p-6 space-y-4">
      <h3 className="text-lg font-semibold">
        Anteprima {preview.document_type_label}
      </h3>

      {/* Header */}
      <div className="grid grid-cols-2 gap-4 text-sm">
        <div>
          <Label>Numero</Label>
          <Value>{preview.number}</Value>
        </div>
        <div>
          <Label>Data</Label>
          <Value>{formatDate(preview.date)}</Value>
        </div>
        <div>
          <Label>Cliente</Label>
          <Value>{preview.customer_name}</Value>
        </div>
        {preview.customer_vat && (
          <div>
            <Label>P.IVA</Label>
            <Value>{preview.customer_vat}</Value>
          </div>
        )}
      </div>

      {/* Lines */}
      <table className="w-full text-sm">
        <thead>
          <tr className="border-b">
            <th className="text-left">Descrizione</th>
            <th className="text-right">Qty</th>
            <th className="text-right">Unitario</th>
            <th className="text-right">Totale</th>
            <th className="text-right">IVA</th>
          </tr>
        </thead>
        <tbody>
          {preview.lines.map((line, i) => (
            <tr key={i} className="border-b">
              <td>{line.description}</td>
              <td className="text-right">{line.quantity}</td>
              <td className="text-right">€{line.unit_price}</td>
              <td className="text-right">€{line.total}</td>
              <td className="text-right">{line.vat_rate}%</td>
            </tr>
          ))}
        </tbody>
      </table>

      {/* Totals */}
      <div className="border-t pt-4 space-y-2">
        <div className="flex justify-between">
          <span>Imponibile</span>
          <span>€{preview.taxable_amount}</span>
        </div>
        <div className="flex justify-between">
          <span>IVA</span>
          <span>€{preview.vat_amount}</span>
        </div>
        <div className="flex justify-between font-bold text-lg">
          <span>TOTALE</span>
          <span>€{preview.total}</span>
        </div>
      </div>

      {/* Validation errors (if any) */}
      {preview.validation_errors?.length > 0 && (
        <Alert variant="error">
          <ul>
            {preview.validation_errors.map((err, i) => (
              <li key={i}>{err}</li>
            ))}
          </ul>
        </Alert>
      )}
    </div>
  )
}
```

---

### 2.4 Checkout Confirmation

```tsx
// src/components/checkout/CheckoutConfirmation.tsx

const CheckoutConfirmation = ({ folio, documentType, onConfirm }) => {
  const [isProcessing, setIsProcessing] = useState(false)
  const [sendEmail, setSendEmail] = useState(
    folio.guest.email ? true : false
  )

  const handleConfirm = async () => {
    setIsProcessing(true)

    try {
      // 1. Emit fiscal document
      const doc = await api.post('/api/fiscal/documents', {
        folio_id: folio.id,
        document_type: documentType,
        send_email: sendEmail
      })

      // 2. Complete checkout
      await api.post(`/api/folios/${folio.id}/checkout`, {
        fiscal_document_id: doc.id
      })

      // 3. Success feedback
      toast.success(`Check-out completato! ${doc.type_label} n. ${doc.number}`)

      // 4. Navigate to summary
      onConfirm(doc)

    } catch (error) {
      toast.error(`Errore: ${error.message}`)
    } finally {
      setIsProcessing(false)
    }
  }

  return (
    <div className="space-y-6">
      <h2>Conferma Check-out</h2>

      {/* Preview documento */}
      <FiscalPreview folio={folio} documentType={documentType} />

      {/* Email option */}
      <Checkbox
        checked={sendEmail}
        onChange={setSendEmail}
        label="Invia documento via email"
        disabled={!folio.guest.email}
      />

      {/* Actions */}
      <div className="flex gap-4">
        <Button variant="outline" onClick={() => history.back()}>
          Indietro
        </Button>
        <Button
          onClick={handleConfirm}
          loading={isProcessing}
          disabled={isProcessing}
        >
          Conferma e Check-out
        </Button>
      </div>
    </div>
  )
}
```

---

## 3. MODELLI DATI

### 3.1 Database Schema

```sql
-- Tabella documenti fiscali
CREATE TABLE fiscal_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hotel_id UUID NOT NULL REFERENCES hotels(id),
    folio_id UUID REFERENCES folios(id),

    -- Identificazione documento
    type VARCHAR(50) NOT NULL,  -- INVOICE, FISCAL_RECEIPT, CREDIT_NOTE, etc.
    number VARCHAR(50) NOT NULL,  -- Numero progressivo
    date DATE NOT NULL,
    fiscal_year INTEGER NOT NULL,

    -- Cliente
    customer_name VARCHAR(255) NOT NULL,
    customer_vat VARCHAR(20),  -- P.IVA
    customer_tax_code VARCHAR(20),  -- Codice Fiscale
    customer_address TEXT,
    customer_sdi_code VARCHAR(7),  -- Codice destinatario SDI
    customer_pec VARCHAR(255),

    -- Importi
    taxable_amount DECIMAL(10,2) NOT NULL,
    vat_amount DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,

    -- Metadati
    payment_method VARCHAR(50),
    notes TEXT,

    -- SDI integration
    sdi_id VARCHAR(100),  -- ID su sistema SDI partner
    sdi_status VARCHAR(50),  -- sent, delivered, accepted, rejected
    sdi_sent_at TIMESTAMP,
    sdi_delivered_at TIMESTAMP,

    -- RT integration
    rt_receipt_number INTEGER,  -- Numero scontrino RT
    rt_fiscal_number VARCHAR(50),  -- Numero fiscale RT
    rt_printed_at TIMESTAMP,

    -- XML fattura (se INVOICE)
    xml_content TEXT,

    -- Audit
    created_at TIMESTAMP DEFAULT NOW(),
    created_by UUID REFERENCES users(id),
    cancelled_at TIMESTAMP,
    cancelled_by UUID REFERENCES users(id),
    cancellation_reason TEXT,

    -- Indexes
    UNIQUE(hotel_id, type, number, fiscal_year)
);

-- Tabella righe documento
CREATE TABLE fiscal_document_lines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID NOT NULL REFERENCES fiscal_documents(id) ON DELETE CASCADE,

    line_number INTEGER NOT NULL,
    category VARCHAR(50),  -- ROOM, FB, EXTRA, TAX, etc.
    description VARCHAR(255) NOT NULL,
    quantity DECIMAL(10,2) NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    vat_rate DECIMAL(5,2) NOT NULL,
    vat_amount DECIMAL(10,2) NOT NULL,

    -- Reference a folio line (opzionale)
    folio_line_id UUID REFERENCES folio_lines(id),

    UNIQUE(document_id, line_number)
);

-- Tabella storico SDI
CREATE TABLE sdi_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID NOT NULL REFERENCES fiscal_documents(id),

    notification_type VARCHAR(50),  -- acceptance, delivery, rejection
    notification_date TIMESTAMP NOT NULL,
    notification_content TEXT,  -- XML notifica SDI
    file_url VARCHAR(500),

    created_at TIMESTAMP DEFAULT NOW()
);

-- Tabella chiusure giornaliere RT
CREATE TABLE rt_daily_closes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hotel_id UUID NOT NULL REFERENCES hotels(id),
    rt_serial VARCHAR(50) NOT NULL,

    close_date DATE NOT NULL,
    receipts_count INTEGER NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    vat_breakdown JSONB,  -- {"10": 450.00, "22": 120.00, ...}

    closed_at TIMESTAMP NOT NULL,
    transmitted_at TIMESTAMP,  -- Trasmissione ad Agenzia Entrate
    transmission_status VARCHAR(50),

    UNIQUE(hotel_id, rt_serial, close_date)
);
```

---

### 3.2 Pydantic Models (Backend)

```python
# backend/modules/fiscal/models.py

from pydantic import BaseModel, Field
from datetime import date, datetime
from typing import Optional, Literal
from decimal import Decimal

class FiscalDocumentLine(BaseModel):
    """Riga documento fiscale"""
    line_number: int
    category: str  # ROOM, FB, EXTRA, TAX
    description: str
    quantity: Decimal = Decimal("1")
    unit_price: Decimal
    total: Decimal
    vat_rate: Decimal
    vat_amount: Decimal
    folio_line_id: Optional[str] = None

class FiscalDocument(BaseModel):
    """Documento fiscale (fattura, ricevuta, etc.)"""
    id: str
    hotel_id: str
    folio_id: Optional[str]

    # Type
    type: Literal[
        "INVOICE",
        "FISCAL_RECEIPT",
        "FISCAL_RECEIPT_INTEGRATED",
        "CREDIT_NOTE",
        "ADVANCE_RECEIPT"
    ]
    number: str
    date: date
    fiscal_year: int

    # Customer
    customer_name: str
    customer_vat: Optional[str] = None
    customer_tax_code: Optional[str] = None
    customer_address: Optional[str] = None
    customer_sdi_code: Optional[str] = None
    customer_pec: Optional[str] = None

    # Amounts
    taxable_amount: Decimal
    vat_amount: Decimal
    total: Decimal

    # Lines
    lines: list[FiscalDocumentLine]

    # Metadata
    payment_method: Optional[str]
    notes: Optional[str]

    # SDI
    sdi_id: Optional[str] = None
    sdi_status: Optional[str] = None
    sdi_sent_at: Optional[datetime] = None

    # RT
    rt_receipt_number: Optional[int] = None
    rt_fiscal_number: Optional[str] = None
    rt_printed_at: Optional[datetime] = None

    # XML
    xml_content: Optional[str] = None

    # Audit
    created_at: datetime
    created_by: str
    cancelled_at: Optional[datetime] = None
    cancellation_reason: Optional[str] = None

class FiscalDocumentCreate(BaseModel):
    """Request creazione documento fiscale"""
    folio_id: str
    document_type: Literal[
        "INVOICE",
        "FISCAL_RECEIPT",
        "FISCAL_RECEIPT_INTEGRATED"
    ]

    # Customer data override (opzionale)
    customer_name: Optional[str] = None
    customer_vat: Optional[str] = None
    customer_tax_code: Optional[str] = None
    customer_sdi_code: Optional[str] = None
    customer_pec: Optional[str] = None

    # Options
    send_email: bool = False
    print_receipt: bool = True  # Stampa RT

class FiscalDocumentPreview(BaseModel):
    """Preview documento prima emissione"""
    document_type: str
    document_type_label: str
    number: str  # Prossimo numero disponibile
    date: date
    customer_name: str
    customer_vat: Optional[str]
    lines: list[FiscalDocumentLine]
    taxable_amount: Decimal
    vat_amount: Decimal
    total: Decimal
    validation_errors: list[str] = []
```

---

## 4. ROADMAP IMPLEMENTAZIONE

### 4.1 Fase 1: MVP (4-6 settimane)

**Obiettivo:** Checkout funzionante con documenti fiscali base

**Sprint 1: Database + Backend Core (2 settimane)**
- [ ] Schema database fiscal_documents
- [ ] Models Pydantic
- [ ] FiscalService (orchestrator)
- [ ] Validators (P.IVA, CF, SDI code)
- [ ] API endpoints base (create, preview, list)
- [ ] Test unitari

**Sprint 2: Frontend Checkout (2 settimane)**
- [ ] CheckoutFlow component
- [ ] FolioReview component
- [ ] DocumentSelector (smart suggestions)
- [ ] FiscalPreview component
- [ ] CheckoutConfirmation
- [ ] Integration API backend
- [ ] Test E2E checkout flow

**Sprint 3: Export Contabilità (1 settimana)**
- [ ] CSV export (summary + detailed)
- [ ] Excel export (opzionale)
- [ ] API endpoint export
- [ ] UI download export
- [ ] Test export formati

**Sprint 4: Testing & Refinement (1 settimana)**
- [ ] Test checkout completo
- [ ] Edge cases (acconti, split billing, etc.)
- [ ] Error handling
- [ ] Performance optimization
- [ ] Documentazione

**DELIVERABLE:**
- ✅ Checkout 3-click funzionante
- ✅ Emissione ricevute/fatture (dati salvati DB)
- ✅ Preview documento
- ✅ Export CSV contabilità
- ⚠️ NO invio SDI (fase 2)
- ⚠️ NO stampa RT (fase 2)

---

### 4.2 Fase 2: SDI Integration (3-4 settimane)

**Obiettivo:** Invio fatture a SDI tramite partner

**Sprint 5: Partner Integration (2 settimane)**
- [ ] Scelta partner SDI (Fatture in Cloud raccomandato)
- [ ] SDIClient implementation
- [ ] XML FatturaPA generator
- [ ] Validazione XML (schema XSD)
- [ ] Test invio fatture
- [ ] Gestione esiti SDI

**Sprint 6: UI SDI Status (1 settimana)**
- [ ] Dashboard status fatture SDI
- [ ] Notifiche esiti (delivered/rejected)
- [ ] Download notifiche SDI
- [ ] Retry invio falliti
- [ ] UI status scontrini fiscali

**Sprint 7: Conservazione (1 settimana)**
- [ ] Storage XML fatture
- [ ] Storage notifiche SDI
- [ ] Archive management (10 anni)
- [ ] Download storico

**DELIVERABLE:**
- ✅ Invio fatture SDI funzionante
- ✅ Tracking status fatture
- ✅ Conservazione documenti
- ✅ Dashboard fiscale

---

### 4.3 Fase 3: RT Integration (4-5 settimane)

**Obiettivo:** Integrazione Registratore Telematico

**Sprint 8: Middleware Integration (2 settimane)**
- [ ] Scelta middleware RT
- [ ] RTMiddleware client implementation
- [ ] Test connessione RT
- [ ] Print receipt implementation
- [ ] Status monitoring RT

**Sprint 9: Daily Close Automation (1 settimana)**
- [ ] Scheduler chiusura giornaliera
- [ ] Verifiche pre-chiusura
- [ ] Gestione errori chiusura
- [ ] Notifiche staff
- [ ] Log chiusure

**Sprint 10: RT UI & Error Handling (2 settimane)**
- [ ] RT status dashboard
- [ ] Error alerts (carta, memoria, etc.)
- [ ] Annullo documenti
- [ ] Ristampa duplicati
- [ ] Gestione correzioni
- [ ] Training materiale

**DELIVERABLE:**
- ✅ Stampa scontrini RT funzionante
- ✅ Chiusura giornaliera automatica
- ✅ Monitoring RT real-time
- ✅ Error handling robusto

---

### 4.4 Fase 4: Optimizations (2-3 settimane)

**Obiettivo:** Miglioramenti UX e performance

**Sprint 11: UX Enhancements (1 settimana)**
- [ ] Dual folio (standard + expense)
- [ ] Memoria preferenze guest
- [ ] Checkout rapido (default smart)
- [ ] Shortcuts tastiera
- [ ] Mobile-friendly refinement

**Sprint 12: Analytics & Reporting (1 settimana)**
- [ ] Dashboard fiscale (totali, breakdown)
- [ ] Report mensili automatici
- [ ] Analytics revenue per categoria
- [ ] Export formati custom (Zucchetti, TeamSystem)
- [ ] Anomaly detection (documenti anomali)

**Sprint 13: Performance & Scale (1 settimana)**
- [ ] Caching smart (documenti recenti)
- [ ] Async processing (invio SDI background)
- [ ] Batch operations (chiusure multiple)
- [ ] Database optimization
- [ ] Load testing

**DELIVERABLE:**
- ✅ UX ottimizzata (< 3 click)
- ✅ Analytics fiscali
- ✅ Performance enterprise-grade
- ✅ Sistema production-ready

---

## 5. DIFFERENZIATORI COMPETITIVI

### 5.1 Cosa Miracollo Fa MEGLIO

**vs Ericsoft:**
- ✅ UX moderna cloud-native (vs tradizionale)
- ✅ API aperte (vs lock-in Zucchetti)
- ✅ Mobile-first (vs desktop-centric)
- ✅ Real-time analytics (vs report batch)

**vs Mews:**
- ✅ Workflow veloce 3-click (vs 10+ click)
- ✅ Fiscalità italiana nativa (vs partner required)
- ✅ RT integration built-in (vs external)
- ✅ Operatori reception-friendly (vs complesso)

**vs Opera/Protel:**
- ✅ Costo accessibile SMB (vs enterprise pricing)
- ✅ Setup semplice (vs complessità enterprise)
- ✅ Italia-first (vs global-generic)
- ✅ Support diretto (vs support tiers)

**vs Cloudbeds:**
- ✅ Fiscalità italiana nativa (vs partner-based)
- ✅ RT direct integration (vs API-only)
- ✅ Feature set più ricco (vs SMB basic)
- ✅ Analytics avanzate

---

### 5.2 Unique Selling Points (USP)

**Per Hotel Italiani:**

1. **"L'unico PMS cloud-native con fiscalità italiana nativa"**
   - RT + SDI integrati (no partner obbligatori)
   - Normativa 2026 ready (RT-POS collegamento)
   - Support italiano diretto

2. **"Checkout in 3 click, non 10"**
   - Workflow ottimizzato reception
   - Smart suggestions automatiche
   - Training staff: 30 minuti (vs giorni)

3. **"API aperte, zero lock-in"**
   - Cambi contabile? Nessun problema
   - Cambi RT? Supportato
   - Export illimitati, formati multipli

4. **"Pricing trasparente SMB"**
   - No costi nascosti moduli fiscali
   - SDI/RT inclusi nel prezzo base
   - Scale con te (da 5 a 500 camere)

---

## 6. DECISIONI DA PRENDERE

### 6.1 Partner SDI - Scelta Finale

**Opzioni analizzate:**

| Partner | Pro | Contro | Raccomandazione |
|---------|-----|--------|-----------------|
| Fatture in Cloud | API moderne, SMB-friendly, €8-15/mese | Meno enterprise | ⭐ **RACCOMANDATO MVP** |
| Aruba | Leader, affidabile, €15-25/mese | Costo più alto | Fase 2 opzione |
| TeamSystem | Ecosistema hotel, €10-20/mese | Lock-in parziale | Se partnership |
| Infocert | Enterprise-grade, €20-30/mese | Overkill SMB | Solo se target enterprise |

**DECISIONE RICHIESTA:**
- Iniziare con Fatture in Cloud (MVP)?
- Oppure multi-partner support da subito?

---

### 6.2 RT Middleware - Scelta Finale

**Opzioni:**

1. **Custom Engineering (vendor RT Custom)**
   - PRO: Integrazione ottimizzata
   - CONTRO: Single-vendor (solo Custom)

2. **Epson ePOS SDK**
   - PRO: Supporto Epson diretto
   - CONTRO: Solo Epson (limitato)

3. **Middleware generico (custom build)**
   - PRO: Multi-marca, controllo totale
   - CONTRO: Sviluppo + manutenzione alto

4. **Partnership con TeamSystem Cassa in Cloud**
   - PRO: Multi-marca, cloud-based, gestito
   - CONTRO: Costo licenza, dipendenza

**DECISIONE RICHIESTA:**
- Quale approccio per MVP?
- Budget disponibile per licenze middleware?

---

### 6.3 Scope MVP - Finale

**Inclusioni MVP (MUST):**
- ✅ Checkout 3-click
- ✅ Emissione ricevute/fatture (DB)
- ✅ Preview documento
- ✅ Export CSV contabilità

**Esclusioni MVP (Fase 2):**
- ⚠️ Invio SDI (manuale export XML interim)
- ⚠️ Stampa RT (documento PDF interim)
- ⚠️ Chiusura automatica (manuale interim)

**DECISIONE RICHIESTA:**
- MVP slim (4-6 settimane) o MVP full (8-10 settimane)?
- Priorità: time-to-market o feature complete?

---

## 7. PROSSIMI STEP SUGGERITI

### Immediati (Questa Settimana)

1. **Decisione Architettura**
   - Conferma Pattern B (API-first + Partner)
   - Approva stack tecnologico

2. **Partner Selection**
   - Test account Fatture in Cloud
   - Valuta alternative (Aruba, TeamSystem)
   - Scelta finale partner SDI

3. **RT Strategy**
   - Contatta vendor middleware (Custom, TeamSystem)
   - Richiedi demo/pricing
   - Scelta finale approccio RT

4. **Scope MVP**
   - Decide inclusioni/esclusioni
   - Timeline target (4-6 weeks? 8-10 weeks?)

### Settimana Prossima

5. **Design Review**
   - Valida database schema
   - Review API endpoints
   - Approva componenti UI

6. **Sprint Planning**
   - Breakdown task Sprint 1
   - Assegnazione worker (backend/frontend)
   - Setup project tracking

### Mese 1

7. **Sviluppo Sprint 1-2**
   - Backend fiscal module
   - Frontend checkout flow
   - Integration testing

---

## CONCLUSIONI

Questa ricerca ha analizzato **6 PMS competitor** identificando:

✅ **Best Practices** - Workflow 3-click, smart suggestions, error prevention
✅ **Anti-Pattern** - Evitare 10+ click (Mews), vendor lock-in eccessivo
✅ **Architettura Consigliata** - API-first + Partner (flessibilità + compliance)
✅ **Roadmap Chiara** - MVP 4-6 settimane, full feature 12-15 settimane

**Miracollo può differenziarsi** combinando:
- UX moderna cloud-native (vs Ericsoft/Sysdat tradizionali)
- Workflow veloce 3-click (vs Mews complesso)
- Fiscalità italiana nativa (vs Opera/Protel/Mews generic)
- Pricing SMB accessibile (vs enterprise Opera/Protel)

**La chiave del successo:** Implementare il modulo fiscale come i competitor enterprise (Opera/Ericsoft) ma con UX cloud-native moderna e pricing accessibile.

---

**Prossima Azione:** Decisioni partner (SDI + RT) + Kickoff Sprint 1

*Fine Parte 3 - Ricerca Completa*
