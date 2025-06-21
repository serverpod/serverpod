import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:serverpod/src/database/concepts/runtime_parameters.dart';
import 'package:serverpod/src/serialization/serialization_manager.dart';

import 'adapters/postgres/pgvector_encoder.dart';
import 'adapters/postgres/value_encoder.dart';

/// Configuration for connecting to the Postgresql database.
@internal
class DatabasePoolManager {
  /// Database configuration.
  final DatabaseConfig config;

  late SerializationManager _serializationManager;

  /// Access to the serialization manager.
  SerializationManager get serializationManager => _serializationManager;

  pg.Pool? _pgPool;

  final pg.PoolSettings _poolSettings;

  /// Postgresql connection pool created from configuration.
  ///
  /// Throws a [StateError] if the pool has not been started.
  pg.Pool get pool {
    var pgPool = _pgPool;
    if (pgPool == null) {
      throw StateError('Database pool not started.');
    }

    return pgPool;
  }

  /// The encoder used to encode objects for storing in the database.
  static final ValueEncoder encoder = ValueEncoder();

  /// Creates a new [DatabasePoolManager]. Typically, this is done automatically
  /// when starting the [Server].
  DatabasePoolManager(
    SerializationManagerServer serializationManager,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
    this.config,
  ) : _poolSettings = pg.PoolSettings(
          maxConnectionCount: 10,
          queryTimeout: const Duration(minutes: 1),
          sslMode: config.requireSsl ? pg.SslMode.require : pg.SslMode.disable,
          typeRegistry: pg.TypeRegistry(encoders: [pgvectorEncoder]),
          onOpen: (connection) async {
            var parameters =
                runtimeParametersBuilder?.call(RuntimeParametersBuilder()) ??
                    [];

            if (!parameters.any((p) => p is SearchPathsConfig) &&
                config.searchPaths != null &&
                config.searchPaths!.isNotEmpty) {
              parameters.add(
                SearchPathsConfig(searchPaths: config.searchPaths),
              );
            }

            var setParametersStatements = parameters
                .map((p) => p.buildStatements(isLocal: false))
                .expand((e) => e);
            if (setParametersStatements.isNotEmpty) {
              for (var statement in setParametersStatements) {
                await connection.execute(statement);
              }
            }
          },
        ) {
    _serializationManager = serializationManager;
  }

  /// Starts the database connection pool.
  void start() {
    // Setup database connection pool
    _pgPool ??= pg.Pool.withEndpoints(
      [
        pg.Endpoint(
          host: config.host,
          port: config.port,
          database: config.name,
          username: config.user,
          password: config.password,
          isUnixSocket: config.isUnixSocket,
        )
      ],
      settings: _poolSettings,
    );
  }

  /// Closes the database connection pool.
  Future<void> stop() async {
    await _pgPool?.close();
    _pgPool = null;
  }
}
