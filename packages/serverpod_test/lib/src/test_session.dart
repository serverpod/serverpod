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

  /// Sets the underlying Serverpod session and configures it.
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
  /// and recreates the underlying Serverpod session.
  Future<void> resetState() async {
    await serverpodSession.close();
    _authenticationInfo = null;
    var newServerpodSession = await _testServerpod.createSession();
    setAndConfigureServerpodSession(newServerpodSession);
  }

  /// Destroys the test session and closes the underlying Serverpod session.
  Future<void> destroy() async {
    await serverpodSession.close();
    _authenticationInfo = null;
  }
}
