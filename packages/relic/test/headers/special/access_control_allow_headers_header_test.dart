import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Headers
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group(
      'Given an Access-Control-Allow-Headers header with the strict flag true',
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
      'when an empty Access-Control-Allow-Headers header is passed then '
      'the server should respond with a bad request including a message '
      'that states the value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'access-control-allow-headers': ''},
          ),
          throwsA(isA<BadRequestException>().having(
            (e) => e.message,
            'message',
            contains('Value cannot be empty'),
          )),
        );
      },
    );

    test(
      'when an Access-Control-Allow-Headers header with a wildcard (*) '
      'is passed then the server should respond with a bad request including '
      'a message that states the wildcard cannot be used with other headers',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'access-control-allow-headers': '*, Content-Type'},
          ),
          throwsA(isA<BadRequestException>().having(
            (e) => e.message,
            'message',
            contains('Wildcard (*) cannot be used with other headers'),
          )),
        );
      },
    );

    test(
      'when a valid Access-Control-Allow-Headers header is passed then it should parse the headers correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {
            'access-control-allow-headers': 'Content-Type, X-Custom-Header'
          },
        );

        final allowedHeaders = headers.accessControlAllowHeaders?.headers;
        expect(allowedHeaders?.length, equals(2));
        expect(
          allowedHeaders,
          containsAll(['Content-Type', 'X-Custom-Header']),
        );
      },
    );

    test(
      'when an Access-Control-Allow-Headers header with wildcard is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'access-control-allow-headers': '*'},
        );

        expect(headers.accessControlAllowHeaders?.isWildcard, isTrue);
      },
    );

    test(
      'when no Access-Control-Allow-Headers header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.accessControlAllowHeaders, isNull);
      },
    );
  });

  group(
      'Given an Access-Control-Allow-Headers header with the strict flag false',
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

    group('when an empty Access-Control-Allow-Headers header is passed', () {
      test('then it should return null', () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );
        expect(headers.accessControlAllowHeaders, isNull);
      });

      test(
        'then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'access-control-allow-headers': ''},
          );

          expect(
            headers.failedHeadersToParse['access-control-allow-headers'],
            equals(['']),
          );
        },
      );
    });
  });
}
