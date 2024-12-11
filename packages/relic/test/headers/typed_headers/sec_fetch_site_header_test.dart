import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Sec-Fetch-Site
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Sec-Fetch-Site header with the strict flag true', () {
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
      'when an empty Sec-Fetch-Site header is passed then the server should respond with a bad request '
      'including a message that states the value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'sec-fetch-site': ''},
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
      'when an invalid Sec-Fetch-Site header is passed then the server should respond with a bad request '
      'including a message that states the value is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'sec-fetch-site': 'custom-site'},
          ),
          throwsA(isA<BadRequestException>().having(
            (e) => e.message,
            'message',
            contains('Invalid value'),
          )),
        );
      },
    );

    test(
      'when a valid Sec-Fetch-Site header is passed then it should parse the site correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'sec-fetch-site': 'same-origin'},
        );

        expect(headers.secFetchSite?.site, equals('same-origin'));
      },
    );

    test(
      'when no Sec-Fetch-Site header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.secFetchSite, isNull);
      },
    );
  });

  group('Given a Sec-Fetch-Site header with the strict flag false', () {
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

    group('When an empty Sec-Fetch-Site header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {},
          );

          expect(headers.secFetchSite, isNull);
        },
      );

      test(
        'then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'sec-fetch-site': ''},
          );

          expect(
            headers.failedHeadersToParse['sec-fetch-site'],
            equals(['']),
          );
        },
      );
    });
  });
}
