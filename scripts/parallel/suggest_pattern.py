#!/usr/bin/env python3
"""
Pattern Suggestion Script per CervellaSwarm.
Suggerisce il pattern ottimale (Sequential, Parallel, Worktrees) basandosi sui file da modificare.

Usage:
    ./suggest_pattern.py file1.py file2.jsx file3.md
    ./suggest_pattern.py --time 60 --json api/*.py
"""

__version__ = "1.0.0"
__version_date__ = "2026-01-01"

import sys
import json
import argparse
from pathlib import Path
from typing import Dict, List, Tuple
from dataclasses import dataclass

# Import logica da task_analyzer
try:
    from task_analyzer import (
        analyze_task,
        ExecutionStrategy,
        Domain,
        TaskAnalysis,
        detect_domain,
        DOMAIN_TO_AGENT
    )
except ImportError:
    print("⚠️  Errore: task_analyzer.py non trovato!", file=sys.stderr)
    print("   Assicurati di essere in scripts/parallel/", file=sys.stderr)
    sys.exit(1)


@dataclass
class PatternSuggestion:
    """Suggerimento pattern con dettagli."""
    pattern: str  # SEQUENTIAL, PARALLEL, WORKTREES
    reason: str
    speedup: float
    time_original: int  # minuti
    time_optimized: int  # minuti
    agents: List[str]
    agent_file_count: Dict[str, int]  # agente -> numero file
    warnings: List[str]  # Eventuali warning


def suggest_pattern(
    file_paths: List[str],
    estimated_time: int = 30
) -> PatternSuggestion:
    """
    Suggerisce il pattern ottimale basandosi sui file.

    Args:
        file_paths: Lista file da modificare
        estimated_time: Tempo stimato in minuti

    Returns:
        PatternSuggestion con raccomandazione e dettagli
    """
    # Delega analisi a task_analyzer
    analysis = analyze_task(file_paths, estimated_time)

    # Calcola tempo ottimizzato
    time_optimized = int(estimated_time / analysis.estimated_speedup)

    # Conta file per agente
    agent_file_count = {}
    for file_analysis in analysis.files:
        agent = file_analysis.agent
        agent_file_count[agent] = agent_file_count.get(agent, 0) + 1

    # Genera warnings
    warnings = []

    # Warning 1: Troppi file per stesso agente
    for agent, count in agent_file_count.items():
        if count > 5:
            warnings.append(
                f"⚠️  {agent} ha {count} file - considera split in batch"
            )

    # Warning 2: Overhead parallel non giustificato
    if analysis.strategy == ExecutionStrategy.PARALLEL and analysis.estimated_speedup < 1.2:
        warnings.append(
            "⚠️  Speedup < 1.2x - overhead parallel potrebbe non valere"
        )

    # Warning 3: Dipendenze rilevate
    has_deps = any(len(f.dependencies) > 0 for f in analysis.files)
    if has_deps and analysis.strategy == ExecutionStrategy.PARALLEL:
        warnings.append(
            "⚠️  Dipendenze rilevate - verifica ordine esecuzione"
        )

    return PatternSuggestion(
        pattern=analysis.strategy.value.upper(),
        reason=analysis.strategy_reason,
        speedup=analysis.estimated_speedup,
        time_original=estimated_time,
        time_optimized=time_optimized,
        agents=analysis.suggested_agents,
        agent_file_count=agent_file_count,
        warnings=warnings
    )


def format_suggestion_rich(suggestion: PatternSuggestion) -> str:
    """Formatta suggerimento con output colorato e box."""

    # Icons per pattern
    pattern_icons = {
        "SEQUENTIAL": "➡️",
        "PARALLEL": "🔀",
        "WORKTREES": "🌳"
    }

    icon = pattern_icons.get(suggestion.pattern, "❓")

    lines = [
        "╔════════════════════════════════════════════════════════════════╗",
        "║  🧠 PATTERN SUGGESTION                                        ║",
        "╠════════════════════════════════════════════════════════════════╣",
        f"║  {icon} Pattern Raccomandato: {suggestion.pattern}",
        f"║  📝 Motivo: {suggestion.reason[:50]}...",  # Truncate long reasons
        f"║  ⚡ Speedup Stimato: {suggestion.speedup:.2f}x",
        f"║  ⏱️  Tempo Stimato: {suggestion.time_original} min → {suggestion.time_optimized} min",
        "║",
        "║  🐝 AGENTI SUGGERITI:",
    ]

    # Lista agenti con conteggio file
    for agent in suggestion.agents:
        count = suggestion.agent_file_count.get(agent, 0)
        lines.append(f"║     • {agent} ({count} file)")

    # Warnings (se presenti)
    if suggestion.warnings:
        lines.append("║")
        lines.append("║  ⚠️  WARNING:")
        for warning in suggestion.warnings:
            # Wrap long warnings
            warning_text = warning[4:]  # Remove emoji prefix
            lines.append(f"║     {warning_text[:55]}")

    lines.append("╚════════════════════════════════════════════════════════════════╝")

    return "\n".join(lines)


