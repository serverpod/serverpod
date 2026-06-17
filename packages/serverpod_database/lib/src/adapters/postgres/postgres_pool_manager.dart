import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../concepts/runtime_parameters.dart';
import '../../interface/database_pool_manager.dart';
import '../../interface/serialization_manager.dart';
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

  /// Only retained when [EmbeddedPostgres.start] supervised this cluster in
  /// this process. Omitted for `attach()` so [stop] does not shut another
  /// supervisor's postmaster.
  EmbeddedPostgres? _embeddedPostgres;

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

    EmbeddedPostgres? launched;
    try {
      final (embeddedPostgres, embeddedConfig) =
          await _launchEmbeddedPostgresIfNeeded();
      launched = embeddedPostgres;

      // stop() may have run while we were spawning the postmaster. Drop the
      // freshly-launched handle rather than leak the supervised process.
      if (_databaseStopped) {
        throw StateError('Database stopped during start.');
      }

      final effectiveConfig = embeddedConfig ?? config;
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
      _embeddedPostgres = launched;
      launched = null;
    } catch (e, st) {
      await launched?.stop();
      await _embeddedPostgres?.stop();
      _embeddedPostgres = null;
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
    final embeddedPostgres = _embeddedPostgres;

    _pgPool = null;
    _embeddedPostgres = null;
    _startedFuture = null;

    await pgPool?.close();
    await embeddedPostgres?.stop();
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

  /// Launches an embedded PostgreSQL server if [config.dataPath] is set.
  ///
  /// If a running postmaster is found, attaches to it as a client-only handle
  /// and returns only the [PostgresDatabaseConfig] for the attached server.
  ///
  /// If no running postmaster is found, starts a new embedded server in the
  /// [PostgresDatabaseConfig.dataPath] directory and returns both the started
  /// [EmbeddedPostgres] instance and the [PostgresDatabaseConfig] for it.
  Future<(EmbeddedPostgres?, PostgresDatabaseConfig?)>
  _launchEmbeddedPostgresIfNeeded() async {
    final dataDir = config.embeddedPostgresDataDir(
      baseDirectory: _serverDirectory ?? Directory.current,
    );
    if (dataDir == null) return (null, null);

    try {
      // Attempt to start a new embedded server. We intentionally do not try to
      // attach first to avoid grabbing servers that are in shutdown process -
      // which proven very common between tests, even with concurrency=1.
      final embeddedPostgres = await EmbeddedPostgres.start(
        EmbeddedPostgresOptions(
          dataDir: dataDir,
          databaseName: config.name,
          username: config.user,
          detach: false,
          repairStaleLocks: true,
        ),
      );
      return (embeddedPostgres, connectivityFrom(embeddedPostgres.endpoint));
    } on PostmasterLockBusyException catch (exc, stackTrace) {
      // Another Serverpod/process already supervises this PGDATA. Attach as a
      // client and return only the endpoint.
      try {
        final attached = await EmbeddedPostgres.attach(dataDir);
        return (null, connectivityFrom(attached.endpoint));
      } on AttachException {
        Error.throwWithStackTrace(exc, stackTrace);
      }
    }
  }

  PostgresDatabaseConfig connectivityFrom(pg.Endpoint endpoint) =>
      PostgresDatabaseConfig(
        host: endpoint.host,
        port: endpoint.port,
        user: endpoint.username ?? config.user,
        password: endpoint.password ?? config.password,
        name: config.name,
        isUnixSocket: endpoint.isUnixSocket,
      );
}

extension on PostgresDatabaseConfig {
  /// The effective data [Directory] for the embedded PostgreSQL, if configured.
  /// Relative `dataPath` values resolve against [baseDirectory].
  Directory? embeddedPostgresDataDir({required Directory baseDirectory}) {
    final dataPath = this.dataPath?.trim();
    if (dataPath == null || dataPath.isEmpty) return null;
    return Directory(
      path.isAbsolute(dataPath)
          ? dataPath
          : path.join(baseDirectory.path, dataPath),
    );
  }
}
