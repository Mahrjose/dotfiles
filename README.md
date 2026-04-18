# NyxDE

A personal Hyprland rice and desktop environment built on Arch Linux. Configs managed via GNU Stow.

> Work in progress.

## Stack

Hyprland · Quickshell · awww · hyprlock · hypridle · Kitty · Zsh

## Structure

```
configs/    stow packages → symlinked to system paths
plugin/     NyxDE C++ Quickshell plugin (NyxDE.Config, NyxDE.ImageAnalyser, etc.)
scripts/    setup, relink, recovery
themes/     color schemes and wallpaper sets
assets/     fonts, icons, cursors
```

## Setup

```bash
./scripts/setup.sh --personal
```

## Recovery

If the desktop breaks, from any TTY:

```bash
cd ~/Hub/Workshop/dotfiles
./scripts/recover.sh --hard
```
