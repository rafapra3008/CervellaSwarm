#!/bin/bash
# ============================================================================
# Test Suite per spawn-workers.sh
# ============================================================================
# Eseguibile con: ./test_spawn_workers.sh
#
# Versione: 1.0.0
# Data: 2026-01-09
# ============================================================================

# Non usare set -e qui - gestiamo gli errori manualmente nei test

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Contatori
TESTS_PASSED=0
TESTS_FAILED=0

# Path assoluto allo script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
SPAWN_WORKERS="${PROJECT_ROOT}/scripts/swarm/spawn-workers.sh"

# ============================================================================
# TEST HELPERS
# ============================================================================

run_test() {
    local test_name="$1"
    local test_func="$2"

    echo -n "Testing: ${test_name}... "

    if $test_func 2>/dev/null; then
        echo -e "${GREEN}PASS${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}FAIL${NC}"
        ((TESTS_FAILED++))
    fi
}

# ============================================================================
# TESTS
# ============================================================================

test_script_exists() {
    [[ -f "$SPAWN_WORKERS" ]]
}

test_script_is_executable() {
    [[ -x "$SPAWN_WORKERS" ]]
}

test_help_option() {
    "$SPAWN_WORKERS" --help &>/dev/null
}

test_list_option() {
    local output
    output=$("$SPAWN_WORKERS" --list 2>&1)
    [[ "$output" == *"backend"* ]] && [[ "$output" == *"frontend"* ]]
}

test_list_shows_guardiane() {
    local output
    output=$("$SPAWN_WORKERS" --list 2>&1)
    [[ "$output" == *"guardiana-qualita"* ]]
}

test_unknown_option_fails() {
    # Deve fallire con opzione sconosciuta
    if "$SPAWN_WORKERS" --unknown-option-xyz 2>&1; then
        return 1
    fi
    return 0
}

test_outside_project_fails() {
    # Deve fallire fuori da un progetto con .swarm/
    local output
    if output=$(cd /tmp && "$SPAWN_WORKERS" --list 2>&1); then
        # Se e' riuscito, controlliamo se ha dato errore
        [[ "$output" == *"Non sei in un progetto"* ]]
    else
        # Fallito come previsto
        return 0
    fi
}

test_no_spawn_without_swarm() {
    # Non deve creare .swarm/ in /tmp
    local tmp_test="/tmp/test_spawn_workers_$$"
    mkdir -p "$tmp_test"

    # Prova a eseguire
    (cd "$tmp_test" && "$SPAWN_WORKERS" --backend 2>&1) || true

    # Verifica che NON abbia creato .swarm/
    if [[ -d "${tmp_test}/.swarm" ]]; then
        rm -rf "$tmp_test"
        return 1
    fi

    rm -rf "$tmp_test"
    return 0
}

test_version_in_script() {
    grep -q "Versione:" "$SPAWN_WORKERS"
}

test_set_e_enabled() {
    # Lo script deve avere set -e per sicurezza
    grep -q "^set -e" "$SPAWN_WORKERS"
}

test_common_sh_sourced() {
    # Deve fare source di common.sh
    grep -q "source.*common.sh" "$SPAWN_WORKERS"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    echo ""
    echo "=============================================="
    echo "  CervellaSwarm - Test Suite: spawn-workers.sh"
    echo "=============================================="
    echo ""

    # Verifica prerequisiti
    if [[ ! -f "$SPAWN_WORKERS" ]]; then
        echo -e "${RED}ERROR: spawn-workers.sh not found${NC}"
        exit 1
    fi

    # Esegui test
    run_test "script exists" test_script_exists
    run_test "script is executable" test_script_is_executable
    run_test "--help option works" test_help_option
    run_test "--list shows workers" test_list_option
    run_test "--list shows guardiane" test_list_shows_guardiane
    run_test "unknown option fails" test_unknown_option_fails
    run_test "fails outside project" test_outside_project_fails
    run_test "no .swarm/ created in wrong dir" test_no_spawn_without_swarm
    run_test "version in script" test_version_in_script
    run_test "set -e enabled" test_set_e_enabled
    run_test "common.sh sourced" test_common_sh_sourced

    # Risultati
    echo ""
    echo "=============================================="
    echo -e "  Results: ${GREEN}${TESTS_PASSED} passed${NC}, ${RED}${TESTS_FAILED} failed${NC}"
    echo "=============================================="
    echo ""

    # Exit code
    if [[ $TESTS_FAILED -gt 0 ]]; then
        exit 1
    fi
    exit 0
}

main "$@"
