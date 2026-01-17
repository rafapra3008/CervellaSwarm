#!/usr/bin/env python3
"""
Hook SubagentStart - Carica la Costituzione per ogni subagent.

OGNI ragazza (Worker o Guardiana) riceve la Costituzione automaticamente.
"Senza costituzione meglio non fare nulla!" - Rafa

Versione: 1.0.0
Data: 2026-01-14
Cervella & Rafa
"""

import sys
import json
from pathlib import Path

# Path Costituzione (GLOBALE)
COSTITUZIONE_PATH = Path.home() / ".claude/COSTITUZIONE.md"


def load_costituzione(max_lines: int = 150) -> str:
    """Carica la Costituzione con limite righe."""
    try:
        if COSTITUZIONE_PATH.exists():
            content = COSTITUZIONE_PATH.read_text(encoding='utf-8')
            lines = content.split('\n')
            if len(lines) > max_lines:
                return '\n'.join(lines[:max_lines]) + f"\n\n... (altre {len(lines) - max_lines} righe)"
            return content
        else:
            return "ERRORE: Costituzione non trovata!"
    except Exception as e:
        return f"ERRORE lettura Costituzione: {e}"


def main():
    """Entry point hook."""
    try:
        # Leggi dati subagent da stdin
        try:
            input_data = json.load(sys.stdin)
        except:
            input_data = {}

        # Carica Costituzione
        costituzione = load_costituzione()

        # Formatta contesto
        context = f"""# COSTITUZIONE - LEGGI PRIMA DI TUTTO!

{costituzione}

---
*Costituzione caricata automaticamente da SubagentStart hook*
*"Senza costituzione meglio non fare nulla!"*
"""

        # Output JSON per hook - inietta nel contesto del subagent
        result = {
            "hookSpecificOutput": {
                "hookEventName": "SubagentStart",
                "additionalContext": context
            }
        }

        print(json.dumps(result))
        sys.exit(0)

    except Exception as e:
        # Fallback - non bloccare il subagent
        error_result = {
            "hookSpecificOutput": {
                "hookEventName": "SubagentStart",
                "additionalContext": f"Errore caricamento Costituzione: {str(e)}"
            }
        }
        print(json.dumps(error_result))
        sys.exit(0)


if __name__ == "__main__":
    main()
