# SUB-ROADMAP: Miracollo 9.5 → 10/10

> **Versione:** 1.0.0
> **Data:** 14 Gennaio 2026 - Sessione 201
> **Autore:** Cervella Regina
> **Status:** PIANIFICATO

---

## EXECUTIVE SUMMARY

```
+================================================================+
|                                                                |
|   MIRACOLLO RMS: DA 9.5/10 A 10/10                             |
|                                                                |
|   STATO ATTUALE:     9.5/10 STABILE                            |
|   TARGET:            10/10 PRODUZIONE-READY                    |
|   GAP:               0.5 punti                                 |
|                                                                |
|   EFFORT STIMATO:    6-8 settimane (incrementale)              |
|                                                                |
|   "Fatto BENE > Fatto VELOCE"                                  |
|                                                                |
+================================================================+
```

---

## STATO ATTUALE - Cosa Funziona

| Feature | Status | Note |
|---------|--------|------|
| Weather API | LIVE | Cortina/Alleghe, suggerimenti automatici |
| Eventi Locali | LIVE | 6 eventi, integrati in AI |
| Autopilot | FUNZIONANTE | Disabilitato, dry_run OK |
| Competitor Scraping | 95% | Manca URL reale |
| Revenue Intelligence | LIVE | CSP fix, heatmap, whatif |
| Transparent AI | LIVE | Confidence breakdown |
| Learning from Actions | LIVE | Feedback widget |

---

## GAP IDENTIFICATI

| # | Area | Gap | Impatto | Effort |
|---|------|-----|---------|--------|
| 1 | Test Coverage | Solo 20 test vs 50+ servizi | +0.30 | 2 settimane |
| 2 | File Grandi | 3 file > 750 righe | +0.10 | 2 settimane |
| 3 | TODO/FIXME | 28 aperti nel codice | +0.05 | 1-2 settimane |
| 4 | Documentazione | Solo 1 API documentata | +0.025 | 1 settimana |
| 5 | Monitoring | No health checks avanzati | +0.015 | 3-4 giorni |
| 6 | Performance | No load testing | +0.01 | 1 settimana |

**Totale GAP: 0.5 punti**

---

## FASE 1: TEST COVERAGE (+0.30 punti)

> **Priorità:** CRITICA
> **Effort:** 2 settimane
> **Owner:** cervella-tester

### Target
- Coverage: 70%+ su business logic
- Test unit + integration
- CI/CD automatico

### Tasks

| Task | Effort | Status |
|------|--------|--------|
| 1.1 Setup pytest-cov | 2h | TODO |
| 1.2 Test suggerimenti_engine (20 test) | 3 giorni | TODO |
| 1.3 Test weather_service (10 test) | 1 giorno | TODO |
| 1.4 Test event_service (10 test) | 1 giorno | TODO |
| 1.5 Test email_parser (15 test) | 2 giorni | TODO |
| 1.6 Test autopilot (esistono, verificare) | 1 giorno | TODO |
| 1.7 Integration tests Weather+Events+Suggerimenti | 2 giorni | TODO |
| 1.8 Setup GitHub Actions CI | 1 giorno | TODO |
| 1.9 Badge coverage README | 1h | TODO |

### Deliverables
- `pytest-cov` configurato
- 50+ nuovi test
- Coverage report automatico
- CI/CD pipeline attiva

---

## FASE 2: REFACTORING FILE GRANDI (+0.10 punti)

> **Priorità:** ALTA
> **Effort:** 2 settimane
> **Owner:** cervella-backend

### File da Splittare

#### 2.1 suggerimenti_engine.py (1031 righe)
```
ATTUALE:
backend/services/suggerimenti_engine.py (1031 righe)

DOPO:
backend/services/suggerimenti/
├── __init__.py (50 righe) - exports
├── engine.py (200 righe) - coordinator
├── weather_suggestions.py (150 righe)
├── event_suggestions.py (150 righe)
├── occupancy_suggestions.py (200 righe)
├── price_suggestions.py (150 righe)
└── utils.py (100 righe)
```

#### 2.2 email_parser.py (829 righe)
```
ATTUALE:
backend/services/email_parser.py (829 righe)

DOPO:
backend/services/email_parsing/
├── __init__.py
├── parser.py (150 righe) - entry point
├── besync_parser.py (300 righe)
├── bookingengine_parser.py (300 righe)
└── utils.py (80 righe)
```

#### 2.3 cm_import_service.py (761 righe)
```
ATTUALE:
backend/services/cm_import_service.py (761 righe)

DOPO:
backend/services/channel_manager/
├── __init__.py
├── import_service.py (200 righe) - orchestrator
├── validators.py (200 righe)
├── mappers.py (200 righe)
└── sync.py (160 righe)
```

### Deliverables
- 3 file grandi → 3 moduli puliti
- Zero breaking changes (stessi import esterni)
- Test aggiornati

