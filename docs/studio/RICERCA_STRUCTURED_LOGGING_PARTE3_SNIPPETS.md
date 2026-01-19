# Ricerca: Structured Logging - PARTE 3: Ready-to-Copy Snippets

> Pronto per l'uso - Copia e incolla negli handler

---

## SNIPPET 1: Config Minimo (Copia in main.py)

```python
# backend/main.py - INIZIO FILE

import os
import logging
import structlog
from logging.handlers import RotatingFileHandler
from fastapi import FastAPI, Request
from fastapi.middleware.base import BaseHTTPMiddleware
import uuid
from contextvars import ContextVar
import time

# ============ LOGGING SETUP ============

request_id_context: ContextVar[str] = ContextVar('request_id', default=None)

class LoggingMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        request_id = request.headers.get("X-Request-ID", str(uuid.uuid4()))
        request_id_context.set(request_id)

        structlog.contextvars.bind_contextvars(
            request_id=request_id,
            method=request.method,
            path=request.url.path,
        )

        logger = structlog.get_logger()
        start = time.perf_counter()

        try:
            response = await call_next(request)
            duration_ms = (time.perf_counter() - start) * 1000
            logger.info("request", status=response.status_code, duration_ms=round(duration_ms, 2))
            return response
        except Exception as e:
            logger.error("request_error", error=str(e), exc_info=True)
            raise

# Configura structlog
structlog.configure(
    processors=[
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.add_log_level,
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        (structlog.dev.ConsoleRenderer()
         if os.getenv("LOG_FORMAT") != "json"
         else structlog.processors.JSONRenderer()),
    ],
    context_class=dict,
    logger_factory=structlog.PrintLoggerFactory(),
    cache_logger_on_first_use=True,
)

logger = structlog.get_logger()

# ============ APP SETUP ============

app = FastAPI(title="Miracollook", version="0.3.0")
app.add_middleware(LoggingMiddleware)

@app.on_event("startup")
async def startup():
    logger.info("startup", log_format=os.getenv("LOG_FORMAT", "pretty"))

# ... rest of app ...
```

**Env richiesto:**
```env
LOG_FORMAT=pretty  # o json
```

---

## SNIPPET 2: Logging nei Router (Copia in handler)

```python
# backend/gmail/api.py o altro router

import structlog
from fastapi import APIRouter, HTTPException

router = APIRouter()
logger = structlog.get_logger()

@router.get("/emails")
async def get_emails(user_id: str):
    """Fetch emails con logging"""

    logger.info("emails_fetch_start", user_id=user_id)

    try:
        # Logic here...
        emails = [{"id": 1, "subject": "Test"}]

        logger.info("emails_fetch_success", count=len(emails))
        return {"emails": emails}

    except ValueError as e:
        logger.warning("emails_validation_error", error=str(e))
        raise HTTPException(status_code=400, detail=str(e))

    except Exception as e:
        logger.error("emails_fetch_failed", error=str(e), exc_info=True)
        raise

@router.post("/send-email")
async def send_email(to: str, subject: str, body: str):
    """Send con binding context"""

    # Bind user-specific context
    ctx = structlog.contextvars.ContextVar('email_context')
    ctx.set({
        "recipient": to,
        "subject": subject[:50],  # Truncate for logging
    })

    logger.info("email_send_start")

    try:
        # Mock send
        message_id = "msg_" + str(uuid.uuid4())[:8]

        logger.info("email_sent", message_id=message_id, recipient=to)
        return {"status": "sent", "message_id": message_id}

    except Exception as e:
        logger.error("email_send_failed", error=str(e))
        raise
```

---

## SNIPPET 3: Error Logging con Stack Trace

```python
# Ovunque nel codice

try:
    # Something risky
    result = risky_function()

except ValueError as e:
    # EXPECTED ERROR - log warning
    logger.warning(
        "validation_error",
        error_type="ValueError",
        error_msg=str(e),
        input_value=some_value,
    )
    raise HTTPException(status_code=400, detail=str(e))

except Exception as e:
    # UNEXPECTED ERROR - log full stack trace
    logger.error(
        "unexpected_error",
        error_type=type(e).__name__,
        error_msg=str(e),
        exc_info=True,  # <-- Include full stack trace
    )
    raise HTTPException(status_code=500, detail="Internal error")
```

