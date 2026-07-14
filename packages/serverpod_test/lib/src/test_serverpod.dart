import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_database/embedded.dart';
import 'package:serverpod_shared/serverpod_shared.dart' show PasswordManager;
import 'package:serverpod_test/src/io_overrides.dart';
import 'package:serverpod_test/src/test_database_manager.dart';
import 'package:serverpod_test/src/test_database_proxy.dart';
import 'package:serverpod_test/src/transaction_manager.dart';
import 'package:serverpod_test/src/with_serverpod.dart';

/// Internal test endpoints interface that contains implementation details
/// that should only be used internally by the test tools.
abstract interface class InternalTestEndpoints {
  /// Initializes the endpoints.
  void initialize(
    DatabaseSerializationManager serializationManager,
    EndpointDispatch endpoints,
  );
}

/// A serverpod session used internally by the test tools.
/// This is needed to modify the transaction which is not mutable on the [Session] base class.
class InternalServerpodSession extends Session {
  /// The transaction that is used by the session.
  @override
  Transaction? get transaction {
    var localTransactionManager = transactionManager;
    if (localTransactionManager == null) {
      throw StateError(
        'Database is not enabled for this project, but transaction was accessed.',
      );
    }
    return localTransactionManager.currentTransaction;
  }

  @override
  TestDatabaseProxy get db {
    var localDbProxy = _dbProxy;
    if (localDbProxy == null) {
      throw StateError(
        'Database is not enabled for this project, but db was accessed.',
      );
    }
    return localDbProxy;
  }

  late final TestDatabaseProxy? _dbProxy;

  /// The database test configuration.
  final RollbackDatabase rollbackDatabase;

  /// The transaction manager to manage the Serverpod session's transactions.
  late final TransactionManager? transactionManager;

  /// Creates a new internal serverpod session.
  InternalServerpodSession({
    required super.endpoint,
    required super.method,
    required super.server,
    required super.enableLogging,
    required this.rollbackDatabase,
    required bool isDatabaseEnabled,
    TransactionManager? transactionManager,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
  }) {
    if (!isDatabaseEnabled) {
      this.transactionManager = null;
      _dbProxy = null;
      return;
    }

    var localTransactionManager =
        transactionManager ?? TransactionManager(this);
    _dbProxy = TestDatabaseProxy(
      super.db,
      rollbackDatabase,
      localTransactionManager,
      runtimeParametersBuilder,
    );

    this.transactionManager = localTransactionManager;
  }
}

List<String> _getServerpodStartUpArgs({
  String? runMode,
  bool? applyMigrations,
  ServerpodLoggingMode? loggingMode,
}) => [
  '-m',
  runMode ?? ServerpodRunMode.test,
  if (applyMigrations ?? true) '--apply-migrations',
  '--logging',
  loggingMode?.name ?? ServerpodLoggingMode.normal.name,
];

/// A facade for the real Serverpod instance.
class TestServerpod<T extends InternalTestEndpoints> {
  /// The test endpoints that are exposed to the user.
  T testEndpoints;

  final bool? _applyMigrations;
  final EndpointDispatch _endpoints;
  final DatabaseSerializationManager _serializationManager;
  final ServerpodLoggingMode? _serverpodLoggingMode;
  final String? _runMode;
  final Directory? _serverDirectory;
  final ExperimentalFeatures? _experimentalFeatures;
  final RuntimeParametersListBuilder? _runtimeParametersBuilder;
  final DatabaseInterceptor? _databaseInterceptor;
  final ServerpodConfig Function(ServerpodConfig)? _configOverride;

  Serverpod? _serverpodInstance;
  Serverpod get _serverpod => _serverpodInstance ??= _constructServerpod();

  /// Manages this group's own database; retained to drop it on [shutdown].
  TestDatabaseManager? _databaseManager;

  /// The per-group database name, decided eagerly in the constructor. It is
  /// baked into the server configuration up front (see [_constructServerpod])
  /// so the single, test-configured server instance is the one that runs -
  /// only the database's creation is deferred to [start].
  late final String _targetDatabaseName =
      TestDatabaseManager.generateDatabaseName();

  /// Whether the database is enabled and supported by the project configuration.
  final bool isDatabaseEnabled;

  /// The output mode for test server logs.
  final TestServerOutputMode testServerOutputMode;

  /// Creates a new test serverpod instance.
  TestServerpod({
    required bool? applyMigrations,
    required EndpointDispatch endpoints,
    required DatabaseSerializationManager serializationManager,
    required this.isDatabaseEnabled,
    required this.testEndpoints,
    required ServerpodLoggingMode? serverpodLoggingMode,
    required String? runMode,
    required TestServerOutputMode? testServerOutputMode,
    Directory? serverDirectory,
    ExperimentalFeatures? experimentalFeatures,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
    DatabaseInterceptor? databaseInterceptor,
    ServerpodConfig Function(ServerpodConfig)? configOverride,
  }) : _applyMigrations = applyMigrations,
       _endpoints = endpoints,
       _serializationManager = serializationManager,
       _serverpodLoggingMode = serverpodLoggingMode,
       _runMode = runMode,
       _serverDirectory = serverDirectory,
       _experimentalFeatures = experimentalFeatures,
       _runtimeParametersBuilder = runtimeParametersBuilder,
       _databaseInterceptor = databaseInterceptor,
       _configOverride = configOverride,
       testServerOutputMode =
           testServerOutputMode ?? TestServerOutputMode.normal {
    testEndpoints.initialize(serializationManager, endpoints);
  }

