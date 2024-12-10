import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Strict-Transport-Security header with the strict flag true',
      () {
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
      'when an empty Strict-Transport-Security header is passed then the server should respond with a bad request '
      'including a message that states the value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'strict-transport-security': ''},
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
      'when a Strict-Transport-Security header with invalid max-age is passed '
      'then the server should respond with a bad request including a message '
      'that states the max-age directive is missing or invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'strict-transport-security': 'max-age=abc'},
          ),
          throwsA(isA<BadRequestException>().having(
            (e) => e.message,
            'message',
            contains('Max-age directive is missing or invalid'),
          )),
        );
      },
    );

    test(
      'when a Strict-Transport-Security header without max-age is passed then '
      'the server should respond with a bad request including a message that '
      'states the max-age directive is missing or invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'strict-transport-security': 'includeSubDomains'},
          ),
          throwsA(isA<BadRequestException>().having(
            (e) => e.message,
            'message',
            contains('Max-age directive is missing or invalid'),
          )),
        );
      },
    );

    test(
      'when a valid Strict-Transport-Security header is passed then it should parse the directives correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {
            'strict-transport-security': 'max-age=31536000; includeSubDomains'
          },
        );

        final hsts = headers.strictTransportSecurity;
        expect(hsts?.maxAge, equals(31536000));
        expect(hsts?.includeSubDomains, isTrue);
      },
    );

    test(
      'when a Strict-Transport-Security header without includeSubDomains is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'strict-transport-security': 'max-age=31536000'},
        );

        final hsts = headers.strictTransportSecurity;
        expect(hsts?.maxAge, equals(31536000));
        expect(hsts?.includeSubDomains, isFalse);
      },
    );

    test(
      'when a Strict-Transport-Security header with preload is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'strict-transport-security': 'max-age=31536000; preload'},
        );

        final hsts = headers.strictTransportSecurity;
        expect(hsts?.maxAge, equals(31536000));
        expect(hsts?.preload, isTrue);
      },
    );

    test(
      'when no Strict-Transport-Security header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.strictTransportSecurity, isNull);
      },
    );
  });

  group('Given a Strict-Transport-Security header with the strict flag false',
      () {
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

    group('when an empty Strict-Transport-Security header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'strict-transport-security': ''},
          );

          expect(headers.strictTransportSecurity, isNull);
        },
      );
      test(
        ' then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'strict-transport-security': ''},
          );

          expect(
            headers.failedHeadersToParse['strict-transport-security'],
            equals(['']),
          );
        },
      );
    });
  });
}
