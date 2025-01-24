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
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _configController = TextEditingController();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final workingDir = widget.game.workingDirectory;
      if (workingDir == null || workingDir.isEmpty) {
        throw Exception('No working directory set');
      }

      final configFile = File('$workingDir/lindbergh.conf');
      if (await configFile.exists()) {
        final contents = await configFile.readAsString();
        _configController.text = contents;
      } else {
        _configController.text = '# Lindbergh Configuration File\n';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveConfig() async {
    try {
      final workingDir = widget.game.workingDirectory;
      if (workingDir == null || workingDir.isEmpty) {
        throw Exception('No working directory set');
      }

      final configFile = File('$workingDir/lindbergh.conf');
      await configFile.writeAsString(_configController.text);
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Config'),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Text('Error: $_errorMessage')
              : SingleChildScrollView(
                  child: TextField(
                    controller: _configController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Edit lindbergh.conf...',
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
            if (_errorMessage == null) {
              if (widget.onSave != null) {
                widget.onSave!(_configController.text);
              }
              Navigator.pop(context);
            } else {
              setState(() {});
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
