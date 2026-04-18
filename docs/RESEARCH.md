# NyxDE — Research & Architecture Notes

## What We're Building

Full custom Hyprland shell using Quickshell (Qt6/QML) — same rendering stack as KDE Plasma. Goal is a visually polished, animated desktop with wallpaper-driven color extraction, multiple themes, and system modes (gaming, study, etc.). Not a fork of anything — built from scratch with our own C++ plugin.

## References Studied

### hyprdots (prasanthrangan/hyprdots)
The rice currently installed. Good reference for what components a full rice needs and how they wire together. Key takeaway: their wallbash color pipeline (wallpaper → imagemagick → placeholder substitution across all app configs) is the right idea but poorly implemented — compiled binary dependency, raw file copies instead of symlinks, no modes. We replicate the concept in C++ (ImageAnalyser) with a cleaner architecture.

### caelestia-dots/shell
Best Quickshell rice found. Full QML shell with a proper C++ plugin (`Caelestia.*`). Key things studied:
- **Architecture**: modular QML — `modules/bar/`, `modules/notifications/`, `modules/launcher/` etc., each self-contained
- **Animation system**: custom `Anim.qml` wrapper around `NumberAnimation` with Material Design 3 timing tokens (standard, emphasized, spatial curves). Every property change has a `Behavior` block.
- **Color system**: Material Design 3 palette loaded from a JSON file at `~/.cache/scheme.json`. QML singleton `Colours` exposes palette tokens. Colors animate on change via `CAnim`.
- **Config system**: hierarchical C++ `GlobalConfig` singleton backed by a JSON file with file watching — changes reload live.
- **Popouts**: hover-triggered context panels per module (audio slider, BT device list, etc.) with animated slide-in.
- **LazyListView**: custom C++ `QQuickItem` for efficiently rendering large lists (only visible items instantiated).
- **Blob shapes**: spring-physics `BlobRect` with custom GLSL shaders — purely aesthetic, skip for now.

**What we take from it**: modular structure, animation patterns, config system design, hover popout pattern.  
**What we skip**: C++ audio visualizer (cava/aubio), blob shapes, NixOS packaging.

## Our C++ Plugin (NyxDE.*)

Built and installed. Modules:

| Module | What it does |
|---|---|
| `NyxDE.Config` | JSON-backed config singleton. Theme name, mode, bar settings, appearance tokens. File-watched — edits reload live. |
| `NyxDE.ImageAnalyser` | Extracts dominant color + luminance from a wallpaper image. Runs in a QThreadPool thread. Feeds the color pipeline. |
| `NyxDE.HyprExtras` | Keyboard layout, caps lock state, batch IPC dispatch — things Quickshell.Hyprland doesn't expose. |
| `NyxDE.Logind` | systemd-logind DBus signals: sleep, wake, lock, unlock. |
| `NyxDE.Widgets` | `SparklineItem` (CPU/RAM graph), `ArcGauge` (circular progress), `CircularBuffer` (ring buffer data source). |

## Color Pipeline (planned)

```
awww wallpaper change
  → ImageAnalyser.source = newPath
  → ImageAnalyser.dominantColor (QThread, non-blocking)
  → QML bindings update: bar accent, workspace dots, border
  → write colors to ~/.cache/nyxde/colors.json
  → kitty/hyprlock read from cache on next load
```

## Bar Architecture (current state)

Modular QML under `configs/quickshell/modules/bar/`:
- `Bar.qml` — PanelWindow, layout, pill containers
- `components/` — one file per module (Workspaces, Clock, Volume, Battery, Network, Bluetooth, MediaPlayer, SystemTray, PowerButton)

Currently using pill-shaped `Rectangle` containers with `color: transparent` + Hyprland blur layerrule for frosted glass. Needs visual polish pass once all modules are stable.

## Next Steps

1. Stabilize bar modules (volume via Pipewire, fix remaining warnings)
2. Visual design pass — proper pill sizing, spacing, typography, hover states
3. Notification center (Quickshell.Services.Notifications + sidebar panel)
4. App launcher (Quickshell subprocess → fuzzy search)
5. Color pipeline wired end to end (ImageAnalyser → all QML + cache file)
6. Theme system (NyxConfig.theme → load colors from `themes/{name}/`)
7. Modes (NyxConfig.mode → nyx-mode.sh)
8. OSD (volume/brightness overlay)
9. Settings panel (QML UI writing to NyxConfig)
10. LLM widget (sidebar, HTTP to local/remote model)
