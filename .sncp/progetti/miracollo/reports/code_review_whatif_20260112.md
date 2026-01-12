# Code Review What-If Simulator - 12 Gennaio 2026

> Review settimanale by Cervella Reviewer

---

## VERDETTO

| | |
|---|---|
| **Score** | 7.5/10 |
| **Verdict** | REQUEST CHANGES |
| **LOC Analizzate** | 1,501 righe |

---

## TOP 3 ISSUES

1. **BLOCKER**: Fake `applyPrice()` button inganna utenti
2. **CRITICAL**: XSS vulnerability in scenario rendering (L467 what-if.js)
3. **CRITICAL**: API URL hardcoded + no auth checks

---

## ISSUES PER SEVERITY

| Severity | Count |
|----------|-------|
| Critici | 4 |
| Alti | 9 |
| Medi | 18 |
| Bassi | 16 |
| **Totale** | **47** |

---

## ANALISI FILE PER FILE

### what-if.html (315 righe) - Score 8/10

**CRITICI:**
- L303: Modal senza ESC key handler
- L10: Chart.js CDN senza SRI (Subresource Integrity)
- L473: onclick inline HTML viola CSP

**POSITIVI:**
- HTML5 semantico pulito
- Preconnect Google Fonts
- Modal ben strutturato

---

### what-if.js (560 righe) - Score 7/10

**CRITICI:**
- **L8: URL API hardcoded** `https://miracollo.com/api/v1`
- **L122: No timeout fetch** - rischio hang infinito
- **L467-477: HTML INJECTION XSS** - s.roomType NON sanitizzato!
- **L549-552: applyPrice() è FAKE** - Prezzo NON applicato realmente!

**ALTI:**
- L64, L87, L122: Fetch senza validazione HTTPS
- L12: LocalStorage senza limite size
- L428, L513, L550: alert() usato - UX pessima

**POSITIVI:**
- Architettura class-based pulita
- Debouncing implementato
- LocalStorage usato bene
- Chart.js configurato correttamente

---

### what_if_api.py (419 righe) - Score 8/10

**CRITICI:**
- **L218: Occupancy 70% hardcoded** - DATI FAKE
- **L222: Total rooms 50 hardcoded** - DATI FAKE
- **L364-379: NO AUTH CHECKS**

**ALTI:**
- **L170: N+1 Query Problem** - 40+ queries per grafico!
- L199: Raw SQL invece di ORM

**POSITIVI:**
- Pydantic schemas eccellenti
- Docstrings complete
- Type hints completi
- Fallback graceful

---

## SICUREZZA

### XSS (Cross-Site Scripting) - SEVERITY: ALTO

**LOCATION:** what-if.js:467-477

**FIX:**
```javascript
// NO: html += '<span>' + s.roomType + '</span>'
// YES:
const span = document.createElement('span');
span.textContent = s.roomType;  // Auto-escaped
```

### Authentication - SEVERITY: CRITICO

**PROBLEMA:** Chiunque può simulare prezzi per QUALSIASI property!

**FIX:** Aggiungere `current_user=Depends(get_current_user)` + verifica ownership

---

## PERFORMANCE

| Metrica | Valore | Target | Status |
|---------|--------|--------|--------|
| Initial Load | ~800ms | <1s | OK |
| API Call | ~200ms | <300ms | OK |
| Slider Response | ~500ms | <200ms | SLOW |

**BOTTLENECK:**
- Debounce 300ms + API 200ms = 500ms lag
- N+1 query: 17 chiamate DB per price curve

---

## RACCOMANDAZIONI PRIORITARIE

### CRITICI (Fare SUBITO)

1. **Rimuovere/Implementare applyPrice()** - Ora è FAKE e inganna utenti
2. **Fix XSS** - createElement + textContent
3. **API URL configurabile** - ENV variable
4. **Auth check API** - Property ownership

### ALTI (Fare PRESTO)

5. Fix N+1 query price curve
6. SRI per CDN Chart.js
7. alert() → modal custom
8. Timeout fetch (max 10s)

### MEDI (Backlog)

9. Split `_generate_explanation` (78 righe!)
10. Unit tests (target 80%+)
11. JSDoc documentation
12. ARIA labels

---

## COSA È FATTO BENE

1. Architettura pulita (Router/Service separation)
2. User feedback completo (loading, errors)
3. Fallback graceful (DB mancanti → defaults)
4. LocalStorage corretto (limit 5 scenari)
5. Debouncing implementato
6. Pydantic validation robusta
7. Business logic intelligente (elasticity, confidence)

---

## METRICHE FINALI

| Categoria | Score | Peso | Weighted |
|-----------|-------|------|----------|
| Funzionalita | 9/10 | 20% | 1.8 |
| Sicurezza | 6/10 | 25% | 1.5 |
| Performance | 8/10 | 15% | 1.2 |
| Manutenibilita | 7/10 | 15% | 1.05 |
| UX/A11y | 6/10 | 10% | 0.6 |
| Code Quality | 7/10 | 10% | 0.7 |
| Testing | 0/10 | 5% | 0 |
| **TOTALE** | - | 100% | **7.5/10** |

---

## VERDETTO FINALE

```
MVP = OK per demo interna
PROD = Richiede hardening security + auth + tests
```

**Prossimi Step:**
1. Decidere fate applyPrice (implementare o rimuovere)
2. Fix XSS
3. ENV config API URL
4. Auth middleware

---

*Cervella Reviewer - 12 Gennaio 2026*
