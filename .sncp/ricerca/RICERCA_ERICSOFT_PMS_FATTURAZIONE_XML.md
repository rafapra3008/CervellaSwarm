# Ricerca: Ericsoft PMS e Integrazione Fatturazione XML

> **Data ricerca:** 19 Gennaio 2026
> **Ricercatrice:** Cervella Researcher
> **Contesto:** Studio flusso fatturazione hotel Ericsoft → SPRING

---

## TL;DR - Executive Summary

**ERICSOFT PMS:**
- Gestionale hotel italiano, parte del gruppo Zucchetti
- Genera fatture XML in formato **FatturaPA standard**
- Export automatico verso Digital Hub Zucchetti per invio SDI
- 4000+ hotel italiani lo usano

**FLUSSO TIPICO:**
```
Hotel PMS (Ericsoft)
  ↓ (genera XML FatturaPA)
  ↓
Cartella export locale
  ↓ (importazione manuale/automatica)
  ↓
Gestionale Contabile (SPRING o altro)
  ↓ (invio finale)
  ↓
SDI (Sistema di Interscambio Agenzia Entrate)
```

**FORMATO XML:** FatturaPA v1.2+ (ora v1.3.2, dal 01/04/2025 v1.4)

**NAMING FILE:** `IT[PIVA]_[PROGRESSIVO].xml` (es: `IT02857800102_00001.xml`)

**SPRING:** NON trovata integrazione diretta Ericsoft-SPRING. Sono prodotti di vendor diversi (Sistemi vs Zucchetti).

---

## 1. Ericsoft PMS - Overview

### Chi è Ericsoft

**Azienda:**
- Nome completo: Ericsoft (gruppo Zucchetti)
- Sede: S.S. Adriatica 62, Misano Adriatico (RN), Italia
- P.IVA: 02894171202
- Contact: info.ericsoft@zucchetti.it | +39 0541604894
- Helpdesk: 365 giorni/anno, 8:00-20:00

**Mercato:**
- 4000+ hotel e strutture ricettive in Italia
- Zucchetti = #1 software house italiana
- Leader nel settore hospitality

