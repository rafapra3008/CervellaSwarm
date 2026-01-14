# ANALISI WhatsApp Router - Miracollo

**Data**: 2026-01-14
**File**: `~/Developer/miracollogeminifocus/backend/routers/whatsapp.py`
**Versione**: v2.4.0 (2026-01-14)
**Worker**: cervella-backend

---

## 1. ENDPOINT (7 totali)

### GET `/webhook`
**Scopo**: Verifica webhook Meta (handshake iniziale)
**Query Params**:
- `hub.mode` - Deve essere "subscribe"
- `hub.verify_token` - Deve matchare `META_WHATSAPP_VERIFY_TOKEN`
- `hub.challenge` - Stringa da restituire in PlainText

**Response**: PlainTextResponse con challenge se ok, 403 se fallito

### POST `/webhook`
**Scopo**: Riceve messaggi inbound (Meta + Twilio fallback)
**Body**: JSON Meta format o form-data Twilio
**Headers**: `X-Hub-Signature-256` per validazione HMAC (solo Meta)
**Response**: `{"status": "received"}`

### POST `/send`
**Scopo**: Invia messaggio WhatsApp
**Body**: `SendMessageRequest`
- `phone: str` (destinatario)
- `message: str` (testo)
- `booking_id: Optional[int]`

**Response**: `{"status": "sent", "message_id": str, "provider": str}`
**Provider**: Prova Meta, fallback Twilio

### POST `/send-template`
**Scopo**: Invia template pre-salvato con variabili
**Body**: `SendTemplateRequest`
- `phone: str`
- `template_name: str`
- `variables: dict` (placeholder replacement)
- `booking_id: Optional[int]`

**Logica**: Carica template da DB, sostituisce `{{key}}`, chiama `/send`

### GET `/messages/{booking_id}`
**Scopo**: Storico messaggi per prenotazione
**Response**: Array di `MessageResponse`

### GET `/inbox`
**Scopo**: Lista messaggi recenti (inbox)
**Query Params**:
- `unread: bool = False`
- `limit: int = 50` (max 100)

**Response**: Array di record con tutti i campi DB

### PUT `/messages/{message_id}/read`
**Scopo**: Marca messaggio come letto
**Response**: `{"status": "marked_read", "id": int}`

---

## 2. RATE LIMITING - DETTAGLIO COMPLETO

### Classe `RateLimiter` (in-memory)

**Limiti**:
- **100 req/min per IP** → Protezione DoS
- **10 msg/min per phone** → Anti-spam

**Implementazione**:
```python
_ip_requests: Dict[str, List[float]]       # {ip: [timestamp1, timestamp2, ...]}
_phone_requests: Dict[str, List[float]]    # {phone: [timestamp1, timestamp2, ...]}
_window_seconds = 60
```

**Cleanup Automatico**:
- Rimuove timestamp > 60 secondi prima di ogni verifica
- `_cleanup_old_entries()` eseguito su ogni check

**Metodi**:
1. `check_ip_limit(ip: str) -> bool`
   - Cleanup old entries
   - Se `len(requests) >= 100` → False (bloccato)
   - Altrimenti aggiungi timestamp → True (ok)

2. `check_phone_limit(phone: str) -> bool`
   - Cleanup old entries
   - Se `len(requests) >= 10` → False (bloccato)
   - Altrimenti aggiungi timestamp → True (ok)

3. `get_stats() -> dict`
   - Ritorna statistiche correnti (monitoring)

**Response quando bloccato**:
```python
JSONResponse(status_code=429, content={
    "error": "Too many requests",  # (per IP)
    "error": "Too many messages",  # (per phone)
    "retry_after": 60
})
```

**Istanza Globale**:
```python
rate_limiter = RateLimiter()  # Singola istanza per tutta l'app
```

---

## 3. LOGICA BUSINESS - PER ENDPOINT

### Webhook POST (ricezione)
**Flow**:
1. **Rate limit IP** → Check 100 req/min (DoS protection)
2. **Leggi raw body** → Per signature validation
3. **Signature validation** (solo Meta):
   - Se `ENVIRONMENT=production` + `app_secret` configurato + NO signature → REJECT 403
   - Se signature presente → Valida HMAC SHA256
   - Se validation fail → REJECT 403
