import 'dart:io';

import 'package:path/path.dart' as p;

class Copier {
  Directory srcDir;
  Directory dstDir;

  List<Replacement> replacements;
  List<Replacement> fileNameReplacements;

  bool verbose;

  Copier({
    required this.srcDir,
    required this.dstDir,
    required this.replacements,
    required this.fileNameReplacements,
    this.verbose = false,
  });

  void copyFiles() {
    _copyDirectory(srcDir, '');
  }

  void _copyDirectory(Directory dir, String relativePath) {
    for (var entity in dir.listSync()) {
      if (entity is File) {
        _copyFile(entity, relativePath);
      }
      if (entity is Directory) {
        String dirName = p.basename(entity.path);
        if (dirName.startsWith('.'))
          continue;
        _copyDirectory(entity, '$relativePath$dirName/');
      }
    }
  }

  void _copyFile(File srcFile, String relativePath) {
    String fileName = p.basename(srcFile.path);
    if (fileName.startsWith('.'))
      return;

    String dstFileName = _replace('$relativePath$fileName', fileNameReplacements);
    if (verbose)
      print('copy: $relativePath$fileName -> $dstFileName');

    var dstFile = File('${dstDir.path}/$dstFileName');
    String contents = srcFile.readAsStringSync();
    contents = _replace(contents, replacements);
    dstFile.createSync(recursive: true);
    dstFile.writeAsStringSync(contents);
  }

  String _replace(String str, List<Replacement> replacements) {
    for (var replacement in replacements) {
      str = str.replaceAll(replacement.slotName, replacement.replacement);
    }
    return str;
  }
}

class Replacement {
  String slotName;
  String replacement;

  Replacement({
    required this.slotName,
    required this.replacement,
  });
}