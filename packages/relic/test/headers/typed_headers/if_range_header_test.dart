import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/If-Range
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given an If-Range header with the strict flag true', () {
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
      'when an empty If-Range header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'if-range': ''},
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
      'when an invalid ETag format is passed then the server responds with a '
      'bad request including a message that states the ETag format is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'if-range': 'invalid-etag'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid format'),
            ),
          ),
        );
      },
    );

    test(
      'when an If-Range header with a valid ETag is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'if-range': '"123456"'},
        );

        expect(headers.ifRange?.etag?.value, equals('123456'));
        expect(headers.ifRange?.etag?.isWeak, isFalse);
        expect(headers.ifRange?.lastModified, isNull);
      },
    );

    test(
      'when an If-Range header with a weak ETag is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'if-range': 'W/"123456"'},
        );

        expect(headers.ifRange?.etag?.value, equals('123456'));
        expect(headers.ifRange?.etag?.isWeak, isTrue);
        expect(headers.ifRange?.lastModified, isNull);
      },
    );

    test(
      'when an If-Range header with a valid HTTP date is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'if-range': 'Wed, 21 Oct 2015 07:28:00 GMT'},
        );

        expect(headers.ifRange?.etag, isNull);
        expect(
          headers.ifRange?.lastModified?.toUtc(),
          equals(parseHttpDate('Wed, 21 Oct 2015 07:28:00 GMT')),
        );
      },
    );

    test(
      'when no If-Range header is passed then it should default to null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.ifRange, isNull);
      },
    );
  });

  group('Given an If-Range header with the strict flag false', () {
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

    group('when an invalid If-Range header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'if-range': 'invalid-value'},
          );

          expect(headers.ifRange, isNull);
        },
      );

      test(
        'then it should be recorded in "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'if-range': 'invalid-value'},
          );

          expect(
            headers.failedHeadersToParse['if-range'],
            equals(['invalid-value']),
          );
        },
      );
    });
  });
}
