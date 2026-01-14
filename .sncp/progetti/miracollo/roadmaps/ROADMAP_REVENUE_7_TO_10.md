# ROADMAP: Revenue Intelligence 7/10 → 10/10

> **Data:** 12 Gennaio 2026
> **Stato attuale:** 7/10 - BUONO
> **Target:** 10/10 - ECCELLENTE

---

## STATO VERIFICATO (Triple Check)

| Componente | Status | Dettaglio |
|------------|--------|-----------|
| API Bucchi | OK | 1 bucco, summary funziona |
| API Suggestions | OK | 2 suggestions |
| API Price History | OK | 50 record |
| API Applications | OK | 6 applications |
| API AI Health | OK | status FAIR |
| Frontend Split | OK | 5 file caricati correttamente |
| Backend Split | OK | 3 file, 63 test passati |

---

## FASE 1: IMMEDIATA (Settimana 1)

### 1.1 Testare GAP #2 Modal Preview
**Effort:** 30 min | **Owner:** Regina
**Task:**
- [ ] Creare nuova suggestion manuale
- [ ] Verificare modal mostra campi corretti
- [ ] Screenshot per documentazione

**Metriche successo:** Modal mostra price_before, price_after, camera

---

### 1.2 RateBoard Hard Tests
**Effort:** 2-3 ore | **Owner:** cervella-tester
**Task:**
- [ ] Test acceptance rate (quante suggestions accettate)
- [ ] Test override rate (quante modificate prima di accettare)
- [ ] Test response time API (< 200ms target)
- [ ] Test edge cases (date particolari, eventi)

**Metriche successo:**
- Acceptance rate > 60%
- Response time < 200ms
- Zero errori su edge cases

---

### 1.3 docker-compose.prod.yml
**Effort:** 1-2 ore | **Owner:** cervella-devops
**Task:**
- [ ] Creare file docker-compose.prod.yml
- [ ] Migrare da container manuali
- [ ] Documentare workflow deploy

**Metriche successo:** Zero container orfani, deploy riproducibile

---

## FASE 2: STABILIZZAZIONE (Settimana 2-3)

### 2.1 Monitoring Dashboard
**Effort:** 4-5 ore | **Owner:** cervella-frontend
**Task:**
- [ ] Dashboard health check
- [ ] Grafici real-time (acceptance rate, RevPAR)
- [ ] Alert automatici se problemi

### 2.2 Error Tracking Migliorato
**Effort:** 2-3 ore | **Owner:** cervella-backend
**Task:**
- [ ] Logging strutturato (JSON)
- [ ] Error aggregation
- [ ] Notification su errori critici

### 2.3 Test Coverage 80%
**Effort:** 4-5 ore | **Owner:** cervella-tester
**Task:**
- [ ] Aggiungere test mancanti
- [ ] Integration tests API
- [ ] E2E tests frontend

---

## FASE 3: ENHANCEMENT (Mese 1-2)

### 3.1 What-If Simulator MVP
**Effort:** 20-25 ore | **Owner:** cervella-frontend + cervella-backend
**Task:**
- [ ] UI con slider (prezzo, sconto)
- [ ] Grafici impatto real-time
- [ ] Backend calcolo scenari
- [ ] Integrazione con suggestions

**Perche PRIMA di ML:** Da valore SUBITO, costruisce fiducia

### 3.2 ML Database Schema
**Effort:** 5-8 ore | **Owner:** cervella-data
**Task:**
- [ ] Tabelle per feature storage
- [ ] Partitioning per performance
- [ ] Indexes ottimizzati

### 3.3 Feature Engineering Base
**Effort:** 15-20 ore | **Owner:** cervella-backend
**Task:**
- [ ] Occupancy tracking
- [ ] Booking pace calculation
- [ ] Competitor price delta

---

## FASE 4: ADVANCED (Mese 2-3)

### 4.1 ML Model Training
**Effort:** 40-50 ore | **Owner:** cervella-backend + cervella-researcher
**Task:**
- [ ] XGBoost model base
- [ ] Training pipeline
- [ ] Validation framework
- [ ] A/B testing setup

### 4.2 Analytics Avanzate
**Effort:** 20-25 ore | **Owner:** cervella-frontend + cervella-data
**Task:**
- [ ] RevPAR trend analysis
- [ ] Competitor benchmark
- [ ] Seasonal patterns

---

## RISCHI E MITIGAZIONI

| Rischio | Probabilita | Mitigazione |
|---------|-------------|-------------|
| ML non converge | Media | What-If funziona anche senza ML |
| Container orfani | Bassa | docker-compose.prod.yml |
| Bug in split | Bassa | 63 test + triple check |
| Performance API | Media | Caching + indexes |

---

## METRICHE TARGET 10/10

| Metrica | Attuale | Target |
|---------|---------|--------|
| Test Coverage | ~30% | 80% |
| API Response | ~300ms | < 200ms |
| Acceptance Rate | ? | > 60% |
| Uptime | ~99% | 99.9% |
| User Trust | ? | NPS > 8 |

---

## PRIORITA ASSOLUTA

```
+================================================================+
|                                                                |
|   "RateBoard PERFETTO > Nuove Features"                        |
|                                                                |
|   1. Stabilizzare quello che c'e                               |
|   2. Testare duramente                                         |
|   3. POI aggiungere ML/What-If                                 |
|                                                                |
|   I dettagli fanno SEMPRE la differenza!                       |
|                                                                |
+================================================================+
```

---

*Roadmap creata 12 Gennaio 2026*
*"Da 7/10 a 10/10 - un passo alla volta!"*
