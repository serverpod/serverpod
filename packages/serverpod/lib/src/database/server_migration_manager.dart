import 'dart:io';

import 'package:serverpod/src/generated/database_migration_version.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// The server migration manager handles migrations of the database.
class ServerMigrationManager extends MigrationManager {
  /// Creates a new server migration manager.
  ServerMigrationManager(Directory projectDirectory, {super.runMode})
    : super(
        FileSystemMigrationArtifactStore(projectDirectory: projectDirectory),
      );

  @override
  Future<List<DatabaseMigrationVersion>> loadInstalledVersions(
    DatabaseSession session, {
    Transaction? transaction,
  }) async {
    return await DatabaseMigrationVersion.db.find(
      session,
      transaction: transaction,
    );
  }

  @override
  Future<DatabaseMigrationVersion?> loadInstalledRepairMigration(
    DatabaseSession session, {
    Transaction? transaction,
  }) async {
    return await DatabaseMigrationVersion.db.findFirstRow(
      session,
      where: (t) =>
          t.module.equals(MigrationConstants.repairMigrationModuleName),
      transaction: transaction,
    );
  }

  /// Verifies the integrity of the database.
  ///
  /// Returns true if the database is intact, false otherwise.
  static Future<bool> verifyDatabaseIntegrity(DatabaseSession session) async {
    return await MigrationManager.verifyDatabaseIntegrity(session);
  }
}
