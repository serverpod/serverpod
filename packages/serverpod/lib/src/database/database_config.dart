import 'package:serverpod_postgres_pool/postgres_pool.dart';
import 'package:postgres/src/text_codec.dart';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'database_connection.dart';
import 'value_encoder.dart';

/// Configuration for connecting to the Postgresql database.
class DatabaseConfig {
  /// Host name.
  final String host;

  /// Port to connect to.
  final int port;

  /// Name of the database to use.
  final String databaseName;

  /// User name.
  final String userName;

  /// Password.
  final String password;

  late SerializationManager _serializationManager;
  /// Access to the serialization manager.
  SerializationManager get serializationManager => _serializationManager;

  late PgPool _pgPool;
  /// Postgresql connection pool created from configuration.
  PgPool get pool => _pgPool;

  /// Maps tables to classes, used internally by the server when communicating
  /// with the database.
  final tableClassMapping; // = <String, String>{};

  /// The encoder used to encode objects for storing in the database.
  static final ValueEncoder encoder = ValueEncoder();

  /// Creates a new [DatabaseConfig]. Typically, this is done automatically
  /// when starting the [Server].
  DatabaseConfig(SerializationManager serializationManager, this.host, this.port, this.databaseName, this.userName, this.password)
      : tableClassMapping = serializationManager.tableClassMapping {
    _serializationManager = serializationManager;

    var poolSettings = PgPoolSettings();
    poolSettings.concurrency = 10;
    poolSettings.queryTimeout = Duration(minutes: 1);

    // Setup database connection pool
    _pgPool = PgPool(
      PgEndpoint(
          host: host,
          port: port,
          database: databaseName,
          username: userName,
          password: password
      ),
      settings: poolSettings,
    );
  }

  /// Used internally by the [Server]. Creates a new connection to the database.
  /// Typically, the [Database] provided by the [Session] object should be used
  /// to connect with the database.
  DatabaseConnection createConnection() => DatabaseConnection(this);
}
