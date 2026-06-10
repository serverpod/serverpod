import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
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

  /// Base dir a relative `filePath` resolves against. Defaults to cwd.
  final Directory? _serverDirectory;

  late DatabaseSerializationManager _serializationManager;

  /// Access to the serialization manager.
  @override
  DatabaseSerializationManager get serializationManager =>
      _serializationManager;

  SqliteDatabase? _db;

  /// Tracks the PRAGMA future kicked off by [start]
  Future<void>? _startedFuture;
  bool _databaseStopped = false;

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
  /// when starting the [Server] with SQLite configuration.
  SqlitePoolManager(
    DatabaseSerializationManager serializationManager,
    this.config, {
    Directory? serverDirectory,
  }) : _serverDirectory = serverDirectory {
    _serializationManager = serializationManager;
  }

  /// `config.filePath`, with a relative path anchored at [_serverDirectory]
  /// (or cwd). `:memory:` and absolute paths are returned unchanged.
  String get _resolvedFilePath {
    final filePath = config.filePath;
    if (filePath == ':memory:' || path.isAbsolute(filePath)) return filePath;
    return path.join(
      (_serverDirectory ?? Directory.current).path,
      filePath,
    );
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
      path: _resolvedFilePath,
      options: SqliteOptions(
        maxReaders:
            config.maxConnectionCount ?? SqliteOptions.defaultMaxReaders,
      ),
    );
    _db = db;
    await db.execute('PRAGMA foreign_keys = ON');
  }

  @override
  Future<void> get started => _startedFuture ??= _bootstrap();

  /// Closes the database.
  @override
  Future<void> stop() async {
    _databaseStopped = true;
    final db = _db;

    _db = null;
    _startedFuture = null;

    await db?.close();
  }

  /// Tests the database connection.
  @override
  Future<bool> testConnection() async {
    final connection = await database;
    await connection.get('SELECT 1');
    return true;
  }
}
