import 'dart:io';

import 'package:async/async.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:watcher/watcher.dart';
import 'package:path/path.dart' as p;

import 'generator.dart';

/// Continuously generate code when files change.
Future<bool> performGenerateContinuously({
  required GeneratorConfig config,
  required EndpointsAnalyzer endpointsAnalyzer,
}) async {
  log.debug('Starting up continuous generator');

  var watchers = _setupAllWatchedDirectories(config);

  var success = await _performSafeGenerate(
    config: config,
    endpointsAnalyzer: endpointsAnalyzer,
    completionMessage:
        'Initial code generation complete. Listening for changes.',
  );

  await for (WatchEvent event in watchers) {
    log.info(
      'File changed: $event',
      newParagraph: true,
    );
    success = await _performSafeGenerate(
      config: config,
      endpointsAnalyzer: endpointsAnalyzer,
      changedFilePath: event.path,
      completionMessage: 'Incremental code generation complete.',
    );
  }

  return success;
}

Stream<WatchEvent> _setupAllWatchedDirectories(GeneratorConfig config) {
  var watchers = <DirectoryWatcher>[];

  var protocolPath = p.joinAll(config.protocolSourcePathParts);
  var modelPath = p.joinAll(config.modelSourcePathParts);
  var endpointPath = p.joinAll(config.endpointsSourcePathParts);

  if (_directoryPathExists(protocolPath)) {
    watchers.add(DirectoryWatcher(p.joinAll(config.protocolSourcePathParts)));
  }

  if (_directoryPathExists(modelPath)) {
    watchers.add(DirectoryWatcher(p.joinAll(config.modelSourcePathParts)));
  }

  if (_directoryPathExists(endpointPath)) {
    watchers.add(DirectoryWatcher(p.joinAll(config.endpointsSourcePathParts)));
  }

  return StreamGroup.merge(watchers.map((w) => w.events));
}

bool _directoryPathExists(String path) {
  var directory = Directory(path);
  return directory.existsSync();
}

Future<bool> _performSafeGenerate({
  required GeneratorConfig config,
  required EndpointsAnalyzer endpointsAnalyzer,
  String? changedFilePath,
  required String completionMessage,
}) async {
  var success = false;
  try {
    success = await log.progress(
        'Generating code',
        () => performGenerate(
              config: config,
              endpointsAnalyzer: endpointsAnalyzer,
              changedFilePath: changedFilePath,
            ));
    log.info(completionMessage);
  } catch (e) {
    if (e is Error) {
      log.error(e.toString(), stackTrace: e.stackTrace);
    } else {
      log.error(e.toString());
    }
  }

  return success;
}
