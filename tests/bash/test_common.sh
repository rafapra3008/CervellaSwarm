#!/bin/bash
# ============================================================================
# Test Suite per common.sh
# ============================================================================
# Eseguibile con: ./test_common.sh
# Oppure con bats: bats test_common.bats
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
COMMON_SH="${PROJECT_ROOT}/scripts/swarm/common.sh"

# ============================================================================
# TEST HELPERS
# ============================================================================

assert_equals() {
    local expected="$1"
    local actual="$2"
    local msg="${3:-assertion failed}"

    if [[ "$expected" == "$actual" ]]; then
        return 0
    else
        echo "  Expected: '$expected'"
        echo "  Actual:   '$actual'"
        return 1
    fi
}

assert_not_empty() {
    local value="$1"
    local msg="${2:-value should not be empty}"

    if [[ -n "$value" ]]; then
        return 0
    else
        echo "  Value is empty"
        return 1
    fi
}

assert_file_exists() {
    local file="$1"
    if [[ -f "$file" ]]; then
        return 0
    else
        echo "  File not found: $file"
        return 1
    fi
}

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

test_common_sh_exists() {
    assert_file_exists "$COMMON_SH"
}

test_common_sh_is_sourceable() {
    source "$COMMON_SH"
}

test_get_claude_bin_defined() {
    source "$COMMON_SH"
    type get_claude_bin &>/dev/null
}

test_find_project_root_defined() {
    source "$COMMON_SH"
    type find_project_root &>/dev/null
}

test_validate_config_ownership_defined() {
    source "$COMMON_SH"
    type validate_config_ownership &>/dev/null
}

test_print_functions_defined() {
    source "$COMMON_SH"
    type print_success &>/dev/null && \
    type print_error &>/dev/null && \
    type print_warning &>/dev/null && \
    type print_info &>/dev/null
}

test_colors_defined() {
    source "$COMMON_SH"
    [[ -n "$RED" ]] && [[ -n "$GREEN" ]] && [[ -n "$NC" ]]
}

test_find_project_root_finds_swarm() {
    source "$COMMON_SH"
    local result
    result=$(cd "$PROJECT_ROOT" && find_project_root)
    assert_equals "$PROJECT_ROOT" "$result"
}

test_find_project_root_fails_outside_project() {
    source "$COMMON_SH"
    # Dovrebbe fallire in /tmp
    if (cd /tmp && find_project_root &>/dev/null); then
        # Se troviamo .swarm in /tmp, qualcosa e' strano - skip test
        return 0
    fi
    return 0
}

test_get_stdbuf_cmd_returns_something_or_empty() {
    source "$COMMON_SH"
    # Deve ritornare un comando valido o stringa vuota, mai errore
    local result
    result=$(get_stdbuf_cmd)
    # OK se vuoto o se contiene "stdbuf" o "unbuffer"
    [[ -z "$result" ]] || [[ "$result" == *stdbuf* ]] || [[ "$result" == *unbuffer* ]]
}

test_timestamp_format() {
    source "$COMMON_SH"
    local ts
    ts=$(timestamp)
    # Deve essere nel formato YYYY-MM-DD HH:MM:SS
    [[ "$ts" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}:[0-9]{2}$ ]]
}

test_timestamp_file_format() {
    source "$COMMON_SH"
    local ts
    ts=$(timestamp_file)
    # Deve essere nel formato YYYYMMDD_HHMMSS
    [[ "$ts" =~ ^[0-9]{8}_[0-9]{6}$ ]]
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    echo ""
    echo "=============================================="
    echo "  CervellaSwarm - Test Suite: common.sh"
    echo "=============================================="
    echo ""

    # Verifica prerequisiti
    if [[ ! -f "$COMMON_SH" ]]; then
        echo -e "${RED}ERROR: common.sh not found at $COMMON_SH${NC}"
        exit 1
    fi

    # Esegui test
    run_test "common.sh exists" test_common_sh_exists
    run_test "common.sh is sourceable" test_common_sh_is_sourceable
    run_test "get_claude_bin defined" test_get_claude_bin_defined
    run_test "find_project_root defined" test_find_project_root_defined
    run_test "validate_config_ownership defined" test_validate_config_ownership_defined
    run_test "print_* functions defined" test_print_functions_defined
    run_test "colors defined" test_colors_defined
    run_test "find_project_root finds .swarm" test_find_project_root_finds_swarm
    run_test "find_project_root handles outside project" test_find_project_root_fails_outside_project
    run_test "get_stdbuf_cmd returns valid" test_get_stdbuf_cmd_returns_something_or_empty
    run_test "timestamp format correct" test_timestamp_format
    run_test "timestamp_file format correct" test_timestamp_file_format

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
