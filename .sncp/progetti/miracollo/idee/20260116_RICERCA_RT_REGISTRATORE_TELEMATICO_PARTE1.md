# RICERCA RT - Registratore Telematico per Hotel (PARTE 1/3)

**Data**: 16 Gennaio 2026
**Ricercatrice**: Cervella Researcher
**Progetto**: Miracollo PMS
**Obiettivo**: Studio approfondito su integrazione Registratore Telematico in PMS hotel

---

## EXECUTIVE SUMMARY

### TL;DR
- **RT obbligatorio** dal 1 Gennaio 2020 per corrispettivi hotel
- **NOVITÀ 2026**: Obbligo collegamento RT-POS entro 45 giorni (Legge Bilancio 2025)
- **Alternative**: RT fisico (~700€) vs Server RT (abbonamento ~40€/mese) vs API Cloud
- **Integrazione PMS**: Protocolli HTTP/XML, no librerie Python standard
- **Raccomandazione**: Server RT o API Cloud per flessibilità e costi gestione

---

## 1. NORMATIVA E OBBLIGHI

### 1.1 Obbligo Corrispettivi Telematici

**Cosa Sono i Corrispettivi Telematici**

I corrispettivi telematici sono le ricevute fiscali elettroniche che certificano operazioni B2C (Business to Consumer) rese a consumatori finali senza partita IVA. Dal 1° gennaio 2020, hotel e strutture ricettive devono:

- Memorizzare elettronicamente gli incassi giornalieri
- Trasmettere i dati all'Agenzia delle Entrate entro 12 giorni
- Utilizzare un Registratore Telematico (RT) certificato

**Quando Emettere Scontrino vs Fattura**

| Tipo Cliente | Documento | Obbligo |
|--------------|-----------|---------|
| **Cliente finale B2C** | Scontrino elettronico | ✅ Obbligatorio (tramite RT) |
| **Agenzia/Tour Operator B2B** | Fattura elettronica | ✅ Obbligatorio |
| **Cliente che richiede fattura** | Fattura elettronica | ✅ Su richiesta |
| **Booking.com/OTA (fattura a struttura)** | Scontrino elettronico | ✅ Per ospite finale |

**Chiave**: Se i servizi hotel sono acquistati e pagati direttamente dal cliente finale, serve scontrino elettronico. Se acquistati da agenzia in nome proprio per rivenderli, serve fattura all'agenzia.

### 1.2 NOVITÀ 2026 - Collegamento Obbligatorio RT-POS

**Legge di Bilancio 2025** introduce obbligo di collegamento tra POS e RT:

**Timeline Implementazione**:
- **1 Gennaio 2026**: Entra in vigore l'obbligo
- **Marzo 2026** (stimato): Agenzia Entrate rende disponibile portale web per abbinamento
- **45 giorni** da disponibilità portale: Scadenza per abbinare POS esistenti
- **POS nuovi**: Abbinamento entro ultimo giorno 2° mese successivo ad attivazione

**Procedura**:
1. Accedere al portale Agenzia Entrate (quando disponibile)
2. Registrare abbinamento POS-RT online
3. Configurare comunicazione automatica importi

**Obiettivo**: Tracciabilità pagamenti elettronici e contrasto evasione fiscale. Il sistema verifica coerenza tra importi incassati via POS e corrispettivi trasmessi dal RT.

**Sanzioni**:
- Mancato collegamento POS-RT: da €1.000 a €4.000
- Stessa sanzione prevista per omessa installazione RT

### 1.3 Chiusura Giornaliera e Trasmissione

**Operazione di Chiusura Giornaliera**

La creazione del file dei corrispettivi giornalieri è eseguita tramite **chiusura giornaliera del RT**, con la quale è creato un file con sigillo elettronico che viene trasmesso automaticamente all'Agenzia delle Entrate.

**Tempistiche**:
- Chiusura giornaliera: Possibile fino a mezzanotte
- Trasmissione all'AdE: Entro **12 giorni** dall'emissione
- Invio automatico: Il RT provvede autonomamente

