# MAPPA DISSEZIONATA - PMS CORE

> **Data:** 16 Gennaio 2026 - Sessione 233
> **Metodo:** 3 Audit paralleli (cervella-ingegnera x3)
> **Copertura:** 15+ moduli, 130k+ righe codice

---

## EXECUTIVE SUMMARY

```
PMS CORE: 85% OPERATIVO
├── Parte operativa: SOLIDA, in produzione
├── Rateboard AI: ENTERPRISE-LEVEL
└── Modulo Finanziario: GAP CRITICO (10%)
```

---

## MODULI CORE

| Modulo | % | Status | Dettagli |
|--------|---|--------|----------|
| **BOOKINGS** | 95% | MATURO | CRUD completo, conflicts, versioning |
| **PLANNING** | 98% | MATURO | Drag&drop, swap, blocks (file grandi!) |
| **GUESTS** | 90% | FRAMMENTATO | Funziona, sparso in 4 file |
| **ROOMS** | 85% | SOLIDO | Housekeeping, status, nuovo |
| **HOTEL** | 50% | MINIMALE | Solo configurazione base |

### Issues Tecnici
- `planning_swap.py` (965 righe) - da splittare
- `planning.py` (722 righe) - da splittare
- Guest logic frammentata in 4 file

---

## MODULI REVENUE

| Modulo | % | Status | Dettagli |
|--------|---|--------|----------|
| **RATEBOARD AI** | 90% | ENTERPRISE | Logica REALE, 365gg pattern, eventi |
| **PRICING TRACKING** | 95% | AVANZATO | Finestra adattiva 6-168h |
| **CITY TAX** | 90% | COMPLETO | Export ISTAT, esenzioni, compliance |
| **ANALYTICS** | 80% | BUONO | KPI: Occupancy, ADR, RevPAR |
| **PAYMENTS** | 40% | INCOMPLETO | Service scritti, NON integrati |
| **RECEIPTS** | 30% | INCOMPLETO | Solo preview JSON, NO PDF |
| **FATTURAZIONE** | 10% | GAP CRITICO | MANCA QUASI TUTTO |

### Cosa Funziona Bene
- Rateboard AI con breakdown spiegazione
- Pricing performance scoring (SUCCESS/NEUTRAL/WARNING/FAILURE)
- IMMUTABLE GUARD per compliance fiscale
- City tax con 8000+ comuni italiani

---

## INTEGRAZIONI

| Modulo | % | Status | Dettagli |
|--------|---|--------|----------|
| **CHANNEL MANAGER** | 95% | PRODUTTIVO | BeSync, auto-import, polling |
| **COMPLIANCE** | 95% | COMPLETO | Alloggiati Web + ISTAT C59 |
| **EMAIL** | 85% | FUNZIONA | Parser + poller + scheduler |
| **NIGHT AUDIT** | 80% | FUNZIONA | Manca email report |
| **DOCUMENTS** | 75% | FUNZIONA | OCR documenti identita |
| **COMPETITOR** | 40% | POC | Parser Booking.com da testare |
| **WHATSAPP** | 30% | STRUTTURA | Meta API pronta, no webhook |

---

## GAP CRITICI

### GAP #1: FATTURAZIONE (CRITICO)

```
MANCA COMPLETAMENTE:
├── Generazione fatture elettroniche XML
├── Numerazione progressiva legale
├── Invio SDI (Sistema Di Interscambio)
├── Note di credito
├── Registro fatture
├── Registratore telematico (RT)
└── Stampante fiscale
```

### GAP #2: RECEIPTS/SCONTRINI (ALTO)

```
MANCA:
├── Generazione PDF ricevute
├── Template HTML professionale
├── Archiviazione PDF
└── Invio email automatico
```

### GAP #3: PAYMENT INTEGRATION (ALTO)

```
PROBLEMA:
├── stripe_service.py SCRITTO ma NON chiamato
├── pagonline/ client PRONTO ma NON integrato
└── generate_payment_link() usa link FITTIZIO
```

---

## ARCHITETTURA FILE

```
backend/
├── routers/          # 50+ API endpoints
│   ├── bookings*.py  # Prenotazioni
│   ├── planning*.py  # Planning board
│   ├── guests*.py    # Ospiti
│   ├── rates*.py     # Tariffe
│   ├── payments.py   # Pagamenti (incompleto)
│   └── ...
├── services/         # 50+ business logic
│   ├── rateboard_ai.py
│   ├── cm_*.py       # Channel manager
│   ├── stripe_service.py (non usato!)
│   └── ...
├── models/           # 17 database models
├── compliance/       # Alloggiati, ISTAT
└── ml/              # Machine learning pricing
```

---

## REPORT DETTAGLIATI

| Report | Path |
|--------|------|
| Audit Core PMS | `reports/engineer_report_20260116_audit_core_pms.md` |
| Audit Revenue | `reports/engineer_report_20260116_124513.md` |
| Audit Integrazioni | `reports/engineer_report_miracollo_integrazioni_20260116.md` |

---

## PROSSIMI STEP

1. **FOCUS FINANZIARIO** - Colmare il gap critico
2. **Split planning files** - Refactoring tecnico
3. **Test competitor scraping** - Validare con dati reali
4. **Integrare payments** - Stripe o PagOnline

---

*"I dettagli fanno SEMPRE la differenza!"*
*Sessione 233 - Cervella & Rafa*
