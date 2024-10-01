import 'package:serverpod/serverpod.dart';

import 'test_serverpod.dart';

/// An override for the authentication state in a test session.
abstract class AuthenticationOverride {
  /// Sets the session to be unauthenticated. This is the default.
  static AuthenticationOverride unauthenticated() => _Unauthenticated();

  /// Sets the session to be authenticated with the provided userId and scope.
  static AuthenticationOverride authenticationInfo(
          int userId, Set<Scope> scopes,
          {String? authId}) =>
      _AuthenticationInfoOverride(userId, scopes, authId: authId);
}

/// Overrides the authenticationInfo on the session. This will bypass any auth handlers.
class _AuthenticationInfoOverride extends AuthenticationOverride {
  final AuthenticationInfo _authenticationInfo;

  /// The authentication info to use for the session.
  AuthenticationInfo get authenticationInfo => _authenticationInfo;

  /// Creates a new AuthenticationInfoOverride with the provided authentication info.
  _AuthenticationInfoOverride(int userId, Set<Scope> scopes, {String? authId})
      : _authenticationInfo =
            AuthenticationInfo(userId, scopes, authId: authId);
}

/// Does not override the authentication state in the session.
class _Unauthenticated extends AuthenticationOverride {}

/// A test specific session that is used to call database methods or pass to endpoints.
/// This is the public interface exposed to developers.
abstract class TestSession implements DatabaseAccessor {
  /// AuthenticationInfo for the session.
  Future<AuthenticationInfo?> get authenticationInfo;

  /// Access to the message central
  MessageCentralAccess get messages;

  /// Creates a new unique session with the provided properties.
  /// This is useful for setting up different session states in the tests
  /// or simulating multiple users.
  TestSession copyWith({
    AuthenticationOverride? authentication,
    bool? enableLogging,
  });
}

/// Internal test session that contains implementation details that should
/// only be used internally by the test tools.
class InternalTestSession extends TestSession {
  final List<InternalTestSession> _allTestSessions;
  final TestServerpod _testServerpod;
  AuthenticationOverride? _authenticationOverride;
  final bool _enableLogging;

  /// The underlying Serverpod session
  InternalServerpodSession serverpodSession;

  @override
  Database get db => serverpodSession.db;

  @override
  Future<AuthenticationInfo?> get authenticationInfo async {
    return serverpodSession.authenticated;
  }

  @override
  MessageCentralAccess get messages => serverpodSession.messages;

  @override
  Transaction? get transaction =>
      serverpodSession.transactionManager.currentTransaction;

  /// Creates a new internal test session.
  InternalTestSession(
    TestServerpod testServerpod, {
    AuthenticationOverride? authenticationOverride,
    InternalTestSession? sessionWithDatabaseConnection,
    required bool enableLogging,
    required List<InternalTestSession> allTestSessions,
    required this.serverpodSession,
  })  : _allTestSessions = allTestSessions,
        _authenticationOverride = authenticationOverride,
        _testServerpod = testServerpod,
        _enableLogging = enableLogging {
    _allTestSessions.add(this);
    _configureServerpodSession(serverpodSession);
  }

  @override
  TestSession copyWith({
    AuthenticationOverride? authentication,
    bool? enableLogging,
    String endpoint = '',
    String method = '',
  }) {
    var newServerpodSession = _testServerpod.createSession(
      enableLogging: enableLogging ?? _enableLogging,
      endpoint: endpoint,
      method: method,
      rollbackDatabase: serverpodSession.rollbackDatabase,
      transactionManager: serverpodSession.transactionManager,
    );

    return InternalTestSession(
      _testServerpod,
      allTestSessions: _allTestSessions,
      authenticationOverride: authentication ?? _authenticationOverride,
      enableLogging: enableLogging ?? _enableLogging,
      serverpodSession: newServerpodSession,
    );
  }

  void _configureServerpodSession(InternalServerpodSession session) {
    var authenticationOverride = _authenticationOverride;
    if (authenticationOverride is _AuthenticationInfoOverride) {
      session.updateAuthenticated(authenticationOverride.authenticationInfo);
    }
  }

  /// Resets the internal state of the test session
  /// and recreates the underlying Serverpod session.
  Future<void> resetState() async {
    await serverpodSession.close();
    _authenticationOverride = null;
    serverpodSession = _testServerpod.createSession(
      enableLogging: _enableLogging,
      rollbackDatabase: serverpodSession.rollbackDatabase,
      transactionManager: serverpodSession.transactionManager,
    );
    _configureServerpodSession(serverpodSession);
  }

  /// Destroys the test session and closes the underlying Serverpod session.
  Future<void> destroy() async {
    await serverpodSession.close();
    _authenticationOverride = null;
  }
}
