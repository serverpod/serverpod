import 'package:async/async.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoints_analyzer.dart';
import 'package:watcher/watcher.dart';

import 'config.dart';
import 'generator.dart';

void performGenerateContinuously(
  bool verbose,
  GeneratorConfig config, {
  required EndpointsAnalyzer analyzer,
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
