import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';

/// Watch-related path helpers for [GeneratorConfig].
extension GeneratorConfigFileWatcher on GeneratorConfig {
  /// Absolute paths of directories containing generated code.
  ///
  /// Used by [WatchSession] to distinguish generated files from source files
  /// so that generated file changes trigger compilation but not re-generation,
  /// and by the endpoint and future call analyzers to keep generated output
  /// out of the files they scan for declarations.
  Set<String> get generatedDirPaths => {
    p.absolute(p.joinAll(generatedServeModelPathParts)),
    p.absolute(p.joinAll(generatedDartClientModelPathParts)),
    ...generatedSharedModelsPaths.map(p.absolute),
  };
}

