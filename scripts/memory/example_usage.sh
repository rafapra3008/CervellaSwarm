#!/bin/bash
# Esempio di utilizzo Sistema Memoria CervellaSwarm

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🐝 CervellaSwarm - Esempio Utilizzo Sistema Memoria"
echo "======================================================"
echo ""

# 1. Inizializzazione (da fare UNA VOLTA)
echo "📋 Step 1: Inizializzazione (se non già fatto)"
echo "   ./scripts/memory/init_db.py"
echo ""

# 2. Log evento (automatico da hook)
echo "📋 Step 2: Log evento (automatico da PostToolUse hook)"
echo "   echo '{...payload...}' | ./scripts/memory/log_event.py"
echo ""

# 3. Query esempi
echo "📋 Step 3: Query database"
echo ""

echo "   🔹 Ultimi 10 eventi:"
"$SCRIPT_DIR/query_events.py" --recent 10 2>/dev/null | head -20
echo ""

echo "   🔹 Statistiche generali:"
"$SCRIPT_DIR/query_events.py" --stats 2>/dev/null
echo ""

echo "   🔹 Eventi per agent specifico:"
echo "      ./scripts/memory/query_events.py --agent cervella-frontend"
echo ""

echo "   🔹 Eventi per progetto:"
echo "      ./scripts/memory/query_events.py --project miracollo"
echo ""

echo "   🔹 Task falliti:"
echo "      ./scripts/memory/query_events.py --failed"
echo ""

echo "📋 Step 4: Load contesto (automatico da SessionStart hook)"
echo "   ./scripts/memory/load_context.py"
echo ""

echo "✅ Per documentazione completa: cat scripts/memory/README.md"
