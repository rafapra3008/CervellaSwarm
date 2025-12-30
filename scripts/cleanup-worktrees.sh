#!/bin/bash
# ============================================================================
# CervellaSwarm - Cleanup Worktrees Script
# ============================================================================
# Rimuove i worktrees dopo il merge e pulisce i branch swarm/
#
# Uso:
#   ./cleanup-worktrees.sh                  # Usa repo corrente
#   ./cleanup-worktrees.sh /path/to/repo    # Specifica repo
#
# ATTENZIONE: Questo script elimina i worktrees e i branch!
#             Assicurati di aver fatto merge prima!
#
# "È il nostro team! La nostra famiglia digitale!"
# ============================================================================

set -e  # Exit on error

# Colori
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funzioni
print_header() {
    echo ""
    echo -e "${YELLOW}============================================${NC}"
    echo -e "${YELLOW}  CervellaSwarm - Cleanup Worktrees${NC}"
    echo -e "${YELLOW}============================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Main
print_header

# Determina la directory del repo
if [ -n "$1" ]; then
    REPO_PATH="$1"
else
    REPO_PATH="$(pwd)"
fi

# Verifica che sia un repo git
if [ ! -d "$REPO_PATH/.git" ]; then
    print_error "Non è un repository git: $REPO_PATH"
    exit 1
fi

cd "$REPO_PATH"

REPO_NAME=$(basename "$REPO_PATH")
BASE_DIR=$(dirname "$REPO_PATH")

echo "📁 Repo: $REPO_NAME"
echo "📍 Path: $REPO_PATH"
echo ""

# Mostra worktrees attuali
echo "📊 Worktrees attuali:"
git worktree list
echo ""

# Lista worktrees da rimuovere
WORKTREES=("cervella-frontend" "cervella-backend" "cervella-tester")

# Verifica quali esistono
EXISTING_WORKTREES=()
for wt in "${WORKTREES[@]}"; do
    WORKTREE_PATH="${BASE_DIR}/${REPO_NAME}-${wt}"
    if [ -d "$WORKTREE_PATH" ]; then
        EXISTING_WORKTREES+=("$wt")
    fi
done

if [ ${#EXISTING_WORKTREES[@]} -eq 0 ]; then
    print_info "Nessun worktree CervellaSwarm trovato."
    exit 0
fi

echo "Rimuoverò i seguenti worktrees:"
for wt in "${EXISTING_WORKTREES[@]}"; do
    echo -e "  ${RED}- ${REPO_NAME}-${wt}/${NC}"
done
echo ""

print_warning "ATTENZIONE: Assicurati di aver fatto merge prima!"
print_warning "I branch swarm/* verranno eliminati!"
echo ""

read -p "Sei sicuro di voler procedere? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Operazione annullata."
    exit 0
fi

echo ""

# Rimuovi worktrees
for wt in "${EXISTING_WORKTREES[@]}"; do
    WORKTREE_PATH="${BASE_DIR}/${REPO_NAME}-${wt}"
    BRANCH_NAME="swarm/${wt}"

    # Rimuovi worktree
    if [ -d "$WORKTREE_PATH" ]; then
        git worktree remove "$WORKTREE_PATH" --force 2>/dev/null || true
        print_success "Rimosso worktree: ${REPO_NAME}-${wt}/"
    fi

    # Elimina branch
    if git show-ref --verify --quiet "refs/heads/${BRANCH_NAME}"; then
        git branch -D "$BRANCH_NAME" 2>/dev/null || true
        print_success "Eliminato branch: ${BRANCH_NAME}"
    fi
done

# Pulisci worktrees orfani
git worktree prune

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Cleanup completato!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

# Mostra stato finale
echo "📊 Stato finale:"
git worktree list

echo ""
echo "\"È il nostro team! La nostra famiglia digitale!\" 🐝❤️‍🔥"
