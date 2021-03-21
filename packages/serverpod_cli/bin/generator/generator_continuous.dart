import 'package:watcher/watcher.dart';

import 'generator.dart';
import 'protocol_analyzer.dart';

void performGenerateContinuously(bool verbose) {
  if (verbose)
    print('Starting up continuous generator');

  // Start watching the protocol directory
  var watcherClasses = DirectoryWatcher('lib/src/protocol');
  watcherClasses.events.listen((WatchEvent event) {
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
  });

  var watcherEndpoints = DirectoryWatcher('lib/src/endpoints');
  watcherEndpoints.events.listen((WatchEvent event) {
    print('File changed: $event');
    switch(event.type) {
      case ChangeType.ADD:
      case ChangeType.MODIFY:
        if (event.path.endsWith('.dart'))
          performAnalysis(event.path);
        break;
      case ChangeType.REMOVE:
      // TODO: Remove
        break;
    }
  });
}