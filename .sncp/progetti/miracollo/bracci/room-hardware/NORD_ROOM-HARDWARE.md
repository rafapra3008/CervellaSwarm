# NORD - Room Hardware

> **L'Hotel che Si Adatta all'Ospite**
> Braccio 3 - Automazione fisica intelligente

---

```
+====================================================================+
|                                                                    |
|   "La camera sa che stai arrivando.                                |
|    E ti accoglie."                                                 |
|                                                                    |
|   Check-in -> Clima si attiva automaticamente                      |
|   Check-out -> Risparmio energetico                                |
|   Nessun receptionist deve premere bottoni.                        |
|                                                                    |
+====================================================================+
```

---

## STATO: 10% - RICERCA COMPLETA

```
RICERCA VDA             [####################] 100%
  21 file, 950+ righe documentazione

HARDWARE                [####................] 20%
  Ordinato Amazon, in arrivo

REVERSE ENGINEERING     [....................] 0%
  Piano Rosetta Stone pronto

BACKEND                 [....................] 0%
  Skeleton da fare dopo Rosetta
```

---

## LA VISIONE

```
OGGI (senza Room Hardware):
- Ospite arriva -> camera fredda
- Receptionist deve ricordarsi di accendere clima
- Energia sprecata in camere vuote

DOMANI (con Room Hardware):
- Check-in confermato -> clima si attiva 30min prima
- Ospite arriva -> camera a 22 gradi
- Check-out -> risparmio automatico
- Zero intervento manuale
```

---

## IL PIANO ROSETTA STONE

```
VDA non documenta i registri Modbus.
Dobbiamo scoprirli da soli.

METODO:
1. Connessione al Nucleus via RS-485
2. Sniffing PASSIVO del bus Modbus
3. Cattura comandi esistenti (da pannello VDA)
4. Decodifica pattern (quali registri = quali azioni)
5. Creazione VDA_REGISTER_MAP.md
6. Test scrittura controllata
7. Backend con pymodbus

FILOSOFIA: "Non esistono cose difficili, esistono cose non studiate!"
```

---

## HARDWARE

### Target
| Device | Modello | Ruolo |
|--------|---------|-------|
| RCU | VDA ETHEOS NUCLEUS H155300 | Controller centrale |
| Termostati | VDA VE503 | Controllo clima |
| Sensori | AI1, AI2 | Temperatura bagno/ingresso |

### Ordinato (Amazon)
| Item | Uso | Arrivo |
|------|-----|--------|
| USB-RS485 FTDI | Converter per Mac | 1-2 giorni |
| Multimetro | Verifica tensioni | 1-2 giorni |

---

## INTEGRAZIONE ECOSISTEMA

```
        +-------------+
        |  PMS CORE   |
        |   :8000     |
        +------+------+
               |
               | Check-in/out events
               |
        +------v------+
        |ROOM         |
        |HARDWARE     |
        | :8003       |
        +------+------+
               |
               | Modbus RTU
               |
        +------v------+
        |VDA NUCLEUS  |
        |H155300      |
        +-------------+
               |
     +---------+---------+
     |         |         |
  +--v--+   +--v--+   +--v--+
  |VE503|   |VE503|   |VE503|
  |Rm101|   |Rm102|   |Rm103|
  +-----+   +-----+   +-----+
```

---

## PROSSIMI STEP

```
QUANDO ARRIVA HARDWARE:
1. [ ] Setup Mac (driver FTDI, minicom)
2. [ ] Prima connessione Ethernet (test ping)
3. [ ] Prima connessione RS-485 (sniffing)
4. [ ] Cattura 10+ comandi dal pannello VDA
5. [ ] Decodifica pattern
6. [ ] VDA_REGISTER_MAP.md
7. [ ] Backend skeleton (FastAPI + pymodbus)
8. [ ] Test scrittura singolo registro
9. [ ] Integrazione PMS Core
```

---

## FILE RIFERIMENTO

| File | Contenuto |
|------|-----------|
| `stato.md` | Stato breve |
| `COSTITUZIONE_room-hardware.md` | Regole operative |
| `PROMPT_RIPRESA_room_hardware.md` | Ripresa sessione |
| `studi/20260116_VDA_ROSETTA_STONE_PIANO.md` | Piano RE |
| `studi/20260114_RICERCA_VDA_HARDWARE.md` | Ricerca completa |
| `ROADMAP_ROOM_MANAGER_COMPLETA.md` | Roadmap dettagliata |

---

## OBIETTIVO FINALE

```
+====================================================================+
|                                                                    |
|   INDIPENDENZA TOTALE                                              |
|                                                                    |
|   Non dipendiamo da VDA per l'integrazione.                        |
|   Non paghiamo licenze software.                                   |
|   Non aspettiamo supporto tecnico.                                 |
|                                                                    |
|   IL NOSTRO MODO. I NOSTRI TERMINI.                                |
|                                                                    |
+====================================================================+
```

---

*"Non esistono cose difficili, esistono cose non studiate!"*
*Braccio 3 - Room Hardware*
