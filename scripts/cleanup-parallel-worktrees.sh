#!/bin/bash
#
# cleanup-parallel-worktrees.sh
# Rimuove tutti i worktrees paralleli e le relative branch
#
# Usage: ./cleanup-parallel-worktrees.sh [project-path] [--force]
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Banner
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║   🐝 CLEANUP PARALLEL WORKTREES                             ║"
echo "║   CervellaSwarm Multi-Instance Development                  ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check arguments
if [ $# -lt 1 ]; then
    echo -e "${RED}Usage: $0 <project-path> [--force]${NC}"
    echo "Example: $0 ~/Developer/swarm-test-lab"
    echo ""
    echo "Options:"
    echo "  --force    Skip confirmation and force remove"
    exit 1
fi

PROJECT_PATH="$1"
PROJECT_PATH=$(eval echo "$PROJECT_PATH")
FORCE=false

if [ "$2" == "--force" ]; then
    FORCE=true
fi

# Validate
if [ ! -d "$PROJECT_PATH/.git" ]; then
    echo -e "${RED}Error: Not a git repository: $PROJECT_PATH${NC}"
    exit 1
fi

cd "$PROJECT_PATH"

PROJECT_NAME=$(basename "$PROJECT_PATH")
PARENT_DIR=$(dirname "$PROJECT_PATH")

echo -e "${CYAN}Project: $PROJECT_NAME${NC}"
echo ""

# List worktrees to remove
echo -e "${YELLOW}Worktrees to remove:${NC}"

WORKTREES_TO_REMOVE=()
while IFS= read -r line; do
    WORKTREE_PATH=$(echo "$line" | awk '{print $1}')
    BRANCH=$(echo "$line" | awk '{print $3}' | tr -d '[]')

    # Skip main worktree
    if [ "$WORKTREE_PATH" == "$PROJECT_PATH" ]; then
        continue
    fi

    # Only remove parallel/* branches
    if [[ "$BRANCH" == parallel/* ]]; then
        echo "  - $WORKTREE_PATH ($BRANCH)"
        WORKTREES_TO_REMOVE+=("$WORKTREE_PATH|$BRANCH")
    fi
done < <(git worktree list)

if [ ${#WORKTREES_TO_REMOVE[@]} -eq 0 ]; then
    echo -e "${GREEN}No parallel worktrees found. Already clean!${NC}"
    exit 0
fi

echo ""

# Check for uncommitted changes
echo -e "${YELLOW}Checking for uncommitted changes...${NC}"
HAS_CHANGES=false

for item in "${WORKTREES_TO_REMOVE[@]}"; do
    WORKTREE_PATH=$(echo "$item" | cut -d'|' -f1)
    BRANCH=$(echo "$item" | cut -d'|' -f2)

    if [ -d "$WORKTREE_PATH" ]; then
        cd "$WORKTREE_PATH"

        # Check for changes
        if [ -n "$(git status --porcelain)" ]; then
            echo -e "${RED}  ⚠️  $BRANCH has uncommitted changes!${NC}"
            HAS_CHANGES=true
        else
            echo -e "${GREEN}  ✓ $BRANCH is clean${NC}"
        fi

        cd "$PROJECT_PATH"
    fi
done

echo ""

# Warn if there are uncommitted changes
if [ "$HAS_CHANGES" = true ] && [ "$FORCE" = false ]; then
    echo -e "${RED}WARNING: Some worktrees have uncommitted changes!${NC}"
    echo "These changes will be LOST if you continue."
    echo ""
    read -p "Are you sure you want to continue? (y/N) " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
elif [ "$FORCE" = false ]; then
    read -p "Remove all parallel worktrees? (y/N) " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

# Remove worktrees
echo -e "${YELLOW}Removing worktrees...${NC}"

REMOVED=()
for item in "${WORKTREES_TO_REMOVE[@]}"; do
    WORKTREE_PATH=$(echo "$item" | cut -d'|' -f1)
    BRANCH=$(echo "$item" | cut -d'|' -f2)

    echo "  Removing: $WORKTREE_PATH"

    # Remove worktree
    if git worktree remove "$WORKTREE_PATH" --force 2>/dev/null; then
        echo -e "${GREEN}    ✓ Worktree removed${NC}"
    else
        # Try manual removal if git worktree remove fails
        rm -rf "$WORKTREE_PATH" 2>/dev/null || true
        git worktree prune 2>/dev/null || true
        echo -e "${YELLOW}    ✓ Worktree removed (manual)${NC}"
    fi

    # Delete branch
    echo "  Deleting branch: $BRANCH"
    if git branch -D "$BRANCH" 2>/dev/null; then
        echo -e "${GREEN}    ✓ Branch deleted${NC}"
    else
        echo -e "${YELLOW}    ⚠ Branch not found or already deleted${NC}"
    fi

    REMOVED+=("$BRANCH")
    echo ""
done

# Prune worktree references
git worktree prune 2>/dev/null || true

# Summary
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║   ✅ CLEANUP COMPLETE!                                      ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo "Removed ${#REMOVED[@]} parallel worktrees:"
for branch in "${REMOVED[@]}"; do
    echo "  ✓ $branch"
done

echo ""
echo -e "${CYAN}Remaining worktrees:${NC}"
git worktree list
