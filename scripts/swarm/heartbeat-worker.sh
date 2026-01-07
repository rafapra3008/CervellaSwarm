#!/bin/bash
#
# heartbeat-worker.sh - Scrive heartbeat ogni 60s per il worker
#
# Usage:
#   heartbeat-worker.sh TASK_ID
#
# Il script gira in background e scrive heartbeat ogni 60s.
# Per fermarlo: kill $(cat .swarm/heartbeat_[WORKER].pid)
#
# Versione: 1.0.0
# Data: 7 Gennaio 2026
# Cervella DevOps
#
# Basato su: Protocollo STATUS (sezione 2.4)

set -euo pipefail

# Colori
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Funzioni
error() {
  echo -e "${RED}Error: $1${NC}" >&2
  exit 1
}

usage() {
  echo "Usage: $0 TASK_ID"
  echo ""
  echo "Runs in background, writes heartbeat every 60s"
  echo "Stop with: kill \$(cat .swarm/heartbeat_[WORKER].pid)"
  echo ""
  echo "Example:"
  echo "  $0 TASK_001 &"
  exit 1
}

# Verifica parametri
if [ $# -lt 1 ]; then
  usage
fi

TASK_ID="$1"

# Detecta worker name
WORKER_NAME="${SWARM_WORKER_NAME:-unknown}"

# Verifica/Crea directory status
mkdir -p .swarm/status

# File paths
HEARTBEAT_FILE=".swarm/status/heartbeat_${WORKER_NAME}.log"
PID_FILE=".swarm/heartbeat_${WORKER_NAME}.pid"
STATUS_FILE=".swarm/status/${WORKER_NAME}.status"

# Verifica se già un heartbeat attivo
if [[ -f "$PID_FILE" ]]; then
  OLD_PID=$(cat "$PID_FILE")
  if ps -p "$OLD_PID" &>/dev/null; then
    echo -e "${YELLOW}Warning: Heartbeat già attivo (PID: $OLD_PID)${NC}"
    echo "Permetto comunque avvio (multi-task?)"
  fi
fi

# Salva PID
echo $$ > "$PID_FILE"

echo -e "${GREEN}✅ Heartbeat started${NC} for ${BLUE}${WORKER_NAME}${NC} (PID: $$)"
echo -e "${BLUE}📝 Writing to:${NC} $HEARTBEAT_FILE"

# Cleanup su exit
cleanup() {
  echo -e "\n${YELLOW}Stopping heartbeat...${NC}"

  # Scrivi ultimo heartbeat STOPPED
  TIMESTAMP=$(date +%s)
  echo "${TIMESTAMP}|${TASK_ID}|STOPPED|Heartbeat stopped" >> "$HEARTBEAT_FILE"

  # Rimuovi PID file
  rm -f "$PID_FILE"

  echo -e "${GREEN}✅ Heartbeat stopped${NC}"
  exit 0
}

trap cleanup SIGINT SIGTERM EXIT

# Loop infinito - heartbeat ogni 60s
while true; do
  TIMESTAMP=$(date +%s)

  # Leggi ultimo status (ultima riga del file status)
  STATUS="WORKING"
  NOTE=""

  if [[ -f "$STATUS_FILE" ]]; then
    LAST_STATUS=$(tail -n 1 "$STATUS_FILE" 2>/dev/null || echo "")
    if [[ -n "$LAST_STATUS" ]]; then
      # Parse: timestamp|stato|task_id|note
      STATUS=$(echo "$LAST_STATUS" | cut -d'|' -f2)
      NOTE=$(echo "$LAST_STATUS" | cut -d'|' -f4)
    fi
  fi

  # Scrivi heartbeat
  echo "${TIMESTAMP}|${TASK_ID}|${STATUS}|${NOTE}" >> "$HEARTBEAT_FILE"

  # Log locale (opzionale, solo se verbose)
  if [[ "${VERBOSE:-0}" == "1" ]]; then
    echo -e "${BLUE}[$(date +%H:%M:%S)]${NC} Heartbeat: ${STATUS} - ${NOTE}"
  fi

  # Sleep 60s
  sleep 60
done
