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
    return jsonList.map((json) => Game.fromJson(json)).toList();
  }

  Future<void> saveGames(List<Game> games) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = games.map((game) => game.toJson()).toList();
    await prefs.setString(_gamesKey, json.encode(jsonList));
  }
}
