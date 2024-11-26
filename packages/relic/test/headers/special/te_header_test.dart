import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/TE
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a TE header with the strict flag true', () {
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
      'when an empty TE header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'te': ''},
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
      'when a TE header with invalid quality values is passed '
      'then the server responds with a bad request including a message that '
      'states the quality value is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'te': 'trailers;q=abc'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid quality value'),
            ),
          ),
        );
      },
    );

    test(
      'when a TE header with invalid encoding is passed '
      'then the server responds with a bad request including a message that '
      'states the encoding is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'te': ';q=1.0'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid encoding'),
            ),
          ),
        );
      },
    );

    test(
      'when a TE header is passed then it should parse the '
      'encoding correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'te': 'trailers'},
        );

        expect(
          headers.te?.encodings.map((e) => e.encoding).toList(),
          equals(['trailers']),
        );
      },
    );

    test(
      'when a TE header is passed without quality then the '
      'default quality value should be set',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'te': 'trailers'},
        );

        expect(
          headers.te?.encodings.map((e) => e.quality).toList(),
          equals([1.0]),
        );
      },
    );

    test(
      'when no TE header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.te, isNull);
      },
    );

    group('when multiple TE headers are passed', () {
      test(
        'then they should parse the encodings correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'te': 'trailers, deflate, gzip'},
          );

          expect(
            headers.te?.encodings.map((e) => e.encoding).toList(),
            equals(['trailers', 'deflate', 'gzip']),
          );
        },
      );

      test(
        'with quantities then they should parse the encodings correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'te': 'trailers;q=1.0, deflate;q=0.5, gzip;q=0.8'},
          );

          expect(
            headers.te?.encodings.map((e) => e.encoding).toList(),
            equals(['trailers', 'deflate', 'gzip']),
          );
        },
      );

      test(
        'with quality values then they should parse the qualities correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'te': 'trailers;q=1.0, deflate;q=0.5, gzip;q=0.8'},
          );

          expect(
            headers.te?.encodings.map((e) => e.quality).toList(),
            equals([1.0, 0.5, 0.8]),
          );
        },
      );

      test(
        'with extra whitespace then they should parse the encodings correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'te': ' trailers , deflate , gzip '},
          );

          expect(
            headers.te?.encodings.map((e) => e.encoding).toList(),
            equals(['trailers', 'deflate', 'gzip']),
          );
        },
      );
    });
  });

  group('Given a TE header with the strict flag false', () {
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

    group('when an empty TE header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'te': ''},
          );

          expect(headers.te, isNull);
        },
      );

      test(
        'then it should be recorded in failedHeadersToParse',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'te': ''},
          );

          expect(headers.failedHeadersToParse['te'], equals(['']));
        },
      );
    });

    group('when TE headers with invalid quality values are passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'te': 'trailers;q=abc, deflate, gzip'},
          );

          expect(headers.te, isNull);
        },
      );

      test(
        'then they should be recorded in failedHeadersToParse',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'te': 'trailers;q=abc, deflate, gzip'},
          );

          expect(
            headers.failedHeadersToParse['te'],
            equals(['trailers;q=abc', 'deflate', 'gzip']),
          );
        },
      );
    });
  });
}
