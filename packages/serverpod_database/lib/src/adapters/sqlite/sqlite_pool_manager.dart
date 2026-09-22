import 'dart:async';

import 'package:meta/meta.dart';
import 'package:serverpod_shared/log.dart';
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

  /// Tracks the PRAGMA future kicked off by [start]
  Future<void>? _startedFuture;
  bool _databaseStopped = false;
  Timer? _optimizationTimer;
  Future<void>? _optimization;

  /// Interval between planner-statistics maintenance runs.
  final Duration optimizationInterval;

  /// The SQLite database instance.
  ///
  /// If the database has not been started yet, this will start it and then
  /// return the database instance. Throws a [StateError] if the database is
  /// not started (e.g. after [stop] has been called).
  Future<SqliteDatabase> get database async {
    await started;
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
  /// when starting the server with SQLite configuration or a client-side
  /// database session.
  SqlitePoolManager(
    DatabaseSerializationManager serializationManager,
    this.config, {
    this.optimizationInterval = const Duration(days: 1),
  }) {
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
    final db = SqliteDatabase(
      path: config.filePath,
      options: SqliteOptions(
        preparedStatementCacheSize: config.preparedStatementCacheSize,
        maxReaders:
            config.maxConnectionCount ?? SqliteOptions.defaultMaxReaders,
      ),
    );
    _db = db;
    await db.execute('PRAGMA foreign_keys = ON');
    await _runOptimization(db);
    if (!_databaseStopped) {
      _optimizationTimer = Timer.periodic(optimizationInterval, (_) {
        unawaited(_runOptimization(db));
      });
    }
  }

  Future<void> _runOptimization(SqliteDatabase db) =>
      _optimization ??= _optimize(db).whenComplete(() => _optimization = null);

  Future<void> _optimize(SqliteDatabase db) async {
    try {
      await db.withAllConnections((writer, readers) async {
        // Most SELECTs run on readers, so the writer's query history alone
        // cannot identify tables that would benefit from fresh statistics.
        await writer.execute('PRAGMA optimize=0x10002');
        for (final reader in readers) {
          // RESET disables schema writes and reloads the in-memory schema. It
          // does not enable writable_schema or modify the database schema.
          // Readers otherwise retain old planner statistics after ANALYZE.
          await reader.getAll('PRAGMA writable_schema=RESET');
        }
      });
    } catch (error, stackTrace) {
      log.warning(
        'SQLite planner maintenance failed.',
        metadata: {'error': error.toString(), 'stackTrace': '$stackTrace'},
      );
    }
  }

  @override
  Future<void> get started {
    if (_databaseStopped) {
      return Future.error(
        StateError('Database stopped. Call `start()` again to restart.'),
      );
    }
    return _startedFuture ??= _bootstrap();
  }

  /// Closes the database.
  @override
  Future<void> stop() async {
    _databaseStopped = true;
    _optimizationTimer?.cancel();
    _optimizationTimer = null;
    // Bootstrap may still be initializing the pool. Do not close its handles
    // while startup maintenance is running, or leave a timer behind it.
    try {
      await _startedFuture;
      await _optimization;
    } finally {
      final db = _db;
      _db = null;
      _startedFuture = null;
      await db?.close();
    }
  }

  /// Tests the database connection.
  @override
  Future<bool> testConnection() async {
    final connection = await database;
    await connection.get('SELECT 1');
    return true;
  }
}
