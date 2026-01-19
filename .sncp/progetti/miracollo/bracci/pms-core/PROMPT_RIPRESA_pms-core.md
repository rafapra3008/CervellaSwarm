<!-- DISCRIMINATORE: MIRACOLLO PMS CORE -->
<!-- PORTA: 8001 | TIPO: Sistema alberghiero principale -->
<!-- PATH: ~/Developer/miracollogeminifocus/ (backend principale) -->
<!-- NON CONFONDERE CON: Miracollook (8002), Room Hardware (8003) -->

# PROMPT RIPRESA - PMS Core

> **Ultimo aggiornamento:** 19 Gennaio 2026 - Sessione 271
> **STATO:** 90% LIVE + Modulo Finanziario 75%

---

## SESSIONE 271 - FATTURE XML TEST OK!

```
+================================================================+
|                                                                |
|   TEST SPRING: SUPERATO!                                       |
|                                                                |
|   - 2 XML generati (200/NL semplice, 201/NL completo)         |
|   - Validati contro schema FatturaPA v1.2                      |
|   - Import SPRING: OK (PDF generato)                           |
|                                                                |
|   DECISIONE: Implementazione PARCHEGGIATA                      |
|   Motivo: Test OK, implementare quando serve realmente         |
|                                                                |
+================================================================+
```

### File Test
```
~/Desktop/fatture_xml_test/
├── IT00658350251_00200.xml   ← Fattura semplice
├── IT00658350251_00201.xml   ← Fattura completa (10%+22%+N1)
├── IT00658350251_00201.PDF   ← Output SPRING
└── Schema_FatturaPA_v1.2.xsd ← Schema ufficiale
```

---

## MODULO FINANZIARIO - STATO

| Fase | Componente | Stato |
|------|------------|-------|
| 1 | Ricevute PDF | 100% REALE |
| 1B | Checkout UI | 100% REALE |
| 2 | Scontrini RT | 90% - test stampante DA FARE |
| 3 | Fatture XML | 60% - TEST OK, impl. PARCHEGGIATA |
| 4 | Export | 0% - PARCHEGGIATO |

---

## PROSSIMO STEP CONCRETO

```
QUANDO IN HOTEL:
  1. Test adapter Scontrini RT su stampante Bar
  2. Se OK: UI integrazione checkout
  3. Se OK: Chiusura automatica 23:55

TUTTO RESTO: PARCHEGGIATO
```

---

## PARCHEGGIATI (19 Gen 2026)

| Cosa | Motivo |
|------|--------|
| Fatture XML impl. | Test SPRING OK, impl. quando serve |
| Export commercialista | 10-15 fatt/mese = gestibile manuale |
| Modularizzazione FASE 2-3 | Codice funziona |

---

## ARCHITETTURA

```
Internet -> Nginx (443) -> Backend (8001) -> SQLite
VM: miracollo-cervella (Google Cloud)
PATH: /home/rafapra/app/
```

---

## GUIDE E DOC

| File | Scopo |
|------|-------|
| GUIDA_FATTURE_XML_MIRACOLLO.md | Tutto su fatture XML |
| MAPPA_MODULO_FINANZIARIO.md | Stato modulo completo |
| STATO_REALE_PMS.md | Verifica infrastruttura |

---

*"Test SPRING OK! Sappiamo che funziona. Implementiamo quando serve."*
