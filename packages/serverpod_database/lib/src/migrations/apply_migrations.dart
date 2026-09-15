import 'dart:io';

import 'package:serverpod_shared/log.dart';

import '../../serverpod_database.dart';

/// Applies pending and/or repair migrations and verifies database integrity.
///
/// Integrity is always verified, regardless of [applyMigrations] and
/// [applyRepairMigration]. Passing both flags as `false` performs a pure
/// verify with no migration application.
///
/// Throws if applying a migration fails (e.g. bad SQL, locking issues).
/// Integrity-check failures are logged and returned as
/// [MigrationsApplyResult.databaseMatchesTargetState] `false`; they do not
/// throw, so a completed apply is not rolled back by a later analyze error.
///
/// [onIntegrityCheck] is invoked with the live-vs-target comparison so
/// callers can gate DB-backed loops on missing framework tables.
Future<MigrationsApplyResult> applyMigrationsAndVerify({
  required DatabaseSession session,
  required Directory projectDirectory,
  required String runMode,
  required bool applyRepairMigration,
  required bool applyMigrations,
  void Function(DatabaseIntegrityCheck check)? onIntegrityCheck,
}) async {
  final manager = MigrationManager.fromDirectory(
    projectDirectory,
    runMode: runMode,
  );

  String? repairMigrationApplied;
  if (applyRepairMigration) {
    repairMigrationApplied = await manager.applyRepairMigration(session);
    if (repairMigrationApplied != null) {
      log.info(
        'Database repair migration "$repairMigrationApplied" applied.',
      );
    }
  }

  List<String>? migrationsApplied;
  if (applyMigrations) {
    migrationsApplied = await manager.migrateToLatest(session) ?? const [];
    if (migrationsApplied.isEmpty) {
      log.info('Latest database migration already applied.');
    } else {
      log.info(
        [
          'Applied database migration${migrationsApplied.length > 1 ? 's' : ''}:',
          ...migrationsApplied.map((m) => ' - $m'),
        ].join('\n'),
      );
    }
  }

  DatabaseIntegrityCheck integrity;
  try {
    integrity = await MigrationManager.verifyDatabaseIntegrity(session);
  } catch (e, stackTrace) {
    // Connection loss during analyze must not look like "every table is
    // missing" (that would skip future-call/health writes). It also must
    // not fail `--apply-migrations` after SQL has already been applied.
    try {
      log.error(
        'Failed to verify database integrity',
        error: e,
        stackTrace: stackTrace,
      );
    } catch (_) {}
    integrity = DatabaseIntegrityCheck(
      warnings: ['Failed to verify database integrity: $e'],
      missingTables: const {},
    );
  }
  onIntegrityCheck?.call(integrity);
  if (!integrity.matchesTarget) {
    log.warning('Database does not match target state.');
  }

  return MigrationsApplyResult(
    migrationsApplied: migrationsApplied,
    repairMigrationApplied: repairMigrationApplied,
    databaseMatchesTargetState: integrity.matchesTarget,
  );
}
