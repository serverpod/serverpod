import 'package:watcher/watcher.dart';

import 'class_generator.dart';
import 'config.dart';
import 'protocol_generator.dart';

void performGenerateContinuously(bool verbose) {
  if (!config.load()) return;

  if (verbose) print('Starting up continuous generator');

  _performGenerateClassesContinuously(verbose);
  _performGenereateProtocolContinuously(verbose);
}

Future<void> _performGenerateClassesContinuously(bool verbose) async {
  DirectoryWatcher watcherClasses = DirectoryWatcher(config.protocolSourcePath);
  await for (WatchEvent event in watcherClasses.events) {
    print('File changed: $event');
    switch (event.type) {
      case ChangeType.ADD:
      case ChangeType.MODIFY:
        performGenerateClasses(verbose);
        break;
      case ChangeType.REMOVE:
        // TODO: Remove
        break;
    }
  }
}

Future<void> _performGenereateProtocolContinuously(bool verbose) async {
  DirectoryWatcher watcherEndpoints = DirectoryWatcher(config.endpointsSourcePath);
  await for (WatchEvent event in watcherEndpoints.events) {
    print('File changed: $event');
    switch (event.type) {
      case ChangeType.ADD:
      case ChangeType.MODIFY:
        if (event.path.endsWith('.dart')) {
          await performGenerateProtocol(verbose);
        }
        break;
      case ChangeType.REMOVE:
        // TODO: Remove
        break;
    }
  }
}
