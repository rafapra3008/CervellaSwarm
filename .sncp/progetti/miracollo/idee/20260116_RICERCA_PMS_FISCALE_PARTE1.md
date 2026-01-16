# RICERCA PMS FISCALE - PARTE 1: Tabella Comparativa Competitor

**Data**: 16 Gennaio 2026
**Ricercatrice**: Cervella Researcher
**Progetto**: Miracollo PMS

---

## 1. ERICSOFT SUITE 5° (Zucchetti Group)

**Mercato**: Italia
**Tipo**: On-premise/Cloud
**Installazioni**: 4.000+ hotel in Italia
**Riferimento**: Sistema ATTUALE dell'hotel di Rafa

### 1.1 Workflow Fiscale

**Checkout Standard:**
```
1. DayToDay Dashboard → comando rapido check-out
2. Schermata account ospite (riepilogo automatico acconti)
3. Scelta tipo documento:
   - Ricevuta fiscale (privati)
   - Fattura (aziende con P.IVA)
   - Scontrino fiscale
   - Ricevuta acconto
   - Nota credito
4. Emissione documento (stampa + invio digitale)
5. Archiviazione automatica
```

**Logica Scelta Documento:**
- Automatica se ospite ha P.IVA → suggerisce fattura
- Privati → ricevuta fiscale
- Possibilità "parcheggio" account per documento riepilogativo successivo

### 1.2 Fatturazione Elettronica

**Approccio**: Doppio canale (manuale + automatizzato)

**Versione Base (gratuita):**
- Gestione manuale via portale web Exchange
- Upload/download XML
- Invio SDI manuale

**Versione Avanzata (modulo opzionale):**
- Invio automatico SDI dopo tempo preimpostato
- Invio massivo programmato (es. ore notturne)
- Ricezione esiti direttamente nel PMS
- Firma digitale automatica
- Conservazione sostitutiva integrata

**Formato**: XML FatturaPA standard

**SDI**: Invio diretto o tramite intermediario Zucchetti

### 1.3 Registratore Telematico (RT)

**Integrazione**: Diretta con RT certificati

**Workflow Corrispettivi:**
```
1. Vendite giornaliere registrate in PMS
2. Emissione scontrini via RT integrato
3. Chiusura giornaliera automatica (programmabile)
4. Invio corrispettivi ad Agenzia Entrate entro 12 giorni
```

**Marche Supportate**: Non specificato nella documentazione pubblica, ma essendo Zucchetti Group supporta probabilmente Custom, RCH, Epson (standard italiani)

**Gestione Half Credit/Full Credit:**
- Half Credit: parte monopolio separata (sigarette, minibar)
- Full Credit: documento unico con tutto
- Configurabile per tipologia di servizio

**Novità 2026**: Ready per collegamento RT-POS telematico (servizio web Agenzia Entrate, disponibile marzo 2026)

### 1.4 UX/Workflow Operatore

**Dashboard DayToDay:**
- Comandi rapidi per check-in/check-out
- Vista ospiti in arrivo/partenza giornata corrente
- Azioni da pulsante singolo

**Flusso Emissione Documento:**
- **Stima click**: 3-4 click (rapido, ottimizzato per reception)
- Riepilogo automatico acconti (no calcoli manuali)
- Selezione documento da menu contestuale
- Preview prima stampa
- Conferma finale

**Gestione Errori:**
- Annullo documento possibile (genera nota credito automatica)
- Ristampa duplicati da storico
- Modifica documento "parcheggiato" prima emissione finale

**Training Staff:**
- Sistema consolidato, interfaccia familiare per operatori italiani
- Curva apprendimento media (sistema complesso ma ben documentato)

### 1.5 Export Contabilità

**Integrazione Diretta**: Con ERP Zucchetti
- Ad Hoc Revolution
- Ad Hoc Infinity
- Mago4

**Formati Export:**
- Office (Excel, CSV)
- HTML
- ASCII (custom format)
- API per integrazioni custom

**Standard**: USALI (Uniform System of Accounts for the Lodging Industry) per report revenue

**Sync Automatica**: Opzionale, dati fiscali sincronizzati real-time con contabilità se ERP Zucchetti

