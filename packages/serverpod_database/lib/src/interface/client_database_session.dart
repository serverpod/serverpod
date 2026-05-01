import 'package:serverpod_shared/serverpod_shared.dart';

import '../adapters/sqlite/sqlite_pool_manager.dart';
import '../concepts/transaction.dart';
import '../database.dart';
import '../migrations/migration_artifacts.dart';
import '../migrations/migration_manager.dart';
import 'database_session.dart';
import 'serialization_manager.dart';

/// A [DatabaseSession] backed by a local SQLite file, for client-side models
/// (`database: client` / `database: all`).
class ClientDatabaseSession implements DatabaseSession {
  final SqlitePoolManager _poolManager;
  late final Database _database;

  ClientDatabaseSession._(this._poolManager) {
    _database = DatabaseConstructor.create(
      session: this,
      poolManager: _poolManager,
    );
  }

  /// Opens a database session at [path] using [serializationManager] for schema
  /// access. When [runMigrations] is true (default), pending [clientMigrations]
  /// are applied before the session is returned. If [isDebugMode] is true, the
  /// database integrity will be verified after the migrations are applied to
  /// provide feedback of possible issues. On a Flutter application, this should
  /// be set to [kDebugMode].
  static Future<ClientDatabaseSession> open(
    String path,
    DatabaseSerializationManager serializationManager, {
    List<MigrationVersionSql> clientMigrations = const [],
    bool runMigrations = true,
    bool isDebugMode = false,
  }) async {
    final poolManager = SqlitePoolManager(
      serializationManager,
      SqliteDatabaseConfig(filePath: path),
    )..start();
    final session = ClientDatabaseSession._(poolManager);
    if (runMigrations) {
      await session._runMigrations(
        moduleName: serializationManager.getModuleName(),
        clientMigrations: clientMigrations,
        isDebugMode: isDebugMode,
      );
    }
    return session;
  }

  Future<void> _runMigrations({
    required String moduleName,
    required List<MigrationVersionSql> clientMigrations,
    required bool isDebugMode,
  }) async {
    if (clientMigrations.isEmpty) return;
    final manager = ClientMigrationManager(
      runMode: isDebugMode ? 'development' : 'production',
      migrations: clientMigrations,
      moduleName: moduleName,
    );
    await manager.migrateToLatest(this);
    if (isDebugMode) {
      await MigrationManager.verifyDatabaseIntegrity(this);
    }
  }

  @override
  Database get db => _database;

  @override
  Transaction? get transaction => null;

  @override
  LogQueryFunction? get logQuery => null;

  @override
  LogWarningFunction? get logWarning => null;

  /// Closes the underlying SQLite database.
  Future<void> close() => _poolManager.stop();
}
