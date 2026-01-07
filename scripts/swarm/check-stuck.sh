#!/bin/bash
#
# check-stuck.sh - Controlla se worker sono stuck (no heartbeat > 2min)
#
# Usage:
#   check-stuck.sh [WORKER_NAME]
#   check-stuck.sh --notify
#
# Se nessun worker specificato, controlla TUTTI i worker.
# Flag --notify: notifica Regina se stuck detected
#
# Exit code:
#   0 = all OK
#   1 = stuck detected
#
# Versione: 1.0.0
# Data: 7 Gennaio 2026
# Cervella DevOps
#
# Basato su: Protocollo STATUS (sezione 2.5)

set -euo pipefail

# Colori
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configurazione
STUCK_THRESHOLD=120  # 2 minuti in secondi
NOTIFY=0
SPECIFIC_WORKER=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --notify)
      NOTIFY=1
      shift
      ;;
    *)
      SPECIFIC_WORKER="$1"
      shift
      ;;
  esac
done

# Funzioni
error() {
  echo -e "${RED}Error: $1${NC}" >&2
  exit 1
}

format_time_ago() {
  local seconds=$1
  if [ $seconds -lt 60 ]; then
    echo "${seconds}s ago"
  elif [ $seconds -lt 3600 ]; then
    echo "$((seconds / 60))m $((seconds % 60))s ago"
  else
    echo "$((seconds / 3600))h $((seconds % 3600 / 60))m ago"
  fi
}

# Verifica directory esiste
if [[ ! -d ".swarm/status" ]]; then
  echo -e "${YELLOW}No workers active (no .swarm/status/ directory)${NC}"
  exit 0
fi

# Timestamp corrente
NOW=$(date +%s)

# Array per stuck workers
declare -a STUCK_WORKERS=()

# Funzione per controllare un worker
check_worker() {
  local heartbeat_file="$1"
  local worker_name=$(basename "$heartbeat_file" | sed 's/heartbeat_//' | sed 's/\.log//')

  # Verifica se worker ha task .done o .failed (terminato normalmente)
  # In questo caso, ignora
  local task_id=""
  if [[ -f ".swarm/status/worker_${worker_name}.task" ]]; then
    task_id=$(cat ".swarm/status/worker_${worker_name}.task" 2>/dev/null || echo "")

    if [[ -n "$task_id" ]]; then
      if [[ -f ".swarm/tasks/${task_id}.done" ]] || [[ -f ".swarm/tasks/${task_id}.failed" ]]; then
        # Worker ha completato - non è stuck
        return 0
      fi
    fi
  fi

  # Leggi ultimo heartbeat
  if [[ ! -f "$heartbeat_file" ]]; then
    echo -e "${YELLOW}  ${worker_name}:${NC} No heartbeat file"
    return 0
  fi

  local last_line=$(tail -n 1 "$heartbeat_file" 2>/dev/null || echo "")

  if [[ -z "$last_line" ]]; then
    echo -e "${YELLOW}  ${worker_name}:${NC} Empty heartbeat file"
    return 0
  fi

  # Parse: timestamp|task_id|status|note
  local timestamp=$(echo "$last_line" | cut -d'|' -f1)
  local status=$(echo "$last_line" | cut -d'|' -f3)
  local note=$(echo "$last_line" | cut -d'|' -f4)

  # Se status = STOPPED, ignora
  if [[ "$status" == "STOPPED" ]]; then
    return 0
  fi

  # Calcola diff
  local diff=$((NOW - timestamp))

  if [ $diff -gt $STUCK_THRESHOLD ]; then
    # STUCK!
    STUCK_WORKERS+=("$worker_name|$diff|$note")
    echo -e "${RED}  ⚠️  ${worker_name}:${NC} $(format_time_ago $diff) (last: \"${note}\")"
    return 1
  else
    # OK
    echo -e "${GREEN}  ✅ ${worker_name}:${NC} $(format_time_ago $diff)"
    return 0
  fi
}

# Se specificato worker, controlla solo lui
if [[ -n "$SPECIFIC_WORKER" ]]; then
  HEARTBEAT_FILE=".swarm/status/heartbeat_${SPECIFIC_WORKER}.log"

  if [[ ! -f "$HEARTBEAT_FILE" ]]; then
    error "Worker '$SPECIFIC_WORKER' not found (no heartbeat file)"
  fi

  echo -e "${BLUE}Checking worker:${NC} $SPECIFIC_WORKER"
  echo ""

  check_worker "$HEARTBEAT_FILE"
  RESULT=$?

  if [ $RESULT -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Worker is active${NC}"
    exit 0
  else
    echo ""
    echo -e "${RED}⚠️  Worker is STUCK${NC}"

    if [ $NOTIFY -eq 1 ]; then
      if command -v osascript &>/dev/null; then
        osascript -e "display notification \"${SPECIFIC_WORKER} is stuck!\" with title \"Worker STUCK!\" sound name \"Basso\"" 2>/dev/null || true
      fi
    fi
    exit 1
  fi
fi

# Altrimenti controlla tutti
echo -e "${BLUE}Checking all workers...${NC}"
echo ""

# Loop su tutti i file heartbeat_*.log
shopt -s nullglob
HEARTBEAT_FILES=(.swarm/status/heartbeat_*.log)

if [ ${#HEARTBEAT_FILES[@]} -eq 0 ]; then
  echo -e "${YELLOW}No workers active${NC}"
  exit 0
fi

HAS_STUCK=0

for heartbeat_file in "${HEARTBEAT_FILES[@]}"; do
  if ! check_worker "$heartbeat_file"; then
    HAS_STUCK=1
  fi
done

echo ""

# Riepilogo
if [ $HAS_STUCK -eq 1 ]; then
  echo -e "${RED}⚠️  STUCK DETECTED:${NC} ${#STUCK_WORKERS[@]} worker(s)"

  if [ $NOTIFY -eq 1 ]; then
    if command -v osascript &>/dev/null; then
      osascript -e "display notification \"${#STUCK_WORKERS[@]} worker(s) stuck!\" with title \"Worker STUCK!\" sound name \"Basso\"" 2>/dev/null || true
    fi
  fi

  exit 1
else
  echo -e "${GREEN}✅ All workers active${NC}"
  exit 0
fi