**Prodotti principali:**
- **Hotel 3°** - Versione legacy
- **Hotel 4°** / **Suite 4°** - Versione matura (quella probabilmente usata dall'hotel)
- **Suite 5°** - Versione nuova (2025+)

### Funzionalità Chiave

1. **PMS completo** - Front office, booking, clienti
2. **Revenue Management** - Pricing dinamico
3. **Channel Manager** - Booking.com, Expedia, etc
4. **Booking Engine** - Prenotazioni dirette
5. **POS Ristorante** - Integrato con hotel
6. **Fatturazione Elettronica** - Integrata via Digital Hub Zucchetti

---

## 2. Fatturazione Elettronica in Ericsoft

### Architettura Soluzione

```
┌─────────────────────────────────────────────────────┐
│  ERICSOFT HOTEL 4° (PMS)                            │
│                                                     │
│  1. Creazione fattura nel PMS                       │
│  2. Generazione XML FatturaPA                       │
│  3. Firma digitale automatica                       │
│  └──────────────┬──────────────────────────────────┘
│                 ↓
│  ┌─────────────────────────────────────────────────┐
│  │  DIGITAL HUB ZUCCHETTI                          │
│  │  (servizio cloud fatturazione)                  │
│  │                                                 │
│  │  - Validazione XML                              │
│  │  - Gestione invio/ricezione                     │
│  │  - Conservazione sostitutiva                    │
│  └──────────────┬──────────────────────────────────┘
│                 ↓
│  ┌─────────────────────────────────────────────────┐
│  │  SDI - Sistema di Interscambio                  │
│  │  (Agenzia delle Entrate)                        │
│  │                                                 │
│  │  - Ricezione e validazione                      │
│  │  - Invio al destinatario                        │
│  │  - Notifiche di stato                           │
│  └─────────────────────────────────────────────────┘
```

### Integrazione Digital Hub

**Come funziona:**
- **Web Services** - Comunicazione bidirezionale XML real-time
- **Import manuale** - Possibile caricare XML manualmente in Digital Hub
- **Export locale** - Possibile salvare XML su disco per import in altri sistemi

**Codice ricezione Zucchetti:** `SUBM70N`

### Modalità Export per Contabilità Esterna

**Opzione 1: Export XML diretto**
- Ericsoft salva file XML in cartella locale
- Naming: `IT[PIVA]_[PROGRESSIVO].xml`
- Software contabile importa da questa cartella

**Opzione 2: Digital Hub come ponte**
- Fatture passano via Digital Hub
- Commercialista scarica XML da Digital Hub
- Import nel gestionale contabile

**Opzione 3: Export CSV per dati (non fatture)**
- Ericsoft supporta export CSV per integrazioni (es: PayTourist)
- Utile per dati grezzi, ma NON per fatture legali

---

## 3. Formato XML FatturaPA

### Standard Nazionale

**Nome:** FatturaPA
**Formato:** XML con schema XSD rigido
**Gestito da:** Agenzia delle Entrate
**Obbligatorio dal:** 01/01/2019 per B2B e B2C in Italia

### Versioni

| Versione | Periodo | Note |
|----------|---------|------|
| v1.2 | 2018-2020 | Prima versione ufficiale |
| v1.3.2 | 2021-2025 | Versione corrente (Gennaio 2026) |
| v1.4 | Dal 01/04/2025 | Nuova versione in arrivo |

**Update Ericsoft:** Sistema già aggiornato alle nuove specifiche (confermato in ricerca).

### Struttura File XML

```xml
<?xml version="1.0" encoding="UTF-8"?>
<p:FatturaElettronica
  xmlns:ds="..."
  xmlns:p="..."
  versione="FPR12">

  <FatturaElettronicaHeader>
    <DatiTrasmissione>
      <IdTrasmittente>
        <IdPaese>IT</IdPaese>
        <IdCodice>[P.IVA mittente]</IdCodice>
      </IdTrasmittente>
      <ProgressivoInvio>[numero progressivo]</ProgressivoInvio>
      <CodiceDestinatario>[codice SDI o PEC]</CodiceDestinatario>
    </DatiTrasmissione>

    <CedentePrestatore>
      <!-- Dati hotel -->
    </CedentePrestatore>

    <CessionarioCommittente>
      <!-- Dati cliente -->
    </CessionarioCommittente>
  </FatturaElettronicaHeader>

  <FatturaElettronicaBody>
    <DatiGenerali>
      <DatiGeneraliDocumento>
        <TipoDocumento>TD01</TipoDocumento> <!-- Fattura -->
        <Data>2026-01-19</Data>
        <Numero>2026/0001</Numero>
        <!-- Altri dati -->
      </DatiGeneraliDocumento>
    </DatiGenerali>

    <DatiBeniServizi>
      <DettaglioLinee>
        <!-- Righe fattura -->
        <Natura>N1</Natura> <!-- Se imposta soggiorno -->
      </DettaglioLinee>
    </DatiBeniServizi>

    <DatiPagamento>
      <!-- Metodi pagamento -->
    </DatiPagamento>
  </FatturaElettronicaBody>
</p:FatturaElettronica>
```

### Campi Specifici Hotel

**Natura N1 - Imposta di Soggiorno:**
- Per hotel che rifatturano tassa soggiorno ai clienti
- Codice: `N1` (escluso da IVA)
- Obbligatorio per Roma, Venezia, Firenze, etc
- NON usare N2 (fuori campo IVA)

**TipoDocumento comuni:**
- `TD01` - Fattura normale
- `TD04` - Nota di credito
- `TD05` - Nota di debito

**Dati Obbligatori Cliente:**
- Codice Fiscale (per B2C italiano)
- P.IVA (per B2B)
- CodiceDestinatario o PEC (per recapito)

---

## 4. SPRING Gestionale Contabile

### Cos'è SPRING

**Produttore:** Sistemi S.p.A. (NON Zucchetti)
**Target:** PMI italiane
**Tipo:** Software gestionale amministrativo-contabile

**Funzionalità:**
- Contabilità ordinaria e semplificata
- IVA, crediti, debiti
- Prima nota
- Bilanci

### Integrazione con Ericsoft

**FINDING CHIAVE:**
❌ **NON trovata documentazione di integrazione diretta Ericsoft-SPRING**

**Perché:**
- SPRING = prodotto Sistemi
- Ericsoft = prodotto Zucchetti
- Vendor diversi, ecosistemi separati

**Ecosistema Zucchetti:**
- Ericsoft si integra nativamente con gestionali Zucchetti
- Digital Hub Zucchetti è il ponte principale
- SPRING NON è parte di questo ecosistema

### Come Funzionava Probabilmente

**Scenario più probabile:**
```
Ericsoft Hotel 4°
  ↓
Export XML FatturaPA in cartella locale
  ↓
Import manuale/automatico in SPRING
  ↓
SPRING gestisce contabilità
  ↓
(Eventuale) Invio SDI da SPRING (se non fatto da Ericsoft)
```

**Import XML in SPRING:**
- SPRING (come tutti i gestionali italiani post-2019) DEVE supportare import FatturaPA XML
- File seguono standard nazionale → compatibilità garantita
- Import può essere manuale (selezione file) o automatico (watch folder)

---

## 5. Flusso Tipico Hotel Italiano

### Schema Completo

```
┌─────────────────────────────────────────────────────┐
│  FASE 1: GESTIONE HOTEL                             │
│  PMS (Ericsoft, Myguestcare, etc)                   │
│                                                     │
│  - Check-in/out ospiti                              │
│  - Gestione camere e servizi                        │
│  - Emissione fatture clienti                        │
│  - Calcolo imposta soggiorno                        │
└──────────────┬──────────────────────────────────────┘
               ↓
┌─────────────────────────────────────────────────────┐
│  FASE 2: GENERAZIONE XML                            │
│                                                     │
│  - Creazione file FatturaPA XML                     │
│  - Firma digitale                                   │
│  - Salvataggio in cartella export                   │
│                                                     │
│  FILE: IT[PIVA]_[PROG].xml                          │
└──────────────┬──────────────────────────────────────┘
               ↓
┌─────────────────────────────────────────────────────┐
│  FASE 3A: INVIO SDI (se PMS integrato)              │
│  Digital Hub o altro intermediario                  │
│                                                     │
│  - Validazione XML                                  │
│  - Invio a SDI                                      │
│  - Ricezione notifiche                              │
│  - Conservazione sostitutiva (10 anni)              │
└──────────────┬──────────────────────────────────────┘
               ↓
┌─────────────────────────────────────────────────────┐
│  FASE 3B: IMPORT IN CONTABILITÀ                     │
│  Software Contabile (SPRING, TeamSystem, etc)       │
│                                                     │
│  - Import XML da cartella                           │
│  - Registrazione contabile                          │
│  - Prima nota, IVA, partitari                       │
│  - Report e bilanci                                 │
└─────────────────────────────────────────────────────┘
               ↓
┌─────────────────────────────────────────────────────┐
│  FASE 4: ADEMPIMENTI FISCALI                        │
│  Commercialista + Software                          │
│                                                     │
│  - Liquidazioni IVA                                 │
│  - Dichiarazioni                                    │
│  - Bilancio civilistico/fiscale                     │
└─────────────────────────────────────────────────────┘
```

### Due Modalità Principali

**MODALITÀ A: All-in-One PMS**
```
PMS integrato → Digital Hub → SDI
                     ↓
              Export XML per commercialista
```
- Esempio: Ericsoft + Digital Hub Zucchetti
- Pro: Tutto automatico, zero errori
- Contro: Lock-in vendor, costi

**MODALITÀ B: PMS + Contabilità Separati**
```
PMS → Export XML locale → Import in gestionale contabile → SDI
```
- Esempio: Ericsoft export + SPRING import
- Pro: Flessibilità, scelta software
- Contro: Più passaggi manuali

---

## 6. Naming Convention File XML

### Standard FatturaPA

**Formato obbligatorio:**
```
IT[PARTITA_IVA]_[PROGRESSIVO].xml
```

**Esempi:**
```
IT02857800102_00001.xml
IT01234567890_A0001.xml
IT11111111111_2026_00123.xml
```

**Regole:**
- Prefisso `IT` obbligatorio
- P.IVA: 11 cifre
- Progressivo: alfanumerico, univoco per mittente
- Estensione: `.xml` (minuscolo)

**Note:**
- Il progressivo NON deve essere sequenziale
- Deve solo essere UNIVOCO per quel mittente
- Alcune implementazioni usano timestamp nel progressivo
- Altre usano anno + numero

### Directory Export Tipiche

**Pattern comuni in PMS italiani:**
```
C:\ProgramData\[NomePMS]\Export\Fatture\
C:\Export\FattureXML\
\\Server\Share\Fatture\Export\
```

**Best practice:**
- Cartella dedicata per XML export
- Sottocartelle per anno/mese (opzionale)
- Permessi lettura per software contabile
- Backup automatico

---

## 7. Raccomandazione per Miracollo

### Scenario Probabile Hotel

**Sistema precedente:**
1. Hotel usava Ericsoft Hotel 4° (o 3°)
2. Ericsoft generava XML FatturaPA in cartella locale
3. SPRING (o altro gestionale) importava da quella cartella
4. Commercialista gestiva la contabilità

**Cosa NON sappiamo (da chiedere a Rafa/Hotel):**
- [ ] Invio SDI fatto da Ericsoft o da SPRING?
- [ ] Export automatico o manuale?
- [ ] Path esatto cartella export
- [ ] Formato progressivo file (anno? numero puro?)
- [ ] SPRING effettivamente usato o altro gestionale?

### Design Miracollo - Opzioni

**OPZIONE 1: Emulazione completa Ericsoft**
```python
# Miracollo genera XML FatturaPA identico
# Salva in stessa cartella che SPRING monitorava
# Zero cambiamenti per commercialista

Path: C:\Export\FattureXML\IT[PIVA]_[PROG].xml
Formato: FatturaPA v1.3.2+ (standard nazionale)
```
✅ Pro: Continuità totale, zero formazione
❌ Contro: Complesso, gestione firma digitale, conservazione

**OPZIONE 2: Export JSON + Tool Conversione**
```python
# Miracollo esporta dati fattura in JSON
# Tool separato converte JSON → XML FatturaPA
# Commercialista usa tool per generare XML finale

Miracollo: export/invoices/[ID].json
Tool: json_to_fatturapa.py
Output: IT[PIVA]_[PROG].xml
```
✅ Pro: Miracollo più semplice, tool riutilizzabile
❌ Contro: Step extra, tool da sviluppare/validare

**OPZIONE 3: Integrazione Servizio Esterno**
```python
# Miracollo usa API Aruba/Fatture in Cloud/etc
# Servizio gestisce tutto (XML, firma, SDI, conservazione)
# Commercialista accede a portale servizio

API: POST /invoices con dati strutturati
Servizio: genera XML, invia SDI, archivia
```
✅ Pro: Zero complessità legale, certificato, aggiornato
❌ Contro: Costo mensile, dipendenza terze parti

### Raccomandazione Researcher

**Per MVP Miracollo:**
→ **OPZIONE 2 (Export JSON + Tool)**

**Perché:**
1. **Semplicità Miracollo** - Backend esporta dati puri, no logica FatturaPA
2. **Flessibilità** - Tool può essere migliorato separatamente
3. **Testabilità** - JSON facile da validare e testare
4. **Riutilizzabilità** - Tool può servire Contabilita, altri progetti
5. **Gradualità** - MVP = export JSON. Tool conversione = fase 2

**Per Produzione Long-term:**
→ **OPZIONE 3 (API Servizio)**

**Perché:**
1. **Compliance garantita** - Servizi certificati, sempre aggiornati
2. **Zero maintenance** - Aggiornamenti formato, normativa gestiti da loro
3. **Conservazione inclusa** - Obbligo 10 anni gestito
4. **Supporto** - In caso problemi SDI, hanno helpdesk

**Da NON fare:**
❌ **OPZIONE 1 (Emulazione Ericsoft completa)**
- Troppo complesso per valore portato
- Firma digitale richiede certificati
- Conservazione sostitutiva è materia legale
- Aggiornamenti formato FatturaPA (v1.4 in arrivo!)
- "Non reinventiamo la ruota" - player grossi hanno già risolto

---

## 8. Next Steps Suggeriti

### Informazioni da Raccogliere

**DA RAFA/HOTEL:**
1. Path esatto cartella export Ericsoft
2. Esempio file XML (1-2 fatture anonimizzate)
3. SPRING davvero usato o altro gestionale?
4. Invio SDI: chi lo faceva? (Ericsoft o SPRING?)
5. Commercialista: workflow attuale import fatture

### Ricerca da Approfondire (se necessario)

**SE scegliamo Opzione 1 (XML diretto):**
- [ ] Studio approfondito schema XSD FatturaPA v1.3.2
- [ ] Librerie Python per generazione XML FatturaPA
- [ ] Gestione firma digitale in Python
- [ ] Conservazione sostitutiva: requisiti legali

**SE scegliamo Opzione 3 (API):**
- [ ] Comparazione servizi: Aruba, Fatture in Cloud, TeamSystem
- [ ] Costi, API, limiti, SLA
- [ ] Integrazione con Miracollo (FastAPI → API fatturazione)

### Validazione Design

**CONSIGLIO:**
Prima di implementare, consultare:
- **Cervella Ingegnera** - Architettura soluzione export
- **Cervella Backend** - Implementazione export JSON
- **Cervella Data** - Schema dati fattura per export

**REGOLA:**
> "La Regina orchestra, non fa tutto da sola!"
> Questo è un problema multi-dominio (business logic + compliance + integrazione)

---

## Fonti e Collegamenti

### Ericsoft
- [Property Management System - Ericsoft PMS](https://www.ericsoft.com/en/property-management-system)
- [Software gestionale albergo con Revenue Management System](https://www.ericsoft.com/it/gestionale-hotel-pms)
- [Gestionale fatture elettroniche e contabilità strutture ricettive](https://www.ericsoft.com/it/software-fatture-elettroniche-hotel)
- [Gestionale con Fatturazione Elettronica per Hotel e Ristoranti](https://www.ericsoft.com/it/fatturazione-elettronica-hotel-ristoranti)

### FatturaPA Standard
- [Fatturazione elettronica PA - FatturaPA](https://www.fatturapa.gov.it/it/norme-e-regole/documentazione-fattura-elettronica/formato-fatturapa/)
- [Specifiche tecniche FatturaPA v1.3.2 (PDF)](https://www.fatturapa.gov.it/export/documenti/Specifiche_tecniche_del_formato_FatturaPA_V1.3.2.pdf)
- [Schema XSD FatturaPA v1.2 - GitHub Italia](https://github.com/italia/fatturapa-testsdi/blob/master/core/schemas/Schema_del_file_xml_FatturaPA_versione_1.2_cleanup.xsd)

### Hotel & Fatturazione Elettronica
- [Fatturazione elettronica hotel: Guida essenziale nel 2025 - Chekin](https://chekin.com/it/blog/fatturazione-elettronica-hotel-guida/)
- [Fattura elettronica, codice N1 per il documento degli hotel - Il Sole 24 Ore](https://ntplusfisco.ilsole24ore.com/art/fattura-elettronica-codice-n1-il-documento-hotel-ABbi9ljB)
- [Fatturazione Elettronica per Hotel - invio SDI tramite PMS - Bedzzle](https://www.bedzzle.com/it/pms/fatturazione-elettronica-sdi-hotel)

### SPRING Gestionale
- [SPRING – Software gestionale per piccole aziende | Sistemi](https://www.sistemi.com/software-gestionali/spring/)
- [SPRING: gestionale Sistemi per piccole imprese](https://www.sistemiapg.it/soluzioni/gestionali-sistemi/spring/)

### Zucchetti Digital Hub
- [Digital HUB - Fatturazione](https://mydigitalhub.it/hub/jsp/funzionalita_fatturazione.jsp)
- [Fatturazione Elettronica - Digital Hub Zucchetti](https://mydh.it/hub/jsp/gsco_dh_funzionalita_fatturazione_portlet.jsp)
- [Posso salvare la fattura in formato XML? - Help Zucchetti](https://help.zucchetti.it/cms/kb/soluzioni/fatturazione-elettronica/tieni-il-conto/materiale-di-supporto/domande-frequenti/creazione-e-gestione-documenti/fattura-in-formato-xml.html)

### Best Practices PMS Italia
- [PMS Hotel: guida completa 2025 al Property Management System](https://roomraccoon.it/risorse/property-management-system-hotel-pms-guida/)
- [Guida ai software contabilità hotel](https://roomraccoon.it/blog/guida-ai-software-contabilita-hotel-cosa-sono-e-quale-scegliere/)

---

## Glossario

| Termine | Significato |
|---------|-------------|
| **PMS** | Property Management System - Software gestione hotel |
| **FatturaPA** | Formato XML standard italiano per fatturazione elettronica |
| **SDI** | Sistema di Interscambio - Piattaforma Agenzia Entrate per fatture elettroniche |
| **Digital Hub** | Servizio cloud Zucchetti per gestione fatture elettroniche |
| **P.IVA** | Partita IVA - Codice fiscale aziende (11 cifre) |
| **Natura** | Codice che identifica operazioni fuori campo IVA (es: N1 = escluso) |
| **TipoDocumento** | Codice tipo fattura (TD01=normale, TD04=nota credito, etc) |
| **Conservazione sostitutiva** | Archiviazione digitale legalmente valida (obbligo 10 anni) |
| **Imposta di soggiorno** | Tassa comunale che hotel rifattura a ospiti (fuori campo IVA, Natura N1) |

---

**Fine Ricerca**

*Cervella Researcher - 19 Gennaio 2026*
*"Studiare prima di agire - sempre!"*
