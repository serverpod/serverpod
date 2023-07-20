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
  var hasErrors = false;
  await for (WatchEvent event
      in StreamGroup.merge([watcherClasses.events, watcherEndpoints.events])) {
    log.info(
      'File changed: $event',
      newParagraph: true,
      style: const TextLog(),
    );
    hasErrors = await performGenerate(
      changedFile: event.path,
      config: config,
      endpointsAnalyzer: endpointsAnalyzer,
    );
    log.info('Incremental code generation complete.');
  }

  return hasErrors;
}
