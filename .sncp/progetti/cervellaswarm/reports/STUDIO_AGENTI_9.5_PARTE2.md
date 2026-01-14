# STUDIO: Portare le Cervelle da 7.8/10 a 9.5/10 - PARTE 2

**Continua da:** PARTE 1 (Gap Analysis)

---

## PARTE 4: ROADMAP VERSO 9.5

### 4.1 Principi Guida

#### From CrewAI
> "Intelligence deployed where it matters"

**Applicato a noi:**
- Non serve agente per task deterministici
- La Regina rimane backbone deterministico
- Gli agenti operano in "scoped intelligence"

#### From LangChain
> "Low-level control over flow"

**Applicato a noi:**
- Manteniamo controllo esplicito (no black box)
- Data-flow > Control-flow
- Routing esplicito

#### From Azure
> "Right pattern for right problem"

**Applicato a noi:**
- Non un solo pattern (sequential)
- Supporto multi-pattern
- Pattern selection automatica

#### From Microsoft
> "Layered design with clear responsibilities"

**Applicato a noi:**
- Layer separati (Communication, Decision, Execution)
- Ogni layer sostituibile

---

### 4.2 Roadmap in 4 FASI

```
FASE 1: RUOLI CRISTALLINI (1 sprint)
  ↓
FASE 2: COMUNICAZIONE STRUTTURATA (2 sprint)
  ↓
FASE 3: ORCHESTRAZIONE AVANZATA (3 sprint)
  ↓
FASE 4: VALIDAZIONE AUTOMATICA (2 sprint)
```

**Totale:** 8 sprint (~8-12 settimane)

---

### 4.3 FASE 1: Ruoli Cristallini

#### Obiettivo
```
Zero ambiguità nei ruoli.
Ogni task ha UN agente ovvio.
```

#### Task 1.1: Risolvi Overlap Researcher/Scienziata

**DECISIONE:** Rename per chiarezza

```
PRIMA:
- cervella-researcher   (ambiguo)
- cervella-scienziata   (ambiguo)

DOPO:
- cervella-tech-researcher   ("HOW to implement")
- cervella-market-analyst    ("WHY to build, WHO uses it")
```

**File da modificare:**
- `~/.claude/agents/cervella-researcher.md` → rename
- `~/.claude/agents/cervella-scienziata.md` → rename
- `scripts/spawn-workers.sh` → update flags
- `DNA_FAMIGLIA.md` → update docs

**Criteri di Routing (per Regina):**
```python
if question.contains("how", "implement", "library", "technical"):
    → cervella-tech-researcher

if question.contains("why", "competitor", "market", "users", "strategy"):
    → cervella-market-analyst

if ambiguous:
    → ASK Rafa for clarification
```

**Deliverable:** Documento "RUOLI_CHEAT_SHEET.md"

| Domanda | Agente | Esempio |
|---------|--------|---------|
| Come implemento X? | tech-researcher | "Come implemento SSE in FastAPI?" |
| Quale library per X? | tech-researcher | "Migliore lib React per charts?" |
| Perché i competitor fanno X? | market-analyst | "Perché Lodgify usa WhatsApp?" |
| Cosa vogliono gli utenti? | market-analyst | "Feature più richieste PMS?" |

---

#### Task 1.2: Chiarifica Docs vs Marketing

**ATTUALE:**
- docs: Documentazione
- marketing: Marketing, UX strategy

**OVERLAP POTENZIALE:** Entrambe scrivono contenuti.

**SOLUZIONE:**
```
DOCS:
- Target: Developers, technical team
- Output: API docs, guides tecnici, README
- Tone: Tecnico, preciso

MARKETING:
- Target: Users, business stakeholders
- Output: Landing pages, feature descriptions, UX copy
- Tone: Persuasivo, user-friendly
```

**Aggiorna DNA:**
```markdown
cervella-docs:
  "Scrivo documentazione TECNICA per developers"

cervella-marketing:
  "Scrivo contenuti BUSINESS/UX per utenti finali"
```

---

#### Task 1.3: Agent Capabilities Manifest

**Crea:** `.claude/agents/manifests/`

