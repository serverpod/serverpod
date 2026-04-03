import 'package:serverpod_shared/serverpod_shared.dart';

import '../concepts/runtime_parameters.dart';
import '../database.dart';
import 'analyzer.dart';
import 'database_connection.dart';
import 'database_pool_manager.dart';
import 'definition_restrictions.dart';
import 'migration_runner.dart';
import 'provider/io.dart' if (dart.library.html) 'provider/web.dart';
import 'serialization_manager.dart';

/// Abstract interface for database providers.
/// Provides a unified interface for any database dialect implementation.
abstract interface class DatabaseProvider {
  /// Creates a new [DatabaseProvider] for the given [dialect].
  factory DatabaseProvider.forDialect(DatabaseDialect dialect) =>
      createDatabaseProviderForDialect(dialect);

  /// Creates a new [DatabaseDefinitionRestrictions] for the current dialect.
  DatabaseDefinitionRestrictions get definitionRestrictions;

  /// Creates a new [DatabasePoolManager] for the given parameters.
  DatabasePoolManager createPoolManager(
    DatabaseSerializationManager serializationManager,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
    covariant DatabaseConfig config,
  );

  /// Creates a new [DatabaseConnection] for the given [poolManager].
  DatabaseConnection createConnection(
    covariant DatabasePoolManager poolManager,
  );

  /// Creates a new [MigrationRunner].
  MigrationRunner createMigrationRunner({String? runMode});

  /// Creates a new [DatabaseAnalyzer] for the given [database].
  DatabaseAnalyzer createAnalyzer(Database database);
}
