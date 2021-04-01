import 'package:postgres_pool/postgres_pool.dart';
import 'package:postgres/src/text_codec.dart';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'database_connection.dart';

class DatabaseConfig {
  final String host;
  final int port;
  final String databaseName;
  final String userName;
  final String password;
  late SerializationManager _serializationManager;
  SerializationManager get serializationManager => _serializationManager;
  late PgPool _pgPool;
  PgPool get pool => _pgPool;

  final tableClassMapping; // = <String, String>{};
  static final PostgresTextEncoder encoder = PostgresTextEncoder();

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

  DatabaseConnection createConnection() => DatabaseConnection(this);
}
