/// Exception thrown when loading the migration registry fails.
class MigrationRegistryLoadException implements Exception {
  /// The path to the directory where the migration registry was expected to be.
  final String directoryPath;

  /// The exception that was thrown.
  final String exception;

  /// Creates a new [MigrationRegistryLoadException].
  MigrationRegistryLoadException({
    required this.directoryPath,
    required this.exception,
  });
}

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
