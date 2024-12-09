import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Credentials
/// These tests verify the behavior of the Access-Control-Allow-Credentials header.
/// According to the CORS specification, this header can only have the value "true".
/// It indicates whether the response to the request can be exposed when the credentials flag is true.
/// The tests cover both strict and non-strict modes, ensuring that invalid values are handled appropriately.
/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Credentials#directives
/// About empty value test, check the [StrictValidationDocs] class for more details.

void main() {
  group(
      'Given an Access-Control-Allow-Credentials header with the strict flag true',
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
      'when an empty Access-Control-Allow-Credentials header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'access-control-allow-credentials': ''},
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
      'when an invalid Access-Control-Allow-Credentials header is passed then the server responds '
      'with a bad request including a message that states the header value is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'access-control-allow-credentials': 'blabla'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid boolean'),
            ),
          ),
        );
      },
    );

    test(
      'when a Access-Control-Allow-Credentials header with a value "false" '
      'then the server responds with a bad request including a message that states the header value '
      'must be "true" or "null"',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'access-control-allow-credentials': 'false'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Must be true or null'),
            ),
          ),
        );
      },
    );

    test(
      'when a Access-Control-Allow-Credentials header with a value "true" '
      'is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'access-control-allow-credentials': 'true'},
        );

        expect(headers.accessControlAllowCredentials, isTrue);
      },
    );

    test(
      'when no Access-Control-Allow-Credentials header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.accessControlAllowCredentials, isNull);
      },
    );
  });

  group(
      'Given an Access-Control-Allow-Credentials header with the strict flag false',
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

    group('when an empty Access-Control-Allow-Credentials header is passed',
        () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'access-control-allow-credentials': ''},
          );

          expect(headers.accessControlAllowCredentials, isNull);
        },
      );

      test(
        'then it should be recorded in failedHeadersToParse',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'access-control-allow-credentials': ''},
          );

          expect(
            headers.failedHeadersToParse['access-control-allow-credentials'],
            equals(['']),
          );
        },
      );
    });
  });
}
