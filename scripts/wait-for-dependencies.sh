#!/bin/bash
# wait-for-dependencies.sh - Aspetta che le dipendenze siano soddisfatte
# Con timeout e retry
#
# Uso: wait-for-dependencies.sh TASK_ID [TIMEOUT_MIN] [PROJECT_PATH]
#
# Esempi:
#   wait-for-dependencies.sh TASK-002           # Default 30 min timeout
#   wait-for-dependencies.sh TASK-002 60        # 60 min timeout
#   TASK_DEPS="TASK-001" wait-for-dependencies.sh TASK-002
#
# CervellaSwarm Multi-Instance Coordination v2.0

set -e

# Colori
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Parametri
TASK_ID="${1:-}"
TIMEOUT_MIN="${2:-30}"
PROJECT_PATH="${3:-.}"

# Script directory (per chiamare check-dependencies.sh)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Validazione
if [ -z "$TASK_ID" ]; then
    echo -e "${RED}ERRORE: TASK_ID mancante${NC}"
    echo ""
    echo "Uso: wait-for-dependencies.sh TASK_ID [TIMEOUT_MIN] [PROJECT_PATH]"
    exit 1
fi

# Setup
PROJECT_PATH=$(cd "$PROJECT_PATH" && pwd)
TIMEOUT_SEC=$((TIMEOUT_MIN * 60))
CHECK_INTERVAL=10  # Secondi tra un check e l'altro
START_TIME=$(date +%s)

# Header
echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}   ATTESA DIPENDENZE: $TASK_ID${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${YELLOW}Timeout:${NC} $TIMEOUT_MIN minuti"
echo -e "${YELLOW}Check ogni:${NC} $CHECK_INTERVAL secondi"
echo ""

# Funzione per calcolare tempo trascorso
elapsed_time() {
    local now=$(date +%s)
    echo $((now - START_TIME))
}

# Funzione per formattare tempo
format_time() {
    local seconds=$1
    local min=$((seconds / 60))
    local sec=$((seconds % 60))
    printf "%02d:%02d" $min $sec
}

# Loop di attesa
ATTEMPT=0
while true; do
    ATTEMPT=$((ATTEMPT + 1))
    ELAPSED=$(elapsed_time)

    # Check timeout
    if [ $ELAPSED -ge $TIMEOUT_SEC ]; then
        echo ""
        echo -e "${RED}========================================${NC}"
        echo -e "${RED}   TIMEOUT!${NC}"
        echo -e "${RED}========================================${NC}"
        echo ""
        echo -e "Tempo trascorso: $(format_time $ELAPSED)"
        echo -e "Timeout: $TIMEOUT_MIN minuti"
        echo ""
        echo -e "${RED}Le dipendenze non sono state soddisfatte in tempo.${NC}"
        echo ""
        exit 2
    fi

    # Status
    echo -e "[$(format_time $ELAPSED)] Tentativo $ATTEMPT - Verifico dipendenze..."

    # Esegui check (esporta TASK_DEPS se presente)
    if TASK_DEPS="$TASK_DEPS" "$SCRIPT_DIR/check-dependencies.sh" "$TASK_ID" "$PROJECT_PATH" > /dev/null 2>&1; then
        echo ""
        echo -e "${GREEN}========================================${NC}"
        echo -e "${GREEN}   DIPENDENZE SODDISFATTE!${NC}"
        echo -e "${GREEN}========================================${NC}"
        echo ""
        echo -e "Tempo atteso: $(format_time $ELAPSED)"
        echo -e "Tentativi: $ATTEMPT"
        echo ""
        echo -e "${GREEN}$TASK_ID puo' iniziare!${NC}"
        echo ""
        exit 0
    fi

    # Calcola tempo rimanente
    REMAINING=$((TIMEOUT_SEC - ELAPSED))
    REMAINING_MIN=$((REMAINING / 60))

    echo -e "  ${YELLOW}Dipendenze non ancora pronte. Riprovo tra ${CHECK_INTERVAL}s (rimangono ~${REMAINING_MIN} min)${NC}"

    # Attendi
    sleep $CHECK_INTERVAL
done
