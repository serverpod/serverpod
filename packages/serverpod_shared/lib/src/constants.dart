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

  /// Directory where migration versions are stored.
  static Directory migrationVersionDirectory(
          Directory serverRootDirectory, String version) =>
      Directory(path.join(
        migrationsBaseDirectory(serverRootDirectory).path,
        version,
      ));

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
        migrationVersionDirectory(serverRootDirectory, version).path,
        'definition.sql',
      ));

  /// File path where the database definition is stored.
  static File databaseDefinitionJSONPath(
    Directory serverRootDirectory,
    String version,
  ) =>
      File(path.join(
        migrationVersionDirectory(serverRootDirectory, version).path,
        'definition.json',
      ));

  /// File path where the database definition is stored.
  static File databaseDefinitionProjectJSONPath(
    Directory serverRootDirectory,
    String version,
  ) =>
      File(path.join(
        migrationVersionDirectory(serverRootDirectory, version).path,
        'definition_project.json',
      ));

  /// File path where the database migration is stored.
  static File databaseMigrationSQLPath(
    Directory serverRootDirectory,
    String version,
  ) =>
      File(path.join(
        migrationVersionDirectory(serverRootDirectory, version).path,
        'migration.sql',
      ));

  /// File path where the database migration is stored.
  static File databaseMigrationJSONPath(
    Directory serverRootDirectory,
    String version,
  ) =>
      File(path.join(
        migrationVersionDirectory(serverRootDirectory, version).path,
        'migration.json',
      ));

  static Directory _migrationDirectory(Directory serverRootDirectory) =>
      Directory(path.join(serverRootDirectory.path, 'generated', 'migration'));
}

/// Serverpod URL constants used by the serverpod framework.
abstract class ServerpodUrlConstants {
  /// URL to the serverpod documentation.
  static const String serverpodDocumentation = 'https://docs.serverpod.dev';
}
