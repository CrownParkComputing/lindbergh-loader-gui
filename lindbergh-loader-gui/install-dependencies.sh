#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing Lindbergh Loader Dependencies${NC}"
echo -e "${YELLOW}This script requires sudo privileges to install packages${NC}"

# Check if yay is installed (for AUR packages)
if ! command -v yay &> /dev/null; then
    echo -e "${RED}yay is not installed. Please install yay first to access AUR packages.${NC}"
    echo "You can install yay by following these steps:"
    echo "1. sudo pacman -S --needed git base-devel"
    echo "2. git clone https://aur.archlinux.org/yay.git"
    echo "3. cd yay && makepkg -si"
    exit 1
fi

# Enable 32-bit architecture
sudo dpkg --add-architecture i386

# Update package lists
sudo pacman -Sy

# Install required 32-bit libraries
sudo pacman -S --needed \
    lib32-mesa \
    lib32-glu \
    lib32-libglvnd \
    lib32-libx11 \
    lib32-libxext \
    lib32-libxmu \
    lib32-libxi \
    lib32-gcc-libs \
    lib32-glibc \
    lib32-libstdc++5 \
    lib32-libxxf86vm \
    lib32-libxrandr \
    lib32-libglvnd \
    lib32-libdbus \
    linux32

# Create compatibility symlinks
if [ ! -e "/usr/lib32/libstdc++.so.5" ]; then
    sudo ln -sf "/usr/lib32/libstdc++.so.6" "/usr/lib32/libstdc++.so.5"
fi

# Create Lindbergh library directory
sudo mkdir -p /usr/local/lib/lindbergh
sudo chmod 755 /usr/local/lib/lindbergh

# Function to install a package
install_package() {
    local package=$1
    local is_aur=${2:-false}
    
    echo -e "${YELLOW}Installing $package...${NC}"
    if [ "$is_aur" = true ]; then
        yay -S --noconfirm "$package" || { echo -e "${RED}Failed to install $package${NC}"; exit 1; }
    else
        sudo pacman -S --noconfirm "$package" || { echo -e "${RED}Failed to install $package${NC}"; exit 1; }
    fi
}

# Main system dependencies
echo -e "\n${GREEN}Installing main system dependencies...${NC}"
PACKAGES=(
    "lib32-freeglut"
    "lib32-sdl2"
    "lib32-alsa-lib"
    "lib32-pipewire"
    "net-tools"
)

for package in "${PACKAGES[@]}"; do
    install_package "$package"
done

# AUR dependencies
echo -e "\n${GREEN}Installing AUR dependencies...${NC}"
AUR_PACKAGES=(
    "lib32-faudio"
)

for package in "${AUR_PACKAGES[@]}"; do
    install_package "$package" true
done

# Create wrapper script for proper 32-bit execution
echo -e "\n${GREEN}Creating wrapper script...${NC}"
WRAPPER_SCRIPT="/usr/local/bin/lindbergh-wrapper"
sudo tee "$WRAPPER_SCRIPT" > /dev/null << 'EOF'
#!/bin/bash
export LD_LIBRARY_PATH="$PWD/build:/usr/lib32:$LD_LIBRARY_PATH"
export LD_PRELOAD="$PWD/build/lindbergh.so"
linux32 ./build/lindbergh "$@"
EOF

sudo chmod +x "$WRAPPER_SCRIPT"

echo -e "\n${GREEN}All dependencies have been installed successfully!${NC}"
echo -e "${YELLOW}You can now build the Lindbergh loader using:${NC}"
echo "make clean && make"
echo -e "\n${YELLOW}To run the loader, use:${NC}"
echo "cd /path/to/lindbergh-loader && lindbergh-wrapper"
