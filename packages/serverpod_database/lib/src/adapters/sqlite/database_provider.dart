import 'dart:io';

import 'package:serverpod_shared/log.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../../serverpod_database.dart';
import 'database_connection.dart';
import 'sqlite_analyzer.dart';
import 'sqlite_migration_runner.dart';
import 'sqlite_pool_manager.dart';

/// Provides a [DatabaseProvider] for the Sqlite database.
class SqliteDatabaseProvider implements DatabaseProvider {
  /// Creates a new [SqliteDatabaseProvider].
  const SqliteDatabaseProvider();

  @override
  DatabaseDefinitionRestrictions get definitionRestrictions =>
      const DatabaseDefinitionRestrictions(
        supportedIndexTypes: ['btree'],
      );

  @override
  SqlitePoolManager createPoolManager(
    DatabaseSerializationManager serializationManager,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
    SqliteDatabaseConfig config, {
    Directory? serverDirectory,
  }) {
    if (runtimeParametersBuilder != null) {
      log.warning(
        'Runtime parameters are not supported on SQLite and will be ignored.',
      );
    }
    return SqlitePoolManager(
      serializationManager,
      config,
      serverDirectory: serverDirectory,
    );
  }

  @override
  SqliteDatabaseConnection createConnection(SqlitePoolManager poolManager) {
    return SqliteDatabaseConnection(poolManager);
  }

  @override
  SqliteDatabaseMigrationRunner createMigrationRunner({String? runMode}) {
    return SqliteDatabaseMigrationRunner(runMode: runMode);
  }

  @override
  SqliteDatabaseAnalyzer createAnalyzer(Database database) {
    return SqliteDatabaseAnalyzer(database: database);
  }
}