**CASO SPECIALE: Hotel con Chiusura Oltre Mezzanotte**

L'Agenzia delle Entrate ha chiarito che per attività con orario oltre mezzanotte (hotel, ristoranti):

> "È opportuno provvedere ad una **prima chiusura di cassa entro la mezzanotte**, in modo che il sistema attribuisca ai corrispettivi la data della giornata e non la data del giorno successivo."

**Workflow Suggerito per Hotel**:
```
21:00 - Check-in ospite → Scontrino "ospite arrivato oggi"
23:55 - Prima chiusura giornaliera → Corrispettivi attribuiti a oggi
00:30 - Check-in notturno → Nuovo scontrino "ospite arrivato domani"
```

**Periodi di Chiusura**

Se interruzione attività > 12 giorni (ferie, chiusura stagionale):
- Inviare evento "fuori servizio" codice 608
- Evitare segnalazioni anomalie da Agenzia Entrate

### 1.4 Formato Dati e Specifiche Tecniche

**XML Versione 7.0** (obbligatorio dal 1° Gennaio 2022)

L'Agenzia delle Entrate ha definito lo standard XML 7.0 per trasmissione corrispettivi:

- **Formato**: XML strutturato con sigillo elettronico
- **Versione attuale**: Specifiche Tecniche RT V11.1 (24 Gennaio 2024)
- **Tracciato**: CorrispettiviTypes v7.1 (Gennaio 2023)
- **Protocollo API**: REST per comunicazione dispositivi-AdE

**Documenti Ufficiali Disponibili**:
- Specifiche Tecniche RT V11.1
- CorrispettiviTypes schema files
- API REST specifiche per dispositivi
- Code Lists e definizioni tipi dati

⚠️ **IMPORTANTE**: RT non aggiornati a XML 7.0 non possono più comunicare con Agenzia Entrate dal 1° Gennaio 2022.

**Contenuto File XML**:
```xml
<!-- Esempio struttura semplificata -->
<Corrispettivi>
  <Data>2026-01-16</Data>
  <Operazioni>
    <TotaleIncassi>1500.00</TotaleIncassi>
    <IVA>220.00</IVA>
    <Contante>800.00</Contante>
    <Elettronico>700.00</Elettronico>
    <NumeroDocumenti>15</NumeroDocumenti>
  </Operazioni>
  <SigilloElettronico>ABC123...</SigilloElettronico>
</Corrispettivi>
```

---

## 2. HARDWARE - REGISTRATORI TELEMATICI

### 2.1 Marche Principali

**Mercato RT in Italia**:

| Marca | Modelli Popolari | Settore Ideale |
|-------|------------------|----------------|
| **Epson** | FP-81II RT, FP-90III RT, RT-90 SERVER | Hotel, Ristoranti, Retail |
| **Custom** | KUBE III RT, Q3X RT | Bar, Piccoli esercizi |
| **Olivetti** | ECR 7700 RT | Retail, GDO |
| **Ditron** | I-Deal RT | Franchising |
| **RCH** | Vari modelli RT | Ristoranti |

**Focus Hotel: Epson**

Epson è leader nel settore hospitality per:
- Affidabilità comprovata
- Compatibilità protocolli standard
- Supporto documentazione tecnica
- Integrazioni PMS diffuse

### 2.2 Modelli Consigliati per Hotel

**Epson FP-81II RT** ⭐ RACCOMANDATO SINGOLO HOTEL

**Caratteristiche**:
- Stampante termica 58mm
- Display LCD per operatore
- Tastiera 23 tasti (versioni con tastiera)
- Connettività: Seriale RS232, USB, Ethernet
- Protocolli: HTTP/XML, OPOS, POS for.NET, JavaPOS, ActiveX, Linux
- Funzioni intelligenti: SMTP client, Web Server, Web Service
- Certificazione RT: Conforme specifiche AdE

**Ideale per**:
- Hotel indipendenti (1-50 camere)
- B&B, Affittacamere
- Agriturismi
- Strutture con reception singola

