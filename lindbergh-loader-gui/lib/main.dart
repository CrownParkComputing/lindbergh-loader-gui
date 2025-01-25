import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:lindbergh_loader_gui/data/game_repository.dart';
import 'package:lindbergh_loader_gui/widgets/about_screen.dart';
import 'package:lindbergh_loader_gui/widgets/setup_screen.dart';
import 'package:lindbergh_loader_gui/models/game.dart';
import 'package:lindbergh_loader_gui/utils/game_launcher.dart';
import 'package:lindbergh_loader_gui/widgets/add_game_dialog.dart';
import 'package:lindbergh_loader_gui/widgets/config_editor_dialog.dart';
import 'package:lindbergh_loader_gui/widgets/game_tile.dart';
import 'package:lindbergh_loader_gui/widgets/icon_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lindbergh_loader_gui/widgets/bin_processor_screen.dart';
import 'package:lindbergh_loader_gui/services/update_service.dart';
import 'package:lindbergh_loader_gui/data/core_config_repository.dart';
import 'package:lindbergh_loader_gui/widgets/update_screen.dart';
import 'package:lindbergh_loader_gui/widgets/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Check for updates on launch
  try {
    final updateInfo = await UpdateService.checkForUpdates();
    final config = await CoreConfigRepository().loadConfig();
    if (config.corePath != null) {
      final hasConfChanges = await UpdateService.isConfFileChanged(
        '${config.corePath}/lindbergh.conf'
      );
      if (hasConfChanges) {
        // Show update notification
      }
    }
  } catch (e) {
    print('Error checking for updates: $e');
  }

  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    minimumSize: Size(400, 300),
    center: true,
    titleBarStyle: TitleBarStyle.hidden,
    title: 'Lindbergh Loader',
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    windowButtonVisibility: false,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  await windowManager.setIcon('assets/images/sega-logo.png');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lindbergh Loader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        cardColor: const Color(0xFF2D2D2D),
        dialogBackgroundColor: const Color(0xFF2D2D2D),
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

enum AppTheme {
  dark(Color(0xFF2C2C2C), Color(0xFF383838), Colors.blue),
  light(Color(0xFFFAFAFA), Color(0xFFF0F0F0), Colors.blue),
  blue(Color(0xFF64B5F6), Color(0xFF90CAF9), Colors.blue),
  red(Color(0xFFEF9A9A), Color(0xFFFFCDD2), Colors.red),
  green(Color(0xFF81C784), Color(0xFFA5D6A7), Colors.green);

  final Color backgroundColor;
  final Color cardColor;
  final MaterialColor primarySwatch;
  const AppTheme(this.backgroundColor, this.cardColor, this.primarySwatch);
}

enum WindowSize {
  small(600, 400, Icons.phone_android),
  medium(800, 600, Icons.tablet_android),
  large(1024, 768, Icons.laptop),
  xl(1280, 960, Icons.tv);

  final double width;
  final double height;
  final IconData icon;
  const WindowSize(this.width, this.height, this.icon);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  late final GameRepository _gameRepository;
  List<Game> games = [];
  bool _isIconView = true;
  AppTheme _currentTheme = AppTheme.dark;
  WindowSize _currentSize = WindowSize.medium;
  late final SharedPreferences _prefs;
  bool _showWelcome = true;

  final Map<AppTheme, ThemeData> themes = {
    AppTheme.dark: ThemeData(
      brightness: Brightness.dark,
      primarySwatch: AppTheme.dark.primarySwatch,
      scaffoldBackgroundColor: AppTheme.dark.backgroundColor,
      cardColor: AppTheme.dark.cardColor,
      dialogBackgroundColor: AppTheme.dark.cardColor,
    ),
    AppTheme.light: ThemeData(
      brightness: Brightness.light,
      primarySwatch: AppTheme.light.primarySwatch,
      scaffoldBackgroundColor: AppTheme.light.backgroundColor,
      cardColor: AppTheme.light.cardColor,
      dialogBackgroundColor: AppTheme.light.cardColor,
    ),
    AppTheme.blue: ThemeData(
      brightness: Brightness.light,
      primarySwatch: AppTheme.blue.primarySwatch,
      scaffoldBackgroundColor: AppTheme.blue.backgroundColor,
      cardColor: AppTheme.blue.cardColor,
      dialogBackgroundColor: AppTheme.blue.cardColor,
      textTheme: Typography.material2021().black,
    ),
    AppTheme.red: ThemeData(
      brightness: Brightness.light,
      primarySwatch: AppTheme.red.primarySwatch,
      scaffoldBackgroundColor: AppTheme.red.backgroundColor,
      cardColor: AppTheme.red.cardColor,
      dialogBackgroundColor: AppTheme.red.cardColor,
      textTheme: Typography.material2021().black,
    ),
    AppTheme.green: ThemeData(
      brightness: Brightness.light,
      primarySwatch: AppTheme.green.primarySwatch,
      scaffoldBackgroundColor: AppTheme.green.backgroundColor,
      cardColor: AppTheme.green.cardColor,
      dialogBackgroundColor: AppTheme.green.cardColor,
      textTheme: Typography.material2021().black,
    ),
  };

