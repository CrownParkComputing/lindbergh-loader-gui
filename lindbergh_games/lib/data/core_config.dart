class CoreConfig {
  final String? corePath;

  CoreConfig({this.corePath});

  CoreConfig.fromJson(Map<String, dynamic> json)
      : corePath = json['corePath'];

  Map<String, dynamic> toJson() => {
    'corePath': corePath,
  };
}
