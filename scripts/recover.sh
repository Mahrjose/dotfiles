#!/usr/bin/env bash
# Emergency recovery — run from TTY if desktop is broken.
# Unstows experimental packages, restores stable configs, restarts session.
#
# Usage:
#   ./scripts/recover.sh           # restore stable configs + restart session
#   ./scripts/recover.sh --hard    # also kill Hyprland and relaunch it

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIGS="$DOTFILES/configs"

# Packages that are always expected to work
STABLE_PKGS=(hypr kitty waybar dunst fastfetch)
STABLE_TARGETS=(
    "$HOME/.config/hypr"
    "$HOME/.config/kitty"
    "$HOME/.config/waybar"
    "$HOME/.config/dunst"
    "$HOME/.config/fastfetch"
)

# Packages currently experimental / being worked on
# Add here when you're actively hacking on something
EXPERIMENTAL_PKGS=(quickshell)
EXPERIMENTAL_TARGETS=(
    "$HOME/.config/quickshell"
)

HARD=false
for arg in "$@"; do
    [[ "$arg" == "--hard" ]] && HARD=true
done

log() { echo "  [recover] $*"; }
ok()  { echo "  [ok]      $*"; }
err() { echo "  [error]   $*" >&2; }

echo ""
echo "NyxDE Recovery"
echo "=============="
echo ""

# Step 1: Unstow experimental packages
log "Unstowing experimental packages..."
for i in "${!EXPERIMENTAL_PKGS[@]}"; do
    pkg="${EXPERIMENTAL_PKGS[$i]}"
    target="${EXPERIMENTAL_TARGETS[$i]}"
    if [[ -d "$CONFIGS/$pkg" ]]; then
        stow --dir="$CONFIGS" --target="$target" -D "$pkg" 2>/dev/null && ok "unstowed $pkg" || log "skipped $pkg (not stowed)"
    else
        log "skipped $pkg (no config dir)"
    fi
done

echo ""

# Step 2: Kill processes that might be broken
log "Stopping experimental processes..."

# Kill quickshell if running
if pgrep -x "quickshell" &>/dev/null; then
    pkill -x "quickshell" && ok "killed quickshell" || true
fi

# Kill waybar if running (we'll restart it cleanly)
if pgrep -x "waybar" &>/dev/null; then
    pkill -x "waybar" && ok "killed waybar" || true
fi

# Kill dunst if running
if pgrep -x "dunst" &>/dev/null; then
    pkill -x "dunst" && ok "killed dunst" || true
fi

echo ""

# Step 3: Restow stable packages
log "Restowing stable packages..."
for i in "${!STABLE_PKGS[@]}"; do
    pkg="${STABLE_PKGS[$i]}"
    target="${STABLE_TARGETS[$i]}"
    mkdir -p "$target"
    stow --dir="$CONFIGS" --target="$target" --restow "$pkg" 2>/dev/null && ok "linked $pkg → $target" || err "failed $pkg"
done

echo ""

# Step 4: Restart services if in a Wayland session
if [[ -n "${WAYLAND_DISPLAY:-}" ]] || [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    log "Restarting bar and notification daemon..."

    waybar &>/dev/null & disown
    ok "started waybar"

    dunst &>/dev/null & disown
    ok "started dunst"

    # Reload hyprland config (non-destructive)
    if command -v hyprctl &>/dev/null; then
        hyprctl reload &>/dev/null && ok "reloaded hyprland config"
    fi
else
    log "No Wayland session detected (TTY mode)"
    log "Start Hyprland manually: Hyprland"
fi

# Step 5: Hard mode — kill and relaunch Hyprland from TTY
if [[ "$HARD" == true ]]; then
    echo ""
    log "--hard: killing Hyprland session..."
    if pgrep -x "Hyprland" &>/dev/null; then
        pkill -x "Hyprland" && ok "killed Hyprland"
        sleep 1
    fi
    log "Launching Hyprland..."
    exec Hyprland
fi

# Update dotfiles path cache
mkdir -p "$HOME/.cache"
echo "$DOTFILES" > "$HOME/.cache/dotfiles_path"

echo ""
echo "Recovery complete. If still broken, run: ./scripts/recover.sh --hard"
echo ""
