#!/bin/bash
#
# ask-regina.sh - Helper per worker: crea feedback file per la Regina
#
# Usage:
#   ask-regina.sh TIPO "titolo" "descrizione"
#
# Types: question, issue, blocker, suggestion
#
# Examples:
#   ask-regina.sh question "Which library?" "Should I use FastAPI or Flask?"
#   ask-regina.sh blocker "API key missing" "Cannot proceed without .env file"
#   ask-regina.sh issue "Test failing" "Unit test test_auth.py fails"
#   ask-regina.sh suggestion "Add caching" "Could improve performance with Redis"
#
# Versione: 1.0.0
# Data: 7 Gennaio 2026
# Cervella DevOps
#
# Basato su: Protocollo FEEDBACK (sezione 3)

set -euo pipefail

# Colori
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Tipi validi
VALID_TYPES=("question" "issue" "blocker" "suggestion")

# Funzioni
error() {
  echo -e "${RED}Error: $1${NC}" >&2
  exit 1
}

usage() {
  echo "Usage: $0 TYPE \"title\" \"description\""
  echo ""
  echo "Available types:"
  echo "  question   - Dubbio su come procedere (MEDIA)"
  echo "  issue      - Problema trovato (ALTA)"
  echo "  blocker    - Completamente bloccato (CRITICA)"
  echo "  suggestion - Idea di miglioramento (BASSA)"
  echo ""
  echo "Examples:"
  echo "  $0 question \"Which library?\" \"Should I use FastAPI or Flask?\""
  echo "  $0 blocker \"Missing credentials\" \"Cannot access database\""
  exit 1
}

# Verifica parametri
if [ $# -lt 3 ]; then
  usage
fi

TYPE_RAW="$1"
TITLE="$2"
DESCRIPTION="$3"

# Normalizza tipo (lowercase)
TYPE=$(echo "$TYPE_RAW" | tr '[:upper:]' '[:lower:]')

# Valida tipo
is_valid_type() {
  local type="$1"
  for valid in "${VALID_TYPES[@]}"; do
    if [[ "$valid" == "$type" ]]; then
      return 0
    fi
  done
  return 1
}

if ! is_valid_type "$TYPE"; then
  echo -e "${RED}Error: Invalid type '$TYPE'${NC}" >&2
  echo ""
  echo "Valid types:"
  for t in "${VALID_TYPES[@]}"; do
    echo "  - $t"
  done
  exit 1
fi

# Detecta worker e task
WORKER_NAME="${SWARM_WORKER_NAME:-unknown}"

TASK_ID="NONE"
if [[ -f ".swarm/current_task" ]]; then
  TASK_ID=$(cat .swarm/current_task)
fi

# Verifica/Crea directory feedback
mkdir -p .swarm/feedback

# Timestamp
TIMESTAMP=$(date +%s)
ISO_TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Tipo UPPERCASE per filename
TYPE_UPPER=$(echo "$TYPE" | tr '[:lower:]' '[:upper:]')

# Crea feedback file
FEEDBACK_FILE=".swarm/feedback/${TYPE_UPPER}_${TASK_ID}_${TIMESTAMP}.md"

# Determina urgenza
URGENCY="MEDIA"
case "$TYPE" in
  question)
    URGENCY="MEDIA"
    ;;
  issue)
    URGENCY="ALTA"
    ;;
  blocker)
    URGENCY="CRITICA"
    ;;
  suggestion)
    URGENCY="BASSA"
    ;;
esac

# Cerca template (se esiste)
TEMPLATE_FILE=".swarm/templates/TEMPLATE_FEEDBACK_${TYPE_UPPER}.md"

if [[ -f "$TEMPLATE_FILE" ]]; then
  # Usa template e sostituisci placeholder
  cp "$TEMPLATE_FILE" "$FEEDBACK_FILE"

  # Sostituzioni semplici (sed cross-platform macOS)
  sed -i '' "s/\[TASK_ID\]/${TASK_ID}/g" "$FEEDBACK_FILE"
  sed -i '' "s/\[WORKER\]/${WORKER_NAME}/g" "$FEEDBACK_FILE"
  sed -i '' "s/\[TIMESTAMP\]/${ISO_TIMESTAMP}/g" "$FEEDBACK_FILE"
  sed -i '' "s/\[TITOLO\]/${TITLE}/g" "$FEEDBACK_FILE"

  # Per descrizione, la inserisce nella sezione Situazione
  # Trova la riga con "## Situazione" e inserisce descrizione dopo
  # (implementazione semplice - il worker può editare poi)
  echo "" >> "$FEEDBACK_FILE"
  echo "## Descrizione Iniziale" >> "$FEEDBACK_FILE"
  echo "" >> "$FEEDBACK_FILE"
  echo "$DESCRIPTION" >> "$FEEDBACK_FILE"
else
  # Crea feedback basic senza template
  cat > "$FEEDBACK_FILE" << EOF
---
tipo: ${TYPE_UPPER}
task_id: ${TASK_ID}
worker: ${WORKER_NAME}
urgenza: ${URGENCY}
timestamp: ${ISO_TIMESTAMP}
---

# ${TYPE_UPPER}: ${TITLE}

## Situazione

${DESCRIPTION}

## Cosa Serve

[Cosa serve dalla Regina per proseguire - da completare]

---

**Worker in attesa di risposta dalla Regina!** 💙
EOF
fi

echo -e "${GREEN}✅ Feedback created:${NC} ${BLUE}${FEEDBACK_FILE}${NC}"

# Se blocker, aggiorna status
if [[ "$TYPE" == "blocker" ]]; then
  # Verifica se update-status.sh esiste
  if [[ -x "scripts/swarm/update-status.sh" ]]; then
    ./scripts/swarm/update-status.sh BLOCKED "Blocker: ${TITLE}" 2>/dev/null || true
  fi
fi

# Notifica Regina
NOTIFICATION_MSG=""
case "$TYPE" in
  question)
    NOTIFICATION_MSG="💬 Question from ${WORKER_NAME}"
    ;;
  issue)
    NOTIFICATION_MSG="⚠️ Issue reported by ${WORKER_NAME}"
    ;;
  blocker)
    NOTIFICATION_MSG="🚫 BLOCKER from ${WORKER_NAME}!"
    ;;
  suggestion)
    NOTIFICATION_MSG="💡 Suggestion from ${WORKER_NAME}"
    ;;
esac

if command -v osascript &>/dev/null; then
  osascript -e "display notification \"${TITLE}\" with title \"${NOTIFICATION_MSG}\" sound name \"Glass\"" 2>/dev/null || true
  echo -e "${BLUE}🔔 Regina notified:${NC} ${NOTIFICATION_MSG}"
fi

# Opzionale: apri file in editor
if [[ "${OPEN_EDITOR:-0}" == "1" ]]; then
  echo -e "${BLUE}📝 Opening editor for details...${NC}"
  open "$FEEDBACK_FILE" 2>/dev/null || true
fi

echo ""
echo -e "${YELLOW}Remember:${NC} Regina will respond in:"
echo "  ${FEEDBACK_FILE}_RESPONSE.md"
