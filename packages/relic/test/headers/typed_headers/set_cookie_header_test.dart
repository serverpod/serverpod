import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie
void main() {
  group('Given a Set-Cookie header with the strict flag true', () {
    late RelicServer server;

    setUp(() async {
      try {
        server = await RelicServer.createServer(
          InternetAddress.loopbackIPv6,
          0,
          strictHeaders: true,
        );
      } on SocketException catch (_) {
        server = await RelicServer.createServer(
          InternetAddress.loopbackIPv4,
          0,
          strictHeaders: true,
        );
      }
    });

    tearDown(() => server.close());

    test(
      'when an empty Set-Cookie header is passed then the server responds '
      'with a bad request including a message that states the header value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'set-cookie': ''},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Value cannot be empty'),
            ),
          ),
        );
      },
    );

    test(
      'when a Set-Cookie header with duplicate attributes is passed then server '
      'responds with a bad request including a message that states the Max-Age is '
      'supplied multiple times',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {
              'set-cookie': 'sessionId=abc123; Max-Age=3600; Max-Age=7200'
            },
          ),
          throwsA(isA<BadRequestException>().having(
            (e) => e.message,
            'message',
            contains('Supplied multiple Max-Age attributes'),
          )),
        );
      },
    );

    test(
      'when a Set-Cookie header with an invalid SameSite attribute is passed then '
      'server responds with a bad request including a message that states the '
      'SameSite is supplied multiple times',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'set-cookie': 'sessionId=abc123; SameSite=Invalid'},
          ),
          throwsA(isA<BadRequestException>().having(
            (e) => e.message,
            'message',
            contains('Invalid SameSite attribute'),
          )),
        );
      },
    );

    test(
      'when a Set-Cookie header with missing name and value is passed then server '
      'responds with a bad request including a message that states the Name and Value '
      'are supplied multiple times',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'set-cookie': 'sessionId=test; userId=42'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Supplied multiple Name and Value attributes'),
            ),
          ),
        );
      },
    );

    test(
      'when a Set-Cookie header with invalid format is passed then the server responds '
      'with a bad request including a message that states the cookie format is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'set-cookie': 'sessionId=abc123; invalidCookie'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid cookie format'),
            ),
          ),
        );
      },
    );

    test(
      'when a Set-Cookie header with an invalid name is passed then the server responds '
      'with a bad request including a message that states the cookie name is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'set-cookie': 'invalid name=abc123'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid cookie name'),
            ),
          ),
        );
      },
    );

    test(
      'when a Set-Cookie header with an invalid value is passed then the server responds '
      'with a bad request including a message that states the cookie value is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'set-cookie': 'userId=42\x7F'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid cookie value'),
            ),
          ),
        );
      },
    );

    test(
      'when a Set-Cookie header with an empty name is passed then it should parse the cookie correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'set-cookie': '=abc123'},
        );

        expect(headers.setCookie?.name, isEmpty);
        expect(headers.setCookie?.value, equals('abc123'));
      },
    );

    test(
      'when a Set-Cookie header with all attributes is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {
            'set-cookie':
                'sessionId=abc123; Expires=Wed, 21 Oct 2025 07:28:00 GMT; Max-Age=3600; Domain=example.com; Path=/; Secure; HttpOnly; SameSite=Strict'
          },
        );

        expect(headers.setCookie?.name, equals('sessionId'));
        expect(headers.setCookie?.value, equals('abc123'));
        expect(headers.setCookie?.expires, isNotNull);
        expect(headers.setCookie?.maxAge, equals(3600));
        expect(headers.setCookie?.domain.toString(), equals('example.com'));
        expect(headers.setCookie?.path.toString(), equals('/'));
        expect(headers.setCookie?.secure, isTrue);
        expect(headers.setCookie?.httpOnly, isTrue);
        expect(headers.setCookie?.sameSite?.name, equals(SameSite.strict.name));
      },
    );

    test(
      'when a Set-Cookie header with extra whitespace is passed then it should parse the cookies correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'set-cookie': ' sessionId=abc123 ; Secure '},
        );

        expect(headers.setCookie?.name, equals('sessionId'));
        expect(headers.setCookie?.value, equals('abc123'));
        expect(headers.setCookie?.secure, isTrue);
      },
    );
  });

  group('Given a Set-Cookie header with the strict flag false', () {
    late RelicServer server;

    setUp(() async {
      try {
        server = await RelicServer.createServer(
          InternetAddress.loopbackIPv6,
          0,
          strictHeaders: false,
        );
      } on SocketException catch (_) {
        server = await RelicServer.createServer(
          InternetAddress.loopbackIPv4,
          0,
          strictHeaders: false,
        );
      }
    });

    tearDown(() => server.close());

    group('when parsing an invalid cookie header', () {
      test(
        'when an invalid Set-Cookie header is passed then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'set-cookie': 'sessionId=abc123; invalidCookie'},
          );

          expect(headers.setCookie, isNull);
        },
      );

      test(
        'when an invalid Set-Cookie header is passed then it should be recorded in failedHeadersToParse',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'set-cookie': 'sessionId=abc123; invalidCookie'},
          );

          expect(
            headers.failedHeadersToParse['set-cookie'],
            equals(['sessionId=abc123; invalidCookie']),
          );
        },
      );
    });
  });
}
