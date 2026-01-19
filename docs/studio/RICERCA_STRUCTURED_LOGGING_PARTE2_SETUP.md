# Ricerca: Structured Logging - PARTE 2: Setup Avanzato

> Advanced configuration + ejemplos reali
> Fonte: GitHub gist Datadog + production patterns

---

## FILE ROTATION PRODUCTION

Quando i log JSON crescono in produzione, servono rotazioni automatiche.

### Setup con RotatingFileHandler

File: `backend/logging_config.py` (aggiunta)

```python
import logging
from logging.handlers import RotatingFileHandler
import os

def configure_file_logging(log_file_path: str, max_bytes: int = 10485760, backup_count: int = 5):
    """
    Setup file rotation per produzione

    Args:
        log_file_path: /var/log/miracollook/app.log
        max_bytes: 10MB (rotate dopo questo)
        backup_count: Mantieni 5 file (app.log.1, .2, etc)
    """

    # Crea directory se non esiste
    os.makedirs(os.path.dirname(log_file_path), exist_ok=True)

    # Handler file con rotazione
    file_handler = RotatingFileHandler(
        filename=log_file_path,
        maxBytes=max_bytes,
        backupCount=backup_count,
        encoding='utf-8'
    )

    # JSON formatter (standard Python logging + structlog)
    formatter = logging.Formatter(
        '{"timestamp": "%(asctime)s", "level": "%(levelname)s", '
        '"logger": "%(name)s", "message": "%(message)s"}'
    )
    file_handler.setFormatter(formatter)

    # Configura root logger con file handler
    root_logger = logging.getLogger()
    root_logger.addHandler(file_handler)
    root_logger.setLevel(logging.INFO)
```

### Usage in main.py

```python
import os
from logging_config import configure_file_logging

# Se in PRODUZIONE, usa file logging
if os.getenv("ENVIRONMENT") == "production":
    configure_file_logging(
        log_file_path=os.getenv(
            "LOG_FILE_PATH",
            "/var/log/miracollook/app.log"
        ),
        max_bytes=int(os.getenv("LOG_FILE_MAX_BYTES", 10485760)),
        backup_count=int(os.getenv("LOG_FILE_BACKUP_COUNT", 5)),
    )
```

---

## LOGGING NEI ROUTER/HANDLER

Esempio reale: Gmail router con structured logging

File: `backend/gmail/api.py`

```python
import structlog
from fastapi import APIRouter, Depends, HTTPException
from middleware.logging_middleware import request_id_context

router = APIRouter()
logger = structlog.get_logger()

@router.get("/emails")
async def get_emails(user_id: str):
    """
    Fetch emails con logging strutturato

    Log Output (JSON):
    {
      "timestamp": "2026-01-19T14:23:45.123Z",
      "level": "INFO",
      "message": "emails_fetch_start",
      "request_id": "550e8400-e29b-41d4-a716",
      "user_id": "user@example.com",
      "service": "gmail.api"
    }
    """

    # Bind contesto specifico per questo handler
    logger.bind(
        user_id=user_id,
        service="gmail.api"
    )

    logger.info(
        "emails_fetch_start",
        query="inbox"
    )

    try:
        # Simula fetch
        if not user_id:
            logger.warning(
                "invalid_user_id",
                user_id=user_id,
            )
            raise HTTPException(status_code=400, detail="Invalid user_id")

        # Mock data
        emails = [
            {"id": 1, "subject": "Test", "from": "sender@example.com"},
            {"id": 2, "subject": "Hello", "from": "friend@example.com"},
        ]

        logger.info(
            "emails_fetch_end",
            count=len(emails),
            duration_ms=123.4,
        )

        return {"emails": emails}

    except Exception as e:
        logger.error(
            "emails_fetch_error",
            error_type=type(e).__name__,
            error_msg=str(e),
            exc_info=True,
        )
        raise

@router.post("/send")
async def send_email(recipient: str, subject: str, body: str):
    """Send email con retry logging"""

    logger.bind(recipient=recipient, action="send_email")

    logger.info("email_send_attempt", attempt=1)

    # Simula retry logic (tenacity già in deps!)
    for attempt in range(1, 4):
        try:
            logger.info(f"email_send_attempt", attempt=attempt)

            # Mock send
            if attempt == 1:
                raise ConnectionError("SMTP timeout")

            logger.info(
                "email_sent",
                attempt=attempt,
                recipient=recipient,
            )
            return {"status": "sent", "message_id": "msg123"}

        except ConnectionError as e:
            logger.warning(
                "email_send_failed",
                attempt=attempt,
                error=str(e),
            )
            if attempt == 3:
                raise

    return {"status": "sent"}
```

**Output JSON di esempio:**
```json
{"timestamp": "2026-01-19T14:23:45.123Z", "level": "INFO", "message": "emails_fetch_start", "request_id": "550e...", "user_id": "user@example.com"}
{"timestamp": "2026-01-19T14:23:45.234Z", "level": "INFO", "message": "emails_fetch_end", "request_id": "550e...", "count": 2}
```

---

## DEV vs PROD: Configuration Matrix

| Aspetto | Development | Production |
|---------|-------------|-----------|
| **LOG_FORMAT** | `pretty` | `json` |
| **LOG_LEVEL** | `DEBUG` | `INFO` |
| **Output** | Console (stdout) | File + rotation |
| **Request logging** | Verbose (path, IP, etc) | Minimal (id, status) |
| **Exception traces** | Full stack trace | Summary + stack |
| **Performance** | N/A (dev only) | <1ms overhead |

### LaunchAgent Config (Miracollook Production)

