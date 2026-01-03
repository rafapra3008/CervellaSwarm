#!/bin/bash
#
# checklist-pre-merge.sh - 4 Quality Gates per CervellaSwarm
#
# Verifica 4 livelli di quality gate prima di un merge:
# GATE 1: SYNTAX - File sintatticamente corretti
# GATE 2: LINT - No errori critici di linting
# GATE 3: TESTS - Test esistenti passano
# GATE 4: REVIEW - Conferma umana richiesta
#
# Uso:
#   ./checklist-pre-merge.sh
#   ./checklist-pre-merge.sh --auto-fix    # Tenta fix automatico lint
#   ./checklist-pre-merge.sh --skip-tests  # Salta GATE 3 (solo per dev)
#
# Versione: 1.0.0
# Data: 2026-01-03
# Cervella & Rafa - CervellaSwarm
# Sprint 9.2 - Quick Wins per Apple Style

set -e

# ============================================================================
# CONFIGURAZIONE
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Colori
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Contatori
TOTAL_GATES=4
GATES_PASSED=0
GATES_FAILED=0

# Opzioni
AUTO_FIX=false
SKIP_TESTS=false

# ============================================================================
# FUNZIONI HELPER
# ============================================================================

print_header() {
    echo -e "${BOLD}${BLUE}"
    echo "╔══════════════════════════════════════════════════╗"
    echo "║         PRE-MERGE CHECKLIST - 4 GATES           ║"
    echo "╚══════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_gate_header() {
    local gate_num=$1
    local gate_name=$2
    echo ""
    echo -e "${BOLD}${PURPLE}GATE ${gate_num}: ${gate_name}${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

print_pass() {
    local message=$1
    echo -e "  ${GREEN}[PASS]${NC} ${message}"
}

print_fail() {
    local message=$1
    echo -e "  ${RED}[FAIL]${NC} ${message}"
}

print_warn() {
    local message=$1
    echo -e "  ${YELLOW}[WARN]${NC} ${message}"
}

print_wait() {
    local message=$1
    echo -e "  ${CYAN}[WAIT]${NC} ${message}"
}

gate_passed() {
    ((GATES_PASSED++))
}

gate_failed() {
    ((GATES_FAILED++))
}

ask_continue() {
    local gate_name=$1
    echo ""
    echo -e "${YELLOW}Gate ${gate_name} fallito.${NC}"
    read -p "Continuare comunque? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Merge bloccato.${NC}"
        exit 1
    fi
    echo -e "${YELLOW}Continuazione forzata.${NC}"
}

# ============================================================================
# GATE 1: SYNTAX CHECK
# ============================================================================

gate1_syntax_check() {
    print_gate_header "1" "SYNTAX CHECK"

    local errors_found=false

    # Check Python files
    local python_files=$(find "${PROJECT_ROOT}" -name "*.py" -not -path "*/\.*" 2>/dev/null || echo "")
    if [ -n "$python_files" ]; then
        local python_error=false
        while IFS= read -r file; do
            if ! python3 -m py_compile "$file" 2>/dev/null; then
                if [ "$python_error" = false ]; then
                    print_fail "Python syntax errors:"
                    python_error=true
                    errors_found=true
                fi
                echo "    - $(basename $file)"
            fi
        done <<< "$python_files"

        if [ "$python_error" = false ]; then
            print_pass "Python files OK"
        fi
    fi

    # Check Bash files
    local bash_files=$(find "${PROJECT_ROOT}/scripts" -name "*.sh" 2>/dev/null || echo "")
    if [ -n "$bash_files" ]; then
        local bash_error=false
        while IFS= read -r file; do
            if ! bash -n "$file" 2>/dev/null; then
                if [ "$bash_error" = false ]; then
                    print_fail "Bash syntax errors:"
                    bash_error=true
                    errors_found=true
                fi
                echo "    - $(basename $file)"
            fi
        done <<< "$bash_files"

        if [ "$bash_error" = false ]; then
            print_pass "Bash files OK"
        fi
    fi

    # Check JSON files (solo in directories importanti)
    local json_dirs=("${PROJECT_ROOT}/scripts" "${PROJECT_ROOT}/.swarm" "${PROJECT_ROOT}/docs")
    local json_count=0
    local json_error=false

    for dir in "${json_dirs[@]}"; do
        if [ -d "$dir" ]; then
            local json_files=$(find "$dir" -name "*.json" -type f 2>/dev/null || echo "")
            if [ -n "$json_files" ]; then
                while IFS= read -r file; do
                    ((json_count++))
                    if ! python3 -c "import json; json.load(open('$file'))" 2>/dev/null; then
                        if [ "$json_error" = false ]; then
                            print_fail "JSON syntax errors:"
                            json_error=true
                            errors_found=true
                        fi
                        echo "    - $(basename $file)"
                    fi
                done <<< "$json_files"
            fi
        fi
    done

    if [ $json_count -gt 0 ]; then
        if [ "$json_error" = false ]; then
            print_pass "JSON files OK ($json_count files)"
        fi
    fi

    # Risultato gate
    if [ "$errors_found" = true ]; then
        gate_failed
        ask_continue "SYNTAX"
    else
        gate_passed
    fi
}

# ============================================================================
# GATE 2: LINT CHECK
# ============================================================================

gate2_lint_check() {
    print_gate_header "2" "LINT CHECK"

    local errors_found=false
    local warnings_found=false

    # Check se esistono tool di linting
    local has_flake8=false
    local has_shellcheck=false

    if command -v flake8 &> /dev/null; then
        has_flake8=true
    fi

    if command -v shellcheck &> /dev/null; then
        has_shellcheck=true
    fi

    # Python linting (flake8)
    if [ "$has_flake8" = true ]; then
        local python_files=$(find "${PROJECT_ROOT}" -name "*.py" -not -path "*/\.*" 2>/dev/null || echo "")
        if [ -n "$python_files" ]; then
            # Solo errori critici (E, F)
            local lint_output=$(echo "$python_files" | xargs flake8 --select=E,F 2>&1 || true)
            if [ -n "$lint_output" ]; then
                print_fail "Python critical lint errors"
                if [ "$AUTO_FIX" = true ]; then
                    print_warn "Auto-fix non disponibile per flake8"
                fi
                echo "$lint_output" | head -10
                errors_found=true
            else
                print_pass "No critical Python errors"
            fi

            # Warning (W, C, N) - solo info
            local warnings=$(echo "$python_files" | xargs flake8 --select=W,C,N 2>&1 || true)
            if [ -n "$warnings" ]; then
                local warning_count=$(echo "$warnings" | wc -l | xargs)
                print_warn "Python warnings: ${warning_count} (non bloccanti)"
                warnings_found=true
            fi
        fi
    else
        print_warn "flake8 non installato - skip Python lint"
    fi

    # Bash linting (shellcheck)
    if [ "$has_shellcheck" = true ]; then
        local bash_files=$(find "${PROJECT_ROOT}/scripts" -name "*.sh" 2>/dev/null || echo "")
        if [ -n "$bash_files" ]; then
            local shellcheck_output=$(echo "$bash_files" | xargs shellcheck -S error 2>&1 || true)
            if [ -n "$shellcheck_output" ]; then
                print_fail "Bash critical lint errors"
                echo "$shellcheck_output" | head -10
                errors_found=true
            else
                print_pass "No critical Bash errors"
            fi
        fi
    else
        print_warn "shellcheck non installato - skip Bash lint"
    fi

    # Risultato gate
    if [ "$errors_found" = true ]; then
        gate_failed
        ask_continue "LINT"
    else
        gate_passed
        if [ "$warnings_found" = true ]; then
            print_warn "Gate passato ma con warning"
        fi
    fi
}

# ============================================================================
# GATE 3: TEST CHECK
# ============================================================================

gate3_test_check() {
    print_gate_header "3" "TEST CHECK"

    if [ "$SKIP_TESTS" = true ]; then
        print_warn "Test skippati (--skip-tests attivo)"
        gate_passed
        return
    fi

    local tests_found=false
    local tests_failed=false

    # Check pytest
    if [ -d "${PROJECT_ROOT}/tests" ]; then
        tests_found=true

        if command -v pytest &> /dev/null; then
            print_wait "Running pytest..."

            # Esegui pytest e cattura output
            if pytest "${PROJECT_ROOT}/tests" -v --tb=short 2>&1 | tee /tmp/pytest_output.txt; then
                local test_count=$(grep -c "PASSED" /tmp/pytest_output.txt 2>/dev/null || echo "0")
                print_pass "${test_count} tests passed"
            else
                local failed_count=$(grep -c "FAILED" /tmp/pytest_output.txt 2>/dev/null || echo "unknown")
                print_fail "Tests failed: ${failed_count}"
                echo ""
                echo "Failed tests:"
                grep "FAILED" /tmp/pytest_output.txt 2>/dev/null | head -5 || true
                tests_failed=true
            fi

            rm -f /tmp/pytest_output.txt
        else
            print_warn "pytest non installato - skip test Python"
        fi
    fi

    # Check Bash tests (se esistono)
    if [ -d "${PROJECT_ROOT}/tests/bash" ]; then
        tests_found=true
        local bash_test_files=$(find "${PROJECT_ROOT}/tests/bash" -name "test_*.sh" 2>/dev/null || echo "")
        if [ -n "$bash_test_files" ]; then
            local bash_failed=false
            while IFS= read -r test_file; do
                if ! bash "$test_file" > /dev/null 2>&1; then
                    if [ "$bash_failed" = false ]; then
                        print_fail "Bash tests failed:"
                        bash_failed=true
                        tests_failed=true
                    fi
                    echo "    - $(basename $test_file)"
                fi
            done <<< "$bash_test_files"

            if [ "$bash_failed" = false ]; then
                local bash_count=$(echo "$bash_test_files" | wc -l | xargs)
                print_pass "${bash_count} Bash tests passed"
            fi
        fi
    fi

    # Nessun test trovato
    if [ "$tests_found" = false ]; then
        print_warn "No tests found - gate passed by default"
        gate_passed
        return
    fi

    # Risultato gate
    if [ "$tests_failed" = true ]; then
        gate_failed
        ask_continue "TESTS"
    else
        gate_passed
    fi
}

# ============================================================================
# GATE 4: HUMAN REVIEW
# ============================================================================

gate4_human_review() {
    print_gate_header "4" "HUMAN REVIEW"

    print_wait "Waiting for human confirmation..."
    echo ""
    echo "Domande di review:"
    echo "  1. Hai verificato i file modificati?"
    echo "  2. Il codice è leggibile e ben documentato?"
    echo "  3. Non ci sono secret/credential committati?"
    echo "  4. I commit message sono chiari?"
    echo ""

    read -p "Tutte le verifiche sono OK? [y/N] " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_pass "Human review approved"
        gate_passed
    else
        print_fail "Human review rejected"
        gate_failed
        echo -e "${RED}Merge bloccato da review umana.${NC}"
        exit 1
    fi
}

# ============================================================================
# RIEPILOGO FINALE
# ============================================================================

print_summary() {
    echo ""
    echo -e "${BOLD}${BLUE}"
    echo "═══════════════════════════════════════════════════"
    if [ $GATES_PASSED -eq $TOTAL_GATES ]; then
        echo -e "${GREEN}RESULT: ${GATES_PASSED}/${TOTAL_GATES} GATES PASSED ✅${NC}"
    else
        echo -e "${YELLOW}RESULT: ${GATES_PASSED}/${TOTAL_GATES} GATES PASSED (${GATES_FAILED} failed)${NC}"
    fi
    echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════════${NC}"
    echo ""

    if [ $GATES_PASSED -eq $TOTAL_GATES ]; then
        echo -e "${GREEN}✅ Pronto per merge!${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  Alcuni gate falliti ma continuazione forzata${NC}"
        return 0
    fi
}

# ============================================================================
# PARSE OPZIONI
# ============================================================================

parse_options() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --auto-fix)
                AUTO_FIX=true
                shift
                ;;
            --skip-tests)
                SKIP_TESTS=true
                shift
                ;;
            --help|-h)
                echo "Uso: $0 [opzioni]"
                echo ""
                echo "Opzioni:"
                echo "  --auto-fix     Tenta fix automatico per lint (dove possibile)"
                echo "  --skip-tests   Salta GATE 3 (test) - solo per sviluppo"
                echo "  --help         Mostra questo help"
                echo ""
                exit 0
                ;;
            *)
                echo "Opzione sconosciuta: $1"
                echo "Usa --help per vedere le opzioni disponibili"
                exit 1
                ;;
        esac
    done
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    parse_options "$@"

    cd "${PROJECT_ROOT}"

    print_header

    # Esegui i 4 gate
    gate1_syntax_check
    gate2_lint_check
    gate3_test_check
    gate4_human_review

    # Riepilogo
    print_summary
}

main "$@"
