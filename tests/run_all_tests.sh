#!/bin/bash
# ============================================================================
# CervellaSwarm - Test Runner
# ============================================================================
# Esegue tutti i test (bash e python).
#
# Uso:
#   ./run_all_tests.sh           # Esegue tutti i test
#   ./run_all_tests.sh --bash    # Solo test bash
#   ./run_all_tests.sh --python  # Solo test python
#
# Versione: 1.0.0
# Data: 2026-01-09
# ============================================================================

# Non usare set -e - gestiamo errori manualmente

# Colori
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Contatori globali
SUITES_PASSED=0
SUITES_FAILED=0

# ============================================================================
# FUNCTIONS
# ============================================================================

print_header() {
    echo ""
    echo -e "${PURPLE}=============================================="
    echo -e "  CervellaSwarm - Test Runner"
    echo -e "==============================================${NC}"
    echo ""
}

run_bash_tests() {
    echo -e "${BLUE}[BASH TESTS]${NC}"
    echo ""

    local bash_tests="${SCRIPT_DIR}/bash"

    if [[ ! -d "$bash_tests" ]]; then
        echo -e "${YELLOW}  No bash tests found${NC}"
        return 0
    fi

    for test_file in "$bash_tests"/test_*.sh; do
        if [[ -f "$test_file" ]]; then
            local test_name=$(basename "$test_file")
            echo -e "${BLUE}Running: ${test_name}${NC}"

            chmod +x "$test_file"

            if "$test_file"; then
                ((SUITES_PASSED++))
            else
                ((SUITES_FAILED++))
            fi
        fi
    done
}

run_python_tests() {
    echo -e "${BLUE}[PYTHON TESTS]${NC}"
    echo ""

    local python_tests="${SCRIPT_DIR}/python"

    if [[ ! -d "$python_tests" ]]; then
        echo -e "${YELLOW}  No python tests found${NC}"
        return 0
    fi

    # Check if pytest is available
    if command -v pytest &>/dev/null; then
        if pytest "$python_tests" -v 2>/dev/null; then
            ((SUITES_PASSED++))
        else
            ((SUITES_FAILED++))
        fi
    elif command -v python3 &>/dev/null; then
        # Fallback to running test files directly
        for test_file in "$python_tests"/test_*.py; do
            if [[ -f "$test_file" ]]; then
                local test_name=$(basename "$test_file")
                echo -e "${BLUE}Running: ${test_name}${NC}"

                if python3 "$test_file"; then
                    ((SUITES_PASSED++))
                else
                    ((SUITES_FAILED++))
                fi
            fi
        done
    else
        echo -e "${YELLOW}  Python not found, skipping python tests${NC}"
    fi
}

print_summary() {
    echo ""
    echo -e "${PURPLE}=============================================="
    echo -e "  FINAL SUMMARY"
    echo -e "==============================================${NC}"
    echo ""
    echo -e "  Test suites passed: ${GREEN}${SUITES_PASSED}${NC}"
    echo -e "  Test suites failed: ${RED}${SUITES_FAILED}${NC}"
    echo ""

    if [[ $SUITES_FAILED -gt 0 ]]; then
        echo -e "${RED}  SOME TESTS FAILED!${NC}"
        return 1
    else
        echo -e "${GREEN}  ALL TESTS PASSED!${NC}"
        return 0
    fi
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    print_header

    local run_bash=true
    local run_python=true

    # Parse args
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --bash)
                run_python=false
                ;;
            --python)
                run_bash=false
                ;;
            --help|-h)
                echo "Usage: $0 [--bash] [--python]"
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
        shift
    done

    # Run tests
    if $run_bash; then
        run_bash_tests
    fi

    if $run_python; then
        run_python_tests
    fi

    # Summary
    print_summary
}

main "$@"
