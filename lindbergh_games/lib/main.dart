import 'package:flutter/material.dart';
import 'package:lindbergh_games/data/game_repository.dart';
import 'package:lindbergh_games/widgets/about_screen.dart';
import 'package:lindbergh_games/models/game.dart';
import 'package:lindbergh_games/utils/game_launcher.dart';
import 'package:lindbergh_games/widgets/add_game_dialog.dart';
import 'package:lindbergh_games/widgets/config_editor_dialog.dart';
import 'package:lindbergh_games/widgets/game_tile.dart';
import 'package:lindbergh_games/widgets/icon_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lindbergh Games',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[800],
        dialogBackgroundColor: Colors.grey[850],
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final GameRepository _gameRepository;
  List<Game> games = [];
  bool _isIconView = true;

  @override
  void initState() {
    super.initState();
    _gameRepository = GameRepository();
    _loadGames();
  }

  Future<void> _loadGames() async {
    final loadedGames = await _gameRepository.loadGames();
    setState(() {
      games = loadedGames;
    });
  }

  Future<void> _addGame(Game game) async {
    setState(() {
      games.add(game);
    });
    await _gameRepository.saveGames(games);
  }

  Future<void> _deleteGame(int index) async {
    setState(() {
      games.removeAt(index);
    });
    await _gameRepository.saveGames(games);
  }

  Future<void> _launchGame(Game game) async {
    try {
      await GameLauncher.launchGame(game);
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _launchTestMenu(Game game) async {
    try {
      await GameLauncher.launchTestMenu(game);
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lindbergh Games'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final game = await showDialog<Game>(
                context: context,
                builder: (context) => AddGameDialog(
                  games: games,
                ),
              );
              if (game != null) {
                _addGame(game);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.view_list),
                  onPressed: () => setState(() => _isIconView = false),
                  color: _isIconView ? Colors.grey : Theme.of(context).primaryColor,
                ),
                IconButton(
                  icon: const Icon(Icons.grid_view),
                  onPressed: () => setState(() => _isIconView = true),
                  color: _isIconView ? Theme.of(context).primaryColor : Colors.grey,
                ),
              ],
            ),
          ),
          Expanded(
            child: _isIconView
                ? IconView(
                    games: games,
                    onPlay: _launchGame,
                  )
                : ListView.builder(
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      final game = games[index];
                      return GameTile(
                        game: game,
                        onLaunch: () => _launchGame(game),
                        onTest: () => _launchTestMenu(game),
                        onEditConfig: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => ConfigEditorDialog(
                              game: game,
                              onSave: (newConfig) {
                                setState(() {
                                  // Config changes are automatically handled by the game model
                                });
                              },
                            ),
                          );
                        },
                        onDelete: () => _deleteGame(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
