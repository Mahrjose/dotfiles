#!/usr/bin/env bash
# Run this manually if you move or rename the dotfiles repo.
# Usage: ./scripts/relink.sh [--personal]

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CACHE="$HOME/.cache/dotfiles_path"

echo "Relinking dotfiles from $DOTFILES..."
bash "$DOTFILES/scripts/setup.sh" "$@"

mkdir -p "$HOME/.cache"
echo "$DOTFILES" > "$CACHE"
echo "Path saved to $CACHE"
