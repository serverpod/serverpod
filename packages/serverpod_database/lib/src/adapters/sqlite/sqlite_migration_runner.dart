import 'package:meta/meta.dart';

import '../../../serverpod_database.dart';
import '../../interface/migration_runner.dart';

@internal
class SqliteDatabaseMigrationRunner extends MigrationRunner {
  const SqliteDatabaseMigrationRunner({required super.runMode});

  /// On SQLite, we can use the transaction directly to ensure that the
  /// database is locked during the migration. However, the transaction must
  /// be passed to the action to ensure we don't create a recursive locks.
  @override
  Future<void> runMigrations(
    DatabaseSession session,
    Future<void> Function(Transaction? transaction) action,
  ) async {
    await session.db.unsafeExecute('PRAGMA foreign_keys=OFF');
    try {
      await session.db.transaction((transaction) async {
        final schemaBefore = await _schemaVersion(session, transaction);
        await action(transaction);
        if (runMode == 'development') {
          await _verifyForeignKeyIntegrity(session, transaction);
        }
        if (await _schemaVersion(session, transaction) != schemaBefore) {
          // Publish statistics with the schema change, before readers reload
          // the new schema. A no-op migration does not need maintenance.
          await session.db.unsafeExecute(
            'PRAGMA optimize',
            transaction: transaction,
          );
        }
      });
    } finally {
      await session.db.unsafeExecute('PRAGMA foreign_keys=ON');
    }
  }
}

Future<Object?> _schemaVersion(
  DatabaseSession session,
  Transaction transaction,
) async => (await session.db.unsafeQuery(
  'PRAGMA schema_version',
  transaction: transaction,
)).single.toColumnMap()['schema_version'];

Future<void> _verifyForeignKeyIntegrity(
  DatabaseSession session,
  Transaction transaction,
) async {
  final result = await session.db.unsafeQuery(
    'PRAGMA foreign_key_check;',
    transaction: transaction,
  );
  if (result.isEmpty) return;

  final violations = result.map((row) => row.toColumnMap()).toList();
  throw SqliteMigrationForeignKeyViolationException(violations);
}
