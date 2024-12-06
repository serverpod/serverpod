import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';
import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Host
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Host header with the strict flag true', () {
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
      'when an empty Host header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'host': ''},
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
      'when a Host header with an invalid URI format is passed '
      'then the server responds with a bad request including a message that '
      'states the URI format is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'host': 'h@ttp://example.com'},
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
      'when a Host header with an invalid port number is passed '
      'then the server responds with a bad request including a message that '
      'states the URI format is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'host': 'http://example.com:test'},
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
      'when a valid Host header is passed then it should parse the URI correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'host': 'https://example.com'},
        );

        expect(headers.host, equals(Uri.parse('https://example.com')));
      },
    );

    test(
      'when a Host header with a port number is passed then it should parse '
      'the port number correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'host': 'https://example.com:8080'},
        );

        expect(
          headers.host?.port,
          equals(8080),
        );
      },
    );

    test(
      'when a Host header with extra whitespace is passed then it should parse the URI correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'host': ' https://example.com '},
        );

        expect(headers.host, equals(Uri.parse('https://example.com')));
      },
    );

    test(
      'when no Host header is passed then it should default to machine address',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.host, isNotNull);
        expect(headers.host, isA<Uri>());
      },
    );
  });

  group('Given a Host header with the strict flag false', () {
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

    group('when an invalid Host header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'host': 'h@ttp://example.com'},
          );

          expect(headers.host, isNull);
        },
      );

      test(
        'then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'host': 'h@ttp://example.com'},
          );

          expect(
            headers.failedHeadersToParse['host'],
            equals(['h@ttp://example.com']),
          );
        },
      );
    });

    test(
      'when no Host header is passed then it should default to machine address',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.host, isNotNull);
        expect(headers.host, isA<Uri>());
      },
    );
  });
}
