#!/bin/bash

# Get the project directory relative to this script
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# Get the git root
GIT_ROOT="$(git -C "$PROJECT_DIR" rev-parse --show-toplevel)"

# Calculate the relative path from GIT_ROOT to PROJECT_DIR/.githooks
RELATIVE_HOOKS_PATH="$(python3 -c "import os; print(os.path.relpath('$PROJECT_DIR/.githooks', '$GIT_ROOT'))")"

echo "Setting git core.hooksPath to $RELATIVE_HOOKS_PATH"
git config core.hooksPath "$RELATIVE_HOOKS_PATH"

echo "Hooks installed successfully."
