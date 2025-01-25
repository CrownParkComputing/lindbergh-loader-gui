class InstallConfig {
  static final Map<String, ProcessStep> steps = {
    'game.bin': ProcessStep(
      file: 'game.bin',
      filesystem: 'ext2',
      copyDirs: ['game', 'data'],
      destinationSubfolder: 'game',
      extraCopyDirs: [
        ExtraCopyDir(source: 'extra/content', destination: 'extra'),
      ],
    ),
    // Add more configurations for different bin files
  };

  static ProcessStep? getStepForFile(String filename) {
    return steps[path.basename(filename)];
  }
} 