# OUTPUT: Rate Limiting WhatsApp Webhook

**Data**: 20260114 | **Worker**: cervella-backend
**Task**: Implementare rate limiting per webhook WhatsApp

---

## File Modificati

- `/Users/rafapra/Developer/miracollogeminifocus/backend/routers/whatsapp.py` - Aggiunto rate limiting in-memory

---

## Cosa Ho Implementato

### 1. Classe RateLimiter (In-Memory)
```python
class RateLimiter:
    - 100 requests/minuto per IP (protezione DoS)
    - 10 messaggi/minuto per phone number (anti-spam)
    - Cleanup automatico entry > 60 secondi
    - Dict con timestamp per tracking
```

### 2. Protezione Webhook POST `/webhook`

**Check IP (step 1 - PRIMA di tutto):**
- Verifica IP client
- Blocca se > 100 req/min
- Restituisce 429 Too Many Requests

**Check Phone (step 5 - dopo parsing):**
- Verifica phone number mittente
- Blocca se > 10 msg/min per numero
- Applicato sia per Meta che Twilio

### 3. Logging
- Log warning quando rate limit è raggiunto
- Include IP/phone e conteggio corrente
- Emoji 🚫 per visibilità immediata

---

## Caratteristiche Implementate

✅ **Zero dipendenze esterne** - Solo stdlib Python
✅ **In-memory** - Nessun database o Redis richiesto
✅ **Thread-safe** - Dict Python con float timestamp
✅ **Auto-cleanup** - Rimuove entry vecchie automaticamente
✅ **Doppio livello** - IP (DoS) + Phone (spam)
✅ **HTTP 429** - Status code corretto con retry_after
✅ **Non invasivo** - Non tocca logica esistente

---

## Versioning

- **Version**: `2.3.0` → `2.4.0`
- **Version Date**: `2026-01-06` → `2026-01-14`
- **Changelog**: Aggiunto in testa al file

---

## Come Testare

### Test 1: Rate Limit IP (DoS Protection)
```bash
# Simula 101 richieste rapide dallo stesso IP
for i in {1..101}; do
  curl -X POST http://localhost:8000/api/whatsapp/webhook \
    -H "Content-Type: application/json" \
    -d '{"entry":[]}' &
done

# Atteso: Prime 100 OK, 101esima = 429
```

### Test 2: Rate Limit Phone (Anti-Spam)
```bash
# Simula 11 messaggi dallo stesso numero
for i in {1..11}; do
  curl -X POST http://localhost:8000/api/whatsapp/webhook \
    -H "Content-Type: application/json" \
    -d '{
      "entry": [{
        "changes": [{
          "value": {
            "messages": [{
              "from": "+39123456789",
              "type": "text",
              "text": {"body": "Test"}
            }]
          }
        }]
      }]
    }'
  sleep 0.1
done

# Atteso: Primi 10 OK, 11esimo = 429
```

### Test 3: Reset Automatico
```bash
# Invia richiesta, attendi 61 secondi, riprova
curl -X POST http://localhost:8000/api/whatsapp/webhook ...
sleep 61
curl -X POST http://localhost:8000/api/whatsapp/webhook ...

# Atteso: Entrambe OK (counter resettato)
```

---

## Note per Guardiana

1. **Testare in staging PRIMA di produzione**
   - Verifica che 429 non rompa integrazione Meta
   - Controlla se Meta ha retry automatico

2. **Monitoring suggerito**
   - Aggiungere endpoint `GET /whatsapp/rate-limit-stats`
   - Mostra `rate_limiter.get_stats()`
   - Utile per vedere IP/phone bloccati

3. **Configurabilità futura**
   - Limiti hardcoded (100/10)
   - Se serve, spostare in ENV vars:
     - `RATE_LIMIT_IP=100`
     - `RATE_LIMIT_PHONE=10`

4. **Production Readiness**
   - In-memory = perdi stato al restart
   - Per multi-instance, serve Redis
   - OK per single-instance attuale

---

## Acceptance Criteria

- [x] Rate limit 100 req/min per IP
- [x] Rate limit 10 msg/min per phone
- [x] In-memory (no dipendenze)
- [x] Log quando raggiunto
- [x] HTTP 429 con retry_after
- [x] Version 2.4.0
- [x] Changelog aggiornato
- [x] Codice compilato (py_compile OK)

---

**Status**: ✅ COMPLETATO

*Il rate limiting è implementato e pronto. Testare in staging prima di deploy in produzione.*
