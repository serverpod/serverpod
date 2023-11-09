import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// The [MigrationRegistry] keeps track of which migrations have been run on
/// the database.
///
/// The registry is stored in the migrations directory as a JSON file.
class MigrationRegistry {
  /// The name of the registry file.
  static const _fileNameRegistryJson = 'migration_registry.json';

  /// The registry.
  DatabaseMigrationRegistry registry;

  /// The directory where the registry is stored.
  final Directory migrationsDirectory;

  /// Creates a new registry with the provided [migrationsDirectory] and
  /// [registry].
  MigrationRegistry(this.migrationsDirectory, this.registry);

  /// Adds a migration to the registry.
  void add(String migrationName) {
    registry.migrations.add(migrationName);
  }

  /// Removes the last migration from the registry.
  ///
  /// Returns the name of the removed migration, or null if no migrations
  /// are registered.
  String? removeLast() {
    if (registry.migrations.isEmpty) {
      return null;
    }

    return registry.migrations.removeLast();
  }

  /// Returns the latest migration in the registry, or null if no migrations
  /// are registered.
  String? getLatest() {
    if (registry.migrations.isEmpty) {
      return null;
    }
    return registry.migrations.last;
  }

  /// Returns the number of migrations in the registry.
  int get length => registry.migrations.length;

  /// Writes the registry to the migrations directory.
  Future<void> write() async {
    var registryFile = File(path.join(
      migrationsDirectory.path,
      _fileNameRegistryJson,
    ));

    var registryData = Protocol().encodeWithType(registry);
    await registryFile.writeAsString(registryData);
  }

  /// Loads the registry from the migrations directory.
  /// Returns an empty registry if no migration registry is found.
  ///
  /// Throws [MigrationRegistryLoadException] if the registry file is corrupt.
  static Future<MigrationRegistry> load(Directory migrationsDirectory) async {
    var registryFile = File(path.join(
      migrationsDirectory.path,
      _fileNameRegistryJson,
    ));

    if (!registryFile.existsSync()) {
      return MigrationRegistry(
        migrationsDirectory,
        DatabaseMigrationRegistry(migrations: []),
      );
    }

    var registryData = await registryFile.readAsString();

    try {
      var registry =
          Protocol().decodeWithType(registryData) as DatabaseMigrationRegistry;
      return MigrationRegistry(migrationsDirectory, registry);
    } catch (e) {
      throw MigrationRegistryLoadException(
        exception: e.toString(),
        directoryPath: migrationsDirectory.path,
      );
    }
  }
}