**Costo Indicativo**:
- Acquisto: €700-800 circa
- Canone annuale: ~€150/anno (assistenza + verifiche biennali)

---

**Epson FP-90III RT** - HOTEL MEDIE DIMENSIONI

**Caratteristiche**:
- Stampante termica 80mm (scontrini più larghi)
- Display touch screen (alcuni modelli)
- Maggiore velocità stampa
- Più memoria per giornale elettronico
- Stessi protocolli FP-81II RT

**Ideale per**:
- Hotel 50-200 camere
- Catene piccole (2-5 hotel)
- Strutture con ristorante interno
- Reception con alto volume transazioni

**Costo Indicativo**:
- Acquisto: €900-1.200 circa
- Canone annuale: ~€150-200/anno

---

**Epson RT-90 SERVER** ⭐ RACCOMANDATO CATENE HOTEL

**Caratteristiche**:
- **Server RT centralizzato** (non fisico in ogni punto vendita)
- Raccoglie dati da min. 3 postazioni cassa
- Sigilla e trasmette centralmente ad AdE
- Richiede software PMS con integrazione server
- Riduce costi manutenzione drasticamente

**Ideale per**:
- Catene hotel (3+ strutture)
- Franchising
- Gruppi alberghieri
- Hotel con più punti cassa (reception + ristorante + bar)

**Vantaggi**:
- Un solo RT da certificare/manutenere
- Aggiornamenti centralizzati
- Costi manutenzione ridotti (-70% vs RT multipli)
- Verifiche biennali solo sul server

**Costo Indicativo**:
- Setup iniziale: €2.000-3.000
- Canone annuale: €200-300/anno
- **ROI**: Da 3+ punti cassa in su

### 2.3 RT Fisico vs Server RT vs Cloud API

**Confronto Tre Approcci**:

| Aspetto | RT Fisico | Server RT | API Cloud |
|---------|-----------|-----------|-----------|
| **Costo iniziale** | €700-1.200 | €2.000-3.000 | €0 (solo abbonamento) |
| **Canone mensile** | €12-15/mese | €200-300/anno totale | €20-60/mese per punto |
| **Manutenzione HW** | Ogni 2 anni | Ogni 2 anni (1 solo) | Nessuna |
| **Aggiornamenti** | Manuale su ogni RT | Centralizzato | Automatici |
| **Scalabilità** | 1 RT = 1 cassa | 1 Server = N casse | Illimitata |
| **Flessibilità** | Bassa | Media | Alta |
| **Dipendenza internet** | Bassa* | Media | Alta |
| **Ideale per** | 1 hotel singolo | Catene 3+ hotel | Startup, multi-sede |

*RT fisico memorizza localmente e trasmette entro 12 giorni, quindi tollera interruzioni internet brevi.

**API Cloud - Soluzione Emergente**

Dal 2026, non è più obbligatorio avere un RT fisico. Software certificati possono trasmettere corrispettivi direttamente all'AdE senza dispositivo fisico.

**Vantaggi API Cloud**:
- Zero hardware da acquistare/manutenere
- Aggiornamenti automatici sempre conformi
- Nessun firmware da aggiornare
- Nessun sigillo fiscale fisico
- Scaling immediato (nuovo hotel = nuovo abbonamento)
- Costi predicibili (abbonamento mensile)

**Provider Disponibili 2026**:
- Fiskaly (tedesco, espansione Italia)
- Effatta (italiano, API Scontrino Elettronico)
- TeamSystem (soluzioni cloud integrate)

**Costi Tipici API Cloud**:
- Piano base: €20-40/mese per punto cassa
- Piano business: €40-80/mese (maggiori funzioni)
- Setup: Gratis o €100-300 una tantum

---

## 3. PROTOCOLLI COMUNICAZIONE E INTEGRAZIONE

### 3.1 Protocolli Standard RT

**Comunicazione RT → Agenzia Entrate**

Protocollo ufficiale definito in "Allegato - API Rest Dispositivi":