### 1.6 Pro/Contro Ericsoft

**PRO:**
- ✅ Sistema completo italiano (conosce normativa fiscale IT)
- ✅ Integrazione nativa RT + SDI
- ✅ Workflow consolidato (4000+ hotel = best practices incorporate)
- ✅ Integrazione Zucchetti ERP senza attriti
- ✅ Supporto diretto in italiano
- ✅ Gestione acconti automatica
- ✅ Half/Full Credit gestito

**CONTRO:**
- ❌ Interfaccia datata (non cloud-native moderna)
- ❌ Flessibilità limitata per integrazioni esterne
- ❌ Costo moduli opzionali (fatturazione automatica)
- ❌ Learning curve per nuovi operatori
- ❌ Vendor lock-in ecosistema Zucchetti

---

## 2. PROTEL

**Mercato**: Europa/Global (forte in Germania, Svizzera, Austria)
**Tipo**: Cloud (Protel Air) / On-premise (Protel Classic)
**Installazioni**: 14.000+ hotel worldwide

### 2.1 Workflow Fiscale

**Approccio**: Billing unificato multi-country

**Checkout Standard:**
```
1. Guest folio (conto ospite) centralizzato
2. Addebiti da vari outlet (ristorante, bar, spa) → folio unico
3. Generazione invoice automatica
4. Multiple currency support (MPC)
5. Tokenization pagamenti (sicurezza carta credito)
```

**Scelta Documento:**
- Configurabile per paese (compliance multi-country)
- Italia: supporto fattura/ricevuta fiscale
- Template customizzabili per tipologia

### 2.2 Fatturazione Elettronica

**Approccio**: E-invoicing integrato (generazione)

**Funzionalità:**
- Generazione fatture accurate (camera + servizi + tasse)
- PDF standard
- XML export (formato configurabile per paese)
- Invio email automatico

**SDI Italia**: Via integrazioni esterne (no invio diretto nativo)
- Partner integrators disponibili
- Export XML → intermediario

**Cloud PMS**: Unified invoicing su piattaforma centralizzata

### 2.3 Registratore Telematico (RT)

**Integrazione Italia**: Tramite partner

**Workflow:**
- PMS genera dati fiscali
- Middleware/integration layer
- RT certificato italiano
- Protel non ha integrazione RT nativa diretta

**Soluzione Tipica**: POS integration per outlet (ristorante/bar) separato da PMS billing

### 2.4 UX/Workflow Operatore

**Interface**: Moderna, cloud-based (Protel Cloud)

**User Experience:**
- **Stima click**: 4-5 click per invoice standard
- Interface intuitiva (UI moderna vs legacy systems)
- Training time ridotto vs sistemi on-premise
- Mobile-friendly (cloud PMS)

**Dashboard:**
- Operazioni centralizzate
- Folio unificato (tutti gli addebiti visibili insieme)
- Streamlined billing process

**Learning Curve:**
- Documentata come "quick to learn"
- Interface più moderna di sistemi legacy
- Però: alcuni utenti lamentano complessità per task specifici

### 2.5 Export Contabilità

**Financial Module**: Robusto

**Capabilities:**
- Financial accounting integrato
- Multi-currency support
- Secure credit card storage (Tokenization)

**Export:**
- Standard accounting formats
- API per integrazioni ERP
- Real-time KPI tracking

**Integrazioni**: Con vari ERP di terze parti (no lock-in vendor specifico)

### 2.6 Pro/Contro Protel

**PRO:**
- ✅ Multi-country compliance (scalabile internazionale)
- ✅ Interface moderna (Cloud PMS)
- ✅ Financial module robusto
- ✅ API aperte per integrazioni
- ✅ Mobile-friendly
- ✅ Training rapido (UI intuitiva)

**CONTRO:**
- ❌ Non specifico mercato italiano (integrazioni RT via partner)
- ❌ SDI non nativo (serve intermediario)
- ❌ Utenti lamentano "interfaccia datata" per versione on-premise
- ❌ Costo più alto (enterprise pricing)
- ❌ Alcuni workflow complessi (feedback utenti)

---

