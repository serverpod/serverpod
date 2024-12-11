import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Encoding
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Content-Encoding header with the strict flag true', () {
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
      'when an empty Content-Encoding header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'content-encoding': ''},
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
      'when an invalid Content-Encoding header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'content-encoding': 'custom-encoding'},
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
      'when a single valid encoding is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'content-encoding': 'gzip'},
        );

        expect(
          headers.contentEncoding?.encodings.map((e) => e.name).toList(),
          equals(['gzip']),
        );
      },
    );

    test(
      'when no Content-Encoding header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.contentEncoding, isNull);
      },
    );

    group('when multiple Content-Encoding encodings are passed', () {
      test(
        'then they should parse correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'content-encoding': 'gzip, deflate'},
          );

          expect(
            headers.contentEncoding?.encodings.map((e) => e.name).toList(),
            equals(['gzip', 'deflate']),
          );
        },
      );

      test(
        'with extra whitespace should parse correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'content-encoding': ' gzip , deflate '},
          );

          expect(
            headers.contentEncoding?.encodings.map((e) => e.name).toList(),
            equals(['gzip', 'deflate']),
          );
        },
      );

      test(
        'with duplicate encodings should parse correctly and remove duplicates',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'content-encoding': 'gzip, deflate, gzip'},
          );

          expect(
            headers.contentEncoding?.encodings.map((e) => e.name).toList(),
            equals(['gzip', 'deflate']),
          );
        },
      );
    });
  });

  group('Given a Content-Encoding header with the strict flag false', () {
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

    group('when an invalid Content-Encoding header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'content-encoding': ''},
          );

          expect(headers.contentEncoding, isNull);
        },
      );

      test(
        'then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'content-encoding': ''},
          );

          expect(
            headers.failedHeadersToParse['content-encoding'],
            equals(['']),
          );
        },
      );
    });
  });
}
