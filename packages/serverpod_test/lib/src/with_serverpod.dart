import 'package:test/test.dart';

import 'test_serverpod.dart';
import 'test_session.dart';
import 'test_stream_manager.dart';
import 'transaction_manager.dart';

export 'package:meta/meta.dart' show isTestGroup;

/// Thrown when the [withServerpod] helper could not be initialized.
class InitializationException implements Exception {
  /// The error message.
  final String message;

  /// Creates a new initialization exception.
  InitializationException(this.message);

  @override
  String toString() {
    return message;
  }
}

/// Thrown when an invalid configuration state is found.
class InvalidConfigurationException implements Exception {
  /// The error message.
  final String message;

  /// Creates a new initialization exception.
  InvalidConfigurationException(this.message);

  @override
  String toString() {
    return message;
  }
}

/// Options for when to reset the test session and recreate
/// the underlying Serverpod session during the test lifecycle.
enum ResetTestSessions {
  /// After each test. This is the default.
  afterEach,

  /// After all tests.
  afterAll,
}

/// Options for when to rollback the database during the test lifecycle.
enum _RollbackDatabase {
  /// After each test. This is the default.
  afterEach,

  /// After all tests.
  afterAll,

  /// Never rollback the database.
  never,
}

/// The test closure that is called by the `withServerpod` test helper.
typedef TestClosure<T> = void Function(
  T endpoints,
  TestSession testSession,
);

/// Internal helper extension for the [DatabaseTestConfig] class.
extension ConfigRuntimeChecks on DatabaseTestConfig {
  /// Returns true if rollbacks are disabled.
  bool get areRollbacksDisabled => _rollbackDatabase == _RollbackDatabase.never;
}

/// Configuration object for how `withServerpod` should handle the database.
class DatabaseTestConfig {
  final _RollbackDatabase _rollbackDatabase;

  /// Creates a new database test configuration.
  DatabaseTestConfig._({
    _RollbackDatabase rollbackDatabase = _RollbackDatabase.afterEach,
  }) : _rollbackDatabase = rollbackDatabase;

  /// Rolls back the database after each test. This is the default.
  /// Will throw an [InvalidConfigurationException] if several calls to `transaction` are made concurrently
  /// since this is not supported by the test tools.
  /// In this case, disable rolling back the database by setting `databaseTestConfig` to `DatabaseTestConfig.rollbacksDisabled()`.
  factory DatabaseTestConfig.rollbackAfterEach() {
    return DatabaseTestConfig._(
      rollbackDatabase: _RollbackDatabase.afterEach,
    );
  }

  /// Rolls back the database after all tests.
  /// Will throw an [InvalidConfigurationException] if several calls to `transaction` are made concurrently
  /// since this is not supported by the test tools.
  /// In this case, disable rolling back the database by setting `databaseTestConfig` to `DatabaseTestConfig.rollbacksDisabled()`.
  factory DatabaseTestConfig.rollbackAfterAll() {
    return DatabaseTestConfig._(
      rollbackDatabase: _RollbackDatabase.afterAll,
    );
  }

  /// Does not rollback the database.
  /// All database changes are persisted and has to be cleaned up manually.
  factory DatabaseTestConfig.rollbacksDisabled() {
    return DatabaseTestConfig._(
      rollbackDatabase: _RollbackDatabase.never,
    );
  }
}

/// Builds the `withServerpod` test helper.
/// Used by the generated code.
/// Note: The [testGroupName] parameter is needed to enable IDE support.
void Function(TestClosure<T>)
    buildWithServerpod<T extends InternalTestEndpoints>(
  String testGroupName,
  TestServerpod<T> testServerpod, {
  ResetTestSessions? maybeResetTestSessions,
  DatabaseTestConfig? maybeDatabaseTestConfig,
  bool? maybeEnableSessionLogging,
}) {
  var resetTestSessions = maybeResetTestSessions ?? ResetTestSessions.afterEach;
  var databaseConfig =
      maybeDatabaseTestConfig ?? DatabaseTestConfig.rollbackAfterEach();
  List<InternalTestSession> allTestSessions = [];

  var mainServerpodSession = testServerpod.createSession(
    databaseTestConfig: databaseConfig,
  );

  TransactionManager transactionManager =
      mainServerpodSession.transactionManager;

  InternalTestSession mainTestSession = InternalTestSession(
    testServerpod,
    allTestSessions: allTestSessions,
    enableLogging: maybeEnableSessionLogging ?? false,
    serverpodSession: mainServerpodSession,
  );

  return (
    TestClosure<T> testClosure,
  ) {
    group(testGroupName, () {
      setUpAll(() async {
        await testServerpod.start();

        if (databaseConfig._rollbackDatabase == _RollbackDatabase.afterAll ||
            databaseConfig._rollbackDatabase == _RollbackDatabase.afterEach) {
          await transactionManager.createTransaction();
          await transactionManager.addSavePoint();
        }
      });

      tearDown(() async {
        if (databaseConfig._rollbackDatabase == _RollbackDatabase.afterEach) {
          await transactionManager.rollbacktoPreviousSavePoint();
          await transactionManager.addSavePoint();
        }

        if (resetTestSessions == ResetTestSessions.afterEach) {
          for (var testSession in allTestSessions) {
            await testSession.resetState();
          }
        }

        await GlobalStreamManager.closeAllStreams();
      });

      tearDownAll(() async {
        if (databaseConfig._rollbackDatabase == _RollbackDatabase.afterAll ||
            databaseConfig._rollbackDatabase == _RollbackDatabase.afterEach) {
          await transactionManager.cancelTransaction();
        }

        for (var testSession in allTestSessions) {
          await testSession.destroy();
        }
        allTestSessions.clear();

        await testServerpod.shutdown();
      });

      testClosure(testServerpod.testEndpoints, mainTestSession);
    });
  };
}
