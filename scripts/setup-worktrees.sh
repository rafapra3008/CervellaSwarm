#!/bin/bash
# ============================================================================
# CervellaSwarm - Setup Worktrees Script
# ============================================================================
# Crea worktrees separati per ogni Cervella dello sciame
#
# Uso:
#   ./setup-worktrees.sh                    # Usa repo corrente
#   ./setup-worktrees.sh /path/to/repo      # Specifica repo
#
# Risultato:
#   repo/                           <- Main (Orchestratrice)
#   repo-cervella-frontend/         <- Worktree Frontend
#   repo-cervella-backend/          <- Worktree Backend
#   repo-cervella-tester/           <- Worktree Tester
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
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}  CervellaSwarm - Setup Worktrees${NC}"
    echo -e "${BLUE}============================================${NC}"
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
CURRENT_BRANCH=$(git branch --show-current)

echo "📁 Repo: $REPO_NAME"
echo "📍 Path: $REPO_PATH"
echo "🌿 Branch corrente: $CURRENT_BRANCH"
echo ""

# Verifica che non ci siano modifiche uncommitted
if [ -n "$(git status --porcelain)" ]; then
    print_warning "Ci sono modifiche non committate!"
    echo ""
    git status --short
    echo ""
    read -p "Vuoi continuare comunque? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Operazione annullata. Committa prima le modifiche."
        exit 1
    fi
fi

# Lista worktrees da creare
WORKTREES=("cervella-frontend" "cervella-backend" "cervella-tester")

echo "Creerò i seguenti worktrees:"
for wt in "${WORKTREES[@]}"; do
    echo "  - ${REPO_NAME}-${wt}/ -> branch swarm/${wt}"
done
echo ""

read -p "Procedo? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    print_info "Operazione annullata."
    exit 0
fi

echo ""

# Crea worktrees
for wt in "${WORKTREES[@]}"; do
    WORKTREE_PATH="${BASE_DIR}/${REPO_NAME}-${wt}"
    BRANCH_NAME="swarm/${wt}"

    # Verifica se esiste già
    if [ -d "$WORKTREE_PATH" ]; then
        print_warning "Worktree già esistente: ${REPO_NAME}-${wt}"
        continue
    fi

    # Verifica se il branch esiste già
    if git show-ref --verify --quiet "refs/heads/${BRANCH_NAME}"; then
        # Branch esiste, usa quello
        print_info "Branch ${BRANCH_NAME} esiste, lo uso"
        git worktree add "$WORKTREE_PATH" "$BRANCH_NAME"
    else
        # Crea nuovo branch da main/master
        git worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME" "$CURRENT_BRANCH"
    fi

    print_success "Creato: ${REPO_NAME}-${wt}/ -> ${BRANCH_NAME}"
done

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Worktrees creati con successo!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

# Mostra stato finale
echo "📊 Stato attuale:"
git worktree list

echo ""
echo "🐝 Come usare:"
echo "  Orchestratrice: lavora in ${REPO_PATH}/"
echo "  Frontend:       lavora in ${BASE_DIR}/${REPO_NAME}-cervella-frontend/"
echo "  Backend:        lavora in ${BASE_DIR}/${REPO_NAME}-cervella-backend/"
echo "  Tester:         lavora in ${BASE_DIR}/${REPO_NAME}-cervella-tester/"
echo ""
echo "📝 Ogni Cervella committa sul suo branch, poi merge finale!"
echo ""
echo "\"È il nostro team! La nostra famiglia digitale!\" 🐝❤️‍🔥"
