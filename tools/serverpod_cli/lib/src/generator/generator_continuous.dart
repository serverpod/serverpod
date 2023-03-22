import 'package:watcher/watcher.dart';

import 'config.dart';
import 'generator.dart';

void performGenerateContinuously(bool verbose, GeneratorConfig config) {
  if (verbose) print('Starting up continuous generator');

  _performGenerateClassesContinuously(verbose, config);
  _performGenereateProtocolContinuously(verbose, config);
}

Future<void> _performGenerateClassesContinuously(
    bool verbose, GeneratorConfig config) async {
  var watcherClasses = DirectoryWatcher(config.protocolSourcePath);
  await for (WatchEvent event in watcherClasses.events) {
    print('File changed: $event');
    await performGenerate(
      verbose: verbose,
      changedFile: event.path,
      requestNewAnalyzer: false,
      config: config,
    );
    print('Incremental code generation complete.');
    print('');
  }
}

Future<void> _performGenereateProtocolContinuously(
    bool verbose, GeneratorConfig config) async {
  var watcherEndpoints = DirectoryWatcher(config.endpointsSourcePath);
  await for (WatchEvent event in watcherEndpoints.events) {
    print('File changed: $event');
    await performGenerate(
      verbose: verbose,
      changedFile: event.path,
      requestNewAnalyzer: false,
      config: config,
    );
    print('Incremental code generation complete.');
    print('');
  }
}