**Per ogni agente, file JSON:**
```json
// cervella-tech-researcher.json
{
  "name": "cervella-tech-researcher",
  "version": "2.0.0",
  "role": "Technical Research Specialist",
  "focus": "HOW to implement technologies",
  "capabilities": [
    "library_research",
    "documentation_analysis",
    "best_practices_discovery",
    "technical_comparison"
  ],
  "tools": ["Read", "Glob", "Grep", "Write", "WebSearch", "WebFetch"],
  "accepts_task_types": [
    "research_technical",
    "library_selection",
    "implementation_guidance"
  ],
  "returns": {
    "format": "research_report_v2",
    "schema": "reports/schemas/research_report_v2.json"
  },
  "best_for": [
    "How do I implement X?",
    "Which library for Y?",
    "Best practices for Z?"
  ],
  "not_for": [
    "Market analysis (use market-analyst)",
    "Competitor strategy (use market-analyst)"
  ]
}
```

**Benefici:**
1. Regina può AUTO-SELECT agente giusto
2. Validazione pre-task (agente può gestire?)
3. Documentazione vivente
4. Versionamento capabilities

**Tool:** Script `validate-agent-manifest.py`
```bash
python scripts/validate-agent-manifest.py cervella-tech-researcher
# Output: ✅ Manifest valid, capabilities match DNA
```

---

#### FASE 1 - Success Criteria

```
✅ Zero domande ambigue su quale agente invocare
✅ Ogni agente ha manifest JSON validato
✅ RUOLI_CHEAT_SHEET usato dalla Regina
✅ Rafa può dire "quale agente per X?" e ottenere risposta chiara
```

**Stima:** 1 sprint (3-5 giorni)

---

### 4.4 FASE 2: Comunicazione Strutturata

#### Obiettivo
```
Output agenti = JSON validato.
Regina parsea automaticamente.
Metriche automatiche.
```

#### Task 2.1: Define Output Schemas

**Crea:** `schemas/agent-output/`

```json
// task_result_v1.json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["agent", "task_id", "status", "output"],
  "properties": {
    "agent": {
      "type": "string",
      "pattern": "^cervella-[a-z-]+$"
    },
    "task_id": {
      "type": "string",
      "pattern": "^TASK_[0-9]{3,}$"
    },
    "status": {
      "type": "string",
      "enum": ["COMPLETED", "PARTIAL", "FAILED", "BLOCKED"]
    },
    "output": {
      "type": "object",
      "required": ["summary"],
      "properties": {
        "summary": {"type": "string", "maxLength": 500},
        "files_created": {"type": "array", "items": {"type": "string"}},
        "files_modified": {"type": "array", "items": {"type": "string"}},
        "next_actions": {"type": "array", "items": {"type": "string"}},
        "blockers": {"type": "array", "items": {"type": "string"}}
      }
    },
    "metadata": {
      "type": "object",
      "properties": {
        "started_at": {"type": "string", "format": "date-time"},
        "completed_at": {"type": "string", "format": "date-time"},
        "tokens_used": {"type": "integer", "minimum": 0}
      }
    }
  }
}
```

**Schemas per tipi specifici:**
```
research_report_v2.json
code_change_v1.json
test_result_v1.json
review_feedback_v1.json
```

---

#### Task 2.2: Update Agent DNAs

**PRIMA (testo libero):**
```markdown
## Output Atteso (COMPATTO!)

FATTO:
- [cosa hai completato]

NOTE:
- [info importanti]
```

**DOPO (JSON):**
```markdown
## Output Format

**MANDATORY:** All responses MUST be valid JSON conforming to schema.

Schema: `schemas/agent-output/task_result_v1.json`

Example:
\`\`\`json
{
  "agent": "cervella-tech-researcher",
  "task_id": "TASK_001",
  "status": "COMPLETED",
  "output": {
    "summary": "Research completed on SSE best practices",
    "files_created": ["docs/studio/STUDIO_SSE.md"],
    "files_modified": [],
    "next_actions": []
  },
  "metadata": {
    "started_at": "2026-01-14T10:00:00Z",
    "completed_at": "2026-01-14T10:15:00Z",
    "tokens_used": 2500
  }
}
\`\`\`

**Validation:** Output will be validated against schema. Invalid JSON = task FAILED.
```

**Update TUTTI gli agent DNAs (16 file).**

---

#### Task 2.3: Output Validation Tool

**Script:** `scripts/swarm/validate-output.py`

