# RICERCA: Fatturazione Elettronica Italiana per Hotel - 2026

**Data**: 16 Gennaio 2026
**Researcher**: Cervella Researcher
**Progetto**: Miracollo PMS

---

## TL;DR - EXECUTIVE SUMMARY

**Status**: ✅ RICERCA COMPLETATA

**Raccomandazione Principale**:
- Usare libreria Python **python-a38** per generazione XML FatturaPA
- IVA alberghiera al **10%** per pernottamenti
- Fattura solo su richiesta cliente, altrimenti corrispettivo telematico
- Conservazione sostitutiva obbligatoria (10 anni)

**Complessità Implementazione**: MEDIA (ben documentato, librerie esistenti)

---

## 1. NORMATIVA FATTURAZIONE ELETTRONICA HOTEL

### Obbligo Fattura Elettronica

**Chi deve emetterla:**
- Hotel con partita IVA (attività imprenditoriale)
- Dal 2019 obbligo per B2B (fatture ad altre aziende, agenzie viaggi)
- B2C (privati): fattura SOLO SE RICHIESTA dal cliente

**Quando emettere:**
- Su richiesta cliente
- Sempre per soggetti con P.IVA (agenzie, aziende)
- Possibile emissione differita entro 15° giorno mese successivo

**Alternative alla fattura:**
- Corrispettivo telematico (scontrino elettronico)
- Ricevuta fiscale (per privati che non richiedono fattura)

**Novità 2026:**
- Obbligo POS collegato a registratore telematico (dal 1° gennaio 2026)
- Perfetta corrispondenza tra incassi POS e ricavi trasmessi

### Regime IVA Alberghiero

**Aliquote applicabili:**

| Servizio | Aliquota | Normativa |
|----------|----------|-----------|
| **Pernottamento** | **10%** | Tabella A/3 Parte III DPR 633/1972 |
| **Pernottamento + colazione** | **10%** | Incluso nel servizio alloggio |
| **Servizi accessori** (spa, sala conferenze) | **22%** | Servizi separati dall'alloggio |

**Note importanti:**
- Aliquota 10% indipendente da categoria hotel (anche lusso)
- Nessuna modifica prevista per 2026

---

## 2. FORMATO XML FatturaPA

### Versione Attuale

**Specifiche Tecniche**: v1.9 (dal 1° aprile 2025)
**Schema XML**: FatturaPA v1.2.3

### Campi Obbligatori

**Blocco Cedente/Prestatore (Hotel):**
```
- Partita IVA (IT + 11 cifre)
- Codice Fiscale
- Denominazione o Nome/Cognome
- Regime Fiscale (es. RF01 = ordinario)
- Sede: indirizzo, cap, comune, provincia, nazione
```

**Blocco Cessionario/Committente (Cliente):**
```
- Partita IVA o Codice Fiscale
- Denominazione o Nome/Cognome
- Codice Destinatario SDI
- Indirizzo (se B2B)
```

**Dettaglio Documento:**
```
- Tipo Documento (TD01 = fattura, TD04 = nota credito)
- Data e Numero progressivo
- Righe di dettaglio (descrizione, quantità, prezzo, IVA)
- Totali IVA per aliquota
- Importo totale documento
```

### Codice Destinatario SDI

| Tipo Cliente | Codice |
|--------------|--------|
| **Privati italiani** | **0000000** (7 zeri) |
| **PA (Pubblica Amministrazione)** | Codice Univoco Ufficio |
| **Aziende con canale PEC** | Codice a 7 caratteri (se fornito) |
| **Clienti esteri** | **XXXXXXX** (7 X) |

**Come funziona:**
- Se codice = 0000000 → fattura in area riservata Agenzia Entrate
- Cliente deve scaricarla da portale "Fatture e Corrispettivi"

---

## 3. SDI - SISTEMA DI INTERSCAMBIO

### Flusso Operativo

