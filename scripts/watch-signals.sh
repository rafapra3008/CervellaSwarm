#!/bin/bash
# watch-signals.sh - Event-Driven Signal Watcher
# Monitora .swarm/segnali/ e notifica quando arrivano nuovi segnali
#
# Uso: watch-signals.sh [PROJECT_PATH]
#
# CervellaSwarm Multi-Instance Coordination v2.0

set -e

# Colori
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# Path progetto
PROJECT_PATH="${1:-.}"
PROJECT_PATH=$(cd "$PROJECT_PATH" && pwd)
SIGNALS_DIR="$PROJECT_PATH/.swarm/segnali"

# Verifica directory esiste
if [ ! -d "$SIGNALS_DIR" ]; then
    echo -e "${RED}ERRORE: Directory $SIGNALS_DIR non trovata${NC}"
    echo "Assicurati che il progetto abbia .swarm/segnali/"
    exit 1
fi

# Header
echo -e "${CYAN}=======================================${NC}"
echo -e "${CYAN}   SIGNAL WATCHER - Event Driven${NC}"
echo -e "${CYAN}=======================================${NC}"
echo ""
echo -e "${BLUE}Progetto:${NC} $PROJECT_PATH"
echo -e "${BLUE}Watching:${NC} $SIGNALS_DIR"
echo ""
echo -e "${YELLOW}In attesa di segnali...${NC}"
echo -e "${YELLOW}(Ctrl+C per terminare)${NC}"
echo ""

# Funzione per processare un segnale
process_signal() {
    local signal_file="$1"
    local filename=$(basename "$signal_file")

    # Ignora template e file temporanei
    if [[ "$filename" == _* ]] || [[ "$filename" == .* ]]; then
        return
    fi

    # Verifica che sia un file .signal.json
    if [[ "$filename" != *.signal.json ]]; then
        return
    fi

    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}   NUOVO SEGNALE RILEVATO!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "${BLUE}File:${NC} $filename"
    echo -e "${BLUE}Time:${NC} $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""

    # Leggi e mostra contenuto
    if [ -f "$signal_file" ]; then
        echo -e "${CYAN}Contenuto:${NC}"
        echo "----------------------------------------"

        # Estrai info principali dal JSON
        local task_id=$(jq -r '.task_id // "N/A"' "$signal_file" 2>/dev/null)
        local type=$(jq -r '.type // "N/A"' "$signal_file" 2>/dev/null)
        local status=$(jq -r '.status // "N/A"' "$signal_file" 2>/dev/null)
        local producer=$(jq -r '.producer.agent // .producer // "N/A"' "$signal_file" 2>/dev/null)
        local description=$(jq -r '.output.description // "N/A"' "$signal_file" 2>/dev/null)

        echo -e "  Task ID:     ${YELLOW}$task_id${NC}"
        echo -e "  Tipo:        $type"
        echo -e "  Status:      $([ "$status" = "success" ] && echo -e "${GREEN}$status${NC}" || echo -e "${RED}$status${NC}")"
        echo -e "  Producer:    $producer"
        echo -e "  Descrizione: $description"

        echo "----------------------------------------"
    fi

    # Log
    local log_file="$PROJECT_PATH/.swarm/logs/signals_$(date '+%Y-%m-%d').log"
    mkdir -p "$(dirname "$log_file")"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SIGNAL: $filename" >> "$log_file"

    # Notifica sonora (opzionale - Mac)
    if command -v afplay &> /dev/null; then
        afplay /System/Library/Sounds/Glass.aiff 2>/dev/null &
    fi

    echo ""
    echo -e "${YELLOW}In attesa del prossimo segnale...${NC}"
}

# Esporta funzione per subshell
export -f process_signal
export PROJECT_PATH SIGNALS_DIR GREEN YELLOW BLUE CYAN RED NC

# Avvia watcher con fswatch
# -0: usa null separator
# --event Created: solo file creati
# -r: ricorsivo
fswatch -0 --event Created "$SIGNALS_DIR" | while read -d "" event; do
    process_signal "$event"
done
