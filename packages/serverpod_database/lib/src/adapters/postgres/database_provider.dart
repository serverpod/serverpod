import 'package:meta/meta.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../../serverpod_database.dart';
import 'database_connection.dart';
import 'postgres_analyzer.dart';
import 'postgres_migration_runner.dart';
import 'postgres_pool_manager.dart';

/// Provides a [DatabaseProvider] for the Postgres database.
@internal
class PostgresDatabaseProvider implements DatabaseProvider {
  @override
  PostgresPoolManager createPoolManager(
    SerializationManagerServer serializationManager,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
    DatabaseConfig config,
  ) {
    return PostgresPoolManager(
      serializationManager,
      runtimeParametersBuilder,
      config,
    );
  }

  @override
  PostgresDatabaseConnection createConnection(DatabasePoolManager poolManager) {
    if (poolManager is! PostgresPoolManager) {
      throw ArgumentError('Pool manager must be a "PostgresPoolManager".');
    }
    return PostgresDatabaseConnection(poolManager);
  }

  @override
  PostgresDatabaseMigrationRunner createMigrationRunner() {
    return const PostgresDatabaseMigrationRunner();
  }

  @override
  PostgresDatabaseAnalyzer createAnalyzer(Database database) {
    return PostgresDatabaseAnalyzer(database: database);
  }
}