```
1. Hotel genera XML FatturaPA
2. Invia a SDI (diretto o tramite intermediario)
3. SDI valida XML (controlli formali)
   - Se OK → consegna al destinatario
   - Se KO → scarta con codice errore
4. SDI invia ricevuta a hotel (5 giorni max)
5. Hotel conserva fattura + ricevute
```

### Tempi di Risposta

- **Validazione iniziale**: pochi secondi
- **Notifica scarto**: entro 5 giorni
- **Consegna**: entro 5 giorni

### Gestione Errori e Scarti

**Errori comuni:**
- Codice destinatario errato
- P.IVA/CF invalidi
- Errori di calcolo IVA
- XML malformato

**Procedura in caso di scarto:**
1. SDI invia "ricevuta di scarto" con codice errore
2. Hotel ha **5 giorni** per correggere
3. Riemettere fattura con **stessa data e numero**
4. Cambiare nome file XML

**Sanzioni:**
- Fattura scartata = "non emessa" fiscalmente
- Sanzioni da €250 a €2000 (dipende da violazione)

### Conservazione Sostitutiva

**Obbligo legale:**
- **10 anni** dalla data ultima registrazione
- Vale per emittente E destinatario
- Processo entro 3 mesi da dichiarazione redditi

**Requisiti:**
- NON basta salvataggio file su PC/cloud
- Servizio di conservazione a norma obbligatorio
- Garantisce integrità e autenticità nel tempo

**Normativa:**
- Art. 2220 Codice Civile
- Art. 39 DPR 633/1972
- D.M. 17 giugno 2014, art. 3 comma 3

---

## 4. FIRMA DIGITALE

### Quando è Obbligatoria

| Destinatario | Obbligo Firma |
|--------------|---------------|
| **PA (Pubblica Amministrazione)** | **SÌ** (obbligatorio) |
| **Privati B2B** | NO (ma consigliato) |

### Chi Può Firmare

- Il contribuente stesso (hotel)
- Software house per conto del cliente

**Vantaggi firma (anche se non obbligatoria):**
- Garantisce integrità dati
- Garantisce autenticità documento
- Best practice per B2B

---

## 5. NOTE DI CREDITO

### Quando Emettere

- Storno fattura errata
- Rimborso parziale/totale cliente
- Variazione prezzo post-emissione

### Formato XML

**Tipo Documento**: TD04
**Stessa struttura** di fattura normale

**Campo cruciale**: `<DatiFattureCollegate>` (tag 2.1.6)
```xml
<DatiFattureCollegate>
  <IdDocumento>123</IdDocumento>
  <Data>2026-01-15</Data>
  <NumItem>1</NumItem>
</DatiFattureCollegate>
```

**Note:**
- Importo positivo (non negativo!)
- Link a fattura originale tramite numero e data
- Stesso flusso SDI di fattura normale

---

## 6. NUMERAZIONE PROGRESSIVA

### Sistemi Consentiti

**1. Progressivo Assoluto:**
- Da 1 a infinito, per tutta vita aziendale
- Es: 1, 2, 3, ... 99999

**2. Progressivo Annuale:** (PIÙ COMUNE)
- Reset ogni anno: 1/2026, 2/2026, ...
- Identificazione garantita da data documento

**3. Continuazione anno precedente:**
- Parte da ultimo numero anno prima
- Es: ultimo 2025 = 450 → primo 2026 = 451

### Numerazione Sezionale (Hotel Multi-Sede)

**Per hotel con più punti vendita/attività:**

```
Sezionale A: 1/2026/A, 2/2026/A, ...
Sezionale B: 1/2026/B, 2/2026/B, ...
```

**Uso tipico:**
- Hotel con più reception
- Ristorante + albergo separati
- Attività distinte con registri separati

**Errori numerazione:**
- NON generano sanzioni (violazione formale)
- Ma EVITARE per pulizia contabile

---

## 7. LIBRERIE PYTHON

### OPZIONE 1: python-a38 (CONSIGLIATA)

