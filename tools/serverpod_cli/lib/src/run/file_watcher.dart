import 'package:watcher/watcher.dart';
import 'package:path/path.dart' as p;

import '../config/config.dart';

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
    var watcherClasses = DirectoryWatcher(p.joinAll(config.libSourcePathParts));
    await for (WatchEvent event in watcherClasses.events) {
      if (event.path
          .startsWith(p.joinAll(config.generatedServerProtocolPathParts))) {
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
      (path.startsWith('${p.joinAll(config.protocolSourcePathParts)}/') ||
          path.startsWith('${p.joinAll(config.endpointsSourcePathParts)}/')) &&
      (path.endsWith('.dart') || path.endsWith('.yaml'));
}
