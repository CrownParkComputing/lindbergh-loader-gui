#!/bin/bash

# Exit on error
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Building Lindbergh Core${NC}"

# Check if dependencies are installed
if [ ! -f "/usr/lib32/libFAudio.so" ]; then
    echo -e "${RED}Dependencies not found. Running install-dependencies.sh...${NC}"
    ./install-dependencies.sh
fi

# Create and enter build directory
mkdir -p build
cd build

# Build using make
echo -e "\n${GREEN}Building core components...${NC}"
make -f ../Makefile

echo -e "\n${GREEN}Build complete! Executables can be found in build/${NC}"
