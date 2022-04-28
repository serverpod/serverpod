import 'dart:io';

import 'package:path/path.dart' as p;

class Copier {
  Directory srcDir;
  Directory dstDir;

  List<Replacement> replacements;
  List<Replacement> fileNameReplacements;

  List<String> removePrefixes;

  List<String> ignoreFileNames;

  bool verbose;

  Copier({
    required this.srcDir,
    required this.dstDir,
    required this.replacements,
    required this.fileNameReplacements,
    this.verbose = false,
    this.removePrefixes = const <String>[],
    this.ignoreFileNames = const <String>[],
  });

  void copyFiles() {
    _copyDirectory(srcDir, '');
  }

  void _copyDirectory(Directory dir, String relativePath) {
    for (FileSystemEntity entity in dir.listSync()) {
      String entityName = p.basename(entity.path);
      if (ignoreFileNames.contains(entityName)) continue;
      if (entityName.startsWith('.')) continue;

      if (entity is File) {
        _copyFile(entity, relativePath);
      }
      if (entity is Directory) {
        String dirName = p.basename(entity.path);
        _copyDirectory(entity, '$relativePath$dirName/');
      }
    }
  }

  void _copyFile(File srcFile, String relativePath) {
    String fileName = p.basename(srcFile.path);
    if (fileName.startsWith('.')) return;

    String dstFileName =
        _replace('$relativePath$fileName', fileNameReplacements);
    print('  ${dstDir.path}$relativePath$fileName');

    File dstFile = File('${dstDir.path}/$dstFileName');
    String contents = srcFile.readAsStringSync();
    contents = _replace(contents, replacements);
    contents = _filterLines(contents, removePrefixes);
    dstFile.createSync(recursive: true);
    dstFile.writeAsStringSync(contents);
  }

  String _replace(String str, List<Replacement> replacements) {
    for (Replacement replacement in replacements) {
      str = str.replaceAll(replacement.slotName, replacement.replacement);
    }
    return str;
  }

  String _filterLines(String str, List<String> prefixes) {
    for (String prefix in prefixes) {
      List<String> lines = str.split('\n');
      List<String> processedLines = <String>[];
      for (String line in lines) {
        if (line.trim().startsWith(prefix) &&
            !line.trim().startsWith('path: ^')) continue;
        processedLines.add(line);
      }
      str = processedLines.join('\n');
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
