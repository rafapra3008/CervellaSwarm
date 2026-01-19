# RICERCA - SPRING SQL: Importazione Fatture XML

> **Ricercatrice:** Cervella Researcher
> **Data:** 19 Gennaio 2026
> **Progetto:** Miracollo - Integrazione Fatturazione Hotel
> **Status:** RICERCA COMPLETATA

---

## EXECUTIVE SUMMARY

### RISULTATO RICERCA

**SPRING SQL NON ha documentazione pubblica** per importazione XML da cartella monitorata.

**RACCOMANDAZIONE:** Contattare Sistemi S.p.A. (supporto tecnico SPRING SQL) per ottenere:
1. Specifiche formato XML accettato da SPRING
2. Modalità import (cartella monitorata vs manuale)
3. Best practices integrazione PMS hotel

**ALTERNATIVA:** Usare formato FatturaPA standard - accettato da TUTTI i gestionali italiani.

---

## CONTESTO

### La Situazione

```
PRIMA (Ericsoft + SPRING):
  Ericsoft PMS → genera XML → cartella
  SPRING SQL → legge cartella → importa fatture
  Contabilista → emette fattura da SPRING
```

### La Domanda

Come faceva Ericsoft a generare XML compatibili con SPRING?
Che formato usava? FatturaPA standard o proprietario SPRING?

---

## SCOPERTE PRINCIPALI

### 1. SPRING SQL - Software Gestionale

**Cosa è:**
- Gestionale PMI di Sistemi S.p.A. (45+ anni esperienza, 10.000+ aziende)
- Moduli: contabilità, ciclo attivo/passivo, magazzino
- Integrazione nativa con PROFIS (dichiarazioni fiscali)

**Capacità XML:**
- ✅ Export XML automatico verso PROFIS (dichiarazioni fiscali)
- ❓ Import XML da cartella monitorata: NON DOCUMENTATO pubblicamente
- ✅ Gestione fatturazione elettronica (confermato)