```python
#!/usr/bin/env python3
import json
import jsonschema
from pathlib import Path

def validate_agent_output(output_json: str, schema_name: str = "task_result_v1"):
    """Validate agent output against schema."""
    schema_path = Path(f"schemas/agent-output/{schema_name}.json")
    schema = json.loads(schema_path.read_text())

    try:
        data = json.loads(output_json)
        jsonschema.validate(instance=data, schema=schema)
        return {"valid": True, "errors": []}
    except jsonschema.ValidationError as e:
        return {"valid": False, "errors": [str(e)]}
    except json.JSONDecodeError as e:
        return {"valid": False, "errors": [f"Invalid JSON: {e}"]}

# Usage:
# python scripts/swarm/validate-output.py --input result.json
```

**Integration in spawn-workers:**
```bash
# After worker completes
RESULT=$(cat /tmp/worker_output.json)
python scripts/swarm/validate-output.py --input "$RESULT"

if [ $? -ne 0 ]; then
  echo "❌ Worker output invalid! Schema validation failed."
  exit 1
fi

echo "✅ Worker output validated"
```

---

#### Task 2.4: Regina Parser Upgrade

**PRIMA:**
```python
# Regina legge testo libero
result = worker_output.strip()
if "FATTO" in result:
    # Parse manualmente...
```

**DOPO:**
```python
import json
from pathlib import Path
from typing import Dict, Any

def parse_worker_result(output: str) -> Dict[str, Any]:
    """Parse and validate worker JSON output."""
    try:
        data = json.loads(output)

        # Validate schema
        validation = validate_agent_output(output)
        if not validation["valid"]:
            raise ValueError(f"Invalid output: {validation['errors']}")

        return data
    except Exception as e:
        raise WorkerOutputError(f"Failed to parse worker output: {e}")

# Usage in Regina:
result = parse_worker_result(worker_output)
status = result["status"]
files = result["output"]["files_created"]
summary = result["output"]["summary"]
```

**Benefits:**
- Parsing automatico ✅
- Type safety ✅
- Error handling chiaro ✅

---

#### Task 2.5: Metrics Dashboard

**Auto-collect metrics da JSON output:**

```python
# scripts/swarm/collect-metrics.py
import json
from pathlib import Path
from datetime import datetime

class SwarmMetrics:
    def __init__(self):
        self.metrics_file = Path(".swarm/metrics/daily.json")

    def record_task(self, result: dict):
        """Record task completion metrics."""
        metrics = {
            "timestamp": datetime.now().isoformat(),
            "agent": result["agent"],
            "task_id": result["task_id"],
            "status": result["status"],
            "duration_seconds": self._calculate_duration(result),
            "tokens_used": result["metadata"].get("tokens_used", 0),
            "files_changed": len(result["output"]["files_created"]) +
                           len(result["output"]["files_modified"])
        }

        # Append to daily metrics
        self._append_metric(metrics)

    def daily_summary(self, date: str = None):
        """Generate daily summary."""
        # Load daily metrics, aggregate by agent
        # Return summary stats
        pass
```

**Dashboard output:**
```
SWARM METRICS - 2026-01-14
==========================

Agent              | Tasks | Success | Avg Duration | Tokens
-------------------|-------|---------|--------------|-------
tech-researcher    |   5   |  100%   |    12m      | 12.5K
market-analyst     |   3   |  100%   |    18m      | 15.2K
frontend           |   8   |   87%   |     8m      |  8.1K
backend            |  10   |   90%   |    10m      |  9.3K

Total Tasks: 26
Success Rate: 92%
Total Tokens: 234K
```

---

#### FASE 2 - Success Criteria

```
✅ Tutti gli agenti restituiscono JSON validato
✅ Regina parsea automaticamente (no testo libero)
✅ Schema validation automatica in spawn-workers
✅ Metrics dashboard funzionante
✅ Errori output = task FAILED (chiaro)
```

**Stima:** 2 sprint (6-10 giorni)

---

### 4.5 FASE 3: Orchestrazione Avanzata

#### Obiettivo
```
Supporto multi-pattern:
- Sequential (già OK)
- Concurrent (NEW)
- Handoff/Router (NEW)
- Magentic (opzionale, FUTURE)
```

#### Task 3.1: Concurrent Orchestration

**Pattern:**
```
Task: "Analyze 3 competitors in parallel"

Regina:
1. Identifica task parallelizzabili
2. Spawn N worker instances
3. Collect results
4. Aggregate
```

