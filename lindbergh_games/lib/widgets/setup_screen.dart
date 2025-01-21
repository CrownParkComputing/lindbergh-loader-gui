import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';
import 'package:process_run/shell_run.dart';
import 'dart:io';
import '../data/core_config_repository.dart';
import '../data/core_config.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  String? corePath;
  List<FileSystemEntity>? buildFiles;
  bool isRunningScript = false;

  @override
  void initState() {
    super.initState();
    _loadCorePath();
  }

  Future<void> _loadCorePath() async {
    final config = await CoreConfigRepository().loadConfig();
    setState(() {
      corePath = config.corePath;
    });
    if (corePath != null) {
      _loadBuildFiles();
    }
  }

  Future<void> _loadBuildFiles() async {
    if (corePath == null) return;
    
    final buildDir = Directory('$corePath/build');
    if (await buildDir.exists()) {
      final files = buildDir.listSync();
      setState(() {
        buildFiles = files.where((file) => file.path.endsWith('lindbergh.conf')).toList();
      });
    }
  }

  Future<void> _selectCorePath() async {
    try {
      final shell = Shell();
      
      // First try zenity
      var results = await shell.run('zenity --file-selection --directory');
      
      // If zenity fails, try kdialog
      if (results.isEmpty || results.first.exitCode != 0) {
        results = await shell.run('kdialog --getexistingdirectory');
      }
      
      // If both fail, fallback to terminal input
      if (results.isEmpty || results.first.exitCode != 0) {
        print('Please enter the core folder path:');
        final path = stdin.readLineSync();
        results = [ProcessResult(0, 0, path ?? '', '')];
      }

      if (results.isNotEmpty && results.first.stdout.isNotEmpty) {
        final path = results.first.stdout.trim();
        print('Selected core path: $path');
        
        // Verify the path exists
        final dir = Directory(path);
        if (!await dir.exists()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Selected directory does not exist')),
          );
          return;
        }
        
        // Verify the path contains the install script
        final scriptFile = File('$path/scripts/install_dependencies.sh');
        if (!await scriptFile.exists()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Selected directory does not contain install script')),
          );
          return;
        }

        setState(() {
          corePath = path;
        });
        
        // Save config and verify it was saved
        final config = CoreConfig(corePath: path);
        await CoreConfigRepository().saveConfig(config);
        
        // Verify the config was saved by loading it back
        final loadedConfig = await CoreConfigRepository().loadConfig();
        if (loadedConfig.corePath != path) {
          throw Exception('Failed to save core path');
        }
        
        _loadBuildFiles();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Core path saved successfully')),
        );
      }
    } catch (e) {
      print('Error selecting core path: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving core path: ${e.toString()}')),
      );
    }
  }

  Future<void> _runInstallScript() async {
    if (corePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set core folder path first')),
      );
      return;
    }

    final scriptPath = '${corePath!}/scripts/install_dependencies.sh';
    final scriptFile = File(scriptPath);
    
    if (!await scriptFile.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Install script not found in core directory')),
      );
      return;
    }

    setState(() {
      isRunningScript = true;
    });

    try {
      final shell = Shell();
      print('Running install script at: $scriptPath');
      
      // Run script with full path instead of cd
      final result = await shell.run('''
        "$scriptPath"
      ''');

      if (result.first.exitCode != 0) {
        print('Script failed with exit code: ${result.first.exitCode}');
        print('Stderr: ${result.first.stderr}');
        print('Stdout: ${result.first.stdout}');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Script failed: ${result.first.stderr}')),
        );
      } else {
        print('Script completed successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Installation completed successfully')),
        );
      }
    } catch (e) {
      print('Error running script: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error running script: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isRunningScript = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Core Folder: ${corePath ?? 'Not set'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectCorePath,
              child: const Text('Set Core Folder Path'),
            ),
            const SizedBox(height: 32),
            if (corePath != null) ...[
              const Text(
                'Build Artifacts:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (buildFiles != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: buildFiles!.length,
                    itemBuilder: (context, index) {
                      final file = buildFiles![index];
                      return ListTile(
                        title: Text(file.path.split('/').last),
                        subtitle: Text(file.path),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _editConfigFile(file.path);
                          },
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isRunningScript ? null : _runInstallScript,
                child: isRunningScript
                    ? const CircularProgressIndicator()
                    : const Text('Run Install Dependencies Script'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _editConfigFile(String path) async {
    final shell = Shell();
    try {
      // Ensure directory exists
      final file = File(path);
      if (!await file.exists()) {
        await file.create(recursive: true);
      }
      
      // Try xdg-open first, fallback to nano
      try {
        await shell.run('xdg-open "$path"');
      } catch (e) {
        await shell.run('nano "$path"');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open editor: ${e.toString()}')),
      );
    }
  }
}
