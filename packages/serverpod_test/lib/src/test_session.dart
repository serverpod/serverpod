import 'package:serverpod/serverpod.dart';

import 'test_serverpod.dart';

/// A test specific session that is used to call database methods or pass to endpoints.
/// This is the public interface exposed to developers.
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

  /// The underlying Serverpod session
  InternalServerpodSession serverpodSession;

  @override
  Database get db => serverpodSession.db;

  @override
  AuthenticationInfo? get authenticationInfo => _authenticationInfo;

  Transaction? _transaction;
  @override
  Transaction? get transaction => _transaction;

  set transaction(Transaction? transaction) {
    _transaction = transaction;
    serverpodSession.transaction = transaction;
  }

  /// Creates a new internal test session.
  InternalTestSession(
    TestServerpod testServerpod, {
    AuthenticationInfo? authenticationInfo,
    InternalTestSession? sessionWithDatabaseConnection,
    Transaction? transaction,
    required bool enableLogging,
    required List<InternalTestSession> allTestSessions,
    required this.serverpodSession,
  })  : _allTestSessions = allTestSessions,
        _authenticationInfo = authenticationInfo,
        _testServerpod = testServerpod,
        _enableLogging = enableLogging,
        _transaction = transaction {
    _allTestSessions.add(this);
    _configureServerpodSession(serverpodSession);
  }

  @override
  Future<TestSession> copyWith({
    AuthenticationInfo? Function()? getAuthenticationInfo,
    bool? enableLogging,
    String endpoint = '',
    String method = '',
  }) async {
    var newServerpodSession = _testServerpod.createSession(
      enableLogging: enableLogging ?? _enableLogging,
      transaction: transaction,
      endpoint: endpoint,
      method: method,
    );

    return InternalTestSession(
      _testServerpod,
      allTestSessions: _allTestSessions,
      authenticationInfo: getAuthenticationInfo != null
          ? getAuthenticationInfo()
          : _authenticationInfo,
      enableLogging: enableLogging ?? _enableLogging,
      transaction: transaction,
      serverpodSession: newServerpodSession,
    );
  }

  void _configureServerpodSession(InternalServerpodSession session) {
    session.updateAuthenticated(_authenticationInfo);
  }

  /// Resets the internal state of the test session
  /// and recreates the underlying Serverpod session.
  Future<void> resetState() async {
    await serverpodSession.close();
    _authenticationInfo = null;
    serverpodSession = _testServerpod.createSession(
      transaction: _transaction,
      enableLogging: _enableLogging,
    );
    _configureServerpodSession(serverpodSession);
  }

  /// Destroys the test session and closes the underlying Serverpod session.
  Future<void> destroy() async {
    await serverpodSession.close();
    _authenticationInfo = null;
  }
}
