import 'package:async/async.dart';
import 'package:watcher/watcher.dart';

import '../config/config.dart';
import 'generator.dart';

/// Continuously generate code when files change.
void performGenerateContinuously(bool verbose, GeneratorConfig config) async {
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
    );
    print('Incremental code generation complete.');
    print('');
  }
}
