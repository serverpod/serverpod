import 'dart:io';
import 'package:relic/src/headers/headers.dart';
import 'package:test/test.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Connection
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Connection header with the strict flag true', () {
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
      'when an empty Connection header is passed then the server responds '
      'with a bad request including a message that states the directives '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'connection': ''},
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
      'when an invalid Connection header is passed then the server responds '
      'with a bad request including a message that states the value '
      'is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'connection': 'custom-directive'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid value'),
            ),
          ),
        );
      },
    );

    test(
      'when a Connection header with directives are passed then they should be parsed correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'connection': 'keep-alive, upgrade'},
        );

        expect(
          headers.connection?.directives.map((d) => d.value),
          containsAll(['keep-alive', 'upgrade']),
        );
      },
    );

    test(
      'when a Connection header with duplicate directives are passed then '
      'they should be parsed correctly and remove duplicates',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'connection': 'keep-alive, upgrade, keep-alive'},
        );

        expect(
          headers.connection?.directives.map((d) => d.value),
          containsAll(['keep-alive', 'upgrade']),
        );
      },
    );

    test(
      'when a Connection header with keep-alive is passed then isKeepAlive should be true',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'connection': 'keep-alive'},
        );

        expect(headers.connection?.isKeepAlive, isTrue);
      },
    );

    test(
      'when a Connection header with close is passed then isClose should be true',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'connection': 'close'},
        );

        expect(headers.connection?.isClose, isTrue);
      },
    );
  });

  group('Given a Connection header with the strict flag false', () {
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

    group(
      'when an invalid Connection header is passed',
      () {
        test(
          'then it should return null',
          () async {
            Headers headers = await getServerRequestHeaders(
              server: server,
              headers: {'connection': ''},
            );

            expect(headers.connection, isNull);
          },
        );

        test(
          'then it should be recorded in failedHeadersToParse',
          () async {
            Headers headers = await getServerRequestHeaders(
              server: server,
              headers: {'connection': ''},
            );

            expect(
              headers.failedHeadersToParse['connection'],
              equals(['']),
            );
          },
        );
      },
    );
  });
}
