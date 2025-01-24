import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:lindbergh_games/models/game.dart';

class GameSettingsDialog extends StatefulWidget {
  final Game game;
  final Function(Game) onSave;

  const GameSettingsDialog({
    super.key,
    required this.game,
    required this.onSave,
  });

  @override
  State<GameSettingsDialog> createState() => _GameSettingsDialogState();
}

class _GameSettingsDialogState extends State<GameSettingsDialog> {
  late TextEditingController _nameController;
  late TextEditingController _executablePathController;
  late TextEditingController _workingDirectoryController;
  final Shell _shell = Shell();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.game.name);
    _executablePathController = TextEditingController(
        text: widget.game.executablePath);
    _workingDirectoryController = TextEditingController(
        text: widget.game.workingDirectory);
  }

  Future<void> _selectWorkingDirectory() async {
    final result = await _shell.run('zenity --file-selection --directory --title="Select Working Directory"');
    if (result.isNotEmpty && result.first.exitCode == 0 && result.first.stdout.isNotEmpty) {
      setState(() {
        _workingDirectoryController.text = result.first.stdout.trim();
      });
    }
  }

  Future<void> _selectExecutable() async {
    final result = await _shell.run('zenity --file-selection --title="Select Game Executable"');
    if (result.isNotEmpty && result.first.exitCode == 0 && result.first.stdout.isNotEmpty) {
      final executablePath = result.first.stdout.trim();
      setState(() {
        _executablePathController.text = executablePath;
        // Set working directory to executable's parent directory
        _workingDirectoryController.text = 
            executablePath.substring(0, executablePath.lastIndexOf('/'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Game Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Game Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _workingDirectoryController,
              decoration: const InputDecoration(
                labelText: 'Working Directory',
              ),
              readOnly: true,
              onTap: _selectWorkingDirectory,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _executablePathController,
              decoration: const InputDecoration(
                labelText: 'Executable Path',
              ),
              readOnly: true,
              onTap: _selectExecutable,
            ),
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
              final updatedGame = Game(
                name: _nameController.text,
                executablePath: _executablePathController.text,
                workingDirectory: _workingDirectoryController.text,
              );
            widget.onSave(updatedGame);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _executablePathController.dispose();
    _workingDirectoryController.dispose();
    super.dispose();
  }
}