**GitHub**: https://github.com/Truelite/python-a38
**PyPI**: `pip install a38`

**Caratteristiche:**
- ✅ Data model dichiarativo (stile Django)
- ✅ Validazione built-in
- ✅ Parse + Generate XML
- ✅ Passa tutti test fatturapa.gov.it
- ✅ Tool CLI incluso (a38tool)
- ✅ Output: JSON, XML, HTML, PDF

**Esempio codice base:**
```python
import a38
from a38.validation import Validation
import datetime

# Cedente (Hotel)
cedente = a38.CedentePrestatore(
    a38.DatiAnagraficiCedentePrestatore(
        a38.IdFiscaleIVA("IT", "01234567890"),
        codice_fiscale="NTNBLN22C23A123U",
        anagrafica=a38.Anagrafica(denominazione="Hotel Example"),
        regime_fiscale="RF01",
    ),
    a38.Sede(
        indirizzo="via Roma",
        numero_civico="1",
        cap="50100",
        comune="Firenze",
        provincia="FI",
        nazione="IT"
    ),
)

# Cessionario (Cliente)
cessionario = a38.CessionarioCommittente(
    a38.DatiAnagraficiCessionario(
        a38.IdFiscaleIVA("IT", "09876543210"),
        anagrafica=a38.Anagrafica(denominazione="Cliente SRL")
    ),
    a38.Sede(
        indirizzo="via Milano",
        numero_civico="10",
        cap="20100",
        comune="Milano",
        provincia="MI",
        nazione="IT"
    )
)

# Fattura
fattura = a38.FatturaPrivati12()
fattura.fattura_elettronica_header = a38.FatturaElettronicaHeader(
    dati_trasmissione=a38.DatiTrasmissione(
        id_trasmittente=a38.IdTrasmittente("IT", "01234567890"),
        progressivo_invio="00001",
        formato_trasmissione="FPR12",
        codice_destinatario="0000000"
    ),
    cedente_prestatore=cedente,
    cessionario_committente=cessionario
)

# Body
body = a38.FatturaElettronicaBody()
body.dati_generali = a38.DatiGenerali(
    dati_generali_documento=a38.DatiGeneraliDocumento(
        tipo_documento="TD01",
        divisa="EUR",
        data=datetime.date.today(),
        numero="1"
    )
)

# Linea dettaglio
linea = a38.DettaglioLinee(
    numero_linea=1,
    descrizione="Pernottamento camera doppia",
    quantita=decimal.Decimal("2"),
    prezzo_unitario=decimal.Decimal("100.00"),
    prezzo_totale=decimal.Decimal("200.00"),
    aliquota_iva=decimal.Decimal("10.00")
)
body.dati_beni_servizi = a38.DatiBeniServizi(
    dettaglio_linee=[linea],
    dati_riepilogo=[
        a38.DatiRiepilogo(
            aliquota_iva=decimal.Decimal("10.00"),
            imponibile_importo=decimal.Decimal("200.00"),
            imposta=decimal.Decimal("20.00")
        )
    ]
)

fattura.fattura_elettronica_body.append(body)

# Validazione
validation = Validation()
fattura.validate(validation)
if validation.warnings or validation.errors:
    print("Errori/Warning:", validation)

# Output XML
xml_content = fattura.build_etree()
```

**CLI tool:**
```bash
# Converti XML in PDF
a38tool pdf -f FatturaOrdinaria.xsl -o fattura.pdf fattura.xml

# Valida XML
a38tool validate fattura.xml

# Converti in JSON
a38tool json fattura.xml
```

### OPZIONE 2: fatturapa-python (Italia/GitHub)

**GitHub**: https://github.com/italia/fatturapa-python

**Caratteristiche:**
- ✅ Tool ufficiale Developers Italia
- ✅ CLI per generazione rapida
- ⚠️ Più semplice ma meno flessibile
- ⚠️ Solo singole fatture base

**Uso:**
```bash
# Generazione da command-line
python FatturaPA-python.py --cedente "..." --cessionario "..."
```

