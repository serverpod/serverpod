import 'dart:io';

import 'package:serverpod_database/serverpod_database.dart';

import '../generated/protocol.dart';

/// Applies pending and/or repair migrations and verifies database integrity.
///
/// Shared by [Serverpod]'s boot-time `--apply-migrations` path and the
/// `InsightsEndpoint.applyMigrations` endpoint. Both paths perform the same
/// operations; they only differ in how they react to the result (boot may
/// exit on failure in development mode; the endpoint returns the result
/// over the wire).
///
/// Throws if applying a migration fails (e.g. bad SQL, locking issues).
/// Verification failure is reported via
/// [MigrationsApplyResult.databaseMatchesTargetState] rather than thrown —
/// callers decide policy.
Future<MigrationsApplyResult> applyMigrationsAndVerify({
  required DatabaseSession session,
  required Directory projectDirectory,
  required String runMode,
  required bool applyRepairMigration,
  required bool applyMigrations,
}) async {
  final manager = MigrationManager.fromDirectory(
    projectDirectory,
    runMode: runMode,
  );

  String? repairMigrationApplied;
  if (applyRepairMigration) {
    repairMigrationApplied = await manager.applyRepairMigration(session);
  }

  List<String>? migrationsApplied;
  if (applyMigrations) {
    migrationsApplied = await manager.migrateToLatest(session);
  }

  final databaseMatchesTargetState =
      await MigrationManager.verifyDatabaseIntegrity(session);

  return MigrationsApplyResult(
    migrationsApplied: migrationsApplied,
    repairMigrationApplied: repairMigrationApplied,
    databaseMatchesTargetState: databaseMatchesTargetState,
  );
}
