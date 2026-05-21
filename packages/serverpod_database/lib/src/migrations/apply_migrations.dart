import 'dart:io';

import '../../serverpod_database.dart';
import 'package:serverpod_shared/log.dart';

import '../generated/protocol.dart';

/// Applies pending and/or repair migrations and verifies database integrity.
///
/// Integrity is always verified, regardless of [applyMigrations] and
/// [applyRepairMigration]. Passing both flags as `false` performs a pure
/// verify with no migration application.
///
/// Throws if applying a migration fails (e.g. bad SQL, locking issues).
/// The [MigrationsApplyResult.databaseMatchesTargetState] indicates whether
/// verification was successful and the database matches the target state.
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
    if (repairMigrationApplied == null) {
      log.error('Failed to apply database repair migration.');
    } else {
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
        'Applied database migration${migrationsApplied.length > 1 ? 's' : ''}:',
      );
      for (final migration in migrationsApplied) {
        log.info(' - $migration');
      }
    }
  }

  final databaseMatchesTargetState =
      await MigrationManager.verifyDatabaseIntegrity(session);
  if (!databaseMatchesTargetState) {
    log.warning('Database does not match target state.');
  }

  return MigrationsApplyResult(
    migrationsApplied: migrationsApplied,
    repairMigrationApplied: repairMigrationApplied,
    databaseMatchesTargetState: databaseMatchesTargetState,
  );
}
