import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Methods
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group(
      'Given an Access-Control-Allow-Methods header with the strict flag true',
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
      'when an empty Access-Control-Allow-Methods header is passed then the server should respond with a bad request '
      'including a message that states the value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'access-control-allow-methods': ''},
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
      'when an Access-Control-Allow-Methods header with wildcard (*) and other '
      'methods is passed then the server should respond with a bad request '
      'including a message that states the wildcard (*) cannot be used with '
      'other values',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'access-control-allow-methods': 'GET, *'},
          ),
          throwsA(isA<BadRequestException>().having(
            (e) => e.message,
            'message',
            contains('Wildcard (*) cannot be used with other values'),
          )),
        );
      },
    );

    test(
      'when a valid Access-Control-Allow-Methods header is passed then it should parse the methods correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'access-control-allow-methods': 'GET, POST, OPTIONS'},
        );

        final methods = headers.accessControlAllowMethods?.methods;
        expect(methods?.length, equals(3));
        expect(
          methods?.map((m) => m.value).toList(),
          containsAll(['GET', 'POST', 'OPTIONS']),
        );
      },
    );

    test(
      'when a valid Access-Control-Allow-Methods header with duplicate methods is passed '
      'then it should parse the methods correctly and remove duplicates',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'access-control-allow-methods': 'GET, POST, OPTIONS, GET'},
        );

        final methods = headers.accessControlAllowMethods?.methods;
        expect(methods?.length, equals(3));
        expect(
          methods?.map((m) => m.value).toList(),
          containsAll(['GET', 'POST', 'OPTIONS']),
        );
      },
    );

    test(
      'when an Access-Control-Allow-Methods header with wildcard is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'access-control-allow-methods': '*'},
        );

        expect(headers.accessControlAllowMethods?.isWildcard, isTrue);
      },
    );

    test(
      'when no Access-Control-Allow-Methods header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.accessControlAllowMethods, isNull);
      },
    );
  });

  group(
      'Given an Access-Control-Allow-Methods header with the strict flag false',
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

    group('when an empty Access-Control-Allow-Methods header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {},
          );
          expect(headers.accessControlAllowMethods, isNull);
        },
      );

      test(
        'then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'access-control-allow-methods': ''},
          );

          expect(
            headers.failedHeadersToParse['access-control-allow-methods'],
            equals(['']),
          );
        },
      );
    });
  });
}
