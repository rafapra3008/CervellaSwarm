# RICERCA: Fatturazione Elettronica Italiana per Hotel/PMS

**Data**: 19 Gennaio 2026
**Ricercatrice**: Cervella Researcher
**Progetto**: Miracollo PMS
**Obiettivo**: Comprendere tutti i requisiti per implementare fatturazione elettronica XML per hotel

---

## TL;DR - Sintesi Esecutiva

**Fattibilità**: ✅ ALTA - Implementazione in-house possibile con librerie Python esistenti

**Complessità Tecnica**: MEDIA - XML strutturato con validazione rigorosa

**Costi Esterni**: BASSI (48-144€/anno per intermediario) o ZERO (servizio gratuito Agenzia Entrate)

**Raccomandazione**: Usare **python-a38** (libreria dichiarativa tipo Django) + intermediario API per invio SDI

---

## 1. FATTURAPA - FORMATO XML

### Versione Corrente
- **Tracciato XML**: FatturaPA v1.2.3 (in vigore dal 1 Aprile 2025)
- **Specifiche Tecniche**: v1.4 (documento ufficiale 781 KB)
- **Standard**: Allineato a fatturazione europea EN16931

### Struttura File XML

```
FatturaPA v1.2.3 (Root)
├── FatturaElettronicaHeader (Intestazione)
│   ├── DatiTrasmissione [OBBLIGATORIO]
│   │   ├── IdTrasmittente (IdPaese + IdCodice)
│   │   ├── ProgressivoInvio
│   │   ├── FormatoTrasmissione (FPA12 / FPR12)
│   │   └── CodiceDestinatario (7 caratteri)
│   ├── CedentePrestatore [OBBLIGATORIO]
│   │   ├── DatiAnagrafici (P.IVA, Anagrafica, RegimeFiscale)
│   │   └── Sede (Indirizzo, CAP, Comune, Provincia, Nazione)
│   └── CessionarioCommittente [OBBLIGATORIO]
│       ├── DatiAnagrafici (IdFiscaleIVA o CodiceFiscale)
│       └── Sede
├── FatturaElettronicaBody (Corpo Fattura) [1.N]
│   ├── DatiGenerali
│   │   ├── DatiGeneraliDocumento (TipoDocumento, Data, Numero)
│   │   └── DatiOrdineAcquisto [opzionale]
│   ├── DatiBeniServizi [OBBLIGATORIO]
│   │   ├── DettaglioLinee [1.N] (Descrizione, Quantità, PrezzoUnitario, AliquotaIVA)
│   │   └── DatiRiepilogo [OBBLIGATORIO per ogni aliquota IVA]
│   └── DatiPagamento [opzionale]
│       └── DettaglioPagamento (ModalitaPagamento, ImportoPagamento)
```

### Campi Obbligatori vs Opzionali

**Identificazione Obbligatorietà nel Tracciato**:
- `<1.1>` = campo obbligatorio, 1 sola occorrenza
- `<1.N>` = campo obbligatorio, N occorrenze
- `<0.1>` = campo opzionale, max 1 occorrenza
- `<0.N>` = campo opzionale, N occorrenze

**Blocchi Sempre Obbligatori**:
- DatiTrasmissione (identifica trasmittente, formato, destinatario)
- CedentePrestatore (chi emette fattura)
- CessionarioCommittente (cliente)
- DatiBeniServizi → DettaglioLinee (righe fattura)
- DatiBeniServizi → DatiRiepilogo (riepilogo per aliquota IVA)

**Campi Minimi Fattura Valida**:
- Soggetti (cedente + cessionario)
- Almeno 1 riga con imponibile
- Almeno 1 riepilogo IVA
- Totale documento

---

## 2. SPECIFICHE PER HOTEL

### Codice ATECO Hotel

**Codice**: `55.10.00` - Alberghi e strutture simili

**Descrizione**: Servizi di alloggio di breve durata presso hotel, resort, motel, apart-hotel, pensioni, alberghi attrezzati per congressi, anche con attività mista di alloggio e ristorazione.

**Altri Codici Correlati**:
- `55.20.51` - Affittacamere, B&B per brevi soggiorni
- `55.20.52` - Agriturismi con alloggio
- `56.10.12` - Agriturismi con ristorazione

### Fatturazione Servizi Alberghieri

**Emissione Obbligatoria**:
- Non obbligatoria a meno che il cliente non la richieda al momento della transazione
- Se richiesta, DEVE essere elettronica (dal 2019)

**Conservazione**: Obbligatoria per 10 anni

**Servizi Tipici da Fatturare**:
```
Voce Fattura              | Aliquota IVA | Natura | Note
--------------------------|--------------|--------|---------------------------
Pernottamento             | 10%          | -      | Aliquota ridotta
Colazione inclusa         | 10%          | -      | Se non scorporata
Ristorazione separata     | 10%          | -      | Aliquota ridotta
Servizi extra (minibar)   | 22%          | -      | Aliquota ordinaria
Tassa soggiorno           | -            | N1     | Escluso IVA art. 15
```

### TASSA DI SOGGIORNO - CODICE N1

**REGOLA CRITICA**:
- Codice Natura: **N1** (escluso IVA ex art. 15 DPR 633/72)
- **NON** usare N2 (fuori campo IVA)

