#!/bin/bash

# Exit on any error
set -e

# Install required system dependencies for Flutter Linux desktop
sudo pacman -S --needed \
    clang \
    cmake \
    ninja \
    gtk3 \
    xz \
    zenity

# Install Flutter dependencies
flutter pub get

echo "Dependencies installed successfully"
