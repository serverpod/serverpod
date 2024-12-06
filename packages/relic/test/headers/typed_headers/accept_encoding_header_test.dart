import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept-Encoding
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given an Accept-Encoding header with the strict flag true', () {
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
      'when an empty Accept-Encoding header is passed then the server responds '
      'with a bad request including a message that states the header value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'accept-encoding': ''},
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
      'when an Accept-Encoding header with invalid quality values is passed '
      'then the server responds with a bad request including a message that '
      'states the quality value is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'accept-encoding': 'gzip;q=abc'},
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
      'when an Accept-Encoding header with wildcard (*) and other encodings is '
      'passed then the server responds with a bad request including a message '
      'that states the wildcard (*) cannot be used with other values',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'accept-encoding': '*, gzip'},
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
      'when an Accept-Encoding header with empty encoding is passed then '
      'the server responds with a bad request including a message that '
      'states the encoding is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'accept-encoding': ';q=0.5'},
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
      'when an Accept-Encoding header is passed then it should parse the encoding correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'accept-encoding': 'gzip'},
        );

        expect(
          headers.acceptEncoding?.encodings?.map((e) => e.encoding).toList(),
          equals(['gzip']),
        );
      },
    );

    test(
      'when an Accept-Encoding header is passed without quality then the '
      'default quality value should be set',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'accept-encoding': 'gzip'},
        );

        expect(
          headers.acceptEncoding?.encodings?.map((e) => e.quality).toList(),
          equals([1.0]),
        );
      },
    );

    test(
      'when an Accept-Encoding header is passed with quality then the '
      'quality value should be set',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'accept-encoding': 'gzip;q=0.5'},
        );

        expect(
          headers.acceptEncoding?.encodings?.map((e) => e.quality).toList(),
          equals([0.5]),
        );
      },
    );

    test(
      'when a mixed case Accept-Encoding header is passed then it should parse '
      'the encoding correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'accept-encoding': 'GZip'},
        );

        expect(
          headers.acceptEncoding?.encodings?.map((e) => e.encoding).toList(),
          equals(['gzip']),
        );
      },
    );

    test(
      'when an Accept-Encoding header with wildcard (*) is passed then it should '
      'parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'accept-encoding': '*'},
        );

        expect(headers.acceptEncoding?.isWildcard, isTrue);
        expect(headers.acceptEncoding?.encodings, isNull);
      },
    );

    test(
      'when an Accept-Encoding header with wildcard (*) and quality value is '
      'passed then it should parse the encoding correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'accept-encoding': '*;q=0.5'},
        );

        expect(
          headers.acceptEncoding?.encodings?.map((e) => e.encoding).toList(),
          equals(['*']),
        );
        expect(
          headers.acceptEncoding?.encodings?.map((e) => e.quality).toList(),
          equals([0.5]),
        );
      },
    );

    test(
      'when no Accept-Encoding header is passed then it should default to gzip',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(
          headers.acceptEncoding?.encodings?.map((e) => e.encoding).toList(),
          equals(['gzip']),
        );
        expect(
          headers.acceptEncoding?.encodings?.map((e) => e.quality).toList(),
          equals([1.0]),
        );
      },
    );

    group('when multiple Accept-Encoding headers are passed', () {
      test(
        'then they should parse the encodings correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'accept-encoding': 'gzip, deflate, br'},
          );

          expect(
            headers.acceptEncoding?.encodings?.map((e) => e.encoding).toList(),
            equals(['gzip', 'deflate', 'br']),
          );
        },
      );

      test(
        'with quality values then they should parse the encodings correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'accept-encoding': 'gzip;q=1.0, deflate;q=0.5, br;q=0.8'},
          );

          expect(
            headers.acceptEncoding?.encodings?.map((e) => e.encoding).toList(),
            equals(['gzip', 'deflate', 'br']),
          );
        },
      );

      test(
        'with quality values then they should parse the qualities correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'accept-encoding': 'gzip;q=1.0, deflate;q=0.5, br;q=0.8'},
          );

          expect(
            headers.acceptEncoding?.encodings?.map((e) => e.quality).toList(),
            equals([1.0, 0.5, 0.8]),
          );
        },
      );

      test(
        'with duplicated values then it should remove duplicates and parse '
        'the encodings correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'accept-encoding': 'gzip, gzip, deflate, br'},
          );

          expect(
            headers.acceptEncoding?.encodings?.map((e) => e.encoding).toList(),
            equals(['gzip', 'deflate', 'br']),
          );
        },
      );

      test(
        'with extra whitespace then it should parse the encodings correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'accept-encoding': ' gzip , deflate , br '},
          );

          expect(
            headers.acceptEncoding?.encodings?.map((e) => e.encoding).toList(),
            equals(['gzip', 'deflate', 'br']),
          );
        },
      );
    });
  });

  group('Given an Accept-Encoding header with the strict flag false', () {
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

    group('when an invalid Accept-Encoding header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'accept-encoding': ''},
          );

          expect(headers.acceptEncoding, isNull);
        },
      );

      test(
        'then it should be recorded in failedHeadersToParse',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'accept-encoding': ''},
          );

          expect(headers.failedHeadersToParse['accept-encoding'], equals(['']));
        },
      );
    });

    group('when Accept-Encoding headers with invalid quality values are passed',
        () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'accept-encoding': 'gzip;q=abc, deflate, br'},
          );

          expect(headers.acceptEncoding, isNull);
        },
      );

      test(
        'then they should be recorded in failedHeadersToParse',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'accept-encoding': 'gzip;q=abc, deflate, br'},
          );

          expect(
            headers.failedHeadersToParse['accept-encoding'],
            equals(['gzip;q=abc', 'deflate', 'br']),
          );
        },
      );
    });
  });
}