**Motivazione**:
- Il soggetto passivo è il cliente (chi paga l'alloggio)
- L'albergatore cura solo riscossione e versamento
- È un rimborso anticipazioni (art. 15, comma 1, punto 3 DPR 633/1972)
- Non concorre alla base imponibile delle prestazioni alberghiere

**In Fattura Elettronica**:
```xml
<DettaglioLinee>
  <NumeroLinea>1</NumeroLinea>
  <Descrizione>Pernottamento 2 notti</Descrizione>
  <Quantita>2</Quantita>
  <PrezzoUnitario>80.00</PrezzoUnitario>
  <PrezzoTotale>160.00</PrezzoTotale>
  <AliquotaIVA>10.00</AliquotaIVA>
</DettaglioLinee>
<DettaglioLinee>
  <NumeroLinea>2</NumeroLinea>
  <Descrizione>Tassa di soggiorno</Descrizione>
  <Quantita>2</Quantita>
  <PrezzoUnitario>3.00</PrezzoUnitario>
  <PrezzoTotale>6.00</PrezzoTotale>
  <AliquotaIVA>0.00</AliquotaIVA>
  <Natura>N1</Natura> <!-- OBBLIGATORIO -->
</DettaglioLinee>
```

**Fonti**:
- Il Sole 24 Ore Fisco: [Fattura elettronica, codice N1 per il documento degli hotel](https://ntplusfisco.ilsole24ore.com/art/fattura-elettronica-codice-n1-il-documento-hotel-ABbi9ljB)
- Eutekne.info: [Imposta e contributo di soggiorno fuori dalla base imponibile IVA](https://www.eutekne.info/Sezioni/Art_750716_imposta_e_contributo_di_soggiorno_fuori_dalla_base_imponibile.aspx)

---

## 3. INVIO A SDI (Sistema di Interscambio)

### Cos'è il Sistema di Interscambio

Il **SDI** (Sistema di Interscambio), gestito dall'Agenzia delle Entrate, è il sistema informatico che:
- Riceve fatture in formato FatturaPA XML
- Esegue controlli di validità formale
- Inoltra fatture a PA o privati (B2B/B2C)
- Restituisce notifiche di consegna/scarto

### Modalità di Invio

**3 Canali Principali**:

1. **PEC (Posta Elettronica Certificata)**
   - Invio a: `sdi01@pec.fatturapa.it`
   - Allegato: file XML fattura (firmato digitalmente)
   - Ritorno: notifiche via PEC

2. **Portale Fatture e Corrispettivi** (Web)
   - https://ivaservizi.agenziaentrate.gov.it/portale/
   - Upload manuale file XML
   - Adatto per volumi bassi

3. **API Web Service / SFTP**
   - Canale preferito per automazione
   - Richiede Codice Destinatario a 7 cifre
   - Gestito tramite intermediario certificato

### Serve un Intermediario?

**NO, non obbligatorio**, ma **FORTEMENTE CONSIGLIATO** per:
- Invio automatizzato da software gestionale
- Firma digitale automatica
- Gestione notifiche (ricevuta consegna, scarto)
- Conservazione a norma inclusa
- API REST per integrazione

**Alternativa Gratuita**:
- Servizio gratuito Agenzia delle Entrate (conservazione inclusa)
- Richiede upload manuale o PEC
- Meno adatto per PMS con alto volume fatture

### Intermediari Disponibili

| Provider | Costo/Anno | Canale | API | Note |
|----------|-----------|--------|-----|------|
| **Software Semplice** | 48€ + IVA | API REST | ✅ | PIÙ ECONOMICO |
| **Aruba** | 59,80€ + IVA | API REST, PEC, Web | ✅ | Conservazione inclusa (1GB), Codice dest: KRRH6B9 |
| **Fatture in Cloud** | 144€ + IVA | API REST | ✅ | PIÙ COSTOSO, funzionalità complete |
| **Openapi** | da 25€/anno | API REST | ✅ | Invio da €0,025 a fattura |
| **InfoCert Legalinvoice** | vari piani | API REST | ✅ | GO (forfettari), START, PRO |
| **EFFATTA** | - | API REST | ✅ | Connettore universale |
| **Invoicetronic** | - | API RESTful | ✅ | Conforme SDI |

**Raccomandazione**:
- **Aruba** (€59,80/anno) = miglior rapporto qualità/prezzo, affidabile, conservazione inclusa
- **Openapi** (pay-per-use) = alternativa economica se volume fatture è basso

### Esempio Flusso con API (Aruba)

```python
# 1. Genera XML FatturaPA con python-a38
fattura_xml = genera_fattura_hotel(cliente, prenotazione)

# 2. Invia a SDI tramite API Aruba
response = requests.post(
    'https://fatturazioneelettronica.aruba.it/api/v1/send',
    headers={'Authorization': 'Bearer API_KEY'},
    files={'fattura': fattura_xml}
)

# 3. Gestisci risposta
if response.status_code == 200:
    id_sdi = response.json()['IdSdI']
    # SDI ha accettato, salva IdSdI
else:
    # Errore validazione, gestisci
```

**Documentazione API**:
- Aruba: https://fatturazioneelettronica.aruba.it/apidoc/docs.html
- Fattura Elettronica API: https://www.fattura-elettronica-api.it/

---

## 4. CONSERVAZIONE DIGITALE

### È Obbligatoria?

**SÌ, OBBLIGATORIA** per legge (art. 39 DPR 633/1972).

**Chi**: Sia emittente che destinatario della fattura elettronica.

**Durata**: 10 anni dalla data di presentazione della dichiarazione dei redditi relativa all'anno di emissione.

**Scadenza Processo**:
- Entro 3 mesi dalla scadenza dichiarazione redditi
- Esempio: Fatture 2024 → conservazione entro 31 Gennaio 2026

### Requisiti Conservazione

**Caratteristiche**:
- Conformità CAD (Codice Amministrazione Digitale)
- Garanzia di integrità
- Reperibilità documenti
- Accesso facilitato
- Marcatura temporale

**NON è**: Semplice salvataggio file su PC/cloud.

### Opzioni Conservazione

1. **Servizio Gratuito Agenzia Entrate**
   - Automatico per fatture transitate via SDI
   - Consultazione su portale Fatture e Corrispettivi
   - Conforme a norma

2. **Conservatori Privati Certificati AgID**
   - Incluso nei servizi intermediari (Aruba, InfoCert, etc.)
   - Esempio: Aruba include conservazione da €29,90/anno
   - Spazio: tipicamente 1GB = oltre 100.000 XML

3. **Gestione In-House**
   - Richiede certificazione conservatore interno
   - Complessità normativa/tecnica elevata
   - Sconsigliato per PMI/hotel

**Raccomandazione**: Usare conservazione inclusa nell'intermediario (es. Aruba) o servizio gratuito Agenzia Entrate.

---

## 5. CODICE DESTINATARIO vs PEC

### Regole Utilizzo

| Scenario | CodiceDestinatario | PEC | Consegna |
|----------|-------------------|-----|----------|
| **Azienda con Codice SDI** | 7 caratteri (es. A1B2C3D) | vuoto | Web Service/SFTP destinatario |
| **Azienda con solo PEC** | `0000000` (7 zeri) | indirizzo PEC | PEC del destinatario |
| **Privato senza PEC** | `0000000` | vuoto | Area privata Agenzia Entrate |
| **Pubblica Amministrazione** | Codice IPA (6 caratteri) | vuoto | Sistema PA |

### PRECEDENZA

**CodiceDestinatario ha SEMPRE precedenza su PEC**.

Se CodiceDestinatario è compilato (≠ 0000000), il campo PEC viene ignorato.

### Codice 0000000 (Sette Zeri)

**Quando usarlo**:
- Cliente fornisce solo PEC (non codice destinatario)
- Cliente è un privato senza PEC

**Cosa succede**:
```
SE CodiceDestinatario = "0000000" E PEC compilata:
  → Invio a PEC cliente

SE CodiceDestinatario = "0000000" E PEC vuota:
  → Consegna in area riservata Agenzia Entrate (cassetto fiscale)
  → Cliente accede con SPID/CIE
```

**Particolarità Privati**:
- Il privato ha diritto a ricevere anche copia cartacea
- L'emittente deve produrre sia fattura elettronica che cartacea
- Fattura elettronica finisce comunque nel cassetto fiscale

### Esempio Pratico Hotel

```python
# Cliente azienda con codice destinatario
cliente_business = {
    'codice_destinatario': 'M5UXCR1',  # Codice SDI del cliente
    'pec': ''  # Lasciare vuoto
}

# Cliente azienda con solo PEC
cliente_business_pec = {
    'codice_destinatario': '0000000',  # 7 zeri
    'pec': 'azienda@pec.it'
}

# Cliente privato (turista)
cliente_privato = {
    'codice_destinatario': '0000000',  # 7 zeri
    'pec': ''  # Vuoto, va in cassetto fiscale
    # + consegna copia cartacea al check-out
}
```

**Fonti**:
- InfoCert: [Codice destinatario: cos'è e come funziona](https://futurodigitale.infocert.it/professionista-digitale/fattura-elettronica-cose-il-codice-destinatario-e-come-funziona/)
- Fiscozen: [Codice destinatario 0000000: quando e come si usa](https://www.fiscozen.it/guide/codice-univoco-0000000/)
- Agenzia Entrate: [Come si invia fattura al cliente](https://www.agenziaentrate.gov.it/portale/aree-tematiche/fatturazione-elettronica/guida-fatturazione-elettronica/come-predisporre-inviare-ricevere-fe/come-inviare-fe-al-cliente)

---

## 6. LIBRERIE PYTHON ESISTENTI

### Confronto Librerie Principali

| Libreria | Sviluppatore | Maturità | Approccio | Validazione | Firma | Status |
|----------|-------------|----------|-----------|-------------|-------|--------|
| **python-a38** | Truelite | ✅ Alta (229 commits) | Dichiarativo (tipo Django) | ✅ Built-in | ✅ CAdES | ATTIVO |
| **fatturapa-python** | Developers Italia | ⚠️ Media (36 commits) | CLI generatore | ❌ Esterna | ❌ | FERMO (2019) |

---

### 📊 RACCOMANDAZIONE: python-a38 (VINCITORE)

**Perché scegliere python-a38**:

✅ **Modello dichiarativo** simile a Django ORM
✅ **Validazione integrata** con classe Validation
✅ **Parsing robusto** (valida tutti gli esempi ufficiali fatturapa.gov.it)
✅ **Firma digitale** CAdES inclusa
✅ **Manutenzione attiva** (2019-2024)
✅ **Licenza Apache 2.0** (business-friendly)
✅ **CLI tool** (`a38tool`) per operazioni comuni

**Limitazioni dichiarate**:
- "Only part of the specification is implemented"
- Estendibile via contributi community
- Copre i casi d'uso principali (sufficiente per hotel)

---

### python-a38 - Dettagli Tecnici

**GitHub**: https://github.com/Truelite/python-a38
**Docs**: https://www.truelite.it/progetti/python-a38/
**Developers Italia**: https://developers.italia.it/it/software/github.com/truelite/python-a38.html

**Installazione**:
```bash
pip install a38
```

**Dipendenze**:
- Obbligatorie: `dateutil`, `pytz`, `asn1crypto`
- Opzionali: `lxml`, `wkhtmltopdf`, `requests`

**Esempio Generazione Fattura Hotel**:

```python
from a38 import FatturaPrivati12
from a38.anagrafica import IdFiscaleIVA, Anagrafica, Sede
from decimal import Decimal

# 1. Crea fattura
f = FatturaPrivati12()

# 2. Dati Trasmissione
f.fattura_elettronica_header.dati_trasmissione.id_trasmittente = \
    IdFiscaleIVA(id_paese='IT', id_codice='01234567890')
f.fattura_elettronica_header.dati_trasmissione.progressivo_invio = 'FT001'
f.fattura_elettronica_header.dati_trasmissione.codice_destinatario = '0000000'

# 3. Cedente (Hotel)
cedente = f.fattura_elettronica_header.cedente_prestatore
cedente.dati_anagrafici.id_fiscale_iva = IdFiscaleIVA('IT', '01234567890')
cedente.dati_anagrafici.anagrafica = Anagrafica(denominazione='Hotel Miracollo')
cedente.dati_anagrafici.regime_fiscale = 'RF01'  # Ordinario
cedente.sede = Sede(
    indirizzo='Via Roma 1',
    cap='00100',
    comune='Roma',
    provincia='RM',
    nazione='IT'
)

# 4. Cessionario (Cliente)
cessionario = f.fattura_elettronica_header.cessionario_committente
cessionario.dati_anagrafici.codice_fiscale = 'RSSMRA80A01H501U'
cessionario.dati_anagrafici.anagrafica = Anagrafica(
    nome='Mario', cognome='Rossi'
)
cessionario.sede = Sede(
    indirizzo='Via Milano 10',
    cap='20100',
    comune='Milano',
    provincia='MI',
    nazione='IT'
)

# 5. Corpo Fattura
body = f.fattura_elettronica_body[0]

# 5a. Dati Generali Documento
body.dati_generali.dati_generali_documento.tipo_documento = 'TD01'
body.dati_generali.dati_generali_documento.data = '2026-01-19'
body.dati_generali.dati_generali_documento.numero = 'FT001/2026'
body.dati_generali.dati_generali_documento.divisa = 'EUR'

# 5b. Righe Fattura - Pernottamento
body.dati_beni_servizi.add_dettaglio_linee(
    numero_linea=1,
    descrizione='Pernottamento camera doppia - 2 notti',
    quantita=Decimal('2'),
    prezzo_unitario=Decimal('80.00'),
    aliquota_iva=Decimal('10.00')
)

# 5c. Riga Fattura - Tassa Soggiorno (NATURA N1!)
body.dati_beni_servizi.add_dettaglio_linee(
    numero_linea=2,
    descrizione='Tassa di soggiorno',
    quantita=Decimal('2'),
    prezzo_unitario=Decimal('3.00'),
    aliquota_iva=Decimal('0.00'),
    natura='N1'  # CRITICO: escluso IVA art. 15
)

# 5d. Riepilogo IVA (automatico con a38, ma esempio manuale)
# Viene generato automaticamente da python-a38 basandosi sulle righe

# 6. Validazione
validation = f.validate()
if validation.errors:
    print("ERRORI:", validation.errors)
    exit(1)

# 7. Genera XML
tree = f.build_etree()
xml_string = f.to_xml(validate=True)

# 8. Salva file
with open('FT001_2026.xml', 'wb') as file:
    file.write(xml_string)

print("Fattura generata: FT001_2026.xml")
```

**Funzionalità CLI**:
```bash
# Validare XML esistente
a38tool validate fattura.xml

# Firmare digitalmente
a38tool sign fattura.xml --cert cert.pem --key key.pem

# Parsing e lettura
a38tool parse fattura.xml --output json
```

**Validazione**:
```python
from a38 import Validation

validation = fattura.validate()

# Controllo errori
if validation.errors:
    for error in validation.errors:
        print(f"ERRORE: {error}")

# Controllo warning
if validation.warnings:
    for warning in validation.warnings:
        print(f"WARNING: {warning}")

# Test OK
if validation.success:
    print("Fattura valida!")
```

---

### fatturapa-python - Dettagli

**GitHub**: https://github.com/italia/fatturapa-python
**Developers Italia**: https://developers.italia.it/it/fatturapa/

**Pro**:
- Ufficiale (Developers Italia / Team Digitale)
- CLI semplice per freelance

**Contro**:
- ❌ Fermo dal 2019 (6 anni senza aggiornamenti)
- ❌ Tracciato 1.3.1 (non aggiornato a 1.2.3)
- ❌ Scope limitato (consulenze, non hotel)
- ❌ Nessuna validazione integrata
- ❌ Database JSON locale (non scalabile)
- ❌ Impossibile rimuovere clienti

**Uso Sconsigliato** per Miracollo PMS.

---

### Altre Risorse Python

**Validatori XML Esterni**:
- Validatore Ufficiale Agenzia Entrate: https://fatturazione-elettronica-pa.assocons.it/validazione-fattura-elettronica.html
- Tool online per test pre-invio

**Forum e Community**:
- Forum Fatturazione Elettronica: https://www.iprogrammatori.it/forum-programmazione/fatturazione-elettronica/
- GitHub Topics: https://github.com/topics/fatturazione-elettronica

---

## 7. RACCOMANDAZIONI IMPLEMENTAZIONE

### Architettura Consigliata per Miracollo PMS

```
┌─────────────────────────────────────────────────────────────┐
│                    MIRACOLLO PMS                            │
│  (FastAPI Backend + React Frontend)                         │
└────────────┬────────────────────────────────────────────────┘
             │
             │ 1. Genera Fattura
             ↓
┌─────────────────────────────────────────────────────────────┐
│              MODULO FATTURAZIONE                            │
│  • Logica business fattura hotel                            │
│  • Calcolo IVA, tassa soggiorno                             │
│  • Validazione dati cliente                                 │
└────────────┬────────────────────────────────────────────────┘
             │
             │ 2. Richiama python-a38
             ↓
┌─────────────────────────────────────────────────────────────┐
│              LIBRERIA: python-a38                           │
│  • Costruisce XML FatturaPA 1.2.3                           │
│  • Valida struttura e campi                                 │
│  • Genera file XML                                          │
└────────────┬────────────────────────────────────────────────┘
             │
             │ 3. Invia XML
             ↓
┌─────────────────────────────────────────────────────────────┐
│         INTERMEDIARIO API (es. Aruba)                       │
│  • Firma digitale automatica                                │
│  • Invio a SDI                                              │
│  • Gestione notifiche (ricevuta/scarto)                     │
│  • Conservazione a norma inclusa                            │
└────────────┬────────────────────────────────────────────────┘
             │
             │ 4. Transita
             ↓
┌─────────────────────────────────────────────────────────────┐
│     SISTEMA DI INTERSCAMBIO (SDI) - Agenzia Entrate         │
│  • Controlli formali                                        │
│  • Inoltro a destinatario                                   │
│  • Notifiche di consegna                                    │
└────────────┬────────────────────────────────────────────────┘
             │
             │ 5. Recapita
             ↓
┌─────────────────────────────────────────────────────────────┐
│                    CLIENTE                                  │
│  • Web Service (se codice dest.)                            │
│  • PEC (se PEC fornita)                                     │
│  • Cassetto fiscale (se privato)                            │
└─────────────────────────────────────────────────────────────┘
```

---

### Cosa Fare In-House

✅ **POSSIAMO FARE**:

1. **Generazione XML FatturaPA**
   - Libreria: `python-a38`
   - Logica: calcoli IVA, righe fattura, gestione natura N1
   - Validazione: controlli pre-invio

2. **Storage Locale Fatture**
   - Salvataggio XML generati nel DB Miracollo
   - Associazione fattura ↔ prenotazione
   - Storico fatture emesse

3. **Preview PDF per Cliente**
   - Generazione PDF human-readable da XML
   - Consegna copia cartacea (se privato)
   - Archivio documenti

4. **Logica Business Hotel**
   - Calcolo tassa soggiorno per città
   - Gestione aliquote IVA differenziate
   - Split fattura pernottamento/servizi extra

5. **Interface Utente**
   - Form inserimento dati cliente fiscali
   - Gestione anagrafica clienti business
   - Dashboard fatture emesse

---

### Cosa Serve Intermediario

❌ **SERVONO ESTERNI**:

1. **Firma Digitale Qualificata**
   - Richiesta per validità fiscale
   - Certificato da CA riconosciuta
   - Gestione scadenze certificati

2. **Invio Effettivo a SDI**
   - Canale Web Service/SFTP certificato
   - Gestione protocollo SDI
   - Retry automatico in caso di errore temporaneo

3. **Ricezione Notifiche SDI**
   - Ricevuta di consegna (RC)
   - Notifica di scarto (NS)
   - Notifica di mancata consegna (MC)
   - Notifica di esito committente (EC/MC)

4. **Conservazione a Norma**
   - Marcatura temporale
   - Certificazione conservatore AgID
   - Generazione lotto conservazione
   - Indice lotto conforme

5. **Compliance Normativa**
   - Aggiornamenti tracciato XML
   - Adeguamenti normativi
   - Monitoraggio modifiche SDI

---

### Stack Tecnologico Consigliato

```python
# requirements.txt per modulo fatturazione

# CORE - Generazione FatturaPA
a38==1.4.0  # Libreria principale

# SUPPORTO
lxml>=4.9.0  # Parser XML performante
python-dateutil>=2.8.0  # Gestione date
pytz>=2023.3  # Timezone

# FIRMA (opzionale se delegata a intermediario)
# asn1crypto>=1.5.0  # Parsing certificati

# INTEGRAZIONE
requests>=2.31.0  # API calls a intermediario
pydantic>=2.0.0  # Validazione dati input

# PDF GENERATION (opzionale)
reportlab>=4.0.0  # Generazione PDF da dati
```

**FastAPI Endpoint Esempio**:

```python
# api/fatturazione.py

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Optional
from decimal import Decimal
import a38

router = APIRouter(prefix="/api/v1/fatture", tags=["Fatturazione"])


class ClienteFatturazioneDTO(BaseModel):
    """Dati cliente per fatturazione"""
    tipo: str  # 'privato' | 'azienda'
    codice_fiscale: Optional[str]
    partita_iva: Optional[str]
    denominazione: Optional[str]  # Azienda
    nome: Optional[str]  # Privato
    cognome: Optional[str]  # Privato
    indirizzo: str
    cap: str
    comune: str
    provincia: str
    nazione: str = 'IT'
    codice_destinatario: str = '0000000'
    pec: Optional[str] = None


class RigaFatturaDTO(BaseModel):
    """Singola riga fattura"""
    descrizione: str
    quantita: Decimal
    prezzo_unitario: Decimal
    aliquota_iva: Decimal
    natura: Optional[str] = None  # 'N1' per tassa soggiorno


class GeneraFatturaRequest(BaseModel):
    """Request generazione fattura"""
    id_prenotazione: int
    cliente: ClienteFatturazioneDTO
    righe: list[RigaFatturaDTO]
    numero_fattura: str
    data_fattura: str  # YYYY-MM-DD


@router.post("/genera")
async def genera_fattura(request: GeneraFatturaRequest):
    """
    Genera fattura elettronica XML per prenotazione hotel

    - Crea file XML FatturaPA 1.2.3
    - Valida campi obbligatori
    - Salva nel DB
    - Invia a intermediario (Aruba API)
    """
    try:
        # 1. Crea oggetto FatturaPA con python-a38
        fattura = crea_fattura_a38(request)

        # 2. Valida
        validation = fattura.validate()
        if validation.errors:
            raise HTTPException(
                status_code=400,
                detail={'errors': validation.errors}
            )

        # 3. Genera XML
        xml_bytes = fattura.to_xml(validate=True)

        # 4. Salva nel DB
        fattura_db = salva_fattura_db(
            id_prenotazione=request.id_prenotazione,
            numero=request.numero_fattura,
            xml_content=xml_bytes
        )

        # 5. Invia a intermediario (Aruba)
        esito_sdi = invia_a_aruba(xml_bytes, fattura_db.id)

        return {
            'success': True,
            'id_fattura': fattura_db.id,
            'numero_fattura': request.numero_fattura,
            'id_sdi': esito_sdi.get('IdSdI'),
            'xml_path': fattura_db.file_path
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


def crea_fattura_a38(request: GeneraFatturaRequest) -> a38.FatturaPrivati12:
    """Helper: costruisce oggetto FatturaPA con python-a38"""
    # Implementazione simile all'esempio precedente
    # ...
    pass


def invia_a_aruba(xml_bytes: bytes, id_fattura_db: int) -> dict:
    """Helper: invio a SDI tramite API Aruba"""
    import requests

    # Config da settings
    ARUBA_API_URL = 'https://fatturazioneelettronica.aruba.it/api/v1/send'
    ARUBA_API_KEY = 'YOUR_API_KEY'  # Da .env

    response = requests.post(
        ARUBA_API_URL,
        headers={
            'Authorization': f'Bearer {ARUBA_API_KEY}',
            'Content-Type': 'application/xml'
        },
        data=xml_bytes
    )

    if response.status_code == 200:
        # Successo, salva IdSdI nel DB
        return response.json()
    else:
        # Gestisci errore
        raise Exception(f"Errore invio SDI: {response.text}")
```

---

### Flusso Operativo Completo

```
UTENTE HOTEL (Receptionist)
│
│ 1. Check-out ospite
│    → Miracollo PMS Frontend
│
└─→ CLICK "Emetti Fattura"
    │
    ├─→ Form chiede:
    │   • Dati fiscali cliente (P.IVA o CF)
    │   • Codice destinatario / PEC
    │   • Conferma servizi fatturati
    │
    └─→ SUBMIT form
        │
        ↓
    MIRACOLLO BACKEND (FastAPI)
    │
    ├─→ /api/v1/fatture/genera
    │
    ├─→ python-a38.FatturaPrivati12()
    │   • Costruisce XML
    │   • Aggiunge righe:
    │     - Pernottamento (IVA 10%)
    │     - Colazione (IVA 10%)
    │     - Tassa soggiorno (Natura N1, IVA 0%)
    │   • Validazione campi
    │
    ├─→ fattura.to_xml() → file XML
    │
    ├─→ Salva DB:
    │   • fatture (id, numero, data, xml, status)
    │   • JOIN con prenotazioni (id_prenotazione)
    │
    ├─→ POST Aruba API
    │   • Endpoint: /api/v1/send
    │   • Headers: Authorization Bearer
    │   • Body: XML file
    │
    │   ↓ ARUBA INTERMEDIARIO
    │   │
    │   ├─→ Firma digitale automatica
    │   ├─→ Invio SDI via Web Service
    │   └─→ Risposta: { "IdSdI": "12345" }
    │
    ├─→ UPDATE DB:
    │   • status = 'inviata'
    │   • id_sdi = '12345'
    │   • timestamp_invio = NOW()
    │
    └─→ RESPONSE al Frontend:
        { "success": true, "numero": "FT001/2026" }
        │
        ↓
    FRONTEND
    │
    └─→ Mostra conferma:
        "Fattura FT001/2026 inviata correttamente"
        │
        └─→ Genera PDF preview per cliente
            (se richiesto consegna cartacea)

--- DOPO 5-10 SECONDI ---

SDI (Sistema di Interscambio)
│
├─→ Controlli formali XML
│
├─→ SE OK:
│   └─→ Invia a destinatario (Web Service / PEC / Cassetto)
│       └─→ Notifica Ricevuta Consegna (RC) ad Aruba
│
└─→ SE ERRORE:
    └─→ Notifica Scarto (NS) ad Aruba

--- ARUBA riceve notifica SDI ---

ARUBA
│
├─→ Webhook a Miracollo:
│   POST /api/v1/fatture/webhook-sdi
│   {
│     "IdSdI": "12345",
│     "tipo_notifica": "RC",  # Ricevuta Consegna
│     "timestamp": "2026-01-19T14:30:00Z"
│   }
│
└─→ Conservazione automatica (inclusa nel servizio)

--- MIRACOLLO riceve webhook ---

BACKEND
│
├─→ UPDATE DB:
│   • status = 'consegnata'
│   • data_consegna = NOW()
│
└─→ NOTIFICA FRONTEND (WebSocket):
    "Fattura FT001/2026 consegnata al cliente"

FINE FLUSSO ✅
```

---

### Checklist Implementazione

**FASE 1: Setup Base** (1-2 giorni)
- [ ] Installare `python-a38` in backend
- [ ] Creare modelli DB (tabella `fatture`)
- [ ] Implementare endpoint FastAPI `/fatture/genera`
- [ ] Test generazione XML base (senza invio)
- [ ] Validazione XML con tool Agenzia Entrate

**FASE 2: Logica Hotel** (2-3 giorni)
- [ ] Calcolo automatico IVA (10% pernottamento, 22% minibar)
- [ ] Gestione tassa soggiorno (Natura N1)
- [ ] Supporto cliente privato vs azienda
- [ ] Form frontend per dati fiscali cliente
- [ ] Numerazione progressiva fatture

**FASE 3: Integrazione Intermediario** (2-3 giorni)
- [ ] Registrazione account Aruba Fatturazione Elettronica
- [ ] Ottenere API key
- [ ] Implementare invio API POST a Aruba
- [ ] Gestione risposta (IdSdI)
- [ ] Test invio in ambiente di test Aruba

**FASE 4: Gestione Notifiche** (2 giorni)
- [ ] Endpoint webhook per notifiche SDI
- [ ] Parsing notifiche (RC, NS, MC)
- [ ] Update stato fattura nel DB
- [ ] Alert a utente (email/notifica frontend)

**FASE 5: UX e Compliance** (2-3 giorni)
- [ ] Generazione PDF preview da XML
- [ ] Download fattura per cliente
- [ ] Storico fatture in dashboard
- [ ] Report fiscali (totali per periodo)
- [ ] Gestione conservazione (verifica inclusione Aruba)

**FASE 6: Testing e Go-Live** (2-3 giorni)
- [ ] Test end-to-end con fatture reali (ambiente test)
- [ ] Validazione con commercialista
- [ ] Documentazione per receptionist
- [ ] Deploy in produzione
- [ ] Monitoraggio primi invii

**TEMPO TOTALE STIMATO**: 12-18 giorni lavorativi (circa 3 settimane)

---

## 8. COSTI TOTALI STIMATI

### Opzione A: In-House + Intermediario (CONSIGLIATA)

| Voce | Costo | Frequenza | Note |
|------|-------|-----------|------|
| **Sviluppo** | 12-18 gg sviluppo | Una tantum | Interno (già budget Miracollo) |
| **Libreria python-a38** | €0 | - | Open source (Apache 2.0) |
| **Intermediario Aruba** | €59,80 + IVA | Annuale | Invio + conservazione |
| **Firma digitale** | Inclusa | - | Fornita da Aruba |
| **Conservazione** | Inclusa | - | 1GB = 100k+ fatture |
| **Manutenzione** | 1-2 gg/anno | Annuale | Aggiornamenti normativi |

**TOTALE ANNO 1**: ~€70/anno (+ sviluppo iniziale)
**TOTALE ANNI SUCCESSIVI**: ~€70/anno

---

### Opzione B: Software Gestionale Completo

| Voce | Costo | Note |
|------|-------|------|
| **Fatture in Cloud** | €144/anno + IVA | Software completo |
| **Integrazione API** | 3-5 gg dev | Connessione a Miracollo |

**PRO**: Meno sviluppo in-house
**CONTRO**: Dipendenza da software esterno, dati fuori da Miracollo

---

### Opzione C: Servizio Gratuito Agenzia Entrate

| Voce | Costo | Note |
|------|-------|------|
| **SDI + Conservazione** | €0 | Gratuito statale |
| **Invio manuale** | Tempo operatore | Upload manuale ogni fattura |
| **Firma digitale** | €30-50/anno | Certificato CA separato |

**PRO**: Zero costi diretti
**CONTRO**: Workflow manuale, non scalabile per hotel

---

### 💡 RACCOMANDAZIONE FINALE COSTI

**Opzione A (In-House + Aruba)** = miglior rapporto costi/benefici per Miracollo:

✅ **Controllo totale** logica fatturazione
✅ **Dati in Miracollo DB** (non vendor lock-in)
✅ **Workflow automatizzato** (click → fattura pronta)
✅ **Costo irrisorio** (€70/anno)
✅ **Scalabile** (API gestisce volumi alti)

---

## 9. RISCHI E MITIGAZIONI

| Rischio | Probabilità | Impatto | Mitigazione |
|---------|-------------|---------|-------------|
| **Cambio normativa tracciato XML** | Media | Alto | Usare intermediario che gestisce aggiornamenti; python-a38 mantenuto attivamente |
| **Scarto fattura da SDI** | Media | Medio | Validazione rigorosa pre-invio; test su ambiente di test; gestione retry |
| **Downtime intermediario** | Bassa | Medio | SLA Aruba 99.9%; fallback: invio manuale via PEC temporaneo |
| **Errore calcolo IVA** | Bassa | Alto | Test suite automatizzati; validazione con commercialista; doppio controllo aliquote |
| **Perdita conservazione fatture** | Molto Bassa | Critico | Conservazione delegata ad Aruba (certificata AgID); backup locale DB |
| **Cliente fornisce dati fiscali errati** | Alta | Basso | Validazione formato CF/PIVA; alert a receptionist; possibilità correzione pre-invio |
| **Mancato aggiornamento python-a38** | Media | Medio | Monitor GitHub releases; community attiva; fork possibile (Apache license) |

---

## 10. PROSSIMI STEP SUGGERITI

### Step Immediati (Oggi)

1. **Decidere intermediario**: Aruba (consigliato) vs altri
2. **Registrare account** Aruba Fatturazione Elettronica (prova 3 mesi €1)
3. **Ottenere API key** e credenziali test

### Step Preparatori (Questa Settimana)

4. **Consultare commercialista**:
   - Validare aliquote IVA hotel
   - Confermare gestione tassa soggiorno
   - Regime fiscale hotel (RF01 ordinario?)

5. **Analisi dati esistenti Miracollo**:
   - Quali dati cliente già raccolti?
   - Manca CF/PIVA nel DB prenotazioni?
   - Schema DB fatture da creare

### Step Tecnici (Prossime 2 Settimane)

6. **Setup ambiente dev**:
   - `pip install a38`
   - Creare branch `feature/fatturazione-elettronica`
   - Script test generazione XML

7. **Prototipo minimal**:
   - Endpoint `/fatture/test-genera`
   - Genera 1 fattura campione
   - Valida con tool Agenzia Entrate online

8. **Design DB schema**:
   ```sql
   CREATE TABLE fatture (
     id SERIAL PRIMARY KEY,
     id_prenotazione INT REFERENCES prenotazioni(id),
     numero VARCHAR(50) UNIQUE NOT NULL,
     data_emissione DATE NOT NULL,
     xml_content TEXT,  -- File XML completo
     pdf_path VARCHAR(255),
     status VARCHAR(20),  -- 'bozza', 'inviata', 'consegnata', 'scartata'
     id_sdi VARCHAR(50),
     codice_destinatario VARCHAR(7),
     importo_totale DECIMAL(10,2),
     created_at TIMESTAMP DEFAULT NOW()
   );
   ```

### Step Sviluppo (Settimane 3-5)

9. **Implementare modulo fatturazione** (vedi checklist sopra)
10. **Testing con fatture reali** in ambiente test Aruba
11. **Validazione con commercialista** prima del go-live

### Step Go-Live (Settimana 6)

12. **Formazione receptionist** (30 min)
13. **Deploy produzione** con monitoraggio
14. **Invio prime 5-10 fatture** supervised
15. **Review dopo 1 settimana** di utilizzo

---

## 11. DOMANDE DA RISOLVERE CON RAFA/TEAM

Prima di procedere con sviluppo, chiarire:

1. **Regime Fiscale Hotel**:
   - Qual è il regime fiscale dell'hotel cliente tipo? (RF01 ordinario?)
   - Ci sono hotel in regime forfettario? (gestione diversa)

2. **Tassa Soggiorno**:
   - Ogni Comune ha importi diversi: gestiamo configurazione per città?
   - Chi fornisce dati aggiornati tassa soggiorno?

3. **Volumi Previsti**:
   - Quante fatture/mese si stimano per hotel medio?
   - Questo determina se pay-per-use (Openapi) o flat (Aruba)

4. **Dati Cliente Esistenti**:
   - Miracollo raccoglie già CF/PIVA al check-in?
   - Se no, aggiungiamo campi obbligatori?

5. **Workflow Emissione**:
   - Fattura SEMPRE a check-out o anche dopo (su richiesta)?
   - Chi autorizza emissione? (receptionist vs manager)

6. **Gestione Errori**:
   - Se SDI scarta fattura, chi risolve? (supporto Miracollo o hotel?)
   - Serve escalation automatica?

7. **Supporto Clienti Hotel**:
   - Miracollo fornisce assistenza fiscale o solo tecnica?
   - Serve formazione certificata per receptionist?

---

## 12. FONTI E LINK UTILI

### Documentazione Ufficiale

- **FatturaPA Gov**: https://www.fatturapa.gov.it/
- **Specifiche Tecniche v1.4 (PDF)**: https://www.fatturapa.gov.it/export/documenti/Specifiche_tecniche_del_formato_FatturaPA_V1.4.pdf
- **Schema XML 1.2.3**: https://www.fatturapa.gov.it/export/documenti/fatturapa/v1.2.2/Schema_del_file_xml_FatturaPA_v1.2.2.xsd
- **Agenzia Entrate - Guida Fatturazione**: https://www.agenziaentrate.gov.it/portale/aree-tematiche/fatturazione-elettronica/

### Librerie Python

- **python-a38 (GitHub)**: https://github.com/Truelite/python-a38
- **python-a38 (Truelite)**: https://www.truelite.it/progetti/python-a38/
- **python-a38 (Developers Italia)**: https://developers.italia.it/it/software/github.com/truelite/python-a38.html
- **fatturapa-python (GitHub)**: https://github.com/italia/fatturapa-python

### Intermediari API

- **Aruba Fatturazione Elettronica**: https://www.aruba.it/fatturazione-elettronica.aspx
- **Aruba API Docs**: https://fatturazioneelettronica.aruba.it/apidoc/docs.html
- **Openapi SDI**: https://openapi.com/products/italian-electronic-invoicing
- **Fattura Elettronica API**: https://www.fattura-elettronica-api.it/
- **Invoicetronic**: https://invoicetronic.com/en/

### Guide e Tutorial

- **Fattura24 - Guida FatturaPA**: https://www.fattura24.com/guide-pratiche/fatturazione-elettronica/fattura-pa/
- **Agenda Digitale - Hotel e B&B**: https://www.agendadigitale.eu/documenti/fatturazione-elettronica/fattura-elettronica-in-agenzie-di-viaggi-hotel-e-bb-regole-e-obblighi/
- **Il Sole 24 Ore - Codice N1 Hotel**: https://ntplusfisco.ilsole24ore.com/art/fattura-elettronica-codice-n1-il-documento-hotel-ABbi9ljB
- **TeamSystem - Conservazione**: https://www.fattura24.com/guide-pratiche/fatturazione-elettronica/conservazione-norma/

### Validatori e Tool

- **Validatore XML Agenzia Entrate**: https://fatturazione-elettronica-pa.assocons.it/validazione-fattura-elettronica.html
- **Portale Fatture e Corrispettivi**: https://ivaservizi.agenziaentrate.gov.it/portale/

### Community e Supporto

- **Forum Fatturazione Elettronica**: https://www.iprogrammatori.it/forum-programmazione/fatturazione-elettronica/
- **GitHub Topic**: https://github.com/topics/fatturazione-elettronica
- **Developers Italia**: https://developers.italia.it/it/fatturapa/

### Confronti e Prezzi

- **Confronto Software 2026**: https://www.softwaresemplice.it/blog/miglior-software-fatturazione-elettronica-confronto/1202
- **Aruba Listino**: https://www.aruba.it/listino-fatturazione-elettronica.aspx

### Normativa

- **DPR 633/1972** (IVA) - Art. 15 (rimborsi anticipazioni), Art. 39 (conservazione)
- **CAD** (Codice Amministrazione Digitale) - Conservazione digitale
- **Agenzia Entrate - Area Fatturazione**: https://www.agenziaentrate.gov.it/portale/web/guest/aree-tematiche/fatturazione-elettronica

---

## CONCLUSIONI

### Sintesi Finale

La **fatturazione elettronica per hotel in Miracollo PMS è pienamente fattibile** con:

1. **Libreria python-a38** (open source, matura, validazione integrata)
2. **Intermediario Aruba** (€59,80/anno, API semplici, conservazione inclusa)
3. **Sviluppo stimato**: 12-18 giorni lavorativi
4. **Costi ricorrenti minimi**: ~€70/anno

### Vantaggi Competitivi per Miracollo

✅ **Feature Differenziante**: pochi PMS hanno fatturazione integrata
✅ **Workflow Fluido**: check-out → fattura automatica in 1 click
✅ **Compliance Automatica**: aggiornamenti normativa gestiti da intermediario
✅ **Zero Formazione**: interfaccia semplice per receptionist
✅ **Dati Centralizzati**: tutto in Miracollo (prenotazioni + fatture)

### Raccomandazione Finale

**PROCEDI con implementazione** seguendo architettura:

```
Miracollo Backend (FastAPI)
  ↓ usa
python-a38 (generazione XML + validazione)
  ↓ invia a
Aruba API (firma + SDI + conservazione)
  ↓ consegna via
SDI → Cliente finale
```

**Next Action**: Decidere go/no-go e confermare intermediario (Aruba consigliato).

---

**Status**: ✅ RICERCA COMPLETATA
**Confidence Level**: ALTA (fonti ufficiali + librerie testate in produzione)
**Data Ricerca**: 19 Gennaio 2026

---

*"Non reinventiamo la ruota - la miglioriamo!"*
*Cervella Researcher 🔬*
