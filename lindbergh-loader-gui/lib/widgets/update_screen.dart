import 'package:flutter/material.dart';
import 'package:lindbergh_loader_gui/services/update_service.dart';
import 'package:lindbergh_loader_gui/data/core_config.dart';
import 'package:lindbergh_loader_gui/data/core_config_repository.dart';
import 'package:lindbergh_loader_gui/data/game_repository.dart';
import 'package:lindbergh_loader_gui/models/game.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> with SingleTickerProviderStateMixin {
  bool _isChecking = false;
  bool _isUpdating = false;
  String _status = '';
  double _progress = 0;
  Map<String, dynamic>? _updateInfo;
  final _configRepository = CoreConfigRepository();
  final _gameRepository = GameRepository();
  late CoreConfig _config;
  List<Game> _games = [];
  late TabController _tabController;
  String? _latestConfContent;
  bool _isLoadingConf = false;
  List<Game> _selectedGames = [];
  List<String> _extractedFiles = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadConfigAndCheck();
    _loadGames();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadGames() async {
    final games = await _gameRepository.loadGames();
    setState(() {
      _games = games;
    });
  }

  Future<void> _loadLatestConf() async {
    setState(() {
      _isLoadingConf = true;
      _status = 'Loading latest configuration...';
    });

    try {
      final response = await http.get(Uri.parse(UpdateService.confUrl));
      if (response.statusCode == 200) {
        setState(() {
          _latestConfContent = response.body;
          _status = 'Latest configuration loaded';
        });
      } else {
        setState(() {
          _status = 'Failed to load configuration: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error loading configuration: $e';
      });
    } finally {
      setState(() {
        _isLoadingConf = false;
      });
    }
  }

  Future<void> _updateSelectedGamesConfig() async {
    try {
      setState(() {
        _isUpdating = true;
        _status = 'Updating game configurations...';
      });

      for (final game in _selectedGames) {
        final configPath = game.effectiveConfigPath;
        if (configPath.isEmpty) continue;
        
        setState(() {
          _status = 'Updating ${game.name} configuration...';
        });

        try {
          final configFile = File(configPath);
          
          // Only backup if the file exists
          if (await configFile.exists()) {
            final backupPath = '$configPath.backup';
            print('Creating backup at: $backupPath');
            await configFile.copy(backupPath);
          }

          // Write new config
          print('Writing new config to: $configPath');
          await configFile.writeAsString(_latestConfContent!);
          
          setState(() {
            _extractedFiles.add('Updated: ${game.name}');
          });
        } catch (e) {
          print('Error updating ${game.name} config: $e');
          setState(() {
            _extractedFiles.add('Error updating ${game.name}: $e');
          });
        }
      }

      setState(() {
        _status = 'Configuration update complete';
        _isUpdating = false;
      });
    } catch (e) {
      print('Error in _updateSelectedGamesConfig: $e');
      setState(() {
        _status = 'Error updating configurations: $e';
        _isUpdating = false;
      });
    }
  }

  Future<void> _loadConfigAndCheck() async {
    _config = await _configRepository.loadConfig();
    if (_config.corePath != null) {  // Only check for updates if corePath is set
      _checkForUpdates();
    } else {
      setState(() {
        _status = 'Please configure core path in settings first';
      });
    }
  }

  Future<void> _checkForUpdates() async {
    setState(() {
      _isChecking = true;
      _status = 'Checking for updates...';
    });

    try {
      final updateInfo = await UpdateService.checkForUpdates();
      
      // Check conf file using first game's path
      bool hasConfChanges = false;
      if (_games.isNotEmpty) {
        final game = _games.first;
        if (game.path.isNotEmpty) {
          final disk0Path = path.dirname(path.dirname(game.path));
          final confPath = path.join(disk0Path, 'lindbergh.conf');
          hasConfChanges = await UpdateService.isConfFileChanged(confPath);
        }
      }

      setState(() {
        _updateInfo = updateInfo;
        _status = hasConfChanges 
          ? 'Updates available with configuration changes'
          : 'Updates available';
      });

    } catch (e) {
      setState(() {
        _status = 'Error checking for updates: $e';
      });
    } finally {
      setState(() {
        _isChecking = false;
      });
    }
  }

  Future<void> _installUpdate() async {
    if (_updateInfo == null || _updateInfo!['downloadUrl'] == null) {
      setState(() {
        _status = 'No valid update available';
      });
      return;
    }

    if (_games.isEmpty) {
      setState(() {
        _status = 'No games configured. Please add games first.';
      });
      return;
    }

    setState(() {
      _isUpdating = true;
      _progress = 0;
      _status = 'Downloading update...';
    });

    try {
      final downloadUrl = _updateInfo!['downloadUrl'] as String;
      
      // For each game, update its core files
      for (final game in _games) {
        if (game.path.isEmpty) continue;

        // Get the directory where the executable is
        final executableDir = path.dirname(game.path);
        
        setState(() {
          _status = 'Updating core for ${game.name}...';
        });

        await UpdateService.downloadAndInstall(
          downloadUrl,
          executableDir,  // Install to the same directory as the executable
          (progress, status) {
            setState(() {
              _progress = progress;
              _status = '$status (${game.name})';
            });
          },
        );

        // Update config if needed
        final confPath = path.join(executableDir, 'lindbergh.conf');
        if (await UpdateService.isConfFileChanged(confPath)) {
          setState(() {
            _status = 'Updating configuration for ${game.name}...';
          });
          await UpdateService.updateConfFile(confPath);
        }

        setState(() {
          _extractedFiles.add('Updated: ${game.name}');
        });
      }

      setState(() {
        _status = 'Update complete!';
        _progress = 1.0;
      });

    } catch (e) {
      setState(() {
        _status = 'Error installing update: $e';
      });
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lindbergh Loader Updates'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Core Update'),
            Tab(text: 'Configuration Update'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCoreUpdateTab(),
          _buildConfigUpdateTab(),
        ],
      ),
    );
  }

  Widget _buildCoreUpdateTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_updateInfo != null) ...[
            Text(
              'Latest version: ${_updateInfo!['version']}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _updateInfo!['body'] ?? 'No release notes available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 16),
          if (_status.isNotEmpty) ...[
            Text(_status),
            const SizedBox(height: 8),
            if (_isUpdating)
              LinearProgressIndicator(value: _progress),
          ],
          const SizedBox(height: 16),
          Center(
            child: _isChecking
              ? const CircularProgressIndicator()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isUpdating ? null : _checkForUpdates,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Check for Updates'),
                    ),
                    if (_updateInfo != null) ...[
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _isUpdating ? null : _installUpdate,
                        icon: const Icon(Icons.download),
                        label: const Text('Install Update'),
                      ),
                    ],
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigUpdateTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _isLoadingConf ? null : _loadLatestConf,
                icon: const Icon(Icons.refresh),
                label: const Text('Load Latest Config'),
              ),
              if (_latestConfContent != null) ...[
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _selectedGames.isEmpty || _isUpdating 
                    ? null 
                    : _updateSelectedGamesConfig,
                  icon: const Icon(Icons.system_update),
                  label: Text('Update Selected (${_selectedGames.length})'),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          if (_status.isNotEmpty) ...[
            Text(_status),
            if (_isUpdating)
              LinearProgressIndicator(value: _progress),
            const SizedBox(height: 16),
          ],
          if (_latestConfContent != null)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select games to update configuration:'),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _games.length,
                      itemBuilder: (context, index) {
                        final game = _games[index];
                        final isSelected = _selectedGames.contains(game);
                        return CheckboxListTile(
                          title: Text(game.name),
                          subtitle: Text(game.effectiveConfigPath),
                          value: isSelected,
                          enabled: game.configPath != null && !_isUpdating,
                          onChanged: game.configPath == null || _isUpdating 
                            ? null
                            : (checked) {
                                setState(() {
                                  if (checked!) {
                                    _selectedGames.add(game);
                                  } else {
                                    _selectedGames.remove(game);
                                  }
                                });
                              },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
} 