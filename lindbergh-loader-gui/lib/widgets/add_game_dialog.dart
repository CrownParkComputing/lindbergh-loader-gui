import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lindbergh_loader_gui/models/game.dart';
import 'package:lindbergh_loader_gui/data/default_games.dart';
import 'package:process_run/shell.dart';
import 'package:path/path.dart' as path_util;
import 'package:file_picker/file_picker.dart';

class AddGameDialog extends StatefulWidget {
  final List<Game> games;
  
  const AddGameDialog({
    super.key,
    required this.games,
  });

  @override
  State<AddGameDialog> createState() => _AddGameDialogState();
}

class _AddGameDialogState extends State<AddGameDialog> {
  Game? _selectedGame;
  String? _executablePath;
  String? _iconPath;

  Future<void> _pickGameExecutable() async {
    final shell = Shell();
    final results = await shell.run('zenity --file-selection --title="Select Lindbergh Executable" --file-filter="Lindbergh Executable | lindbergh"');
    if (results.isNotEmpty && results.first.exitCode == 0 && results.first.stdout.isNotEmpty) {
      final executablePath = results.first.stdout.trim();
      if (executablePath.endsWith('/lindbergh')) {
        setState(() {
          _executablePath = executablePath;
        });
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Error'),
              content: const Text('Please select a valid lindbergh executable'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
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
          onPressed: () {
            if (_selectedGame != null && _executablePath != null) {
              final game = Game(
                name: _selectedGame!.name,
                executablePath: _executablePath!,
                iconPath: _iconPath,
              );
              Navigator.of(context).pop(game);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
