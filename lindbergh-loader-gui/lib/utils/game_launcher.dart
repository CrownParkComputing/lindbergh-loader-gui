import 'dart:io';
import 'dart:async' show unawaited;
import 'package:path/path.dart' as path;
import '../models/game.dart';

class GameLauncher {
  static Future<void> launchGame(Game game) async {
    if (game.path.isEmpty) {
      throw Exception('No executable path specified');
    }

    try {
      final process = await Process.start(
        game.path,
        [],
        workingDirectory: game.workingDirectory,
        mode: ProcessStartMode.detached,
      );
      
      // Don't wait for the process to complete
      unawaited(process.exitCode);
      
      // Give the process a moment to start
      await Future.delayed(const Duration(milliseconds: 500));
      
    } catch (e) {
      throw Exception('Failed to launch game: $e');
    }
  }

  static Future<void> launchTestMenu(Game game) async {
    if (game.path.isEmpty) {
      throw Exception('No executable path specified');
    }

    try {
      final process = await Process.start(
        game.path,
        ['--test-menu'],
        workingDirectory: game.workingDirectory,
        mode: ProcessStartMode.detached,
      );
      
      // Don't wait for the process to complete
      unawaited(process.exitCode);
      
      // Give the process a moment to start
      await Future.delayed(const Duration(milliseconds: 500));
      
    } catch (e) {
      throw Exception('Failed to launch test menu: $e');
    }
  }
}
