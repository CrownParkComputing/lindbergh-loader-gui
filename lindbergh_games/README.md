# Lindbergh Games Launcher

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/yourusername/lindbergh-games/build.yml)
![GitHub](https://img.shields.io/github/license/yourusername/lindbergh-games)

A Linux desktop application for managing and launching Lindbergh arcade games.

## About

This project is a fork of the original [Lindbergh Loader](https://github.com/yourusername/lindbergh-loader) repository. All credit for the core functionality goes to the original authors.

## Features

- Game library management
- Launch games with custom executable paths
- Access test menus with -t flag
- Game compatibility information
- Intuitive UI with game icons
- About screen with project information

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/lindbergh-games.git
cd lindbergh-games
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run -d linux
```

## Building

To build a release version:
```bash
flutter build linux
```

The built application will be in `build/linux/x64/release/bundle`

## Supported Distributions

- Arch Linux
- Ubuntu (20.04+)
- Fedora (34+)

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please maintain compatibility with the original Lindbergh Loader project and follow the existing code style.

## License

[MIT](https://choosealicense.com/licenses/mit/)

## Credits

- Original Lindbergh Loader project: [lindbergh-loader](https://github.com/yourusername/lindbergh-loader)
- Flutter Desktop Embedding team
- Linux community for testing and feedback
