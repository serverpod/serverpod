import 'package:serverpod_shared/serverpod_shared.dart';

import '../../interface/serialization_manager.dart';
import '../../concepts/runtime_parameters.dart';
import '../../database.dart';
import '../../interface/provider.dart';
import '../../interface/database_pool_manager.dart';
import 'postgres_pool_manager.dart';
import 'database_connection.dart';
import 'postgres_analyzer.dart';

/// Provides a [DatabaseProvider] for the Postgres database.
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
  PostgresDatabaseAnalyzer createAnalyzer(Database database) {
    return PostgresDatabaseAnalyzer(database: database);
  }
}
