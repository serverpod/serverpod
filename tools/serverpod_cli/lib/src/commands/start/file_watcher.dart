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

  /// Whether any `pubspec.yaml` was modified in this batch (any watched
  /// pubspec, including the server's and each companion Flutter app's).
  /// Consumers use fingerprinting to decide what action, if any, is needed.
  final bool pubspecChanged;

  /// Whether non-dart, non-model files changed (e.g. HTML, JS, CSS).
  ///
  /// Used to trigger a browser refresh without recompilation.
  final bool staticFilesChanged;

  FileChangeEvent({
    required this.dartFiles,
    this.modelFiles = const {},
    this.packageConfigChanged = false,
    this.flutterDependenciesChanged = false,
    this.pubspecChanged = false,
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
    var pubspecChanged = false;
    var staticFilesChanged = false;

    for (final event in this) {
      dartFiles.addAll(event.dartFiles);
      modelFiles.addAll(event.modelFiles);
      packageConfigChanged |= event.packageConfigChanged;
      flutterDependenciesChanged |= event.flutterDependenciesChanged;
      pubspecChanged |= event.pubspecChanged;
      staticFilesChanged |= event.staticFilesChanged;
    }

    return FileChangeEvent(
      dartFiles: dartFiles,
      modelFiles: modelFiles,
      packageConfigChanged: packageConfigChanged,
      flutterDependenciesChanged: flutterDependenciesChanged,
      pubspecChanged: pubspecChanged,
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

  /// The exact `package_config.json` whose change sets `packageConfigChanged`
  /// (the server's resolution), or `null` if not tracked. Matched by full path
  /// rather than basename so that, in a non-workspace layout where the server
  /// and Flutter app have separate `.dart_tool` dirs, only the server's file
  /// drives a server reload.
  final String? _packageConfigPath;

  /// The exact `package_graph.json` files whose change sets
  /// `flutterDependenciesChanged` (one per Flutter app's resolution). Empty when
  /// no Flutter dependency closures are tracked. A workspace layout collapses to
  /// a single entry shared with the server's resolution.
  final Set<String> _packageGraphPaths;

  final Duration debounceDelay;

  /// Creates a file watcher.
  ///
  /// [watchPaths] is the set of directories or files to watch.
  /// [packageConfigPath] and [packageGraphPaths] are the exact pub-artifact
  /// files whose changes map to `packageConfigChanged` / `flutterDependenciesChanged`.
  FileWatcher({
    required Iterable<String> watchPaths,
    String? packageConfigPath,
    Iterable<String> packageGraphPaths = const [],
    this.debounceDelay = const Duration(milliseconds: 100),
  }) : _watchPaths = watchPaths.map(p.canonicalize).toSet(),
       _packageConfigPath = packageConfigPath == null
           ? null
           : p.canonicalize(packageConfigPath),
       _packageGraphPaths = packageGraphPaths.map(p.canonicalize).toSet();

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
          var pubspecChanged = false;
          var staticFilesChanged = false;

          for (final event in events) {
            final filePath = event.path;
            final canonical = p.canonicalize(filePath);
            // Two pub artifacts matter, each matched by its EXACT path (not
            // just basename):
            //
            // - package_config.json (the server's resolution): makes the
            //   server's Frontend Server reload its package map in place, no
            //   restart (KernelCompiler.invalidatePackageConfig).
            // - package_graph.json (each Flutter app's resolution): drives the
            //   Flutter dependency-closure check (hot reload vs restart vs
            //   relaunch).
            //
            // Exact-path matching means that in a non-workspace layout, where
            // the server and Flutter apps have separate .dart_tool dirs, the
            // *other* resolution's same-named file does not cross-trigger.
            // pub writes both back-to-back on `pub get`, but they are flagged
            // separately so a debounce window that splits them still triggers
            // each action - at worst as two reload steps instead of one.
            if (_packageConfigPath != null && canonical == _packageConfigPath) {
              packageConfigChanged = true;
            } else if (_packageGraphPaths.contains(canonical)) {
              flutterDependenciesChanged = true;
            } else if (_isWithinDartTool(filePath)) {
              // Any other .dart_tool churn (build artifacts, the output dill,
              // a sibling resolution's pub artifacts) is ignored.
            } else if (_isModelFile(filePath)) {
              modelFiles.add(filePath);
            } else if (p.extension(filePath) == '.dart') {
              dartFiles.add(filePath);
            } else if (p.basename(filePath) == 'pubspec.yaml') {
              pubspecChanged = true;
            } else {
              staticFilesChanged = true;
            }
          }

          return FileChangeEvent(
            dartFiles: dartFiles,
            modelFiles: modelFiles,
            packageConfigChanged: packageConfigChanged,
            flutterDependenciesChanged: flutterDependenciesChanged,
            pubspecChanged: pubspecChanged,
            staticFilesChanged: staticFilesChanged,
          );
        })
        .where(
          (e) =>
              e.dartFiles.isNotEmpty ||
              e.modelFiles.isNotEmpty ||
              e.packageConfigChanged ||
              e.flutterDependenciesChanged ||
              e.pubspecChanged ||
              e.staticFilesChanged,
        );
  }
}