**Output JSON con exc_info=True:**
```json
{
  "timestamp": "2026-01-19T14:23:45.123Z",
  "level": "ERROR",
  "message": "unexpected_error",
  "error_type": "ZeroDivisionError",
  "error_msg": "division by zero",
  "exc_info": "Traceback (most recent call last):\n  File ...\nZeroDivisionError: division by zero",
  "request_id": "550e8400-e29b-41d4-a716"
}
```

---

## SNIPPET 4: Database Query Logging

```python
# backend/db/query.py o simile

import structlog

logger = structlog.get_logger()

async def query_user(user_id: str):
    """Query con logging"""

    logger.info("db_query_start", operation="select", table="users")

    try:
        # Simula query
        start = time.perf_counter()
        user = {"id": user_id, "email": "test@example.com"}
        duration_ms = (time.perf_counter() - start) * 1000

        logger.info(
            "db_query_end",
            operation="select",
            table="users",
            rows=1,
            duration_ms=round(duration_ms, 2),
        )

        return user

    except Exception as e:
        logger.error("db_query_error", operation="select", error=str(e))
        raise

async def insert_email(user_id: str, subject: str, body: str):
    """Insert con batch info"""

    logger.info(
        "db_insert_start",
        table="emails",
        user_id=user_id,
    )

    try:
        # Insert...
        email_id = 12345

        logger.info(
            "db_insert_success",
            table="emails",
            id=email_id,
            rows_affected=1,
        )

        return email_id

    except Exception as e:
        logger.error("db_insert_failed", table="emails", error=str(e))
        raise
```

---

## SNIPPET 5: Auth Logging (Sensibile!)

```python
# backend/auth/google.py - IMPORTANTE: no PII nei log

import structlog

logger = structlog.get_logger()

@router.post("/login")
async def login(code: str):
    """OAuth login - NO user email in logs!"""

    # Genera tracking ID senza PII
    login_attempt_id = str(uuid.uuid4())[:8]

    logger.info("login_attempt", attempt_id=login_attempt_id)

    try:
        # Exchange code for token
        token_data = await exchange_code(code)

        # Hash email per logging (non salva email in chiaro!)
        email_hash = hashlib.sha256(token_data["email"].encode()).hexdigest()[:8]

        logger.info(
            "login_success",
            attempt_id=login_attempt_id,
            email_hash=email_hash,  # <-- Hashed, not plain!
        )

        return {"token": token_data["access_token"]}

    except Exception as e:
        logger.error(
            "login_failed",
            attempt_id=login_attempt_id,
            error=str(e),
            exc_info=True,
        )
        raise HTTPException(status_code=401, detail="Authentication failed")

@router.post("/logout")
async def logout(token: str):
    """Logout - Minimal logging"""

    logger.info("logout")

    # No email/token in log!
    return {"status": "logged_out"}
```

**REGOLA SECURITY:** Non logga mai:
- ❌ Email in chiaro
- ❌ Token / password
- ❌ API key
- ❌ Credit card numbers

**INVECE:**
- ✅ Hash di email (sha256)
- ✅ Token ID (non il token)
- ✅ Mask sensibili (***@**.com)

---

## SNIPPET 6: Performance Monitoring

```python
# backend/services/gmail_sync.py

import structlog
import time

logger = structlog.get_logger()

async def sync_emails_batch(user_ids: list):
    """Sync emails per batch di utenti - Track performance"""

    logger.info("batch_sync_start", user_count=len(user_ids))

    batch_start = time.perf_counter()
    success_count = 0
    error_count = 0

    for user_id in user_ids:
        try:
            user_start = time.perf_counter()

            # Sync per user
            emails_count = await sync_user_emails(user_id)

            user_duration_ms = (time.perf_counter() - user_start) * 1000

            logger.info(
                "batch_item_success",
                user_id=user_id,
                emails_synced=emails_count,
                duration_ms=round(user_duration_ms, 2),
            )

            success_count += 1

        except Exception as e:
            error_count += 1
            logger.warning("batch_item_failed", user_id=user_id, error=str(e))

    batch_duration_ms = (time.perf_counter() - batch_start) * 1000

    logger.info(
        "batch_sync_end",
        total_users=len(user_ids),
        successful=success_count,
        failed=error_count,
        total_duration_ms=round(batch_duration_ms, 2),
        avg_per_user_ms=round(batch_duration_ms / len(user_ids), 2),
    )
```

