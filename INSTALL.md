# Installation Instructions

This document provides detailed installation instructions for different Linux distributions.

## Table of Contents
- [Arch Linux / Manjaro](#arch-linux--manjaro)
- [Ubuntu / Linux Mint / Pop!_OS](#ubuntu--linux-mint--pop_os)
- [Fedora](#fedora)
- [Game-Specific Setup](#game-specific-setup)

## Arch Linux / Manjaro

### 1. Install Required Dependencies
```bash
# Install 32-bit libraries and NVIDIA dependencies
sudo pacman -S lib32-nvidia-utils lib32-nvidia-cg-toolkit

# Install Flutter
sudo pacman -S flutter
```

### 2. Setup Library Directory
```bash
# Create Lindbergh library directory
sudo mkdir -p /usr/local/lib32/lindbergh

# Link required libraries
sudo ln -s /usr/lib32/libCg.so /usr/local/lib32/lindbergh/
sudo ln -s /usr/lib32/libCgGL.so /usr/local/lib32/lindbergh/
```

## Ubuntu / Linux Mint / Pop!_OS

### 1. Enable 32-bit Architecture
```bash
sudo dpkg --add-architecture i386
sudo apt update
```

### 2. Install Required Dependencies
```bash
# Install 32-bit libraries and NVIDIA dependencies
sudo apt install -y \
    libc6:i386 \
    libstdc++6:i386 \
    libx11-6:i386 \
    libgl1-nvidia-glx:i386 \
    nvidia-cg-toolkit

# Install Flutter
sudo snap install flutter --classic
```

### 3. Setup Library Directory
```bash
# Create Lindbergh library directory
sudo mkdir -p /usr/local/lib32/lindbergh

# Link required libraries
sudo ln -s /usr/lib/i386-linux-gnu/libCg.so /usr/local/lib32/lindbergh/
sudo ln -s /usr/lib/i386-linux-gnu/libCgGL.so /usr/local/lib32/lindbergh/
```

## Fedora

### 1. Enable RPM Fusion Repository
```bash
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

### 2. Install Required Dependencies
```bash
# Enable 32-bit repository
sudo dnf install dnf-plugins-core
sudo dnf config-manager --set-enabled fedora-cisco-openh264

# Install 32-bit libraries and NVIDIA dependencies
sudo dnf install -y \
    glibc.i686 \
    libstdc++.i686 \
    libX11.i686 \
    nvidia-driver-libs.i686 \
    nvidia-cg-toolkit.i686

# Install Flutter
sudo dnf install flutter
```

### 3. Setup Library Directory
```bash
# Create Lindbergh library directory
sudo mkdir -p /usr/local/lib32/lindbergh

# Link required libraries
sudo ln -s /usr/lib/libCg.so /usr/local/lib32/lindbergh/
sudo ln -s /usr/lib/libCgGL.so /usr/local/lib32/lindbergh/
```

## Game-Specific Setup

### Let's Go Jungle!

1. Create shader directories:
```bash
sudo mkdir -p /shader/Cg
sudo cp -r "game_directory/shader/Cg/*" /shader/Cg/
```

2. Configure `lindbergh.conf`:
```ini
# Set GPU vendor to NVIDIA
GPU_VENDOR 1

# Disable Mesa rendering patches
LGJ_RENDER_WITH_MESA 0

# Enable debug messages
DEBUG_MSGS 1
```

3. Run the game:
```bash
cd "game_directory"
LD_LIBRARY_PATH=/usr/local/lib32/lindbergh:. ./lindbergh
```

### Too Spicy

1. Create shader directories:
```bash
sudo mkdir -p /shader/compiledshader
sudo cp -r "game_directory/fs/compiledshader/*" /shader/compiledshader/
```

2. Configure `lindbergh.conf`:
```ini
# Set GPU vendor to NVIDIA
GPU_VENDOR 1

# Disable Mesa rendering patches
LGJ_RENDER_WITH_MESA 0

# Enable debug messages
DEBUG_MSGS 1
```

3. Run the game:
```bash
cd "game_directory/elf"
LIBGL_ALWAYS_INDIRECT=0 __GL_THREADED_OPTIMIZATIONS=0 __GL_SYNC_TO_VBLANK=0 LD_LIBRARY_PATH=/usr/local/lib32/lindbergh:. ./lindbergh
```

Note: Too Spicy currently has issues with X11 thread handling that may cause crashes.

## Troubleshooting

### Common Issues

1. **Missing shader files**
   - Error: "Program error at position: XXXX"
   - Solution: Make sure shader files are copied to the correct location (/shader/Cg or /shader/compiledshader)

2. **Library version errors**
   - Error: "no version information available"
   - Solution: These warnings for libCgGL.so and libCg.so can be safely ignored

3. **X11 thread errors (Too Spicy)**
   - Error: "XInitThreads has not been called"
   - Current Status: Known issue, under investigation

### Distribution-Specific Issues

#### Ubuntu
- If NVIDIA drivers are not detected, you may need to install them from the Graphics Drivers PPA:
  ```bash
  sudo add-apt-repository ppa:graphics-drivers/ppa
  sudo apt update
  sudo apt install nvidia-driver-xxx
  ```

#### Arch Linux
- If you encounter missing 32-bit libraries, make sure multilib repository is enabled in `/etc/pacman.conf`:
  ```ini
  [multilib]
  Include = /etc/pacman.d/mirrorlist
  ```

#### Fedora
- If NVIDIA drivers are not working, you might need to install them from RPM Fusion:
  ```bash
  sudo dnf install akmod-nvidia
  ```
