#!/bin/bash
# =============================================================================
# Installa gli hook git di CervellaSwarm
# =============================================================================
#
# Uso: ./scripts/hooks/install.sh
#
# Copia gli hook da scripts/hooks/ a .git/hooks/
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIT_HOOKS_DIR="$(git rev-parse --git-dir)/hooks"

echo "Installing CervellaSwarm git hooks..."

# Copy pre-commit
if [ -f "$SCRIPT_DIR/pre-commit" ]; then
    cp "$SCRIPT_DIR/pre-commit" "$GIT_HOOKS_DIR/pre-commit"
    chmod +x "$GIT_HOOKS_DIR/pre-commit"
    echo "  [OK] pre-commit installed"
fi

echo ""
echo "Done! Hooks installed in $GIT_HOOKS_DIR"
