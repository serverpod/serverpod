import 'package:meta/meta.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../serverpod_database.dart';

/// A representation of a migration version for running migrations.
@immutable
class MigrationVersionSql {
  /// Creates a new migration version SQL.
  const MigrationVersionSql({
    required this.version,
    required this.moduleName,
    required this.definitionSql,
    required this.migrationSql,
  });

  /// The migration version string (e.g. `20231205080937028` or with tag).
  final String version;

  /// The module that owns this migration.
  final String moduleName;

  /// The full database definition SQL for this version.
  final String definitionSql;

  /// The incremental migration SQL that leads to this version.
  final String migrationSql;
}

/// A representation migration version definitions. Used to compare
/// and generate migrations.
class MigrationVersionDefinition {
  /// Creates a new migration version artifacts.
  const MigrationVersionDefinition({
    required this.version,
    required this.definition,
    required this.projectDefinition,
    required this.migration,
  });

  /// The version name of the migration.
  final String version;

  /// The full database definition for this version.
  final DatabaseDefinition definition;

  /// The project-only database definition for this version.
  final DatabaseDefinition projectDefinition;

  /// The migration definition for this version.
  final DatabaseMigration migration;

  /// The module name associated with the migration.
  String get moduleName => definition.moduleName;
}

/// A representation of a migration version and its artifacts for persistence.
/// Contains both the definition and the migration SQL.
class MigrationVersionArtifacts extends MigrationVersionDefinition
    implements MigrationVersionSql {
  /// Creates a new migration version artifacts.
  const MigrationVersionArtifacts({
    required super.version,
    required this.definitionSql,
    required this.migrationSql,
    required super.definition,
    required super.projectDefinition,
    required super.migration,
  });

  @override
  final String definitionSql;

  @override
  final String migrationSql;
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

/// Base class for a migration artifacts storage.
abstract interface class BaseMigrationArtifactStore {
  /// Lists all available migration versions in ascending order.
  Future<List<String>> listVersions();
}

/// Loads migration SQL for running migrations.
abstract interface class MigrationArtifactStoreReader
    implements BaseMigrationArtifactStore {
  /// Reads the stored migration SQL for running migrations.
  ///
  /// Does not include the project definition. Returns `null` if the version
  /// cannot be found.
  Future<MigrationVersionSql?> readVersionSql(String version);

  /// Reads the currently available repair migration, if any.
  Future<RepairMigration?> readRepairMigration();

  /// Loads the module name from the definition of the given migration version.
  ///
  /// Returns `null` if the version cannot be found.
  Future<String?> loadDefinitionModuleName(String version);
}

/// Persists migration artifacts from a storage implementation.
abstract interface class MigrationArtifactStoreWriter
    implements BaseMigrationArtifactStore {
  /// Reads the stored definition for a migration version.
  ///
  /// Does not include the migration SQL. Returns `null` if the version cannot
  /// be found.
  Future<MigrationVersionDefinition?> readVersionDefinition(String version);

  /// Persists all provided artifacts for a migration version.
  ///
  /// Throws [MigrationVersionAlreadyExistsException] if the version already
  /// exists.
  Future<void> writeVersion(MigrationVersionArtifacts artifacts);

  /// Writes the ordered list of migration versions.
  Future<void> writeVersionRegistry(List<String> versions);

  /// Persists the provided repair migration, replacing any existing one.
  ///
  /// Throws [MigrationRepairWriteException] if the repair migration cannot be
  /// written.
  Future<void> writeRepairMigration(RepairMigration repairMigration);
}
