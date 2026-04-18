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
  // Every group runs against its own database, so `RollbackDatabase` only
  // decides the transaction strategy within that database: afterEach/afterAll
  // wrap a transaction that is rolled back; disabled commits for real (the
  // database is dropped when the group finishes).
  var rollbackDatabase = maybeRollbackDatabase ?? RollbackDatabase.afterEach;

  var rollbacksEnabled = rollbackDatabase != RollbackDatabase.disabled;
  if (rollbacksEnabled && !testServerpod.isDatabaseEnabled) {
    throw InitializationException(
      'Rollbacks where enabled but the database is not enabled in for this project configuration.',
    );
  }

  var startTimeout = maybeServerpodStartTimeout ?? const Duration(seconds: 120);
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
        // Assigned in setUpAll whenever the database is enabled, which
        // `rollbacksEnabled` already guarantees for every read below.
        late final TransactionManager transactionManager;

        setUpAll(() async {
          await testServerpod.start().timeout(
            startTimeout,
            onTimeout: () {
              throw InitializationException(
                'Serverpod did not start within the timeout of $startTimeout. '
                'This might indicate that Serverpod cannot connect to the database.',
              );
            },
          );

          mainServerpodSession = testServerpod.createSession(
            rollbackDatabase: rollbackDatabase,
          );
          if (testServerpod.isDatabaseEnabled) {
            var localTransactionManager =
                mainServerpodSession.transactionManager;
            if (localTransactionManager == null) {
              throw InitializationException(
                'The transaction manager is null but database is enabled.',
              );
            }
            transactionManager = localTransactionManager;
          }
          allTestSessions = <InternalServerpodSession>[];
          sessionBuilder.bind(
            testServerpod: testServerpod,
            allTestSessions: allTestSessions,
            mainServerpodSession: mainServerpodSession,
            enableLogging: enableLogging,
          );

          // A throw here skips the group's tests, but tearDownAll still runs
          // and drops the database. No unlock needed - this TransactionManager
          // dies with the group's session.
          if (rollbacksEnabled) {
            await transactionManager.createTransaction();
            await transactionManager.addSavepoint();
          }
        });

        tearDown(() async {
          if (rollbackDatabase == RollbackDatabase.afterEach) {
            try {
              await transactionManager.rollbackToPreviousSavepoint();
              await transactionManager.addSavepoint();
            } catch (_) {
              // A half-applied pair leaves the stack locked, failing every
              // later addSavepoint with ConcurrentTransactionsException.
              await transactionManager.ensureTransactionIsUnlocked();
              rethrow;
            }
          }

          await (
            mainServerpodSession.caches.clear(),
            GlobalStreamManager.closeAllStreams(),
          ).wait;
        });

        tearDownAll(() async {
          // DB-touching cleanup runs first, in parallel; both return
          // connections to the pool.
          Future<void> cancelTransactionIfNeeded() async {
            if (rollbacksEnabled) {
              await transactionManager.cancelTransaction();
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
            // Swallowed rather than `finally`: a broken setUpAll leaves this
            // state half-built, and rethrowing would report the resulting
            // cascade as a second failure on top of the real one.
          }

          // Must run after, not alongside, the cleanup above: pg.Pool.close()
          // skips connections still marked _isInUse, so a racing in-flight
          // ROLLBACK leaks its connection until max_connections is hit.
          await testServerpod.shutdown();
        });

        testClosure(sessionBuilder, testServerpod.testEndpoints);
      },
      tags: maybeTestGroupTagsOverride ?? [defaultIntegrationTestTag],
    );
  };
}
