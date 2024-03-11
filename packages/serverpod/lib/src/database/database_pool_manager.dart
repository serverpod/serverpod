import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:serverpod/src/serialization/serialization_manager.dart';

import 'adapters/postgres/value_encoder.dart';

/// Configuration for connecting to the Postgresql database.
@internal
class DatabasePoolManager {
  /// Database configuration.
  final DatabaseConfig config;

  late SerializationManager _serializationManager;

  /// Access to the serialization manager.
  SerializationManager get serializationManager => _serializationManager;

  late pg.Pool _pgPool;

  /// Postgresql connection pool created from configuration.
  pg.Pool get pool => _pgPool;

  /// The encoder used to encode objects for storing in the database.
  static final ValueEncoder encoder = ValueEncoder();

  /// Creates a new [DatabasePoolManager]. Typically, this is done automatically
  /// when starting the [Server].
  DatabasePoolManager(
    SerializationManagerServer serializationManager,
    this.config,
  ) {
    _serializationManager = serializationManager;

    var poolSettings = pg.PoolSettings(
      maxConnectionCount: 10,
      queryTimeout: const Duration(minutes: 1),
      sslMode: config.requireSsl ? pg.SslMode.require : pg.SslMode.disable,
    );

    // Setup database connection pool
    _pgPool = pg.Pool.withEndpoints(
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
      settings: poolSettings,
    );
  }
}