---

## FASE 3: COMPLETARE TODO (+0.05 punti)

> **Priorità:** ALTA
> **Effort:** 1-2 settimane
> **Owner:** cervella-backend

### TODO Critici (12)
```
document_intelligence/scanner.py:
- Step 1-6 preprocessing/OCR/validation STUB
- Impatta Document Scanner
```

### TODO Funzionali (8)
```
pagonline/client.py: Implementare pagamenti
date_validator.py: 4 validazioni
fiscal_code_validator.py: Check digit
```

### TODO Nice-to-have (8)
```
email_parser.py: Estrazione num_guests
altri minori
```

### Deliverables
- 0 TODO critici
- < 5 TODO totali (nice-to-have)

---

## FASE 4: DOCUMENTAZIONE API (+0.025 punti)

> **Priorità:** MEDIA
> **Effort:** 1 settimana
> **Owner:** cervella-docs

### Tasks

| Endpoint | Doc Status |
|----------|------------|
| /api/weather/* | TODO |
| /api/events/* | TODO |
| /api/revenue/* | TODO |
| /api/autopilot/* | TODO |
| /api/ab-testing/* | FATTO |
| /api/rateboard/* | TODO |

### Approccio
- FastAPI auto-genera /docs (Swagger)
- Aggiungere esempi request/response
- Documentare error codes
- Authentication flow

### Deliverables
- /docs endpoint completo
- README con link API docs
- Postman collection (bonus)

---

## FASE 5: MONITORING (+0.015 punti)

> **Priorità:** MEDIA
> **Effort:** 3-4 giorni
> **Owner:** cervella-devops

### Tasks

| Task | Effort | Tool |
|------|--------|------|
| 5.1 /api/health/detailed | 2h | FastAPI |
| 5.2 Structured logging | 1 giorno | structlog |
| 5.3 Sentry.io integration | 4h | Sentry |
| 5.4 Uptime monitoring | 30min | UptimeRobot |

### Deliverables
- Health check avanzato (DB, Weather API, Events)
- Error tracking automatico
- Uptime dashboard

---

## FASE 6: PERFORMANCE (+0.01 punti)

> **Priorità:** BASSA
> **Effort:** 1 settimana
> **Owner:** cervella-backend

### Tasks

| Task | Effort | Tool |
|------|--------|------|
| 6.1 Load testing | 2 giorni | Locust |
| 6.2 Query analysis | 1 giorno | EXPLAIN |
| 6.3 Profiling | 1 giorno | py-spy |
| 6.4 Cache strategy doc | 1 giorno | - |

### Deliverables
- Load test report (req/sec target)
- Query optimization
- Performance baseline

---

## TIMELINE SUGGERITA

```
GENNAIO 2026
+--------+--------+--------+--------+
| W3     | W4     |        |        |
+--------+--------+--------+--------+
| FASE 1: TEST COVERAGE             |
| (incrementale, mentre lavoriamo)  |
+--------+--------+--------+--------+

FEBBRAIO 2026
+--------+--------+--------+--------+
| W1     | W2     | W3     | W4     |
+--------+--------+--------+--------+
| FASE 2: REFACTORING               |
|        | FASE 3: TODO              |
|               | FASE 4+5+6        |
+--------+--------+--------+--------+

>>> TARGET 10/10: Fine Febbraio 2026 <<<
```

---

## APPROCCIO INCREMENTALE

> **"Una cosa alla volta, fino al 100000%!"**

```
NON fare tutto insieme!

Ogni sessione:
1. Scegliere 1 task dalla lista
2. Completarlo al 100%
3. Commit + push
4. Aggiornare questa roadmap
5. Prossimo task

PROGRESSI VISIBILI ogni giorno!
```

---

## METRICHE SUCCESSO

| Metrica | Attuale | Target |
|---------|---------|--------|
| RATEBOARD Score | 9.5/10 | 10/10 |
| Test Coverage | ~30% | 70%+ |
| File > 500 righe | 15 | < 5 |
| TODO aperti | 28 | < 5 |
| API documentate | 1/30 | 30/30 |
| Uptime | ? | 99.9% |

---

## QUICK WINS (oggi/domani)

Cose che si possono fare SUBITO:

1. **Uptime monitoring** (30 min)
   - Setup UptimeRobot free
   - Monitor https://miracollo.com/api/health

2. **Competitor URL** (5 min)
   - Rafa fornisce URL Booking competitor
   - Test scraping completo

3. **Autopilot attivazione** (10 min)
   - Abbassare min_confidence a 70%
   - O aspettare suggerimenti alta confidence

---

*"Fatto BENE > Fatto VELOCE"*
*"Una cosa alla volta, standard 100000%!"*
*"Il debito tecnico si paga con gli interessi."*

*Creato: 14 Gennaio 2026 - Sessione 201*
*Cervella Regina per Miracollo*
