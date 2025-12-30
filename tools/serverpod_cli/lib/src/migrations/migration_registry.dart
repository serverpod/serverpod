import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/migrations/migration_registry_file.dart';

/// The [MigrationRegistry] keeps track of which migrations have been created
/// for a module.
class MigrationRegistry {
  /// Filename of the migration registry.
  static const _migrationRegistryFileName = 'migration_registry.txt';

  /// List of migrations versions for the module.
  final List<String> _migrationVersions;

  /// The directory where modules migrations are stored.
  final Directory moduleMigrationDirectory;

  /// Creates a new registry with the provided [moduleMigrationDirectory] and
  /// [migrationVersions].
  MigrationRegistry(this.moduleMigrationDirectory, this._migrationVersions);

  /// Adds a migration to the registry.
  void add(String migrationName) {
    _migrationVersions.add(migrationName);
  }

  /// Returns the latest migration in the registry, or null if no migrations
  /// are registered.
  String? getLatest() {
    if (_migrationVersions.isEmpty) {
      return null;
    }
    return _migrationVersions.last;
  }

  /// Returns the list of migration versions in the registry.
  List<String> get versions => _migrationVersions;

  /// Returns a [MigrationRegistryFile] instance for managing the migration
  /// registry file in this module's migration directory.
  late MigrationRegistryFile migrationRegistryFile = MigrationRegistryFile(
    path.join(
      moduleMigrationDirectory.path,
      _migrationRegistryFileName,
    ),
  );

  /// Returns the File where migration versions are stored for this module.
  ///
  /// The file is located in [moduleMigrationDirectory].
  File get registryFile => migrationRegistryFile.file;

  /// Writes the registry to the migrations directory.
  Future<void> write() => migrationRegistryFile.update(_migrationVersions);

  /// Loads the migration versions from the migrations directory and
  /// creates a registry.
  /// Returns an empty registry if no migrations are found for the module.
  static MigrationRegistry load(Directory migrationsDirectory) {
    if (!migrationsDirectory.existsSync()) {
      return MigrationRegistry(
        migrationsDirectory,
        [],
      );
    }

    var migrationPaths = migrationsDirectory.listSync().whereType<Directory>();
    var migrationVersions = migrationPaths
        .map((d) => path.basename(d.path))
        .toList();
    migrationVersions.sort();

    return MigrationRegistry(migrationsDirectory, migrationVersions);
  }
}
