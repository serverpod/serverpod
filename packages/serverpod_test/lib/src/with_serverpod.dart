import 'package:test/test.dart';

import 'test_serverpod.dart';
import 'test_session_builder.dart';
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

/// Options for when to rollback the database during the test lifecycle.
enum RollbackDatabase {
  /// After each test. This is the default.
  afterEach,

  /// After all tests.
  afterAll,

  /// Disable rolling back the database.
  disabled,
}

/// The test closure that is called by the `withServerpod` test helper.
typedef TestClosure<T> = void Function(
  TestSessionBuilder testSession,
  T endpoints,
);

/// Builds the `withServerpod` test helper.
/// Used by the generated code.
/// Note: The [testGroupName] parameter is needed to enable IDE support.
void Function(TestClosure<T>)
    buildWithServerpod<T extends InternalTestEndpoints>(
  String testGroupName,
  TestServerpod<T> testServerpod, {
  RollbackDatabase? maybeRollbackDatabase,
  bool? maybeEnableSessionLogging,
}) {
  var rollbackDatabase = maybeRollbackDatabase ?? RollbackDatabase.afterEach;
  List<InternalServerpodSession> allTestSessions = [];

  var mainServerpodSession = testServerpod.createSession(
    rollbackDatabase: rollbackDatabase,
  );

  TransactionManager transactionManager =
      mainServerpodSession.transactionManager;

  InternalTestSessionBuilder mainTestSession = InternalTestSessionBuilder(
    testServerpod,
    allTestSessions: allTestSessions,
    enableLogging: maybeEnableSessionLogging ?? false,
    mainServerpodSession: mainServerpodSession,
  );

  return (
    TestClosure<T> testClosure,
  ) {
    group(testGroupName, () {
      setUpAll(() async {
        await testServerpod.start();

        if (rollbackDatabase == RollbackDatabase.afterAll ||
            rollbackDatabase == RollbackDatabase.afterEach) {
          await transactionManager.createTransaction();
          await transactionManager.addSavePoint();
        }
      });

      tearDown(() async {
        if (rollbackDatabase == RollbackDatabase.afterEach) {
          await transactionManager.rollbacktoPreviousSavePoint();
          await transactionManager.addSavePoint();
        }

        await GlobalStreamManager.closeAllStreams();
      });

      tearDownAll(() async {
        if (rollbackDatabase == RollbackDatabase.afterAll ||
            rollbackDatabase == RollbackDatabase.afterEach) {
          await transactionManager.cancelTransaction();
        }

        for (var testSession in allTestSessions) {
          await testSession.close();
        }
        allTestSessions.clear();

        await testServerpod.shutdown();
      });

      testClosure(mainTestSession, testServerpod.testEndpoints);
    });
  };
}
