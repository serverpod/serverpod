import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Request-Headers
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group(
      'Given an Access-Control-Request-Headers header with the strict flag true',
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
      'when an empty Access-Control-Request-Headers header is passed then the '
      'server responds with a bad request including a message that states the '
      'header value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'access-control-request-headers': ''},
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
      'when an Access-Control-Request-Headers header is passed then it '
      'should parse the headers correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {
            'access-control-request-headers':
                'X-Custom-Header, X-Another-Header'
          },
        );

        expect(
          headers.accessControlRequestHeaders,
          equals(['X-Custom-Header', 'X-Another-Header']),
        );
      },
    );

    test(
      'when an Access-Control-Request-Headers header with extra whitespace is '
      'passed then it should parse the headers correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {
            'access-control-request-headers':
                ' X-Custom-Header , X-Another-Header '
          },
        );

        expect(
          headers.accessControlRequestHeaders,
          equals(['X-Custom-Header', 'X-Another-Header']),
        );
      },
    );

    test(
      'when an Access-Control-Request-Headers header with duplicate headers is '
      'passed then it should parse the headers correctly and remove duplicates',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {
            'access-control-request-headers':
                'X-Custom-Header, X-Another-Header, X-Custom-Header'
          },
        );

        expect(
          headers.accessControlRequestHeaders,
          equals(['X-Custom-Header', 'X-Another-Header']),
        );
      },
    );

    test(
      'when no Access-Control-Request-Headers header is passed then it should '
      'default to null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.accessControlRequestHeaders, isNull);
      },
    );
  });

  group(
      'Given an Access-Control-Request-Headers header with the strict flag false',
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

    group('when an empty Access-Control-Request-Headers header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'access-control-request-headers': ''},
          );

          expect(headers.accessControlRequestHeaders, isNull);
        },
      );

      test(
        'then it should be recorded in "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'access-control-request-headers': ''},
          );

          expect(
            headers.failedHeadersToParse['access-control-request-headers'],
            equals(['']),
          );
        },
      );
    });
  });
}
