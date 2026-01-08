#!/bin/bash
#
# setup-parallel-worktrees.sh
# Crea worktrees paralleli per multi-instance development
#
# Usage: ./setup-parallel-worktrees.sh [project-path] [worktree-names...]
# Example: ./setup-parallel-worktrees.sh ~/Developer/swarm-test-lab frontend backend testing
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║   🐝 SETUP PARALLEL WORKTREES                               ║"
echo "║   CervellaSwarm Multi-Instance Development                  ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check arguments
if [ $# -lt 2 ]; then
    echo -e "${RED}Usage: $0 <project-path> <worktree-name1> [worktree-name2] ...${NC}"
    echo ""
    echo "Example:"
    echo "  $0 ~/Developer/swarm-test-lab frontend backend testing"
    echo ""
    echo "This will create:"
    echo "  ~/Developer/swarm-test-lab-frontend (branch: parallel/frontend)"
    echo "  ~/Developer/swarm-test-lab-backend (branch: parallel/backend)"
    echo "  ~/Developer/swarm-test-lab-testing (branch: parallel/testing)"
    exit 1
fi

PROJECT_PATH="$1"
shift
WORKTREE_NAMES=("$@")

# Expand path
PROJECT_PATH=$(eval echo "$PROJECT_PATH")

# Validate project path
if [ ! -d "$PROJECT_PATH" ]; then
    echo -e "${RED}Error: Project path does not exist: $PROJECT_PATH${NC}"
    exit 1
fi

if [ ! -d "$PROJECT_PATH/.git" ]; then
    echo -e "${RED}Error: Not a git repository: $PROJECT_PATH${NC}"
    exit 1
fi

# Get project name and parent directory
PROJECT_NAME=$(basename "$PROJECT_PATH")
PARENT_DIR=$(dirname "$PROJECT_PATH")

echo -e "${YELLOW}Project: $PROJECT_NAME${NC}"
echo -e "${YELLOW}Location: $PROJECT_PATH${NC}"
echo -e "${YELLOW}Worktrees to create: ${WORKTREE_NAMES[*]}${NC}"
echo ""

# Change to project directory
cd "$PROJECT_PATH"

# Ensure we're on main/master
MAIN_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
if ! git show-ref --verify --quiet "refs/heads/$MAIN_BRANCH"; then
    MAIN_BRANCH="master"
fi
if ! git show-ref --verify --quiet "refs/heads/$MAIN_BRANCH"; then
    MAIN_BRANCH=$(git branch --show-current)
fi

echo -e "${BLUE}Main branch: $MAIN_BRANCH${NC}"
echo ""

# Create worktrees
CREATED=()
for name in "${WORKTREE_NAMES[@]}"; do
    WORKTREE_PATH="$PARENT_DIR/${PROJECT_NAME}-${name}"
    BRANCH_NAME="parallel/${name}"

    echo -e "${YELLOW}Creating worktree: $name${NC}"
    echo "  Path: $WORKTREE_PATH"
    echo "  Branch: $BRANCH_NAME"

    # Check if worktree already exists
    if [ -d "$WORKTREE_PATH" ]; then
        echo -e "${RED}  ⚠️  Worktree already exists, skipping${NC}"
        continue
    fi

    # Check if branch already exists
    if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
        echo -e "${YELLOW}  Branch exists, using existing branch${NC}"
        git worktree add "$WORKTREE_PATH" "$BRANCH_NAME"
    else
        echo -e "${GREEN}  Creating new branch from $MAIN_BRANCH${NC}"
        git worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME"
    fi

    CREATED+=("$name")
    echo -e "${GREEN}  ✅ Created!${NC}"
    echo ""
done

# Summary
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║   ✅ SETUP COMPLETE!                                        ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo "Created worktrees:"
for name in "${CREATED[@]}"; do
    echo -e "  ${GREEN}✓${NC} ${PROJECT_NAME}-${name} (parallel/${name})"
done

echo ""
echo -e "${BLUE}To start working:${NC}"
for name in "${CREATED[@]}"; do
    echo "  cd $PARENT_DIR/${PROJECT_NAME}-${name} && claude"
done

echo ""
echo -e "${BLUE}To see status:${NC}"
echo "  ./status-parallel-worktrees.sh $PROJECT_PATH"

echo ""
echo -e "${BLUE}To merge when done:${NC}"
echo "  ./merge-parallel-worktrees.sh $PROJECT_PATH"
