#!/bin/bash
# Test: verify-sync.sh
# Verifica che lo script funzioni correttamente

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VERIFY_SYNC="$PROJECT_ROOT/scripts/sncp/verify-sync.sh"
SYMLINK="$HOME/.local/bin/verify-sync"

echo "=== TEST: verify-sync.sh ==="
echo ""

# Test 1: Script esiste
echo -n "1. Script esiste... "
if [[ -f "$VERIFY_SYNC" ]]; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

# Test 2: Script eseguibile
echo -n "2. Script eseguibile... "
if [[ -x "$VERIFY_SYNC" ]]; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

# Test 3: Symlink esiste
echo -n "3. Symlink ~/.local/bin/verify-sync esiste... "
if [[ -L "$SYMLINK" ]]; then
    echo "OK"
else
    echo "FAIL - Symlink mancante!"
    exit 1
fi

# Test 4: --help funziona
echo -n "4. --help funziona... "
if "$VERIFY_SYNC" --help > /dev/null 2>&1; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

# Test 5: Output help contiene "Uso:"
echo -n "5. Output help contiene 'Uso:'... "
OUTPUT=$("$VERIFY_SYNC" --help 2>&1)
if echo "$OUTPUT" | grep -q "Uso:"; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

# Test 6: Comando globale funziona
echo -n "6. Comando 'verify-sync --help' funziona... "
if verify-sync --help > /dev/null 2>&1; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

# Test 7: Esecuzione su progetto reale (warning OK, solo verifico che esegue)
echo -n "7. Esecuzione su cervellaswarm... "
OUTPUT=$("$VERIFY_SYNC" cervellaswarm 2>&1) || true
if echo "$OUTPUT" | grep -q "cervellaswarm"; then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

echo ""
echo "=== TUTTI I TEST PASSATI ==="
