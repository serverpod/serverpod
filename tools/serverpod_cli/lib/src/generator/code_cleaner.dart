import 'dart:io';

import 'code_analysis_collector.dart';

void performRemoveOldFiles({
  required bool verbose,
  required CodeAnalysisCollector collector,
  required String generatedServerProtocolPath,
  required String generatedClientProtocolPath,
}) {
  var keepFilePaths = collector.generatedFiles.map((e) => e.path).toSet();

  _removeOldFilesInPath(
    generatedServerProtocolPath,
    keepFilePaths,
    verbose,
  );

  _removeOldFilesInPath(
    generatedClientProtocolPath,
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
  if (verbose) {
    print('Remove old files from $directory');
  }
  var fileList = directory.listSync(recursive: true);

  for (var entity in fileList) {
    // Only check Dart files.
    if (entity is! File || !entity.path.endsWith('.dart')) {
      continue;
    }

    if (!keepPaths.contains(entity.path)) {
      if (verbose) {
        print('Remove: $entity');
      }
      entity.deleteSync();
    }
  }
}
