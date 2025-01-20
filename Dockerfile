FROM ubuntu:22.04 AS lindbergh-build

# Add i386 architecture and update package lists
RUN dpkg --add-architecture i386 \
    && apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        build-essential \
        gcc-multilib \
        freeglut3-dev:i386 \
        libsdl2-dev:i386 \
        libfaudio-dev:i386 \
        libasound2-dev:i386 \
        libglu1-mesa-dev:i386 \
        libxmu-dev:i386 \
        libstdc++5:i386 \
        pipewire:i386 \
        pipewire-alsa:i386 \
        ca-certificates \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /lindbergh-loader

# Copy source files
COPY . .

# Build the loader
RUN make clean && make

# Create a runtime stage with minimal dependencies
FROM ubuntu:22.04 AS lindbergh-runtime

# Add i386 architecture and install runtime dependencies
RUN dpkg --add-architecture i386 \
    && apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        freeglut3:i386 \
        libsdl2-2.0-0:i386 \
        libfaudio0:i386 \
        libasound2:i386 \
        libglu1-mesa:i386 \
        libxmu6:i386 \
        libstdc++5:i386 \
        pipewire:i386 \
        pipewire-alsa:i386 \
        net-tools \
        libc6:i386 \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy only the necessary files from build stage
COPY --from=lindbergh-build /lindbergh-loader/build ./build

# Set environment variables
ENV LD_LIBRARY_PATH=/app/build
ENV PRELOAD_ARCH=i386-linux-gnu

# Set up entrypoint script
COPY --chmod=755 <<-"EOF" /app/entrypoint.sh
#!/bin/bash
export LD_LIBRARY_PATH=/app/build:/lib/i386-linux-gnu:/usr/lib/i386-linux-gnu:$LD_LIBRARY_PATH
export LD_PRELOAD=/app/build/lindbergh.so
linux32 ./build/lindbergh "$@"
EOF

# Default command
ENTRYPOINT ["/app/entrypoint.sh"]
