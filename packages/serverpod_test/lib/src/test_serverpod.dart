import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test/src/io_overrides.dart';
import 'package:serverpod_test/src/test_database_proxy.dart';
import 'package:serverpod_test/src/transaction_manager.dart';
import 'package:serverpod_test/src/with_serverpod.dart';

/// Internal test endpoints interface that contains implementation details
/// that should only be used internally by the test tools.
abstract interface class InternalTestEndpoints {
  /// Initializes the endpoints.
  void initialize(
    SerializationManagerServer serializationManager,
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
          'Database is not enabled for this project, but transaction was accessed.');
    }
    return localTransactionManager.currentTransaction;
  }

  @override
  TestDatabaseProxy get db {
    var localDbProxy = _dbProxy;
    if (localDbProxy == null) {
      throw StateError(
          'Database is not enabled for this project, but db was accessed.');
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
}) =>
    [
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

  late final Serverpod Function() _buildServerpodAndInitializeEndpoints;

  Serverpod? _serverpodInstance;
  Serverpod get _serverpod {
    return _serverpodInstance ??= _buildServerpodAndInitializeEndpoints();
  }

  /// Whether the database is enabled and supported by the project configuration.
  final bool isDatabaseEnabled;

  /// Creates a new test serverpod instance.
  TestServerpod({
    required bool? applyMigrations,
    required EndpointDispatch endpoints,
    required SerializationManagerServer serializationManager,
    required this.isDatabaseEnabled,
    required this.testEndpoints,
    required ServerpodLoggingMode? serverpodLoggingMode,
    required String? runMode,
    ExperimentalFeatures? experimentalFeatures,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
  }) {
    // Ignore output from the Serverpod constructor to avoid spamming the console.
    // Should be changed when a proper logger is implemented.
    // Tracked in issue: https://github.com/serverpod/serverpod/issues/2847
    _buildServerpodAndInitializeEndpoints = () => IOOverrides.runZoned(
          () {
            var serverpod = Serverpod(
              _getServerpodStartUpArgs(
                runMode: runMode,
                applyMigrations: applyMigrations,
                loggingMode: serverpodLoggingMode,
              ),
              serializationManager,
              endpoints,
              experimentalFeatures: experimentalFeatures,
              runtimeParametersBuilder: runtimeParametersBuilder,
            );
            endpoints.initializeEndpoints(serverpod.server);
            return serverpod;
          },
          stdout: () => NullStdOut(),
          stderr: () => NullStdOut(),
        );
    testEndpoints.initialize(serializationManager, endpoints);
  }

  /// Starts the underlying serverpod instance.
  Future<void> start() async {
    try {
      await _serverpod.start(runInGuardedZone: false);
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

  /// Shuts down the underlying serverpod instance.
  Future<void> shutdown() async {
    return _serverpod.shutdown(exitProcess: false);
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
