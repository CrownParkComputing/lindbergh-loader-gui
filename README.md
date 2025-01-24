# Lindbergh GUI

A modern GUI application for managing and running SEGA Lindbergh arcade games on Linux.

## Acknowledgments

This project is based on the [Lindbergh Loader](https://github.com/lindbergh-loader/lindbergh-loader) project. All core emulation functionality and the foundation of this work comes from the original Lindbergh Loader Development Team. We extend our deepest gratitude to:

- The Lindbergh Loader Development Team for creating and maintaining the original emulator
- All contributors to the original project
- The SEGA community for their continued support and testing

This GUI is built on top of their excellent work and aims to provide a more user-friendly interface while maintaining compatibility with their core emulator. For the latest updates and information about the core emulator, please visit the [original project repository](https://github.com/lindbergh-loader/lindbergh-loader).

## Project Structure

```
lindbergh-gui/
├── lindbergh-loader/     # Core emulator functionality
└── lindbergh-loader-gui/ # Flutter-based GUI application
```

## Installation

For detailed installation instructions for your specific Linux distribution, please see [INSTALL.md](INSTALL.md).

## Building the GUI

```bash
cd lindbergh-loader-gui
flutter pub get
flutter build linux
```

The built application will be in `lindbergh-loader-gui/build/linux/x64/release/bundle/`

## Default Controls

- Test: T key
- Player 1 Start: 1 key
- Player 1 Service: S key
- Player 1 Coin: 5 key
- Player 1 Movement: Arrow keys
- Player 1 Buttons: Q, W, E, R keys

These can be customized in the lindbergh.conf file.

## License

This project consists of two parts with their respective licenses:

1. **Core Emulator (lindbergh-loader)**:
   The core emulator functionality is from the [Lindbergh Loader](https://github.com/lindbergh-loader/lindbergh-loader) project and is licensed under [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-nc-sa/4.0/).

2. **GUI Application (lindbergh-loader-gui)**:
   The GUI portion of this project is also licensed under [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-nc-sa/4.0/) to maintain compatibility with the original project.

This project is not affiliated with or endorsed by SEGA. All trademarks are property of their respective owners.
