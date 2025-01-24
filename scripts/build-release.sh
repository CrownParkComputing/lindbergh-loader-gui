#!/bin/bash

# Exit on any error
set -e

# Enable debug output
set -x

# Get absolute path to the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Script directory: $SCRIPT_DIR"

# Try to find the Flutter project directory
if [ -d "./lindbergh-loader-gui" ]; then
    PROJECT_DIR="./lindbergh-loader-gui"
elif [ -d "../lindbergh-loader-gui" ]; then
    PROJECT_DIR="../lindbergh-loader-gui"
else
    echo "Error: Cannot find lindbergh-loader-gui directory"
    exit 1
fi

# Create release directory in the workspace root
RELEASE_DIR="$SCRIPT_DIR/release"
rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

# Change to project directory
cd "$PROJECT_DIR"
echo "Current directory after cd: $(pwd)"
ls -la  # Debug: show directory contents

# Create required asset directories
mkdir -p assets/images
mkdir -p assets/icons

# Copy SEGA logo if it exists
if [ -f "/home/jon/Downloads/sega-logo-png-sega-logos-img-5000x1511.png" ]; then
    cp "/home/jon/Downloads/sega-logo-png-sega-logos-img-5000x1511.png" "assets/images/sega-logo.png"
fi

# Build the application
flutter clean
flutter pub get
flutter build linux --release

# Copy executable and required files to workspace release directory
cp -r build/linux/x64/release/bundle/* "$RELEASE_DIR"/

# Create icons directory and copy icons
mkdir -p "$RELEASE_DIR"/icons
if [ -d "assets/icons" ]; then
    cp -r assets/icons/* "$RELEASE_DIR"/icons/
fi

echo "Release package created in $RELEASE_DIR directory"