  /// Constructs a [Serverpod] whose configured database is this group's own: a
  /// PostgreSQL database named [_targetDatabaseName], or a SQLite file derived
  /// from it.
  Serverpod _constructServerpod() {
    // Ignore output from the Serverpod constructor to avoid spamming the
    // console. Tracked in https://github.com/serverpod/serverpod/issues/2847
    return IOOverrides.runZoned(
      () {
        final serverpod = Serverpod(
          _getServerpodStartUpArgs(
            runMode: _runMode,
            applyMigrations: _applyMigrations,
            loggingMode: _serverpodLoggingMode,
          ),
          _serializationManager,
          _endpoints,
          serverDirectory: _serverDirectory,
          configOverride: (config) {
            var resolved = _configOverride?.call(config) ?? config;
            final db = resolved.database;
            if (db is PostgresDatabaseConfig) {
              resolved = resolved.copyWith(
                database: db.withName(_targetDatabaseName),
              );
            } else if (db is SqliteDatabaseConfig) {
              resolved = resolved.copyWith(
                database: SqliteDatabaseConfig(
                  filePath: _perGroupSqliteFilePath(db.filePath),
                  maxConnectionCount: db.maxConnectionCount,
                ),
              );
            }
            return resolved;
          },
          experimentalFeatures: _experimentalFeatures,
          runtimeParametersBuilder: _runtimeParametersBuilder,
          databaseInterceptor: _databaseInterceptor,
        );
        _endpoints.initializeEndpoints(serverpod.server);
        return serverpod;
      },
      stdout: () => NullStdOut(),
      stderr: () => NullStdOut(),
    );
  }

  /// This group's own SQLite file, derived from the configured [original] path
  /// by inserting [_targetDatabaseName] (e.g. `db/test.db` ->
  /// `db/sp_test_<token>.db`). `:memory:` is left as-is. Relative paths stay
  /// relative so the SQLite adapter anchors them against the server directory.
  String _perGroupSqliteFilePath(String original) {
    if (original == ':memory:') return original;
    return p.join(
      p.dirname(original),
      '$_targetDatabaseName${p.extension(original)}',
    );
  }

  /// Executes a callback with output suppression based on the configured mode.
  Future<R> _withOutputMode<R>(Future<R> Function() callback) async {
    switch (testServerOutputMode) {
      case TestServerOutputMode.normal:
        // Suppress stdout, allow stderr
        return await IOOverrides.runZoned(
          callback,
          stdout: () => NullStdOut(),
        );
      case TestServerOutputMode.verbose:
        // Allow both stdout and stderr
        return await callback();
      case TestServerOutputMode.silent:
        // Suppress both stdout and stderr
        return await IOOverrides.runZoned(
          callback,
          stdout: () => NullStdOut(),
          stderr: () => NullStdOut(),
        );
    }
  }

  /// Embedded PostgreSQL postmasters launched to back tests, keyed by data
  /// directory. They are launched once per test process and intentionally kept
  /// running; see [_startOrAttachSharedEmbeddedPostgres].
  static final Map<String, ResolvedEmbeddedPostgres> _sharedEmbeddedPostgres =
      {};

  /// Starts the underlying serverpod instance.
  Future<void> start() async {
    try {
      await _withOutputMode(() async {
        final database = _resolveProjectDatabaseConfig();
        final isEmbeddedPostgres =
            database is PostgresDatabaseConfig && database.dataPath != null;

        // Start the shared postmaster before the server connects, so this
        // group's database can be created on it.
        final embedded = isEmbeddedPostgres
            ? await _startOrAttachSharedEmbeddedPostgres(database)
            : null;

        // SQLite needs nothing here; its per-group file is created when the
        // server migrates it.
        if (database is PostgresDatabaseConfig) {
          try {
            await _createOwnDatabase(embedded?.connectivity ?? database);
          } catch (e) {
            throw InitializationException(
              'Failed to set up the test database. Ensure the database is '
              'running and reachable. Error: $e',
            );
          }
        }

        try {
          await _serverpod.start(runInGuardedZone: false);
        } catch (_) {
          // A failed start skips shutdown(), so drop this group's database
          // here. Best-effort, preserving the original start failure.
          try {
            await _serverpod.shutdown(exitProcess: false);
          } catch (_) {}
          try {
            await _dropOwnDatabase();
          } catch (_) {}
          rethrow;
        }
      });
    } on InitializationException {
      // Already a descriptive failure (e.g. database setup); surface it as-is.
      rethrow;
    } on ExitException catch (e) {
      throw InitializationException(
        'Failed to start the serverpod instance${e.message.isEmpty ? ', check the log for more info.' : ': ${e.message}'}',
      );
    } catch (_) {
      throw InitializationException(
        'Failed to start the serverpod instance, check the log for more info.',
      );
    }
  }