## 3. OPERA PMS (Oracle Hospitality)

**Mercato**: Global Enterprise (hotel grandi/catene)
**Tipo**: Cloud (Opera Cloud)
**Installazioni**: 40.000+ proprietà worldwide

### 3.1 Workflow Fiscale

**Checkout Enterprise:**
```
1. Cashiering > Billing (In-House Guest Search)
2. Billing screen ospite aperta
3. Opera auto-post room & tax charges (day-use: immediato)
4. Check Out button
5. Opzione stampa expense folio (breakdown categorie: Room, F&B, Tel, etc.)
6. Standard folio stampato
7. Archiviazione Folio History
```

**Scelta Documento:**
- Multi-format invoicing
- Country-specific templates
- Configurazione per 200+ paesi

**Particolarità:**
- Day-use reservations: charges postati immediatamente all'apertura Billing screen
- Dual folio option: standard + expense (categorizzato)

### 3.2 Fatturazione Elettronica

**Global Compliance**: 200+ paesi

**Italia:**
- Supporto FatturaPA XML
- Fiscal compliance italiana integrata
- Invio SDI: tramite integration partners (Oracle non gestisce direttamente SDI)

**Features:**
- Automated invoicing (riduce errori)
- Financial reporting automation
- Compliance with financial regulations globally

**Settlement:**
- Integration payment provider (EMV online settlement)
- Secure payment experience

### 3.3 Registratore Telematico (RT)

**Approccio**: Via Hospitality Integration Platform (HIP)

**Oracle HIP:**
- Piattaforma integrazioni unificata
- POS/PMS integration
- RT italiano: via partner integrators

**Workflow:**
- Opera PMS → HIP → RT certified
- No integrazione diretta nativa

**POS Integration**: Strong (per F&B outlets), RT segue stesso pattern

### 3.4 UX/Workflow Operatore

**Interface**: Enterprise-grade

**Flusso Checkout:**
- **Stima click**: 2-3 click (ottimizzato per high-volume)
- Operazioni semplificate per front desk
- Folio preview integrata
- Secure payment integrated

**User Experience:**
- Training: richiede formazione (sistema complesso)
- Performance: ottimizzato per catene grandi
- Standardizzazione: workflow uniformi multi-property

**Gestione Errori:**
- Folio History: consultabile e ristampabile sempre
- Annulli/rettifiche: processo strutturato
- Audit trail completo

### 3.5 Export Contabilità

**Financial Management**: Enterprise-level

**Export:**
- Standard accounting formats
- Real-time financial data
- Integration con ERP enterprise (SAP, Oracle ERP, etc.)

**Reporting:**
- Automated financial reporting
- Compliance reports per paese
- Revenue management integration

**API**: OPERA APIs (RESTful) per integrazioni custom

### 3.6 Pro/Contro Opera

**PRO:**
- ✅ Enterprise-grade (scalabilità catene)
- ✅ 200+ paesi compliance
- ✅ Workflow checkout ottimizzato (2-3 click)
- ✅ Financial module molto robusto
- ✅ Integration Platform (HIP) potente
- ✅ Audit trail completo
- ✅ API aperte

**CONTRO:**
- ❌ Costo molto alto (enterprise pricing)
- ❌ Overkill per hotel indipendenti/piccoli
- ❌ Complessità sistema (training richiesto)
- ❌ RT Italia: serve partner (no nativo)
- ❌ SDI: serve integration (no diretto)
- ❌ Vendor lock-in parziale (ecosistema Oracle)

---

## 4. MEWS

**Mercato**: Global, cloud-native (moderno)
**Tipo**: Cloud-only
**Target**: Hotel indipendenti, boutique, catene moderne

### 4.1 Workflow Fiscale

**Approccio**: API-first, cloud-native

**Checkout:**
```
1. Dashboard Mews
2. Guest profile/reservation
3. Billing tab
4. Generate invoice
   [CRITICITÀ: utenti segnalano "about ten clicks to invoice room service or other"]
5. Payment processing
6. Document delivery (email/print)
```

**Scelta Documento:**
- Configurabile per country
- Italia: supporto ricevuta/fattura
- Template customizzabili

