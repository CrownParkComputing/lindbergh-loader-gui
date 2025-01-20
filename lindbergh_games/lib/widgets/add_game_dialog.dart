import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lindbergh_games/models/game.dart';
import 'package:lindbergh_games/data/default_games.dart';
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
  String? _workingDirectory;
  String? _iconPath;

  Future<void> _pickGameExecutable() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        _executablePath = result.files.single.path;
        _workingDirectory = File(_executablePath!).parent.path;
      });
    }
  }

  Future<void> _pickIcon() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
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
                !widget.games.any((g) => g.id == game.id)
              ).map((game) {
                return DropdownMenuItem<Game>(
                  value: game,
                  child: Text('${game.name} (${game.id})'),
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
              onPressed: _pickIcon,
              child: const Text('Select Game Icon'),
            ),
            const SizedBox(height: 16),
            if (_executablePath != null) ...[
              Text('Executable: $_executablePath'),
              const SizedBox(height: 8),
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
                executablePath: _executablePath,
                workingDirectory: _workingDirectory,
                iconPath: _iconPath,
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
