import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:watcher/watcher.dart';

import 'generator.dart';

/// Continuously generate code when files change.
Future<bool> performGenerateContinuously({
  required GeneratorConfig config,
  required EndpointsAnalyzer endpointsAnalyzer,
  required StatefulAnalyzer modelAnalyzer,
}) async {
  log.debug('Starting up continuous generator');

  var watchers = _setupAllWatchedDirectories(config);

  var success = await _performSafeGenerate(
    config: config,
    endpointsAnalyzer: endpointsAnalyzer,
    modelAnalyzer: modelAnalyzer,
    completionMessage:
        'Initial code generation complete. Listening for changes.',
  );

  Timer? debouncedGenerate;
  await for (WatchEvent event in watchers) {
    log.debug('File changed: $event');

    var shouldGenerate = await endpointsAnalyzer.updateFileContexts({
      event.path,
    });

    if (ModelHelper.isModelFile(
      event.path,
      loadConfig: config,
    )) {
      shouldGenerate = true;
      var modelUri = Uri.parse(p.absolute(event.path));
      switch (event.type) {
        case ChangeType.ADD:
        case ChangeType.MODIFY:
          var yaml = File(event.path).readAsStringSync();
          modelAnalyzer.addYamlModel(
            ModelSource(
              defaultModuleAlias,
              yaml,
              modelUri,
              ModelHelper.extractPathFromConfig(config, Uri.parse(event.path)),
            ),
          );
        case ChangeType.REMOVE:
          modelAnalyzer.removeYamlModel(modelUri);
      }
    }

    if (!shouldGenerate) continue;

    debouncedGenerate?.cancel();
    debouncedGenerate = Timer(const Duration(milliseconds: 500), () async {
      log.info(
        DateFormat('MMM dd - HH:mm:ss:SS').format(DateTime.now()),
        newParagraph: true,
      );
      log.info('File changed: $event');

      success = await _performSafeGenerate(
        config: config,
        endpointsAnalyzer: endpointsAnalyzer,
        modelAnalyzer: modelAnalyzer,
        completionMessage: 'Incremental code generation complete.',
      );
    });
  }

  return success;
}

Stream<WatchEvent> _setupAllWatchedDirectories(GeneratorConfig config) {
  var watchers = <DirectoryWatcher>[];

  var libPath = p.joinAll(config.libSourcePathParts);

  if (_directoryPathExists(libPath)) {
    watchers.add(DirectoryWatcher(libPath));
  }

  bool notInGeneratedDirectory(WatchEvent e) {
    var generatedFile = e.path.contains(
      p.joinAll(config.generatedServeModelPackagePathParts),
    );

    return !generatedFile;
  }

  return StreamGroup.merge(
    watchers.map((w) => w.events),
  ).where(notInGeneratedDirectory);
}

bool _directoryPathExists(String path) {
  var directory = Directory(path);
  return directory.existsSync();
}

Future<bool> _performSafeGenerate({
  required GeneratorConfig config,
  required EndpointsAnalyzer endpointsAnalyzer,
  required StatefulAnalyzer modelAnalyzer,
  required String completionMessage,
}) async {
  var success = false;
  try {
    success = await log.progress(
      'Generating code',
      () => performGenerate(
        config: config,
        endpointsAnalyzer: endpointsAnalyzer,
        modelAnalyzer: modelAnalyzer,
      ),
    );
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
