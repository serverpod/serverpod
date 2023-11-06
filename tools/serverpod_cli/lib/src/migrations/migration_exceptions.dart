/// Exception thrown when loading a migration version fails.
class MigrationVersionLoadException implements Exception {
  final String versionName;
  final String moduleName;
  final String exception;

  MigrationVersionLoadException({
    required this.versionName,
    required this.moduleName,
    required this.exception,
  });
}
