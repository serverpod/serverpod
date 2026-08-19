import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test/src/ephemeral_test_database.dart';
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

  /// This group's own database; retained to drop it on [shutdown].
  EphemeralTestDatabase? _ephemeralDatabase;

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
                  filePath: EphemeralTestDatabase.sqliteFilePath(
                    db.filePath,
                    _targetDatabaseName,
                  ),
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

  /// Starts the underlying serverpod instance.
  Future<void> start() async {
    try {
      await _withOutputMode(() async {
        // Provision this group's database before the server connects.
        // PostgreSQL: CREATE DATABASE on the shared postmaster. SQLite: a
        // drop-handle for the per-group file (created when migrations run).
        try {
          _ephemeralDatabase = await EphemeralTestDatabase.create(
            runMode: _runMode ?? ServerpodRunMode.test,
            databaseName: _targetDatabaseName,
            serverDirectory: _serverpod.serverDirectory,
            configOverride: _configOverride,
          );
        } catch (e) {
          throw InitializationException(
            'Failed to set up the test database. Ensure the database is '
            'running and reachable. Error: $e',
          );
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
            await _ephemeralDatabase?.drop();
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

  /// Shuts down the underlying serverpod instance and drops this group's
  /// database (a PostgreSQL `DROP DATABASE`, or deleting the SQLite file). The
  /// shared embedded postmaster is intentionally left running; it is reclaimed
  /// when the test process exits.
  Future<void> shutdown() async {
    try {
      await _withOutputMode(() async {
        await _serverpod.shutdown(exitProcess: false);
        await _ephemeralDatabase?.drop();
      });
    } catch (e, stackTrace) {
      throw InitializationException(
        'Failed to shutdown the serverpod instance: $e\n$stackTrace',
      );
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
