import 'dart:io';

import 'package:serverpod_database/serverpod_database.dart';

/// Server-side entrypoint for [MigrationManager]. Wraps the constructor
/// to take a [Directory] (the project root) instead of a
/// [MigrationArtifactStore], and re-exports
/// [MigrationManager.verifyDatabaseIntegrity] as a static for callers
/// that don't need a manager instance.
///
/// The CLI uses [MigrationManager] directly; this class exists so server
/// code keeps a familiar surface and doesn't have to know about the
/// artifact-store abstraction.
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
