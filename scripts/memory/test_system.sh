#!/bin/bash
# Test Sistema Memoria CervellaSwarm
# Verifica che tutti i componenti funzionino correttamente

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_PATH="$SCRIPT_DIR/../../data/swarm_memory.db"

echo "🧪 Test Sistema Memoria CervellaSwarm"
echo "======================================"
echo ""

# Cleanup test precedenti
if [ -f "$DB_PATH" ]; then
    echo "🧹 Rimuovo database precedente..."
    rm "$DB_PATH"
fi

# Test 1: Inizializzazione
echo "✅ Test 1: Inizializzazione database"
"$SCRIPT_DIR/init_db.py" > /dev/null 2>&1
if [ ! -f "$DB_PATH" ]; then
    echo "❌ Database non creato!"
    exit 1
fi
echo "   ✓ Database creato"

# Test 2: Log eventi
echo "✅ Test 2: Log eventi"

# Evento 1: cervella-frontend
echo '{
  "tool": {"name": "cervella-frontend", "input": {"task": "Test frontend"}},
  "result": {"file_path": "/test/app.js"},
  "context": {"cwd": "/Users/test/miracollo", "session_id": "test-1"}
}' | "$SCRIPT_DIR/log_event.py" > /dev/null
echo "   ✓ Evento cervella-frontend loggato"

# Evento 2: cervella-backend
echo '{
  "tool": {"name": "cervella-backend", "input": {"task": "Test backend"}},
  "result": {"file_path": "/test/api.py"},
  "context": {"cwd": "/Users/test/miracollo", "session_id": "test-1"}
}' | "$SCRIPT_DIR/log_event.py" > /dev/null
echo "   ✓ Evento cervella-backend loggato"

# Evento 3: cervella-tester
echo '{
  "tool": {"name": "cervella-tester", "input": {"task": "Test QA"}},
  "result": {},
  "context": {"cwd": "/Users/test/contabilita", "session_id": "test-2"}
}' | "$SCRIPT_DIR/log_event.py" > /dev/null
echo "   ✓ Evento cervella-tester loggato"

# Test 3: Query eventi
echo "✅ Test 3: Query database"
STATS=$("$SCRIPT_DIR/query_events.py" --stats 2>/dev/null)
if [[ $STATS == *"total_events"* ]]; then
    echo "   ✓ Query statistiche funziona"
else
    echo "❌ Query statistiche fallita!"
    exit 1
fi

RECENT=$("$SCRIPT_DIR/query_events.py" --recent 1 2>/dev/null)
if [[ $RECENT == *"agent"* ]]; then
    echo "   ✓ Query eventi recenti funziona"
else
    echo "❌ Query eventi recenti fallita!"
    exit 1
fi

# Test 4: Load context
echo "✅ Test 4: Caricamento contesto"
CONTEXT=$("$SCRIPT_DIR/load_context.py" 2>/dev/null)
if [[ $CONTEXT == *"hookSpecificOutput"* ]]; then
    echo "   ✓ Load context funziona"
else
    echo "❌ Load context fallito!"
    exit 1
fi

# Test 5: Verifica dati
echo "✅ Test 5: Verifica dati salvati"
EVENT_COUNT=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM swarm_events;")
if [ "$EVENT_COUNT" -eq 3 ]; then
    echo "   ✓ Tutti e 3 gli eventi salvati"
else
    echo "❌ Eventi attesi: 3, trovati: $EVENT_COUNT"
    exit 1
fi

AGENT_COUNT=$(sqlite3 "$DB_PATH" "SELECT COUNT(DISTINCT agent_name) FROM swarm_events;")
if [ "$AGENT_COUNT" -eq 3 ]; then
    echo "   ✓ Tutti e 3 gli agent tracciati"
else
    echo "❌ Agent attesi: 3, trovati: $AGENT_COUNT"
    exit 1
fi

# Summary
echo ""
echo "🎉 Tutti i test passati!"
echo ""
echo "📊 Statistiche finali:"
"$SCRIPT_DIR/query_events.py" --stats 2>/dev/null | grep -A 10 "{"

echo ""
echo "✅ Sistema Memoria funzionante al 100%!"
