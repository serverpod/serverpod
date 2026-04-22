import 'package:serverpod/serverpod.dart';

import 'test_serverpod.dart';

/// An override for the authentication state in a test session.
abstract class AuthenticationOverride {
  /// Sets the session to be authenticated with the provided [userIdentifier] and [scopes].
  ///
  /// If [authId] is not provided, a new UUID will be generated.
  static AuthenticationOverride authenticationInfo(
    String userIdentifier,
    Set<Scope> scopes, {
    String? authId,
  }) => _AuthenticationInfoOverride(
    userIdentifier,
    scopes,
    authId: authId ?? const Uuid().v4().toString(),
  );

  /// Sets the session to be unauthenticated. This is the default.
  static AuthenticationOverride unauthenticated() => _Unauthenticated();
}

/// Internal test session that contains implementation details that should
/// only be used internally by the test tools.
///
/// Construct, then call [bind] before any other method. Methods called
/// before [bind] throw [LateInitializationError].
class InternalTestSessionBuilder extends TestSessionBuilder {
  late final List<InternalServerpodSession> _allTestSessions;
  late final TestServerpod _testServerpod;
  late final AuthenticationOverride? _authenticationOverride;
  late final bool _enableLogging;
  late final InternalServerpodSession _mainServerpodSession;

  /// Populates the builder's state. Can only be called once.
  void bind({
    required TestServerpod testServerpod,
    required List<InternalServerpodSession> allTestSessions,
    required InternalServerpodSession mainServerpodSession,
    required bool enableLogging,
    AuthenticationOverride? authenticationOverride,
  }) {
    _testServerpod = testServerpod;
    _allTestSessions = allTestSessions;
    _mainServerpodSession = mainServerpodSession;
    _enableLogging = enableLogging;
    _authenticationOverride = authenticationOverride;
  }

  @override
  Session build() => internalBuild();

  @override
  TestSessionBuilder copyWith({
    AuthenticationOverride? authentication,
    bool? enableLogging,
  }) => InternalTestSessionBuilder()
    ..bind(
      testServerpod: _testServerpod,
      allTestSessions: _allTestSessions,
      mainServerpodSession: _mainServerpodSession,
      enableLogging: enableLogging ?? _enableLogging,
      authenticationOverride: authentication ?? _authenticationOverride,
    );

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
    String userIdentifier,
    Set<Scope> scopes, {
    required String authId,
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
