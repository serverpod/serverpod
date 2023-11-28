import 'dart:io';
import 'package:path/path.dart' as path;

/// Database constants used by the serverpod framework.
abstract class DatabaseConstants {
  /// Current version of the migration api.
  static const migrationApiVersion = 1;
}

/// Migration constants used by the serverpod framework.
abstract class MigrationConstants {
  /// Module name in database under which repair migrations are stored.
  static const repairMigrationModuleName = '_repair';

  /// Directory where migrations are stored.
  static Directory migrationsBaseDirectory(Directory serverRootDirectory) =>
      Directory(path.join(
          _migrationDirectory(serverRootDirectory).path, 'migrations'));

  /// Directory where repair migrations are stored.
  static Directory repairMigrationDirectory(Directory serverRootDirectory) =>
      Directory(
          path.join(_migrationDirectory(serverRootDirectory).path, 'repair'));

  /// File path where the database definition is stored.
  static File databaseDefinitionSQLPath(
    Directory serverRootDirectory,
    String version,
  ) =>
      File(path.join(
        migrationsBaseDirectory(serverRootDirectory).path,
        version,
        'definition.sql',
      ));

  /// File path where the database definition is stored.
  static File databaseDefinitionJSONPath(
    Directory serverRootDirectory,
    String version,
  ) =>
      File(path.join(
        migrationsBaseDirectory(serverRootDirectory).path,
        version,
        'definition.json',
      ));

  /// File path where the database migration is stored.
  static File databaseMigrationSQLPath(
    Directory serverRootDirectory,
    String version,
  ) =>
      File(path.join(
        migrationsBaseDirectory(serverRootDirectory).path,
        version,
        'migration.sql',
      ));

  /// File path where the database migration is stored.
  static File databaseMigrationJSONPath(
    Directory serverRootDirectory,
    String version,
  ) =>
      File(path.join(
        migrationsBaseDirectory(serverRootDirectory).path,
        version,
        'migration.json',
      ));

  static Directory _migrationDirectory(Directory serverRootDirectory) =>
      Directory(path.join(serverRootDirectory.path, 'generated', 'migration'));
}
