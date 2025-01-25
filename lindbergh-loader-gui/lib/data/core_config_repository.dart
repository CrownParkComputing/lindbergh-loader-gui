import 'dart:convert';
import 'dart:io';
import 'core_config.dart';

class CoreConfigRepository {
  static const String configFile = 'lindbergh-loader.json';

  Future<CoreConfig> loadConfig() async {
    try {
      final file = File(configFile);
      if (await file.exists()) {
        final contents = await file.readAsString();
        final json = jsonDecode(contents) as Map<String, dynamic>;
        return CoreConfig.fromJson(json);
      }
    } catch (e) {
      print('Error loading config: $e');
    }
    return CoreConfig();
  }

  Future<void> saveConfig(CoreConfig config) async {
    try {
      final file = File(configFile);
      await file.writeAsString(jsonEncode(config.toJson()));
    } catch (e) {
      print('Error saving config: $e');
    }
  }
}
