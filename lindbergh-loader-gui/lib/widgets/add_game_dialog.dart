import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lindbergh_games/models/game.dart';
import 'package:lindbergh_games/data/default_games.dart';
import 'package:process_run/shell.dart';

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
  String? _workingDirectory;

  Future<void> _pickGameExecutable() async {
    final shell = Shell();
    final results = await shell.run('zenity --file-selection --title="Select Game Executable"');
    if (results.isNotEmpty && results.first.exitCode == 0 && results.first.stdout.isNotEmpty) {
      setState(() {
        _executablePath = results.first.stdout.trim();
      });
    }
  }

  Future<void> _pickWorkingDirectory() async {
    final shell = Shell();
    final results = await shell.run('zenity --file-selection --directory --title="Select Working Directory"');
    if (results.isNotEmpty && results.first.exitCode == 0 && results.first.stdout.isNotEmpty) {
      setState(() {
        _workingDirectory = results.first.stdout.trim();
      });
    }
  }

  Future<void> _pickIcon() async {
    final shell = Shell();
    final results = await shell.run('zenity --file-selection --title="Select Game Icon" --file-filter="Images | *.png *.jpg *.jpeg"');
    if (results.isNotEmpty && results.first.exitCode == 0 && results.first.stdout.isNotEmpty) {
      setState(() {
        _iconPath = results.first.stdout.trim();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Game'),
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
              child: const Text('Select Game Executable'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickWorkingDirectory,
              child: const Text('Select Working Directory'),
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
            if (_workingDirectory != null) ...[
              const SizedBox(height: 16),
              Text('Working Directory: $_workingDirectory'),
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
              final game = _selectedGame!.copyWith(
                executablePath: _executablePath!,
                iconPath: _iconPath,
                workingDirectory: _workingDirectory,
              );
              Navigator.pop(context, game);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
