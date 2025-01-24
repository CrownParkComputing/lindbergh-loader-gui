import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/game.dart';

class GameLauncher {
  static Future<void> launchGame(Game game) async {
    if (game.executablePath.isEmpty) {
      throw Exception('Executable path not set for ${game.name}');
    }

    final process = await Process.start(
      './lindbergh',
      [],
      workingDirectory: game.workingDirectory,
      runInShell: true,
    );

    process.stdout.listen((data) => print(String.fromCharCodes(data)));
    process.stderr.listen((data) => print(String.fromCharCodes(data)));
  }

  static Future<void> launchTestMenu(Game game) async {
    if (game.executablePath.isEmpty) {
      throw Exception('Executable path not set for ${game.name}');
    }

    final process = await Process.start(
      './lindbergh',
      ['--test'],
      workingDirectory: game.workingDirectory,
      runInShell: true,
    );

    process.stdout.listen((data) => print(String.fromCharCodes(data)));
    process.stderr.listen((data) => print(String.fromCharCodes(data)));
  }
}
