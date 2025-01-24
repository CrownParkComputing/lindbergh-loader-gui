#!/bin/bash

# Create release directory
RELEASE_DIR="release"
rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

# Build Flutter app
flutter build linux --release

# Copy build files to release directory
cp -r build/linux/x64/release/bundle/* "$RELEASE_DIR/"

# Create assets directory structure
mkdir -p "$RELEASE_DIR/assets/icons"
mkdir -p "$RELEASE_DIR/data"

# Copy any existing icons or assets
if [ -d "assets/icons" ]; then
    cp -r assets/icons/* "$RELEASE_DIR/assets/icons/"
fi

# Copy games data file if it exists
if [ -f "data/games.json" ]; then
    cp data/games.json "$RELEASE_DIR/data/"
fi

echo "Build complete! Release package is in the $RELEASE_DIR directory"
