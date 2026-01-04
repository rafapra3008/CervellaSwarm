#!/bin/bash
#
# monitor-handoff.sh - Monitora comunicazioni worker -> Regina
#
# Mostra i messaggi in .swarm/handoff/ che richiedono attenzione
#
# Uso:
#   ./monitor-handoff.sh           # Lista messaggi pendenti
#   ./monitor-handoff.sh --watch   # Monitora continuamente (ogni 5 sec)
#   ./monitor-handoff.sh --clear   # Archivia messaggi gestiti
#
# Versione: 1.0.0
# Data: 2026-01-04
# Cervella & Rafa

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
HANDOFF_DIR="${PROJECT_ROOT}/.swarm/handoff"
ARCHIVE_DIR="${PROJECT_ROOT}/.swarm/handoff/archive"

# Colori
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${PURPLE}"
    echo "=============================================="
    echo "  MONITOR HANDOFF - Messaggi Worker -> Regina"
    echo "=============================================="
    echo -e "${NC}"
}

count_pending() {
    find "$HANDOFF_DIR" -maxdepth 1 -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' '
}

list_messages() {
    local count=$(count_pending)

    if [ "$count" -eq 0 ]; then
        echo -e "${GREEN}[OK]${NC} Nessun messaggio pendente"
        return 0
    fi

    echo -e "${YELLOW}[!]${NC} $count messaggio/i in attesa:"
    echo ""

    for file in "$HANDOFF_DIR"/*.md; do
        [ -f "$file" ] || continue
        filename=$(basename "$file")

        # Estrai info dal file
        worker=$(grep -m1 "Worker:" "$file" 2>/dev/null | cut -d':' -f2 | xargs || echo "unknown")
        stato=$(grep -m1 "Stato:" "$file" 2>/dev/null | cut -d':' -f2 | xargs || echo "unknown")
        data=$(grep -m1 "Data:" "$file" 2>/dev/null | cut -d':' -f2- | xargs || echo "unknown")

        echo -e "  ${CYAN}$filename${NC}"
        echo -e "    Worker: $worker"
        echo -e "    Stato: $stato"
        echo -e "    Data: $data"
        echo ""
    done

    echo -e "${BLUE}[i]${NC} Leggi i file per i dettagli"
    echo -e "${BLUE}[i]${NC} Rispondi creando RISPOSTA_*.md"
}

watch_mode() {
    echo -e "${BLUE}[i]${NC} Modalita watch attiva (Ctrl+C per uscire)"
    echo ""

    while true; do
        clear
        print_header
        echo "Ultimo check: $(date '+%H:%M:%S')"
        echo ""
        list_messages
        sleep 5
    done
}

archive_handled() {
    mkdir -p "$ARCHIVE_DIR"

    local count=0
    for file in "$HANDOFF_DIR"/*.md; do
        [ -f "$file" ] || continue
        mv "$file" "$ARCHIVE_DIR/"
        count=$((count + 1))
    done

    echo -e "${GREEN}[OK]${NC} Archiviati $count messaggi in handoff/archive/"
}

# Main
case "${1:-}" in
    --watch|-w)
        print_header
        watch_mode
        ;;
    --clear|-c)
        archive_handled
        ;;
    --help|-h)
        echo "Uso: $0 [opzione]"
        echo ""
        echo "Opzioni:"
        echo "  (nessuna)     Lista messaggi pendenti"
        echo "  --watch, -w   Monitora continuamente"
        echo "  --clear, -c   Archivia messaggi gestiti"
        echo "  --help, -h    Mostra questo help"
        ;;
    *)
        print_header
        list_messages
        ;;
esac
