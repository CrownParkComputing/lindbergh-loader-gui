import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:convert';

class UpdateService {
  static const String apiUrl = 'https://api.github.com/repos/lindbergh-loader/lindbergh-loader/releases/latest';
  static const String confUrl = 'https://raw.githubusercontent.com/lindbergh-loader/lindbergh-loader/master/docs/lindbergh.conf';
  
  static Future<Map<String, dynamic>> checkForUpdates() async {
    try {
      print('Checking for updates from: $apiUrl');
      
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'Lindbergh-Loader-GUI',
        },
      );

      print('Response status code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Release data: $data');
        
        final assets = data['assets'] as List?;
        if (assets == null || assets.isEmpty) {
          print('No assets found in release data');
          return {
            'version': data['tag_name'].toString().replaceAll('v', ''),
            'body': data['body'],
            'publishedAt': data['published_at'],
            'hasAssets': false,
          };
        }

        // Find the Linux asset (should be a .tar.gz or .zip file)
        print('Looking for Linux asset in ${assets.length} assets');
        for (var asset in assets) {
          print('Checking asset: ${asset['name']}');
        }

        final linuxAsset = assets.firstWhere(
          (asset) => asset['name'].toString().toLowerCase().contains('linux') || 
                    asset['name'].toString().toLowerCase().endsWith('.tar.gz') ||
                    asset['name'].toString().toLowerCase().endsWith('.zip'),
          orElse: () {
            print('No Linux asset found in release');
            return null;
          },
        );

        if (linuxAsset != null) {
          print('Found Linux asset: ${linuxAsset['name']}');
          print('Download URL: ${linuxAsset['browser_download_url']}');

          return {
            'version': data['tag_name'].toString().replaceAll('v', ''),
            'downloadUrl': linuxAsset['browser_download_url'],
            'body': data['body'],
            'publishedAt': data['published_at'],
            'assetName': linuxAsset['name'],
            'hasAssets': true,
          };
        } else {
          return {
            'version': data['tag_name'].toString().replaceAll('v', ''),
            'body': data['body'],
            'publishedAt': data['published_at'],
            'hasAssets': false,
          };
        }
      }
      
      print('Error response body: ${response.body}');
      throw Exception('Failed to check for updates: ${response.statusCode}');
    } catch (e, stackTrace) {
      print('Error checking for updates:');
      print(e);
      print('Stack trace:');
      print(stackTrace);
      throw Exception('Failed to check for updates: $e');
    }
  }

  static Future<bool> isConfFileChanged(String currentConfPath) async {
    try {
      final response = await http.get(Uri.parse(confUrl));
      if (response.statusCode == 200) {
        final currentConf = await File(currentConfPath).readAsString();
        return currentConf.trim() != response.body.trim();
      }
      return false;
    } catch (e) {
      print('Error checking conf file: $e');
      return false;
    }
  }

  static Future<void> downloadAndInstall(
    String downloadUrl,
    String executableDir,  // Directory containing the game executable
    void Function(double progress, String status) onProgress,
  ) async {
    if (downloadUrl.isEmpty || executableDir.isEmpty) {
      throw Exception('Invalid download URL or executable directory');
    }

    try {
      print('Starting download from: $downloadUrl');
      print('Installing to executable directory: $executableDir');
      
      // Create executable directory if it doesn't exist
      final executableDirDir = Directory(executableDir);
      if (!await executableDirDir.exists()) {
        await executableDirDir.create(recursive: true);
      }

      // Download the release
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(downloadUrl));
      request.headers['User-Agent'] = 'Lindbergh-Loader-GUI';
      
      final response = await client.send(request);
      print('Download response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Failed to download update: ${response.statusCode}');
      }

      final contentLength = response.contentLength ?? 0;
      int received = 0;

      // Create temp directory
      final tempDir = await Directory.systemTemp.createTemp('lindbergh_update_');
      print('Created temp directory: ${tempDir.path}');
      
      final zipFile = File(path.join(tempDir.path, 'update.tar.gz'));
      print('Download file: ${zipFile.path}');
      
      final sink = zipFile.openWrite();

      try {
        await response.stream.forEach((chunk) {
          sink.add(chunk);
          received += chunk.length;
          if (contentLength > 0) {
            final progress = received / contentLength;
            final percentage = (progress * 100).toInt();
            onProgress(progress, 'Downloading... $percentage%');
          }
        });
      } finally {
        await sink.close();
      }

      print('Download complete. Extracting files...');
      onProgress(0.5, 'Extracting files...');

      // Extract files directly to the executable directory
      final result = await Process.run('tar', [
        'xzf',
        zipFile.path,
        '-C',
        executableDir,
        '--strip-components=2',  // Remove top-level and build/ directories
        '--verbose'
      ]);

      print('Extraction stdout: ${result.stdout}');
      print('Extraction stderr: ${result.stderr}');

      if (result.exitCode != 0) {
        throw Exception('Failed to extract update: ${result.stderr}');
      }

      onProgress(1.0, 'Installation complete');

      // Cleanup
      print('Cleaning up temporary files...');
      await tempDir.delete(recursive: true);
      print('Update complete');

    } catch (e) {
      print('Error during update: $e');
      throw Exception('Failed to install update: $e');
    }
  }

  static Future<void> updateConfFile(String confPath) async {
    try {
      print('Updating conf file at: $confPath');
      final response = await http.get(Uri.parse(confUrl));
      
      if (response.statusCode == 200) {
        final confFile = File(confPath);
        
        // Create backup if original exists
        if (await confFile.exists()) {
          final backupPath = '$confPath.backup';
          print('Creating backup at: $backupPath');
          await confFile.copy(backupPath);
        }

        // Write new conf
        print('Writing new conf file');
        await confFile.writeAsString(response.body);
        print('Conf file updated successfully');
      } else {
        throw Exception('Failed to download conf file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating conf file: $e');
      throw Exception('Failed to update conf file: $e');
    }
  }
} 