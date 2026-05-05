import 'package:meta/meta.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:sqlite_async/sqlite_async.dart';

import '../../interface/database_pool_manager.dart';
import '../../interface/serialization_manager.dart';
import 'value_encoder.dart';

/// Configuration for connecting to a SQLite database.
@internal
class SqlitePoolManager implements DatabasePoolManager {
  /// The dialect of the database pool manager.
  @override
  DatabaseDialect get dialect => DatabaseDialect.sqlite;

  @override
  DateTime? lastDatabaseOperationTime;

  /// Database configuration.
  final SqliteDatabaseConfig config;

  late DatabaseSerializationManager _serializationManager;

  /// Access to the serialization manager.
  @override
  DatabaseSerializationManager get serializationManager =>
      _serializationManager;

  SqliteDatabase? _db;

  /// In-flight [start] future, used to coalesce concurrent callers onto
  /// a single start cycle. Cleared once the cycle completes (or fails)
  /// and again by [stop] so a restart kicks off a fresh cycle.
  Future<void>? _starting;

  /// The SQLite database instance.
  ///
  /// Throws a [StateError] if the database has not been started.
  SqliteDatabase get database {
    var db = _db;
    if (db == null) {
      throw StateError('Database not started.');
    }
    return db;
  }

  /// The encoder used to encode objects for storing in the database.
  @override
  SqliteValueEncoder get encoder => const SqliteValueEncoder();

  /// Creates a new [SqlitePoolManager]. Typically, this is done automatically
  /// when starting the [Server] with SQLite configuration.
  SqlitePoolManager(
    DatabaseSerializationManager serializationManager,
    this.config,
  ) {
    _serializationManager = serializationManager;
  }

  /// Starts the database connection.
  ///
  /// Safe to call concurrently or repeatedly: in-flight calls share the
  /// same future, and a call after [stop] begins a fresh start cycle.
  @override
  Future<void> start() async {
    if (_db != null) return;
    return _starting ??= _start();
  }

  Future<void> _start() async {
    try {
      final db = SqliteDatabase(
        path: config.filePath,
        // This will only be available from 0.14 onwards.
        // options: SqliteOptions(
        //   maxReaders:
        //       config.maxConnectionCount ?? SqliteOptions.defaultMaxReaders,
        // ),
      );
      await db.execute('PRAGMA foreign_keys = ON');
      // Assign after the await so a failed start leaves _db null and the
      // caller can retry.
      _db = db;
    } finally {
      _starting = null;
    }
  }

  /// Closes the database.
  @override
  Future<void> stop() async {
    await _db?.close();
    _db = null;
    _starting = null;
  }

  /// Tests the database connection.
  @override
  Future<bool> testConnection() async {
    await database.get('SELECT 1');
    return true;
  }
}
