import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referer
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Referer header with the strict flag true', () {
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
      'when a Referer header with an empty value is passed then the server '
      'responds with a bad request including a message that states the '
      'header value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'referer': ''},
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
      'when a Referer header with an invalid URI is passed then the server '
      'responds with a bad request including a message that states the URI is '
      'invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'referer': 'ht!tp://invalid-url'},
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
      'when a Referer header with an invalid port number is passed '
      'then the server responds with a bad request including a message that '
      'states the URI format is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'referer': 'http://example.com:test'},
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
      'when a Referer header with a valid URI is passed then it should parse '
      'correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'referer': 'https://example.com/page'},
        );

        expect(headers.referer, equals(Uri.parse('https://example.com/page')));
      },
    );

    test(
      'when a Referer header with a port number is passed then it should parse '
      'the port number correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'referer': 'https://example.com:8080'},
        );

        expect(
          headers.referer?.port,
          equals(8080),
        );
      },
    );

    test(
      'when a Referer header with extra whitespace is passed then it should '
      'parse the URI correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'referer': ' https://example.com '},
        );

        expect(headers.referer, equals(Uri.parse('https://example.com')));
      },
    );

    test(
      'when no Referer header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.referer, isNull);
      },
    );
  });

  group('Given a Referer header with the strict flag false', () {
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

    group('when an invalid Referer header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'referer': 'ht!tp://invalid-url'},
          );

          expect(headers.referer, isNull);
        },
      );

      test(
        'then it should be recorded in "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'referer': 'ht!tp://invalid-url'},
          );

          expect(
            headers.failedHeadersToParse['referer'],
            equals(['ht!tp://invalid-url']),
          );
        },
      );
    });
  });
}
