# COSTITUZIONE - PMS Core

> **Il Cuore di Miracollo**
> Braccio 1 - Backend principale in produzione

---

## CHI SIAMO

PMS Core e il **braccio principale** dell'ecosistema Miracollo.
E il sistema gestionale dell'hotel: prenotazioni, ospiti, fatturazione.

```
+================================================================+
|                                                                |
|   PMS Core = Il CUORE che fa battere tutto                     |
|                                                                |
|   - Miracallook si CONNETTE a noi per dati ospiti              |
|   - Room Hardware si CONNETTE a noi per automazione            |
|   - Noi siamo la FONTE DI VERITA                               |
|                                                                |
+================================================================+
```

---

## REGOLE OPERATIVE

### 1. STABILITA PRIMA DI TUTTO

```
PMS Core e IN PRODUZIONE.
Hotel VERI usano questo sistema OGNI GIORNO.

REGOLA: Mai rompere cio che funziona.
- Test PRIMA di ogni deploy
- Rollback pronto
- Zero downtime
```

### 2. INTEGRITA DATI

```
I dati degli ospiti sono SACRI.
- Mai perdere prenotazioni
- Mai corrompere fatture
- Mai esporre dati sensibili

Se in dubbio: NON FARE.
```

### 3. SEMPLICITA

```
PMS Core deve essere SEMPLICE da usare.
- Receptionist non sono sviluppatori
- Ogni click deve avere senso
- Errori devono essere chiari
```

---

## STACK

| Layer | Tech | Porta | Stato |
|-------|------|-------|-------|
| Backend | FastAPI | 8000 | PRODUZIONE |
| Frontend | React | 80/443 | PRODUZIONE |
| Database | PostgreSQL | 5432 | 41 migrations |
| Server | GCP VM | - | LIVE |

---

## MODULI INTERNI

| Modulo | Descrizione | Stato |
|--------|-------------|-------|
| Prenotazioni | CRUD booking | LIVE |
| Anagrafica | Gestione ospiti | LIVE |
| Room Rack | Planning visuale | LIVE |
| Fatturazione | Conti e fatture | LIVE |
| Rate Board | Pricing intelligente | LIVE |
| Housekeeping | Stato camere | LIVE |
| Revenue | AI suggestions | LIVE |
| Meteo | Integrazione weather | LIVE |
| Eventi | Eventi locali | LIVE |

---

## COMUNICAZIONE CON ALTRI BRACCI

```
PMS Core <---> Miracallook
  - GET /guests/{email} - trova ospite da email
  - GET /bookings/current - prenotazioni attive
  - Miracallook LEGGE, non scrive

PMS Core <---> Room Hardware
  - POST /rooms/{id}/status - aggiorna stato camera
  - Room Hardware SCRIVE stato sensori
```

---

## QUANDO LAVORARE SU PMS CORE

```
OK:
- Bug fix critici
- Ottimizzazioni performance
- Nuovi moduli (se pianificati)
- Security patch

NON OK:
- Refactoring "perche si"
- Cambiare struttura DB senza piano
- Deploy senza test
- Modifiche a moduli funzionanti
```

---

## FILE RIFERIMENTO

| File | Cosa |
|------|------|
| `stato.md` | Stato attuale |
| `NORD_PMS-CORE.md` | Visione strategica |
| `PROMPT_RIPRESA_pms-core.md` | Ripresa sessione |

---

*"Il cuore deve battere. Sempre. Senza interruzioni."*
*Braccio 1 - PMS Core*
