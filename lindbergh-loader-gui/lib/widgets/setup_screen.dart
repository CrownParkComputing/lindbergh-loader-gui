import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lindbergh_loader_gui/data/core_config_repository.dart';
import 'package:lindbergh_loader_gui/data/core_config.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  late CoreConfig _config = CoreConfig();
  late final CoreConfigRepository _configRepository;

  @override
  void initState() {
    super.initState();
    _configRepository = CoreConfigRepository();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await _configRepository.loadConfig();
    setState(() {
      _config = config;
    });
  }

  Future<void> _saveConfig() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _configRepository.saveConfig(_config);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuration saved')),
      );
    }
  }

  Widget _buildPathPicker(String label, String? value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: Text(
                value ?? 'No path selected',
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8.0),
            IconButton(
              icon: const Icon(Icons.folder),
              onPressed: () async {
                final result = await FilePicker.platform.getDirectoryPath();
                if (result != null) {
                  onChanged(result);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildPathPicker(
                'Core Path',
                _config.corePath,
                (value) {
                  setState(() {
                    _config.corePath = value;
                  });
                },
              ),
              if (_config.corePath != null)
                Text(
                  'Lindbergh.conf path: ${_config.lindberghConfPath}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              const SizedBox(height: 16.0),
              _buildPathPicker(
                'Install Dependencies Script Path',
                _config.installDependenciesPath,
                (value) {
                  setState(() {
                    _config.installDependenciesPath = value;
                  });
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _saveConfig,
                child: const Text('Save Configuration'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
