import 'package:relic/relic.dart';
import 'package:serverpod/serverpod.dart' show WebAuthCookieBuilder;
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

  test(
    'Given a SameSite mapping when each CookieSameSite is built '
    'then it maps to the relic value.',
    () {
      SetCookie build(CookieSameSite s) =>
          WebAuthCookieConfig(sameSite: s).buildSetCookieHeader('v');

      expect(build(CookieSameSite.lax).sameSite, SameSite.lax);
      expect(build(CookieSameSite.strict).sameSite, SameSite.strict);
      expect(build(CookieSameSite.none).sameSite, SameSite.none);
    },
  );

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

  test(
    'Given a malformed cookie path when building a header '
    'then a clear ArgumentError is thrown.',
    () {
      expect(
        () => const WebAuthCookieConfig(path: 'a;b').buildSetCookieHeader('v'),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given a non-default config when built '
    'then secure/path/name are taken from the config.',
    () {
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
    },
  );
}
