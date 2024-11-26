import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Age
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given an Age header with the strict flag true', () {
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
      'when an empty Age header is passed then the server responds with a bad '
      'request including a message that states the header value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'age': ''},
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
      'when an invalid Age header is passed then the server responds with a bad '
      'request including a message that states the age is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'age': 'invalid'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid number'),
            ),
          ),
        );
      },
    );

    test(
      'when an negative Age header is passed then the server responds with a bad '
      'request including a message that states the age must be non-negative',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'age': '-3600'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Must be non-negative'),
            ),
          ),
        );
      },
    );

    test(
      'when an non-integer Age header is passed then the server responds with a '
      'bad request including a message that states the age must be an integer',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'age': '3.14'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Must be an integer'),
            ),
          ),
        );
      },
    );

    test(
      'when a valid Age header is passed then it should parse the age correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'age': '3600'},
        );

        expect(headers.age, equals(3600));
      },
    );

    test(
      'when an Age header with extra whitespace is passed then it should parse '
      'the age correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'age': ' 3600 '},
        );

        expect(headers.age, equals(3600));
      },
    );

    test(
      'when no Age header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.age, isNull);
      },
    );
  });

  group('Given an Age header with the strict flag false', () {
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

    group('when an empty Age header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'age': ''},
          );

          expect(headers.age, isNull);
        },
      );

      test(
        'then it should be recorded in "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'age': ''},
          );

          expect(headers.failedHeadersToParse['age'], equals(['']));
        },
      );
    });

    group('when an invalid Age header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'age': 'invalid'},
          );

          expect(headers.age, isNull);
        },
      );

      test(
        'then it should be recorded in "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'age': 'invalid'},
          );

          expect(headers.failedHeadersToParse['age'], equals(['invalid']));
        },
      );
    });
  });
}
