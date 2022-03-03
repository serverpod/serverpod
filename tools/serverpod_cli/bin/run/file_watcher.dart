import 'package:watcher/watcher.dart';

import '../generator/config.dart';

class SourceFileWatcher {
  final Future<void> Function(String path, bool isProtocol) onChangedSourceFile;
  final Future<void> Function(String path) onRemovedProtocolFile;

  SourceFileWatcher({
    required this.onChangedSourceFile,
    required this.onRemovedProtocolFile,
  });

  Future<void> watch(bool verbose) async {
    var watcherClasses = DirectoryWatcher(config.libSourcePath);
    await for (WatchEvent event in watcherClasses.events) {
      print('File changed: $event');
      switch (event.type) {
        case ChangeType.ADD:
        case ChangeType.MODIFY:
          print('ADD/MODIFY path: ${event.path}');
          await onChangedSourceFile(event.path, _isPathInProtocol(event.path));
          break;
        case ChangeType.REMOVE:
          await onRemovedProtocolFile(event.path);
          break;
      }
    }
  }

  bool _isPathInProtocol(String path) =>
      (path.startsWith(config.protocolSourcePath + '/') ||
          path.startsWith(config.endpointsSourcePath + '/')) &&
      (path.endsWith('.dart') || path.endsWith('.yaml'));
}
