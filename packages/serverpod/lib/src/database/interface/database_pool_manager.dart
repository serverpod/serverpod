import 'package:meta/meta.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'serialization_manager.dart';
import 'value_encoder.dart';

/// Abstract interface for database pool managers.
/// Provides a unified interface for both any database dialect implementation.
@internal
abstract interface class DatabasePoolManager {
  /// The dialect of the database pool manager.
  DatabaseDialect get dialect;

  /// The last time a database operation was performed. This can be used to
  /// determine if the database is sleeping.
  DateTime? lastDatabaseOperationTime;

  /// Access to the serialization manager.
  SerializationManagerServer get serializationManager;

  /// The encoder used to encode objects for storing in the database.
  ValueEncoder get encoder;

  /// Starts the database pool.
  void start();

  /// Closes the database pool.
  Future<void> stop();

  /// Tests the database connection.
  /// Throws an exception if the connection is not working.
  Future<bool> testConnection();
}
