# Sessione 264 - Test Epson RT FUNZIONANTE!

> **Data:** 18 Gennaio 2026
> **Status:** PROOF OF CONCEPT COMPLETATO!

---

## IL GRANDE RISULTATO

```
+================================================================+
|                                                                |
|   MIRACOLLO HA STAMPATO SU EPSON RT!                          |
|                                                                |
|   Prima stampa: 18-01-2026 15:51                              |
|   Tipo: DOCUMENTO GESTIONALE (non fiscale)                    |
|   Risultato: SUCCESSO!                                        |
|                                                                |
+================================================================+
```

---

## SCOPERTE TECNICHE

### 1. Rete - VLAN Routing Funziona!

```
Mac (192.168.201.25) ←→ Epson (192.168.200.240) = OK!

- Ping: 3/3 packets, ~5ms
- HTTP porta 80: APERTA
- VLAN diverse ma routing funziona
```

### 2. Endpoint Epson Trovato

```
URL: http://192.168.200.240/cgi-bin/fpmate.cgi
Parametri: ?devid=local_printer&timeout=10000
Content-Type: text/xml
```

### 3. Formato XML SOAP Corretto

```xml
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <printerNonFiscal>
      <beginNonFiscal />
      <printNormal data="Testo da stampare" />
      <endNonFiscal />
    </printerNonFiscal>
  </soap:Body>
</soap:Envelope>
```

### 4. Stato RT Stampante

```
URL: http://192.168.200.240/www/printer_status/get_rt_status.html

Stato RT Attuale:    IN SERVIZIO
Day Opened:          TRUE
Training Mode:       0 (REALE!)
Certificato:         Valido fino 01/06/2031
File da inviare:     0
```

---

## STAMPANTI TROVATE

| IP | Posizione | Cassa | Modello |
|----|-----------|-------|---------|
| 192.168.200.240 | BAR (Sesto Grado) | Cassa 2 | TM-T800F (M261A) |
| ??? | RECEPTION | Cassa 1? | TM-T800F (M261A) |

**TODO:** Trovare IP stampante Reception in UniFi

---

## FOTO PROVA

Scontrino stampato salvato in:
- WhatsApp Image 2026-01-18 at 15.53.29.jpeg

Contenuto stampato:
```
SESTO GRADO
Famiglia Pra S.r.l.
...
DOCUMENTO GESTIONALE
=== TEST MIRACOLLO ===
Stampante: TM-T800F
IP: 192.168.200.240
STAMPA NON FISCALE
===================
NUMERO CASSA    2
18-01-2026 15:51
DOCUMENTO N. 0374-0002
```

---

## PROSSIMI STEP

1. **Trovare IP Reception** - Cercare in UniFi "cassa1" o "reception"
2. **Aggiornare nostro codice** - Usare formato SOAP corretto
3. **Test su Reception** - Stampa non fiscale
4. **Training Mode** - Contattare Epson per abilitarlo

---

## FILE CREATI

| File | Scopo |
|------|-------|
| `~/Desktop/test_epson_nonfiscale.sh` | Script test stampa |
| `~/Desktop/scan_stampanti_epson.sh` | Script scan rete |
| `~/Desktop/verifica_epson.sh` | Script verifica Epson |
| `RICERCA_EPSON_RT_TRAININGMODE_20260118.md` | Ricerca completa |

---

*"Prima stampa Miracollo su Epson RT - Momento storico!"*
