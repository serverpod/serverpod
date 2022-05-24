import 'package:serverpod/src/serialization/serialization_manager.dart';
import 'package:serverpod_postgres_pool/postgres_pool.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'database_connection.dart';
import 'value_encoder.dart';

/// Configuration for connecting to the Postgresql database.
class DatabasePoolManager {
  /// Database configuration.
  final DatabaseConfig config;

  late SerializationManager _serializationManager;

  /// Access to the serialization manager.
  SerializationManager get serializationManager => _serializationManager;

  late PgPool _pgPool;

  /// Postgresql connection pool created from configuration.
  PgPool get pool => _pgPool;

  /// Maps tables to classes, used internally by the server when communicating
  /// with the database.
  final Map<String, String> tableClassMapping; // = <String, String>{};

  /// The encoder used to encode objects for storing in the database.
  static final ValueEncoder encoder = ValueEncoder();

  /// Creates a new [DatabasePoolManager]. Typically, this is done automatically
  /// when starting the [Server].
  DatabasePoolManager(
    SerializationManagerServer serializationManager,
    this.config,
  ) : tableClassMapping = serializationManager.tableClassMapping {
    _serializationManager = serializationManager;

    var poolSettings = PgPoolSettings();
    poolSettings.concurrency = 10;
    poolSettings.queryTimeout = const Duration(minutes: 1);

    // Setup database connection pool
    _pgPool = PgPool(
      PgEndpoint(
          host: config.host,
          port: config.port,
          database: config.name,
          username: config.user,
          password: config.password),
      settings: poolSettings,
    );
  }

  /// Used internally by the [Server]. Creates a new connection to the database.
  /// Typically, the [Database] provided by the [Session] object should be used
  /// to connect with the database.
  DatabaseConnection createConnection() => DatabaseConnection(this);
}
