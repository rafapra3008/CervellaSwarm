#!/bin/bash
#
# merge-parallel-worktrees.sh
# Merge ordinato di tutti i worktrees paralleli in main
#
# Usage: ./merge-parallel-worktrees.sh [project-path] [--no-cleanup]
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
echo "║   🐝 MERGE PARALLEL WORKTREES                               ║"
echo "║   CervellaSwarm Multi-Instance Development                  ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check arguments
if [ $# -lt 1 ]; then
    echo -e "${RED}Usage: $0 <project-path> [--no-cleanup]${NC}"
    echo "Example: $0 ~/Developer/swarm-test-lab"
    echo ""
    echo "Options:"
    echo "  --no-cleanup    Don't remove worktrees after merge"
    exit 1
fi

PROJECT_PATH="$1"
PROJECT_PATH=$(eval echo "$PROJECT_PATH")
NO_CLEANUP=false

if [ "$2" == "--no-cleanup" ]; then
    NO_CLEANUP=true
fi

# Validate
if [ ! -d "$PROJECT_PATH/.git" ]; then
    echo -e "${RED}Error: Not a git repository: $PROJECT_PATH${NC}"
    exit 1
fi

cd "$PROJECT_PATH"

PROJECT_NAME=$(basename "$PROJECT_PATH")

# Get main branch
MAIN_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
if ! git show-ref --verify --quiet "refs/heads/$MAIN_BRANCH"; then
    MAIN_BRANCH="master"
fi
if ! git show-ref --verify --quiet "refs/heads/$MAIN_BRANCH"; then
    MAIN_BRANCH=$(git branch --show-current)
fi

echo -e "${CYAN}Project: $PROJECT_NAME${NC}"
echo -e "${CYAN}Main branch: $MAIN_BRANCH${NC}"
echo ""

# Get all parallel branches
PARALLEL_BRANCHES=$(git branch --list "parallel/*" | sed 's/^[* ]*//')

if [ -z "$PARALLEL_BRANCHES" ]; then
    echo -e "${YELLOW}No parallel branches found.${NC}"
    exit 0
fi

echo -e "${YELLOW}Branches to merge:${NC}"
for branch in $PARALLEL_BRANCHES; do
    echo "  - $branch"
done
echo ""

# Confirm
echo -e "${YELLOW}This will merge all parallel branches into $MAIN_BRANCH.${NC}"
read -p "Continue? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Ensure main is checked out
echo -e "${BLUE}Switching to $MAIN_BRANCH...${NC}"
git checkout "$MAIN_BRANCH"
echo ""

# Merge each branch
MERGED=()
FAILED=()

for branch in $PARALLEL_BRANCHES; do
    echo -e "${YELLOW}═══ Merging $branch ═══${NC}"

    # Check if branch has commits ahead of main
    AHEAD=$(git rev-list --count "$MAIN_BRANCH".."$branch" 2>/dev/null || echo "0")

    if [ "$AHEAD" -eq 0 ]; then
        echo -e "${CYAN}  No new commits, skipping${NC}"
        MERGED+=("$branch (no changes)")
        continue
    fi

    echo "  Commits to merge: $AHEAD"

    # Try merge
    if git merge "$branch" --no-edit -m "Merge $branch into $MAIN_BRANCH"; then
        echo -e "${GREEN}  ✅ Merged successfully!${NC}"
        MERGED+=("$branch")
    else
        echo -e "${RED}  ❌ Merge conflict!${NC}"
        echo "  Please resolve conflicts manually, then run:"
        echo "    git add . && git commit"
        FAILED+=("$branch")

        # Abort merge
        git merge --abort 2>/dev/null || true
    fi

    echo ""
done

# Summary
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║   MERGE SUMMARY                                             ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

if [ ${#MERGED[@]} -gt 0 ]; then
    echo -e "${GREEN}Merged successfully:${NC}"
    for branch in "${MERGED[@]}"; do
        echo "  ✅ $branch"
    done
    echo ""
fi

if [ ${#FAILED[@]} -gt 0 ]; then
    echo -e "${RED}Failed (conflicts):${NC}"
    for branch in "${FAILED[@]}"; do
        echo "  ❌ $branch"
    done
    echo ""
    echo -e "${YELLOW}To resolve conflicts manually:${NC}"
    echo "  1. git merge <branch-name>"
    echo "  2. Resolve conflicts in files"
    echo "  3. git add . && git commit"
    echo ""
fi

# Cleanup worktrees if requested
if [ "$NO_CLEANUP" = false ] && [ ${#FAILED[@]} -eq 0 ]; then
    echo -e "${YELLOW}Cleaning up worktrees...${NC}"

    for branch in $PARALLEL_BRANCHES; do
        # Get worktree path for this branch
        WORKTREE_INFO=$(git worktree list | grep "\[$branch\]" || true)

        if [ -n "$WORKTREE_INFO" ]; then
            WORKTREE_PATH=$(echo "$WORKTREE_INFO" | awk '{print $1}')

            if [ "$WORKTREE_PATH" != "$PROJECT_PATH" ]; then
                echo "  Removing worktree: $WORKTREE_PATH"
                git worktree remove "$WORKTREE_PATH" --force 2>/dev/null || true
            fi
        fi

        # Delete branch
        echo "  Deleting branch: $branch"
        git branch -d "$branch" 2>/dev/null || git branch -D "$branch" 2>/dev/null || true
    done

    echo -e "${GREEN}Cleanup complete!${NC}"
else
    echo -e "${CYAN}Worktrees preserved. To cleanup later:${NC}"
    echo "  ./cleanup-parallel-worktrees.sh $PROJECT_PATH"
fi

echo ""
echo -e "${GREEN}Done! All parallel work merged into $MAIN_BRANCH.${NC}"
