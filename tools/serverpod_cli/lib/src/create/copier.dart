import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

class Copier {
  Directory srcDir;
  Directory dstDir;

  List<Replacement> replacements;
  List<Replacement> fileNameReplacements;

  List<String> removePatterns;

  List<String> ignoreFileNames;

  Copier({
    required this.srcDir,
    required this.dstDir,
    required this.replacements,
    required this.fileNameReplacements,
    this.removePatterns = const <String>[],
    this.ignoreFileNames = const <String>[],
  });

  void copyFiles() {
    _copyDirectory(srcDir, '');
  }

  void _copyDirectory(Directory dir, String relativePath) {
    for (var model in dir.listSync()) {
      var modelName = p.basename(model.path);
      if (ignoreFileNames.contains(modelName)) continue;
      if (modelName.startsWith('.')) continue;

      if (model is File) {
        _copyFile(model, relativePath);
      }
      if (model is Directory) {
        var dirName = p.basename(model.path);
        _copyDirectory(model, p.join(relativePath, dirName));
      }
    }
  }

  void _copyFile(File srcFile, String relativePath) {
    var fileName = p.basename(srcFile.path);
    if (fileName.startsWith('.')) return;

    var dstFileName =
        _replace(p.join(relativePath, fileName), fileNameReplacements);
    log.debug(
      p.join(dstDir.path, relativePath, fileName),
      type: TextLogType.bullet,
    );

    var dstFile = File(p.join(dstDir.path, dstFileName));
    var contents = srcFile.readAsStringSync();
    contents = _replace(contents, replacements);
    contents = _filterLines(contents, removePatterns);
    dstFile.createSync(recursive: true);
    dstFile.writeAsStringSync(contents);
  }

  String _replace(String str, List<Replacement> replacements) {
    for (var replacement in replacements) {
      str = str.replaceAll(replacement.slotName, replacement.replacement);
    }
    return str;
  }

  String _filterLines(String str, List<String> removePatterns) {
    var processedLines = <String>[];
    var lines = str.split('\n');

    for (var line in lines) {
      if (removePatterns.any((pattern) => line.contains(pattern))) continue;
      processedLines.add(line);
    }

    return processedLines.join('\n');
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
