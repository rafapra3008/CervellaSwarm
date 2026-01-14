# Test Audit - WhatsApp Feature

**Data**: 2026-01-14
**Tester**: Cervella Tester
**Progetto**: Miracollo PMS
**Feature**: WhatsApp Integration (Sprint 4.6-4.8)

---

## STATO: ❌ ZERO TEST COVERAGE

**CRITICO**: La feature WhatsApp non ha NESSUN test automatico.

---

## TEST ESISTENTI

**Risultato ricerca:**
```bash
# Ricerca file test
✗ test_whatsapp*.py (0 file)
✗ *whatsapp*test*.py (0 file)

# Grep "whatsapp" in backend/tests/
✗ Nessun file di test menziona WhatsApp
```

**CONCLUSIONE:** Zero test coverage per WhatsApp.

---

## CODICE DA TESTARE

### File Identificati

| File | LOC | Complessità | Priorità Test |
|------|-----|-------------|---------------|
| `routers/whatsapp.py` | ~527 | Alta | 🔴 CRITICA |
| `services/whatsapp_service.py` | ~203 | Media | 🔴 CRITICA |
| `services/meta_whatsapp_service.py` | ~100+ | Media | 🟡 Alta |
| `services/twilio_whatsapp_service.py` | ~100+ | Media | 🟡 Alta |

### Funzionalità Critiche (NON TESTATE!)

**Router (`whatsapp.py`):**
- ✗ Webhook verification (GET `/webhook`)
- ✗ Webhook receive (POST `/webhook`)
- ✗ Rate limiter (IP + Phone)
- ✗ Signature validation HMAC SHA256
- ✗ Auto-reply AI
- ✗ Send message (`/send`)
- ✗ Send template (`/send-template`)
- ✗ Inbox (`/inbox`)
- ✗ Mark as read

**AI Service (`whatsapp_service.py`):**
- ✗ FAQ matching
- ✗ Claude AI reply generation
- ✗ Auto-reply logic

**Meta Service:**
- ✗ API calls a Meta Cloud
- ✗ Error handling

**Twilio Service:**
- ✗ Fallback logic
- ✗ Error handling

---

## EDGE CASES SCOPERTI

### Sicurezza (CRITICI!)
- [ ] Webhook con signature invalida
- [ ] Webhook senza signature in production
- [ ] Rate limiting: IP flood attack
- [ ] Rate limiting: Phone spam attack
- [ ] HMAC timing attack
- [ ] Invalid token verification

### Input Validation
- [ ] Phone number invalido
- [ ] Messaggio vuoto
- [ ] Template non trovato
- [ ] JSON malformato webhook
- [ ] Twilio format fallback

### Business Logic
- [ ] Auto-reply: FAQ match
- [ ] Auto-reply: Claude fallback
- [ ] Meta fail → Twilio fallback
- [ ] Nessun provider configurato
- [ ] Messaggio duplicato (idempotency)
- [ ] Database failure durante webhook

### Rate Limiter
- [ ] Cleanup old entries
- [ ] Concurrent requests race condition
- [ ] Memory leak con IP multipli
- [ ] Stats correttezza

---

## INFRASTRUTTURA TEST ESISTENTE

**Configurazione pytest:**
```ini
[pytest]
testpaths = tests
python_files = test_*.py
asyncio_mode = auto
addopts = -v --tb=short
```

**Fixture disponibili (conftest.py):**
- `client` - FastAPI TestClient
- `api_base` - "/api"
- `auth_headers` - Mock auth
- `sample_hotel` - Dati hotel test
- `sample_guest` - Dati ospite test

**NOTA:** Fixture esistenti NON sufficienti per WhatsApp. Serve:
- Mock Meta API
- Mock Twilio API
- Mock Anthropic Claude
- Database test dedicato
- Mock webhook payload

---

## STRUTTURA CONSIGLIATA

### File da Creare

