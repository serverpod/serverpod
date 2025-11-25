import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_shared/serverpod_shared.dart';

/// Shared methods for migration versioning.
class MigrationVersions {
  /// Provides a list of all available migration versions of a module.
  /// Returns an empty list if no migrations are available or if the module
  /// directory does not exist.
  ///
  /// If [customMigrationsPath] is provided, it will be used instead of the
  /// default 'migrations' directory.
  static List<String> listVersions({
    required Directory projectDirectory,
    String? customMigrationsPath,
  }) {
    var directory = MigrationConstants.migrationsBaseDirectory(
      projectDirectory,
      customMigrationsPath: customMigrationsPath,
    );

    var moduleDirectory = Directory(
      path.join(
        directory.path,
      ),
    );

    if (!moduleDirectory.existsSync()) {
      return [];
    }

    var migrationPaths = moduleDirectory.listSync().whereType<Directory>();
    var migrationVersions = migrationPaths
        .map((d) => path.basename(d.path))
        .toList();
    migrationVersions.sort();

    return migrationVersions;
  }
}
