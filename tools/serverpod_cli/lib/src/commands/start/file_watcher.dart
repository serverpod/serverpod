import 'dart:io';

import 'package:async/async.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/model_helper.dart';
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

bool _isModelFile(String filePath) {
  return spyModelFileExtensions.any((ext) => filePath.endsWith(ext));
}

/// Merges multiple buffered [FileChangeEvent]s into a single event.
extension FileChangeEventMerge on List<FileChangeEvent> {
  /// Combines all events into one, unioning their file sets and flags.
  FileChangeEvent merge() {
    if (length == 1) return first;

    final dartFiles = <String>{};
    final modelFiles = <String>{};
    var packageConfigChanged = false;
    var staticFilesChanged = false;

    for (final event in this) {
      dartFiles.addAll(event.dartFiles);
      modelFiles.addAll(event.modelFiles);
      packageConfigChanged |= event.packageConfigChanged;
      staticFilesChanged |= event.staticFilesChanged;
    }

    return FileChangeEvent(
      dartFiles: dartFiles,
      modelFiles: modelFiles,
      packageConfigChanged: packageConfigChanged,
      staticFilesChanged: staticFilesChanged,
    );
  }
}

/// Watches project directories for file changes.
///
/// Debounces raw file system events into batched [FileChangeEvent]s,
/// categorized by file type.
class FileWatcher {
  final Set<String> _watchPaths;
  final Set<String> _ignorePaths;
  final Duration debounceDelay;

  /// Creates a file watcher.
  ///
  /// [watchPaths] is the set of directories to watch.
  /// [ignorePaths] is a set of path prefixes to ignore (e.g. generated
  /// directories). Defaults to empty.
  FileWatcher({
    required Iterable<String> watchPaths,
    Iterable<String> ignorePaths = const {},
    this.debounceDelay = const Duration(milliseconds: 500),
  }) : _watchPaths = watchPaths.map(p.canonicalize).toSet(),
       _ignorePaths = ignorePaths.map(p.canonicalize).toSet();

  late final List<DirectoryWatcher> _watchers = [
    for (final watchPath in _watchPaths)
      if (Directory(watchPath).existsSync()) DirectoryWatcher(watchPath),
  ];

  /// Completes when all underlying directory watchers are initialized.
  ///
  /// Subscribers must be listening to [onFilesChanged] before awaiting this,
  /// since watcher initialization only begins when the stream has subscribers.
  Future<void> get ready => Future.wait(_watchers.map((w) => w.ready));

  /// Stream of debounced, categorized file change events.
  late final Stream<FileChangeEvent> onFilesChanged = _buildStream();

  Stream<FileChangeEvent> _buildStream() {
    if (_watchers.isEmpty) return const Stream.empty();

    final mergedStream = _watchers.length == 1
        ? _watchers.first.events
        : StreamGroup.merge(_watchers.map((w) => w.events));

    return mergedStream
        .where((e) => !_ignorePaths.any((ip) => p.isWithin(ip, e.path)))
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
