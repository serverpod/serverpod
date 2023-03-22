import 'package:watcher/watcher.dart';

import '../generator/config.dart';

class SourceFileWatcher {
  final Future<void> Function(String path, bool isProtocol) onChangedSourceFile;
  final Future<void> Function(String path) onRemovedProtocolFile;
  final GeneratorConfig config;

  SourceFileWatcher({
    required this.onChangedSourceFile,
    required this.onRemovedProtocolFile,
    required this.config,
  });

  Future<void> watch(bool verbose) async {
    var watcherClasses = DirectoryWatcher(config.relativeLibSourcePath);
    await for (WatchEvent event in watcherClasses.events) {
      if (event.path.startsWith(config.relativeGeneratedServerProtocolPath)) {
        continue;
      }
      switch (event.type) {
        case ChangeType.ADD:
        case ChangeType.MODIFY:
          await onChangedSourceFile(event.path, _isPathInProtocol(event.path));
          break;
        case ChangeType.REMOVE:
          await onRemovedProtocolFile(event.path);
          break;
      }
    }
  }

  bool _isPathInProtocol(String path) =>
      (path.startsWith('${config.relativeProtocolSourcePath}/') ||
          path.startsWith('${config.relativeEndpointsSourcePath}/')) &&
      (path.endsWith('.dart') || path.endsWith('.yaml'));
}
