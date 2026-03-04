import 'dart:io';

import 'package:async/async.dart';
import 'package:path/path.dart' as p;
import 'package:stream_transform/stream_transform.dart';
import 'package:watcher/watcher.dart';

/// Result of a file change batch from the watcher.
class FileChangeEvent {
  /// Changed (created/modified/removed) .dart file paths.
  final Set<String> dartFiles;

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
    this.modelFiles = const {},
    this.packageConfigChanged = false,
    this.staticFilesChanged = false,
  });
}

const _modelExtensions = {'.spy.yaml', '.spy', '.spy.yml'};

bool _isModelFile(String filePath) {
  for (final ext in _modelExtensions) {
    if (filePath.endsWith(ext)) return true;
  }
  return false;
}

/// Watches project directories for file changes.
///
/// Debounces raw file system events into batched [FileChangeEvent]s,
/// categorized by file type.
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

  /// Stream of debounced, categorized file change events.
  Stream<FileChangeEvent> get onFilesChanged {
    final watchers = <DirectoryWatcher>[];
    for (final watchPath in _watchPaths) {
      if (Directory(watchPath).existsSync()) {
        watchers.add(DirectoryWatcher(watchPath));
      }
    }

    if (watchers.isEmpty) return const Stream.empty();

    final mergedStream = watchers.length == 1
        ? watchers.first.events
        : StreamGroup.merge(watchers.map((w) => w.events));

    return mergedStream
        .where((e) => !e.path.contains(_ignorePath))
        .debounceBuffer(debounceDelay)
        .map((events) {
          final dartFiles = <String>{};
          final modelFiles = <String>{};
          var packageConfigChanged = false;
          var staticFilesChanged = false;

          for (final event in events) {
            final filePath = event.path;
            if (p.basename(filePath) == 'package_config.json') {
              packageConfigChanged = true;
            } else if (_isModelFile(filePath)) {
              modelFiles.add(filePath);
            } else if (p.extension(filePath) == '.dart') {
              dartFiles.add(filePath);
            } else {
              staticFilesChanged = true;
            }
          }

          return FileChangeEvent(
            dartFiles: dartFiles,
            modelFiles: modelFiles,
            packageConfigChanged: packageConfigChanged,
            staticFilesChanged: staticFilesChanged,
          );
        })
        .where(
          (e) =>
              e.dartFiles.isNotEmpty ||
              e.modelFiles.isNotEmpty ||
              e.packageConfigChanged ||
              e.staticFilesChanged,
        );
  }
}
