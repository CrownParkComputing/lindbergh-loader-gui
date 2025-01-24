#!/bin/bash

# Exit on any error
set -e

# Enable debug output
set -x

# Get absolute path to the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Script directory: $SCRIPT_DIR"

# Change to project directory using absolute path
cd "$SCRIPT_DIR/lindbergh-loader-gui"
echo "Current directory after cd: $(pwd)"

# Create release directory in workspace root
RELEASE_DIR="$SCRIPT_DIR/release"
rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

# Create required asset directories
mkdir -p assets/images
mkdir -p assets/icons

# Copy SEGA logo if it exists
if [ -f "/home/jon/Downloads/sega-logo-png-sega-logos-img-5000x1511.png" ]; then
    cp "/home/jon/Downloads/sega-logo-png-sega-logos-img-5000x1511.png" "assets/images/sega-logo.png"
    # Also copy to the data directory for the taskbar icon
    mkdir -p "$RELEASE_DIR"/data
    cp "assets/images/sega-logo.png" "$RELEASE_DIR"/data/
fi

# Build the application
flutter clean
flutter pub get
flutter build linux --release

# Copy executable and required files
cp -r build/linux/x64/release/bundle/* "$RELEASE_DIR"/

# Create icons directory and copy icons
mkdir -p "$RELEASE_DIR"/icons
if [ -d "assets/icons" ]; then
    cp -r assets/icons/* "$RELEASE_DIR"/icons/
fi

echo "Release package created in $RELEASE_DIR directory" 