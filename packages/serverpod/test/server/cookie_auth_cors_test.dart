import 'package:relic/relic.dart';
import 'package:serverpod/src/server/cookie_auth_cors.dart';
import 'package:test/test.dart';

Headers _apply(Headers base, {List<String>? requestedHeaders}) {
  return base.transform(
    (mh) => ensureCookieAuthAllowedHeaders(
      mh,
      requestedHeaders: requestedHeaders,
    ),
  );
}

void main() {
  test(
    'Given a preflight response without allowed headers '
    'when ensuring the cookie-auth headers '
    'then they are set as the allowed headers.',
    () {
      final headers = _apply(Headers.empty());

      expect(
        headers.accessControlAllowHeaders?.headers,
        containsAll(cookieAuthRequestHeaders),
      );
    },
  );

  group(
    'Given a preflight response with a wildcard allowed headers override',
    () {
      late Headers base;

      setUp(() {
        base = Headers.build(
          (mh) => mh.accessControlAllowHeaders =
              const AccessControlAllowHeadersHeader.wildcard(),
        );
      });

      test(
        'when ensuring the cookie-auth headers '
        'then the wildcard is replaced with an explicit list including them.',
        () {
          final headers = _apply(base, requestedHeaders: ['content-type']);

          final allow = headers.accessControlAllowHeaders!;
          expect(allow.isWildcard, isFalse);
          expect(
            allow.headers,
            containsAll(['content-type', ...cookieAuthRequestHeaders]),
          );
        },
      );

      test(
        'when the preflight requests no headers '
        'then the explicit list still includes the cookie-auth headers.',
        () {
          final headers = _apply(base, requestedHeaders: null);

          expect(
            headers.accessControlAllowHeaders?.headers,
            containsAll(cookieAuthRequestHeaders),
          );
        },
      );
    },
  );

  group('Given a preflight response with an explicit allowed headers list', () {
    test(
      'when the cookie-auth headers are missing '
      'then they are appended to the list.',
      () {
        final base = Headers.build(
          (mh) => mh.accessControlAllowHeaders =
              AccessControlAllowHeadersHeader.headers(['content-type']),
        );

        final headers = _apply(base);

        expect(
          headers.accessControlAllowHeaders?.headers,
          containsAll(['content-type', ...cookieAuthRequestHeaders]),
        );
      },
    );

    test(
      'when the cookie-auth headers are already present '
      'then the list is unchanged.',
      () {
        final base = Headers.build(
          (mh) => mh.accessControlAllowHeaders =
              AccessControlAllowHeadersHeader.headers([
                'content-type',
                ...cookieAuthRequestHeaders,
              ]),
        );

        final headers = _apply(base);

        expect(headers.accessControlAllowHeaders?.headers, [
          'content-type',
          ...cookieAuthRequestHeaders,
        ]);
      },
    );
  });
}