  void showUpdateNotification(Map<String, dynamic> updateInfo, bool hasConfChanges) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Updates Available'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New version available: ${updateInfo['version']}'),
            if (hasConfChanges)
              const Text('\nConfiguration updates are also available.'),
            const SizedBox(height: 16),
            Text(updateInfo['body'] ?? 'No release notes available'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdateScreen()),
              );
            },
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initPrefs();
    windowManager.addListener(this);
    _gameRepository = GameRepository();
    _loadGames();
    _applyWindowSize();
    _checkForUpdates();
    _checkWelcomeScreen();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _isIconView = _prefs.getBool('isIconView') ?? true;
      _currentTheme = AppTheme.values[_prefs.getInt('themeIndex') ?? 0];
      _currentSize = WindowSize.values[_prefs.getInt('windowSizeIndex') ?? 1];
    });
  }

  void _saveSettings() {
    _prefs.setBool('isIconView', _isIconView);
    _prefs.setInt('themeIndex', _currentTheme.index);
    _prefs.setInt('windowSizeIndex', _currentSize.index);
  }

  Future<void> _applyWindowSize() async {
    await windowManager.setSize(Size(_currentSize.width, _currentSize.height));
    await windowManager.center();
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

  Future<void> _checkForUpdates() async {
    try {
      final updateInfo = await UpdateService.checkForUpdates();
      final config = await CoreConfigRepository().loadConfig();
      
      if (config.corePath != null) {
        final hasConfChanges = await UpdateService.isConfFileChanged(
          '${config.corePath}/lindbergh.conf'
        );
        
        // Only show notification if there are actual updates or config changes
        if (mounted && (updateInfo['version'] != null || hasConfChanges)) {
          // Don't show update notification if there are no assets to download
          if (!updateInfo['hasAssets'] && !hasConfChanges) {
            print('New version found but no assets available');
            return;
          }
          showUpdateNotification(updateInfo, hasConfChanges);
        }
      }
    } catch (e) {
      print('Error checking for updates: $e');
      // Don't show error to user, just log it
    }
  }

  Future<void> _checkWelcomeScreen() async {
    final hasShownWelcome = _prefs.getBool('hasShownWelcome') ?? false;
    setState(() {
      _showWelcome = !hasShownWelcome;
    });
  }

  void _hideWelcomeScreen() {
    setState(() {
      _showWelcome = false;
    });
    _prefs.setBool('hasShownWelcome', true);
  }

  @override
  Widget build(BuildContext context) {
    if (_showWelcome) {
      return WelcomeScreen(
        onContinue: _hideWelcomeScreen,
      );
    }

    return Theme(
      data: themes[_currentTheme]!,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: GestureDetector(
            onPanStart: (details) => windowManager.startDragging(),
            child: AppBar(
              title: Image.asset(
                'assets/images/sega-logo.png',
                height: 20,
                fit: BoxFit.contain,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => windowManager.close(),
                  tooltip: 'Exit',
                ),
              ],
            ),
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: (details) {
            windowManager.startDragging();
          },
          child: Column(
            children: [
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
                            onEdit: () async {
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
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Tooltip(
                  message: 'Add New Game',
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AddGameDialog(
                          games: games,
                          onAdd: (game) async {
                            await _addGame(game);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Tooltip(
                  message: _isIconView ? 'Switch to List View' : 'Switch to Grid View',
                  child: IconButton(
                    icon: Icon(_isIconView ? Icons.list : Icons.grid_view),
                    onPressed: () => _toggleView(),
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<AppTheme>(
                    value: _currentTheme,
                    icon: const Icon(Icons.palette),
                    dropdownColor: Theme.of(context).cardColor,
                    items: AppTheme.values.map((theme) {
                      return DropdownMenuItem<AppTheme>(
                        value: theme,
                        child: Container(
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [theme.backgroundColor, theme.cardColor],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              theme.name.toUpperCase(),
                              style: TextStyle(
                                color: theme == AppTheme.light ? Colors.black : Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: _changeTheme,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<WindowSize>(
                    value: _currentSize,
                    icon: const Icon(Icons.aspect_ratio),
                    dropdownColor: Theme.of(context).cardColor,
                    items: WindowSize.values.map((size) {
                      return DropdownMenuItem<WindowSize>(
                        value: size,
                        child: Tooltip(
                          message: '${size.name.toUpperCase()} (${size.width.toInt()}x${size.height.toInt()})',
                          child: Icon(size.icon),
                        ),
                      );
                    }).toList(),
                    onChanged: _changeWindowSize,
                  ),
                ),
                Tooltip(
                  message: 'About',
                  child: IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutScreen()),
                      );
                    },
                  ),
                ),
                Tooltip(
                  message: 'Check for Updates',
                  child: IconButton(
                    icon: const Icon(Icons.system_update),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UpdateScreen()),
                      );
                    },
                  ),
                ),
                Tooltip(
                  message: 'Process Bin File',
                  child: IconButton(
                    icon: const Icon(Icons.file_present),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BinProcessorScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleView() {
    setState(() {
      _isIconView = !_isIconView;
      _saveSettings();
    });
  }

  void _changeTheme(AppTheme? value) {
    if (value != null) {
      setState(() {
        _currentTheme = value;
        _saveSettings();
      });
    }
  }

  void _changeWindowSize(WindowSize? value) async {
    if (value != null) {
      setState(() {
        _currentSize = value;
        _saveSettings();
      });
      await _applyWindowSize();
    }
  }

  @override
  void dispose() {
    _saveSettings();
    windowManager.removeListener(this);
    super.dispose();
  }
}
