#!/bin/bash

# new-report.sh - Helper per creare nuovo report finale
# Parte di CervellaSwarm v27.x+
# Uso: ./scripts/swarm/new-report.sh

set -e

# Colori
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Path
TEMPLATE_PATH="$(dirname "$0")/../../docs/templates/REPORT_FINALE.md"
REPORTS_DIR="$(dirname "$0")/../../reports"

# Crea reports/ se non esiste
mkdir -p "$REPORTS_DIR"

# Genera filename con timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
NEW_REPORT="$REPORTS_DIR/REPORT_$TIMESTAMP.md"

# Copia template
cp "$TEMPLATE_PATH" "$NEW_REPORT"

echo -e "${GREEN}✓ Report creato:${NC} $NEW_REPORT"
echo ""
echo -e "${BLUE}Prossimi step:${NC}"
echo "1. Apri il file in editor"
echo "2. Compila tutte le sezioni (leggi i commenti HTML)"
echo "3. Guarda l'esempio: docs/templates/REPORT_FINALE_ESEMPIO.md"
echo "4. Salva e committa"
echo ""
echo -e "${YELLOW}Tip:${NC} Dedica 15-20 minuti a fine sessione per compilarlo bene."
echo "      Un buon report oggi = ore risparmiate domani!"
echo ""

# Opzionale: apri in editor (decommentare se vuoi)
# open "$NEW_REPORT"
