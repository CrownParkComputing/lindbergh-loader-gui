import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/game.dart';

class GameRepository {
  static const String _gamesFileName = 'games.json';
  late final String _gamesFilePath;

  GameRepository() {
    final dataDir = Directory('data');
    if (!dataDir.existsSync()) {
      dataDir.createSync();
    }
    _gamesFilePath = path.join('data', _gamesFileName);
  }

  Future<List<Game>> loadGames() async {
    try {
      final file = File(_gamesFilePath);
      if (!file.existsSync()) {
        return [];
      }

      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      
      return jsonList.map((json) => Game.fromJson(json)).toList();
    } catch (e) {
      print('Error loading games: $e');
      return [];
    }
  }

  Future<void> saveGames(List<Game> games) async {
    try {
      final file = File(_gamesFilePath);
      final jsonList = games.map((game) => game.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving games: $e');
    }
  }
}
