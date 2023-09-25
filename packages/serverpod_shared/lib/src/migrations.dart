import 'dart:io';

import 'package:path/path.dart' as path;

/// Shared methods for migration versioning.
class MigrationVersions {
  /// Provides a list of all available migration versions of a module.
  static List<String> listVersions({
    Directory? directory,
    required String module,
  }) {
    directory ??= defaultMigrationsDirectory;
    try {
      var versionDir = Directory(path.join(directory.path, module));

      var versions = <String>[];
      var entities = versionDir.listSync();
      for (var entity in entities) {
        if (entity is Directory) {
          versions.add(path.basename(entity.path));
        }
      }
      versions.sort();
      return versions;
    } catch (e) {
      return [];
    }
  }

  /// Provides a list of modules with migrations available.
  static List<String> listAvailableModules({
    Directory? directory,
  }) {
    directory ??= defaultMigrationsDirectory;
    try {
      var modules = <String>[];
      var entities = directory.listSync();
      for (var entity in entities) {
        if (entity is Directory) {
          modules.add(path.basename(entity.path));
        }
      }
      modules.sort();
      return modules;
    } catch (e) {
      return [];
    }
  }

  /// Gets the default migrations directory.
  static Directory get defaultMigrationsDirectory =>
      Directory(path.join(Directory.current.path, 'migrations'));
}
