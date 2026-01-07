#!/bin/bash
#
# update-status.sh - Helper per worker: aggiorna status file
#
# Usage:
#   update-status.sh STATUS "note"
#
# Example:
#   update-status.sh WORKING "Creating endpoints"
#   update-status.sh BLOCKED "Need help with authentication"
#
# Versione: 1.0.0
# Data: 7 Gennaio 2026
# Cervella DevOps
#
# Basato su: Protocollo STATUS (sezione 2.6)

set -euo pipefail

# Colori
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Stati validi
VALID_STATES=("READY" "WORKING" "BLOCKED" "DONE" "FAILED")

# Funzioni helper
error() {
  echo -e "${RED}Error: $1${NC}" >&2
  exit 1
}

usage() {
  echo "Usage: $0 STATUS \"note\""
  echo ""
  echo "Available states:"
  for state in "${VALID_STATES[@]}"; do
    echo "  - $state"
  done
  echo ""
  echo "Examples:"
  echo "  $0 WORKING \"Creating API endpoints\""
  echo "  $0 BLOCKED \"Need help with authentication\""
  echo "  $0 DONE \"Task completed successfully\""
  exit 1
}

# Verifica parametri
if [ $# -lt 1 ]; then
  usage
fi

STATUS="$1"
NOTE="${2:-}"

# Valida stato
is_valid_state() {
  local state="$1"
  for valid in "${VALID_STATES[@]}"; do
    if [[ "$valid" == "$state" ]]; then
      return 0
    fi
  done
  return 1
}

if ! is_valid_state "$STATUS"; then
  echo -e "${RED}Error: Invalid status '$STATUS'${NC}" >&2
  echo ""
  echo "Valid states:"
  for state in "${VALID_STATES[@]}"; do
    echo "  - $state"
  done
  exit 1
fi

# Warn se note vuota
if [[ -z "$NOTE" ]]; then
  echo -e "${YELLOW}Warning: Empty note${NC}"
fi

# Detecta worker name
WORKER_NAME=""

# 1. Prova env var
if [[ -n "${SWARM_WORKER_NAME:-}" ]]; then
  WORKER_NAME="$SWARM_WORKER_NAME"
# 2. Altrimenti usa "unknown"
else
  WORKER_NAME="unknown"
fi

# Leggi current task_id
TASK_ID="NONE"
if [[ -f ".swarm/current_task" ]]; then
  TASK_ID=$(cat .swarm/current_task)
fi

# Verifica/Crea directory status
mkdir -p .swarm/status

# Scrivi in status file
STATUS_FILE=".swarm/status/${WORKER_NAME}.status"
TIMESTAMP=$(date +%s)

echo "${TIMESTAMP}|${STATUS}|${TASK_ID}|${NOTE}" >> "$STATUS_FILE"

echo -e "${GREEN}✅ Status updated:${NC} ${BLUE}${WORKER_NAME}${NC} → ${YELLOW}${STATUS}${NC}"

# Notifica se BLOCKED o FAILED
if [[ "$STATUS" == "BLOCKED" ]] || [[ "$STATUS" == "FAILED" ]]; then
  if command -v osascript &>/dev/null; then
    osascript -e "display notification \"${WORKER_NAME}: ${NOTE}\" with title \"Worker ${STATUS}!\" sound name \"Basso\"" 2>/dev/null || true
    echo -e "${BLUE}🔔 Regina notified!${NC}"
  fi
fi
