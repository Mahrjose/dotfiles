#!/usr/bin/env bash
# Build and install the NyxDE Quickshell plugin.
# Usage: ./build.sh [--clean]

set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$PLUGIN_DIR/build"
INSTALL_PREFIX="/usr"

if [[ "${1:-}" == "--clean" ]]; then
    echo "Cleaning build dir..."
    rm -rf "$BUILD_DIR"
fi

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

cmake "$PLUGIN_DIR" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

cmake --build . --parallel "$(nproc)"

echo ""
echo "Build complete. Installing to $INSTALL_PREFIX (requires sudo)..."
sudo cmake --install .

echo ""
echo "Done. Restart quickshell to pick up the new plugin."
