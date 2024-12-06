import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Vary
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Vary header with the strict flag true', () {
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
      'when an empty Vary header is passed then the server should respond with a bad request '
      'including a message that states the value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'vary': ''},
          ),
          throwsA(isA<BadRequestException>().having(
            (e) => e.message,
            'message',
            contains('Value cannot be empty'),
          )),
        );
      },
    );

    test(
      'when a Vary header with a wildcard (*) is used with another header then '
      'the server responds with a bad request including a message that states '
      'the wildcard (*) cannot be used with other values',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'vary': '* , User-Agent'},
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
      'when a Vary header is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'vary': 'Accept-Encoding, User-Agent'},
        );

        expect(
          headers.vary?.fields,
          equals(['Accept-Encoding', 'User-Agent']),
        );
      },
    );

    test(
      'when a Vary header with whitespace is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'vary': ' Accept-Encoding , User-Agent '},
        );

        expect(
          headers.vary?.fields,
          equals(['Accept-Encoding', 'User-Agent']),
        );
      },
    );

    test(
      'when a Vary header with wildcard (*) is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'vary': '*'},
        );

        expect(headers.vary?.isWildcard, isTrue);
        expect(headers.vary?.fields, isNull);
      },
    );

    test(
      'when no Vary header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.vary, isNull);
      },
    );
  });

  group('Given a Vary header with the strict flag false', () {
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

    group('when an empty Vary header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'vary': ''},
          );

          expect(headers.vary, isNull);
        },
      );
      test(
        'then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'vary': ''},
          );

          expect(
            headers.failedHeadersToParse['vary'],
            equals(['']),
          );
        },
      );
    });
  });
}