**Fonti:**
- [SPRING SQL Overview - Sistemi Due Roma](https://www.sistemidueroma.it/prodotti/software-per-aziende/spring-sql)
- [SPRING SQL Scheda - Sistemi.com](https://www.sistemi.com/downloads/SPRING-scheda.pdf)

### 2. Ericsoft PMS - Hotel Management

**Cosa è:**
- PMS specifico per hotel (reception, prenotazioni, fatturazione)
- Include modulo fatturazione elettronica
- NON usa Zucchetti Digital Hub (usa sistema proprio)

**Capacità XML:**
- ✅ Genera fatture elettroniche formato XML
- ✅ Invio SDI (Sistema di Interscambio)
- ✅ Export XML per gestionali esterni

**CRITICO:** NON ho trovato documentazione specifica su integrazione Ericsoft → SPRING SQL.

**Fonti:**
- [Ericsoft Fatturazione Elettronica](https://www.ericsoft.com/it/software-fatture-elettroniche-hotel)
- [Ericsoft Suite PMS](https://www.ericsoft.com/it/software-gestionali-ericsoft)

### 3. FatturaPA - Formato Standard Italiano

**Versione Corrente:** 1.9 (attiva da 1 Aprile 2025)

**Campi OBBLIGATORI per Fattura Hotel:**

```xml
<FatturaElettronicaHeader>
  <DatiTrasmissione>
    <!-- ID trasmittente e destinatario -->
  </DatiTrasmissione>
  <CedentePrestatore>
    <!-- Hotel: Partita IVA, ragione sociale, indirizzo -->
  </CedentePrestatore>
  <CessionarioCommittente>
    <!-- Cliente: dati fiscali -->
  </CessionarioCommittente>
</FatturaElettronicaHeader>

<FatturaElettronicaBody>
  <DatiGenerali>
    <Numero>001</Numero>
    <Data>2026-01-19</Data>
    <Divisa>EUR</Divisa>
  </DatiGenerali>

  <DatiBeniServizi>
    <DettaglioLinee>
      <Descrizione>Soggiorno camera doppia</Descrizione>
      <Quantita>2</Quantita>
      <PrezzoUnitario>100.00</PrezzoUnitario>
      <AliquotaIVA>10.00</AliquotaIVA>
    </DettaglioLinee>
  </DatiBeniServizi>

  <DatiRiepilogo>
    <ImponibileImporto>200.00</ImponibileImporto>
    <Imposta>20.00</Imposta>
  </DatiRiepilogo>
</FatturaElettronicaBody>
```

**Fonti:**
- [Specifiche Tecniche FatturaPA v1.2 (PDF ufficiale)](https://www.fatturapa.gov.it/export/documenti/Specifiche_tecniche_del_formato_FatturaPA_v1.2.pdf)
- [Formato FatturaPA - Documentazione](https://www.fatturapa.gov.it/it/norme-e-regole/documentazione-fattura-elettronica/formato-fatturapa/)

### 4. Zucchetti Digital Hub - Portale Fatturazione

**Cosa è:**
- Hub centralizzato per fatturazione elettronica
- Integrazione con gestionali Zucchetti (Hotel2000, Hoasys, etc.)
- NON usato né da Ericsoft né da SPRING SQL

**Come funziona:**
```
PMS Hotel (Zucchetti) → Digital Hub → SDI → Agenzia Entrate
                            ↓
                    Conservazione digitale
```

**Rilevanza per noi:** BASSA - né Ericsoft né SPRING usano Digital Hub.

**Fonti:**
- [Digital Hub Zucchetti Hotel](https://www.hotel2000pms.it/fatturazione-elettronica/)
- [Pacchetti Fatture Hospitality](https://www.zucchetti.it/store/cms/fatture-hospitality/335-fatturazione-elettronica-bar-ristoranti-pizzerie-hotel-bb-descrizione.html)

### 5. Import Automatico da Cartella - Best Practices

**Come funziona normalmente:**

```
Software Contabilità → monitora cartella → importa XML automaticamente

Esempi:
- INTEGRATO GB: carica XML automaticamente, divide per mese
- Namirial VSP: import multipli XML/ZIP, associa per P.IVA
- DATALOG: importa da cartella, registra in prima nota
- Atlantis Evo: folder monitorato (con servizio Pro)
```

**Processo Standard:**
1. PMS genera XML FatturaPA
2. Salva in cartella condivisa (es: `/fatture/export/`)
3. Software contabilità monitora cartella
4. Import automatico quando rileva nuovi file
5. Validazione XML + registrazione in contabilità

**ATTENZIONE:** SPRING SQL NON ha documentazione pubblica su questo processo!

**Fonti:**
- [Importazione Fatture DATALOG](https://www.datalog.it/come-importare-le-fatture-elettroniche-in-contabilita/)
- [INTEGRATO GB - Import XML](https://www.softwareintegrato.it/software-per-commercialisti/contabilita-commercialisti/importazione-fatture-elettroniche-xml/)

---

## ANALISI INTEGRAZIONE PMS → SPRING

### Scenario Probabile (Ipotesi da Verificare)

```
IPOTESI 1: Ericsoft generava FatturaPA standard
  ↓
  XML salvato in cartella condivisa
  ↓
  SPRING importava manualmente (o via addon non documentato)
  ↓
  Contabilista registrava fattura

IPOTESI 2: Ericsoft aveva formato proprietario SPRING
  ↓
  Sistemi S.p.A. fornì specifiche a Ericsoft
  ↓
  XML custom per SPRING
  ↓
  Import automatico via funzione non pubblica
```

### Cosa NON ho trovato

❌ Documentazione tecnica pubblica SPRING SQL per import XML
❌ Specifiche formato XML proprietario SPRING (se esiste)
❌ Casi studio Ericsoft + SPRING integrazione
❌ API o webservice SPRING per import programmatico

### Cosa Serve Sapere

**DOMANDE CRITICHE per Sistemi S.p.A.:**

1. SPRING SQL supporta import automatico da cartella?
2. Quale formato XML accetta? (FatturaPA standard o proprietario?)
3. Esiste API/webservice per push fatture?
4. Come faceva Ericsoft PMS a integrarsi?
5. Esistono best practices per PMS hotel + SPRING?

**Contatto:**
- Tel: 011.40.19.650
- Email: marketing@sistemi.com
- Web: www.sistemi.com

---

## COMPETITOR ANALYSIS - PMS HOTEL

### Come fanno altri PMS italiani

**Cloud Hotel:**
- Export XML FatturaPA standard
- Gestione via PEC o portale Agenzia Entrate
- NO integrazione diretta gestionali

**Bedzzle PMS:**
- Invio diretto SDI
- Export XML per contabilità
- Formato FatturaPA standard

**Hotel Runner:**
- Fatture e corrispettivi elettronici
- Export XML standard
- Integrazione con commercialisti via file

**TeamSystem Hospitality:**
- PMS integrato con gestionale TS
- Fatturazione elettronica nativa
- Tutto in un unico ecosistema (niente export)

**Pattern Comune:**
TUTTI usano **FatturaPA standard** per export verso contabilità esterna.

**Fonti:**
- [Cloud Hotel Fatturazione](https://www.cloud-hotel.it/en/blog/view/id/55/title/fattura-elettronica-come-funziona-e-come-gestirla-in-cloud-hotel.html)
- [Bedzzle PMS](https://www.bedzzle.com/it/pms/fatturazione-elettronica-sdi-hotel)
- [TeamSystem Hospitality](https://www.teamsystem.com/horeca/ts-hospitality/funzionalita/pms/)

---

## RACCOMANDAZIONI per MIRACOLLO

### OPZIONE A - Formato FatturaPA Standard (RACCOMANDATO!)

**PRO:**
- ✅ Standard nazionale - funziona con TUTTI i gestionali
- ✅ Documentazione completa e pubblica
- ✅ Validatori XML disponibili
- ✅ Se hotel cambia gestionale, funziona lo stesso
- ✅ Librerie Python esistenti (fattura-elettronica-reader, etc.)

**CONTRO:**
- ⚠️ SPRING potrebbe richiedere import manuale (da verificare)
- ⚠️ Formato complesso (ma librerie aiutano)

**Implementazione:**
```python
# backend/services/fiscal/fatturapa_generator.py

from datetime import date
from decimal import Decimal
import xml.etree.ElementTree as ET

def generate_fatturapa_xml(invoice_data: dict) -> str:
    """Genera XML FatturaPA v1.9 standard"""

    root = ET.Element("p:FatturaElettronica")
    root.set("versione", "FPR12")
    root.set("xmlns:p", "http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2")

    # Header
    header = ET.SubElement(root, "FatturaElettronicaHeader")

    # ... costruzione completa XML FatturaPA

    return ET.tostring(root, encoding='unicode')
```

**Next Steps:**
1. Studiare libreria `fattura-elettronica-reader` (pip)
2. Implementare generator FatturaPA
3. Testare import in SPRING (con contabilista)
4. Se SPRING richiede manuale, valutare Opzione B

### OPZIONE B - Contattare Sistemi S.p.A.

**Quando:**
- Se Opzione A non funziona (import manuale troppo lento)
- Se hotel ESIGE import automatico

**Cosa chiedere:**
1. "Come si integrava Ericsoft PMS con SPRING?"
2. "Esiste formato XML proprietario per import veloce?"
3. "SPRING supporta webservice/API per import fatture?"
4. "Potete condividere specifiche tecniche?"

**Approccio:**
- Email a marketing@sistemi.com
- Presentarsi come "PMS hotel in sviluppo"
- Chiedere supporto tecnico/commerciale
- Possibile richiesta accesso documentazione riservata

### OPZIONE C - Integrazione Ibrida

**Se SPRING non importa automaticamente:**

```
Miracollo → genera FatturaPA XML → cartella condivisa
                                        ↓
                          Contabilista apre SPRING
                                        ↓
                          Import manuale da cartella
                                        ↓
                          Emissione fattura
```

**PRO:**
- ✅ Funziona SICURAMENTE (no dipendenza da SPRING API)
- ✅ Formato standard
- ✅ Contabilista controlla prima di emettere

**CONTRO:**
- ❌ Non automatico al 100%
- ❌ Richiede intervento umano

---

## FILE DA CREARE (Next Phase)

Quando si procede con implementazione:

```
backend/services/fiscal/
├── fatturapa_generator.py      # Core generator XML
├── fatturapa_validator.py      # Validatore pre-export
├── schemas/
│   └── fatturapa_v1.9.xsd      # Schema ufficiale
└── tests/
    ├── test_fatturapa_generation.py
    └── fixtures/
        └── sample_hotel_invoice.xml
```

---

## FONTI COMPLETE

### SPRING SQL
- [SPRING SQL Overview - Sistemi Due Roma](https://www.sistemidueroma.it/prodotti/software-per-aziende/spring-sql)
- [SPRING SQL Scheda - Sistemi.com](https://www.sistemi.com/downloads/SPRING-scheda.pdf)
- [SPRING SQL Manuali - C2 Sistemi](https://www.c2sistemi.it/news-spring/)
- [Gestione Integrazioni SPRING - Sistemi Tre](https://www.sistemitre.it/noteoperative/caso-risolto-gestione-integrazioni-e-autofatture-estere-e-solver-enologia-e-spring-sql/)

### Ericsoft PMS
- [Ericsoft Fatturazione Elettronica](https://www.ericsoft.com/it/software-fatture-elettroniche-hotel)
- [Ericsoft Suite PMS](https://www.ericsoft.com/it/software-gestionali-ericsoft)
- [Ericsoft Gestionale Hotel](https://www.ericsoft.com/it/software-gestionale-hotel-pms)

### FatturaPA Standard
- [Formato FatturaPA - Documentazione Ufficiale](https://www.fatturapa.gov.it/it/norme-e-regole/documentazione-fattura-elettronica/formato-fatturapa/)
- [Specifiche Tecniche FatturaPA v1.2 (PDF)](https://www.fatturapa.gov.it/export/documenti/Specifiche_tecniche_del_formato_FatturaPA_v1.2.pdf)
- [Guida FatturaPA 2026 - Fattura24](https://www.fattura24.com/guide-pratiche/fatturazione-elettronica/fattura-pa/)
- [Documentazione SDI](https://www.fatturapa.gov.it/it/norme-e-regole/DocumentazioneSDI/)

### Zucchetti Digital Hub
- [Digital Hub Hotel2000](https://www.hotel2000pms.it/fatturazione-elettronica/)
- [Pacchetti Fatturazione Hospitality](https://www.zucchetti.it/store/cms/fatture-hospitality/335-fatturazione-elettronica-bar-ristoranti-pizzerie-hotel-bb-descrizione.html)
- [Fatturazione Elettronica Aziende - Zucchetti](https://www.zucchetti.it/it/cms/soluzioni/obblighi-normativi/fatturazione-elettronica/digital-hub/fatturazione-elettronica-aziende-descrizione.html)

### Import Automatico Software
- [Importazione Fatture DATALOG](https://www.datalog.it/come-importare-le-fatture-elettroniche-in-contabilita/)
- [INTEGRATO GB - Import XML](https://www.softwareintegrato.it/software-per-commercialisti/contabilita-commercialisti/importazione-fatture-elettroniche-xml/)
- [Namirial VSP - Contabilizzazione](https://servicedesk-vsp.namirial.com/hc/it/articles/7981138268049-Contabilizzazione-Fatture-Elettroniche)
- [Software Contabile - Import XML](https://www.softwarecontabile.com/software-contabilita-studi-aziende/importazione-fatture-elettroniche-xml/)

### PMS Hotel - Competitor
- [Cloud Hotel Fatturazione](https://www.cloud-hotel.it/en/blog/view/id/55/title/fattura-elettronica-come-funziona-e-come-gestirla-in-cloud-hotel.html)
- [Bedzzle PMS Fatturazione SDI](https://www.bedzzle.com/it/pms/fatturazione-elettronica-sdi-hotel)
- [Chekin Fatturazione Hotel 2025](https://chekin.com/it/blog/fatturazione-elettronica-hotel-guida/)
- [TeamSystem Hospitality PMS](https://www.teamsystem.com/horeca/ts-hospitality/funzionalita/pms/)
- [Integrazione ERP-PMS Hotel](https://www.azienda-digitale.it/gestione-aziendale/integrazione-erp-pms-per-gestione-hotel/)

---

## CONCLUSIONI

### TL;DR

**SPRING SQL:**
- Software contabilità SME molto diffuso (10.000+ aziende)
- Export XML confermato, import NON documentato pubblicamente
- Serve contatto con Sistemi S.p.A. per specifiche

**FatturaPA:**
- Standard nazionale OBBLIGATORIO
- Tutti i PMS italiani lo usano per export
- ALTAMENTE RACCOMANDATO per Miracollo

**NEXT ACTION:**
1. Implementare generator FatturaPA standard (SICURO)
2. Testare import in SPRING con contabilista hotel
3. Se problemi, contattare Sistemi supporto tecnico

### La Mia Raccomandazione

**USARE FATTURAPA STANDARD.**

**Perché:**
- Standard nazionale = compatibilità garantita
- Se hotel cambia gestionale, funziona lo stesso
- Documentazione completa
- Librerie Python disponibili
- Futureproof

**Rischio:**
- SPRING potrebbe non importare automaticamente
- Soluzione: contabilista import manuale (workflow accettabile)

---

**Ricerca completata:** 19 Gennaio 2026, 18:30
**Tempo ricerca:** 45 minuti
**Fonti consultate:** 30+
**Status:** PRONTA PER DECISIONE

*"Studiare prima di agire - sempre!"*
*Cervella Researcher* 🔬
