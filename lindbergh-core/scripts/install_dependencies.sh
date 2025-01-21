#!/bin/bash

# Enable multilib if not already enabled
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    sudo sed -i '/^#\[multilib\]/{N;s/^#//;s/\n#/\n/}' /etc/pacman.conf
    sudo pacman -Sy
fi

# Install 32-bit libraries required for Lindbergh games on Arch Linux
sudo pacman -S --needed --noconfirm --overwrite '/usr/lib32/*' \
    lib32-ncurses \
    lib32-ncurses5-compat-libs \
    lib32-libx11 \
    lib32-libxext \
    lib32-libxrandr \
    lib32-libxinerama \
    lib32-libxi \
    lib32-libxcursor \
    lib32-libxcomposite \
    lib32-libxdamage \
    lib32-libxfixes \
    lib32-libxrender \
    lib32-libxtst


# Install lindbergh-core dependencies
cd ../../lindbergh-core
./install-dependencies.sh

# Verify and create proper ncurses symlink
if [ ! -f /usr/lib32/libncurses.so.5 ]; then
    sudo ln -sf /usr/lib32/libncurses.so.6 /usr/lib32/libncurses.so.5
fi

# Verify library installation
echo "Verifying 32-bit library installation..."
ldconfig -p | grep lib32

# Build ncurses 5.9 from source with explicit 32-bit configuration
echo "Building ncurses from source with 32-bit configuration..."
temp_dir=$(mktemp -d)
cd $temp_dir
wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz
echo "Verifying download integrity..."
sha256sum ncurses-5.9.tar.gz | grep -q '8cb9c412e5f2d96bc6f459aa8c6282a1' || { echo "Download verification failed"; exit 1; }

tar xzf ncurses-5.9.tar.gz
cd ncurses-5.9

# Explicit 32-bit build configuration
export CC="gcc -m32"
export CXX="g++ -m32"
./configure \
    --prefix=/usr \
    --libdir=/usr/lib32 \
    --with-shared \
    --without-debug \
    --enable-widec \
    --enable-pc-files \
    --with-abi-version=5 \
    --with-versioned-syms

make -j$(nproc)
sudo make install

# Verify installation
echo "Verifying ncurses installation..."
if [ ! -f /usr/lib32/libncurses.so.5 ]; then
    echo "Failed to install libncurses.so.5"
    exit 1
fi

# Ensure /usr/lib32 exists and is writable
sudo mkdir -p /usr/lib32
sudo chmod 755 /usr/lib32

# Create additional symlinks
sudo ln -sf /usr/lib32/libncursesw.so.5 /usr/lib32/libncurses.so.5
sudo ln -sf /usr/lib32/libncursesw.so.5 /usr/lib32/libtinfo.so.5
sudo ln -sf /usr/lib32/libncurses.so.5 /usr/lib32/libncurses.so
sudo ln -sf /usr/lib32/libtinfo.so.5 /usr/lib32/libtinfo.so

# Add library path configuration
echo "/usr/lib32" | sudo tee /etc/ld.so.conf.d/lib32.conf > /dev/null
sudo ldconfig

# Clean up
cd /
rm -rf $temp_dir

# Verify ncurses installation
echo "Verifying ncurses installation:"
ls -lh /usr/lib32/libncurses*
file /usr/lib32/libncurses.so.5
ldconfig -p | grep lib32
