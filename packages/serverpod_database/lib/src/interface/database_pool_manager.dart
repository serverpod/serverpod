import 'package:serverpod_shared/serverpod_shared.dart';

import 'serialization_manager.dart';
import 'value_encoder.dart';

/// Abstract interface for database pool managers.
/// Provides a unified interface for both any database dialect implementation.
abstract interface class DatabasePoolManager {
  /// The dialect of the database pool manager.
  DatabaseDialect get dialect;

  /// The last time a database operation was performed. This can be used to
  /// determine if the database is sleeping.
  DateTime? lastDatabaseOperationTime;

  /// Access to the serialization manager.
  DatabaseSerializationManager get serializationManager;

  /// The encoder used to encode objects for storing in the database.
  ValueEncoder get encoder;

  /// Starts the database pool.
  ///
  /// This method kicks off an async initialization process that must be
  /// awaited from [started] to avoid unhandled futures. Use it only to start
  /// the database pool after [stop] has been called. Otherwise prefer awaiting
  /// [started] instead, since it will lazily initialize the database pool on
  /// the first access.
  void start();

  /// Ensures the database pool is started.
  ///
  /// If [start] has been previously called, this will simply return the future
  /// kicked off by [start]. Otherwise, it will create an initialization process
  /// and return the future. This method alone is enough to ensure the database
  /// pool is first started.
  ///
  /// This method is idempotent and can be called multiple times.
  Future<void> get started;

  /// Closes the database pool.
  Future<void> stop();

  /// Tests the database connection.
  ///
  /// Throws an exception if the connection is not working.
  Future<bool> testConnection();
}
