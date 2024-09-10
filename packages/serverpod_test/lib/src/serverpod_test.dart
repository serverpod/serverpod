import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

export 'package:meta/meta.dart' show isTestGroup;

/// A test specific session that is used to call database methods or pass to endpoints.
abstract class TestSession implements DatabaseAccessor {
  /// AuthenticationInfo for the session.
  AuthenticationInfo? get authenticationInfo;

  /// Creates a new unique session with the provided properties.
  /// This is useful for setting up different session states in the tests
  /// or simulating multiple users.
  Future<TestSession> copyWith({
    AuthenticationInfo? Function()? getAuthenticationInfo,
    bool? enableLogging,
  });
}

/// Internal test session that contains implementation details that should
/// only be used internally by the test tools.
class InternalTestSession extends TestSession {
  final List<InternalTestSession> _allTestSessions;
  final TestServerpod _testServerpod;
  AuthenticationInfo? _authenticationInfo;
  final bool _enableLogging;

  /// The underlaying Serverpod session
  late Session serverpodSession;

  @override
  Database get db => serverpodSession.db;

  @override
  AuthenticationInfo? get authenticationInfo => _authenticationInfo;

  @override
  Transaction? transaction;

  /// Creates a new internal test session.
  InternalTestSession(
    TestServerpod testServerpod, {
    AuthenticationInfo? authenticationInfo,
    InternalTestSession? sessionWithDatabaseConnection,
    this.transaction,
    required bool enableLogging,
    required List<InternalTestSession> allTestSessions,
  })  : _allTestSessions = allTestSessions,
        _authenticationInfo = authenticationInfo,
        _testServerpod = testServerpod,
        _enableLogging = enableLogging {
    _allTestSessions.add(this);
  }

  /// Sets the underlaying Serverpod session and configures it.
  /// This is needed to enable the creation of the InternalTestSession before
  /// the Serverpod session is created.
  void setAndConfigureServerpodSession(Session session) {
    serverpodSession = session;

    serverpodSession.transaction = transaction;

    serverpodSession.updateAuthenticated(_authenticationInfo);
  }

  @override
  Future<TestSession> copyWith({
    AuthenticationInfo? Function()? getAuthenticationInfo,
    bool? enableLogging,
  }) async {
    var newSession = InternalTestSession(
      _testServerpod,
      allTestSessions: _allTestSessions,
      authenticationInfo: getAuthenticationInfo != null
          ? getAuthenticationInfo()
          : _authenticationInfo,
      enableLogging: enableLogging ?? _enableLogging,
      transaction: transaction,
    );
    var newServerpodSession = await _testServerpod.createSession(
      enableLogging: enableLogging ?? _enableLogging,
    );

    newSession.setAndConfigureServerpodSession(newServerpodSession);

    return newSession;
  }

  /// Resets the internal state of the test session
  /// and recreates the underlaying Serverpod session.
  Future<void> resetState() async {
    await serverpodSession.close();
    _authenticationInfo = null;
    var newServerpodSession = await _testServerpod.createSession();
    setAndConfigureServerpodSession(newServerpodSession);
  }

  /// Destroys the test session and closes the underlaying Serverpod session.
  Future<void> destroy() async {
    await serverpodSession.close();
    _authenticationInfo = null;
  }
}

/// Internal test endpoints interface that contains implementation details
/// that should only be used internally by the test tools.
abstract interface class InternalTestEndpoints {
  /// Initializes the endpoints.
  void initialize(
    SerializationManagerServer serializationManager,
    EndpointDispatch endpoints,
  );
}

/// A facade for the real Serverpod instance.
class TestServerpod<T extends InternalTestEndpoints> {
  /// The test endpoints that are exposed to the user.
  T testEndpoints;

  final Serverpod _serverpod;

  /// Creates a new test serverpod instance.
  TestServerpod({
    required this.testEndpoints,
    required SerializationManagerServer serializationManager,
    required EndpointDispatch endpoints,
    String? runMode,
  }) : _serverpod = Serverpod(
          ['-m', runMode ?? ServerpodRunMode.test],
          serializationManager,
          endpoints,
        ) {
    endpoints.initializeEndpoints(_serverpod.server);
    testEndpoints.initialize(serializationManager, endpoints);
  }

  /// Starts the underlaying serverpod instance.
  Future<void> start() async {
    await _serverpod.start();
  }

  /// Shuts down the underlaying serverpod instance.
  Future<void> shutdown() async {
    return _serverpod.shutdown(exitProcess: false);
  }

  /// Creates a new Serverpod session.
  Future<Session> createSession({bool enableLogging = false}) async {
    return _serverpod.createSession(enableLogging: enableLogging);
  }
}