```
backend/tests/
├── test_whatsapp_router.py         # Endpoint testing
├── test_whatsapp_ai_service.py     # AI logic testing
├── test_whatsapp_rate_limiter.py   # Rate limiter testing
├── test_whatsapp_security.py       # Signature validation, attacks
├── test_meta_service.py            # Meta Cloud API mocking
├── test_twilio_service.py          # Twilio API mocking
└── fixtures/
    └── whatsapp_fixtures.py        # Mock payloads, services
```

### Priorità Implementazione

**FASE 1 - CRITICI (Security):**
1. `test_whatsapp_security.py` - Signature validation, rate limiting
2. `test_whatsapp_rate_limiter.py` - Unit test rate limiter

**FASE 2 - CORE BUSINESS:**
3. `test_whatsapp_router.py` - Endpoint send/receive
4. `test_whatsapp_ai_service.py` - FAQ + Claude

**FASE 3 - INTEGRAZIONE:**
5. `test_meta_service.py` - API calls mocking
6. `test_twilio_service.py` - Fallback logic

---

## MOCK NECESSARI

### External Services
```python
# Meta Cloud API
@pytest.fixture
def mock_meta_api(monkeypatch):
    # Mock requests.post to Meta
    pass

# Twilio Client
@pytest.fixture
def mock_twilio_client(monkeypatch):
    # Mock twilio.rest.Client
    pass

# Anthropic Claude
@pytest.fixture
def mock_claude_ai(monkeypatch):
    # Mock anthropic.Anthropic
    pass
```

### Webhook Payloads
```python
# Meta webhook format
META_WEBHOOK_INBOUND = {
    "entry": [{
        "changes": [{
            "value": {
                "messages": [{
                    "from": "+393334830122",
                    "type": "text",
                    "text": {"body": "Ciao, info check-in?"},
                    "id": "wamid.123"
                }]
            }
        }]
    }]
}

# Twilio webhook format (form-encoded)
TWILIO_WEBHOOK_INBOUND = {
    "From": "whatsapp:+393334830122",
    "Body": "Ciao, info check-in?",
    "MediaUrl0": None
}
```

---

## COMMAND DA ESEGUIRE

### Setup Test Database
```bash
# Crea database test separato
export DATABASE_PATH="backend/data/test_miracollo.db"
python backend/database/init_db.py
```

### Eseguire Test (quando creati)
```bash
# Tutti i test WhatsApp
pytest backend/tests/test_whatsapp*.py -v

# Solo security
pytest backend/tests/test_whatsapp_security.py -v

# Con coverage
pytest backend/tests/test_whatsapp*.py --cov=backend/routers/whatsapp --cov=backend/services/whatsapp_service
```

---

## METRICHE ATTESE

### Code Coverage Target
```
backend/routers/whatsapp.py           90%+
backend/services/whatsapp_service.py  85%+
backend/services/meta_whatsapp_service.py   80%+
backend/services/twilio_whatsapp_service.py 80%+
```

### Test Categories
```
Unit Tests:        ~30 test (services, rate limiter, AI logic)
Integration Tests: ~20 test (router endpoints, fallback)
Security Tests:    ~15 test (signature, rate limit, attacks)
Edge Cases:        ~10 test (error handling, validation)
---
TOTALE:           ~75 test
```

---

## RISCHI ATTUALI

| Rischio | Probabilità | Impatto | Mitigation |
|---------|-------------|---------|------------|
| Webhook fake (no signature) | Alta | CRITICO | Test security subito |
| DoS attack (no rate limit test) | Media | Alto | Test rate limiter |
| AI reply errata | Bassa | Medio | Test FAQ matching |
| Fallback Twilio non funziona | Media | Alto | Test integration |
| Database race condition | Media | Alto | Test concurrency |
| Memory leak rate limiter | Bassa | Medio | Test cleanup logic |

---

## SUMMARY

**FATTO:** ✅ Audit completo codice WhatsApp
**TROVATO:** ❌ Zero test coverage (CRITICO!)
**TEST NECESSARI:** ~75 test da creare
**FILES DA CREARE:** 6 file test + fixtures
**PRIORITÀ:** Security tests PRIMA (signature + rate limit)

**NEXT:** Creare test security come priorità #1

---

*Report generato da Cervella Tester - "Se non è testato, non funziona."*
