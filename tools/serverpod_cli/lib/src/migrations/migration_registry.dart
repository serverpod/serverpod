import 'dart:io';

import 'package:path/path.dart' as path;

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

  /// Writes the registry to the migrations directory.
  Future<void> write() async {
    var registryFile = File(path.join(
      moduleMigrationDirectory.path,
      _migrationRegistryFileName,
    ));

    var out = '''
### This file is automatically generated by the serverpod framework.
### Do not modify this file manually. 
###
### This file contains a list of all migrations that have been created for
### the module.
### 
### If a collision is detected in this file. Resolve the conflict by
### removing and re-creating the conflicting migration.

''';
    for (var version in _migrationVersions) {
      out += '- $version\n';
    }

    await registryFile.writeAsString(out);
  }

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
    var migrationVersions =
        migrationPaths.map((d) => path.basename(d.path)).toList();
    migrationVersions.sort();

    return MigrationRegistry(migrationsDirectory, migrationVersions);
  }
}