- **Protocollo**: REST API
- **Formato**: XML 7.0/7.1 sigillato elettronicamente
- **Autenticazione**: Certificato digitale RT
- **Risposta**: Esito controllo immediato (OK/KO)
- **Retry**: Automatico su errori temporanei

**Il RT gestisce AUTONOMAMENTE questa comunicazione**. Il PMS non deve preoccuparsene.

### 3.2 Protocolli PMS → RT (IL PROBLEMA)

**SITUAZIONE REALE**:

> "Sui protocolli di comunicazione, tendenzialmente è un **disastro** - non esistono standard universali tra i diversi produttori."

Ogni produttore RT implementa il proprio protocollo proprietario.

**Protocolli Disponibili per Integrazione**:

| Protocollo | Tipo | Supporto | Note |
|------------|------|----------|------|
| **HTTP/XML** | Standard aperto | Epson, alcuni altri | Più flessibile |
| **OPOS** | Standard retail | Epson, Custom | Java, .NET, non Python |
| **POS for.NET** | Microsoft | Epson | Solo Windows/.NET |
| **JavaPOS** | Java | Epson | Librerie Java |
| **Seriale proprietario** | Custom | Vari | Documentazione limitata |
| **TCP Socket** | Basso livello | Alcuni | Documentazione produttore |
| **WebSocket** | Moderno | Pochi | Dipende da modello |

**Epson FP-81II/90III RT**:
- **HTTP/XML**: ✅ RACCOMANDATO per Python
- **Web Service SOAP**: ✅ Disponibile
- **ActiveX**: ❌ Solo Windows legacy
- **OPOS**: ✅ Ma richiede wrapper Python

### 3.3 Librerie Python - SITUAZIONE ATTUALE

**Ricerca Effettuata**: Non esistono librerie Python ufficiali o mainstream per integrazione RT.

**Opzioni Disponibili**:

1. **HTTP/XML Diretto** ⭐ RACCOMANDATO
   ```python
   import requests

   # Esempio invio documento a RT Epson via HTTP
   rt_endpoint = "http://192.168.1.100/cgi-bin/fpmate.cgi"
   xml_documento = """
   <Document>
     <Item>Camera Singola</Item>
     <Amount>85.00</Amount>
     <VAT>10</VAT>
   </Document>
   """
   response = requests.post(rt_endpoint, data=xml_documento)
   ```

2. **Web Service SOAP** (Epson)
   ```python
   from zeep import Client

   wsdl = "http://192.168.1.100/RT.wsdl"
   client = Client(wsdl)
   result = client.service.PrintReceipt(
       description="Camera Doppia",
       amount=120.00,
       vat_rate=10
   )
   ```

3. **Wrapper OPOS** (richiede pywin32 su Windows)
   - Complesso, dipendenze native
   - Non portabile Linux
   - ❌ Sconsigliato per nuovi progetti

4. **API Cloud Provider** ⭐ ALTERNATIVA MODERNA
   ```python
   import effatta  # esempio

   client = effatta.Client(api_key="...")
   receipt = client.create_receipt(
       items=[{"desc": "Camera Deluxe", "amount": 150.00}],
       payment_methods=[{"type": "card", "amount": 150.00}]
   )
   ```

**RACCOMANDAZIONE TECNICA**:

Per nuovo sviluppo PMS in Python:

1. **Soluzione Immediata (Hotel singolo)**: HTTP/XML con Epson FP-81II RT
   - Costo hardware: ~€700
   - Sviluppo integrazione: ~4-8 ore
   - Massimo controllo, funziona offline

2. **Soluzione Scalabile (Catene)**: API Cloud (Effatta, Fiskaly)
   - Zero hardware
   - Integrazione: ~2-4 ore (SDK Python)
   - Richiede internet stabile

3. **Soluzione Enterprise**: Server RT Epson RT-90 + HTTP/XML
   - Setup complesso iniziale
   - Minima manutenzione ongoing
   - Ideale da 3+ strutture

---

*Continua in PARTE 2: Workflow PMS, Gestione Errori, Casi Pratici*
