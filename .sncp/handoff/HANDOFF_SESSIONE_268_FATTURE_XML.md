# HANDOFF - Sessione 268: Fatture XML Miracollo

> **Data:** 19 Gennaio 2026
> **Durata:** ~1.5h
> **Focus:** FASE 3 Fatture XML - Guida Completa

---

## RIASSUNTO

```
+================================================================+
|                                                                |
|   FASE 3 FATTURE: DA 10% A 40%                                 |
|                                                                |
|   - Studiati 4 XML reali di Ericsoft                           |
|   - Estratti tutti i dati fiscali                              |
|   - Verificato da 3 Guardiane                                  |
|   - Guida completa salvata                                     |
|                                                                |
+================================================================+
```

---

## COSA ABBIAMO FATTO

### 1. Studio XML Reali

| File | Hotel | Contenuto |
|------|-------|-----------|
| ERICFE_BXMCM.xml | Lodge (NL) | Fattura 3/NL - B&B |
| ERICFE_BY0DV.xml | Lodge (NL) | Fattura 4/NL - Half Board |
| ERICFE_BXGVB.xml | SHE (E) | Fattura 1/E - Mezza Pensione |
| ERICFE_BXGWV.xml | SHE (E) | Altro esempio |

### 2. Dati Estratti

```
HOTEL:
- Denominazione: Famiglia Pra Srl
- P.IVA: 00658350251
- Indirizzo: Piazza Dogliani, 19 - 32022 Alleghe (BL)
- Regime: RF01 (ordinario)
- Codice Dest: USAL8PV

SPRING:
- Versione: 3.5.02A (server)
- IDS: 507866
- Codice Utente: 029808

ALIQUOTE:
- 10% pernottamento, colazione, bar, ristorante
- 22% minibar/extra
- 0% N1 tassa soggiorno (Escluse ex. art. 15)

NUMERAZIONE:
- Lodge: progressivo/NL (es: 3/NL, 4/NL)
- SHE: progressivo/E (es: 1/E)
- Test: partiamo da 200/NL
```

### 3. Consultate Guardiane

| Guardiana | Verdetto | Note |
|-----------|----------|------|
| Qualita | APPROVE 8/10 | Naming da allineare a standard |
| Ops | OK | Cartella `~/Desktop/fatture_xml_test/` |
| Data | OK | Schema DB pronto con locking |

### 4. File Creati

```
.sncp/progetti/miracollo/guide/GUIDA_FATTURE_XML_MIRACOLLO.md
~/Desktop/fatture_xml_test/
~/Desktop/fatture_xml_test/backup/
```

---

## STATO MODULO FINANZIARIO

```
FASE 1:  Ricevute PDF   [####################] 100% REALE!
FASE 1B: Checkout UI    [####################] 100% REALE!
FASE 2:  Scontrini RT   [##################..] 90% ADAPTER!
FASE 3:  Fatture XML    [########............] 40% GUIDA!
FASE 4:  Export         [....................] 0%

TOTALE: 75%
```

---

## PROSSIMI STEP

### FASE 3 Fatture (priorita)

```
1. [ ] Generare 1 XML test (fattura 200/NL)
2. [ ] Validare con tool online (fatturapa.gov.it)
3. [ ] Test import in SPRING (con contabilista)
4. [ ] Se OK: implementare in Miracollo
```

### FASE 2 Scontrini (quando in hotel)

```
1. [ ] Test adapter su stampante Bar
2. [ ] Trovare IP Reception
```

---

## FLUSSO FATTURE (Referenza)

```
Miracollo --> XML FatturaPA --> Cartella --> SPRING --> SDI

- Miracollo genera solo XML (python-a38)
- SPRING gestisce firma/invio/conservazione
- 10-15 fatture/mese = gestibile manualmente
```

---

## FILE AGGIORNATI

| File | Modifica |
|------|----------|
| NORD.md | FASE 3 al 40%, puntatore guida |
| oggi.md | Focus fatture + miracollook |
| PROMPT_RIPRESA_miracollo.md | Sessione 268 fatture |
| GUIDA_FATTURE_XML_MIRACOLLO.md | NUOVO |

---

## NOTE PER PROSSIMA SESSIONE

1. **Per generare XML test:** Usare python-a38, dati hotel gia estratti
2. **Per validare:** https://www.fatturapa.gov.it (validatore online)
3. **Per SPRING:** Chiedere a contabilista il path cartella input
4. **Numerazione:** Partire da 200/NL per test (non interferire con produzione)

---

*"Non reinventiamo la ruota - usiamo lo standard FatturaPA!"*
*Sessione 268 - 19 Gennaio 2026*
