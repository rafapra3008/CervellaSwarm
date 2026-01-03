#!/bin/bash
# triple-ack.sh - Helper per Triple ACK pattern
#
# Pattern Apple Style per confermare task:
# 1. ACK_RECEIVED - "Ho ricevuto il task"
# 2. ACK_UNDERSTOOD - "Ho capito cosa fare"
# 3. ACK_COMPLETED - "Ho finito" (equivale a .done)
#
# Uso:
#   ./triple-ack.sh received TASK_001
#   ./triple-ack.sh understood TASK_001
#   ./triple-ack.sh status TASK_001
#
# Versione: 2.0.0
# Data: 2026-01-03
# Cervella Backend & Rafa
# "Integrato con task_manager.py - file marker system"

__version__="2.0.0"
__version_date__="2026-01-03"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
TASK_MANAGER="${SCRIPT_DIR}/task_manager.py"

# Colors per output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

case "$1" in
    received)
        if [ -z "$2" ]; then
            echo "Uso: $0 received TASK_ID"
            exit 1
        fi
        python3 "${TASK_MANAGER}" ack-received "$2"
        echo -e "${GREEN}✓ ACK_RECEIVED: $2${NC}"
        ;;

    understood)
        if [ -z "$2" ]; then
            echo "Uso: $0 understood TASK_ID"
            exit 1
        fi
        python3 "${TASK_MANAGER}" ack-understood "$2"
        echo -e "${GREEN}✓ ACK_UNDERSTOOD: $2${NC}"
        ;;

    status)
        if [ -z "$2" ]; then
            echo "Uso: $0 status TASK_ID"
            exit 1
        fi
        TASK_DIR="${PROJECT_ROOT}/.swarm/tasks"
        echo -e "${BLUE}ACK Status for $2:${NC}"
        echo "-------------------"
        if [ -f "${TASK_DIR}/$2.ack_received" ]; then
            echo -e "  ${GREEN}[✓]${NC} RECEIVED"
        else
            echo -e "  ${YELLOW}[ ]${NC} RECEIVED"
        fi

        if [ -f "${TASK_DIR}/$2.ack_understood" ]; then
            echo -e "  ${GREEN}[✓]${NC} UNDERSTOOD"
        else
            echo -e "  ${YELLOW}[ ]${NC} UNDERSTOOD"
        fi

        if [ -f "${TASK_DIR}/$2.done" ]; then
            echo -e "  ${GREEN}[✓]${NC} COMPLETED"
        else
            echo -e "  ${YELLOW}[ ]${NC} COMPLETED"
        fi
        ;;

    help|--help|-h)
        echo "triple-ack.sh - Helper per Triple ACK pattern"
        echo ""
        echo "Uso:"
        echo "  $0 received TASK_ID     - Segna task come ricevuto"
        echo "  $0 understood TASK_ID   - Segna task come capito"
        echo "  $0 status TASK_ID       - Mostra stato ACK del task"
        echo "  $0 help                 - Mostra questo help"
        echo ""
        echo "Pattern Triple ACK:"
        echo "  1. RECEIVED    - Worker ha ricevuto il task"
        echo "  2. UNDERSTOOD  - Worker ha capito cosa fare"
        echo "  3. COMPLETED   - Worker ha completato (.done)"
        echo ""
        echo "Integrazione:"
        echo "  Usa task_manager.py per i file marker (.ack_received, .ack_understood)"
        echo ""
        ;;

    *)
        echo "Errore: Comando non valido '$1'"
        echo ""
        echo "Uso: $0 {received|understood|status|help} TASK_ID"
        echo "Usa '$0 help' per maggiori informazioni"
        exit 1
        ;;
esac
