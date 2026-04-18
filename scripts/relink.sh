#!/usr/bin/env bash
# Relink all dotfiles. Run this after moving the repo or pulling changes.
# Usage: ./scripts/relink.sh [--personal]

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "$DOTFILES/scripts/setup.sh" --personal "$@"

mkdir -p "$HOME/.cache"
echo "$DOTFILES" > "$HOME/.cache/dotfiles_path"
