# GUIDA FATTURE XML - Miracollo PMS

> **Creato:** 19 Gennaio 2026 - Sessione 268
> **Aggiornato:** 19 Gennaio 2026 - Sessione 271
> **Verificato da:** Guardiana Qualita, Guardiana Ops, Cervella Data
> **Status:** TEST SPRING SUPERATO!

---

## QUADRO GENERALE

```
+================================================================+
|                                                                |
|   FLUSSO FATTURAZIONE:                                         |
|                                                                |
|   Miracollo --> XML FatturaPA --> Cartella --> SPRING --> SDI  |
|                                                                |
|   Miracollo fa SOLO generazione XML                            |
|   SPRING gestisce: firma, invio SDI, conservazione             |
|                                                                |
+================================================================+
```

---

## DATI FISCALI HOTEL (Estratti da XML reali)

```
Denominazione:    Famiglia Pra Srl
P.IVA:            00658350251
Indirizzo:        Piazza Dogliani, 19
CAP:              32022
Comune:           Alleghe
Provincia:        BL
Nazione:          IT
Regime Fiscale:   RF01 (ordinario)
Codice Dest:      USAL8PV (per ricevere fatture)
```

---

## SPRING

```
Versione:      3.5.02A (server locale, non cloud)
Licenza:       FAMIGLIA PRA S.R.L.
IDS:           507866
Codice Utente: 029808
```

---

## ALIQUOTE IVA

| Voce | Aliquota | Natura | Riferimento Normativo |
|------|----------|--------|----------------------|
| Pernottamento | 10% | - | 10% |
| Colazione inclusa | 10% | - | 10% |
| Bar | 10% | - | 10% |
| Ristorante | 10% | - | 10% |
| Minibar/Extra | 22% | - | 22% |
| **Tassa Soggiorno** | **0%** | **N1** | Escluse ex. art. 15 |

**IMPORTANTE:** Tassa soggiorno = N1 (NON N2!)

---

## CODICI PAGAMENTO

| Codice | Significato |
|--------|-------------|
| MP01 | Contanti |
| MP05 | Bonifico |
| MP08 | POS/Carta di credito |
| TP02 | Pagamento completo |

---

## NUMERAZIONE FATTURE

### Sistema Attuale (Ericsoft)
```
Lodge: 3/NL, 4/NL, 5/NL...  (progressivo + sezionale NL)
SHE:   1/E, 2/E, 3/E...     (progressivo + sezionale E)
```

### Sistema Miracollo (Test)
```
Sezionale:     NL
Partenza test: 200/NL
Formato:       {progressivo}/{sezionale}
Reset annuale: NO (continuare progressivo)
```

### Regole
- Ogni sezionale ha numerazione indipendente
- NON obbligatorio azzerare a inizio anno
- Errori numerazione = NON sanzionabili (ma evitare duplicati!)

---

## NAMING FILE XML

### Standard FatturaPA (raccomandato)
```
IT{PIVA}_{PROGRESSIVO}.xml
Esempio: IT00658350251_00200.xml
```

### Alternativa Miracollo (per test)
```
MIRAF_{YYYYMMDD}_{HHMMSS}_{numero}.xml
Esempio: MIRAF_20260119_143022_200.xml
```

---

## CARTELLE TEST

```
OUTPUT XML:    ~/Desktop/fatture_xml_test/
BACKUP:        ~/Desktop/fatture_xml_test/backup/
```

Workflow:
1. Miracollo genera XML in `fatture_xml_test/`
2. Validare con tool online (fatturapa.gov.it)
3. Copiare manualmente in SPRING
4. Se import OK -> spostare in `backup/`
5. Se KO -> analizzare errore, correggere

---

