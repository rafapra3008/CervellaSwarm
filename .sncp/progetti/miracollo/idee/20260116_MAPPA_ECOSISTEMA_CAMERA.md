# MAPPA ECOSISTEMA CAMERA - Miracollo Hotel

> **Data:** 16 Gennaio 2026
> **Fonte:** Conversazione con Rafa + Foto NUCLEUS

---

## DISPOSITIVO CENTRALE

```
VDA ETHEOS - NUCLEUS I/O RCU
Modello: H155300 v1.4
MAC Ethernet: 00:08:0C:20:1F:6D
```

### Porte e I/O Disponibili

| Tipo | Identificativo | Uso Noto |
|------|----------------|----------|
| MODBUS | M1, M2, M3, M4 | 4 porte RS-485 |
| Seriale | RS232 TTL (pin 5) | Backup/config |
| Ethernet | RJ45 | Modbus TCP? |
| Digital Out | DO1-DO8 | Relè (da mappare) |
| Digital In | DI1-DI5 | Sensori (da mappare) |
| Analog In | AI1, AI2 | Sonde temperatura |
| Analog Out | AO1-AO3 | Controllo 0-10V |

### Mappatura Nota (da Rafa)

```
AI1 = SONDA BAGNO
AI2 = SONDA INGRESSO
```

---

## ECOSISTEMA CAMERA

### Fuori Porta - Pannello Codici
- Inserimento codice → apertura porta
- LED Verde = camera occupata
- LED Giallo = camera pulita
- LED Viola = MUR (richiesta pulizia)
- **Brand:** Da verificare (VDA o altro?)

### Dentro Camera - Pannello Temperatura
- Display temperatura attuale
- Impostazione temperatura desiderata
- Controlla SOLO termosifone camera
- Termosifone bagno = controllabile SOLO da room manager
- **Brand:** Da verificare (VDA?)

### Sensori
- **Presenza:** Attiva corrente camera quando entri
- **Finestre:** Ferma riscaldamento se aperte
- **Porte:** Stato aperta/chiusa

### Luci Camera
- Tutte controllate da pulsanti fisici
- NON smart (per ora)

### Riscaldamento
- Termosifone camera: controllabile da pannello nero
- Termosifone bagno: SOLO room manager VDA

---

## SISTEMA SEPARATO - Legrand/BTicino

- **Dove:** Spa e Bar
- **App:** Home + Control
- **Protocollo:** Zigbee/WiFi (Netatmo/Legrand)
- **NON collegato al NUCLEUS**

---

## OPPORTUNITÀ CON REVERSE ENGINEERING

| Oggi | Con Rosetta Stone |
|------|-------------------|
| Termo bagno solo da room manager | Controllabile da Miracollo |
| Temperature non visibili | Lettura real-time |
| Sensori non accessibili | Stato camera occupata/vuota |
| Nessun alert | Notifiche finestre aperte |

---

## DOMANDE APERTE

1. Pannello codici porta - è VDA?
2. Pannello nero temperatura - è VDA?
3. Room manager - software PC? Web? App?
4. DO1-DO8 collegati a cosa?
5. DI1-DI5 collegati a cosa?

---

## FOTO RIFERIMENTO

```
/Users/rafapra/Downloads/WhatsApp Image 2026-01-16 at 02.48.33 (2).jpeg - Etichetta NUCLEUS
/Users/rafapra/Downloads/WhatsApp Image 2026-01-16 at 02.48.33 (1).jpeg - Power supply
/Users/rafapra/Downloads/WhatsApp Image 2026-01-16 at 02.48.32.jpeg - Vista insieme + note
```

---

*"Non esistono cose difficili, esistono cose non studiate!"*
