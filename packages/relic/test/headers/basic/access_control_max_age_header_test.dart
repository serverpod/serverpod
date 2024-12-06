import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Max-Age
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given an Access-Control-Max-Age header with the strict flag true', () {
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
      'when an empty Access-Control-Max-Age header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'access-control-max-age': ''},
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
      'when a invalid Access-Control-Max-Age header is passed then the server '
      'responds with a bad request including a message that states the value is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'access-control-max-age': 'invalid'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid number'),
            ),
          ),
        );
      },
    );

    test(
      'when a Access-Control-Max-Age header is passed then it should parse the value correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'access-control-max-age': '600'},
        );

        expect(headers.accessControlMaxAge, equals(600));
      },
    );

    test(
      'when a Access-Control-Max-Age header with extra whitespace is passed then it should parse the value correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'access-control-max-age': ' 600 '},
        );

        expect(headers.accessControlMaxAge, equals(600));
      },
    );

    test(
      'when no Access-Control-Max-Age header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.accessControlMaxAge, isNull);
      },
    );
  });

  group('Given an Access-Control-Max-Age header with the strict flag false',
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

    group('when an invalid Access-Control-Max-Age header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'access-control-max-age': 'invalid'},
          );

          expect(headers.accessControlMaxAge, isNull);
        },
      );

      test(
        'then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'access-control-max-age': 'invalid'},
          );

          expect(
            headers.failedHeadersToParse['access-control-max-age'],
            equals(['invalid']),
          );
        },
      );
    });
  });
}
