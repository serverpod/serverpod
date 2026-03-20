import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';

/// Extension to expose a [FileWatcher] from [GeneratorConfig].
extension GeneratorConfigFileWatcher on GeneratorConfig {
  /// A [FileWatcher] to watch changes in the non-generated files of the project.
  ///
  /// Includes server `lib/` and shared model package `lib/` directories.
  /// If [includeWeb] is true, also includes the `web/` directory (if it exists).
  /// If [includeClientPackage] is true, also includes the client package `lib/`
  /// directory so that generated client code changes are picked up (needed for
  /// compilation in `serverpod start --watch`).
  /// Returns the set of source directories that should be watched.
  Set<String> watchPaths({
    bool includeWeb = false,
    bool includeClientPackage = false,
  }) => _watchPathsFromConfig(
    this,
    includeWeb: includeWeb,
    includeClientPackage: includeClientPackage,
  );

  FileWatcher createFileWatcher({
    bool includeWeb = false,
    bool includeClientPackage = false,
  }) => FileWatcher(
    watchPaths: watchPaths(
      includeWeb: includeWeb,
      includeClientPackage: includeClientPackage,
    ),
    ignorePaths: {
      p.absolute(p.joinAll(generatedServeModelPathParts)),
      p.absolute(p.joinAll(generatedDartClientModelPathParts)),
      ...generatedSharedModelsPaths.map(p.absolute),
    },
  );
}

Set<String> _watchPathsFromConfig(
  GeneratorConfig config, {
  bool includeWeb = false,
  bool includeClientPackage = false,
}) {
  final paths = <String>{
    p.absolute(p.joinAll(config.libSourcePathParts)),
    ...config.sharedModelsLibSourcePaths.map(p.absolute),
  };

  if (includeClientPackage) {
    final clientLib = p.absolute(
      p.joinAll([...config.clientPackagePathParts, 'lib']),
    );
    if (Directory(clientLib).existsSync()) {
      paths.add(clientLib);
    }
  }

  if (includeWeb) {
    final webPath = p.absolute(
      p.joinAll([...config.serverPackageDirectoryPathParts, 'web']),
    );
    if (Directory(webPath).existsSync()) {
      paths.add(webPath);
    }
  }

  return paths;
}
