import 'package:serverpod/serverpod.dart';

import 'test_serverpod.dart';

/// An override for the authentication state in a test session.
abstract class AuthenticationOverride {
  /// Sets the session to be authenticated with the provided [userIdentifier] and [scopes].
  static AuthenticationOverride authenticationInfo(
    Object userIdentifier,
    Set<Scope> scopes, {
    String? authId,
  }) =>
      _AuthenticationInfoOverride(userIdentifier, scopes, authId: authId);

  /// Sets the session to be unauthenticated. This is the default.
  static AuthenticationOverride unauthenticated() => _Unauthenticated();
}

/// Internal test session that contains implementation details that should
/// only be used internally by the test tools.
class InternalTestSessionBuilder extends TestSessionBuilder {
  final List<InternalServerpodSession> _allTestSessions;
  final TestServerpod _testServerpod;
  final AuthenticationOverride? _authenticationOverride;
  final bool _enableLogging;
  final InternalServerpodSession _mainServerpodSession;

  /// Creates a new internal test session.
  InternalTestSessionBuilder(
    TestServerpod testServerpod, {
    AuthenticationOverride? authenticationOverride,
    InternalTestSessionBuilder? sessionWithDatabaseConnection,
    required bool enableLogging,
    required List<InternalServerpodSession> allTestSessions,
    required InternalServerpodSession mainServerpodSession,
  })  : _allTestSessions = allTestSessions,
        _authenticationOverride = authenticationOverride,
        _testServerpod = testServerpod,
        _enableLogging = enableLogging,
        _mainServerpodSession = mainServerpodSession;

  @override
  Session build() {
    return internalBuild();
  }

  @override
  TestSessionBuilder copyWith({
    AuthenticationOverride? authentication,
    bool? enableLogging,
  }) {
    return InternalTestSessionBuilder(
      _testServerpod,
      allTestSessions: _allTestSessions,
      authenticationOverride: authentication ?? _authenticationOverride,
      enableLogging: enableLogging ?? _enableLogging,
      mainServerpodSession: _mainServerpodSession,
    );
  }

  /// Creates a new Serverpod session with the specified [endpoint] and [method].
  /// Should only be used by generated code.
  Session internalBuild({
    String endpoint = '<not applicable: created by user in test>',
    String method = '<not applicable: created by user in test>',
  }) {
    var newServerpodSession = _testServerpod.createSession(
      enableLogging: _enableLogging,
      endpoint: endpoint,
      method: method,
      rollbackDatabase: _mainServerpodSession.rollbackDatabase,
      transactionManager: _mainServerpodSession.transactionManager,
    );

    _allTestSessions.add(newServerpodSession);

    _configureServerpodSession(newServerpodSession);

    return newServerpodSession;
  }

  void _configureServerpodSession(InternalServerpodSession session) {
    var authenticationOverride = _authenticationOverride;
    if (authenticationOverride is _AuthenticationInfoOverride) {
      session.updateAuthenticated(authenticationOverride.authenticationInfo);
    }
  }
}

/// A test specific builder to create a [Session] that for instance can be used to call database methods.
/// The builder can also be passed to endpoint calls. The builder will create a new session for each call.
abstract class TestSessionBuilder {
  /// Given the properties set on the session through the `copyWith` method,
  /// this returns a serverpod [Session] that has the configured state.
  Session build();

  /// Creates a new unique session with the provided properties.
  /// This is useful for setting up different session states in the tests
  /// or simulating multiple users.
  TestSessionBuilder copyWith({
    AuthenticationOverride? authentication,
    bool? enableLogging,
  });
}

/// Overrides the authenticationInfo on the session. This will bypass any auth handlers.
class _AuthenticationInfoOverride extends AuthenticationOverride {
  final AuthenticationInfo _authenticationInfo;

  /// Creates a new AuthenticationInfoOverride with the provided authentication info.
  _AuthenticationInfoOverride(
    Object userIdentifier,
    Set<Scope> scopes, {
    String? authId,
  }) : _authenticationInfo = AuthenticationInfo(
          userIdentifier,
          scopes,
          authId: authId,
        );

  /// The authentication info to use for the session.
  AuthenticationInfo get authenticationInfo => _authenticationInfo;
}

/// Does not override the authentication state in the session.
class _Unauthenticated extends AuthenticationOverride {}
