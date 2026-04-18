#!/usr/bin/env bash
# Dotfiles install script
# Usage: ./install.sh [--personal] [--package <name>]
#
# --personal   also deploy personal configs (zsh, git, claude)
# --package    deploy a single package by name

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="$DOTFILES_DIR/manifest.toml"
PERSONAL=false
TARGET_PKG=""

for arg in "$@"; do
    case $arg in
        --personal) PERSONAL=true ;;
        --package) shift; TARGET_PKG="$1" ;;
    esac
done

if ! command -v stow &>/dev/null; then
    echo "Error: GNU Stow is not installed. Install it with: sudo pacman -S stow"
    exit 1
fi

deploy() {
    local name="$1"
    local source="$2"
    local target="$3"
    local personal="$4"

    [[ -n "$TARGET_PKG" && "$name" != "$TARGET_PKG" ]] && return
    [[ "$personal" == "true" && "$PERSONAL" == "false" ]] && return

    target="${target/#\~/$HOME}"
    mkdir -p "$target"

    echo "  -> $name ($source → $target)"
    stow --dir="$DOTFILES_DIR" --target="$target" --restow "$source"
}

echo "Deploying dotfiles..."

# Parse manifest.toml manually (no toml parser dependency)
current_pkg=""
declare -A pkg

while IFS= read -r line; do
    if [[ "$line" =~ ^\[([a-zA-Z0-9_-]+)\] ]]; then
        if [[ -n "$current_pkg" ]]; then
            deploy "$current_pkg" "${pkg[source]}" "${pkg[target]}" "${pkg[personal]:-false}"
        fi
        current_pkg="${BASH_REMATCH[1]}"
        pkg=()
    elif [[ "$line" =~ ^([a-z]+)\ =\ \"?([^\"#]+)\"? ]]; then
        key="${BASH_REMATCH[1]}"
        val="${BASH_REMATCH[2]}"
        val="${val%\"}"
        val="${val% }"
        pkg[$key]="$val"
    fi
done < "$MANIFEST"

# Deploy last package
[[ -n "$current_pkg" ]] && deploy "$current_pkg" "${pkg[source]}" "${pkg[target]}" "${pkg[personal]:-false}"

echo "Done."
