import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Language
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Content-Language header with the strict flag true', () {
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
      'when an empty Content-Language header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'content-language': ''},
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
      'when an invalid language code is passed then the server responds with a '
      'bad request including a message that states the language code is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'content-language': 'en-123'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid language code'),
            ),
          ),
        );
      },
    );

    test(
      'when a single valid language is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'content-language': 'en'},
        );

        expect(headers.contentLanguage?.languages, equals(['en']));
      },
    );

    group('when multiple Content-Language languages are passed', () {
      test('then they should parse correctly', () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'content-language': 'en, fr, de'},
        );

        expect(headers.contentLanguage?.languages, equals(['en', 'fr', 'de']));
      });

      test('with extra whitespace then they should parse correctly', () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'content-language': ' en , fr , de '},
        );

        expect(headers.contentLanguage?.languages, equals(['en', 'fr', 'de']));
      });

      test(
          'with duplicate languages then they should parse correctly and remove duplicates',
          () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'content-language': 'en, fr, de, en'},
        );

        expect(headers.contentLanguage?.languages, equals(['en', 'fr', 'de']));
      });
    });

    test(
      'when no Content-Language header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.contentLanguage, isNull);
      },
    );
  });

  group('Given a Content-Language header with the strict flag false', () {
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

    group('when an invalid Content-Language header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'content-language': 'en-123'},
          );

          expect(headers.contentLanguage, isNull);
        },
      );

      test(
        'then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'content-language': 'en-123'},
          );

          expect(
            headers.failedHeadersToParse['content-language'],
            equals(['en-123']),
          );
        },
      );
    });
  });
}
