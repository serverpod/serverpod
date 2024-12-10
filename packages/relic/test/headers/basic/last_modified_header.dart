import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';
import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Last-Modified
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Last-Modified header with the strict flag true', () {
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
      'when an empty Last-Modified header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'last-modified': ''},
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
      'when a Last-Modified header with an invalid date format is passed '
      'then the server responds with a bad request including a message that '
      'states the date format is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'last-modified': 'invalid-date-format'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid date format'),
            ),
          ),
        );
      },
    );

    test(
      'when a valid Last-Modified header is passed then it should parse the '
      'date correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'last-modified': 'Wed, 21 Oct 2015 07:28:00 GMT'},
        );

        expect(
          headers.lastModified,
          equals(parseHttpDate('Wed, 21 Oct 2015 07:28:00 GMT')),
        );
      },
    );

    test(
      'when a Last-Modified header with extra whitespace is passed then it should parse the date correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'last-modified': ' Wed, 21 Oct 2015 07:28:00 GMT '},
        );

        expect(
          headers.lastModified,
          equals(parseHttpDate('Wed, 21 Oct 2015 07:28:00 GMT')),
        );
      },
    );

    test(
      'when no Last-Modified header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.lastModified, isNull);
      },
    );
  });

  group('Given a Last-Modified header with the strict flag false', () {
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

    group('when an empty Last-Modified header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'last-modified': ''},
          );

          expect(headers.lastModified, isNull);
        },
      );

      test(
        'then it should be recorded in "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'last-modified': ''},
          );

          expect(
            headers.failedHeadersToParse['last-modified'],
            equals(['']),
          );
        },
      );
    });

    group('when an invalid Last-Modified header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'last-modified': 'invalid-date-format'},
          );

          expect(headers.lastModified, isNull);
        },
      );

      test(
        'then it should be recorded in "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'last-modified': 'invalid-date-format'},
          );

          expect(
            headers.failedHeadersToParse['last-modified'],
            equals(['invalid-date-format']),
          );
        },
      );
    });
  });
}
