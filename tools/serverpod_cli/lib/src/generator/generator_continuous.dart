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

  var watcherClasses =
      DirectoryWatcher(p.joinAll(config.protocolSourcePathParts));
  var watcherEndpoints =
      DirectoryWatcher(p.joinAll(config.endpointsSourcePathParts));

  var success = await _performSafeGenerate(
      config: config, endpointsAnalyzer: endpointsAnalyzer);

  await for (WatchEvent event
      in StreamGroup.merge([watcherClasses.events, watcherEndpoints.events])) {
    log.info(
      'File changed: $event',
      newParagraph: true,
    );
    success = await _performSafeGenerate(
        config: config, endpointsAnalyzer: endpointsAnalyzer);
  }

  return success;
}

Future<bool> _performSafeGenerate({
  required GeneratorConfig config,
  required EndpointsAnalyzer endpointsAnalyzer,
}) async {
  var success = false;
  try {
    success = await log.progress(
        'Generating code',
        () => performGenerate(
              config: config,
              endpointsAnalyzer: endpointsAnalyzer,
            ));
    log.info('Incremental code generation complete.');
  } catch (e) {
    if (e is Error) {
      log.error(e.toString(), stackTrace: e.stackTrace);
    } else {
      log.error(e.toString());
    }
  }

  return success;
}
