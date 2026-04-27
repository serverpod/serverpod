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
  /// Creates a new [PostgresDatabaseProvider].
  const PostgresDatabaseProvider();

  @override
  DatabaseDefinitionRestrictions get definitionRestrictions =>
      const DatabaseDefinitionRestrictions();

  @override
  PostgresPoolManager createPoolManager(
    SerializationManagerServer serializationManager,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
    PostgresDatabaseConfig config,
  ) {
    return PostgresPoolManager(
      serializationManager,
      runtimeParametersBuilder,
      config,
    );
  }

  @override
  PostgresDatabaseConnection createConnection(PostgresPoolManager poolManager) {
    return PostgresDatabaseConnection(poolManager);
  }

  @override
  PostgresDatabaseMigrationRunner createMigrationRunner({String? runMode}) {
    return PostgresDatabaseMigrationRunner(runMode: runMode);
  }

  @override
  PostgresDatabaseAnalyzer createAnalyzer(Database database) {
    return PostgresDatabaseAnalyzer(database: database);
  }
}
