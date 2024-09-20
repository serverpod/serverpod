import 'package:test/test.dart';

import 'test_serverpod.dart';
import 'test_session.dart';
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

/// Options for when to reset the test session and recreate
/// the underlying Serverpod session during the test lifecycle.
enum ResetTestSessions {
  /// After each test. This is the default.
  afterEach,

  /// After all tests.
  afterAll,
}

/// Options for when to rollback the database during the test lifecycle.
enum RollbackDatabase {
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

/// Builds the `withServerpod` test helper.
/// Used by the generated code.
/// Note: The [testGroupName] parameter is needed to enable IDE support.
void Function(TestClosure<T>)
    buildWithServerpod<T extends InternalTestEndpoints>(
  String testGroupName,
  TestServerpod<T> testServerpod, {
  ResetTestSessions? maybeResetTestSessions,
  RollbackDatabase? maybeRollbackDatabase,
  bool? maybeEnableSessionLogging,
}) {
  var resetTestSessions = maybeResetTestSessions ?? ResetTestSessions.afterEach;
  var rollbackDatabase = maybeRollbackDatabase ?? RollbackDatabase.afterEach;
  List<InternalTestSession> allTestSessions = [];
  TransactionManager? transactionManager;

  return (
    TestClosure<T> testClosure,
  ) {
    group(testGroupName, () {
      InternalTestSession mainTestSession = InternalTestSession(
        testServerpod,
        allTestSessions: allTestSessions,
        enableLogging: maybeEnableSessionLogging ?? false,
        serverpodSession: testServerpod.createSession(),
      );

      setUpAll(() async {
        await testServerpod.start();
        var localTransactionManager =
            TransactionManager(mainTestSession.serverpodSession);
        transactionManager = localTransactionManager;

        if (rollbackDatabase == RollbackDatabase.afterAll ||
            rollbackDatabase == RollbackDatabase.afterEach) {
          mainTestSession.transaction =
              await localTransactionManager.createTransaction();
          await localTransactionManager.pushSavePoint();
        }
      });

      tearDown(() async {
        var localTransactionManager = transactionManager;
        if (localTransactionManager == null) {
          throw StateError('Transaction manager is null.');
        }

        if (rollbackDatabase == RollbackDatabase.afterEach) {
          await localTransactionManager.popSavePoint();
          await localTransactionManager.pushSavePoint();
        }

        if (resetTestSessions == ResetTestSessions.afterEach) {
          for (var testSession in allTestSessions) {
            await testSession.resetState();
          }
        }
      });

      tearDownAll(() async {
        if (rollbackDatabase == RollbackDatabase.afterAll ||
            rollbackDatabase == RollbackDatabase.afterEach) {
          await transactionManager?.cancelTransaction();
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
