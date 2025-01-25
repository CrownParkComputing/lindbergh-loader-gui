import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lindbergh_loader_gui/models/game.dart';
import 'package:lindbergh_loader_gui/data/default_games.dart';
import 'package:process_run/shell.dart';
import 'package:path/path.dart' as path_util;
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class AddGameDialog extends StatefulWidget {
  final List<Game> games;
  final Function(Game) onAdd;
  
  const AddGameDialog({
    super.key,
    required this.games,
    required this.onAdd,
  });

  @override
  State<AddGameDialog> createState() => _AddGameDialogState();
}

class _AddGameDialogState extends State<AddGameDialog> {
  Game? _selectedGame;
  String? _executablePath;
  String? _iconPath;
  String? _testMenuPath;
  String? _configPath;

  Future<void> _pickGameExecutable() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        final file = File(result.files.single.path!);
        _executablePath = file.path;
        _configPath = path.join(path.dirname(_executablePath!), 'lindbergh.conf');
      });
    }
  }

  Future<void> _pickIcon() async {
    final executableDir = Directory.current.absolute.path;
    
    String iconsPath = path_util.join(executableDir, 'assets', 'icons');
    
    if (_executablePath != null) {
      final execDir = path_util.dirname(_executablePath!);
      final execIconsPath = path_util.join(execDir, 'icons');
      if (Directory(execIconsPath).existsSync()) {
        iconsPath = execIconsPath;
      }
    }

    if (!Directory(iconsPath).existsSync()) {
      Directory(iconsPath).createSync(recursive: true);
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'gif'],
      dialogTitle: 'Select Game Icon',
      initialDirectory: iconsPath,
      lockParentWindow: true,
    );

    if (result != null) {
      setState(() {
        _iconPath = result.files.single.path;
      });
    }
  }

  void _onSave() {
    if (_selectedGame == null || _executablePath == null) return;

    final game = Game(
      name: _selectedGame!.name,
      path: _executablePath!,
      configPath: _configPath,
      iconPath: _iconPath,
      testMenuPath: _testMenuPath,
    );

    widget.onAdd(game);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Image.asset(
            'assets/images/sega-logo.png',
            height: 30,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          const Text('Add Game'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<Game>(
              value: _selectedGame,
              decoration: const InputDecoration(
                labelText: 'Select Game',
              ),
              items: defaultGames.where((game) => 
                !widget.games.any((g) => g.name == game.name)
              ).map((game) {
                return DropdownMenuItem<Game>(
                  value: game,
                  child: Text(game.name),
                );
              }).toList(),
              onChanged: (game) {
                setState(() {
                  _selectedGame = game;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a game';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickGameExecutable,
              child: const Text('Select Lindbergh Executable'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickIcon,
              child: const Text('Select Game Icon'),
            ),
            const SizedBox(height: 16),
            if (_executablePath != null) ...[
              Text('Executable: $_executablePath'),
            ],
            if (_iconPath != null) ...[
              const SizedBox(height: 16),
              Text('Icon: $_iconPath'),
              const SizedBox(height: 8),
              Image.file(
                File(_iconPath!),
                height: 64,
                width: 64,
                fit: BoxFit.cover,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _onSave,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