**Implementation:**

**Script:** `scripts/swarm/spawn-workers-parallel.sh`

```bash
#!/bin/bash
# Spawn multiple workers in parallel

WORKERS=()
RESULTS=()

# Function to spawn single worker
spawn_worker() {
    local agent=$1
    local task_file=$2
    local output_file=$3

    spawn-workers --$agent --task-file $task_file --output $output_file &
    WORKERS+=($!)
}

# Spawn all workers
spawn_worker "market-analyst" "tasks/analyze_lodgify.md" "results/lodgify.json"
spawn_worker "market-analyst" "tasks/analyze_guesty.md" "results/guesty.json"
spawn_worker "market-analyst" "tasks/analyze_hostaway.md" "results/hostaway.json"

# Wait for all
echo "Waiting for ${#WORKERS[@]} workers..."
for pid in "${WORKERS[@]}"; do
    wait $pid
    echo "Worker $pid completed"
done

# Collect results
python scripts/swarm/aggregate-results.py results/*.json > final_report.json
```

**Aggregator:** `scripts/swarm/aggregate-results.py`

```python
#!/usr/bin/env python3
import json
import sys
from pathlib import Path

def aggregate_results(result_files: list[str]):
    """Aggregate multiple worker results."""
    results = []

    for file in result_files:
        data = json.loads(Path(file).read_text())
        results.append(data)

    # Combine outputs
    aggregated = {
        "status": "COMPLETED" if all(r["status"] == "COMPLETED" for r in results) else "PARTIAL",
        "workers": [r["agent"] for r in results],
        "outputs": [r["output"] for r in results],
        "total_tokens": sum(r["metadata"]["tokens_used"] for r in results)
    }

    print(json.dumps(aggregated, indent=2))

if __name__ == "__main__":
    aggregate_results(sys.argv[1:])
```

**Regina Usage:**
```bash
# In Regina's bash tool
./scripts/swarm/spawn-workers-parallel.sh \
  --tasks "analyze_lodgify,analyze_guesty,analyze_hostaway" \
  --agent market-analyst \
  --aggregate-to competitor_analysis.json
```

---

#### Task 3.2: Handoff/Router Pattern

**Pattern:**
```
Task: "Handle customer inquiry"

Router Agent:
1. Reads inquiry
2. Classifies type (technical/billing/general)
3. Routes to specialist
4. Specialist handles
```

**Implementation:**

**New Agent:** `cervella-router.md`

```markdown
# Cervella Router

## Role
Route tasks to appropriate specialist agents.

## Process
1. Analyze incoming task
2. Classify type using predefined categories
3. Select best specialist agent
4. Delegate task
5. Return specialist's result

## Routing Rules
- Technical questions → cervella-tech-researcher
- Market/strategy → cervella-market-analyst
- Code implementation → cervella-backend OR cervella-frontend
- Testing → cervella-tester
- Unknown → ASK Regina for guidance

## Output
\`\`\`json
{
  "router": "cervella-router",
  "classification": "technical_research",
  "selected_agent": "cervella-tech-researcher",
  "confidence": 0.95,
  "delegated_to": "cervella-tech-researcher",
  "result": { ... }
}
\`\`\`
```

**Regina Usage:**
```bash
# When task type is unknown
spawn-workers --router --task-file tasks/ambiguous.md

# Router auto-selects and delegates
# Regina receives final result
```

---

#### Task 3.3: Pattern Auto-Selection

**Regina Intelligence:** Decide QUALE pattern usare.

**Logic:**

```python
# In Regina's decision logic

def select_orchestration_pattern(task: Task) -> str:
    """Auto-select orchestration pattern."""

    # Sequential: Default for most tasks
    if task.has_dependencies() and not task.parallelizable():
        return "SEQUENTIAL"

    # Concurrent: Multiple independent sub-tasks
    if task.parallelizable() and task.count_subtasks() >= 3:
        return "CONCURRENT"

    # Handoff: Unknown optimal agent upfront
    if task.type == "UNKNOWN" or task.requires_classification():
        return "HANDOFF"

    # Magentic: Open-ended planning (future)
    if task.complexity == "HIGH" and task.open_ended():
        return "MAGENTIC"  # Not implemented yet

    return "SEQUENTIAL"  # Default

# Usage:
pattern = select_orchestration_pattern(current_task)

if pattern == "CONCURRENT":
    run_concurrent_orchestration(current_task)
elif pattern == "HANDOFF":
    run_handoff_orchestration(current_task)
else:
    run_sequential_orchestration(current_task)
```

