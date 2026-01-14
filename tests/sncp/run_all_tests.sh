#!/bin/bash
# Runner: Esegue tutti i test SNCP
# Uso: ./tests/sncp/run_all_tests.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    SNCP TEST SUITE                             ║"
echo "║                    CervellaSwarm                               ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

PASSED=0
FAILED=0

for test_file in "$SCRIPT_DIR"/test_*.sh; do
    if [[ -f "$test_file" && "$test_file" != *"run_all"* ]]; then
        echo "----------------------------------------"
        echo "Running: $(basename "$test_file")"
        echo "----------------------------------------"

        if bash "$test_file"; then
            ((PASSED++))
        else
            ((FAILED++))
            echo "FAILED: $test_file"
        fi
        echo ""
    fi
done

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    RISULTATI                                   ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║  Test passati:  $PASSED                                              ║"
echo "║  Test falliti:  $FAILED                                              ║"
echo "╚════════════════════════════════════════════════════════════════╝"

if [[ $FAILED -gt 0 ]]; then
    echo ""
    echo "ALCUNI TEST SONO FALLITI!"
    exit 1
else
    echo ""
    echo "TUTTI I TEST PASSATI!"
    exit 0
fi
