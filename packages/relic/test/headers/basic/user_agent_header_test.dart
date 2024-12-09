import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/User-Agent
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a User-Agent header with the strict flag true', () {
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
      'when an empty User-Agent header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'user-agent': ''},
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
      'when a User-Agent string is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'},
        );

        expect(
          headers.userAgent,
          equals('Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
        );
      },
    );

    test(
      'when no User-Agent header is passed then it should default to a non-null value',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.userAgent, isNotNull);
      },
    );
  });

  group('Given a User-Agent header with the strict flag false', () {
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

    group('when an invalid User-Agent header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'user-agent': ''},
          );

          expect(headers.userAgent, isNull);
        },
      );

      test(
        'then it should be recorded in "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'user-agent': ''},
          );

          expect(
            headers.failedHeadersToParse['user-agent'],
            equals(['']),
          );
        },
      );
    });
  });
}
