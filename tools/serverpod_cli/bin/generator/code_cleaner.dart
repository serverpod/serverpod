import 'dart:io';

import '../util/print.dart';
import 'code_analysis_collector.dart';
import 'config.dart';

void performRemoveOldFiles({
  required bool verbose,
  required CodeAnalysisCollector collector,
}) {
  var keepFilePaths = collector.generatedFiles.map((e) => e.path).toSet();

  _removeOldFilesInPath(
    config.generatedServerProtocolPath,
    keepFilePaths,
    verbose,
  );

  _removeOldFilesInPath(
    config.generatedClientProtocolPath,
    keepFilePaths,
    verbose,
  );
}

void _removeOldFilesInPath(
  String directoryPath,
  Set<String> keepPaths,
  bool verbose,
) {
  var directory = Directory(directoryPath);
  vPrint(verbose, 'Remove old files from $directory');
  var fileList = directory.listSync();

  for (var entity in fileList) {
    // Only check Dart files.
    if (entity is! File || !entity.path.endsWith('.dart')) {
      continue;
    }

    if (!keepPaths.contains(entity.path)) {
      vPrint(verbose, 'Remove: $entity');
      entity.deleteSync();
    }
  }
}
