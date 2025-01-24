import 'package:file_picker/file_picker.dart';

class FilePickerService {
  static Future<String?> pickExecutable() async {
    final shell = Shell();
    final results = await shell.run('zenity --file-selection --title="Select Lindbergh Executable" --file-filter="Lindbergh Executable | lindbergh"');
    if (results.isNotEmpty && results.first.exitCode == 0 && results.first.stdout.isNotEmpty) {
      final executablePath = results.first.stdout.trim();
      if (executablePath.endsWith('/lindbergh')) {
        return executablePath;
      }
    }
    return null;
  }

  static Future<String?> pickIcon(String iconsPath) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'gif'],
      dialogTitle: 'Select Game Icon',
      initialDirectory: iconsPath,
      lockParentWindow: true,
    );
    return result?.files.single.path;
  }
} 