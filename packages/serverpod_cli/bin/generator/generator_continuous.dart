import 'package:watcher/watcher.dart';

import 'config.dart';
import 'generator.dart';
import 'protocol_generator.dart';

void performGenerateContinuously(bool verbose) {
  if (!config.load())
    return;

  if (verbose)
    print('Starting up continuous generator');

  _performGenerateClassesContinuously(verbose);
  _performGenereateProtocolContinuously(verbose);
}

Future<void> _performGenerateClassesContinuously(bool verbose) async {
  var watcherClasses = DirectoryWatcher(config.sourceProtocol);
  await for (WatchEvent event in watcherClasses.events) {
    print('File changed: $event');
    switch(event.type) {
      case ChangeType.ADD:
      case ChangeType.MODIFY:
        performGenerate(verbose, false);
        break;
      case ChangeType.REMOVE:
      // TODO: Remove
        break;
    }
  }
}

Future<void> _performGenereateProtocolContinuously(bool verbose) async {
  var watcherEndpoints = DirectoryWatcher(config.sourceEndpoints);
  await for(WatchEvent event in watcherEndpoints.events) {
    print('File changed: $event');
    switch(event.type) {
      case ChangeType.ADD:
      case ChangeType.MODIFY:
        if (event.path.endsWith('.dart'))
          await performGenerateProtocol(verbose);
        break;
      case ChangeType.REMOVE:
      // TODO: Remove
        break;
    }
  }
}