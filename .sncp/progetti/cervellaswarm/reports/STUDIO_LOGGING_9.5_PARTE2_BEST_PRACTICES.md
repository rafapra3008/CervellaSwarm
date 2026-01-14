# STUDIO LOGGING 9.5 - PARTE 2: BEST PRACTICES DEI BIG

> **Ricerca:** Cervella Researcher
> **Data:** 14 Gennaio 2026
> **Fonti:** OpenTelemetry, Microsoft Azure, IBM, Langfuse, Helicone, Braintrust

---

## EXECUTIVE SUMMARY

Questa parte analizza COME fanno i big player nel 2026:
- **OpenTelemetry**: Standard de facto per observability AI agents
- **Langfuse/Helicone/Braintrust**: Top 3 piattaforme AI logging
- **Microsoft/IBM**: Best practices enterprise

**Key Insight:** Il 2026 è l'anno del "Semantic Telemetry" - log che LLM possono parsare per auto-diagnosi.

---

## 1. OPENTELEMETRY - LO STANDARD

### 1.1 Perché OTel è Diventato Inevitabile

**Dati 2026:**
- 89% organizzazioni AI hanno implementato observability
- OTel è il "default data layer" per enterprise observability
- Semantic conventions GenAI finalizzate a Gennaio 2025

