#!/bin/bash
# test_coordinamento_dipendenze.sh
# Suite di test per il sistema di coordinamento dipendenze
#
# CervellaSwarm - Hard Tests
# Data: 9 Gennaio 2026

set -e

# Colori
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/scripts"
TEST_PROJECT="$HOME/Developer/swarm-test-lab"
SWARM_DIR="$TEST_PROJECT/.swarm"

# Contatori
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Funzioni helper
log_test() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  TEST: $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

log_step() {
    echo -e "${BLUE}  → $1${NC}"
}

log_success() {
    echo -e "${GREEN}  ✓ $1${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

log_fail() {
    echo -e "${RED}  ✗ $1${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

cleanup() {
    log_step "Pulizia segnali di test..."
    rm -f "$SWARM_DIR/segnali/"*.signal.json 2>/dev/null || true
    rm -f "$SWARM_DIR/dipendenze/sessione_corrente.md" 2>/dev/null || true
}

# Header
echo ""
echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║                                                      ║${NC}"
echo -e "${BOLD}${CYAN}║   CERVELLASWARM - HARD TESTS                        ║${NC}"
echo -e "${BOLD}${CYAN}║   Sistema Coordinamento Dipendenze                  ║${NC}"
echo -e "${BOLD}${CYAN}║                                                      ║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Data:${NC} $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "${YELLOW}Progetto test:${NC} $TEST_PROJECT"
echo ""

# Verifica prerequisiti
log_step "Verifico prerequisiti..."
if [ ! -d "$TEST_PROJECT" ]; then
    echo -e "${RED}ERRORE: Progetto test non trovato: $TEST_PROJECT${NC}"
    exit 1
fi

if [ ! -d "$SWARM_DIR" ]; then
    echo -e "${RED}ERRORE: Directory .swarm non trovata${NC}"
    exit 1
fi

# Pulizia iniziale
cleanup

# ============================================================
# TEST 1: Check dipendenze - Task senza dipendenze
# ============================================================
log_test "1. Task senza dipendenze"
TESTS_RUN=$((TESTS_RUN + 1))

log_step "Eseguo check-dependencies.sh per TASK-001 (nessuna dipendenza)"

if "$SCRIPT_DIR/check-dependencies.sh" TASK-001 "$TEST_PROJECT" > /tmp/test1.out 2>&1; then
    if grep -q "Nessuna dipendenza" /tmp/test1.out || grep -q "Puoi iniziare" /tmp/test1.out; then
        log_success "TASK-001 può partire senza dipendenze"
    else
        log_fail "Output inatteso"
        cat /tmp/test1.out
    fi
else
    log_fail "Script fallito"
    cat /tmp/test1.out
fi

# ============================================================
# TEST 2: Check dipendenze - Task con dipendenza NON soddisfatta
# ============================================================
log_test "2. Task con dipendenza NON soddisfatta"
TESTS_RUN=$((TESTS_RUN + 1))

log_step "Eseguo check-dependencies.sh per TASK-002 (dipende da TASK-001)"

if TASK_DEPS="TASK-001" "$SCRIPT_DIR/check-dependencies.sh" TASK-002 "$TEST_PROJECT" > /tmp/test2.out 2>&1; then
    log_fail "Doveva fallire! La dipendenza non è soddisfatta"
    cat /tmp/test2.out
else
    if grep -q "IN ATTESA\|MANCANTI\|deve aspettare" /tmp/test2.out; then
        log_success "Correttamente rileva dipendenza mancante"
    else
        log_fail "Output inatteso"
        cat /tmp/test2.out
    fi
fi

# ============================================================
# TEST 3: Creazione segnale SUCCESS
# ============================================================
log_test "3. Creazione segnale SUCCESS"
TESTS_RUN=$((TESTS_RUN + 1))

log_step "Creo segnale TASK-001 success"

CERVELLA_AGENT=cervella-backend "$SCRIPT_DIR/create-signal.sh" TASK-001 success "API /users completata" abc123 "$TEST_PROJECT" > /tmp/test3.out 2>&1

SIGNAL_FILE="$SWARM_DIR/segnali/TASK-001-complete.signal.json"

if [ -f "$SIGNAL_FILE" ]; then
    # Verifica contenuto JSON
    if jq -e '.status == "success"' "$SIGNAL_FILE" > /dev/null 2>&1; then
        if jq -e '.type == "TASK_COMPLETE"' "$SIGNAL_FILE" > /dev/null 2>&1; then
            log_success "Segnale creato con formato corretto"
        else
            log_fail "Tipo segnale errato"
        fi
    else
        log_fail "Status non è success"
    fi
else
    log_fail "File segnale non creato"
fi

# ============================================================
# TEST 4: Check dipendenze - Task con dipendenza SODDISFATTA
# ============================================================
log_test "4. Task con dipendenza SODDISFATTA"
TESTS_RUN=$((TESTS_RUN + 1))

log_step "Eseguo check-dependencies.sh per TASK-002 (TASK-001 ora completato)"

if TASK_DEPS="TASK-001" "$SCRIPT_DIR/check-dependencies.sh" TASK-002 "$TEST_PROJECT" > /tmp/test4.out 2>&1; then
    if grep -q "SODDISFATTE\|puo' iniziare" /tmp/test4.out; then
        log_success "Correttamente rileva dipendenza soddisfatta"
    else
        log_fail "Output inatteso"
        cat /tmp/test4.out
    fi
else
    log_fail "Script fallito - dipendenza doveva essere soddisfatta"
    cat /tmp/test4.out
fi

# ============================================================
# TEST 5: Creazione segnale FAILURE
# ============================================================
log_test "5. Creazione segnale FAILURE"
TESTS_RUN=$((TESTS_RUN + 1))

log_step "Creo segnale TASK-002 failure"

CERVELLA_AGENT=cervella-frontend "$SCRIPT_DIR/create-signal.sh" TASK-002 failure "Build fallita" "" "$TEST_PROJECT" > /tmp/test5.out 2>&1

SIGNAL_FILE="$SWARM_DIR/segnali/TASK-002-complete.signal.json"

if [ -f "$SIGNAL_FILE" ]; then
    if jq -e '.status == "failure"' "$SIGNAL_FILE" > /dev/null 2>&1; then
        if jq -e '.type == "TASK_FAILED"' "$SIGNAL_FILE" > /dev/null 2>&1; then
            log_success "Segnale failure creato correttamente"
        else
            log_fail "Tipo doveva essere TASK_FAILED"
        fi
    else
        log_fail "Status doveva essere failure"
    fi
else
    log_fail "File segnale non creato"
fi

# ============================================================
# TEST 6: Check dipendenza con status FAILURE
# ============================================================
log_test "6. Check dipendenza con status FAILURE"
TESTS_RUN=$((TESTS_RUN + 1))

log_step "TASK-003 dipende da TASK-002 che è failure"

if TASK_DEPS="TASK-002" "$SCRIPT_DIR/check-dependencies.sh" TASK-003 "$TEST_PROJECT" > /tmp/test6.out 2>&1; then
    log_fail "Doveva fallire! TASK-002 è failure"
else
    if grep -q "non success\|MANCANTI" /tmp/test6.out; then
        log_success "Correttamente rileva che dipendenza è failure"
    else
        log_fail "Output inatteso"
        cat /tmp/test6.out
    fi
fi

# ============================================================
# TEST 7: Dipendenze MULTIPLE (Fan-in: A + B -> C)
# ============================================================
log_test "7. Dipendenze MULTIPLE (Fan-in)"
TESTS_RUN=$((TESTS_RUN + 1))

# Pulisci e ricrea
cleanup

log_step "Setup: TASK-004 dipende da TASK-A e TASK-B"

# Crea solo TASK-A
CERVELLA_AGENT=cervella-backend "$SCRIPT_DIR/create-signal.sh" TASK-A success "Parte A completata" aaa "$TEST_PROJECT" > /dev/null 2>&1

log_step "Solo TASK-A completato, TASK-B manca"

if TASK_DEPS="TASK-A,TASK-B" "$SCRIPT_DIR/check-dependencies.sh" TASK-004 "$TEST_PROJECT" > /tmp/test7a.out 2>&1; then
    log_fail "Doveva fallire! Manca TASK-B"
else
    if grep -q "TASK-A.*COMPLETATO" /tmp/test7a.out && grep -q "TASK-B.*ATTESA" /tmp/test7a.out; then
        log_success "Correttamente: A ok, B manca"
    else
        log_fail "Output inatteso"
        cat /tmp/test7a.out
    fi
fi

# Ora completa anche TASK-B
CERVELLA_AGENT=cervella-frontend "$SCRIPT_DIR/create-signal.sh" TASK-B success "Parte B completata" bbb "$TEST_PROJECT" > /dev/null 2>&1

log_step "Ora anche TASK-B completato"

if TASK_DEPS="TASK-A,TASK-B" "$SCRIPT_DIR/check-dependencies.sh" TASK-004 "$TEST_PROJECT" > /tmp/test7b.out 2>&1; then
    if grep -q "SODDISFATTE" /tmp/test7b.out; then
        log_success "Con entrambe le dipendenze soddisfatte: OK"
    else
        log_fail "Output inatteso"
        cat /tmp/test7b.out
    fi
else
    log_fail "Doveva passare! Entrambe le dipendenze sono OK"
    cat /tmp/test7b.out
fi

# ============================================================
# TEST 8: Segnale BLOCKED
# ============================================================
log_test "8. Creazione segnale BLOCKED"
TESTS_RUN=$((TESTS_RUN + 1))

log_step "Creo segnale blocked"

CERVELLA_AGENT=cervella-tester "$SCRIPT_DIR/create-signal.sh" TASK-005 blocked "In attesa di API esterna" "" "$TEST_PROJECT" > /tmp/test8.out 2>&1

SIGNAL_FILE="$SWARM_DIR/segnali/TASK-005-complete.signal.json"

if [ -f "$SIGNAL_FILE" ]; then
    if jq -e '.type == "TASK_BLOCKED"' "$SIGNAL_FILE" > /dev/null 2>&1; then
        log_success "Segnale blocked creato correttamente"
    else
        log_fail "Tipo doveva essere TASK_BLOCKED"
    fi
else
    log_fail "File segnale non creato"
fi

# ============================================================
# TEST 9: Formato JSON completo
# ============================================================
log_test "9. Verifica formato JSON completo"
TESTS_RUN=$((TESTS_RUN + 1))

log_step "Verifico tutti i campi richiesti nel segnale"

SIGNAL_FILE="$SWARM_DIR/segnali/TASK-A-complete.signal.json"

REQUIRED_FIELDS=("type" "task_id" "idempotency_key" "producer" "status" "output" "timestamp")
ALL_PRESENT=true

for field in "${REQUIRED_FIELDS[@]}"; do
    if ! jq -e ".$field" "$SIGNAL_FILE" > /dev/null 2>&1; then
        log_fail "Campo mancante: $field"
        ALL_PRESENT=false
    fi
done

if [ "$ALL_PRESENT" = true ]; then
    log_success "Tutti i campi richiesti presenti"
fi

# ============================================================
# TEST 10: Idempotency key unica
# ============================================================
log_test "10. Idempotency key unica"
TESTS_RUN=$((TESTS_RUN + 1))

log_step "Verifico che ogni segnale abbia UUID diverso"

KEY_A=$(jq -r '.idempotency_key' "$SWARM_DIR/segnali/TASK-A-complete.signal.json")
KEY_B=$(jq -r '.idempotency_key' "$SWARM_DIR/segnali/TASK-B-complete.signal.json")

if [ "$KEY_A" != "$KEY_B" ]; then
    log_success "Idempotency keys sono uniche"
else
    log_fail "Idempotency keys duplicate!"
fi

# ============================================================
# PULIZIA FINALE
# ============================================================
cleanup

# ============================================================
# RISULTATI
# ============================================================
echo ""
echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║                  RISULTATI TEST                      ║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Test eseguiti:${NC}  $TESTS_RUN"
echo -e "${GREEN}Test passati:${NC}   $TESTS_PASSED"
echo -e "${RED}Test falliti:${NC}   $TESTS_FAILED"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                      ║${NC}"
    echo -e "${GREEN}║   TUTTI I TEST PASSATI! SISTEMA VALIDATO!           ║${NC}"
    echo -e "${GREEN}║                                                      ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
    exit 0
else
    echo -e "${RED}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                                                      ║${NC}"
    echo -e "${RED}║   ALCUNI TEST FALLITI - VERIFICARE!                  ║${NC}"
    echo -e "${RED}║                                                      ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════════╝${NC}"
    exit 1
fi
