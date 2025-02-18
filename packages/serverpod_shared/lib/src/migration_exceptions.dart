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
}

/// Exception thrown when trying to load the live database definition.
class MigrationLiveDatabaseDefinitionException implements Exception {
  /// The exception that was thrown.
  final String exception;

  /// Creates a new [MigrationLiveDatabaseDefinitionException].
  MigrationLiveDatabaseDefinitionException({
    required this.exception,
  });
}

/// Exception thrown when writing a migration fails.
class MigrationRepairWriteException implements Exception {
  /// The exception that was thrown.
  final String exception;

  /// Creates a new [MigrationRepairWriteException].
  MigrationRepairWriteException({
    required this.exception,
  });
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
}

/// Exception thrown when the migration failed to create a database definition
/// from the projects model files.
class GenerateMigrationDatabaseDefinitionException implements Exception {}

/// Exception thrown when the migration directory already exists.
class MigrationVersionAlreadyExistsException implements Exception {
  /// The path to the directory that already exists.
  final String directoryPath;

  /// Creates a new [MigrationVersionAlreadyExistsException].
  MigrationVersionAlreadyExistsException({
    required this.directoryPath,
  });
}
