#!/usr/bin/env python3
"""
Benchmark Architect Pattern - W3-B Day 7

Testa che il task_classifier classifica correttamente 10 task di esempio.
Target: >85% accuracy

Cervella & Rafa - Sessione 283
"""

import sys
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent.parent.parent
sys.path.insert(0, str(project_root))

from scripts.swarm.task_classifier import (
    classify_task,
    TaskComplexity,
    ClassificationResult
)


# ============================================================
# BENCHMARK TASKS - 10 task con expected classification
# Distribution: 30% SIMPLE, 20% MEDIUM, 30% COMPLEX, 20% CRITICAL
# ============================================================

BENCHMARK_TASKS = [
    # --- SIMPLE (3 task) ---
    {
        "id": "T01",
        "description": "Fix typo in README.md documentation",
        "expected_complexity": TaskComplexity.SIMPLE,
        "expected_architect": False,
        "why": "Contains 'fix typo' - simple keyword"
    },
    {
        "id": "T02",
        "description": "Update button color from blue to green",
        "expected_complexity": TaskComplexity.SIMPLE,
        "expected_architect": False,
        "why": "Single file CSS change, no complexity keywords"
    },
    {
        "id": "T03",
        "description": "Rename variable userData to userProfile",
        "expected_complexity": TaskComplexity.SIMPLE,
        "expected_architect": False,
        "why": "Contains 'rename' - simple keyword"
    },

    # --- SIMPLE (2 task extra) ---
    # Guardiana Qualità review: questi sono SIMPLE, non MEDIUM
    # - "Add logging" = add puntuale, non architettura
    # - "Fix null pointer" = fix bug localizzato
    {
        "id": "T04",
        "description": "Add logging to authentication endpoint",
        "expected_complexity": TaskComplexity.SIMPLE,
        "expected_architect": False,
        "why": "Add puntuale, scope limitato, no architettura"
    },
    {
        "id": "T05",
        "description": "Fix null pointer exception in payment processing",
        "expected_complexity": TaskComplexity.SIMPLE,
        "expected_architect": False,
        "why": "Fix bug localizzato, no modifiche strutturali"
    },

    # --- COMPLEX (2 task) ---
    # T06 moved to CRITICAL per Guardiana review
    {
        "id": "T06",
        "description": "Refactor database connection pooling across all services",
        "expected_complexity": TaskComplexity.CRITICAL,
        "expected_architect": True,
        "why": "Refactor infrastruttura globale = CRITICAL (Guardiana approved)"
    },
    {
        "id": "T07",
        "description": "Implement dashboard with 5 interactive charts",
        "expected_complexity": TaskComplexity.COMPLEX,
        "expected_architect": True,
        "why": "Contains 'implement' + multiple components"
    },
    {
        "id": "T08",
        "description": "Integrate analytics tracking across frontend and backend",
        "expected_complexity": TaskComplexity.COMPLEX,
        "expected_architect": True,
        "why": "Contains 'integrate' + 'across' = cross-cutting"
    },

    # --- CRITICAL (2 task) ---
    {
        "id": "T09",
        "description": "Migrate authentication from JWT to OAuth2 with breaking changes",
        "expected_complexity": TaskComplexity.CRITICAL,
        "expected_architect": True,
        "why": "Contains 'migrate' + 'breaking change' = critical"
    },
    {
        "id": "T10",
        "description": "Restructure entire API versioning system affecting 15 endpoints",
        "expected_complexity": TaskComplexity.CRITICAL,
        "expected_architect": True,
        "why": "Contains 'restructure' + 'entire' + '15 files'"
    },
]


def run_benchmark() -> dict:
    """
    Esegue benchmark su tutti i task.

    Returns:
        Dict con risultati e metriche
    """
    results = []
    correct_complexity = 0
    correct_architect = 0

    print("\n" + "=" * 70)
    print("BENCHMARK ARCHITECT PATTERN - W3-B Day 7")
    print("=" * 70)
    print(f"Tasks: {len(BENCHMARK_TASKS)}")
    print("Target: Classification >85%, Routing >90%")
    print("=" * 70 + "\n")

    for task in BENCHMARK_TASKS:
        # Classify
        result = classify_task(task["description"])

        # Check correctness
        complexity_match = result.complexity == task["expected_complexity"]
        architect_match = result.should_architect == task["expected_architect"]

        if complexity_match:
            correct_complexity += 1
        if architect_match:
            correct_architect += 1

        # Status symbol
        status = "✓" if (complexity_match and architect_match) else "✗"

        # Print result
        print(f"[{task['id']}] {status}")
        print(f"    Task: {task['description'][:50]}...")
        print(f"    Expected: {task['expected_complexity'].value} | Architect: {task['expected_architect']}")
        print(f"    Got:      {result.complexity.value} | Architect: {result.should_architect}")
        print(f"    Triggers: {', '.join(result.triggers)}")
        if not complexity_match:
            print(f"    ⚠️  Complexity mismatch!")
        if not architect_match:
            print(f"    ⚠️  Architect decision mismatch!")
        print()

        results.append({
            "id": task["id"],
            "task": task["description"],
            "expected_complexity": task["expected_complexity"].value,
            "got_complexity": result.complexity.value,
            "expected_architect": task["expected_architect"],
            "got_architect": result.should_architect,
            "complexity_match": complexity_match,
            "architect_match": architect_match,
            "triggers": result.triggers,
            "confidence": result.confidence
        })

    # Calculate metrics
    total = len(BENCHMARK_TASKS)
    complexity_accuracy = (correct_complexity / total) * 100
    architect_accuracy = (correct_architect / total) * 100
    overall_accuracy = ((correct_complexity + correct_architect) / (total * 2)) * 100

    # Print summary
    print("=" * 70)
    print("RESULTS SUMMARY")
    print("=" * 70)
    print(f"Classification Accuracy: {correct_complexity}/{total} = {complexity_accuracy:.1f}%")
    print(f"Routing Accuracy:        {correct_architect}/{total} = {architect_accuracy:.1f}%")
    print(f"Overall Accuracy:        {overall_accuracy:.1f}%")
    print()

    # Check targets
    classification_pass = complexity_accuracy >= 85
    routing_pass = architect_accuracy >= 90

    print("TARGET CHECK:")
    print(f"  Classification ≥85%: {'✓ PASS' if classification_pass else '✗ FAIL'}")
    print(f"  Routing ≥90%:        {'✓ PASS' if routing_pass else '✗ FAIL'}")
    print("=" * 70)

    if classification_pass and routing_pass:
        print("\n🎉 BENCHMARK PASSED! Architect Pattern ready for production.\n")
    else:
        print("\n⚠️  BENCHMARK NEEDS IMPROVEMENT. Review mismatches above.\n")

    return {
        "total_tasks": total,
        "correct_complexity": correct_complexity,
        "correct_architect": correct_architect,
        "complexity_accuracy": complexity_accuracy,
        "architect_accuracy": architect_accuracy,
        "overall_accuracy": overall_accuracy,
        "classification_pass": classification_pass,
        "routing_pass": routing_pass,
        "all_pass": classification_pass and routing_pass,
        "results": results
    }


def test_benchmark_passes():
    """Test che il benchmark passa (per pytest)."""
    metrics = run_benchmark()
    assert metrics["classification_pass"], f"Classification accuracy {metrics['complexity_accuracy']:.1f}% < 85%"
    assert metrics["routing_pass"], f"Routing accuracy {metrics['architect_accuracy']:.1f}% < 90%"


if __name__ == "__main__":
    metrics = run_benchmark()
    sys.exit(0 if metrics["all_pass"] else 1)
