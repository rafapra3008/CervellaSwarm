#!/bin/bash
# Test: sncp-init.sh
# Verifica che lo script funzioni correttamente

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SNCP_INIT="$PROJECT_ROOT/scripts/sncp/sncp-init.sh"
SYMLINK="$HOME/.local/bin/sncp-init"

echo "=== TEST: sncp-init.sh ==="
echo ""

# Test 1: Script esiste
echo -n "1. Script esiste... "
if [[ -f "$SNCP_INIT" ]]; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

# Test 2: Script eseguibile
echo -n "2. Script eseguibile... "
if [[ -x "$SNCP_INIT" ]]; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

# Test 3: Symlink esiste
echo -n "3. Symlink ~/.local/bin/sncp-init esiste... "
if [[ -L "$SYMLINK" ]]; then
    echo "OK"
else
    echo "FAIL - Symlink mancante!"
    exit 1
fi

# Test 4: --help funziona
echo -n "4. --help funziona... "
if "$SNCP_INIT" --help > /dev/null 2>&1; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

# Test 5: Output help contiene "Uso:"
echo -n "5. Output help contiene 'Uso:'... "
OUTPUT=$("$SNCP_INIT" --help 2>&1)
if echo "$OUTPUT" | grep -q "Uso:"; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

# Test 6: Comando globale funziona
echo -n "6. Comando 'sncp-init --help' funziona... "
if sncp-init --help > /dev/null 2>&1; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

echo ""
echo "=== TUTTI I TEST PASSATI ==="
