import 'dart:io';

class Game {
  final String name;
  final String id;
  final String dvp;
  String? executablePath;
  String? workingDirectory;
  String? iconPath;
  String? configPath;

  Game({
    required this.name,
    required this.id,
    required this.dvp,
    this.executablePath,
    this.workingDirectory,
    this.iconPath,
    this.configPath,
  });

  String get configFilePath {
    if (workingDirectory != null) {
      return '${workingDirectory!}/lindbergh.conf';
    }
    return configPath ?? '';
  }

  bool get isConfigured => executablePath != null && executablePath!.isNotEmpty;

  Game copyWith({
    String? name,
    String? id,
    String? dvp,
    String? executablePath,
    String? workingDirectory,
    String? iconPath,
    String? configPath,
  }) {
    return Game(
      name: name ?? this.name,
      id: id ?? this.id,
      dvp: dvp ?? this.dvp,
      executablePath: executablePath ?? this.executablePath,
      workingDirectory: workingDirectory ?? this.workingDirectory,
      iconPath: iconPath ?? this.iconPath,
      configPath: configPath ?? this.configPath,
    );
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      name: json['name'],
      id: json['id'],
      dvp: json['dvp'],
      executablePath: json['executablePath'],
      workingDirectory: json['workingDirectory'],
      iconPath: json['iconPath'],
      configPath: json['configPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'dvp': dvp,
      'executablePath': executablePath,
      'workingDirectory': workingDirectory,
      'iconPath': iconPath,
      'configPath': configPath,
    };
  }
}
