# Benchmark Structure for Architect Pattern

**Status**: OK
**Created**: 2026-01-19
**Researcher**: cervella-researcher

---

## THRESHOLD SUMMARY

### From `task_classifier.py`

**Classificazione basata su:**
- **Keyword Score** (0.0-1.0): analisi keywords (refactor, architecture, migrate, etc.)
- **File Score** (0.0-0.8): numero file affetti (≥5 file = 0.8, ≥3 file = 0.5)
- **Final Score**: `min((keyword_score + file_score) / 1.5, 1.0)`

**Thresholds:**

| Complexity | Final Score | Should Architect | Reasoning |
|-----------|-------------|------------------|-----------|
| **CRITICAL** | ≥ 0.7 | ✅ YES (required) | Task critico - richiede planning dettagliato |
| **COMPLEX** | ≥ 0.5 | ✅ YES (recommended) | Task complesso - architect raccomandato |
| **MEDIUM** | ≥ 0.3 | ❌ NO (optional) | Task medio - architect opzionale |
| **SIMPLE** | < 0.3 | ❌ NO | Task semplice - procedi direttamente |

**Override rules:**
- Simple keywords (`fix typo`, `update comment`, `rename`) → SIMPLE (bypass)
- `force_architect=True` → COMPLEX (override)
- Breaking changes flag → +0.3 to score

### From `architect_flow.py`

**Plan Validation Criteria:**
- Required sections: Metadata, Phase 1-4
- Metadata fields: Task ID, Complexity, Files Affected
- Success Criteria must be present
- Score: 10.0 base, penalties for missing elements
- **Valid plan**: no errors AND score ≥ 7.0

**Fallback Logic:**
- Max revisions: 2
- After 2 rejections → FALLBACK mode (direct to worker with caution)

---

## 10 TASK EXAMPLES (Benchmark Suite)

| # | Task Description | Expected Class | Expected Score | Should Architect | Why |
|---|------------------|----------------|----------------|------------------|-----|
| 1 | Fix typo in README.md introduction | SIMPLE | ~0.1 | ❌ NO | Simple keyword detected |
| 2 | Add logging to user authentication endpoint | MEDIUM | ~0.35 | ❌ NO | Single keyword `api`, ~1 file |
| 3 | Refactor database connection pooling | COMPLEX | ~0.55 | ✅ YES | `refactor` (0.8) + DB complexity |
| 4 | Migrate entire authentication module from JWT to OAuth2 | CRITICAL | ~0.75 | ✅ YES | `migrate` (0.7) + `authentication`, multiple files |
| 5 | Update button color from blue to green | SIMPLE | ~0.15 | ❌ NO | Simple UI tweak, 1 file |
| 6 | Implement new user dashboard with 5 charts and real-time updates | COMPLEX | ~0.6 | ✅ YES | `implement feature` + multiple components |
| 7 | Fix null pointer bug in payment processing | MEDIUM | ~0.4 | ❌ NO | `fix` + `bug` but single issue |
| 8 | Restructure entire API layer to support versioning across 15 endpoints | CRITICAL | ~0.85 | ✅ YES | `restructure` (0.8) + 15 files mentioned |
| 9 | Rename variable `userData` to `userProfile` in UserService.py | SIMPLE | ~0.1 | ❌ NO | `rename` simple keyword |
| 10 | Integrate third-party analytics service across frontend and backend | COMPLEX | ~0.65 | ✅ YES | `integrate` (0.5) + `across modules` (0.6) + multiple files |

**Distribution:**
- SIMPLE: 3 tasks (30%)
- MEDIUM: 2 tasks (20%)
- COMPLEX: 3 tasks (30%)
- CRITICAL: 2 tasks (20%)

---

## MEASUREMENT APPROACH

### Without Real Execution (Dry Run)

**Goal**: Misurare se il classifier PREDICE correttamente la complessita, non se l'esecuzione riesce.

#### Primary Metrics

1. **Classification Accuracy**
   ```python
   # Per ogni task nel benchmark:
   result = classify_task(task_description)
   accuracy = (result.complexity == expected_complexity) ? 1 : 0

   # Aggregate:
   total_accuracy = correct_predictions / total_tasks
   ```

2. **Routing Decision Accuracy**
   ```python
   decision = route_task(task_description)
   routing_accuracy = (decision.use_architect == expected_should_architect) ? 1 : 0
   ```

3. **Confidence Calibration**
   ```
   Compare result.confidence vs actual correctness

   Well-calibrated = high confidence when correct, low when wrong
   Poorly calibrated = confident but wrong
   ```

#### Secondary Metrics

4. **Trigger Analysis**
   ```
   For each task:
   - Which triggers matched? (result.triggers)
   - Are they the expected ones?
   - False positives/negatives in trigger detection
   ```

5. **Score Distribution**
   ```
   Plot final_score distribution:
   - Are SIMPLE tasks clustered < 0.3?
   - Are CRITICAL tasks clustered > 0.7?
   - Is there clear separation between classes?
   ```

6. **Boundary Cases**
   ```
   Test edge cases near thresholds:
   - Task with score = 0.29 vs 0.31 (SIMPLE vs MEDIUM boundary)
   - Task with score = 0.49 vs 0.51 (MEDIUM vs COMPLEX boundary)
   ```

