import 'package:meta/meta.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../adapters/postgres/database_provider.dart';
import '../database.dart';
import '../concepts/runtime_parameters.dart';
import 'analyzer.dart';
import 'database_connection.dart';
import 'database_pool_manager.dart';
import 'migration_runner.dart';
import 'serialization_manager.dart';

/// Abstract interface for database providers.
/// Provides a unified interface for any database dialect implementation.
@internal
abstract interface class DatabaseProvider {
  /// Creates a new [DatabaseProvider] for the given [dialect].
  factory DatabaseProvider.forDialect(DatabaseDialect dialect) =>
      switch (dialect) {
        DatabaseDialect.postgres => PostgresDatabaseProvider(),
      };

  /// Creates a new [DatabasePoolManager] for the given parameters.
  DatabasePoolManager createPoolManager(
    SerializationManagerServer serializationManager,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
    DatabaseConfig config,
  );

  /// Creates a new [DatabaseConnection] for the given [poolManager].
  DatabaseConnection createConnection(DatabasePoolManager poolManager);

  /// Creates a new [MigrationRunner].
  MigrationRunner createMigrationRunner();

  /// Creates a new [DatabaseAnalyzer] for the given [database].
  DatabaseAnalyzer createAnalyzer(Database database);
}
