import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

void main() {
  final jwtConfig = JwtConfig(
    algorithm: JwtAlgorithm.hmacSha512(
      SecretKey('test-private-key-for-HS512'),
    ),
    refreshTokenHashPepper: 'test-pepper',
    refreshTokenLifetime: const Duration(days: 14),
  );

  group('Given a cookie-mode JWT session,', () {
    late _FakeJwt jwt;
    late _TestRefreshJwtTokensEndpoint refreshEndpoint;
    late _FakeSession session;
    late UuidValue authUserId;

    setUp(() {
      authUserId = const Uuid().v4obj();
      jwt = _FakeJwt(
        config: jwtConfig,
        createTokensResult: _authSuccess(
          authUserId: authUserId,
          token: 'access-token',
          refreshToken: 'refresh-token',
        ),
        refreshAccessTokenResult: _authSuccess(
          authUserId: authUserId,
          token: 'rotated-access-token',
          refreshToken: 'rotated-refresh-token',
        ),
      );
      refreshEndpoint = _TestRefreshJwtTokensEndpoint(jwt);
      session = _FakeSession(
        config: _serverpodConfig(),
        request: _request(marker: true),
        refreshEndpoint: refreshEndpoint,
      );
    });

    test(
      'when JwtTokenManager issues a token, '
      'then the refresh token is set as a cookie and removed from the body.',
      () async {
        final tokenManager = JwtTokenManager(config: jwtConfig, jwt: jwt);

        final authSuccess = await tokenManager.issueToken(
          session,
          authUserId: authUserId,
          method: 'test',
        );

        expect(authSuccess.token, 'access-token');
        expect(authSuccess.refreshToken, isNull);
        expect(session.responseCookies, hasLength(1));
        expect(session.responseCookies.single.name, 'auth_refresh');
        expect(session.responseCookies.single.value, 'refresh-token');
        expect(
          session.responseCookies.single.maxAge,
          jwtConfig.refreshTokenLifetime.inSeconds,
        );
        // Path-scoped to the registered refresh endpoint's route, so the
        // browser only attaches the refresh token there.
        expect(session.responseCookies.single.path?.toString(), '/jwtRefresh');
      },
    );

    test(
      'when JwtTokenManager issues a token for a client behind a URL prefix '
      '(declared via the base-path header), then the refresh cookie path '
      'includes the prefix.',
      () async {
        session = _FakeSession(
          config: _serverpodConfig(),
          request: _request(marker: true, basePath: '/api'),
          refreshEndpoint: refreshEndpoint,
        );
        final tokenManager = JwtTokenManager(config: jwtConfig, jwt: jwt);

        await tokenManager.issueToken(
          session,
          authUserId: authUserId,
          method: 'test',
        );

        expect(
          session.responseCookies.single.path?.toString(),
          '/api/jwtRefresh',
        );
      },
    );

    test(
      'when JwtTokenManager issues a token on a server without a registered '
      'refresh endpoint, then the refresh cookie falls back to the configured '
      'path.',
      () async {
        session = _FakeSession(
          config: _serverpodConfig(),
          request: _request(marker: true),
          refreshEndpoint: null,
        );
        final tokenManager = JwtTokenManager(config: jwtConfig, jwt: jwt);

        await tokenManager.issueToken(
          session,
          authUserId: authUserId,
          method: 'test',
        );

        expect(session.responseCookies.single.path?.toString(), '/');
      },
    );

    test(
      'when RefreshJwtTokensEndpoint refreshes from a cookie, '
      'then the rotated refresh token is set as a cookie and removed from the body.',
      () async {
        session = _FakeSession(
          config: _serverpodConfig(),
          request: _request(
            marker: true,
            cookieHeader: 'auth_refresh=refresh-token',
          ),
          refreshEndpoint: refreshEndpoint,
        );

        final authSuccess = await refreshEndpoint.refreshAccessToken(session);

        expect(jwt.receivedRefreshTokens, ['refresh-token']);
        expect(authSuccess.token, 'rotated-access-token');
        expect(authSuccess.refreshToken, isNull);
        expect(session.responseCookies, hasLength(1));
        expect(session.responseCookies.single.name, 'auth_refresh');
        expect(session.responseCookies.single.value, 'rotated-refresh-token');
        expect(session.responseCookies.single.path?.toString(), '/jwtRefresh');
      },
    );

    test(
      'when RefreshJwtTokensEndpoint refreshes from an explicit token, '
      'then the rotated refresh token is returned in the body.',
      () async {
        session = _FakeSession(
          config: _serverpodConfig(),
          request: _request(marker: false),
        );
        final endpoint = _TestRefreshJwtTokensEndpoint(jwt);

        final authSuccess = await endpoint.refreshAccessToken(
          session,
          refreshToken: 'refresh-token',
        );

        expect(jwt.receivedRefreshTokens, ['refresh-token']);
        expect(authSuccess.token, 'rotated-access-token');
        expect(authSuccess.refreshToken, 'rotated-refresh-token');
        expect(session.responseCookies, isEmpty);
      },
    );

    test(
      'when RefreshJwtTokensEndpoint has no explicit token or cookie, '
      'then it throws RefreshTokenNotFoundException.',
      () async {
        session = _FakeSession(
          config: _serverpodConfig(),
          request: _request(marker: true),
        );
        final endpoint = _TestRefreshJwtTokensEndpoint(jwt);

        await expectLater(
          endpoint.refreshAccessToken(session),
          throwsA(isA<RefreshTokenNotFoundException>()),
        );
      },
    );
  });
}

