import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'core_config.dart';

class CoreConfigRepository {
  static const _configKey = 'core_config';

  Future<void> saveConfig(CoreConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = jsonEncode(config.toJson());
      final saved = await prefs.setString(_configKey, configJson);
      
      if (!saved) {
        throw Exception('Failed to save config to SharedPreferences');
      }
      
      // Verify the config was saved by reading it back
      final savedConfig = await loadConfig();
      if (savedConfig.corePath != config.corePath) {
        throw Exception('Config verification failed - saved value does not match. Expected: ${config.corePath}, Got: ${savedConfig.corePath}');
      }
    } catch (e) {
      throw Exception('Failed to save config: ${e.toString()}');
    }
  }

  Future<CoreConfig> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final configString = prefs.getString(_configKey);
    if (configString != null) {
      try {
        final jsonMap = jsonDecode(configString) as Map<String, dynamic>;
        return CoreConfig.fromJson(jsonMap);
      } catch (e) {
        return CoreConfig();
      }
    }
    return CoreConfig();
  }
}
