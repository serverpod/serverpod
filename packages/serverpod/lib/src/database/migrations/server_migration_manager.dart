import 'dart:io';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/src/database/concepts/transaction.dart';
import 'package:serverpod/src/database/interface/database_session.dart';
import 'package:serverpod/src/database/migrations/migration_artifacts_store/file_system.dart';
import 'package:serverpod/src/database/migrations/migration_manager.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// The server migration manager handles migrations of the database.
class ServerMigrationManager extends MigrationManager {
  /// Creates a new server migration manager.
  ServerMigrationManager(Directory projectDirectory)
    : super(
        FileSystemMigrationArtifactStore(projectDirectory: projectDirectory),
        writeWarning: stderr.writeln,
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
    return await MigrationManager.verifyDatabaseIntegrity(
      session,
      writeWarning: stderr.writeln,
    );
  }
}
