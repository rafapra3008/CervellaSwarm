#!/bin/bash
# ============================================================================
# CervellaSwarm - Merge Worktrees Script
# ============================================================================
# Fa merge di tutti i branch swarm/* nel branch principale
#
# Uso:
#   ./merge-worktrees.sh                    # Usa repo corrente
#   ./merge-worktrees.sh /path/to/repo      # Specifica repo
#
# Ordine merge:
#   1. swarm/cervella-backend  (prima le dipendenze)
#   2. swarm/cervella-frontend
#   3. swarm/cervella-tester
#
# "È il nostro team! La nostra famiglia digitale!"
# ============================================================================

set -e  # Exit on error

# Colori
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Funzioni
print_header() {
    echo ""
    echo -e "${CYAN}============================================${NC}"
    echo -e "${CYAN}  CervellaSwarm - Merge Worktrees${NC}"
    echo -e "${CYAN}============================================${NC}"
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
CURRENT_BRANCH=$(git branch --show-current)

echo "📁 Repo: $REPO_NAME"
echo "📍 Path: $REPO_PATH"
echo "🌿 Branch target: $CURRENT_BRANCH"
echo ""

# Verifica che siamo sul branch principale
if [[ "$CURRENT_BRANCH" == swarm/* ]]; then
    print_error "Sei su un branch swarm! Torna su main/master prima."
    exit 1
fi

# Verifica che non ci siano modifiche uncommitted
if [ -n "$(git status --porcelain)" ]; then
    print_error "Ci sono modifiche non committate! Committa prima."
    git status --short
    exit 1
fi

# Ordine di merge (backend prima, poi frontend, poi tester)
MERGE_ORDER=("cervella-backend" "cervella-frontend" "cervella-tester")

# Trova quali branch esistono
BRANCHES_TO_MERGE=()
for wt in "${MERGE_ORDER[@]}"; do
    BRANCH_NAME="swarm/${wt}"
    if git show-ref --verify --quiet "refs/heads/${BRANCH_NAME}"; then
        BRANCHES_TO_MERGE+=("$BRANCH_NAME")
    fi
done

if [ ${#BRANCHES_TO_MERGE[@]} -eq 0 ]; then
    print_info "Nessun branch swarm/* trovato da mergiare."
    exit 0
fi

echo "Branch da mergiare (in ordine):"
for branch in "${BRANCHES_TO_MERGE[@]}"; do
    # Conta commits ahead
    AHEAD=$(git rev-list --count "$CURRENT_BRANCH".."$branch" 2>/dev/null || echo "0")
    echo "  - $branch ($AHEAD commit ahead)"
done
echo ""

read -p "Procedo con il merge? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    print_info "Operazione annullata."
    exit 0
fi

echo ""

# Esegui merge
MERGED=0
CONFLICTS=0

for branch in "${BRANCHES_TO_MERGE[@]}"; do
    echo -e "${BLUE}📦 Merging: $branch${NC}"

    # Verifica se ci sono commit da mergiare
    AHEAD=$(git rev-list --count "$CURRENT_BRANCH".."$branch" 2>/dev/null || echo "0")
    if [ "$AHEAD" -eq 0 ]; then
        print_info "Nessun commit da mergiare in $branch"
        continue
    fi

    # Prova merge
    if git merge "$branch" --no-ff -m "🐝 Merge: $branch into $CURRENT_BRANCH (CervellaSwarm)"; then
        print_success "Merge completato: $branch"
        ((MERGED++))
    else
        print_error "CONFLITTO durante merge di $branch!"
        print_warning "Risolvi manualmente e poi esegui: git commit"
        ((CONFLICTS++))
        break  # Ferma il merge
    fi

    echo ""
done

echo ""
echo "============================================"
if [ $CONFLICTS -eq 0 ]; then
    echo -e "${GREEN}  Merge completato con successo!${NC}"
    echo -e "${GREEN}  Branch mergiati: $MERGED${NC}"
    echo ""
    print_info "Ora puoi eseguire cleanup-worktrees.sh per pulire"
else
    echo -e "${RED}  Merge interrotto per conflitti!${NC}"
    echo -e "${RED}  Risolvi i conflitti e committa${NC}"
fi
echo "============================================"
echo ""

# Mostra stato finale
echo "📊 Stato finale:"
git log --oneline -5

echo ""
echo "\"È il nostro team! La nostra famiglia digitale!\" 🐝❤️‍🔥"