**Quando usarlo:**
- Fatture semplici, occasionali
- Prototipazione veloce

### OPZIONE 3: odoo-addon-l10n-it-fatturapa

**PyPI**: https://pypi.org/project/odoo-addon-l10n-it-fatturapa/

**Caratteristiche:**
- Modulo Odoo ERP
- Solo se si usa già Odoo
- Integrazione completa ERP

---

## 8. SERVIZI INTERMEDIARI

### Confronto Prezzi 2026

| Servizio | Prezzo/anno | API | Note |
|----------|-------------|-----|------|
| **Software Semplice** | €48 + IVA | ❌ No | Più economico |
| **Aruba Base** | €59.80 + IVA | ❌ No | Conservazione inclusa |
| **Aruba Premium** | €600 + IVA + €300 setup | ✅ Sì | API/Webservice |
| **Fatture in Cloud Standard** | €144 + IVA | ⚠️ Limitato | 100 doc/anno |

### ARUBA - Dettaglio Tecnico

**Versione Base (€59.80/anno):**
- Emissione tramite web
- Conservazione sostitutiva inclusa
- Documenti illimitati
- NO API

**Versione Premium (€600/anno + €300 setup):**
- ✅ API/Webservice REST
- ✅ Automazione completa flusso
- ✅ Integrazione PMS senza intervento umano
- ✅ Documenti illimitati

**Valutazione per Miracollo:**
- Premium overkill per fase iniziale
- Base OK per MVP/test
- Valutare Premium quando scaling

### FATTURE IN CLOUD

**Standard (€144/anno):**
- 100 documenti/anno totali
- Superamento limite → upgrade obbligatorio
- API disponibili (ma limiti volumi)

**Valutazione:**
- Costoso per volumi bassi
- Limiti rigidi poco flessibili

### RACCOMANDAZIONE INTERMEDIA

**Fase MVP (0-50 hotel):**
- Implementazione diretta con **python-a38**
- Invio diretto a SDI (gratis, API Agenzia Entrate)
- Conservazione: Aruba Base (€60/anno) o similare

**Fase Scale (50+ hotel):**
- Valutare Aruba Premium (€600/anno)
- API per automazione completa
- Oppure sviluppo interno conservazione a norma

---

## 9. IMPLEMENTAZIONE SUGGERITA PER MIRACOLLO

### Architettura Proposta

```
┌─────────────────────────────────────────────┐
│          MIRACOLLO PMS                      │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │   Modulo Fatturazione                │   │
│  │                                      │   │
│  │  • Genera dati fattura da check-out  │   │
│  │  • Libreria python-a38               │   │
│  │  • Valida XML                        │   │
│  │  • Genera PDF per cliente            │   │
│  └──────────────┬───────────────────────┘   │
│                 │                            │
└─────────────────┼────────────────────────────┘
                  │
                  ▼
         ┌────────────────┐
         │   Invio SDI    │ (API Agenzia Entrate)
         └────────┬───────┘
                  │
                  ▼
         ┌────────────────┐
         │  Conservazione │ (Aruba/servizio esterno)
         └────────────────┘
```

### Step di Implementazione

**FASE 1 - MVP (2-3 settimane):**
1. Installazione python-a38
2. Creazione modello Fattura in DB
3. API endpoint: POST /api/invoices/create
4. Generazione XML da dati check-out
5. Validazione locale XML
6. Output PDF per cliente (via a38tool)

**FASE 2 - Integrazione SDI (1-2 settimane):**
1. Setup credenziali Agenzia Entrate
2. Implementazione invio XML a SDI
3. Gestione ricevute (accettazione/scarto)
4. Logging completo flusso
5. Retry automatico su errori temporanei

**FASE 3 - Conservazione (1 settimana):**
1. Integrazione Aruba API (o altro servizio)
2. Invio fatture + ricevute a conservazione
3. Verifica conservazione avvenuta
4. Dashboard stato conservazione

