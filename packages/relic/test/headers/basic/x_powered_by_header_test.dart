import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given an X-Powered-By header with the strict flag true', () {
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
      'when an empty X-Powered-By header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'x-powered-by': ''},
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
      'when a valid X-Powered-By value is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'x-powered-by': 'Express'},
        );

        expect(headers.xPoweredBy, equals('Express'));
      },
    );

    test(
      'when no X-Powered-By header is passed then it should default to Relic',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.xPoweredBy, equals('Relic'));
      },
    );
  });

  group('Given an X-Powered-By header with the strict flag false', () {
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

    group('when an invalid X-Powered-By header is passed', () {
      test(
        'when an invalid X-Powered-By header is passed then it should default to Relic',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'x-powered-by': ''},
          );

          expect(headers.xPoweredBy, equals('Relic'));
        },
      );
    });
  });
}
