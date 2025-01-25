import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lindbergh_loader_gui/services/bin_processor_service.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:lindbergh_loader_gui/widgets/sudo_password_dialog.dart';

class BinProcessorScreen extends StatefulWidget {
  const BinProcessorScreen({super.key});

  @override
  State<BinProcessorScreen> createState() => _BinProcessorScreenState();
}

class _BinProcessorScreenState extends State<BinProcessorScreen> {
  String? _selectedBinPath;
  bool _isProcessing = false;
  String _status = '';
  double _progress = 0;
  List<String> _extractedFiles = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _selectBinFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['bin'],
      dialogTitle: 'Select Lindbergh Bin File',
      allowMultiple: false,
      withData: false,
      withReadStream: false,
      lockParentWindow: true,
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      if (!path.endsWith('/')) {
        setState(() {
          _selectedBinPath = path;
          _status = 'Selected: ${result.files.single.name}';
        });
      } else {
        setState(() {
          _status = 'Error: Please select a bin file, not a directory';
        });
      }
    }
  }

  Future<void> _processBinFile() async {
    if (_selectedBinPath == null) return;

    setState(() {
      _isProcessing = true;
      _status = 'Processing bin file...';
      _progress = 0;
      _extractedFiles.clear();
    });

    try {
      await BinProcessorService.processBinFile(
        _selectedBinPath!,
        (message, current, total) {
          setState(() {
            _status = message;
            _progress = current / total;
            if (message.startsWith('Found:') || 
                message.startsWith('Copying') ||
                message.contains('complete')) {
              _extractedFiles.add(message);
              // Auto-scroll to bottom
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  );
                }
              });
            }
          });
        },
        '',
      );

      final outputDir = path.join(
        path.dirname(_selectedBinPath!),
        path.basenameWithoutExtension(_selectedBinPath!)
      );
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Extracted ${_extractedFiles.length} files to:'),
              const SizedBox(height: 8),
              SelectableText(outputDir),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await Process.run('xdg-open', [outputDir]);
                } catch (e) {
                  print('Failed to open directory: $e');
                }
                if (mounted) Navigator.pop(context);
              },
              child: const Text('Open Folder'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        _status = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bin File Processor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a Lindbergh bin file to process',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedBinPath ?? 'No file selected',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _selectBinFile,
                  icon: const Icon(Icons.file_upload),
                  label: const Text('Select Bin File'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_status.isNotEmpty) ...[
              Text(_status),
              const SizedBox(height: 8),
              if (_isProcessing || _progress > 0)
                LinearProgressIndicator(value: _progress),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: _extractedFiles.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        _extractedFiles[index],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: _isProcessing
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _selectedBinPath != null ? _processBinFile : null,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Process Bin File'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}