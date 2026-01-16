# PROMPT RIPRESA - Miracollo

> **Ultimo aggiornamento:** 16 Gennaio 2026 - Sessione 230
> **STATO: VDA Rosetta Stone pianificata, hardware in arrivo**

---

## STATO IN UNA RIGA

**VDA: Hardware Amazon ordinato. Piano reverse engineering pronto. Aspettiamo pacco per iniziare sniffing Modbus.**

---

## SESSIONE 230: VDA ROSETTA STONE

### DECISIONE RAFA
- **NO contatto VDA** - facciamo il nostro modo
- Reverse engineering completo
- Indipendenza totale

### HARDWARE ORDINATO (Amazon Prime)
- USB-RS485 FTDI (DSD TECH) - €19
- Multimetro Electraline - €12
- Cacciaviti precisione - €10
- Cavetti jumper - €8

### DISPOSITIVI DA MAPPARE
```
NUCLEUS H155300 (cervello camera):
- 4 porte Modbus (M1-M4)
- AI1 = sonda bagno, AI2 = sonda ingresso
- DO1-DO8 = rele, DI1-DI5 = sensori
- Ethernet RJ45 (Modbus TCP?)

ALTRI DEVICE (da Room Manager VDA):
- 6T KEYPAD (NE000056) - pannello codici porta
- LT BLE 2.1 (VE503E00) - termostato camera?
- CON4 2.1 (VE503T00) - termostato bagno?
```

### RICERCA FATTA
- Cercato documentazione pubblica: NON ESISTE
- Cercato reverse engineering esistente: NESSUNO
- VDA produce internamente (Pordenone)
- Saremo i PRIMI a documentare!

### PROSSIMI STEP (quando arriva hardware)
1. Setup Mac (driver FTDI)
2. Test connessione (Ethernet o RS-485)
3. Sniffing passivo
4. Mappatura registri
5. Rosetta Stone!

### FILE CREATO
`.sncp/progetti/miracollo/idee/20260116_VDA_ROSETTA_STONE_PIANO.md`

---

## MIRACALLOOK (da Sessione 229)

---

## SESSIONE 229: BUG FIX

### FIXATI
1. **Email HTML rendering** - Backend ora preferisce text/html, plain text con \n-><br>
   - File: `gmail/api.py` linee 716-736 e 793-813
2. **Resize pannelli** - CSS flexbox con `resize: horizontal` (temporaneo ma funziona)
   - File: `ThreePanel.tsx` - layout semplice con width px
3. **Bulk Actions 422** - Aggiunto `embed=True` a tutti gli endpoint Body()
   - File: `gmail/api.py` - archive, trash, untrash, mark-read, mark-unread

### DA FARE (PROSSIMA SESSIONE)

**PRIORITA ALTA:**
1. **Checkbox nei gruppi** - Email aggregate non mostrano checkbox individuali
2. **Barra bulk opaca** - Si sovrappone al contenuto, serve background blur/opaco

**PRIORITA MEDIA:**
3. **Sistema cartelle** - Archive funziona ma dove vanno le email? UI per cartelle
4. **Drag handles custom** - Sostituire CSS resize con drag professionale

**FUTURO:**
5. Sanitizzazione HTML (XSS protection)

---

## FILE MODIFICATI (Sessione 229)

```
miracallook/backend/gmail/api.py    <- HTML preference + embed=True
miracallook/frontend/src/components/Layout/ThreePanel.tsx <- CSS resize
```

---

## MAPPA PORTE

| Progetto | Backend | Frontend |
|----------|---------|----------|
| Miracollo PMS | 8001 | 80/443 |
| Miracallook | 8002 | 5173/5174 |

---

## NOTE TECNICHE

**react-resizable-panels v4.4.1:**
- Bug fix v4.3.1 NON ha risolto il problema per noi
- La libreria calcola male le dimensioni dal DOM
- Usato CSS resize come workaround

**FastAPI Body():**
- Singolo parametro Body() senza embed=True si aspetta valore diretto
- Con embed=True si aspetta {"param": value}
- Frontend manda sempre oggetto JSON

---

*"3 bug fixati, app funziona! UX polish nella prossima sessione."*
