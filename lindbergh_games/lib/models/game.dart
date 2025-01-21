class Game {
  final String name;
  final String executablePath;
  final String? iconPath;
  final String? workingDirectory;

  Game({
    required this.name,
    required this.executablePath,
    this.iconPath,
    this.workingDirectory,
  });

  String get configFilePath {
    if (workingDirectory == null || workingDirectory!.isEmpty) {
      return '';
    }
    return '$workingDirectory/lindbergh.conf';
  }

  Game copyWith({
    String? name,
    String? executablePath,
    String? iconPath,
    String? workingDirectory,
  }) {
    return Game(
      name: name ?? this.name,
      executablePath: executablePath ?? this.executablePath,
      iconPath: iconPath ?? this.iconPath,
      workingDirectory: workingDirectory ?? this.workingDirectory,
    );
  }
}
