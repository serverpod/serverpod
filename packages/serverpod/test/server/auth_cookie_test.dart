import 'package:relic/relic.dart';
import 'package:serverpod/serverpod.dart'
    show
        ServerConfig,
        Serverpod,
        ServerpodConfig,
        Session,
        WebAuthCookieBuilder,
        WebAuthCookieSession,
        webAuthModeCookie,
        webAuthModeHeaderName,
        webBasePathHeaderName;
import 'package:serverpod_shared/serverpod_shared.dart'
    show CookieSameSite, WebAuthCookieConfig;
import 'package:test/test.dart';

void main() {
  group('Given a default WebAuthCookieConfig', () {
    var config = const WebAuthCookieConfig();

    test('when building a set-cookie header then it is HttpOnly and Secure '
        'with the configured defaults.', () {
      var cookie = config.buildSetCookieHeader('abc123', maxAgeSeconds: 3600);

      expect(cookie.name, WebAuthCookieConfig.defaultName);
      expect(cookie.value, 'abc123');
      expect(cookie.httpOnly, isTrue);
      expect(cookie.secure, isTrue);
      expect(cookie.sameSite, SameSite.lax);
      expect(cookie.maxAge, 3600);
      expect(cookie.path?.toString(), '/');
      expect(cookie.domain, isNull);
    });

    test(
      'when building a refresh set-cookie header then it uses the refresh name.',
      () {
        var cookie = config.buildSetRefreshCookieHeader(
          'refresh123',
          maxAgeSeconds: 7200,
        );

        expect(cookie.name, '${WebAuthCookieConfig.defaultName}_refresh');
        expect(cookie.value, 'refresh123');
        expect(cookie.httpOnly, isTrue);
        expect(cookie.secure, isTrue);
        expect(cookie.sameSite, SameSite.lax);
        expect(cookie.maxAge, 7200);
        expect(cookie.path?.toString(), '/');
        expect(cookie.domain, isNull);
      },
    );

    test('when no maxAge is given then it is a session cookie.', () {
      var cookie = config.buildSetCookieHeader('abc123');
      expect(cookie.maxAge, isNull);
    });

    test('when building a clear-cookie header then value is empty and '
        'maxAge is 0.', () {
      var cookie = config.buildClearCookieHeader();
      expect(cookie.value, '');
      expect(cookie.maxAge, 0);
      expect(cookie.httpOnly, isTrue);
    });

    test('when building a refresh clear-cookie header then value is empty and '
        'maxAge is 0.', () {
      var cookie = config.buildClearRefreshCookieHeader();
      expect(cookie.name, '${WebAuthCookieConfig.defaultName}_refresh');
      expect(cookie.value, '');
      expect(cookie.maxAge, 0);
      expect(cookie.httpOnly, isTrue);
    });

    test(
      'when a path override is given then set and clear refresh cookies use '
      'it instead of the configured path.',
      () {
        var setCookie = config.buildSetRefreshCookieHeader(
          'refresh123',
          path: '/jwtRefresh',
        );
        var clearCookie = config.buildClearRefreshCookieHeader(
          path: '/jwtRefresh',
        );

        expect(setCookie.path?.toString(), '/jwtRefresh');
        expect(clearCookie.path?.toString(), '/jwtRefresh');
      },
    );
  });

  group('Given a SameSite mapping', () {
    test(
      'when each CookieSameSite is built then it maps to the relic value.',
      () {
        SetCookie build(CookieSameSite s) =>
            WebAuthCookieConfig(sameSite: s).buildSetCookieHeader('v');

        expect(build(CookieSameSite.lax).sameSite, SameSite.lax);
        expect(build(CookieSameSite.strict).sameSite, SameSite.strict);
        expect(build(CookieSameSite.none).sameSite, SameSite.none);
      },
    );
  });

  group('Given a configured domain', () {
    test('when it has a leading dot then the dot is stripped (host-only).', () {
      var cookie = const WebAuthCookieConfig(
        domain: '.example.com',
      ).buildSetCookieHeader('v');
      expect(cookie.domain?.toString(), 'example.com');
    });

    test('when it has no leading dot then it is used as-is.', () {
      var cookie = const WebAuthCookieConfig(
        domain: 'example.com',
      ).buildSetCookieHeader('v');
      expect(cookie.domain?.toString(), 'example.com');
    });

    test('when it is malformed then a clear ArgumentError is thrown.', () {
      // A misconfigured domain must surface as an actionable configuration
      // error, not an opaque relic FormatException deep in the sign-in path.
      expect(
        () => const WebAuthCookieConfig(
          domain: 'https://example.com',
        ).buildSetCookieHeader('v'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('when it includes a port then a clear ArgumentError is thrown.', () {
      // Host.parse accepts host:port, but a cookie Domain must not carry a port
      // (RFC 6265 5.2.3); that rejection must also surface as an ArgumentError.
      expect(
        () => const WebAuthCookieConfig(
          domain: 'example.com:8443',
        ).buildSetCookieHeader('v'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Given a malformed cookie path', () {
    test('when building a header then a clear ArgumentError is thrown.', () {
      expect(
        () => const WebAuthCookieConfig(path: 'a;b').buildSetCookieHeader('v'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Given a non-default config', () {
    test('when built then secure/path/name are taken from the config.', () {
      var cookie = const WebAuthCookieConfig(
        name: 'my_auth',
        refreshName: 'my_refresh',
        path: '/app',
        secure: false,
        sameSite: CookieSameSite.strict,
      ).buildSetCookieHeader('tok');

      expect(cookie.name, 'my_auth');
      expect(cookie.path?.toString(), '/app');
      expect(cookie.secure, isFalse);
      expect(cookie.sameSite, SameSite.strict);
    });
  });

  group('Given a web-auth-cookie session', () {
    late ServerpodConfig serverpodConfig;

    setUp(() {
      serverpodConfig = ServerpodConfig(
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
    });

    test(
      'when writing a refresh cookie for a cookie-mode request '
      'then the refresh cookie is queued.',
      () {
        final session = _FakeSession(
          config: serverpodConfig,
          request: _request(marker: true),
        );

        final wasWritten = session.writeWebAuthRefreshCookie(
          'refresh-token',
          maxAgeSeconds: 60,
        );

        expect(wasWritten, isTrue);
        expect(session.responseCookies, hasLength(1));
        expect(session.responseCookies.single.name, 'auth_refresh');
        expect(session.responseCookies.single.value, 'refresh-token');
        expect(session.responseCookies.single.maxAge, 60);
      },
    );

    test(
      'when writing a refresh cookie without cookie mode '
      'then no refresh cookie is queued.',
      () {
        final session = _FakeSession(
          config: serverpodConfig,
          request: _request(marker: false),
        );

        final wasWritten = session.writeWebAuthRefreshCookie('refresh-token');

        expect(wasWritten, isFalse);
        expect(session.responseCookies, isEmpty);
      },
    );

    test(
      'when reading a refresh cookie for a cookie-mode request '
      'then the refresh cookie value is returned.',
      () {
        final session = _FakeSession(
          config: serverpodConfig,
          request: _request(
            marker: true,
            cookieHeader: 'auth_refresh=refresh-token',
          ),
        );

        expect(session.readWebAuthRefreshCookie(), 'refresh-token');
      },
    );

    test(
      'when reading a refresh cookie for a cookie-transport-only request '
      'then the refresh cookie value is returned.',
      () {
        final session = _FakeSession(
          config: serverpodConfig,
          request: _request(
            marker: true,
            authMode: 'cookie-transport',
            cookieHeader: 'auth_refresh=refresh-token',
          ),
        );

        expect(session.readWebAuthRefreshCookie(), 'refresh-token');
      },
    );

    test(
      'when writing a refresh cookie for a cookie-transport-only request '
      'then the refresh cookie is queued.',
      () {
        final session = _FakeSession(
          config: serverpodConfig,
          request: _request(
            marker: true,
            authMode: 'cookie-transport',
          ),
        );

        final wasWritten = session.writeWebAuthRefreshCookie('refresh-token');

        expect(wasWritten, isTrue);
        expect(session.responseCookies.single.name, 'auth_refresh');
      },
    );

    test(
      'when reading duplicate refresh cookies for a cookie-mode request '
      'then no refresh cookie value is returned.',
      () {
        final session = _FakeSession(
          config: serverpodConfig,
          request: _request(
            marker: true,
            cookieHeader: 'auth_refresh=one; auth_refresh=two',
          ),
        );

        expect(session.readWebAuthRefreshCookie(), isNull);
      },
    );

    test(
      'when clearing web auth cookies for a cookie-mode request '
      'then both auth cookies are cleared.',
      () {
        final session = _FakeSession(
          config: serverpodConfig,
          request: _request(marker: true),
        );

        session.clearWebAuthCookie();

        expect(session.responseCookies, hasLength(2));
        expect(session.responseCookies.map((c) => c.name), [
          'auth',
          'auth_refresh',
        ]);
        expect(session.responseCookies.map((c) => c.value), ['', '']);
        expect(session.responseCookies.map((c) => c.maxAge), [0, 0]);
      },
    );

    test(
      'when the client declares a base path '
      'then it is returned normalized without a trailing slash.',
      () {
        final session = _FakeSession(
          config: serverpodConfig,
          request: _request(marker: true, basePath: '/api/'),
        );

        expect(session.webAuthBasePath, '/api');
      },
    );

    test(
      'when the client declares the root base path '
      'then it is returned as-is.',
      () {
        final session = _FakeSession(
          config: serverpodConfig,
          request: _request(marker: true, basePath: '/'),
        );

        expect(session.webAuthBasePath, '/');
      },
    );

    test(
      'when the declared base path is malformed or the marker is missing '
      'then no base path is returned.',
      () {
        for (final basePath in ['api', '/a;b', '/a b', '/${'a' * 300}']) {
          final session = _FakeSession(
            config: serverpodConfig,
            request: _request(marker: true, basePath: basePath),
          );
          expect(
            session.webAuthBasePath,
            isNull,
            reason: 'basePath "$basePath" should be rejected',
          );
        }

        final noMarker = _FakeSession(
          config: serverpodConfig,
          request: _request(marker: false, basePath: '/api'),
        );
        expect(noMarker.webAuthBasePath, isNull);
      },
    );
  });
}

Request _request({
  required bool marker,
  String authMode = webAuthModeCookie,
  String? cookieHeader,
  String? basePath,
}) {
  return RequestInternal.create(
    Method.get,
    Uri.parse('http://localhost/test'),
    Object(),
    headers: Headers.build((headers) {
      if (marker) {
        headers[webAuthModeHeaderName] = [authMode];
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
    required ServerpodConfig config,
    required this.request,
  }) : _serverpod = _FakeServerpod(config);

  final _FakeServerpod _serverpod;

  final responseCookies = <SetCookie>[];

  @override
  final Request? request;

  @override
  Serverpod get serverpod => _serverpod;

  @override
  void setResponseCookie(SetCookie cookie) {
    responseCookies.add(cookie);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} is not implemented in _FakeSession',
  );
}

class _FakeServerpod implements Serverpod {
  _FakeServerpod(this.config);

  @override
  final ServerpodConfig config;

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} is not implemented in _FakeServerpod',
  );
}
