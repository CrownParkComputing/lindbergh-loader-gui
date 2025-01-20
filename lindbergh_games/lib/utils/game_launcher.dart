import 'dart:io';
import 'dart:convert';
import 'package:lindbergh_games/models/game.dart';

class GameLauncher {
  static Future<void> _launchProcess(Game game, List<String> arguments) async {
    if (game.executablePath == null || game.executablePath!.isEmpty) {
      throw Exception('Executable path not configured');
    }

    final executable = File(game.executablePath!);
    if (!executable.existsSync()) {
      throw Exception('Executable file does not exist');
    }

    final process = await Process.start(
      executable.path,
      arguments,
      workingDirectory: game.workingDirectory,
    );

    process.stderr.transform(utf8.decoder).listen((data) {
      print('Game Error: $data');
    });

    process.stdout.transform(utf8.decoder).listen((data) {
      print('Game Output: $data');
    });

    await process.exitCode;
  }

  static Future<void> launchGame(Game game) async {
    await _launchProcess(game, []);
  }

  static Future<void> launchTestMenu(Game game) async {
    await _launchProcess(game, ['-t']);
  }
}
