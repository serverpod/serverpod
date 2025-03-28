import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_2/additional_data.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session_repository.dart';

void main() {
  test('JWT token storage', () async {
    final ServerpodSessionExample server;
    {
      final sessionHandler = ServerSessionHandler();
      server = ServerpodSessionExample(sessionHandler);

      server.registerEndpoint<void, TokenPair>(
        'login',
        (_, __) => sessionHandler.createTokenPair(5),
      );

      server.registerEndpoint<String, TokenPair>(
        'refreshTokens',
        (_, refreshToken) => sessionHandler.refreshTokens(refreshToken),
      );

      server.registerEndpoint(
        'greetByUserId',
        (userId, _) => 'Hello #$userId!',
      );
    }

    final tokenStore = TokenBasedSessionStore();
    final client = ServerpodClientExample(
      tokenStore,
      server,
    );
    // init is a bit tricky here, but the token store needs to be able to call normal endpoints on the server
    // in practice this might be fine if the client is a global variable (TBD how this would look if the store is implemented in a package though)
    tokenStore.client = client;

    await client.login();

    expect(
      await client._sessionStore.getSessionKey(),
      isNotNull,
    );

    final greeting = await client.getGreeting();

    expect(greeting, 'Hello #5!');
  });
}

typedef TokenPair = ({String refreshToken, String accessToken});

class TokenBasedSessionStore implements SessionStore {
  TokenPair? _tokens;

  late final ServerpodClientExample client;

  void setTokens(TokenPair? tokens) {
    _tokens = tokens;
  }

  @override
  Future<String?> getSessionKey() async {
    // this pattern would need to be adapted to handle concurrent requests.
    // E.g. it needs to hold "normal" API calls with the access token, but allow token refresh calls as well as (some) unauthenticated calls like "login" (to get a new session)
    // In practice I have only ever seen this with a list of "special APIs" and then custom logic for those, so maybe we need to pass in some module/method name here
    if (_isRefreshing) {
      return null;
    }
    if (_tokens == null) {
      return null;
    }
    if (_isAccessTokenExpired()) {
      await _refreshTokens();
    }

    return _tokens!.accessToken;
  }

  bool _isAccessTokenExpired() {
    // in this example it always causes a refresh call to be made, usually this would just check the `exp` on the JWT
    return true;
  }

  bool _isRefreshing = false;

  Future<void> _refreshTokens() async {
    // in practices this would call into a custom "refresh tokens" endpoint to get a new pair of tokens
    try {
      _isRefreshing = true;
      _tokens = await client.refreshTokens(_tokens!.refreshToken);
      _isRefreshing = false;
    } finally {
      _isRefreshing = false;
    }
  }
}

class ServerSessionHandler implements SessionRepository {
  var _userIdsByRefreshToken = <String, int>{};

  // typed variant of `createSession`, which the server can use if they implement the login endpoints themselves
  // for a fully-typed stack. else they would have to resort to the String-typed createSession as the common interface
  TokenPair createTokenPair(int userId) {
    final refreshToken =
        'refresh_${DateTime.now().microsecondsSinceEpoch.toString()}';

    _userIdsByRefreshToken[refreshToken] = userId;

    return (refreshToken: refreshToken, accessToken: 'access:$userId');
  }

  @override
  String createSession(
    int userId, {
    required String authProvider,
    required AdditionalData? additionalData,
  }) {
    final tokenPair = createTokenPair(userId);

    return jsonEncode({
      'refreshToken': tokenPair.refreshToken,
      'accessToken': tokenPair.accessToken,
    });
  }

  @override
  int resolveSessionToUserId(String sessionKey) {
    // access tokens look like 'access:$userId' for this demo (in practice they'd be signed and expiring)
    return int.parse(sessionKey.split(':')[1]);
  }

  @override
  void revokeAllSessionsForUser(int userId) {
    _userIdsByRefreshToken.removeWhere((_, id) => id == userId);
  }

  @override
  void revokeSession(String sessionKey) {
    // logouts would have to happen with a reference to the refresh token to close the session, and then still the access token would work until expiry
    throw 'An individual access token can not be removed';
  }

  // Additional functionality provided by this session handler type. Developer would need to expose this in an endpoint
  TokenPair refreshTokens(String refreshToken) {
    final userId = _userIdsByRefreshToken.remove(refreshToken)!;

    return createTokenPair(userId);
  }
}

// Client
class ServerpodClientExample {
  ServerpodClientExample(
    this._sessionStore,
    this._server,
  );

  final TokenBasedSessionStore _sessionStore;

  final ServerpodSessionExample _server;

  Future<R> _callEndpoint<P, R>(String methodName, P parameter) async {
    final sessionKey = await _sessionStore.getSessionKey();

    return _server.callEndpoint(methodName, sessionKey, parameter);
  }

  Future<void> login() async {
    final sessionKey = await _callEndpoint('login', null);

    // post login, the client will have to set the session key themselves
    _sessionStore.setTokens(sessionKey);
  }

  Future<String> getGreeting() async {
    return _callEndpoint('greetByUserId', null);
  }

  Future<TokenPair> refreshTokens(String refreshToken) {
    return _callEndpoint('refreshTokens', refreshToken);
  }
}

// Server endpoint (aggregrate)
class ServerpodSessionExample {
  ServerpodSessionExample(this._sessionHandler);

  final ServerSessionHandler _sessionHandler;

  final _methods = <String, dynamic Function(int? userId, dynamic parameter)>{};

  void registerEndpoint<P, R>(
    String methodName,
    R Function(int? userId, P param) func,
  ) {
    _methods[methodName] = (userId, param) => func(userId, param);
  }

  R callEndpoint<P, R>(String methodName, String? sessionKey, P parameter) {
    return _methods[methodName]!(
      sessionKey == null
          ? null
          : _sessionHandler.resolveSessionToUserId(sessionKey),
      parameter,
    );
  }
}
