import 'package:meta/meta.dart';
import 'package:serverpod/database.dart';

import '../../interface/migration_runner.dart';

@internal
class PostgresDatabaseMigrationRunner implements MigrationRunner {
  const PostgresDatabaseMigrationRunner();

  /// Migrations on Postgres use a transaction to ensure that the advisory lock
  /// is retained until the transaction is completed.
  ///
  /// The transaction ensures that the session used for acquiring the lock is
  /// kept alive in the underlying connection pool, and that we can later use
  /// that exact same session for releasing the lock. The transaction is thus
  /// only used to get the desired behavior from the database driver, and does
  /// not have any effect on the Postgres level.
  ///
  /// This ensures that we are only running migrations one at a time.
  @override
  Future<void> runMigrations(
    DatabaseSession session,
    Future<void> Function(Transaction? transaction) action,
  ) async {
    const String lockName = 'serverpod_migration_lock';

    await session.db.transaction((transaction) async {
      await session.db.unsafeExecute(
        "SELECT pg_advisory_lock(hashtext('$lockName'));",
        transaction: transaction,
      );

      try {
        await action(null);
      } finally {
        await session.db.unsafeExecute(
          "SELECT pg_advisory_unlock(hashtext('$lockName'));",
          transaction: transaction,
        );
      }
    });
  }
}
