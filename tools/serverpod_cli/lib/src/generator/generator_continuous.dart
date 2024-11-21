import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:watcher/watcher.dart';

import 'package:serverpod_cli/analyzer.dart';

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

  var modelSourcePath = p.joinAll(config.modelSourcePathParts);
  var protocolSourcePath = p.joinAll(config.protocolSourcePathParts);

  Timer? generateDispatch;
  await for (WatchEvent event in watchers) {
    log.debug('File changed: $event');

    var shouldGenerate =
        await endpointsAnalyzer.updateFileContexts({event.path});

    if (ModelHelper.isModelFile(
      event.path,
      modelSourcePath,
      protocolSourcePath,
    )) {
      shouldGenerate = true;
      var modelUri = Uri.parse(p.absolute(event.path));
      switch (event.type) {
        case ChangeType.ADD:
        case ChangeType.MODIFY:
          var yaml = File(event.path).readAsStringSync();
          modelAnalyzer.addYamlModel(ModelSource(
            defaultModuleAlias,
            yaml,
            modelUri,
            ModelHelper.extractPathFromConfig(config, Uri.parse(event.path)),
          ));
        case ChangeType.REMOVE:
          modelAnalyzer.removeYamlModel(modelUri);
      }
    }

    if (!shouldGenerate) continue;

    generateDispatch?.cancel();
    generateDispatch = Timer(const Duration(milliseconds: 500), () async {
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