/// Options for when to reset the test session and recreate
/// the underlaying Serverpod session during the test lifecycle.
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
/// Used by the genearated code.
void Function(TestClosure<T>)
    buildWithServerpod<T extends InternalTestEndpoints>(
  TestServerpod<T> testServerpod, {
  ResetTestSessions? maybeResetTestSessions,
  RollbackDatabase? maybeRollbackDatabase,
  bool? maybeEnableSessionLogging,
}) {
  var resetTestSessions = maybeResetTestSessions ?? ResetTestSessions.afterEach;
  var rollbackDatabase = maybeRollbackDatabase ?? RollbackDatabase.afterEach;
  List<InternalTestSession> allTestSessions = [];
  late _TransactionManager transactionManager;

  return (
    TestClosure<T> testClosure,
  ) {
    const groupDescriptionWithSingleSpaceToEnableIDESupport = ' ';
    group(groupDescriptionWithSingleSpaceToEnableIDESupport, () {
      InternalTestSession mainTestSession = InternalTestSession(
        testServerpod,
        allTestSessions: allTestSessions,
        enableLogging: maybeEnableSessionLogging ?? false,
      );

      setUpAll(() async {
        await testServerpod.start();
        var serverpodSession = await testServerpod.createSession();
        transactionManager = _TransactionManager(serverpodSession);

        if (rollbackDatabase == RollbackDatabase.afterAll ||
            rollbackDatabase == RollbackDatabase.afterEach) {
          mainTestSession.transaction =
              await transactionManager.createTransaction();
          await transactionManager.pushSavePoint();
        }

        mainTestSession.setAndConfigureServerpodSession(serverpodSession);
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

class _TransactionManager {
  final List<String> _savePointIds = [];

  Transaction? _transaction;

  late Completer _endTransactionScopeCompleter;

  late Session serverpodSession;

  _TransactionManager(this.serverpodSession);

  Future<Transaction> createTransaction() async {
    if (_transaction != null) {
      throw StateError('Transaction already exists.');
    }

    _endTransactionScopeCompleter = Completer();
    var transactionStartedCompleter = Completer();
    late Transaction localTransaction;

    unawaited(
      serverpodSession.db.transaction((newTransaction) async {
        localTransaction = newTransaction;

        transactionStartedCompleter.complete();

        await _endTransactionScopeCompleter.future
            .timeout(const Duration(seconds: 60), onTimeout: () async {
          await newTransaction.cancel();
        });
      }),
    );

    await transactionStartedCompleter.future;

    _transaction = localTransaction;

    return localTransaction;
  }

  Future<void> cancelTransaction() async {
    var localTransaction = _transaction;
    if (localTransaction == null) {
      throw StateError('No ongoing transaction.');
    }

    await localTransaction.cancel();
    _endTransactionScopeCompleter.complete();
    _transaction = null;
  }

  Future<void> pushSavePoint() async {
    if (_transaction == null) {
      throw StateError('No ongoing transaction.');
    }

    var savePointId = _getNextSavePointId();
    _savePointIds.add(savePointId);

    await serverpodSession.db.unsafeExecute(
      'SAVEPOINT $savePointId;',
      transaction: _transaction,
    );
  }

  String _getNextSavePointId() {
    var postgresCompatibleRandomString =
        const Uuid().v4obj().toString().replaceAll(RegExp(r'-'), '_');
    var savePointId = 'savepoint_$postgresCompatibleRandomString';

    return savePointId;
  }

  Future<void> popSavePoint() async {
    if (_transaction == null) {
      throw StateError('No ongoing transaction.');
    }

    if (_savePointIds.isEmpty) {
      throw StateError('No previous savepoint to rollback to.');
    }

    await serverpodSession.db.unsafeExecute(
      'ROLLBACK TO SAVEPOINT ${_savePointIds.removeLast()};',
      transaction: _transaction,
    );
  }
}

/// Test tools helper to not leak exceptions from awaitable functions.
/// Used by the generated code.
Future<T> callAwaitableFunctionAndHandleExceptions<T>(
  Future<T> Function() call,
) async {
  try {
    return await call();
  } catch (e) {
    throw _getException(e);
  }
}

/// Test tools helper to not leak exceptions from functions that return streams.
/// Used by the generated code.
Future<void> callStreamFunctionAndHandleExceptions<T>(
  Future<Stream<T>> Function() call,
  StreamController<T> streamController,
) async {
  late Stream<T> stream;
  try {
    stream = await call();
  } catch (e) {
    streamController.addError(_getException(e));
    return;
  }

  var subscription = stream.listen((data) {
    streamController.add(data);
  }, onError: (e) {
    streamController.addError(_getException(e));
  }, onDone: () {
    streamController.close();
  });

  streamController.onCancel = () {
    subscription.cancel();
  };
}

/// The user was not authenticated.
class UnauthenticatedEndpointCallTestException implements Exception {
  /// Creates a new UnauthenticatedEndpointCallTestException.
  UnauthenticatedEndpointCallTestException();
}

/// The authentication key provided did not have sufficient access.
class InsufficientEndpointAccessTestException implements Exception {
  /// Creates a new InsufficientEndpointAccessTestException.
  InsufficientEndpointAccessTestException();
}

dynamic _getException(dynamic e) {
  switch (e) {
    case NotAuthorizedException():
      return switch (e.authenticationFailedResult.reason) {
        AuthenticationFailureReason.unauthenticated =>
          UnauthenticatedEndpointCallTestException(),
        AuthenticationFailureReason.insufficientAccess =>
          InsufficientEndpointAccessTestException(),
      };
    case MethodNotFoundException():
    case EndpointNotFoundException():
    case InvalidParametersException():
    case InvalidEndpointMethodTypeException():
      return StateError(
        'An unexpected error occured while trying to call the endpoint in the test. '
        'Make sure you have run the `serverpod generate` command.\n ${StackTrace.current}',
      );
    default:
      return e;
  }
}
