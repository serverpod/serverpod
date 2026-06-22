import 'dart:io';

import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:watcher/watcher.dart' as w;

/// Result of a file change batch from the watcher.
class FileChangeEvent {
  /// Changed (created/modified/removed) .dart file paths.
  final Set<String> dartFiles;

  /// Changed model file paths (.spy.yaml, .spy, .spy.yml).
  final Set<String> modelFiles;

  /// Whether package_config.json was modified in this batch.
  final bool packageConfigChanged;

  /// Whether the Flutter app's dependency graph (`package_graph.json`) was
  /// modified in this batch. Signals that the Flutter app may need a full
  /// relaunch to pick up new dependencies; the actual decision is made by
  /// comparing the dependency fingerprint (see `FlutterDependencyTracker`).
  final bool flutterDependenciesChanged;

  /// Whether the Flutter app's `pubspec.yaml` was modified in this batch.
  /// Assets and fonts declared in the `pubspec.yaml` are bundled at build
  /// time, so any change requires a full process relaunch.
  final bool flutterPubspecChanged;

  /// Whether non-dart, non-model files changed (e.g. HTML, JS, CSS).
  ///
  /// Used to trigger a browser refresh without recompilation.
  final bool staticFilesChanged;

  FileChangeEvent({
    required this.dartFiles,
    this.modelFiles = const {},
    this.packageConfigChanged = false,
    this.flutterDependenciesChanged = false,
    this.flutterPubspecChanged = false,
    this.staticFilesChanged = false,
  });
}

bool _isModelFile(String filePath) {
  return spyModelFileExtensions.any((ext) => filePath.endsWith(ext));
}

bool _isWithinDartTool(String filePath) {
  return p.split(filePath).contains('.dart_tool');
}

/// Merges multiple buffered [FileChangeEvent]s into a single event.
extension FileChangeEventMerge on List<FileChangeEvent> {
  /// Combines all events into one, unioning their file sets and flags.
  FileChangeEvent merge() {
    if (length == 1) return first;

    final dartFiles = <String>{};
    final modelFiles = <String>{};
    var packageConfigChanged = false;
    var flutterDependenciesChanged = false;
    var flutterPubspecChanged = false;
    var staticFilesChanged = false;

    for (final event in this) {
      dartFiles.addAll(event.dartFiles);
      modelFiles.addAll(event.modelFiles);
      packageConfigChanged |= event.packageConfigChanged;
      flutterDependenciesChanged |= event.flutterDependenciesChanged;
      flutterPubspecChanged |= event.flutterPubspecChanged;
      staticFilesChanged |= event.staticFilesChanged;
    }

    return FileChangeEvent(
      dartFiles: dartFiles,
      modelFiles: modelFiles,
      packageConfigChanged: packageConfigChanged,
      flutterDependenciesChanged: flutterDependenciesChanged,
      flutterPubspecChanged: flutterPubspecChanged,
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
  final Duration debounceDelay;

  /// Creates a file watcher.
  ///
  /// [watchPaths] is the set of directories to watch.
  FileWatcher({
    required Iterable<String> watchPaths,
    this.debounceDelay = const Duration(milliseconds: 100),
  }) : _watchPaths = watchPaths.map(p.canonicalize).toSet();

  late final List<w.Watcher> _watchers = [
    for (final watchPath in _watchPaths) ...{
      if (Directory(watchPath).existsSync())
        w.DirectoryWatcher(watchPath)
      else if (File(watchPath).existsSync())
        w.FileWatcher(watchPath),
    },
  ];

  /// An immutable view of the paths being watched.
  Set<String> get watchPaths => UnmodifiableSetView(_watchPaths);

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
        .debounceBuffer(debounceDelay)
        .map((events) {
          final dartFiles = <String>{};
          final modelFiles = <String>{};
          var packageConfigChanged = false;
          var flutterDependenciesChanged = false;
          var flutterPubspecChanged = false;
          var staticFilesChanged = false;

          for (final event in events) {
            final filePath = event.path;
            if (_isWithinDartTool(filePath)) {
              // Inside .dart_tool only the dependency graph is relevant;
              // everything else is ignored. Notably this keeps
              // packageConfigChanged (the FES restart path) dormant, exactly
              // as before .dart_tool was watched at all.
              if (p.basename(filePath) == 'package_graph.json') {
                flutterDependenciesChanged = true;
              }
            } else if (p.basename(filePath) == 'package_config.json') {
              packageConfigChanged = true;
            } else if (_isModelFile(filePath)) {
              modelFiles.add(filePath);
            } else if (p.extension(filePath) == '.dart') {
              dartFiles.add(filePath);
            } else if (p.basename(filePath) == 'pubspec.yaml') {
              flutterPubspecChanged = true;
            } else {
              staticFilesChanged = true;
            }
          }

          return FileChangeEvent(
            dartFiles: dartFiles,
            modelFiles: modelFiles,
            packageConfigChanged: packageConfigChanged,
            flutterDependenciesChanged: flutterDependenciesChanged,
            flutterPubspecChanged: flutterPubspecChanged,
            staticFilesChanged: staticFilesChanged,
          );
        })
        .where(
          (e) =>
              e.dartFiles.isNotEmpty ||
              e.modelFiles.isNotEmpty ||
              e.packageConfigChanged ||
              e.flutterDependenciesChanged ||
              e.flutterPubspecChanged ||
              e.staticFilesChanged,
        );
  }
}
