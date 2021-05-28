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
    for (var entity in dir.listSync()) {
      var entityName = p.basename(entity.path);
      if (ignoreFileNames.contains(entityName))
        continue;
      if (entityName.startsWith('.'))
        continue;

      if (entity is File) {
        _copyFile(entity, relativePath);
      }
      if (entity is Directory) {
        var dirName = p.basename(entity.path);
        _copyDirectory(entity, '$relativePath$dirName/');
      }
    }
  }

  void _copyFile(File srcFile, String relativePath) {
    var fileName = p.basename(srcFile.path);
    if (fileName.startsWith('.'))
      return;

    var dstFileName = _replace('$relativePath$fileName', fileNameReplacements);
    print('  ${dstDir.path}$relativePath$fileName');

    var dstFile = File('${dstDir.path}/$dstFileName');
    var contents = srcFile.readAsStringSync();
    contents = _replace(contents, replacements);
    contents = _filterLines(contents, removePrefixes);
    dstFile.createSync(recursive: true);
    dstFile.writeAsStringSync(contents);
  }

  String _replace(String str, List<Replacement> replacements) {
    for (var replacement in replacements) {
      str = str.replaceAll(replacement.slotName, replacement.replacement);
    }
    return str;
  }


  String _filterLines(String str, List<String> prefixes) {
    for (var prefix in prefixes) {
      var lines = str.split('\n');
      var processedLines = <String>[];
      for (var line in lines) {
        if (line.trim().startsWith(prefix) && !line.trim().startsWith('path: ^'))
          continue;
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