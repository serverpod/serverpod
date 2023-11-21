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
    required String module,
  }) {
    directory ??= defaultMigrationsDirectory;

    var moduleDirectory = Directory(path.join(
      directory.path,
      module,
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

  /// Provides a list of modules with migrations available.
  static List<String> listAvailableModules({
    Directory? directory,
  }) {
    directory ??= defaultMigrationsDirectory;
    try {
      var moduleDirectories = directory.listSync().whereType<Directory>();
      var modules =
          moduleDirectories.map((d) => path.basename(d.path)).toList();
      modules.sort();
      return modules;
    } catch (e) {
      return [];
    }
  }

  /// Gets the default migrations directory.
  static Directory get defaultMigrationsDirectory =>
      MigrationConstants.migrationsBaseDirectory(Directory.current);
}
