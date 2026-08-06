/// Exception thrown when loading a migration version fails.
class MigrationVersionLoadException implements Exception {
  /// The name of the version that failed to load.
  final String versionName;

  /// The name of the module that failed to load.
  final String moduleName;

  /// The exception that was thrown.
  final String exception;

  /// Creates a new [MigrationVersionLoadException].
  MigrationVersionLoadException({
    required this.versionName,
    required this.moduleName,
    required this.exception,
  });

  @override
  String toString() =>
      'Unable to determine latest database definition due to a corrupted '
      'migration. Please re-create or remove the migration version and try '
      'again. Migration version: "$versionName" for module "$moduleName".\n'
      '$exception';
}

/// Exception thrown when trying to load the live database definition.
class MigrationLiveDatabaseDefinitionException implements Exception {
  /// The exception that was thrown.
  final String exception;

  /// Creates a new [MigrationLiveDatabaseDefinitionException].
  MigrationLiveDatabaseDefinitionException({
    required this.exception,
  });

  @override
  String toString() =>
      'Unable to fetch live database schema from server. Make sure the '
      'server is running and is connected to the database.\n$exception';
}

/// Exception thrown when writing a migration fails.
class MigrationRepairWriteException implements Exception {
  /// The exception that was thrown.
  final String exception;

  /// Creates a new [MigrationRepairWriteException].
  MigrationRepairWriteException({
    required this.exception,
  });

  @override
  String toString() => 'Unable to write repair migration.\n$exception';
}

/// Exception thrown when a migration target is not found.
class MigrationRepairTargetNotFoundException implements Exception {
  /// The versions that were found.
  final List<String> versionsFound;

  /// The name of the target that was not found.
  final String? targetName;

  /// Creates a new [MigrationRepairTargetNotFoundException].
  MigrationRepairTargetNotFoundException({
    required this.versionsFound,
    required this.targetName,
  });

  @override
  String toString() => versionsFound.isEmpty
      ? 'Unable to find any migration versions.'
      : 'Unable to find the specified target migration "$targetName". '
            'Available versions: $versionsFound.';
}

/// Exception thrown when the migration failed to create a database definition
/// from the projects model files.
class GenerateMigrationDatabaseDefinitionException implements Exception {
  @override
  String toString() => 'Unable to generate database definition for project.';
}

/// Exception thrown when the migration directory already exists.
class MigrationVersionAlreadyExistsException implements Exception {
  /// The path to the directory that already exists.
  final String directoryPath;

  /// Creates a new [MigrationVersionAlreadyExistsException].
  MigrationVersionAlreadyExistsException({
    required this.directoryPath,
  });

  @override
  String toString() =>
      'Unable to create migration. A directory with the same name already '
      'exists: "$directoryPath".';
}

/// Exception thrown when a migration is aborted.
class MigrationAbortedException implements Exception {
  /// Creates a new [MigrationAbortedException].
  const MigrationAbortedException();

  @override
  String toString() => 'Migration aborted due to warnings.';
}
