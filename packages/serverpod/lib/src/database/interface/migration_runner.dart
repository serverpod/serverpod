import 'package:meta/meta.dart';
import 'package:serverpod/database.dart';

@internal
abstract interface class MigrationRunner {
  /// Runs a migration action.
  ///
  /// This method is used by the migration manager to run migrations. Database
  /// implementation might add custom pre/post operations around the migration.
  /// If a [Transaction] is provided to the [action], all steps of the migration
  /// will run within such transaction. If no transaction is provided, the
  /// [action] will run each step independently.
  Future<void> runMigrations(
    DatabaseSession session,
    Future<void> Function(Transaction? transaction) action,
  );
}
