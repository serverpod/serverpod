import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Location
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Location header with the strict flag true', () {
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
      'when an empty Location header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'location': ''},
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
      'when a Location header with an invalid URI is passed then the server '
      'responds with a bad request including a message that states the URI '
      'is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'location': 'ht!tp://invalid-url'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid URI'),
            ),
          ),
        );
      },
    );

    test(
      'when a Location header with an invalid port is passed then the server '
      'responds with a bad request including a message that states the URI '
      'format is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'location': 'https://example.com:test'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid URI format'),
            ),
          ),
        );
      },
    );

    test(
      'when a Location header with a valid URI is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'location': 'https://example.com/page'},
        );

        expect(
          headers.location,
          equals(Uri.parse('https://example.com/page')),
        );
      },
    );

    test(
      'when a Location header with a valid port is passed then it should parse '
      'correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'location': 'https://example.com:8080'},
        );

        expect(
          headers.location?.port,
          equals(8080),
        );
      },
    );

    test(
      'when a Location header with extra whitespace is passed then it should '
      'parse the URI correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'location': ' https://example.com '},
        );

        expect(headers.location, equals(Uri.parse('https://example.com')));
      },
    );

    test(
      'when no Location header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.location, isNull);
      },
    );
  });

  group('Given a Location header with the strict flag false', () {
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

    group('when an invalid Location header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'location': 'ht!tp://invalid-url'},
          );

          expect(headers.location, isNull);
        },
      );

      test(
        'then it should be recorded in failedHeadersToParse',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'location': 'ht!tp://invalid-url'},
          );

          expect(
            headers.failedHeadersToParse['location'],
            equals(['ht!tp://invalid-url']),
          );
        },
      );
    });
  });
}