**Transparency:** Regina comunica a Rafa quale pattern usa.

```
Regina: "Ho analizzato il task. Userò CONCURRENT orchestration (3 workers in parallel). Procedo?"
Rafa: "Ok!"
```

---

#### Task 3.4: Flow Definition Language (Optional)

**Inspired by CrewAI Flows.**

**Crea:** `.swarm/flows/competitor_analysis_flow.yaml`

```yaml
name: competitor_analysis
description: Analyze multiple competitors in parallel

steps:
  - id: parallel_analysis
    type: CONCURRENT
    agents:
      - cervella-market-analyst
      - cervella-market-analyst
      - cervella-market-analyst
    tasks:
      - analyze_competitor_1
      - analyze_competitor_2
      - analyze_competitor_3

  - id: aggregate
    type: SEQUENTIAL
    agent: cervella-market-analyst
    task: synthesize_analysis
    depends_on: [parallel_analysis]

  - id: review
    type: SEQUENTIAL
    agent: cervella-guardiana-ricerca
    task: validate_report
    depends_on: [aggregate]
```

**Regina parses flow file e esegue:**

```bash
python scripts/swarm/execute-flow.py .swarm/flows/competitor_analysis_flow.yaml
```

**Benefits:**
- Declarative (cosa fare, non come)
- Reusable flows
- Version controlled
- Testable

**Effort:** Medium-High, priorità BASSA (opzionale).

---

#### FASE 3 - Success Criteria

```
✅ Concurrent orchestration funzionante
✅ Handoff/Router pattern implementato
✅ Regina auto-selects pattern per task
✅ Parallel tasks = 3x faster than sequential
✅ Flow definition language (opzionale)
```

**Stima:** 3 sprint (9-15 giorni)

---

### 4.6 FASE 4: Validazione Automatica

#### Obiettivo
```
Output validato automaticamente.
Test run automatici.
Guardiane triggerrate automaticamente.
```

#### Task 4.1: Post-Task Hooks

**Hook system:** `scripts/swarm/hooks/`

```bash
# hooks/post-task.sh
#!/bin/bash
# Executed automatically after each worker completes

AGENT=$1
TASK_ID=$2
RESULT_FILE=$3

echo "Running post-task hooks for $AGENT..."

# Hook 1: Schema validation
python scripts/swarm/validate-output.py --input $RESULT_FILE
if [ $? -ne 0 ]; then
  echo "❌ Schema validation FAILED"
  exit 1
fi

# Hook 2: Run tests (if applicable)
if [[ "$AGENT" == "cervella-backend" ]] || [[ "$AGENT" == "cervella-frontend" ]]; then
  echo "Running automated tests..."
  ./hooks/run-tests.sh $AGENT
fi

# Hook 3: Trigger Guardiana (if critical)
CRITICAL_AGENTS=("cervella-backend" "cervella-frontend" "cervella-security")
if [[ " ${CRITICAL_AGENTS[@]} " =~ " ${AGENT} " ]]; then
  echo "Triggering Guardiana validation..."
  ./hooks/trigger-guardiana.sh $AGENT $RESULT_FILE
fi

echo "✅ All hooks passed"
```

**Integration in spawn-workers:**
```bash
# After worker completes
./scripts/swarm/hooks/post-task.sh $AGENT $TASK_ID $RESULT_FILE
```

---

#### Task 4.2: Automated Testing Hook

**Script:** `hooks/run-tests.sh`

```bash
#!/bin/bash
AGENT=$1

case $AGENT in
  cervella-backend)
    echo "Running backend tests..."
    cd ~/Developer/miracollogeminifocus
    pytest tests/backend/ --tb=short
    ;;

  cervella-frontend)
    echo "Running frontend tests..."
    cd ~/Developer/miracollogeminifocus/frontend
    npm test -- --watchAll=false
    ;;

  *)
    echo "No automated tests for $AGENT"
    ;;
esac
```

**Output integration:**
```json
{
  "agent": "cervella-backend",
  "status": "COMPLETED",
  "output": { ... },
  "validation": {
    "schema": "PASSED",
    "tests": {
      "status": "PASSED",
      "tests_run": 42,
      "failures": 0
    }
  }
}
```

