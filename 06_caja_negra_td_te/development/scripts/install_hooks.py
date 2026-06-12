"""Cross-platform script to install git hooks."""

import os
import subprocess
import sys


def install_hooks():
    """Configure git to use the project's .githooks directory."""
    try:
        # Get the project directory (parent of 'scripts')
        project_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

        # Get the git root
        git_root = subprocess.check_output(
            ["git", "-C", project_dir, "rev-parse", "--show-toplevel"], text=True
        ).strip()

        # Target hooks path
        hooks_dir = os.path.join(project_dir, ".githooks")

        # Calculate relative path from GIT_ROOT to PROJECT_DIR/.githooks
        relative_hooks_path = os.path.relpath(hooks_dir, git_root).replace(os.sep, "/")

        print(f"Setting git core.hooksPath to {relative_hooks_path}")
        subprocess.check_call(["git", "config", "core.hooksPath", relative_hooks_path])

        print("Hooks installed successfully.")
    except Exception as e:
        print(f"Error installing hooks: {e}")
        sys.exit(1)


if __name__ == "__main__":
    install_hooks()
