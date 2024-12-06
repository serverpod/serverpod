import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/If-Match
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given an If-Match header with the strict flag true', () {
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
      'when an empty If-Match header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'if-match': ''},
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
      'when an If-Match header with an invalid ETag is passed then the server '
      'responds with a bad request including a message that states the ETag is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'if-match': 'invalid-etag'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid ETag format'),
            ),
          ),
        );
      },
    );

    test(
      'when an If-Match header with a wildcard (*) and a valid ETag is passed then '
      'the server responds with a bad request including a message that states '
      'the wildcard (*) cannot be used with other values',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'if-match': '*, 123456"'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Wildcard (*) cannot be used with other values'),
            ),
          ),
        );
      },
    );

    test(
      'when an If-Match header with a single valid ETag is passed then it '
      'should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'if-match': '"123456"'},
        );

        expect(headers.ifMatch?.etags.length, equals(1));
        expect(headers.ifMatch?.etags.first.value, equals('123456'));
        expect(headers.ifMatch?.etags.first.isWeak, isFalse);
      },
    );

    test(
      'when an If-Match header with a wildcard (*) is passed then it '
      'should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'if-match': '*'},
        );

        expect(headers.ifMatch?.isWildcard, isTrue);
        expect(headers.ifMatch?.etags, isEmpty);
      },
    );

    test(
      'when no If-Match header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.ifMatch, isNull);
      },
    );

    group('when multiple ETags are passed', () {
      test(
        'ETags are passed then they should parse correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'if-match': '"123", "456", "789"'},
          );

          expect(headers.ifMatch?.etags.length, equals(3));
          expect(
            headers.ifMatch?.etags.map((e) => e.value).toList(),
            equals(['123', '456', '789']),
          );
        },
      );

      test(
        'with W/ weak validator prefix should be accepted',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'if-match': 'W/"123", W/"456"'},
          );

          expect(headers.ifMatch?.etags.length, equals(2));
          expect(
            headers.ifMatch?.etags.every((e) => e.isWeak),
            isTrue,
          );
        },
      );

      test(
        'with extra whitespace are passed then they should parse correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'if-match': ' "123" , "456" , "789" '},
          );

          expect(headers.ifMatch?.etags.length, equals(3));
          expect(
            headers.ifMatch?.etags.map((e) => e.value).toList(),
            equals(['123', '456', '789']),
          );
        },
      );

      test(
        'with duplicate values are passed then they should parse correctly '
        'and remove duplicates',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'if-match': '"123", "456", "789", "123"'},
          );

          expect(headers.ifMatch?.etags.length, equals(3));
          expect(
            headers.ifMatch?.etags.map((e) => e.value).toList(),
            equals(['123', '456', '789']),
          );
        },
      );
    });
  });

  group('Given an If-Match header with the strict flag false', () {
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

    group('when an invalid If-Match header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'if-match': 'invalid-etag'},
          );

          expect(headers.ifMatch, isNull);
        },
      );

      test(
        'then it should be recorded in "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'if-match': 'invalid-etag'},
          );

          expect(
            headers.failedHeadersToParse['if-match'],
            equals(['invalid-etag']),
          );
        },
      );
    });
  });
}
