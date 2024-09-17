import 'package:test/test.dart';

import 'test_serverpod.dart';
import 'test_session.dart';
import 'transaction_manager.dart';

export 'package:meta/meta.dart' show isTestGroup;

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
  late TransactionManager transactionManager;

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
        transactionManager =
            TransactionManager(mainTestSession.serverpodSession);

        if (rollbackDatabase == RollbackDatabase.afterAll ||
            rollbackDatabase == RollbackDatabase.afterEach) {
          mainTestSession.transaction =
              await transactionManager.createTransaction();
          await transactionManager.pushSavePoint();
        }
      });

      tearDown(() async {
        if (rollbackDatabase == RollbackDatabase.afterEach) {
          await transactionManager.popSavePoint();
          await transactionManager.pushSavePoint();
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
