/// Failures loading migration versions or SQL artifacts from disk.
///
/// These are operational: the operator can fix project files or the
/// registered version. They are not bugs in the migrator.
sealed class MigrationLoadException implements Exception {
  /// Human-readable description of the failure.
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when a project has no migration versions on disk.
final class NoMigrationsFoundException extends MigrationLoadException {
  /// Creates a [NoMigrationsFoundException].
  NoMigrationsFoundException();

  @override
  String get message => 'No migrations found in project.';
}

/// Thrown when the database has a migration version registered that is
/// not present in the project's migration files.
final class MigrationVersionNotFoundException extends MigrationLoadException {
  /// Creates a [MigrationVersionNotFoundException] for [registeredVersion].
  MigrationVersionNotFoundException(this.registeredVersion);

  /// Version recorded in `serverpod_migrations` but missing from disk.
  final String registeredVersion;

  @override
  String get message =>
      'DB has migration version $registeredVersion registered but it is not found in the project files.';
}

/// Thrown when a migration version's definition SQL cannot be loaded.
final class MigrationDefinitionNotFoundException
    extends MigrationLoadException {
  /// Creates a [MigrationDefinitionNotFoundException] for [version].
  MigrationDefinitionNotFoundException(this.version);

  /// Migration version whose definition SQL is missing.
  final String version;

  @override
  String get message =>
      'Definition for migration version $version could not be loaded.';
}

/// Thrown when a migration version's migration SQL cannot be loaded.
final class MigrationSqlNotFoundException extends MigrationLoadException {
  /// Creates a [MigrationSqlNotFoundException] for [version].
  MigrationSqlNotFoundException(this.version);

  /// Migration version whose migration SQL is missing.
  final String version;

  @override
  String get message => 'Migration for version $version could not be loaded.';
}

/// Thrown when a required migration artifact file is missing.
final class MigrationArtifactMissingException extends MigrationLoadException {
  /// Creates a [MigrationArtifactMissingException] for [path].
  MigrationArtifactMissingException(this.path);

  /// Path of the missing artifact.
  final String path;

  @override
  String get message => 'Required migration artifact is missing: $path';
}
