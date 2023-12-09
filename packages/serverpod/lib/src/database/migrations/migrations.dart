import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_shared/serverpod_shared.dart';

/// Shared methods for migration versioning.
class MigrationVersions {
  /// Provides a list of all available migration versions of a module.
  /// Returns an empty list if no migrations are available or if the module
  /// directory does not exist.
  static List<String> listVersions({
    Directory? directory,
  }) {
    directory ??= defaultMigrationsDirectory;

    var moduleDirectory = Directory(path.join(
      directory.path,
    ));

    if (!moduleDirectory.existsSync()) {
      return [];
    }

    var migrationPaths = moduleDirectory.listSync().whereType<Directory>();
    var migrationVersions =
        migrationPaths.map((d) => path.basename(d.path)).toList();
    migrationVersions.sort();

    return migrationVersions;
  }

  /// Gets the default migrations directory.
  static Directory get defaultMigrationsDirectory =>
      MigrationConstants.migrationsBaseDirectory(Directory.current);
}
