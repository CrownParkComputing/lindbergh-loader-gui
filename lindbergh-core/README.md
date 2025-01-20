[![Actions Status](https://github.com/lindbergh-loader/lindbergh-loader/actions/workflows/ci.yml/badge.svg)](https://github.com/lindbergh-loader/lindbergh-loader/actions)

# SEGA Lindbergh Emulator

This project emulates the SEGA Lindbergh, allowing games to run on modern Linux computers to be used as replacement hardware for broken Lindbergh systems in physical arcade machines. It supports both Intel and AMD CPUs as well as Intel, NVIDIA and AMD GPUs, surround sound audio, networking and JVS pass through.

If you'd like to support the development work of this emulator, see early development builds or get support from the authors please consider [becoming a patreon here](https://www.patreon.com/LindberghLoader).

If you need any help please ask the community in the [arcade community discord](https://arcade.community). Please only submit issues if they are bugs with the software, ask in the arcade community discord if you're not sure if it's a bug or you're not setting something up properly!

## Dependencies

The Lindbergh loader requires several 32-bit libraries to function properly. On Arch Linux and its derivatives, you can install all required dependencies using the provided installation script:

```bash
./install-dependencies.sh
```

The script will:
1. Install all required dependencies
2. Create a wrapper script for proper 32-bit execution
3. Set up the necessary environment variables

### Manual Installation

If you prefer to install dependencies manually, you'll need the following packages:

#### Pacman packages:
- lib32-freeglut
- lib32-sdl2
- lib32-alsa-lib
- lib32-glu
- lib32-libxmu
- lib32-pipewire (for audio support)
- net-tools (for networking support)

#### AUR packages:
- lib32-faudio
- lib32-libstdc++5

To install AUR packages, you'll need an AUR helper like `yay`. You can install them manually using:
```bash
yay -S lib32-faudio lib32-libstdc++5
```

## Building

After installing all dependencies, build the loader using:

```bash
make clean && make
```

The compiled binaries will be placed in the `build` directory.

## Running

### Native Installation
If you installed using the installation script, simply run:
```bash
cd /path/to/lindbergh-loader
lindbergh-wrapper
```

### Docker Installation
You can also run the loader using Docker:
```bash
docker build -t lindbergh-loader .
docker run --rm -it \
  --device=/dev/dri \
  --device=/dev/snd \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  --privileged \
  lindbergh-loader
```

Note: The `--privileged` flag might be necessary for proper 32-bit operation and hardware access. Add `--network host` if the game requires network access.

## Building & Running

In order to build the loader you will need to install the following dependencies in a Linux environment. We recommend Ubuntu 22.04 LTS as default, but it may work in various configurations like WSL2, Debian, etc.  
Please note other dependencies might be required to run games (see the [guide](docs/guide.md)).

```shell
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install git build-essential gcc-multilib freeglut3-dev:i386 libsdl2-dev:i386 libfaudio-dev:i386
```

This emulator will need access to the input devices and serial devices on your computer. You should add your user account to the following groups and then _restart your computer_.

```shell
sudo usermod -a -G dialout,input $USER
```

Then you should clone the repository, change directory into it and run make.

```shell
git clone git@github.com:lindbergh-loader/lindbergh-loader.git
cd lindbergh-loader
make
```

You should then copy the contents of the build directory to your game directory and run `./lindbergh` for the game, or `./lindbergh -t` for test mode. Please note you might need to set the game executable as "executable" using `chmod +x`.

```shell
cp -a build/* /home/games/the-house-of-the-dead-4/disk0/elf/.
cd /home/games/the-house-of-the-dead-4/disk0/elf/.
./lindbergh
```

If you'd like to change game settings copy the [default configuration file](docs/lindbergh.conf) from the repository to your game directory.

```shell
cp build/docs/lindbergh.conf /home/games/the-house-of-the-dead-4/disk0/elf/.
nano lindbergh.conf
```

Please take a look at the configuration options, supported games and known issues in the [guide](docs/guide.md).

## License

<p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://github.com/lindbergh-loader/">Lindbergh Loader</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/lindbergh-loader/">Lindbergh Loader Development Team</a> is licensed under <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" alt=""></a></p>

Our project is open source, and our primary goal is to preserve and maintain Lindbergh arcade machines, ensuring they continue to operate in arcades. We encourage individuals to use the information provided for their own open source projects and contribute to the development of the loader to improve it for the benefit of the community. However, we do not permit the use of any of our code in pay-to-play/subscription/commercial ventures without prior consent from the Lindbergh Loader Development Team. If we become aware of any such use, we reserve the right to take legal action.

## Thanks

This project has been built by referencing various earlier projects and would like to extend it's thanks to everyone that has contributed to the Lindbergh scene.

## Takedown Notices

The Lindbergh Loader Development Team respects intellectual property rights and is committed to ensuring that no copyrighted material is shared without proper authorization. If you believe that we are infringing on your intellectual property or have any concerns regarding our activities, please email us at bobby [at] dilley [dot] uk. We are more than happy to address any issues and discuss them further.

[![Core Build Status](https://github.com/lindbergh-loader/lindbergh-loader/actions/workflows/lindbergh-core.yml/badge.svg)](https://github.com/lindbergh-loader/lindbergh-loader/actions/workflows/lindbergh-core.yml)

# Lindbergh Core

This project is a fork of the original [Lindbergh Loader](https://github.com/lindbergh-loader/lindbergh-loader) project. All core functionality and intellectual property belongs to the original Lindbergh Loader Development Team.

## Original Project Credits
- Project: [Lindbergh Loader](https://github.com/lindbergh-loader/lindbergh-loader)
- Authors: The Lindbergh Loader Development Team
- License: Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International

If you'd like to support the development work of the original emulator, please consider [becoming a patron](https://www.patreon.com/LindberghLoader).

## About This Fork

This repository contains the core emulation component extracted from the original Lindbergh Loader project. We maintain this separation to provide a cleaner development experience for the GUI frontend while preserving all the original functionality and licensing terms.

All improvements and modifications made in this fork will be contributed back to the original project whenever possible.

## Features

- Full emulation of SEGA Lindbergh hardware
- JVS (Jamma Video Standard) support
- Audio emulation with surround sound support
- Network functionality
- GPU compatibility with Intel, NVIDIA, and AMD

## Building from Source

### Dependencies

The following 32-bit libraries are required:

#### Arch Linux
```bash
# Core dependencies
sudo pacman -S lib32-freeglut lib32-sdl2 lib32-alsa-lib lib32-glu lib32-libxmu lib32-pipewire net-tools

# AUR packages (using yay)
yay -S lib32-faudio lib32-libstdc++5
```

#### Ubuntu/Debian
```bash
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install \
    gcc-multilib \
    g++-multilib \
    libstdc++6:i386 \
    libglu1-mesa:i386 \
    libgl1-mesa-dev:i386 \
    libxmu6:i386 \
    libfreeglut3:i386 \
    libasound2:i386 \
    libsdl2-2.0-0:i386
```

### Building

1. Install dependencies:
```bash
./install-dependencies.sh
```

2. Build the project:
```bash
make clean && make
```

The compiled binaries will be in the `build/` directory:
- `lindbergh` (main executable)
- `lindbergh.so` (core library)
- `libsegaapi.so` (SEGA API implementation)
- `libkswapapi.so` (memory management)
- `libposixtime.so` (time management)

## Usage

1. Install the dependencies
2. Build the project
3. Configure your game paths
4. Run the loader with your game

For detailed usage instructions and game-specific configuration, please refer to our [Wiki](https://github.com/lindbergh-loader/lindbergh-loader/wiki).

## License

This project is licensed under Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International. See the LICENSE file for details.

## Contributing

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

## Support

If you need help, please:
1. Check our [Wiki](https://github.com/lindbergh-loader/lindbergh-loader/wiki)
2. Join our [Discord community](https://arcade.community)
3. [Open an issue](https://github.com/lindbergh-loader/lindbergh-loader/issues) for bugs

## Acknowledgments

Special thanks to all contributors and the arcade preservation community.
