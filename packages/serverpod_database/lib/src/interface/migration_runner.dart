import 'package:meta/meta.dart';

import '../../serverpod_database.dart';

@internal
abstract class MigrationRunner {
  /// Creates a new migration runner.
  const MigrationRunner({this.runMode});

  /// The run mode of the server.
  ///
  /// This is used to determine if additional database integrity checks should
  /// be run, since they can be expensive and not matter in production.
  ///
  /// If the run mode is not set, the migration runner will not run any
  /// additional database integrity checks.
  final String? runMode;

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