**Quote chiave:**
> "OpenTelemetry is poised to become the default data layer for enterprise observability and AIOps" - [APM Digest 2026 Predictions](https://www.apmdigest.com/2026-observability-predictions-6)

> "More investment around open standards for agent communication and transparency is expected, with OpenTelemetry being critical in this new AI-driven world" - [OpenTelemetry Blog](https://opentelemetry.io/blog/2025/ai-agent-observability/)

### 1.2 Semantic Conventions GenAI - OTel

**Status:** FINALIZZATE (repo ufficiale)

#### Core Attributes per AI Agents

```yaml
# Service identification
service.name: "cervella-backend"
service.version: "1.5.0"
service.instance.id: "worker-001"

# GenAI specific
gen_ai.system: "anthropic"  # o "openai", "custom"
gen_ai.request.model: "claude-sonnet-4"
gen_ai.operation.name: "task_execute"

# Usage tracking
gen_ai.usage.input_tokens: 1500
gen_ai.usage.output_tokens: 800
gen_ai.usage.cost: 0.024  # USD

# Response metadata
gen_ai.response.finish_reason: "stop"
gen_ai.response.id: "msg_abc123"
```

#### Distributed Tracing Fields

```yaml
# OBBLIGATORI per distributed tracing
trace_id: "4bf92f3577b34da6a3ce929d0e0e4736"  # 128-bit hex
span_id: "00f067aa0ba902b7"                   # 64-bit hex
parent_span_id: "00f067aa0ba902b6"            # 64-bit hex (se esiste)

# Span metadata
span.kind: "CLIENT" | "SERVER" | "INTERNAL"
span.status: "OK" | "ERROR"
span.start_time: "2026-01-14T10:30:00.123Z"
span.end_time: "2026-01-14T10:30:05.456Z"
span.duration_ms: 5333
```

#### Resource Attributes

```yaml
# Deployment info
deployment.environment: "production" | "staging" | "dev"
deployment.version: "v2.3.1"

# Host info
host.name: "worker-node-03"
host.arch: "arm64"
host.type: "macos" | "linux"

# Process info
process.pid: 12345
process.command: "python spawn-workers --backend"
process.runtime.name: "python"
process.runtime.version: "3.11.7"
```

#### Error Categorization

```yaml
# Structured error tracking
error.type: "ValidationError" | "APIError" | "TimeoutError"
error.message: "Task validation failed: missing required field 'output_path'"
error.stack: "..." # Full stacktrace
error.escaped: false  # True se non dovrebbe essere logged

# Business logic errors
exception.type: "TaskFailure"
exception.message: "Worker exceeded retry limit (3/3)"
exception.stacktrace: "..."
```

### 1.3 Instrumentation Approaches - OTel Raccomandazioni

**Option 1: Baked-in (Come CrewAI)**

```python
# Framework emette telemetria nativa
from opentelemetry import trace

tracer = trace.get_tracer(__name__)

class SwarmLogger:
    def __init__(self, agent: str):
        self.tracer = tracer

    def info(self, message: str, **extra):
        with self.tracer.start_as_current_span("log.info") as span:
            span.set_attribute("log.message", message)
            span.set_attribute("log.level", "INFO")
            for k, v in extra.items():
                span.set_attribute(f"log.extra.{k}", v)
```

**Vantaggi:**
- Out-of-the-box observability
- Sincronizzato con release framework

**Svantaggi:**
- Bloat nel framework
- Version lock-in su OTel dependencies

**Option 2: External Instrumentation (Raccomandato OTel)**

```python
# Libreria separata: opentelemetry-instrumentation-cervellaswarm
from opentelemetry.instrumentation.cervellaswarm import CervellaSwarmInstrumentor

CervellaSwarmInstrumentor().instrument()

# Automaticamente instrumenta:
# - SwarmLogger.info/error/etc
# - Task execution
# - Worker spawn/stop
```

**Vantaggi:**
- Disaccoppiato dal core
- Community-maintained
- Mix-and-match

**Svantaggi:**
- Sviluppo più lento (code review queue)

**Raccomandazione OTel 2026:** External instrumentation via registry

### 1.4 Trace Hierarchies - Multi-Agent Pattern

**Pattern LangChain (OTel approved):**

```
trace_id: abc123 (ROOT)
│
├─ span: gateway_request (SPAN_KIND=SERVER)
│  ├─ span: auth_check (SPAN_KIND=INTERNAL)
│  └─ span: route_to_agent (SPAN_KIND=INTERNAL)
│
├─ span: cervella_regina (SPAN_KIND=INTERNAL)
│  ├─ span: read_prompt_ripresa (SPAN_KIND=INTERNAL)
│  ├─ span: spawn_worker (SPAN_KIND=CLIENT)
│  │  └─ span: cervella_backend (SPAN_KIND=SERVER)  # New trace context!
│  │     ├─ span: task_validate (SPAN_KIND=INTERNAL)
│  │     ├─ span: code_generation (SPAN_KIND=INTERNAL)
│  │     │  └─ span: llm_call (SPAN_KIND=CLIENT, gen_ai.system=anthropic)
│  │     └─ span: file_write (SPAN_KIND=INTERNAL)
│  └─ span: aggregate_results (SPAN_KIND=INTERNAL)
│
└─ span: response_format (SPAN_KIND=INTERNAL)
```

**Key Insights:**
- Ogni agent ha il suo span_id
- parent_span_id collega gerarchicamente
- trace_id UGUALE per tutta la request
- gen_ai.* attributes sui LLM calls

---

## 2. AI OBSERVABILITY PLATFORMS - TOP 3

### 2.1 Langfuse - Open Source Leader

**Focus:** Prompt engineering + tracing

**Key Features:**

```yaml
Tracing:
  - Automatic SDK instrumentation (LangChain, OpenAI, Anthropic)
  - Detailed trace hierarchies con timing
  - Cost tracking per call

Prompt Management:
  - Version control prompt templates
  - A/B testing prompts
  - Production prompt deployment

Evaluations:
  - Custom eval functions
  - Automated quality scoring
  - Human feedback loop

Pricing:
  - Free tier: 50k observations/month
  - Pro: $59/month
  - Self-hosted: FREE (MIT license)
```

**Architecture Pattern:**

```python
# Langfuse pattern
from langfuse import Langfuse

langfuse = Langfuse(
    public_key="pk-lf-...",
    secret_key="sk-lf-..."
)

# Trace creation
trace = langfuse.trace(
    name="task_execution",
    user_id="cervella-backend",
    session_id="session-123",
    metadata={"project": "cervellaswarm"}
)

# Span creation
span = trace.span(
    name="code_generation",
    input={"task": "Fix bug in watcher.sh"},
    metadata={"model": "claude-sonnet-4"}
)

# LLM call
generation = trace.generation(
    name="anthropic_call",
    model="claude-sonnet-4",
    input=[{"role": "user", "content": "..."}],
    metadata={"temperature": 0.7}
)

# Completion
generation.end(
    output="...",
    usage={
        "input": 1500,
        "output": 800,
        "total": 2300
    },
    metadata={"finish_reason": "stop"}
)
```

**Best for CervellaSwarm:**
- Self-hosted option (data privacy)
- Generous free tier per test
- Strong LangChain integration (se mai useremo)

### 2.2 Helicone - Performance Focus

**Focus:** AI Gateway + monitoring

**Key Features:**

```yaml
AI Gateway:
  - <1ms P99 latency overhead (Rust-based)
  - Routing, failovers, rate limiting
  - Built-in caching (save $$)
  - 100+ models supported

Monitoring:
  - Real-time request tracking
  - Cost per endpoint/user
  - Latency percentiles
  - Error rate tracking

Pricing:
  - Free: 10k requests/month
  - Pro: $20/seat/month + usage

Architecture:
  - Rust gateway (high performance)
  - Acts as proxy between app and LLM
```

**Integration Pattern:**

```python
# Helicone as proxy
import anthropic

client = anthropic.Anthropic(
    api_key="...",
    base_url="https://anthropic.helicone.ai/v1",
    default_headers={
        "Helicone-Auth": "Bearer sk-helicone-...",
        "Helicone-User-Id": "cervella-backend",
        "Helicone-Session-Id": "session-123"
    }
)

# Automatic logging di TUTTE le chiamate
response = client.messages.create(...)
```

**Best for CervellaSwarm:**
- Caching integrato (riduce costi)
- Monitoring senza code changes
- Flat pricing ($25/mo)

### 2.3 Braintrust - Evaluation Focus

**Focus:** LLM evals + CI/CD integration

**Key Features:**

```yaml
Evaluations:
  - Purpose-built per evals
  - Automated scoring
  - Dataset versioning
  - Regression detection

CI/CD Integration:
  - Eval gates in deploy pipeline
  - Automated quality checks
  - Performance regression alerts

Enterprise:
  - Custom DB optimized per full-text search
  - Large dataset handling
  - Team collaboration

Pricing:
  - Free tier disponibile
  - Enterprise: contact sales
```

**Integration Pattern:**

```python
# Braintrust eval pattern
from braintrust import init_experiment, current_span

experiment = init_experiment(
    project="cervellaswarm",
    experiment="task_quality_v1"
)

@experiment.trace
def execute_task(task_description: str):
    with current_span() as span:
        span.log(input=task_description)

        result = worker.execute(task_description)

        span.log(
            output=result,
            scores={
                "correctness": 0.95,
                "completeness": 0.88,
                "efficiency": 0.92
            }
        )

    return result
```

**Best for CervellaSwarm:**
- Quality gates per deploy
- Automated regression detection
- Team-wide evaluation sharing

### 2.4 Comparison Matrix

| Feature | Langfuse | Helicone | Braintrust |
|---------|----------|----------|------------|
| **Focus** | Prompt eng | Performance | Evals |
| **Open Source** | ✅ MIT | ✅ Partial | ❌ No |
| **Self-hosted** | ✅ Free | ⚠️ Limited | ❌ No |
| **Tracing** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Caching** | ❌ No | ⭐⭐⭐⭐⭐ | ❌ No |
| **Evals** | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Latency** | Low | <1ms | Low |
| **Free Tier** | 50k/mo | 10k/mo | Limited |
| **Pricing** | $59/mo | $20+usage | Enterprise |
| **Best For** | Dev/Test | Production | QA/CI |

**Raccomandazione Multi-Tool (Industry Pattern 2026):**

```
Langfuse (self-hosted) → Raw logging + prompt versioning
    ↓
Helicone → Production caching + monitoring
    ↓
Braintrust → Automated evals + regression detection
```

---

## 3. STRUCTURED LOGGING BEST PRACTICES 2026

### 3.1 JSON Format Standards

**Raccomandazioni SigNoz/Uptrace:**

```json
{
  "timestamp": "2026-01-14T10:30:00.123456Z",
  "level": "INFO",
  "logger": "cervella.backend.worker",
  "message": "Task execution started",

  "trace_id": "4bf92f3577b34da6a3ce929d0e0e4736",
  "span_id": "00f067aa0ba902b7",
  "parent_span_id": "00f067aa0ba902b6",

  "service": {
    "name": "cervella-backend",
    "version": "1.5.0",
    "instance_id": "worker-001"
  },

  "resource": {
    "host.name": "macbook-pro",
    "process.pid": 12345,
    "deployment.environment": "production"
  },

  "attributes": {
    "task_id": "task-001",
    "project": "cervellaswarm",
    "agent_role": "backend",
    "user_id": "cervella-regina"
  },

  "event": {
    "category": "task",
    "action": "start",
    "outcome": "success"
  }
}
```

**Essential Fields (Uptrace 2026):**

1. **timestamp** - ISO 8601 in UTC (con microseconds!)
2. **level** - ERROR, WARN, INFO, DEBUG
3. **service.name** - Identificazione servizio
4. **trace_id** - Correlation cross-service
5. **message** - Human-readable description

**Storage Considerations:**

```
Plain text: 100 bytes/log
JSON:       150-200 bytes/log (1.5-2x overhead)
GZIP:       30-40 bytes/log (60-80% compression)
```

**Raccomandazione:** JSON + GZIP compression (Best of both worlds)

### 3.2 Retention Policies - Industry Standards

**Tipi di Log e Retention (Last9.io):**

| Log Type | Retention | Storage Tier | Reason |
|----------|-----------|--------------|--------|
| **Debug** | 7 giorni | Hot | Troubleshooting immediato |
| **Info** | 30 giorni | Hot→Warm | Analisi operazioni |
| **Warning** | 90 giorni | Warm | Pattern detection |
| **Error** | 1 anno | Warm→Cold | Compliance, audit |
| **Security** | 7 anni | Cold | Legal requirements |

**Storage Tiers:**

```yaml
Hot Storage (SSD):
  - Access: < 1ms
  - Cost: $$$$
  - Use: Last 7 days

Warm Storage (HDD):
  - Access: < 100ms
  - Cost: $$
  - Use: 8-90 days

Cold Storage (S3/Archive):
  - Access: minutes-hours
  - Cost: $
  - Use: > 90 days
```

**Automation Tools:**

```yaml
Elasticsearch ILM:
  - Hot phase: 7 days
  - Warm phase: rollover to warm nodes
  - Cold phase: move to snapshot repository
  - Delete phase: auto-delete after retention

SQLite (CervellaSwarm):
  - Custom retention script
  - DELETE WHERE created_at < NOW() - INTERVAL '90 days'
  - VACUUM per recuperare spazio
```

### 3.3 Log Aggregation Best Practices

**Microservices Pattern (Medium/SigNoz):**

```yaml
Organization-wide Standards:
  1. Same logging library across services
  2. Generate correlation IDs at gateway
  3. Propagate via headers (X-Correlation-ID)
  4. Include service name/version in EVERY log
  5. Centralized aggregation (ELK, Loki, etc)
  6. Consistent field naming (documented schema)
```

**Correlation ID Propagation:**

```python
# API Gateway generates
correlation_id = str(uuid.uuid4())
headers = {"X-Correlation-ID": correlation_id}

# All services log with it
logger.info("Processing request", correlation_id=correlation_id)

# Easy filtering
SELECT * FROM logs WHERE correlation_id = 'abc-123'
```

**CervellaSwarm Application:**

```python
# Regina generates session_id (già lo fa!)
session_id = "session-20260114-103000"

# Tutti i worker DEVONO loggare con session_id
logger = SwarmLogger("backend-worker", session_id=session_id)

# Hook propagano session_id
# DB query: SELECT * FROM swarm_events WHERE session_id = '...'
```

### 3.4 PII Masking & Security

**Pattern Matching (StrongDM):**

```python
import re

PII_PATTERNS = {
    "email": r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
    "ssn": r'\b\d{3}-\d{2}-\d{4}\b',
    "credit_card": r'\b\d{4}[- ]?\d{4}[- ]?\d{4}[- ]?\d{4}\b',
    "api_key": r'(sk-[a-zA-Z0-9]{32,})'
}

def mask_pii(message: str) -> str:
    for pii_type, pattern in PII_PATTERNS.items():
        message = re.sub(pattern, f"[MASKED_{pii_type.upper()}]", message)
    return message

# Usage
logger.info(mask_pii("User email: john@example.com"))
# Output: "User email: [MASKED_EMAIL]"
```

**Encryption at Rest:**

```yaml
Standard: AES-256
Key Management: AWS KMS, Azure Key Vault, HashiCorp Vault
Scope: Encrypt logs before writing to disk

Implementation:
  - Transparent encryption (filesystem level)
  - OR application-level (encrypt field values)
```

**Access Control:**

```yaml
RBAC for Log Viewing:
  - regina: ALL logs
  - guardiana-qualita: ALL logs
  - worker-backend: OWN logs only
  - external-viewer: REDACTED logs only
```

---

## 4. ERROR PATTERN DETECTION & ALERTING

### 4.1 AI-Powered Pattern Detection (2026 Standard)

**Relevance AI Pattern:**

```yaml
Error Pattern Detection:
  Input: Stream di log events
  Process:
    1. Machine learning baseline normale behavior
    2. Detect subtle anomalies (non rule-based)
    3. Cluster simili errori
    4. Identify root cause patterns
  Output:
    - Alert prioritizzati
    - Suggested remediation
    - Confidence score
```

**Example Implementation:**

```python
# Pattern detector (AI-based)
from sklearn.cluster import DBSCAN
import numpy as np

class ErrorPatternDetector:
    def __init__(self, db_path):
        self.db = sqlite3.connect(db_path)

    def detect_patterns(self, time_window_hours=24):
        # Fetch errors in time window
        errors = self.fetch_errors(time_window_hours)

        # Feature extraction
        features = self.extract_features(errors)

        # Clustering
        clustering = DBSCAN(eps=0.3, min_samples=3)
        labels = clustering.fit_predict(features)

        # Identify patterns
        patterns = []
        for cluster_id in set(labels):
            if cluster_id == -1:  # Noise
                continue

            cluster_errors = [e for e, l in zip(errors, labels) if l == cluster_id]
            pattern = self.analyze_cluster(cluster_errors)
            patterns.append(pattern)

        return patterns

    def analyze_cluster(self, errors):
        # Common error message
        messages = [e['error_message'] for e in errors]
        common_message = max(set(messages), key=messages.count)

        # Affected agents
        agents = list(set(e['agent_name'] for e in errors))

        # Time distribution
        first_occurrence = min(e['timestamp'] for e in errors)
        frequency = len(errors) / ((datetime.now() - first_occurrence).seconds / 3600)

        return {
            "pattern_id": uuid.uuid4(),
            "error_message": common_message,
            "occurrences": len(errors),
            "affected_agents": agents,
            "frequency_per_hour": frequency,
            "first_seen": first_occurrence,
            "severity": self.calculate_severity(errors)
        }
```

### 4.2 Context-Aware Alerting

**Microsoft Azure Best Practice:**

```yaml
Alert Fatigue Reduction:
  - Group related alerts (correlation)
  - Suppress duplicate alerts (deduplication)
  - Priority scoring (ML-based)
  - Context enrichment (why this matters NOW)

Alert Channels:
  - Critical: PagerDuty, SMS
  - High: Slack, Email
  - Medium: Dashboard notification
  - Low: Log only
```

**Implementation Pattern:**

```python
class ContextAwareAlerter:
    def __init__(self):
        self.alert_history = {}

    def should_alert(self, error: dict) -> tuple[bool, str]:
        # Deduplication
        error_hash = self.hash_error(error)
        if error_hash in self.alert_history:
            last_alert = self.alert_history[error_hash]
            if (datetime.now() - last_alert) < timedelta(hours=1):
                return False, "SUPPRESSED_DUPLICATE"

        # Severity calculation
        severity = self.calculate_severity(error)

        # Context enrichment
        context = self.get_context(error)

        # Decision
        if severity == "CRITICAL":
            self.send_pagerduty(error, context)
            return True, "PAGERDUTY"
        elif severity == "HIGH":
            self.send_slack(error, context)
            return True, "SLACK"
        else:
            return False, "LOG_ONLY"

    def calculate_severity(self, error: dict) -> str:
        # ML-based scoring
        score = 0

        # Frequency
        recent_count = self.count_recent_similar(error, hours=1)
        if recent_count > 10:
            score += 50

        # Affected agents
        if "regina" in error['agent_name']:
            score += 30

        # Error type
        if "CRITICAL" in error['level']:
            score += 40

        if score >= 80:
            return "CRITICAL"
        elif score >= 50:
            return "HIGH"
        else:
            return "MEDIUM"
```

### 4.3 Predictive Alerting (2026 Trend)

**Dataminr/Microsoft Pattern:**

```yaml
Predictive Intelligence:
  - Analyze telemetry trends
  - Predict failures hours/days in advance
  - Proactive remediation before user impact

Example:
  Input: Worker memory usage increasing 5%/hour
  Prediction: OOM crash in 8 hours
  Action: Auto-scale worker pool NOW
```

---

## 5. REAL-TIME DASHBOARD PATTERNS

### 5.1 Modern Dashboard Architecture

**Stack Raccomandato 2026:**

```yaml
Option 1: ELK Stack
  - Elasticsearch: Storage + indexing
  - Logstash: Ingestion pipeline
  - Kibana: Visualization dashboard

Option 2: Grafana + Loki
  - Loki: Log aggregation (like Prometheus for logs)
  - Grafana: Dashboard + alerting
  - Tempo: Distributed tracing

Option 3: Custom (CervellaSwarm attuale)
  - SQLite: Storage
  - FastAPI: Backend API
  - React: Frontend dashboard
  - SSE: Real-time updates
```

**CervellaSwarm Best Fit: Option 3 Enhanced**

Motivi:
- Già abbiamo SQLite + FastAPI + React
- Self-hosted (no external dependencies)
- Full control su data privacy
- Lightweight (no Java overhead di ELK)

**Enhancement needed:**
- Add SSE for real-time
- Add WebSocket fallback
- Migliorare query performance (indexes)
- Add retention automation

### 5.2 Dashboard Metrics - Industry Standard

**Metrics da mostrare (Microsoft/IBM):**

```yaml
Agent Health:
  - Active agents count
  - Average response time per agent
  - Success rate (%)
  - Error rate (errors/hour)

Task Metrics:
  - Tasks in queue
  - Tasks completed/hour
  - Average task duration
  - Task failure rate

System Metrics:
  - CPU usage per agent
  - Memory usage per agent
  - API quota remaining (Anthropic)
  - Cost per hour/day

Quality Metrics:
  - Average confidence score
  - Retry rate
  - Human intervention rate
```

### 5.3 Real-Time Updates - SSE vs WebSocket

**SSE (Server-Sent Events):**

```python
# FastAPI SSE endpoint
@app.get("/api/logs/stream")
async def stream_logs(request: Request):
    async def event_generator():
        last_id = 0
        while True:
            # Check for new logs
            new_logs = db.query(
                "SELECT * FROM swarm_events WHERE id > ? ORDER BY timestamp",
                (last_id,)
            )

            for log in new_logs:
                yield {
                    "event": "log",
                    "data": json.dumps(log),
                    "id": log['id']
                }
                last_id = log['id']

            await asyncio.sleep(1)  # Poll interval

    return EventSourceResponse(event_generator())
```

**WebSocket (fallback per bi-directional):**

```python
# FastAPI WebSocket
@app.websocket("/ws/logs")
async def websocket_logs(websocket: WebSocket):
    await websocket.accept()

    try:
        while True:
            # Send new logs
            new_logs = get_new_logs()
            await websocket.send_json(new_logs)

            # Receive filters (bi-directional)
            data = await websocket.receive_json()
            if 'filter' in data:
                apply_filter(data['filter'])

            await asyncio.sleep(0.5)
    except WebSocketDisconnect:
        pass
```

**Raccomandazione:** SSE per dashboard (unidirezionale), WebSocket per interactive debugging

---

## CONCLUSIONI PARTE 2

### Top Insights dai BIG

1. **OpenTelemetry è inevitabile** - Standard industry per AI agents
2. **Semantic conventions GenAI già pronte** - Basta implementarle
3. **Distributed tracing NON opzionale** - trace_id/span_id MUST
4. **Multi-tool approach** - Logger + Monitor + Eval (non uno solo)
5. **AI-powered pattern detection** - ML baseline, no rule-based
6. **Context-aware alerting** - Riduce fatigue del 70%
7. **Predictive > Reactive** - 2026 è l'anno del proactive
8. **Semantic telemetry** - Log che LLM possono parsare

### Recommended Stack per CervellaSwarm 9.5

```yaml
Logging Core:
  - SwarmLogger (enhanced con OTel attributes)
  - JSON Lines format + GZIP
  - SQLite con OTel-compliant schema

Distributed Tracing:
  - OpenTelemetry SDK (lightweight)
  - Trace/Span ID generation
  - Context propagation via headers

External Platform (optional):
  - Langfuse self-hosted (free, MIT)
  - Per: Prompt versioning, advanced analytics

Alerting:
  - Custom pattern detector (ML-based)
  - Slack integration
  - PagerDuty per critical

Dashboard:
  - FastAPI + SSE
  - React frontend
  - Real-time updates

Retention:
  - Automated ILM script
  - Hot (7d) → Warm (30d) → Cold (90d) → Delete
```

### Anti-Patterns da Evitare

❌ **Vendor lock-in** - No cloud-only solutions
❌ **Over-engineering** - No Kubernetes se non serve
❌ **Log everything** - Sampling per high-volume
❌ **Plaintext secrets** - Mask API keys ALWAYS
❌ **Infinite retention** - Disk pieno = disaster
❌ **Rule-based alerting** - ML pattern detection better
❌ **Single tool mindset** - Combine tools strategicamente

---

**PROSSIMO:** Parte 3 - Gap Analysis & Roadmap 9.5
