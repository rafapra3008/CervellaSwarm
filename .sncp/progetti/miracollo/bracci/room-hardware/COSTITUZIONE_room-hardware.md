# COSTITUZIONE - Room Hardware

> **L'Automazione Intelligente delle Stanze**
> Braccio 3 - IoT e controllo hardware

---

## CHI SIAMO

Room Hardware e il braccio che porta l'**automazione fisica** nell'ecosistema Miracollo.
Controlliamo termostati, sensori, e (futuro) serrature.

```
+================================================================+
|                                                                |
|   Room Hardware = Il CORPO che esegue                          |
|                                                                |
|   - PMS Core ci dice QUANDO (check-in/out)                     |
|   - Noi FACCIAMO (accendi clima, leggi temperatura)            |
|   - Il risultato: comfort ospite + risparmio energia           |
|                                                                |
+================================================================+
```

---

## REGOLE OPERATIVE

### 1. SICUREZZA HARDWARE

```
Lavoriamo con ELETTRICITA e dispositivi FISICI.

REGOLA: Mai improvvisare.
- Studiare PRIMA di toccare
- Sniffing PASSIVO prima di scrivere
- Mai tensioni sconosciute
- Documentare OGNI registro scoperto
```

### 2. REVERSE ENGINEERING ETICO

```
VDA non fornisce documentazione completa.
Dobbiamo scoprire i registri Modbus da soli.

METODO:
1. Sniffing passivo (solo ascolto)
2. Decodifica pattern
3. Test su singolo dispositivo
4. Documentazione completa
5. SOLO POI implementazione
```

### 3. FILOSOFIA

```
"Non esistono cose difficili, esistono cose non studiate!"

- 21 file di ricerca completati
- 950+ righe documentazione VDA
- Piano Rosetta Stone pronto

NON abbiamo fretta. Studiamo BENE.
```

---

## HARDWARE TARGET

| Device | Modello | Protocollo |
|--------|---------|------------|
| RCU | VDA ETHEOS NUCLEUS H155300 | Modbus RTU/TCP |
| Termostati | VDA VE503 | Via RCU |
| Sensori | AI1 (bagno), AI2 (ingresso) | Analog 0-10V |

---

## STACK PIANIFICATO

| Layer | Tech | Porta |
|-------|------|-------|
| Backend | FastAPI + pymodbus | 8003 |
| Protocollo | Modbus RTU (RS-485) | - |
| Hardware | USB-RS485 FTDI | - |

---

## COMUNICAZIONE CON PMS CORE

```
PMS Core --> Room Hardware:
  - POST /rooms/{id}/checkin  -> Attiva clima
  - POST /rooms/{id}/checkout -> Modalita risparmio
  - GET /rooms/{id}/status    -> Temperatura attuale

Room Hardware e SLAVE di PMS Core.
Esegue comandi, riporta stato.
```

---

## QUANDO LAVORARE SU ROOM HARDWARE

```
FASE ATTUALE: Attesa hardware

PROSSIMO:
1. Arriva hardware Amazon
2. Setup Mac (driver FTDI)
3. Prima connessione
4. Rosetta Stone (mappatura registri)
5. Backend skeleton

NON FARE:
- Codice senza hardware
- Scrittura registri senza sniffing
- Deploy senza test fisico
```

---

## FILE RIFERIMENTO

| File | Cosa |
|------|------|
| `stato.md` | Stato attuale |
| `NORD_ROOM-HARDWARE.md` | Visione strategica |
| `PROMPT_RIPRESA_room_hardware.md` | Ripresa sessione |
| `studi/20260116_VDA_ROSETTA_STONE_PIANO.md` | Piano reverse engineering |

---

*"Il nostro modo. Indipendenza totale."*
*Braccio 3 - Room Hardware*
