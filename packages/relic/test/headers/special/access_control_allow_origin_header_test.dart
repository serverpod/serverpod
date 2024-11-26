import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given an Access-Control-Allow-Origin header with the strict flag true',
      () {
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
      'when an empty Access-Control-Allow-Origin header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'access-control-allow-origin': ''},
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
      'when a Access-Control-Allow-Origin header with an invalid URI is passed '
      'then the server responds with a bad request including a message that '
      'states the URI is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'access-control-allow-origin': 'ht!tp://invalid-url'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid URI format'),
            ),
          ),
        );
      },
    );

    test(
      'when an Access-Control-Allow-Origin header with an invalid port is passed '
      'then the server responds with a bad request including a message that '
      'states the URI is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {
              'access-control-allow-origin': 'https://example.com:test'
            },
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid URI format'),
            ),
          ),
        );
      },
    );

    test(
      'when a Access-Control-Allow-Origin header with a valid URI origin is passed '
      'then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'access-control-allow-origin': 'https://example.com'},
        );

        expect(
          headers.accessControlAllowOrigin?.origin,
          equals(Uri.parse('https://example.com')),
        );
      },
    );

    test(
      'when a Access-Control-Allow-Origin header with a valid URI origin and port is passed '
      'then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'access-control-allow-origin': 'https://example.com:8080'},
        );

        expect(
          headers.accessControlAllowOrigin?.origin?.port,
          equals(8080),
        );
      },
    );

    test(
      'when a Access-Control-Allow-Origin header with a valid URI origin with '
      'spaces is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'access-control-allow-origin': ' https://example.com '},
        );

        expect(
          headers.accessControlAllowOrigin?.origin,
          equals(Uri.parse('https://example.com')),
        );
      },
    );

    test(
      'when a Access-Control-Allow-Origin header with a wildcard (*) is passed '
      'then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'access-control-allow-origin': '*'},
        );

        expect(headers.accessControlAllowOrigin?.isWildcard, isTrue);
        expect(headers.accessControlAllowOrigin?.origin, isNull);
      },
    );

    test(
      'when no Access-Control-Allow-Origin header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.accessControlAllowOrigin, isNull);
      },
    );
  });

  group(
      'Given an Access-Control-Allow-Origin header with the strict flag false',
      () {
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

    group('When an invalid Access-Control-Allow-Origin header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'access-control-allow-origin': 'ht!tp://invalid-url'},
          );

          expect(headers.accessControlAllowOrigin, isNull);
        },
      );

      test(
        'then it should be recorded in "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'access-control-allow-origin': 'ht!tp://invalid-url'},
          );

          expect(
            headers.failedHeadersToParse['access-control-allow-origin'],
            equals(['ht!tp://invalid-url']),
          );
        },
      );
    });
  });
}
