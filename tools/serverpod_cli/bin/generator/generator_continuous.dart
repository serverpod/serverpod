import 'package:watcher/watcher.dart';

import '../util/print.dart';
import 'config.dart';
import 'generator.dart';

void performGenerateContinuously(bool verbose) {
  if (!config.load()) return;

  vPrint(verbose, 'Starting up continuous generator');

  _performGenerateClassesContinuously(verbose);
  _performGenereateProtocolContinuously(verbose);
}

Future<void> _performGenerateClassesContinuously(bool verbose) async {
  var watcherClasses = DirectoryWatcher(config.protocolSourcePath);
  await for (WatchEvent event in watcherClasses.events) {
    print('File changed: $event');
    await performGenerate(
      verbose: verbose,
      changedFile: event.path,
      requestNewAnalyzer: false,
    );
    print('Incremental code generation complete.');
    print('');
  }
}

Future<void> _performGenereateProtocolContinuously(bool verbose) async {
  var watcherEndpoints = DirectoryWatcher(config.endpointsSourcePath);
  await for (WatchEvent event in watcherEndpoints.events) {
    print('File changed: $event');
    await performGenerate(
      verbose: verbose,
      changedFile: event.path,
      requestNewAnalyzer: false,
    );
    print('Incremental code generation complete.');
    print('');
  }
}