  /// Launches or attaches to the embedded PostgreSQL postmaster backing
  /// [database], caching it per data directory so every `withServerpod` group
  /// shares one instance - otherwise the first group would tear it down on its
  /// own shutdown, stranding the rest. Returns the resolved coordinates, or
  /// `null` for an externally-managed server.
  ///
  /// [database] must be the project config (see [_resolveProjectDatabaseConfig]),
  /// not the running server's per-group-named one, which the launcher would
  /// create on first init instead of the project database.
  Future<ResolvedEmbeddedPostgres?> _startOrAttachSharedEmbeddedPostgres(
    PostgresDatabaseConfig database,
  ) async {
    final baseDirectory = _serverpod.serverDirectory;
    final key = '${baseDirectory.path}|${database.dataPath}';
    final existing = _sharedEmbeddedPostgres[key];
    if (existing != null) return existing;

    final resolved = await startOrAttachEmbeddedPostgres(
      database,
      baseDirectory: baseDirectory,
    );
    if (resolved != null) {
      _sharedEmbeddedPostgres[key] = resolved;
    }
    return resolved;
  }

  /// Loads the project's database config the way [Serverpod] would (run mode,
  /// passwords, and the user's `configOverride`) but without the per-group
  /// name swap, so the shared postmaster is launched against the project
  /// database regardless of which group starts first.
  DatabaseConfig? _resolveProjectDatabaseConfig() {
    final serverDir = _serverDirectory?.path;
    final runMode = _runMode ?? ServerpodRunMode.test;
    final passwords = PasswordManager(runMode: runMode).loadPasswords(
      serverDir: serverDir,
    );
    var config = ServerpodConfig.load(
      runMode,
      null,
      passwords,
      serverDir: serverDir,
    );
    config = _configOverride?.call(config) ?? config;
    return config.database;
  }

  /// Creates this group's own PostgreSQL database (dropped on [shutdown]) on
  /// the server given by [connectivity]: the embedded postmaster's resolved
  /// coordinates, or the project's configured server.
  Future<void> _createOwnDatabase(PostgresDatabaseConfig connectivity) async {
    final manager = TestDatabaseManager(connectivity);
    _databaseManager = manager;
    await manager.createEmptyDatabase(_targetDatabaseName);
  }

  /// Shuts down the underlying serverpod instance and drops this group's
  /// database (a PostgreSQL `DROP DATABASE`, or deleting the SQLite file). The
  /// shared embedded postmaster is intentionally left running; it is reclaimed
  /// when the test process exits.
  Future<void> shutdown() async {
    try {
      await _withOutputMode(() async {
        await _serverpod.shutdown(exitProcess: false);
        await _dropOwnDatabase();
      });
    } catch (e, stackTrace) {
      throw InitializationException(
        'Failed to shutdown the serverpod instance: $e\n$stackTrace',
      );
    }
  }

  /// Drops this group's own database: a PostgreSQL `DROP DATABASE` for the
  /// per-group database created in [_createOwnDatabase], plus the per-group
  /// SQLite file. Shared by [shutdown] and [start]'s failure cleanup.
  Future<void> _dropOwnDatabase() async {
    await _databaseManager?.dropDatabase(_targetDatabaseName);
    _deleteOwnSqliteFile();
  }

  /// Deletes this group's SQLite database file (and its WAL/SHM/journal
  /// sidecars) when the project uses SQLite. Relative paths are resolved
  /// against the server directory the SQLite adapter anchors them to.
  void _deleteOwnSqliteFile() {
    final db = _serverpod.config.database;
    if (db is! SqliteDatabaseConfig || db.filePath == ':memory:') return;
    final base = p.isAbsolute(db.filePath)
        ? db.filePath
        : p.join(_serverpod.serverDirectory.path, db.filePath);
    for (final suffix in const ['', '-wal', '-shm', '-journal']) {
      final file = File('$base$suffix');
      if (file.existsSync()) file.deleteSync();
    }
  }

  /// Creates a new Serverpod session.
  InternalServerpodSession createSession({
    bool enableLogging = false,
    required RollbackDatabase rollbackDatabase,
    String endpoint = '',
    String method = '',
    TransactionManager? transactionManager,
  }) {
    return InternalServerpodSession(
      server: _serverpod.server,
      enableLogging: enableLogging,
      endpoint: endpoint,
      method: method,
      rollbackDatabase: rollbackDatabase,
      transactionManager: transactionManager,
      isDatabaseEnabled: isDatabaseEnabled,
      runtimeParametersBuilder: _serverpod.runtimeParametersBuilder,
    );
  }
}