### 4.2 Fatturazione Elettronica

**Legal Environment Integration:**

**Italia:**
- Raccomandato contattare Support per attivare "do not print a receipt" (evitare doppia tassazione con POS)
- Fiscal integration via partner: InvoiceXpress (Portogallo esempio)
- Pattern: Mews PMS + integration partner per compliance paese

**Workflow:**
- Mews genera invoice
- Export to fiscal integration partner
- Partner gestisce SDI/compliance locale
- Feedback status in Mews

**API-Based**: Forte su integrazioni via API, meno su fiscalità nativa

### 4.3 Registratore Telematico (RT)

**Integrazione Italia**: Via partner/custom integration

**Approccio:**
- Mews non ha RT integration nativa
- Necessario contattare Support per setup italiano
- Possibile via middleware custom

**POS Integration**: Lightspeed K-Series (esempio), ma richiede setup manuale

**Documentazione RT**: Limitata (non focus principale Mews)

### 4.4 UX/Workflow Operatore

**Interface**: Moderna, cloud-native

**User Experience:**
- **Design**: Molto moderno, "sleek"
- **Click count**: PROBLEMA segnalato - "about ten clicks to invoice room service"
- **Intuitive?**: Feedback misto
  - Marketing: "intuitive, easy"
  - Receptionists (35 years exp): "anything but intuitive, wastes time"

**Training:**
- Curva apprendimento variabile
- Interface moderna ma workflow complessi per alcune task
- Check-in: veloce ("just a few clicks")
- Invoicing: lento (feedback negativo)

**Updates Frequenti:**
- Mews lancia update regolari per "minimize clicks"
- Problema riconosciuto, lavoro in corso

### 4.5 Export Contabilità

**API-First Architecture:**

**Export:**
- API RESTful robuste
- Integration con accounting software vari
- Real-time data sync possibile

**Formati:**
- JSON (via API)
- CSV export
- Custom integrations

**Flessibilità**: Alta (API aperte), ma richiede sviluppo/configurazione

### 4.6 Pro/Contro Mews

**PRO:**
- ✅ Cloud-native moderno (no legacy)
- ✅ API-first (integrazioni flessibili)
- ✅ Interface design moderno
- ✅ Update frequenti (prodotto in evoluzione)
- ✅ Check-in veloce
- ✅ Mobile-friendly
- ✅ Open integrations

**CONTRO:**
- ❌ Workflow invoicing lento (10+ click segnalati)
- ❌ Non intuitivo per operatori esperti (feedback negativo)
- ❌ Fiscalità italiana: serve partner/support
- ❌ RT: no integrazione nativa
- ❌ SDI: via partner, non diretto
- ❌ Learning curve alta per alcuni task
- ❌ "Wastes time" - feedback reception staff

---

## 5. CLOUDBEDS

**Mercato**: Global, SMB focus
**Tipo**: Cloud-only
**Target**: Hotel piccoli/medi, B&B, ostelli

### 5.1 Workflow Fiscale

**Fiscal Documents Support:**

**Approach**: Fiscalizzazione via API integrations

**Checkout Options:**
```
Opzione 1 - At Reservation Creation:
  Invoice emessa alla creazione prenotazione

Opzione 2 - At Check-out (RACCOMANDATO):
  Invoice creata al momento check-out
  Include tutte transazioni disponibili
  Streamline checkout process

Opzione 3 - Manually:
  Invoice generata manualmente dall'operatore
  Controllo completo su timing
```

**Scelta Documento:**
- Configurabile per tipo fiscale
- Prevent duplicate invoices (solo transazioni non ancora fatturate)
- Invoice guests separately (split billing)

### 5.2 Fatturazione Elettronica

**Government Invoicing:**

**API Integration Model:**
- Partner fiscali inviano invoice URL (PDF/XML) a Cloudbeds
- `postGovernmentReceipt` endpoint
- File salvato e visualizzabile in PMS

**Italia:**
- Fiscal documents gestiti da partner certificati
- Cloudbeds = hub, partner = compliance

**Features:**
- Credit notes support
- Invoice status: Open/Paid/Voided
- Document email selection
- Advanced Invoicing module (opzionale)

