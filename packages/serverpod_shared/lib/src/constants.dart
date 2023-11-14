import 'dart:io';
import 'package:path/path.dart' as path;

/// Database constants used by the serverpod framework.
abstract class DatabaseConstants {
  /// Current version of the migration api.
  static const migrationApiVersion = 1;
}

/// Migration constants used by the serverpod framework.
abstract class MigrationConstants {
  /// Filename of the migration registry.
  static const migrationRegistryFileName = 'migration_registry.json';

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

  static Directory _migrationDirectory(Directory serverRootDirectory) =>
      Directory(path.join(serverRootDirectory.path, 'generated', 'migration'));
}
