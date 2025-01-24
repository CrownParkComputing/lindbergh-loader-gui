#!/bin/bash

# Exit on any error
set -e

# Function to print colored output
print_status() {
    echo -e "\e[1;34m==>\e[0m \e[1m$1\e[0m"
}

print_error() {
    echo -e "\e[1;31m==>\e[0m \e[1m$1\e[0m" >&2
}

# Check if running on Arch Linux
if [ ! -f /etc/arch-release ]; then
    print_error "This script is intended for Arch Linux"
    exit 1
fi

# Change to project directory
cd "$(dirname "$0")/lindbergh-loader-gui"

print_status "Installing system dependencies..."
sudo pacman -S --needed \
    clang \
    cmake \
    ninja \
    gtk3 \
    xz \
    zenity

print_status "Installing Flutter dependencies..."
flutter pub get

print_status "Dependencies installed successfully" 