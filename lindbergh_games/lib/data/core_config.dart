class CoreConfig {
  String? corePath;
  String? installDependenciesPath;

  CoreConfig({
    this.corePath,
    this.installDependenciesPath,
  });

  CoreConfig.fromJson(Map<String, dynamic> json)
      : corePath = json['corePath'],
        installDependenciesPath = json['installDependenciesPath'];

  Map<String, dynamic> toJson() => {
    'corePath': corePath,
    'installDependenciesPath': installDependenciesPath,
  };

  String? get lindberghConfPath {
    if (corePath == null) return null;
    return '$corePath/builds/lindbergh.conf';
  }
}