def format_suggestion_simple(suggestion: PatternSuggestion) -> str:
    """Formatta suggerimento semplice (senza box)."""
    lines = [
        f"Pattern: {suggestion.pattern}",
        f"Motivo: {suggestion.reason}",
        f"Speedup: {suggestion.speedup:.2f}x",
        f"Tempo: {suggestion.time_original}min → {suggestion.time_optimized}min",
        "",
        "Agenti:",
    ]

    for agent in suggestion.agents:
        count = suggestion.agent_file_count.get(agent, 0)
        lines.append(f"  - {agent} ({count} file)")

    if suggestion.warnings:
        lines.append("")
        lines.append("Warnings:")
        for warning in suggestion.warnings:
            lines.append(f"  {warning}")

    return "\n".join(lines)


def format_suggestion_json(suggestion: PatternSuggestion) -> str:
    """Formatta suggerimento come JSON."""
    data = {
        "pattern": suggestion.pattern,
        "reason": suggestion.reason,
        "speedup": suggestion.speedup,
        "time": {
            "original": suggestion.time_original,
            "optimized": suggestion.time_optimized,
            "saved": suggestion.time_original - suggestion.time_optimized
        },
        "agents": suggestion.agents,
        "agent_file_count": suggestion.agent_file_count,
        "warnings": suggestion.warnings
    }
    return json.dumps(data, indent=2)


def main():
    """Entry point CLI."""
    parser = argparse.ArgumentParser(
        description="CervellaSwarm Pattern Suggestion Script",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Analizza 3 file
  ./suggest_pattern.py api/main.py components/Header.jsx tests/test_api.py

  # Con tempo stimato custom
  ./suggest_pattern.py --time 60 backend/*.py

  # Output JSON per automazione
  ./suggest_pattern.py --json --time 45 src/**/*.jsx

  # Output semplice (no box)
  ./suggest_pattern.py --simple file1.py file2.css
        """
    )

    parser.add_argument(
        "files",
        nargs="*",
        help="File da analizzare"
    )
    parser.add_argument(
        "--time", "-t",
        type=int,
        default=30,
        help="Tempo stimato in minuti (default: 30)"
    )
    parser.add_argument(
        "--json", "-j",
        action="store_true",
        help="Output JSON"
    )
    parser.add_argument(
        "--simple", "-s",
        action="store_true",
        help="Output semplice (no box)"
    )
    parser.add_argument(
        "--version", "-v",
        action="version",
        version=f"suggest_pattern.py v{__version__}"
    )

    args = parser.parse_args()

    # Validate input
    if not args.files:
        parser.print_help()
        sys.exit(1)

    # Header (solo se non JSON)
    if not args.json:
        print(f"🧠 CervellaSwarm Pattern Suggester v{__version__}", file=sys.stderr)
        print(f"   Analyzing {len(args.files)} file(s)...\n", file=sys.stderr)

    # Suggerimento pattern
    try:
        suggestion = suggest_pattern(args.files, args.time)
    except Exception as e:
        print(f"❌ Errore durante analisi: {e}", file=sys.stderr)
        sys.exit(1)

    # Output
    if args.json:
        print(format_suggestion_json(suggestion))
    elif args.simple:
        print(format_suggestion_simple(suggestion))
    else:
        print(format_suggestion_rich(suggestion))

    # Exit code basato su warnings
    if suggestion.warnings:
        sys.exit(2)  # Exit code 2 = successo con warning
    else:
        sys.exit(0)  # Exit code 0 = successo


if __name__ == "__main__":
    main()