## STRUTTURA XML (Template)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<p:FatturaElettronica
  xmlns:p="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2"
  versione="FPR12">

  <FatturaElettronicaHeader>
    <DatiTrasmissione>
      <IdTrasmittente>
        <IdPaese>IT</IdPaese>
        <IdCodice>00658350251</IdCodice>
      </IdTrasmittente>
      <ProgressivoInvio>1</ProgressivoInvio>
      <FormatoTrasmissione>FPR12</FormatoTrasmissione>
      <CodiceDestinatario>{CODICE_CLIENTE}</CodiceDestinatario>
    </DatiTrasmissione>

    <CedentePrestatore>
      <DatiAnagrafici>
        <IdFiscaleIVA>
          <IdPaese>IT</IdPaese>
          <IdCodice>00658350251</IdCodice>
        </IdFiscaleIVA>
        <Anagrafica>
          <Denominazione>Famiglia Pra Srl</Denominazione>
        </Anagrafica>
        <RegimeFiscale>RF01</RegimeFiscale>
      </DatiAnagrafici>
      <Sede>
        <Indirizzo>Piazza Dogliani, 19</Indirizzo>
        <CAP>32022</CAP>
        <Comune>Alleghe</Comune>
        <Provincia>BL</Provincia>
        <Nazione>IT</Nazione>
      </Sede>
    </CedentePrestatore>

    <CessionarioCommittente>
      <!-- Dati cliente da inserire -->
    </CessionarioCommittente>
  </FatturaElettronicaHeader>

  <FatturaElettronicaBody>
    <DatiGenerali>
      <DatiGeneraliDocumento>
        <TipoDocumento>TD01</TipoDocumento>
        <Divisa>EUR</Divisa>
        <Data>{DATA_FATTURA}</Data>
        <Numero>{NUMERO}/NL</Numero>
        <ImportoTotaleDocumento>{TOTALE}</ImportoTotaleDocumento>
      </DatiGeneraliDocumento>
    </DatiGenerali>

    <DatiBeniServizi>
      <!-- Righe dettaglio -->
      <DatiRiepilogo>
        <!-- Riepilogo per aliquota -->
      </DatiRiepilogo>
    </DatiBeniServizi>

    <DatiPagamento>
      <CondizioniPagamento>TP02</CondizioniPagamento>
      <DettaglioPagamento>
        <ModalitaPagamento>{MP01|MP05|MP08}</ModalitaPagamento>
        <ImportoPagamento>{IMPORTO}</ImportoPagamento>
      </DettaglioPagamento>
    </DatiPagamento>
  </FatturaElettronicaBody>
</p:FatturaElettronica>
```

---

## TEST COMPLETATI - Sessione 271

```
+================================================================+
|                                                                |
|   TEST SPRING: SUPERATO!                                       |
|   Data: 19 Gennaio 2026                                        |
|                                                                |
+================================================================+
```

### File Generati
```
~/Desktop/fatture_xml_test/
├── IT00658350251_00200.xml   ← Fattura semplice (solo 10%)
├── IT00658350251_00201.xml   ← Fattura COMPLETA (10%+22%+N1)
├── IT00658350251_00201.PDF   ← Output SPRING (conferma OK)
├── Schema_FatturaPA_v1.2.xsd ← Schema ufficiale AdE
└── backup/
```

### Fattura 201/NL - Test Realistico

| Voce | Importo | IVA | Totale |
|------|---------|-----|--------|
| Soggiorno 2 notti | 200.00 | 10% (20.00) | 220.00 |
| Colazione | 20.00 | 10% (2.00) | 22.00 |
| Minibar | 15.00 | 22% (3.30) | 18.30 |
| Tassa soggiorno | 6.00 | N1 (0.00) | 6.00 |
| **TOTALE** | | | **266.30** |

### Validazioni Superate
1. xmllint (well-formed XML) - OK
2. Schema FatturaPA v1.2 - VALIDATES
3. Import SPRING - OK (PDF generato)

---

## PROSSIMI STEP

| # | Task | Chi | Status |
|---|------|-----|--------|
| 1 | Creare cartella test | Cervella | FATTO |
| 2 | Generare XML test (200/NL, 201/NL) | Cervella | FATTO |
| 3 | Validare schema FatturaPA | Cervella | FATTO |
| 4 | Test import in SPRING | Rafa | FATTO |
| 5 | Implementare generatore XML in Miracollo | Cervella | PARCHEGGIATO |
| 6 | UI fatturazione nel checkout | Cervella | PARCHEGGIATO |

---

## DIPENDENZE (per implementazione futura)

```
DA CHIEDERE A CONTABILISTA (quando si implementa):
- [ ] Path cartella input SPRING (dove copia i file)
- [ ] Ultimo numero fattura NL in produzione (evitare duplicati)
- [ ] Conferma workflow: Miracollo genera -> copia manuale -> SPRING invia
```

---

## NOTE TECNICHE

### Libreria Python
```
python-a38 (pip install a38)
- Genera XML FatturaPA validato
- CLI tool per conversione/validazione
```

### Schema DB (creato da cervella-data)
```
File: docs/schemas/043_fiscal_invoices.sql
- Numerazione con optimistic locking
- Indici per performance
- Supporto concorrenza
```

---

*"Non reinventiamo la ruota - usiamo lo standard FatturaPA!"*
*Sessione 268 - 19 Gennaio 2026*
