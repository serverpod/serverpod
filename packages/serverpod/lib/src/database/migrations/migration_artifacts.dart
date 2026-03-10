import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// A semantic representation of a migration version and its persisted artifacts.
class MigrationVersionArtifacts {
  /// Creates a new migration version artifacts.
  const MigrationVersionArtifacts({
    required this.version,
    required this.definitionSql,
    required this.migrationSql,
    required this.definition,
    required this.projectDefinition,
    required this.migration,
  });

  /// The version name of the migration.
  final String version;

  /// The full database definition SQL for this version.
  final String definitionSql;

  /// The incremental migration SQL that leads to this version.
  final String migrationSql;

  /// The full database definition for this version.
  final DatabaseDefinition definition;

  /// The project-only database definition for this version.
  final DatabaseDefinition projectDefinition;

  /// The migration definition for this version.
  final DatabaseMigration migration;

  /// The module name associated with the migration.
  String get moduleName => definition.moduleName;
}

/// A migration used to repair the database back to a specific migration version.
class RepairMigration {
  /// The version of the repair migration.
  final String version;

  /// The SQL to run to repair the database.
  final String migrationSql;

  /// Creates a new repair migration.
  const RepairMigration({
    required this.version,
    required this.migrationSql,
  });
}

/// Persists and loads migration artifacts from a storage implementation.
abstract interface class MigrationArtifactStore {
  /// Lists all available migration versions in ascending order.
  Future<List<String>> listVersions();

  /// Reads the stored artifacts for a migration version.
  ///
  /// Returns `null` if the version cannot be found.
  Future<MigrationVersionArtifacts?> readVersion(String version);

  /// Persists all provided artifacts for a migration version.
  ///
  /// Throws [MigrationVersionAlreadyExistsException] if the version already
  /// exists.
  Future<void> writeVersion(MigrationVersionArtifacts artifacts);

  /// Writes the ordered list of migration versions.
  Future<void> writeVersionRegistry(List<String> versions);

  /// Reads the currently available repair migration, if any.
  Future<RepairMigration?> readRepairMigration();

  /// Persists the provided repair migration, replacing any existing one.
  ///
  /// Throws [MigrationRepairWriteException] if the repair migration cannot be
  /// written.
  Future<void> writeRepairMigration(RepairMigration repairMigration);
}
