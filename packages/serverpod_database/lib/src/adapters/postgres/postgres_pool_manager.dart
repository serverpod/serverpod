import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../concepts/runtime_parameters.dart';
import '../../interface/database_pool_manager.dart';
import '../../interface/serialization_manager.dart';
import 'embedded_postgres_resolver.dart';
import 'pgvector_encoder.dart';
import 'value_encoder.dart';

/// Configuration for connecting to the Postgresql database.
@internal
class PostgresPoolManager implements DatabasePoolManager {
  @override
  DatabaseDialect get dialect => DatabaseDialect.postgres;

  @override
  DateTime? lastDatabaseOperationTime;

  /// Database configuration.
  final PostgresDatabaseConfig config;

  /// Base dir relative `dataPath` values resolve against. Defaults to cwd.
  final Directory? _serverDirectory;

  late DatabaseSerializationManager _serializationManager;

  @override
  DatabaseSerializationManager get serializationManager =>
      _serializationManager;

  pg.Pool? _pgPool;

  final pg.PoolSettings _poolSettings;

  /// Stops the embedded PostgreSQL this manager launched, or `null` when none
  /// was launched (no `dataPath`, or it attached to a postmaster another
  /// supervisor owns). Retained so [stop] can shut it down.
  Future<void> Function()? _stopEmbeddedPostgres;

  Future<void>? _startedFuture;
  bool _databaseStopped = false;

  /// Postgresql connection pool created from configuration.
  ///
  /// If the database has not been started yet, this will start it and then
  /// return the database instance. Throws a [StateError] if the database is
  /// not started (e.g. after [stop] has been called).
  Future<pg.Pool> get pool async {
    await started;
    var pgPool = _pgPool;
    if (pgPool == null) {
      throw StateError('Database pool not started.');
    }
    return pgPool;
  }

  @override
  PostgresValueEncoder get encoder => const PostgresValueEncoder();

  /// Creates a new [PostgresPoolManager]. Typically, this is done automatically
  /// when starting the [Server].
  PostgresPoolManager(
    DatabaseSerializationManager serializationManager,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
    this.config, {
    Directory? serverDirectory,
  }) : _serverDirectory = serverDirectory,
       _poolSettings = pg.PoolSettings(
         maxConnectionCount: config.maxConnectionCount,
         queryTimeout: const Duration(minutes: 1),
         sslMode: config.requireSsl ? pg.SslMode.require : pg.SslMode.disable,
         typeRegistry: pg.TypeRegistry(encoders: [pgvectorEncoder]),
         onOpen: (connection) async {
           var parameters =
               runtimeParametersBuilder?.call(RuntimeParametersBuilder()) ?? [];

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

  @override
  void start() {
    _databaseStopped = false;
    _startedFuture ??= _bootstrap();
  }

  Future<void> _bootstrap() async {
    if (_databaseStopped) {
      throw StateError('Database stopped. Call `start()` again to restart.');
    }

    Future<void> Function()? stopLaunched;
    try {
      final resolved = await startOrAttachEmbeddedPostgres(
        config,
        baseDirectory: _serverDirectory ?? Directory.current,
      );
      stopLaunched = resolved?.stop;

      // stop() may have run while we were spawning the postmaster. Drop the
      // freshly-launched handle rather than leak the supervised process.
      if (_databaseStopped) {
        throw StateError('Database stopped during start.');
      }

      final effectiveConfig = resolved?.connectivity ?? config;
      _pgPool = pg.Pool.withEndpoints(
        [
          pg.Endpoint(
            host: effectiveConfig.host,
            port: effectiveConfig.port,
            database: effectiveConfig.name,
            username: effectiveConfig.user,
            password: effectiveConfig.password,
            isUnixSocket: effectiveConfig.isUnixSocket,
          ),
        ],
        settings: _poolSettings,
      );
      _stopEmbeddedPostgres = stopLaunched;
      stopLaunched = null;
    } catch (e, st) {
      await stopLaunched?.call();
      await _stopEmbeddedPostgres?.call();
      _stopEmbeddedPostgres = null;
      _startedFuture = null;
      Error.throwWithStackTrace(e, st);
    }
  }

  @override
  Future<void> get started => _startedFuture ??= _bootstrap();

  @override
  Future<void> stop() async {
    _databaseStopped = true;
    final pgPool = _pgPool;
    final stopEmbeddedPostgres = _stopEmbeddedPostgres;

    _pgPool = null;
    _stopEmbeddedPostgres = null;
    _startedFuture = null;

    await pgPool?.close();
    await stopEmbeddedPostgres?.call();
  }

  @override
  Future<bool> testConnection() async {
    final connection = await pool;
    await connection.execute(
      'SELECT 1;',
      timeout: const Duration(seconds: 2),
    );
    return true;
  }
}
