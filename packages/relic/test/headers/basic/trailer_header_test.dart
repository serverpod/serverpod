import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Trailer
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Trailer header with the strict flag true', () {
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
      'when an empty Trailer header is passed then the server should respond with a bad request '
      'including a message that states the value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'trailer': ''},
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
      'when a valid Trailer header is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'trailer': 'Expires, Content-MD5, Content-Language'},
        );

        expect(
          headers.trailer,
          equals(['Expires', 'Content-MD5', 'Content-Language']),
        );
      },
    );

    test(
      'when a Trailer header with whitespace is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'trailer': ' Expires , Content-MD5 , Content-Language '},
        );

        expect(
          headers.trailer,
          equals(['Expires', 'Content-MD5', 'Content-Language']),
        );
      },
    );

    test(
      'when a Trailer header with custom values is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'trailer': 'custom-header, AnotherHeader'},
        );

        expect(
          headers.trailer,
          equals(['custom-header', 'AnotherHeader']),
        );
      },
    );

    test(
      'when no Trailer header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.trailer, isNull);
      },
    );
  });

  group('Given a Trailer header with the strict flag false', () {
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

    test(
      'when a custom Trailer header is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'trailer': 'custom-header'},
        );

        expect(headers.trailer, equals(['custom-header']));
      },
    );

    test(
      'when an empty Trailer header is passed then it should be recorded in failedHeadersToParse',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'trailer': ''},
        );

        expect(
          headers.failedHeadersToParse['trailer'],
          equals(['']),
        );
      },
    );
  });
}
