import 'package:async/async.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:watcher/watcher.dart';

import 'generator.dart';

/// Continuously generate code when files change.
void performGenerateContinuously({
  required bool verbose,
  required GeneratorConfig config,
  required ProtocolAnalyzer analyzer,
}) async {
  if (verbose) print('Starting up continuous generator');

  var watcherClasses = DirectoryWatcher(config.relativeProtocolSourcePath);
  var watcherEndpoints = DirectoryWatcher(config.relativeEndpointsSourcePath);

  await for (WatchEvent event
      in StreamGroup.merge([watcherClasses.events, watcherEndpoints.events])) {
    print('File changed: $event');
    await performGenerate(
      verbose: verbose,
      changedFile: event.path,
      config: config,
      analyzer: analyzer,
    );
    print('Incremental code generation complete.');
    print('');
  }
}
