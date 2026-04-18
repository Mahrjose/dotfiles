#!/usr/bin/env bash
# Run this if you move or rename the dotfiles repo.
# Usage: ./scripts/relink.sh

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Relinking dotfiles from $DOTFILES..."
bash "$DOTFILES/scripts/setup.sh" --personal

mkdir -p "$HOME/.cache"
echo "$DOTFILES" > "$HOME/.cache/dotfiles_path"
