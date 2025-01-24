import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game.dart';

class GameRepository {
  static const _gamesKey = 'games';

  Future<List<Game>> loadGames() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_gamesKey);
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = json.decode(jsonString);
    final games = jsonList.map((json) => Game(
      name: json['name'],
      executablePath: json['executablePath'],
      iconPath: json['iconPath'],
      workingDirectory: json['workingDirectory'],
    )).toList();

    // Migrate existing games if needed
    final migratedGames = await _migrateGames(games);
    if (migratedGames != games) {
      await saveGames(migratedGames);
    }

    return migratedGames;
  }

  Future<void> saveGames(List<Game> games) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = games.map((game) => {
      'name': game.name,
      'executablePath': game.executablePath,
      'iconPath': game.iconPath,
      'workingDirectory': game.workingDirectory,
    }).toList();
    await prefs.setString(_gamesKey, json.encode(jsonList));
  }

  Future<List<Game>> _migrateGames(List<Game> games) async {
    return games.map((game) {
      // If working directory isn't set, set it to executable's parent directory
      if (game.workingDirectory == null || game.workingDirectory!.isEmpty) {
        final lastSlash = game.executablePath.lastIndexOf('/');
        if (lastSlash > 0) {
          return game.copyWith(
            workingDirectory: game.executablePath.substring(0, lastSlash)
          );
        }
      }
      return game;
    }).toList();
  }
}