**Output (beautiful for monitoring):**
```json
{"timestamp": "...", "level": "INFO", "message": "batch_sync_start", "user_count": 1000}
{"timestamp": "...", "level": "INFO", "message": "batch_item_success", "user_id": "...", "emails_synced": 45, "duration_ms": 234.5}
...
{"timestamp": "...", "level": "INFO", "message": "batch_sync_end", "total_users": 1000, "successful": 998, "failed": 2, "total_duration_ms": 234567.8, "avg_per_user_ms": 234.6}
```

---

## SNIPPET 7: File Rotation Setup (Production)

```python
# backend/logging_config_prod.py

import logging
from logging.handlers import RotatingFileHandler
import os

def setup_file_rotation(
    log_file_path: str = "/var/log/miracollook/app.log",
    max_bytes: int = 10485760,  # 10MB
    backup_count: int = 5,
):
    """Setup file rotation per produzione"""

    os.makedirs(os.path.dirname(log_file_path), exist_ok=True)

    handler = RotatingFileHandler(
        filename=log_file_path,
        maxBytes=max_bytes,
        backupCount=backup_count,
        encoding='utf-8',
    )

    formatter = logging.Formatter(
        '%(message)s'  # structlog handles formatting
    )
    handler.setFormatter(formatter)

    logging.getLogger().addHandler(handler)
    logging.getLogger().setLevel(logging.INFO)

# In main.py:
if os.getenv("ENVIRONMENT") == "production":
    from logging_config_prod import setup_file_rotation
    setup_file_rotation()
```

**Monitor log files:**
```bash
# Watch in real-time
tail -f /var/log/miracollook/app.log | jq .

# Check rotation
ls -lh /var/log/miracollook/app.log*

# Count logs
wc -l /var/log/miracollook/app.log*
```

---

## SNIPPET 8: Custom Context Manager per Scope

```python
# backend/utils/logging_scope.py

import structlog
from contextlib import contextmanager

@contextmanager
def log_scope(operation: str, **context):
    """
    Context manager per tracciare operazioni

    Usage:
        with log_scope("email_sync", user_id="user@example.com"):
            # Tutti i log avranno operation="email_sync", user_id="user@example.com"
    """

    logger = structlog.get_logger()

    logger.info(f"{operation}_start", **context)

    try:
        yield

    except Exception as e:
        logger.error(f"{operation}_error", error=str(e), **context, exc_info=True)
        raise

    finally:
        logger.info(f"{operation}_end", **context)

# Usage in handler:
from utils.logging_scope import log_scope

@router.post("/sync")
async def sync_emails(user_id: str):
    with log_scope("email_sync", user_id=user_id):
        # All logs here have user_id context
        emails = await fetch_emails(user_id)
        # Log automatically appends user_id

    return {"synced": len(emails)}
```

---

## FULL MINIMAL EXAMPLE (Copia tutto)

**File: `backend/logging_setup.py`**
```python
import os
import structlog

def init_logging():
    log_format = os.getenv("LOG_FORMAT", "pretty")

    structlog.configure(
        processors=[
            structlog.processors.TimeStamper(fmt="iso"),
            structlog.processors.add_log_level,
            structlog.processors.StackInfoRenderer(),
            structlog.processors.format_exc_info,
            (structlog.dev.ConsoleRenderer()
             if log_format != "json"
             else structlog.processors.JSONRenderer()),
        ],
        context_class=dict,
        logger_factory=structlog.PrintLoggerFactory(),
        cache_logger_on_first_use=True,
    )

# In main.py:
from logging_setup import init_logging
init_logging()
logger = structlog.get_logger()
```

---

## TROUBLESHOOTING

| Problema | Soluzione |
|----------|-----------|
| Log non appare | Verifica LOG_LEVEL env var |
| Non è JSON | Verifica LOG_FORMAT=json |
| Request_id è None | Middleware deve essere FIRST (outermost) |
| File growing troppo | Verifica rotation (app.log.1 creato?) |
| Performance lenta | Usa async logging o riduci verbosity |

---

**PRONTO PER L'IMPLEMENTAZIONE!**

Copia i snippet nei file appropriati.
Test locale: `LOG_FORMAT=pretty uvicorn main:app --reload`
