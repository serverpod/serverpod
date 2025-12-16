import 'dart:io';
import 'package:path/path.dart' as path;

/// Database constants used by the serverpod framework.
abstract class DatabaseConstants {
  /// Current version of the migration api.
  static const migrationApiVersion = 1;

  /// The maximum length of a identifiers and key words in Postgres.
  /// Source: https://www.postgresql.org/docs/current/sql-syntax-lexical.html#SQL-SYNTAX-IDENTIFIERS
  static const pgsqlMaxNameLimitation = 63;
}

/// Migration constants used by the serverpod framework.
abstract class MigrationConstants {
  /// Module name in database under which repair migrations are stored.
  static const repairMigrationModuleName = '_repair';

  /// The default migrations directory name.
  static const defaultMigrationsDirectoryName = 'migrations';

  /// Directory where migration versions are stored.
  ///
  /// If [customMigrationsPath] is provided, it will be used instead of the
  /// default 'migrations' directory.
  static Directory migrationVersionDirectory(
    Directory serverRootDirectory,
    String version, {
    String? customMigrationsPath,
  }) => Directory(
    path.join(
      migrationsBaseDirectory(
        serverRootDirectory,
        customMigrationsPath: customMigrationsPath,
      ).path,
      version,
    ),
  );

  /// Directory where migrations are stored.
  ///
  /// If [customMigrationsPath] is provided, it will be used instead of the
  /// default 'migrations' directory. The path is resolved relative to the
  /// server root directory.
  static Directory migrationsBaseDirectory(
    Directory serverRootDirectory, {
    String? customMigrationsPath,
  }) {
    var migrationsPath = customMigrationsPath ?? defaultMigrationsDirectoryName;
    return Directory(path.join(serverRootDirectory.path, migrationsPath));
  }

  /// Directory where repair migrations are stored.
  static Directory repairMigrationDirectory(Directory serverRootDirectory) =>
      Directory(path.join(serverRootDirectory.path, 'repair-migration'));

  /// File path where the database definition is stored.
  static File databaseDefinitionSQLPath(
    Directory serverRootDirectory,
    String version, {
    String? customMigrationsPath,
  }) => File(
    path.join(
      migrationVersionDirectory(
        serverRootDirectory,
        version,
        customMigrationsPath: customMigrationsPath,
      ).path,
      'definition.sql',
    ),
  );

  /// File path where the database definition is stored.
  static File databaseDefinitionJSONPath(
    Directory serverRootDirectory,
    String version, {
    String? customMigrationsPath,
  }) => File(
    path.join(
      migrationVersionDirectory(
        serverRootDirectory,
        version,
        customMigrationsPath: customMigrationsPath,
      ).path,
      'definition.json',
    ),
  );

  /// File path where the database definition is stored.
  static File databaseDefinitionProjectJSONPath(
    Directory serverRootDirectory,
    String version, {
    String? customMigrationsPath,
  }) => File(
    path.join(
      migrationVersionDirectory(
        serverRootDirectory,
        version,
        customMigrationsPath: customMigrationsPath,
      ).path,
      'definition_project.json',
    ),
  );

  /// File path where the database migration is stored.
  static File databaseMigrationSQLPath(
    Directory serverRootDirectory,
    String version, {
    String? customMigrationsPath,
  }) => File(
    path.join(
      migrationVersionDirectory(
        serverRootDirectory,
        version,
        customMigrationsPath: customMigrationsPath,
      ).path,
      'migration.sql',
    ),
  );

  /// File path where the database migration is stored.
  static File databaseMigrationJSONPath(
    Directory serverRootDirectory,
    String version, {
    String? customMigrationsPath,
  }) => File(
    path.join(
      migrationVersionDirectory(
        serverRootDirectory,
        version,
        customMigrationsPath: customMigrationsPath,
      ).path,
      'migration.json',
    ),
  );
}

/// Serverpod URL constants used by the serverpod framework.
abstract class ServerpodUrlConstants {
  /// URL to the serverpod documentation.
  static const String serverpodDocumentation = 'https://docs.serverpod.dev';
}

/// Constants representing the keys used to access command line arguments from
/// the map returned by [CommandLineArgs.toMap()].
abstract class CliArgsConstants {
  /// Key for the run mode (development, staging, production, test).
  static const runMode = 'runMode';

  /// Key for the server role (monolith, serverless, maintenance).
  static const role = 'role';

  /// Key for the logging mode (normal, verbose).
  static const loggingMode = 'loggingMode';

  /// Key for the server ID.
  static const serverId = 'serverId';

  /// Key for whether to apply database migrations.
  static const applyMigrations = 'applyMigrations';

  /// Key for whether to apply database repair migration.
  static const applyRepairMigration = 'applyRepairMigration';
}
