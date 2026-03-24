import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';

/// Extension to expose watch-related path helpers from [GeneratorConfig].
extension GeneratorConfigFileWatcher on GeneratorConfig {
  /// Returns the set of source directories that should be watched.
  ///
  /// Includes server `lib/` and shared model package `lib/` directories.
  /// If [includeWeb] is true, also includes the `web/` directory (if it exists).
  /// If [includeClientPackage] is true, also includes the client package `lib/`
  /// directory.
  Set<String> watchPaths({
    bool includeWeb = false,
    bool includeClientPackage = false,
  }) => _watchPathsFromConfig(
    this,
    includeWeb: includeWeb,
    includeClientPackage: includeClientPackage,
  );

  /// Absolute paths of directories containing generated code.
  ///
  /// Used by [WatchSession] to distinguish generated files from source files
  /// so that generated file changes trigger compilation but not re-generation.
  Set<String> get generatedDirPaths => {
    p.absolute(p.joinAll(generatedServeModelPathParts)),
    p.absolute(p.joinAll(generatedDartClientModelPathParts)),
    ...generatedSharedModelsPaths.map(p.absolute),
  };
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
