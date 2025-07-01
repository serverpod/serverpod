import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:serverpod_shared/serverpod_shared.dart';

/// [RepairMigration] is used to repair a database back to a migration version.
class RepairMigration {
  /// The version of the repair migration.
  final String versionName;

  /// The SQL to run to repair the database.
  final String sqlMigration;

  RepairMigration._({
    required this.versionName,
    required this.sqlMigration,
  });

  /// Loads the repair migration from the repair migration directory.
  /// Returns null if no repair migration is found.
  static RepairMigration? load(Directory projectRootDirectory) {
    var repairMigrationDirectory =
        MigrationConstants.repairMigrationDirectory(projectRootDirectory);

    if (!repairMigrationDirectory.existsSync()) {
      return null;
    }

    var repairMigrationFiles =
        repairMigrationDirectory.listSync().whereType<File>();
    if (repairMigrationFiles.isEmpty) {
      return null;
    }

    var migrationSqlFile = repairMigrationFiles.cast<File?>().firstWhere(
          (element) => element != null
              ? path.basename(element.path).endsWith('.sql')
              : false,
          orElse: () => null,
        );

    if (migrationSqlFile == null) {
      return null;
    }

    var version = path.basename(migrationSqlFile.path).split('.').first;
    var sqlMigration = migrationSqlFile.readAsStringSync();

    return RepairMigration._(
      versionName: version,
      sqlMigration: sqlMigration,
    );
  }
}
