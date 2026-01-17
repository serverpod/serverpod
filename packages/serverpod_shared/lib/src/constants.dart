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

  /// Directory where migration versions are stored.
  static Directory migrationVersionDirectory(
    Directory serverRootDirectory,
    String version,
  ) => Directory(
    path.join(
      migrationsBaseDirectory(serverRootDirectory).path,
      version,
    ),
  );

  /// Directory where migrations are stored.
  static Directory migrationsBaseDirectory(Directory serverRootDirectory) =>
      Directory(path.join(serverRootDirectory.path, 'migrations'));

  /// Directory where repair migrations are stored.
  static Directory repairMigrationDirectory(Directory serverRootDirectory) =>
      Directory(path.join(serverRootDirectory.path, 'repair-migration'));

  /// File path where the database definition is stored.
  static File databaseDefinitionSQLPath(
    Directory serverRootDirectory,
    String version,
  ) => File(
    path.join(
      migrationVersionDirectory(serverRootDirectory, version).path,
      'definition.sql',
    ),
  );

  /// File path where the database definition is stored.
  static File databaseDefinitionJSONPath(
    Directory serverRootDirectory,
    String version,
  ) => File(
    path.join(
      migrationVersionDirectory(serverRootDirectory, version).path,
      'definition.json',
    ),
  );

  /// File path where the database definition is stored.
  static File databaseDefinitionProjectJSONPath(
    Directory serverRootDirectory,
    String version,
  ) => File(
    path.join(
      migrationVersionDirectory(serverRootDirectory, version).path,
      'definition_project.json',
    ),
  );

  /// File path where the database migration is stored.
  static File databaseMigrationSQLPath(
    Directory serverRootDirectory,
    String version,
  ) => File(
    path.join(
      migrationVersionDirectory(serverRootDirectory, version).path,
      'migration.sql',
    ),
  );

  /// File path where the database migration is stored.
  static File databaseMigrationJSONPath(
    Directory serverRootDirectory,
    String version,
  ) => File(
    path.join(
      migrationVersionDirectory(serverRootDirectory, version).path,
      'migration.json',
    ),
  );

  /// File path where pre-database setup SQL is stored.
  /// This SQL is executed before definition.sql when creating a database from scratch.
  static File preDatabaseSetupSQLPath(
    Directory serverRootDirectory,
    String version,
  ) => File(
    path.join(
      migrationVersionDirectory(serverRootDirectory, version).path,
      'pre_database_setup.sql',
    ),
  );

  /// File path where post-database setup SQL is stored.
  /// This SQL is executed after definition.sql when creating a database from scratch.
  static File postDatabaseSetupSQLPath(
    Directory serverRootDirectory,
    String version,
  ) => File(
    path.join(
      migrationVersionDirectory(serverRootDirectory, version).path,
      'post_database_setup.sql',
    ),
  );

  /// File path where pre-migration SQL is stored.
  /// This SQL is executed before migration.sql when rolling forward.
  static File preMigrationSQLPath(
    Directory serverRootDirectory,
    String version,
  ) => File(
    path.join(
      migrationVersionDirectory(serverRootDirectory, version).path,
      'pre_migration.sql',
    ),
  );

  /// File path where post-migration SQL is stored.
  /// This SQL is executed after migration.sql when rolling forward.
  static File postMigrationSQLPath(
    Directory serverRootDirectory,
    String version,
  ) => File(
    path.join(
      migrationVersionDirectory(serverRootDirectory, version).path,
      'post_migration.sql',
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