4. **Parse payload**:
   - JSON Meta format → Estrai messaggi da `entry[].changes[].value.messages[]`
   - Form-data Twilio → Estrai `From`, `Body`, `MediaUrl0`
5. **Rate limit phone** → Check 10 msg/min per mittente
6. **Salva in DB** → `whatsapp_messages` table
7. **Auto-reply AI** → Solo per `msg_type=text` e se content presente
8. **Response 200** → `{"status": "received"}`

### Auto-Reply AI (funzione helper)
**Function**: `_handle_auto_reply(from_number, message_text, property_id, source)`

**Flow**:
1. Inizializza `WhatsAppAI(property_id)`
2. Chiama `ai_service.should_auto_reply(message_text)` → (bool, reply_text)
3. Se `should_reply=True`:
   - Prova invio via **Meta** → `meta_service.send_text()`
   - Se fallito → Fallback **Twilio** → `twilio_service.send_text()`
   - Salva risposta in DB con `ai_auto_replied=TRUE`
4. Se errore → Log, ma **non blocca webhook** (fail silently)

**Refactor DRY**: La logica è identica per Meta e Twilio (no duplicazione)

### Send Message
**Flow**:
1. Prova **Meta** → `meta_service.send_text()`
2. Se fallito → Prova **Twilio** → `twilio_service.send_text()`
3. Se nessun provider configurato → 400
4. Se errore invio → 500
5. Salva in DB → `whatsapp_messages` con `direction=outbound`, `status=sent`

### Send Template
**Flow**:
1. Query DB → `SELECT content FROM whatsapp_templates WHERE name=? AND property_id=1`
2. Se non trovato → 404
3. Sostituisci variabili → `{{key}}` con `req.variables[key]`
4. Chiama `/send` internamente con `SendMessageRequest`

### Inbox
**Flow**:
1. Query `whatsapp_messages WHERE property_id=1`
2. Se `unread=True` → Aggiungi `AND is_read=FALSE`
3. `ORDER BY created_at DESC LIMIT ?` (max 100)

---

## 4. DIPENDENZE

### Import Standard
```python
os, logging, hmac, hashlib, json, time, datetime
fastapi (APIRouter, HTTPException, Request, Query)
fastapi.responses (PlainTextResponse, JSONResponse)
pydantic (BaseModel)
aiosqlite
```

### Servizi Interni
```python
backend.services.whatsapp_service.WhatsAppAI
backend.services.meta_whatsapp_service.get_meta_whatsapp_service
backend.services.twilio_whatsapp_service.get_twilio_whatsapp_service
```

### Variabili Ambiente Richieste
```python
DATABASE_PATH = "backend/data/miracollo.db"
META_WHATSAPP_VERIFY_TOKEN = [required per webhook verification]
META_WHATSAPP_APP_SECRET = [required per signature validation]
ENVIRONMENT = "development" | "production"
```

### Database Tables
```python
whatsapp_messages (
    id, property_id, guest_phone, booking_id,
    direction, message_type, content, status,
    meta_message_id, ai_auto_replied, is_read, created_at
)

whatsapp_templates (
    name, content, property_id
)
```

---

## 5. EDGE CASES GESTITI

### Security
✅ **HMAC Signature Validation** (HMAC SHA256)
- Protegge da richieste fake che bypassano Meta
- Usa `hmac.compare_digest()` per constant-time comparison (anti timing-attack)
- In production: se `app_secret` configurato MA signature manca → REJECT 403

✅ **Rate Limiting DoS**
- 100 req/min per IP → Previene flooding
- 429 response con `retry_after: 60`

✅ **Rate Limiting Spam**
- 10 msg/min per phone → Previene spam da singolo numero
- 429 response con `retry_after: 60`

### Formato Payload
✅ **Meta JSON Format**
- Parse `entry[].changes[].value.messages[]`
- Gestisce tutti i tipi: text, image, document, audio, video
- Content placeholder per media: `[IMAGE]`, `[DOCUMENT]`, etc.

✅ **Twilio Form-Data Fallback**
- Se JSON parsing fallisce → `await request.form()`
- Rimuove prefisso `whatsapp:` dal numero

