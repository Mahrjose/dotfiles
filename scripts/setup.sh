#!/usr/bin/env bash
# Usage: ./scripts/setup.sh [--personal] [--dry-run] [--relink]
#   --personal  also link personal configs (zsh, claude)
#   --dry-run   show what would be linked without doing it
#   --relink    relink everything including personal (calls relink.sh)

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIGS="$DOTFILES/configs"
PERSONAL=false
DRY=false

for arg in "$@"; do
    case $arg in
        --personal) PERSONAL=true ;;
        --dry-run)  DRY=true ;;
        --relink)   exec "$DOTFILES/scripts/relink.sh" ;;
    esac
done

stow_pkg() {
    local pkg="$1"
    local target="$2"

    if [[ "$DRY" == true ]]; then
        echo "[dry-run] stow $pkg → $target"
        return
    fi

    mkdir -p "$target"
    stow --dir="$CONFIGS" --target="$target" --restow "$pkg"
    echo "  linked $pkg → $target"
}

echo "Setting up dotfiles from $DOTFILES"
echo ""

echo "[ configs ]"
stow_pkg hypr      "$HOME/.config/hypr"
stow_pkg kitty     "$HOME/.config/kitty"
stow_pkg waybar    "$HOME/.config/waybar"
stow_pkg dunst     "$HOME/.config/dunst"
stow_pkg fastfetch "$HOME/.config/fastfetch"

if [[ "$PERSONAL" == true ]]; then
    echo ""
    echo "[ personal ]"
    stow_pkg zsh    "$HOME"
    stow_pkg claude "$HOME/.claude"
fi

# Save current dotfiles path so shell can detect if it moves
mkdir -p "$HOME/.cache"
echo "$DOTFILES" > "$HOME/.cache/dotfiles_path"

echo ""
echo "Done."