### 5.3 Registratore Telematico (RT)

**Integrazione**: Via partner (no nativo)

**Workflow:**
- Cloudbeds genera fiscal data
- Integration partner gestisce RT
- Feedback status a Cloudbeds

**Accounting & Finance Apps**: Marketplace con partner certificati

### 5.4 UX/Workflow Operatore

**Interface**: User-friendly, SMB-oriented

**Checkout:**
- **Stima click**: 3-4 click (opzione "at check-out" ottimizzata)
- Workflow guidato
- Prevent duplicate invoices automatico

**Setup:**
- Configuration: flessibile (3 opzioni emissione)
- Onboarding: documentato come "easy"

**User Experience:**
- Target SMB = semplicità prioritaria
- Meno feature enterprise vs Opera/Protel
- Ma più semplice da usare per operatori non esperti

### 5.5 Export Contabilità

**Accounting Integrations:**

**Marketplace:**
- Accounting & Finance Apps category
- Partner integrations (QuickBooks, Xero, etc.)
- API per custom integrations

**Export:**
- Standard formats (CSV, PDF)
- Real-time sync con accounting software via apps
- Invoice Report (reporting fiscal documents)

### 5.6 Pro/Contro Cloudbeds

**PRO:**
- ✅ Semplice (target SMB)
- ✅ 3 opzioni emissione documento (flessibilità)
- ✅ Prevent duplicate invoices (smart)
- ✅ Fiscal API integration (estensibile)
- ✅ Marketplace accounting apps
- ✅ Pricing accessibile (vs enterprise)
- ✅ User-friendly per non esperti

**CONTRO:**
- ❌ Fiscalità nativa limitata (dipende da partner)
- ❌ RT Italia: via partner obbligatorio
- ❌ SDI: via partner obbligatorio
- ❌ Meno feature vs enterprise PMS
- ❌ Customizzazione limitata
- ❌ Dipendenza partner per compliance

---

## 6. SYSDAT TURISMO

**Mercato**: Italia
**Tipo**: On-premise (tradizionale)
**Installazioni**: 1.500+ strutture (hotel, villaggi, B&B, agriturismi)
**Gruppo**: Gruppo Centro Paghe (da novembre 2023)

### 6.1 Workflow Fiscale

**Approccio**: Specifico mercato italiano

**Focus:**
- PMS completo italiano
- Fatturazione elettronica integrata
- Corrispettivi telematici

**Workflow:**
- Standard PMS italiano (simile Ericsoft)
- Gestione completa ciclo attivo
- Emissione documenti fiscali da account ospite

### 6.2 Fatturazione Elettronica

**Soluzione Nativa:**

**Caratteristiche:**
- Fattura XML format (standard Sogei)
- Contenuto non modificabile (compliance)
- Sistema di Interscambio (SDI) integration

**SDI Integration:**
- Tramite Gruppo Informatico Siges (partner/intermediario)
- SDI verifica formato e completezza dati
- Trasmissione autonoma o via intermediario accreditato

**Compliance:**
- Obbligatoria da 1 gennaio 2019 (emissione, trasmissione, ricezione, conservazione)
- Sysdat Turismo offre consulenza qualificata continua

**Benefits:**
- Elimina storage fisico documenti cartacei
- Riduce costi stampa/spedizione
- Conformità normativa garantita

### 6.3 Registratore Telematico (RT)

**Integrazione**: Specifica italiana

**Supporto:**
- RT integration nativa (specifico per mercato italiano)
- Gestione corrispettivi elettronici

**Expertise:**
- Sistema pensato per normativa italiana
- 1.500+ installazioni = esperienza consolidata

### 6.4 UX/Workflow Operatore

**Interface**: Tradizionale on-premise

**Target:**
- Operatori italiani
- Strutture varie (da piccole a Grand Hotel)

**User Experience:**
- Curva apprendimento media
- Interface classica (non cloud-native)
- Consolidata per mercato italiano

### 6.5 Export Contabilità

**Integrazione:**

**Gruppo Siges:**
- Soluzioni gestionali integrate
- Export verso software contabilità gruppo
- Consulenza specialistica

