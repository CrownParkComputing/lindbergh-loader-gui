import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;

class ProcessStep {
  final String file;
  final String filesystem;
  final List<String> copyDirs;
  final String? destinationSubfolder;
  final List<ExtraCopyDir> extraCopyDirs;

  ProcessStep({
    required this.file,
    this.filesystem = 'ext2',
    this.copyDirs = const [],
    this.destinationSubfolder,
    this.extraCopyDirs = const [],
  });
}

class ExtraCopyDir {
  final String source;
  final String destination;

  ExtraCopyDir({required this.source, required this.destination});
}

class BinProcessorService {
  static const String mountPoint = '/mnt/lindbergh_temp';
  static const String loopDeviceBase = '/dev/loop';
  static const int sectorSize = 4096;
  static String? _activeLoopDevice;

  static Future<void> processBinFile(
    String binFilePath,
    void Function(String message, int current, int total) onProgress,
    String password,
  ) async {
    try {
      // Get current user and group
      final userResult = await Process.run('id', ['-u']);
      final groupResult = await Process.run('id', ['-g']);
      final userId = userResult.stdout.trim();
      final groupId = groupResult.stdout.trim();

      onProgress('Starting bin file processing...', 0, 4);

      // Create temporary script file with all commands
      final script = '''
#!/bin/bash
set -e

# Enable verbose output
set -x

cleanup() {
    echo "Running cleanup..."
    # Ensure everything is unmounted and cleaned up even if script fails
    if mountpoint -q "$mountPoint"; then
        echo "Unmounting $mountPoint"
        umount -f "$mountPoint" || true
    fi
    echo "Detaching loop devices"
    losetup -D || true  # Detach all loop devices
    echo "Removing mount point"
    rm -rf "$mountPoint" || true
}

# Set up cleanup trap
trap cleanup EXIT

# Check if running as root
if [ "\$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

echo "Processing bin file: \$1"
echo "Current user ID: $userId"
echo "Current group ID: $groupId"

# Setup mount point
echo "Setting up mount point: $mountPoint"
rm -rf "$mountPoint" || true
mkdir -p "$mountPoint"
chmod 700 "$mountPoint"

# Setup loop device
echo "Creating loop device..."
LOOP_DEV=\$(losetup --find --show --read-only "\$1")
echo "Using loop device: \$LOOP_DEV"

# Mount filesystem
echo "Mounting filesystem..."
mount -t auto -o ro,loop "\$LOOP_DEV" "$mountPoint"
echo "Mount successful"

# List contents of mounted bin
echo "Contents of bin file:"
ls -la "$mountPoint"
find "$mountPoint" -type f | while read -r file; do
    echo "Found file: \$file"
done

# Create destination directory
DEST_DIR="\$(dirname "\$1")/\$(basename "\$1" .bin)"
echo "Creating destination directory: \$DEST_DIR"
mkdir -p "\$DEST_DIR"

# Copy contents with rsync
echo "Copying files..."
rsync -av --delete --progress "$mountPoint/" "\$DEST_DIR/"

# Change ownership to original user
echo "Changing ownership to $userId:$groupId"
chown -R $userId:$groupId "\$DEST_DIR"
chmod -R u+rw "\$DEST_DIR"

echo "Listing extracted files:"
ls -la "\$DEST_DIR"

echo "Process complete!"
# Cleanup is handled by trap
''';

      final scriptFile = File('/tmp/lindbergh_processor.sh');
      await scriptFile.writeAsString(script);
      await Process.run('chmod', ['+x', scriptFile.path]);

      onProgress('Mounting bin file...', 1, 4);

      // Execute script with pkexec, passing the bin file path as an argument
      final result = await Process.run('pkexec', [scriptFile.path, binFilePath]);
      
      // Process and display the output
      final outputLines = result.stdout.toString().split('\n');
      final errorLines = result.stderr.toString().split('\n');

      for (final line in outputLines) {
        if (line.trim().isNotEmpty) {
          if (line.contains('Found file:')) {
            onProgress('Found: ${line.split('Found file:').last.trim()}', 2, 4);
          } else if (line.contains('Copying files')) {
            onProgress('Copying files...', 3, 4);
          } else {
            print('Output: $line');
          }
        }
      }

      // Print errors if any
      for (final line in errorLines) {
        if (line.trim().isNotEmpty) {
          print('Error: $line');
        }
      }

      if (result.exitCode != 0) {
        throw Exception('Processing failed: ${result.stderr}');
      }

      // Clean up the script file
      try {
        await scriptFile.delete();
      } catch (e) {
        print('Warning: Failed to delete script file: $e');
      }

      onProgress('Extraction complete', 4, 4);

    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to process bin file: $e');
    }
  }

  static Future<void> copyContent(String source, String destination) async {
    final sourceDir = Directory(source);
    if (!await sourceDir.exists()) return;

    await for (final entity in sourceDir.list(recursive: true)) {
      if (entity is File) {
        final relativePath = path.relative(entity.path, from: source);
        final destPath = path.join(destination, relativePath);
        await Directory(path.dirname(destPath)).create(recursive: true);
        await entity.copy(destPath);
      }
    }
  }
}