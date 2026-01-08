#!/bin/bash
# create-signal.sh - Crea segnale JSON strutturato
# Usato dalle Cervelle per segnalare completamento task
#
# Uso: create-signal.sh TASK_ID STATUS "DESCRIPTION" [COMMIT] [PROJECT_PATH]
#
# Esempi:
#   create-signal.sh TASK-001 success "API /users completata" abc123
#   create-signal.sh TASK-002 failure "Test fallito" "" /path/to/project
#   create-signal.sh TASK-003 blocked "Aspetto risposta API esterna"
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
STATUS="${2:-}"
DESCRIPTION="${3:-}"
COMMIT="${4:-}"
PROJECT_PATH="${5:-.}"

# Validazione
if [ -z "$TASK_ID" ] || [ -z "$STATUS" ]; then
    echo -e "${RED}ERRORE: Parametri mancanti${NC}"
    echo ""
    echo "Uso: create-signal.sh TASK_ID STATUS \"DESCRIPTION\" [COMMIT] [PROJECT_PATH]"
    echo ""
    echo "Parametri:"
    echo "  TASK_ID      - ID del task (es: TASK-001)"
    echo "  STATUS       - success | failure | blocked"
    echo "  DESCRIPTION  - Descrizione di cosa e' stato fatto"
    echo "  COMMIT       - Hash del commit (opzionale)"
    echo "  PROJECT_PATH - Path al progetto (default: .)"
    echo ""
    echo "Esempi:"
    echo "  create-signal.sh TASK-001 success \"API completata\" abc123"
    echo "  create-signal.sh TASK-002 failure \"Build fallita\""
    exit 1
fi

# Valida STATUS
if [[ ! "$STATUS" =~ ^(success|failure|blocked)$ ]]; then
    echo -e "${RED}ERRORE: STATUS deve essere: success, failure, o blocked${NC}"
    exit 1
fi

# Setup paths
PROJECT_PATH=$(cd "$PROJECT_PATH" && pwd)
SIGNALS_DIR="$PROJECT_PATH/.swarm/segnali"

# Crea directory se non esiste
mkdir -p "$SIGNALS_DIR"

# Genera UUID per idempotency
IDEMPOTENCY_KEY=$(uuidgen 2>/dev/null || cat /proc/sys/kernel/random/uuid 2>/dev/null || echo "$(date +%s)-$$")

# Timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Determina producer (da variabili ambiente o default)
AGENT_NAME="${CERVELLA_AGENT:-unknown}"
WORKTREE_NAME="${CERVELLA_WORKTREE:-$(basename "$PROJECT_PATH")}"
BRANCH_NAME=$(git -C "$PROJECT_PATH" branch --show-current 2>/dev/null || echo "unknown")

# Tipo segnale basato su status
case "$STATUS" in
    success) TYPE="TASK_COMPLETE" ;;
    failure) TYPE="TASK_FAILED" ;;
    blocked) TYPE="TASK_BLOCKED" ;;
esac

# Trova file modificati (ultimi 10 minuti)
FILES_MODIFIED=$(git -C "$PROJECT_PATH" diff --name-only HEAD~1 2>/dev/null | head -10 | jq -R -s -c 'split("\n") | map(select(length > 0))' 2>/dev/null || echo "[]")

# Costruisci JSON
SIGNAL_FILE="$SIGNALS_DIR/${TASK_ID}-complete.signal.json"

cat > "$SIGNAL_FILE" << EOF
{
  "type": "$TYPE",
  "task_id": "$TASK_ID",
  "idempotency_key": "$IDEMPOTENCY_KEY",

  "producer": {
    "agent": "$AGENT_NAME",
    "worktree": "$WORKTREE_NAME",
    "branch": "$BRANCH_NAME"
  },

  "status": "$STATUS",

  "output": {
    "description": "$DESCRIPTION",
    "files_modified": $FILES_MODIFIED,
    "commit": "$COMMIT"
  },

  "timestamp": "$TIMESTAMP"
}
EOF

# Output
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   SEGNALE CREATO!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${CYAN}Task ID:${NC}     $TASK_ID"
echo -e "${CYAN}Status:${NC}      $([ "$STATUS" = "success" ] && echo -e "${GREEN}$STATUS${NC}" || echo -e "${RED}$STATUS${NC}")"
echo -e "${CYAN}File:${NC}        $SIGNAL_FILE"
echo -e "${CYAN}Timestamp:${NC}   $TIMESTAMP"
echo ""

# Mostra contenuto
echo -e "${YELLOW}Contenuto segnale:${NC}"
echo "----------------------------------------"
cat "$SIGNAL_FILE"
echo ""
echo "----------------------------------------"
echo ""
echo -e "${GREEN}Segnale creato con successo!${NC}"
echo -e "Le Cervelle in attesa verranno notificate."