**Formati:**
- Standard italiani
- Export per commercialisti
- Integrazione ecosistema Gruppo Centro Paghe

### 6.6 Pro/Contro Sysdat Turismo

**PRO:**
- ✅ Specifico Italia (conosce normativa)
- ✅ 1.500+ installazioni (esperienza consolidata)
- ✅ RT integration nativa
- ✅ SDI integration (via Gruppo Siges)
- ✅ Consulenza specialistica inclusa
- ✅ Supporto italiano dedicato
- ✅ Range strutture (da piccole a grandi)

**CONTRO:**
- ❌ Solo Italia (no internazionalizzazione)
- ❌ On-premise (no cloud-native)
- ❌ Interface tradizionale (non moderna)
- ❌ Gruppo Centro Paghe (acquisizione recente, incertezza evoluzione)
- ❌ Meno innovazione vs cloud players

---

## Tabella Comparativa Riassuntiva

| Caratteristica | Ericsoft | Protel | Opera | Mews | Cloudbeds | Sysdat |
|----------------|----------|--------|-------|------|-----------|--------|
| **Mercato Focus** | Italia | EU/Global | Global Enterprise | Global Cloud | Global SMB | Italia |
| **Tipo** | Hybrid | Cloud/On-prem | Cloud | Cloud-only | Cloud-only | On-premise |
| **Click Checkout** | 3-4 | 4-5 | 2-3 | 10+ ⚠️ | 3-4 | 4-5 |
| **RT Nativo** | ✅ Sì | ❌ Partner | ❌ Partner | ❌ Partner | ❌ Partner | ✅ Sì |
| **SDI Diretto** | ✅ Opzionale | ❌ No | ❌ No | ❌ No | ❌ No | ✅ Via Siges |
| **UX Moderna** | ⚠️ Media | ✅ Sì (Cloud) | ⚠️ Enterprise | ✅ Moderna | ✅ Semplice | ❌ Tradizionale |
| **API Aperte** | ⚠️ Limitate | ✅ Sì | ✅ Sì | ✅✅ Excellent | ✅ Sì | ❌ Limitate |
| **Costo** | €€ | €€€ | €€€€ | €€ | € | €€ |
| **Complessità** | Media | Media-Alta | Alta | Media | Bassa | Media |
| **Italia Ready** | ✅✅ | ⚠️ | ⚠️ | ⚠️ | ⚠️ | ✅✅ |
| **Internazionale** | ❌ | ✅ | ✅✅ | ✅ | ✅ | ❌ |

**Legenda:**
- ✅✅ = Eccellente
- ✅ = Buono
- ⚠️ = Sufficiente/Con limiti
- ❌ = Mancante/Scarso
- € = Economico, €€€€ = Molto costoso

---

## Key Insights

### Pattern Vincenti

1. **Checkout Ottimizzato** = 2-4 click (Opera, Ericsoft, Cloudbeds)
2. **Fiscalità Italiana** = Meglio sistemi nativi (Ericsoft, Sysdat) o integrazioni solide
3. **UX Moderna** ≠ Workflow Efficiente (Mews: design bello, troppi click)
4. **SDI/RT** = Serve integrazione, pochi lo fanno diretto nativamente

### Anti-Pattern da Evitare

1. ❌ Troppi click per operazioni frequenti (Mews: 10+ click invoicing)
2. ❌ Dipendenza totale da partner per compliance paese
3. ❌ Interface complessa per funzioni base
4. ❌ No preview documento prima emissione

### Best-in-Class per Feature

| Feature | Migliore | Perché |
|---------|----------|--------|
| **Checkout Speed** | Opera PMS | 2-3 click, ottimizzato enterprise |
| **Italia Compliance** | Ericsoft | RT + SDI nativi, 4000+ hotel |
| **API Flexibility** | Mews | API-first architecture |
| **Semplicità** | Cloudbeds | Target SMB, user-friendly |
| **Financial Module** | Opera PMS | Enterprise-grade, 200+ paesi |
| **Costo/Beneficio** | Ericsoft | Completo italiano, prezzo medio |

---

*Fine Parte 1 - Continua in Parte 2 (Best Practices e Pattern)*
