#!/bin/bash
# Test: health-check.sh
# Verifica che lo script funzioni correttamente

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
HEALTH_CHECK="$PROJECT_ROOT/scripts/sncp/health-check.sh"

echo "=== TEST: health-check.sh ==="
echo ""

# Test 1: Script esiste
echo -n "1. Script esiste... "
if [[ -f "$HEALTH_CHECK" ]]; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

# Test 2: Script eseguibile
echo -n "2. Script eseguibile... "
if [[ -x "$HEALTH_CHECK" ]]; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

# Test 3: Esecuzione senza errori
echo -n "3. Esecuzione senza errori... "
if "$HEALTH_CHECK" > /dev/null 2>&1; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

# Test 4: Output contiene "SNCP Health"
echo -n "4. Output contiene 'SNCP Health'... "
OUTPUT=$("$HEALTH_CHECK" 2>&1)
if echo "$OUTPUT" | grep -q "SNCP"; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

echo ""
echo "=== TUTTI I TEST PASSATI ==="
