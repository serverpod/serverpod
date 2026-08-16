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
        await action(transaction);
        if (runMode == 'development') {
          await _verifyForeignKeyIntegrity(session, transaction);
        }
      });
    } finally {
      await session.db.unsafeExecute('PRAGMA foreign_keys=ON');
    }
  }
}

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
  throw SqliteForeignKeyViolationException(violations);
}
