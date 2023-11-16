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

  /// Directory where migrations are stored.
  static Directory migrationsBaseDirectory(Directory serverRootDirectory) =>
      Directory(path.join(
          serverRootDirectory.path, 'generated', 'migration', 'migrations'));
}
