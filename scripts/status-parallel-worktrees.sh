#!/bin/bash
#
# status-parallel-worktrees.sh
# Mostra lo stato di tutti i worktrees paralleli
#
# Usage: ./status-parallel-worktrees.sh [project-path]
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
echo "║   🐝 PARALLEL WORKTREES STATUS                              ║"
echo "║   CervellaSwarm Multi-Instance Development                  ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check arguments
if [ $# -lt 1 ]; then
    echo -e "${RED}Usage: $0 <project-path>${NC}"
    echo "Example: $0 ~/Developer/swarm-test-lab"
    exit 1
fi

PROJECT_PATH="$1"
PROJECT_PATH=$(eval echo "$PROJECT_PATH")

# Validate
if [ ! -d "$PROJECT_PATH/.git" ]; then
    echo -e "${RED}Error: Not a git repository: $PROJECT_PATH${NC}"
    exit 1
fi

cd "$PROJECT_PATH"

PROJECT_NAME=$(basename "$PROJECT_PATH")
echo -e "${CYAN}Project: $PROJECT_NAME${NC}"
echo -e "${CYAN}Path: $PROJECT_PATH${NC}"
echo ""

# List all worktrees
echo -e "${YELLOW}═══ WORKTREES ═══${NC}"
echo ""

git worktree list | while read -r line; do
    WORKTREE_PATH=$(echo "$line" | awk '{print $1}')
    COMMIT=$(echo "$line" | awk '{print $2}')
    BRANCH=$(echo "$line" | awk '{print $3}' | tr -d '[]')

    # Determine type
    if [[ "$WORKTREE_PATH" == "$PROJECT_PATH" ]]; then
        TYPE="MAIN"
        COLOR=$GREEN
    else
        TYPE="PARALLEL"
        COLOR=$CYAN
    fi

    echo -e "${COLOR}[$TYPE]${NC} $BRANCH"
    echo "  Path: $WORKTREE_PATH"
    echo "  Commit: $COMMIT"

    # Get status for this worktree
    if [ -d "$WORKTREE_PATH" ]; then
        cd "$WORKTREE_PATH"

        # Count changes
        STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
        UNSTAGED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
        UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

        if [ "$STAGED" -gt 0 ] || [ "$UNSTAGED" -gt 0 ] || [ "$UNTRACKED" -gt 0 ]; then
            echo -e "  Changes: ${YELLOW}$STAGED staged, $UNSTAGED modified, $UNTRACKED untracked${NC}"
        else
            echo -e "  Changes: ${GREEN}Clean${NC}"
        fi

        # Last commit info
        LAST_COMMIT=$(git log -1 --format="%h %s" 2>/dev/null || echo "No commits")
        echo "  Last: $LAST_COMMIT"

        cd "$PROJECT_PATH"
    fi

    echo ""
done

# Show .swarm/stato if exists
if [ -d "$PROJECT_PATH/.swarm/stato" ]; then
    echo -e "${YELLOW}═══ CERVELLA STATUS (.swarm/stato/) ═══${NC}"
    echo ""

    for stato_file in "$PROJECT_PATH/.swarm/stato"/*.md; do
        if [ -f "$stato_file" ]; then
            CERVELLA_NAME=$(basename "$stato_file" .md)
            echo -e "${CYAN}[$CERVELLA_NAME]${NC}"

            # Extract "Cosa Sto Facendo" section
            if grep -q "Cosa Sto Facendo" "$stato_file"; then
                # Get first task line after "Cosa Sto Facendo"
                DOING=$(grep -A 3 "Cosa Sto Facendo" "$stato_file" | grep -E "^\[" | head -1 || echo "  (non specificato)")
                echo "  $DOING"
            fi
            echo ""
        fi
    done
fi

# Show locks if any
if [ -d "$PROJECT_PATH/.swarm/locks" ]; then
    LOCKS=$(find "$PROJECT_PATH/.swarm/locks" -name "*.lock" 2>/dev/null)
    if [ -n "$LOCKS" ]; then
        echo -e "${RED}═══ ACTIVE LOCKS ═══${NC}"
        echo ""
        for lock in $LOCKS; do
            echo -e "${RED}🔒 $(basename "$lock")${NC}"
            cat "$lock" 2>/dev/null | head -5
            echo ""
        done
    fi
fi

# Summary
echo -e "${BLUE}═══ SUMMARY ═══${NC}"
TOTAL_WORKTREES=$(git worktree list | wc -l | tr -d ' ')
PARALLEL_WORKTREES=$((TOTAL_WORKTREES - 1))
echo "Total worktrees: $TOTAL_WORKTREES (1 main + $PARALLEL_WORKTREES parallel)"
