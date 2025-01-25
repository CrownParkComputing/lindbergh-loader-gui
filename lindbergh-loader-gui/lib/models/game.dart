class Game {
  final String name;
  final String path;
  final String? configPath;
  final String? iconPath;
  final String? testMenuPath;

  Game({
    required this.name,
    required this.path,
    this.configPath,
    this.iconPath,
    this.testMenuPath,
  });

  String get workingDirectory {
    if (path.isEmpty) return '';
    // Go up TWO levels - one from 'lindbergh' and one from 'lindbergh/' or 'elf/'
    return path.substring(0, path.lastIndexOf('/')).substring(0, path.substring(0, path.lastIndexOf('/')).lastIndexOf('/'));
  }

  String get effectiveConfigPath {
    if (configPath != null && configPath!.isNotEmpty) {
      return configPath!;
    }
    // Put lindbergh.conf in disk0/ directory
    return path.isEmpty ? '' : '${workingDirectory}/lindbergh.conf';
  }

  Game copyWith({
    String? name,
    String? path,
    String? configPath,
    String? iconPath,
    String? testMenuPath,
  }) {
    return Game(
      name: name ?? this.name,
      path: path ?? this.path,
      configPath: configPath ?? this.configPath,
      iconPath: iconPath ?? this.iconPath,
      testMenuPath: testMenuPath ?? this.testMenuPath,
    );
  }

  // Create a Game from JSON
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      name: json['name'] as String,
      path: json['path'] as String,
      configPath: json['configPath'] as String?,
      iconPath: json['iconPath'] as String?,
      testMenuPath: json['testMenuPath'] as String?,
    );
  }

  // Convert Game to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'configPath': configPath,
      'iconPath': iconPath,
      'testMenuPath': testMenuPath,
    };
  }
}
