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

/// Options for controlling test server output during test execution.
enum TestServerOutputMode {
  /// Default mode - only stderr is printed (stdout suppressed).
  /// This hides normal startup/shutdown logs while preserving error messages.
  normal,

  /// All logging - both stdout and stderr are printed.
  /// Useful for debugging when you need to see all server output.
  verbose,

  /// No logging - both stdout and stderr are suppressed.
  /// Completely silent mode, useful when you don't want any server output.
  silent,
}

/// The test closure that is called by the `withServerpod` test helper.
typedef TestClosure<T> =
    void Function(
      TestSessionBuilder testSession,
      T endpoints,
    );

/// The default integration test tag used by `withServerpod`.
const String defaultIntegrationTestTag = 'integration';

/// Builds the `withServerpod` test helper. Used by generated code.
///
/// Registers a `group` with `setUpAll`, `tearDown`, and `tearDownAll`
/// hooks and nothing else. Session, transaction manager, endpoint
/// wrappers, and Serverpod construction are all deferred into
/// `setUpAll`, so test-tree enumeration stays cheap and sendable
/// across isolates.
void Function(TestClosure<T>)
buildWithServerpod<T extends InternalTestEndpoints>(
  String testGroupName,
  TestServerpod<T> testServerpod, {
  required RollbackDatabase? maybeRollbackDatabase,
  required bool? maybeEnableSessionLogging,
  required List<String>? maybeTestGroupTagsOverride,
  required Duration? maybeServerpodStartTimeout,
  required TestServerOutputMode? maybeTestServerOutputMode,
}) {
  var rollbackDatabase = maybeRollbackDatabase ?? RollbackDatabase.afterEach;

  var rollbacksEnabled = rollbackDatabase != RollbackDatabase.disabled;
  if (rollbacksEnabled && !testServerpod.isDatabaseEnabled) {
    throw InitializationException(
      'Rollbacks where enabled but the database is not enabled in for this project configuration.',
    );
  }

  var startTimeout = maybeServerpodStartTimeout ?? const Duration(seconds: 30);
  var enableLogging = maybeEnableSessionLogging ?? false;

  return (
    TestClosure<T> testClosure,
  ) {
    group(
      testGroupName,
      () {
        final sessionBuilder = InternalTestSessionBuilder();
        late final InternalServerpodSession mainServerpodSession;
        late final List<InternalServerpodSession> allTestSessions;
        TransactionManager? transactionManager;

        TransactionManager getTransactionManager() {
          var localTransactionManager = transactionManager;
          if (localTransactionManager == null) {
            throw StateError(
              'The transaction manager is null.',
            );
          }

          return localTransactionManager;
        }

        setUpAll(() async {
          await testServerpod.start().timeout(
            startTimeout,
            onTimeout: () {
              throw InitializationException(
                'Serverpod did not start within the timeout of $startTimeout. '
                'This might indicate that Serverpod cannot connect to the database. '
                'Ensure that you have run `docker compose up` and check the logs for more information.',
              );
            },
          );

          mainServerpodSession = testServerpod.createSession(
            rollbackDatabase: rollbackDatabase,
          );
          if (testServerpod.isDatabaseEnabled) {
            transactionManager = mainServerpodSession.transactionManager;
            if (transactionManager == null) {
              throw InitializationException(
                'The transaction manager is null but database is enabled.',
              );
            }
          }
          allTestSessions = <InternalServerpodSession>[];
          sessionBuilder.bind(
            testServerpod: testServerpod,
            allTestSessions: allTestSessions,
            mainServerpodSession: mainServerpodSession,
            enableLogging: enableLogging,
          );

          if (rollbackDatabase == RollbackDatabase.afterAll ||
              rollbackDatabase == RollbackDatabase.afterEach) {
            var localTransactionManager = getTransactionManager();
            try {
              await localTransactionManager.createTransaction();
              await localTransactionManager.addSavepoint();
            } catch (_) {
              // A throw here can leave the transaction stack locked or a
              // half-created transaction behind. That state persists across
              // test groups because the TransactionManager is retained on
              // mainServerpodSession. Reset so the next group starts clean.
              await localTransactionManager.ensureTransactionIsUnlocked();
              rethrow;
            }
          }
        });

        tearDown(() async {
          if (rollbackDatabase == RollbackDatabase.afterEach) {
            var localTransactionManager = getTransactionManager();
            try {
              await localTransactionManager.rollbackToPreviousSavepoint();
              await localTransactionManager.addSavepoint();
            } catch (_) {
              // Unlock so the next test in the group doesn't inherit a locked
              // stack from a failed rollback/addSavepoint pair.
              await localTransactionManager.ensureTransactionIsUnlocked();
              rethrow;
            }
          }

          await (
            mainServerpodSession.caches.clear(),
            GlobalStreamManager.closeAllStreams(),
          ).wait;
        });

        tearDownAll(() async {
          // DB-touching cleanup runs first, in parallel. They may return
          // connections to the pool via rollback / session close.
          Future<void> cancelTransactionIfNeeded() async {
            if (rollbackDatabase == RollbackDatabase.afterAll ||
                rollbackDatabase == RollbackDatabase.afterEach) {
              var localTransactionManager = getTransactionManager();
              await localTransactionManager.cancelTransaction();
            }
          }

          Future<void> closeAllTestSessions() async {
            await [
              for (var testSession in allTestSessions) testSession.close(),
            ].wait;
            allTestSessions.clear();
          }

          try {
            await (cancelTransactionIfNeeded(), closeAllTestSessions()).wait;
          } catch (_) {
            // Partial state from a broken setUpAll can make these fail.
            // Not fatal - we still need shutdown to drain the pool.
          }

          // Shutdown must be sequentially last. pg.Pool.close() skips
          // connections still marked _isInUse; they dangle until returned.
          // Running shutdown in parallel with the DB cleanup above means
          // an in-flight ROLLBACK can race pool.close() and leak its
          // connection across test files, eventually hitting Postgres'
          // max_connections cap.
          await testServerpod.shutdown();
        });

        testClosure(sessionBuilder, testServerpod.testEndpoints);
      },
      tags: maybeTestGroupTagsOverride ?? [defaultIntegrationTestTag],
    );
  };
}