**FASE 4 - Note di Credito (1 settimana):**
1. Endpoint POST /api/credit-notes/create
2. Link a fattura originale
3. Stesso flusso SDI
4. Notifica cliente

**FASE 5 - Automazione (ongoing):**
1. Auto-emissione fattura su check-out
2. Invio email PDF al cliente
3. Dashboard fatture emesse/da emettere
4. Report fiscali mensili/annuali

### Database Schema Suggerito

```python
class Invoice(Base):
    id = Column(Integer, primary_key=True)
    invoice_number = Column(String)  # es: "1/2026" o "1/2026/A"
    invoice_date = Column(Date)
    invoice_type = Column(String)  # TD01, TD04, etc.

    # Hotel (cedente)
    hotel_id = Column(Integer, ForeignKey('hotels.id'))
    hotel_vat = Column(String)
    hotel_fiscal_code = Column(String)

    # Cliente (cessionario)
    customer_name = Column(String)
    customer_vat = Column(String, nullable=True)
    customer_fiscal_code = Column(String, nullable=True)
    customer_sdi_code = Column(String)  # 0000000, XXXXXXX, etc.
    customer_address = Column(JSON, nullable=True)

    # Dati fattura
    lines = Column(JSON)  # Array righe dettaglio
    subtotal = Column(Numeric(10, 2))
    vat_10_amount = Column(Numeric(10, 2))
    vat_22_amount = Column(Numeric(10, 2), default=0)
    total = Column(Numeric(10, 2))

    # SDI
    xml_content = Column(Text)  # XML generato
    xml_filename = Column(String)
    sdi_status = Column(String)  # pending, sent, accepted, rejected
    sdi_receipt_id = Column(String, nullable=True)
    sdi_error_code = Column(String, nullable=True)
    sdi_sent_at = Column(DateTime, nullable=True)

    # Conservazione
    conservation_status = Column(String)  # pending, conserved
    conservation_id = Column(String, nullable=True)
    conserved_at = Column(DateTime, nullable=True)

    # Link nota credito
    original_invoice_id = Column(Integer, ForeignKey('invoices.id'), nullable=True)

    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, onupdate=datetime.utcnow)
```

### API Endpoints Suggeriti

```
POST   /api/invoices/create              # Crea fattura da check-out
GET    /api/invoices/:id                 # Dettagli fattura
GET    /api/invoices/:id/xml             # Download XML
GET    /api/invoices/:id/pdf             # Download PDF
POST   /api/invoices/:id/send-sdi        # Invia a SDI
GET    /api/invoices/:id/sdi-status      # Verifica stato SDI
POST   /api/invoices/:id/conserve        # Invia a conservazione

POST   /api/credit-notes/create          # Crea nota credito
GET    /api/credit-notes/:id             # Dettagli nota credito

GET    /api/invoices/report/monthly      # Report mensile
GET    /api/invoices/report/annual       # Report annuale
```

---

## 10. CHECKLIST COMPLIANCE

### Prima di Andare in Produzione

- [ ] **Partita IVA hotel** configurata correttamente
- [ ] **Regime fiscale** specificato (RF01 = ordinario)
- [ ] **Aliquote IVA** corrette (10% pernottamenti, 22% extra)
- [ ] **Numerazione progressiva** definita (annuale/assoluta)
- [ ] **Codice destinatario** corretto per tipo cliente
- [ ] **Validazione XML** con python-a38 attiva
- [ ] **Test invio SDI** in ambiente test
- [ ] **Gestione scarti** implementata
- [ ] **Conservazione sostitutiva** attivata
- [ ] **Firma digitale PA** (se si fattura a PA)
- [ ] **Privacy GDPR** - dati cliente in fattura
- [ ] **Backup fatture** + ricevute SDI
- [ ] **Logging completo** per audit
- [ ] **Documentazione** per hotel su come richiedere fattura

---

## 11. RISCHI E MITIGAZIONI

