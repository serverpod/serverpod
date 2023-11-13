import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod/protocol.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Shared methods for migration versioning.
class MigrationVersions {
  /// Provides a list of all available migration versions of a module.

  /// Returns all migration versions available for the module.
  /// throws [MigrationRegistryLoadException] if the registry file is corrupt.
  static List<String> listVersions({
    Directory? directory,
    required String module,
  }) {
    directory ??= defaultMigrationsDirectory;
    var migrationRegistry = load(
      migrationsDirectory: directory,
      module: module,
    );

    return migrationRegistry?.migrations ?? [];
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

  /// Loads the registry from the migrations directory.
  /// Returns null registry if no migration registry is found.
  ///
  /// Throws [MigrationRegistryLoadException] if the registry file is corrupt.
  static DatabaseMigrationRegistry? load({
    required Directory migrationsDirectory,
    required String module,
  }) {
    var moduleDirectory = Directory(path.join(
      migrationsDirectory.path,
      module,
    ));
    var registryFile = File(path.join(
      moduleDirectory.path,
      MigrationConstants.migrationRegistryFileName,
    ));

    if (!registryFile.existsSync()) {
      return null;
    }

    var registryData = registryFile.readAsStringSync();

    try {
      var registry =
          Protocol().decodeWithType(registryData) as DatabaseMigrationRegistry;
      return registry;
    } catch (e) {
      throw MigrationRegistryLoadException(
        exception: e.toString(),
        directoryPath: moduleDirectory.path,
      );
    }
  }
}