#### Evaluation Code Structure

```python
# benchmark_architect_pattern.py

from scripts.swarm.task_classifier import classify_task
from scripts.swarm.architect_flow import route_task

BENCHMARK_TASKS = [
    {
        "id": 1,
        "description": "Fix typo in README.md introduction",
        "expected_complexity": "simple",
        "expected_should_architect": False,
        "expected_score_range": (0.0, 0.2)
    },
    # ... altri 9 task
]

def run_benchmark():
    results = []

    for task in BENCHMARK_TASKS:
        # Classification
        classification = classify_task(task["description"])

        # Routing
        routing = route_task(task["description"])

        # Evaluate
        result = {
            "task_id": task["id"],
            "description": task["description"],
            "expected_complexity": task["expected_complexity"],
            "actual_complexity": classification.complexity.value,
            "correct_classification": (classification.complexity.value == task["expected_complexity"]),
            "expected_should_architect": task["expected_should_architect"],
            "actual_should_architect": routing.use_architect,
            "correct_routing": (routing.use_architect == task["expected_should_architect"]),
            "confidence": classification.confidence,
            "triggers": classification.triggers,
            "score": classification.confidence,
        }

        results.append(result)

    # Aggregate metrics
    metrics = {
        "classification_accuracy": sum(r["correct_classification"] for r in results) / len(results),
        "routing_accuracy": sum(r["correct_routing"] for r in results) / len(results),
        "avg_confidence": sum(r["confidence"] for r in results) / len(results),
        "results": results
    }

    return metrics
```

#### Test Without Execution

**Validation Tests** (senza eseguire task reali):

1. **Plan Structure Test** (if architect used)
   ```python
   # Se task → architect, simula piano minimo
   mock_plan = """
   ## Metadata
   Task ID: MOCK_001
   Complexity: complex
   Files Affected: 3

   ## Phase 1: Understanding
   ...

   ## Phase 2: Design
   ...

   ## Phase 3: Review
   ...

   ## Phase 4: Final Plan
   ### Success Criteria
   - Test pass

   ### Execution Order
   1. Step 1
   """

   validation = validate_plan(mock_plan)
   assert validation.is_valid == True
   ```

2. **Fallback Logic Test**
   ```python
   # Simula 3 rejection senza eseguire nulla
   session = create_session("TEST_001", "complex task")

   # 1st rejection
   session, action = handle_plan_rejection(session, "Missing details")
   assert action == "REQUEST_REVISION"

   # 2nd rejection
   session, action = handle_plan_rejection(session, "Still unclear")
   assert action == "REQUEST_REVISION"

   # 3rd rejection
   session, action = handle_plan_rejection(session, "Cannot plan")
   assert action == "FALLBACK_TO_WORKER"
   assert should_fallback(session) == True
   ```

---

## VALUE MEASUREMENT

### How to Measure Architect Pattern Value

**Without execution**, possiamo misurare:

#### A. Prediction Quality
- **Classification accuracy** sul benchmark (target: >85%)
- **Routing accuracy** (target: >90%)
- **False positives** (task semplice → architect): costo inutile
- **False negatives** (task complesso → direct): rischio fallimento

#### B. Consistency
- **Same task → same classification** (repeatability)
- **Similar tasks → similar scores** (calibration)

#### C. Boundary Robustness
- **Small description changes → stable classification?**
  ```
  Example:
  "Refactor auth module" → COMPLEX
  "Refactor auth module across 3 files" → CRITICAL?

  Score should increase smoothly, not jump erratically
  ```

#### D. System Integration
- **Plan validation pass rate** (mock plans)
- **Fallback trigger correctness** (rejection scenarios)

### Value Proposition

Se il benchmark mostra:
- ✅ Classification accuracy >85%
- ✅ Routing accuracy >90%
- ✅ Low false negatives (<5%)
- ✅ Stable boundary behavior

**Allora possiamo dire:**
> "L'Architect Pattern route correttamente task complessi a planning, evitando spreco di tempo su task semplici e riducendo fallimenti su task critici."

---

## NEXT STEPS

1. **Implementare benchmark script** (`tests/swarm/benchmark_architect_pattern.py`)
2. **Run baseline** (misurare performance attuale)
3. **Iterate thresholds** se accuracy <85%
4. **Add more tasks** (espandere benchmark a 20-50 task)
5. **Real execution validation** (opzionale: eseguire 3-5 task reali per verificare)

---

## SOURCES

Research basata su:
- [MAESTRO Multi-Agent Evaluation Suite](https://arxiv.org/html/2601.00481v1)
- [MultiAgentBench for LLM Collaboration](https://arxiv.org/abs/2503.01935)
- [Benchmarking Multi-Agent Architectures - LangChain](https://www.blog.langchain.com/benchmarking-multi-agent-architectures/)
- [RouterBench Dataset for LLM Routing](https://www.emergentmind.com/topics/routerbench-dataset)
- [How to create LLM test datasets with synthetic data](https://www.evidentlyai.com/llm-guide/llm-test-dataset-synthetic-data)
- [30 LLM evaluation benchmarks](https://www.evidentlyai.com/llm-guide/llm-benchmarks)

---

**Fine Output - Benchmark Design Completato**