| Rischio | Impatto | Probabilità | Mitigazione |
|---------|---------|-------------|-------------|
| **Scarto SDI per errore XML** | Alto | Media | Validazione locale con python-a38 PRIMA invio |
| **Down servizio conservazione** | Medio | Bassa | Backup locale XML + retry automatico |
| **Cambio normativa** | Alto | Bassa | Monitoraggio Agenzia Entrate + aggiornamento librerie |
| **Errore calcolo IVA** | Alto | Media | Test unitari su calcoli + validazione a38 |
| **Cliente non riceve fattura** | Medio | Media | Email PDF + link area riservata AE |
| **Perdita numerazione** | Basso | Bassa | DB transazionale + sequence PostgreSQL |

---

## 12. COSTI STIMATI

### Setup Iniziale
- Sviluppo modulo: **15-20 ore dev** (incluso in sprint Miracollo)
- Testing: **5 ore**
- Totale setup: ~25 ore

### Costi Ricorrenti
- Aruba Base (conservazione): **€60/anno**
- Invio SDI: **GRATIS** (API Agenzia Entrate)
- Firma digitale (se PA): **€30-50/anno** (opzionale)

**Totale anno 1**: ~€60-110 (no costi sviluppo, già in progetto)

### Scalabilità
- Aruba Premium (se API): +€600/anno (fase scale)
- Nessun costo variabile per volume fatture

---

## 13. FONTI E RIFERIMENTI

### Documentazione Ufficiale
- [Specifiche Tecniche SDI v1.8.1](https://www.fatturapa.gov.it/export/documenti/Specifiche_tecniche_SdI_v1.8.1.pdf)
- [Formato FatturaPA](https://www.fatturapa.gov.it/it/norme-e-regole/documentazione-fattura-elettronica/formato-fatturapa/)
- [Agenzia Entrate - Fatturazione Elettronica](https://www.agenziaentrate.gov.it/portale/aree-tematiche/fatturazione-elettronica)

### Librerie Python
- [python-a38 GitHub](https://github.com/Truelite/python-a38)
- [fatturapa-python GitHub](https://github.com/italia/fatturapa-python)
- [Developers Italia](https://developers.italia.it/it/fatturapa/)

### Normativa
- DPR 633/1972 (IVA)
- Codice Civile art. 2220 (conservazione)
- D.M. 17 giugno 2014 (conservazione sostitutiva)
- Legge 207/2024 (Budget 2025 - novità 2026)

---

## 14. PROSSIMI STEP SUGGERITI

### Immediati (questa settimana)
1. ✅ Ricerca completata
2. ⏭️ Decisione: includere fatturazione in MVP o post-MVP?
3. ⏭️ Se MVP: creare spike tecnico python-a38 (2h)

### Short-term (se approvato)
1. Setup ambiente sviluppo fatturazione
2. Implementazione FASE 1 (MVP base)
3. Test con fatture reali ambiente test SDI
4. Validazione con commercialista

### Medium-term
1. Integrazione completa SDI
2. Automazione check-out → fattura
3. Dashboard gestione fatture
4. Conservazione sostitutiva

---

## CONCLUSIONE

La fatturazione elettronica per hotel in Italia è **ben normata** e **tecnicamente gestibile**.

**PRO:**
- ✅ Librerie Python mature (python-a38)
- ✅ Processo SDI documentato
- ✅ Costi contenuti (€60/anno base)
- ✅ Nessun costo per invio (API gratis)

**CONTRO:**
- ⚠️ Complessità normativa (IVA, conservazione, etc.)
- ⚠️ Gestione scarti richiede logica robusta
- ⚠️ Compliance GDPR su dati cliente

**RACCOMANDAZIONE FINALE:**
Implementare modulo fatturazione in **FASE 2** (post-MVP core), usando **python-a38** per generazione XML e **Aruba Base** per conservazione. Investimento contenuto, rischio basso, valore alto per hotel clienti.

---

**Fine ricerca. Pronta per domande o approfondimenti.**