### Provider Fallback
✅ **Meta → Twilio Cascade**
- Prova prima Meta (preferito)
- Se Meta non configurato o fallito → Twilio
- Se nessuno configurato → 400

✅ **Auto-Reply Resilience**
- Se AI service fallisce → Log, ma webhook continua (no blocking)
- Stesso fallback Meta→Twilio per invio risposta

### Database
✅ **Async SQLite**
- Tutti i DB access sono `async with aiosqlite.connect()`
- Commit esplicito dopo INSERT

✅ **Template Not Found**
- 404 se template non esiste nel DB

### Configurazione Mancante
⚠️ **VERIFY_TOKEN mancante**
- Log warning, ma webhook verification fallisce (403)

⚠️ **APP_SECRET mancante**
- Signature validation skippata in development
- In production: se manca signature → REJECT 403

### Logging
✅ **Livelli appropriati**
- `logger.info()` per operazioni normali
- `logger.warning()` per fallback e rate limit
- `logger.error()` per errori critici (con `exc_info=True` se exception)

---

## 6. COSE DA TESTARE (per test suite)

### Unit Tests
- [ ] `RateLimiter.check_ip_limit()` - Limite 100 req
- [ ] `RateLimiter.check_phone_limit()` - Limite 10 msg
- [ ] `RateLimiter._cleanup_old_entries()` - Rimuove entry vecchie
- [ ] `verify_webhook_signature()` - HMAC validation (valid + invalid + no secret)

### Integration Tests - Webhook
- [ ] GET `/webhook` - Verification success
- [ ] GET `/webhook` - Verification failure (wrong token)
- [ ] POST `/webhook` - Meta JSON format (text message)
- [ ] POST `/webhook` - Twilio form-data format
- [ ] POST `/webhook` - Invalid signature → 403
- [ ] POST `/webhook` - No signature in production → 403
- [ ] POST `/webhook` - Rate limit IP exceeded → 429
- [ ] POST `/webhook` - Rate limit phone exceeded → 429
- [ ] POST `/webhook` - Media types (image, document, audio, video)
- [ ] POST `/webhook` - Auto-reply AI triggered

### Integration Tests - Send
- [ ] POST `/send` - Meta success
- [ ] POST `/send` - Meta fallback to Twilio
- [ ] POST `/send` - No provider configured → 400
- [ ] POST `/send-template` - Template found
- [ ] POST `/send-template` - Template not found → 404
- [ ] POST `/send-template` - Variable substitution

### Integration Tests - Inbox
- [ ] GET `/messages/{booking_id}` - Return messages
- [ ] GET `/inbox` - All messages
- [ ] GET `/inbox?unread=true` - Only unread
- [ ] GET `/inbox?limit=10` - Limit applied
- [ ] PUT `/messages/{id}/read` - Mark as read

### E2E Tests
- [ ] Webhook → Auto-reply → DB save → Provider cascade

---

## 7. CHANGELOG HIGHLIGHTS

**v2.4.0 (2026-01-14)**: Rate limiting in-memory (100 IP, 10 phone)
**v2.3.0 (2026-01-06)**: Twilio fallback support
**v2.2.0 (2026-01-05)**: REFACTOR - DRY auto-reply (eliminata duplicazione)
**v2.1.1 (2026-01-05)**: SECURITY FIX - Attivata signature validation
**v2.1.0 (2026-01-04)**: Auto-reply AI nel webhook
**v2.0.3 (2026-01-03)**: Fix webhook verification (PlainTextResponse)
**v2.0.2 (2026-01-02)**: Signature validation HMAC SHA256

---

## NOTE PER TESTING

### Mock Richiesti
- `WhatsAppAI.should_auto_reply()` → (bool, str)
- `MetaWhatsAppService.send_text()` → dict
- `TwilioWhatsAppService.send_text()` → dict
- `aiosqlite.connect()` → Mock DB

### Fixture Payload
- Meta webhook JSON (text, image, video)
- Twilio form-data
- Signature valida/invalida

### Environment Variables
```bash
META_WHATSAPP_VERIFY_TOKEN=test_token
META_WHATSAPP_APP_SECRET=test_secret
DATABASE_PATH=:memory:
ENVIRONMENT=production
```

---

**STATUS**: ✅ ANALISI COMPLETA
**READY FOR**: Test suite creation (cervella-tester)
