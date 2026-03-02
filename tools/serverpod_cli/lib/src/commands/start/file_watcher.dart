import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:async/async.dart';
import 'package:path/path.dart' as p;
import 'package:stream_transform/stream_transform.dart';
import 'package:watcher/watcher.dart';

/// Result of a file change batch from the watcher.
class FileChangeEvent {
  /// Changed (created/modified) .dart file paths.
  final Set<String> dartFiles;

  /// Removed .dart file paths.
  final Set<String> removedDartFiles;

  /// Changed model file paths (.spy.yaml, .spy, .spy.yml).
  final Set<String> modelFiles;

  /// Whether package_config.json was modified in this batch.
  final bool packageConfigChanged;

  /// Whether non-dart, non-model files changed (e.g. HTML, JS, CSS).
  ///
  /// Used to trigger a browser refresh without recompilation.
  final bool staticFilesChanged;

  FileChangeEvent({
    required this.dartFiles,
    this.removedDartFiles = const {},
    this.modelFiles = const {},
    this.packageConfigChanged = false,
    this.staticFilesChanged = false,
  });
}

/// Watches project directories for file changes on a background isolate.
///
/// The `watcher` package's `DirectoryWatcher` does a synchronous
/// `listSync()` on construction which blocks the calling thread.
/// Running it on a background isolate keeps the main thread free.
class FileWatcher {
  final List<String> _watchPaths;
  final String _ignorePath;
  final Duration debounceDelay;

  /// Creates a file watcher.
  ///
  /// [watchPaths] is the list of directories to watch.
  /// [ignorePath] is a path prefix to ignore (e.g. generated directory).
  FileWatcher({
    required List<String> watchPaths,
    required String ignorePath,
    this.debounceDelay = const Duration(milliseconds: 500),
  }) : _watchPaths = watchPaths,
       _ignorePath = ignorePath;

  /// Stream of file change events from a background isolate.
  Stream<FileChangeEvent> get onFilesChanged {
    final controller = StreamController<FileChangeEvent>();

    final receivePort = ReceivePort();
    Isolate? isolate;

    receivePort.listen((message) {
      if (message is Map) {
        controller.add(
          FileChangeEvent(
            dartFiles: Set<String>.from(message['dartFiles'] as List),
            removedDartFiles: Set<String>.from(
              message['removedDartFiles'] as List,
            ),
            modelFiles: Set<String>.from(message['modelFiles'] as List),
            packageConfigChanged: message['packageConfigChanged'] as bool,
            staticFilesChanged: message['staticFilesChanged'] as bool,
          ),
        );
      }
    });

    controller.onCancel = () {
      isolate?.kill(priority: Isolate.immediate);
      receivePort.close();
    };

    Isolate.spawn(
      _watcherIsolateEntry,
      _WatcherConfig(
        sendPort: receivePort.sendPort,
        watchPaths: _watchPaths,
        ignorePath: _ignorePath,
        debounceMicroseconds: debounceDelay.inMicroseconds,
      ),
    ).then((i) {
      isolate = i;
    });

    return controller.stream;
  }
}

const _modelExtensions = {'.spy.yaml', '.spy', '.spy.yml'};

bool _isModelFile(String filePath) {
  for (final ext in _modelExtensions) {
    if (filePath.endsWith(ext)) return true;
  }
  return false;
}

class _WatcherConfig {
  final SendPort sendPort;
  final List<String> watchPaths;
  final String ignorePath;
  final int debounceMicroseconds;

  _WatcherConfig({
    required this.sendPort,
    required this.watchPaths,
    required this.ignorePath,
    required this.debounceMicroseconds,
  });
}

/// Entry point for the background watcher isolate.
void _watcherIsolateEntry(_WatcherConfig config) {
  final debounceDelay = Duration(microseconds: config.debounceMicroseconds);

  final watchers = <DirectoryWatcher>[];
  for (final watchPath in config.watchPaths) {
    if (Directory(watchPath).existsSync()) {
      watchers.add(DirectoryWatcher(watchPath));
    }
  }

  if (watchers.isEmpty) return;

  final mergedStream = watchers.length == 1
      ? watchers.first.events
      : StreamGroup.merge(watchers.map((w) => w.events));

  mergedStream
      .where((e) => !e.path.contains(config.ignorePath))
      .debounceBuffer(debounceDelay)
      .map((events) {
        final dartFiles = <String>[];
        final removedDartFiles = <String>[];
        final modelFiles = <String>[];
        var packageConfigChanged = false;
        var staticFilesChanged = false;
        final seen = <String>{};

        for (final event in events) {
          final filePath = event.path;
          if (p.basename(filePath) == 'package_config.json') {
            packageConfigChanged = true;
          } else if (_isModelFile(filePath)) {
            modelFiles.add(filePath);
          } else if (p.extension(filePath) == '.dart') {
            if (event.type == ChangeType.REMOVE) {
              removedDartFiles.add(filePath);
            } else {
              dartFiles.add(filePath);
              seen.add(filePath);
            }
          } else {
            staticFilesChanged = true;
          }
        }

        return <String, Object>{
          'dartFiles': dartFiles,
          'removedDartFiles': removedDartFiles
              .where((f) => !seen.contains(f))
              .toList(),
          'modelFiles': modelFiles,
          'packageConfigChanged': packageConfigChanged,
          'staticFilesChanged': staticFilesChanged,
        };
      })
      .where((e) {
        final dartFiles = e['dartFiles']! as List<String>;
        final removedDartFiles = e['removedDartFiles']! as List<String>;
        final modelFiles = e['modelFiles']! as List<String>;
        final packageConfigChanged = e['packageConfigChanged']! as bool;
        final staticFilesChanged = e['staticFilesChanged']! as bool;
        return dartFiles.isNotEmpty ||
            removedDartFiles.isNotEmpty ||
            modelFiles.isNotEmpty ||
            packageConfigChanged ||
            staticFilesChanged;
      })
      .listen((event) {
        config.sendPort.send(event);
      });
}
