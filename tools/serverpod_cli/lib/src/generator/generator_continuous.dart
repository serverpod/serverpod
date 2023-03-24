import 'package:async/async.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:watcher/watcher.dart';
import 'package:path/path.dart' as p;

import 'generator.dart';

/// Continuously generate code when files change.
void performGenerateContinuously({
  required bool verbose,
  required GeneratorConfig config,
  required EndpointsAnalyzer endpointsAnalyzer,
}) async {
  if (verbose) print('Starting up continuous generator');

  var watcherClasses =
      DirectoryWatcher(p.joinAll(config.protocolSourcePathParts));
  var watcherEndpoints =
      DirectoryWatcher(p.joinAll(config.endpointsSourcePathParts));

  await for (WatchEvent event
      in StreamGroup.merge([watcherClasses.events, watcherEndpoints.events])) {
    print('File changed: $event');
    await performGenerate(
      verbose: verbose,
      changedFile: event.path,
      config: config,
      endpointsAnalyzer: endpointsAnalyzer,
    );
    print('Incremental code generation complete.');
    print('');
  }
}