---

#### Task 4.3: Guardiana Auto-Trigger

**Pattern:**
```
Worker completes → Hook checks criticality → If critical → Spawn Guardiana
```

**Script:** `hooks/trigger-guardiana.sh`

```bash
#!/bin/bash
AGENT=$1
RESULT_FILE=$2

# Map agent to Guardiana
case $AGENT in
  cervella-backend|cervella-frontend|cervella-tester)
    GUARDIANA="guardiana-qualita"
    ;;
  cervella-tech-researcher|cervella-docs)
    GUARDIANA="guardiana-ricerca"
    ;;
  cervella-devops|cervella-security|cervella-data)
    GUARDIANA="guardiana-ops"
    ;;
  *)
    echo "No Guardiana needed for $AGENT"
    exit 0
    ;;
esac

echo "Spawning $GUARDIANA to validate $AGENT output..."

# Create validation task
cat > /tmp/guardiana_task.md << EOF
# Validation Task

Validate the output of **$AGENT** for task completion.

Result file: $RESULT_FILE

Verify:
1. Output quality
2. Best practices compliance
3. No obvious errors
4. Completeness

Return validation report.
EOF

# Spawn Guardiana
spawn-workers --$GUARDIANA --task-file /tmp/guardiana_task.md --output /tmp/guardiana_result.json

# Check Guardiana result
VALIDATION_STATUS=$(jq -r '.status' /tmp/guardiana_result.json)

if [ "$VALIDATION_STATUS" != "PASSED" ]; then
  echo "❌ Guardiana validation FAILED"
  exit 1
fi

echo "✅ Guardiana validation PASSED"
```

---

#### Task 4.4: Validation Report Dashboard

**Collect all validation results:**

```python
# scripts/swarm/validation-dashboard.py

class ValidationDashboard:
    def generate_report(self, date: str):
        """Generate validation report for date."""

        # Load all task results for date
        results = self._load_results(date)

        # Aggregate validation stats
        stats = {
            "total_tasks": len(results),
            "schema_validation": {
                "passed": sum(1 for r in results if r["validation"]["schema"] == "PASSED"),
                "failed": sum(1 for r in results if r["validation"]["schema"] == "FAILED")
            },
            "automated_tests": {
                "passed": ...,
                "failed": ...
            },
            "guardiana_checks": {
                "passed": ...,
                "failed": ...
            }
        }

        return self._format_report(stats)

# Output:
# VALIDATION DASHBOARD - 2026-01-14
# ===================================
#
# Total Tasks: 26
#
# Schema Validation:  ✅ 26/26 (100%)
# Automated Tests:    ✅ 18/18 (100%)
# Guardiana Checks:   ✅ 12/15 (80%)
#
# ISSUES:
# - Task TASK_042: Guardiana flagged code quality issue
# - Task TASK_055: Guardiana flagged missing tests
```

---

#### FASE 4 - Success Criteria

```
✅ Post-task hooks eseguiti automaticamente
✅ Automated tests run per backend/frontend changes
✅ Guardiane triggerrate automaticamente per task critici
✅ Validation dashboard generato daily
✅ Failure rate < 5% (quality improvement)
```

**Stima:** 2 sprint (6-10 giorni)

---

## PARTE 5: PRIORITIZZAZIONE & QUICK WINS

### 5.1 Quick Wins (1-2 giorni each)

#### Quick Win 1: RUOLI_CHEAT_SHEET.md
```
Effort: 2 ore
Impact: Alto (riduce ambiguità immediata)

Deliverable:
- Tabella chiara "Domanda → Agente"
- Usata da Regina per decidere
```

#### Quick Win 2: Rename Researcher/Scienziata
```
Effort: 4 ore
Impact: Alto (risolve overlap principale)

Steps:
1. Rename file agents
2. Update spawn-workers flags
3. Update DNA_FAMIGLIA.md
```

#### Quick Win 3: Agent Manifests (minimal version)
```
Effort: 1 giorno
Impact: Medio (documentazione vivente)

Crea JSON manifest per top 5 agenti:
- tech-researcher
- market-analyst
- backend
- frontend
- tester
```

---

### 5.2 Prioritizzazione FASI

