class Game {
  final String name;
  final String executablePath;
  final String? iconPath;

  Game({
    required this.name,
    required this.executablePath,
    this.iconPath,
  });

  String get workingDirectory => executablePath.substring(0, executablePath.lastIndexOf('/'));

  String get configFilePath => '$workingDirectory/lindbergh.conf';

  Game copyWith({
    String? name,
    String? executablePath,
    String? iconPath,
  }) {
    return Game(
      name: name ?? this.name,
      executablePath: executablePath ?? this.executablePath,
      iconPath: iconPath ?? this.iconPath,
    );
  }

  // Create a Game from JSON
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      name: json['name'] as String,
      executablePath: json['executablePath'] as String,
      iconPath: json['iconPath'] as String?,
    );
  }

  // Convert Game to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'executablePath': executablePath,
      'iconPath': iconPath,
    };
  }
}
