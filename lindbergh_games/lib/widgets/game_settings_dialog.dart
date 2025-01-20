import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.game.name);
    _executablePathController = TextEditingController(
        text: widget.game.executablePath);
    _workingDirectoryController = TextEditingController(
        text: widget.game.workingDirectory);
  }

  Future<void> _selectExecutable() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      dialogTitle: 'Select Game Executable',
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _executablePathController.text = result.files.single.path!;
      });
    }
  }

  Future<void> _selectWorkingDirectory() async {
    final directory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select Working Directory',
    );

    if (directory != null) {
      setState(() {
        _workingDirectoryController.text = directory;
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
              controller: _executablePathController,
              decoration: const InputDecoration(
                labelText: 'Executable Path',
              ),
              readOnly: true,
              onTap: _selectExecutable,
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
            final updatedGame = widget.game.copyWith(
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
