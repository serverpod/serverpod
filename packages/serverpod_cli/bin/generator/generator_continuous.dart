import 'package:watcher/watcher.dart';

import 'generator.dart';
import 'protocol_generator.dart';
//import 'protocol_analyzer.dart';

void performGenerateContinuously(bool verbose) {
  if (verbose)
    print('Starting up continuous generator');

  _performGenerateClassesContinuously(verbose);
  _performGenereateProtocolContinuously(verbose);
}

Future<void> _performGenerateClassesContinuously(bool verbose) async {
  var watcherClasses = DirectoryWatcher('lib/src/protocol');
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
  var watcherEndpoints = DirectoryWatcher('lib/src/endpoints');
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