import 'dart:io';

import 'package:serverpod_database/serverpod_database.dart';

/// The server migration manager handles migrations of the database.
///
/// Thin wrapper over [MigrationManager] kept for source compatibility:
/// historically this class overrode `loadInstalledVersions` and
/// `loadInstalledRepairMigration` to query the `serverpod_migrations`
/// table via the generated `DatabaseMigrationVersion` model. Those
/// queries now live in [MigrationManager] itself as raw SQL, so the
/// CLI can drive migrations without depending on the server runtime.
class ServerMigrationManager extends MigrationManager {
  /// Creates a new server migration manager.
  ServerMigrationManager(
    Directory projectDirectory, {
    super.runMode,
  }) : super(
         FileSystemMigrationArtifactStore(projectDirectory: projectDirectory),
       );

  /// Verifies the integrity of the database.
  ///
  /// Returns true if the database is intact, false otherwise.
  static Future<bool> verifyDatabaseIntegrity(DatabaseSession session) async {
    return await MigrationManager.verifyDatabaseIntegrity(session);
  }
}
