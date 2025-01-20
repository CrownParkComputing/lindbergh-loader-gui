import 'package:flutter/material.dart';
import 'dart:io';
import '../models/game.dart';

class ConfigEditorDialog extends StatefulWidget {
  final Game game;
  final Function(String)? onSave;

  const ConfigEditorDialog({
    super.key,
    required this.game,
    this.onSave,
  });

  @override
  State<ConfigEditorDialog> createState() => _ConfigEditorDialogState();
}

class _ConfigEditorDialogState extends State<ConfigEditorDialog> {
  late TextEditingController _configController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _configController = TextEditingController();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final configPath = widget.game.configFilePath;
    
    if (configPath.isNotEmpty) {
      final file = File(configPath);
      
      if (await file.exists()) {
        final contents = await file.readAsString();
        _configController.text = contents;
      }
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveConfig() async {
    final configPath = widget.game.configFilePath;
    
    if (configPath.isNotEmpty) {
      final file = File(configPath);
      await file.writeAsString(_configController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Config'),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: TextField(
                controller: _configController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter config file contents...',
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await _saveConfig();
            if (widget.onSave != null) {
              widget.onSave!(_configController.text);
            }
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