AuthSuccess _authSuccess({
  required final UuidValue authUserId,
  required final String token,
  required final String? refreshToken,
}) {
  return AuthSuccess(
    authStrategy: AuthStrategy.jwt.name,
    token: token,
    refreshToken: refreshToken,
    authUserId: authUserId,
    scopeNames: const {},
  );
}

ServerpodConfig _serverpodConfig() {
  return ServerpodConfig(
    apiServer: ServerConfig(
      port: 8080,
      publicHost: 'localhost',
      publicPort: 8080,
      publicScheme: 'http',
    ),
    allowedOrigins: const ['https://app.example.com'],
    authCookie: const WebAuthCookieConfig(
      name: 'auth',
      refreshName: 'auth_refresh',
    ),
  );
}

Request _request({
  required final bool marker,
  final String? cookieHeader,
  final String? basePath,
}) {
  return RequestInternal.create(
    Method.post,
    Uri.parse('http://localhost/test'),
    Object(),
    headers: Headers.build((final headers) {
      if (marker) {
        headers[webAuthModeHeaderName] = [webAuthModeCookie];
      }
      if (cookieHeader != null) {
        headers['cookie'] = [cookieHeader];
      }
      if (basePath != null) {
        headers[webBasePathHeaderName] = [basePath];
      }
    }),
  );
}

class _FakeSession implements Session {
  _FakeSession({
    required final ServerpodConfig config,
    required this.request,
    final Endpoint? refreshEndpoint,
  }) : _serverpod = _FakeServerpod(config),
       _server = _FakeServer(refreshEndpoint);

  final _FakeServerpod _serverpod;
  final _FakeServer _server;

  final responseCookies = <SetCookie>[];

  @override
  final Request? request;

  @override
  Serverpod get serverpod => _serverpod;

  @override
  Server get server => _server;

  @override
  void setResponseCookie(final SetCookie cookie) {
    responseCookies.add(cookie);
  }

  @override
  dynamic noSuchMethod(final Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} is not implemented in _FakeSession',
  );
}

class _FakeServer implements Server {
  _FakeServer(final Endpoint? refreshEndpoint)
    : endpoints = _FakeEndpoints(refreshEndpoint);

  @override
  final EndpointDispatch endpoints;

  @override
  dynamic noSuchMethod(final Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} is not implemented in _FakeServer',
  );
}

class _FakeEndpoints extends EndpointDispatch {
  _FakeEndpoints(final Endpoint? refreshEndpoint) {
    if (refreshEndpoint != null) {
      connectors['jwtRefresh'] = EndpointConnector(
        name: 'jwtRefresh',
        endpoint: refreshEndpoint,
        methodConnectors: {},
      );
    }
  }

  @override
  void initializeEndpoints(final Server server) {}
}

class _FakeServerpod implements Serverpod {
  _FakeServerpod(this._config);

  final ServerpodConfig _config;

  @override
  ServerpodConfig get config => _config;

  @override
  dynamic noSuchMethod(final Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} is not implemented in _FakeServerpod',
  );
}

class _FakeJwt implements Jwt {
  _FakeJwt({
    required final JwtConfig config,
    required this.createTokensResult,
    required this.refreshAccessTokenResult,
  }) : _config = config;

  final JwtConfig _config;
  final AuthSuccess createTokensResult;
  final AuthSuccess refreshAccessTokenResult;
  final receivedRefreshTokens = <String>[];

  @override
  JwtConfig get config => _config;

  @override
  Future<AuthSuccess> createTokens(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,
    final Set<Scope>? scopes,
    final Map<String, dynamic>? extraClaims,
    final bool skipUserBlockedChecked = false,
    final Transaction? transaction,
  }) async {
    return createTokensResult;
  }

  @override
  Future<AuthSuccess> refreshAccessToken(
    final Session session, {
    required final String refreshToken,
    final Transaction? transaction,
  }) async {
    receivedRefreshTokens.add(refreshToken);
    return refreshAccessTokenResult;
  }

  @override
  dynamic noSuchMethod(final Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} is not implemented in _FakeJwt',
  );
}

class _TestRefreshJwtTokensEndpoint extends RefreshJwtTokensEndpoint {
  _TestRefreshJwtTokensEndpoint(this._jwt);

  final Jwt _jwt;

  @override
  Jwt get jwt => _jwt;
}