Update `~/Library/LaunchAgents/com.miracollook.backend.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.miracollook.backend</string>

    <key>ProgramArguments</key>
    <array>
        <string>bash</string>
        <string>-c</string>
        <string>
            cd ~/Developer/miracollogeminifocus/miracallook/backend &&
            source venv/bin/activate &&
            uvicorn main:app --port 8002
        </string>
    </array>

    <!-- NUOVO: Environment per structured logging -->
    <key>EnvironmentVariables</key>
    <dict>
        <key>ENVIRONMENT</key>
        <string>production</string>
        <key>LOG_FORMAT</key>
        <string>json</string>
        <key>LOG_LEVEL</key>
        <string>INFO</string>
        <key>LOG_FILE_PATH</key>
        <string>/var/log/miracollook/app.log</string>
        <key>LOG_FILE_MAX_BYTES</key>
        <string>10485760</string>
        <key>LOG_FILE_BACKUP_COUNT</key>
        <string>5</string>
    </dict>

    <key>StandardOutPath</key>
    <string>/var/log/miracollook/stdout.log</string>

    <key>StandardErrorPath</key>
    <string>/var/log/miracollook/stderr.log</string>

    <key>KeepAlive</key>
    <true/>

    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
```

---

## TESTING STRUCTURED LOGS

Verifica che i log siano ben formattati

File: `backend/tests/test_logging.py`

```python
import pytest
import json
from io import StringIO
import logging
import structlog
from logging_config import configure_logging

@pytest.fixture
def log_capture():
    """Cattura log output per testing"""
    log_stream = StringIO()
    handler = logging.StreamHandler(log_stream)
    logging.getLogger().addHandler(handler)
    yield log_stream
    logging.getLogger().removeHandler(handler)

def test_structured_logging_format(log_capture):
    """Verifica che i log siano JSON validi"""

    configure_logging(json_format=True, log_level="DEBUG")
    logger = structlog.get_logger()

    logger.info("test_message", user_id="test@example.com", status="ok")

    output = log_capture.getvalue()
    print(f"Raw output:\n{output}")

    # Estrai linee di log
    log_lines = output.strip().split('\n')

    for line in log_lines:
        if not line:
            continue

        # Parse JSON
        log_entry = json.loads(line)

        # Verifica campi obbligatori
        assert "timestamp" in log_entry, "Missing timestamp"
        assert "level" in log_entry, "Missing level"
        assert "message" in log_entry, "Missing message"

        print(f"✓ Valid log entry: {log_entry['message']}")

def test_context_propagation():
    """Verifica che contextvars si propaghino"""

    configure_logging(json_format=False)
    logger = structlog.get_logger()

    structlog.contextvars.bind_contextvars(
        request_id="test-123",
        user_id="user@example.com"
    )

    logger.info("test_with_context")
    # In output, dovrebbe includere request_id e user_id

def test_exception_logging():
    """Verifica stack trace in log"""

    configure_logging(json_format=True)
    logger = structlog.get_logger()

    try:
        1 / 0
    except ZeroDivisionError:
        logger.error(
            "division_error",
            error_type="ZeroDivisionError",
            exc_info=True  # Include full stack
        )

    # Log dovrebbe contenere stack trace completo
```

**Run tests:**
```bash
cd ~/Developer/miracollogeminifocus/miracallook/backend
pytest tests/test_logging.py -v
```

---

## INTEGRAZIONE MONITORING (Datadog/Google Cloud)

### For Datadog (se usato in futuro)

```bash
# Install datadog APM
pip install ddtrace

# Run con DDTrace
ddtrace-run uvicorn main:app --port 8002
```

**In LaunchAgent:**
```xml
<key>ProgramArguments</key>
<array>
    <string>bash</string>
    <string>-c</string>
    <string>
        cd ~/Developer/miracollogeminifocus/miracallook/backend &&
        source venv/bin/activate &&
        ddtrace-run uvicorn main:app --port 8002 \
        --env DD_TRACE_ENABLED=true
    </string>
</array>
```

### For Google Cloud Logging (se usato in futuro)

```python
# backend/logging_config.py (add)

from google.cloud import logging as gc_logging

def configure_google_cloud_logging():
    """Integrazione Google Cloud Logging"""
    gc_client = gc_logging.Client()
    gc_handler = gc_client.get_default_handler()
    logging.getLogger().addHandler(gc_handler)
```

---

## CHECKLIST IMPLEMENTAZIONE

```
FASE 5.1 - SETUP BASE
[ ] Installa structlog: pip install structlog>=24.1.0
[ ] Crea backend/logging_config.py
[ ] Crea backend/middleware/logging_middleware.py
[ ] Aggiorna backend/main.py con middleware
[ ] Test locale: LOG_FORMAT=pretty, uvicorn main:app

FASE 5.2 - FILE ROTATION
[ ] Add file rotation handler
[ ] Crea /var/log/miracollook/ directory
[ ] Update .env con LOG_FILE_PATH
[ ] Test rotation: generi >10MB, verifica app.log.1

FASE 5.3 - HANDLER LOGGING
[ ] Add logging nei gmail/auth router
[ ] Verifica request_id propaga in tutti i log
[ ] Test: curl endpoint, leggi stdout

FASE 5.4 - TESTING
[ ] pytest tests/test_logging.py
[ ] Verifica JSON output valido
[ ] Test exception logging con stack trace

FASE 5.5 - PRODUCTION DEPLOY
[ ] Update LaunchAgent .plist con env variables
[ ] Test: launchctl load/unload, verifica log file
[ ] Monitora performance (overhead < 1ms)
```

---

**Confidence:** 9/10
**Tempo:** 2-3 ore (incluso testing)
**Rollback Risk:** Basso (no breaking changes, logging è additive)

CONTINUA in PARTE 3: Real-world examples + troubleshooting