#### Alta Priorità (MUST HAVE per 9.5)
```
✅ FASE 1: Ruoli Cristallini
✅ FASE 2: Comunicazione Strutturata
✅ FASE 4: Validazione Automatica (almeno schema + tests)
```

**Rationale:**
- Senza ruoli chiari → confusione persiste
- Senza JSON output → parsing fragile
- Senza validazione → errori silenti

#### Media Priorità (NICE TO HAVE)
```
⚠️ FASE 3: Concurrent orchestration
⚠️ FASE 3: Handoff/Router pattern
```

**Rationale:**
- Concurrent → performance gain, ma non blocker
- Router → utile per task ambigui, ma non frequenti

#### Bassa Priorità (FUTURE)
```
🔮 FASE 3: Magentic pattern
🔮 FASE 3: Flow definition language
🔮 Advanced metrics/analytics
```

---

### 5.3 Ordine Implementazione Suggerito

```
SPRINT 1 (Week 1):
  ├─ Quick Win 1: RUOLI_CHEAT_SHEET
  ├─ Quick Win 2: Rename agents
  └─ Quick Win 3: Manifests (top 5)

SPRINT 2 (Week 2):
  ├─ Define output schemas (all types)
  ├─ Update 5 agent DNAs (pilot)
  └─ Build validate-output.py tool

SPRINT 3 (Week 3):
  ├─ Update remaining 11 agent DNAs
  ├─ Integrate validation in spawn-workers
  └─ Regina parser upgrade

SPRINT 4 (Week 4):
  ├─ Metrics collection
  ├─ Dashboard prototype
  └─ Test end-to-end

SPRINT 5-6 (Week 5-6):
  ├─ Post-task hooks system
  ├─ Automated testing hook
  ├─ Guardiana auto-trigger
  └─ Validation dashboard

SPRINT 7-8 (Week 7-8 - OPTIONAL):
  ├─ Concurrent orchestration
  ├─ Router pattern
  └─ Pattern auto-selection
```

**Checkpoint dopo Sprint 4:** Valutare 9.0/10 raggiunto?

---

## PARTE 6: METRICHE DI SUCCESSO

### 6.1 Metriche Quantitative

| Metrica | Ora (7.8) | Target (9.5) | Come Misurare |
|---------|-----------|--------------|---------------|
| **Ambiguità ruoli** | 20% tasks | < 2% tasks | Track "quale agente?" domande |
| **Output parsing errors** | ~10% | < 1% | Schema validation failures |
| **Task re-delegation** | ~15% | < 5% | Track retry count |
| **Validation coverage** | 30% | 95% | % tasks con validation |
| **Parallel efficiency** | N/A | 3x speedup | Concurrent vs Sequential time |
| **Token efficiency** | Baseline | +20% | Tokens/task (better routing) |

---

### 6.2 Metriche Qualitative

#### Developer Experience (Regina)
```
PRIMA:
"Devo indovinare quale agente invocare"
"Devo parsare testo manualmente"
"Non so se output è valido"

DOPO:
"Manifests mi dicono quale agente"
"JSON parsed automaticamente"
"Validation automatica mi avvisa"
```

#### User Experience (Rafa)
```
PRIMA:
"Quale agente per questa ricerca?"
"È andato tutto bene?" (non chiaro)

DOPO:
"Sistema sceglie agente automaticamente"
"Dashboard mostra validation status chiaro"
```

---

### 6.3 Success Definition: 9.5/10

```
✅ Zero ambiguità su quale agente invocare
✅ Output sempre validato (schema + tests)
✅ Parallel tasks 3x più veloci
✅ Failure detection automatica
✅ Guardiane validate automaticamente
✅ Dashboard metrics leggibile
✅ Rafa dice: "Wow, funziona da solo!"
```

**Test finale:** Dare task complesso alla Regina, osservare.
```
Task: "Analizza 5 competitor, implementa feature simile, testa, deploy"

Regina dovrebbe:
1. Auto-select pattern (concurrent per analysis)
2. Spawn 5 market-analyst in parallel
3. Aggregate results
4. Delegate implementation (backend/frontend)
5. Auto-trigger tests
6. Auto-trigger Guardiana
7. Report completo a Rafa

SENZA intervento umano (tranne OK finale).
```

**Se passa questo test → 9.5/10! ✨**

---

## FINE PARTE 2

**Prossimo:** PARTE 3 con implementazione dettagliata e code examples.
