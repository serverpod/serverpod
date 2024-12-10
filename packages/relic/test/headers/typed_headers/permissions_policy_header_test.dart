import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Permissions-Policy
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Permissions-Policy header with the strict flag true', () {
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
      'when an empty Permissions-Policy header is passed then the server should respond with a bad request '
      'including a message that states the value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'permissions-policy': ''},
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
      'when a valid Permissions-Policy header is passed then it should parse the policies correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'permissions-policy': 'geolocation=(self), microphone=()'},
        );

        final policies = headers.permissionsPolicy?.directives;
        expect(policies?.length, equals(2));
        expect(policies?[0].name, equals('geolocation'));
        expect(policies?[0].values, equals(['self']));
        expect(policies?[1].name, equals('microphone'));
        expect(policies?[1].values, equals(['']));
      },
    );

    test(
      'when a Permissions-Policy header with multiple policies is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {
            'permissions-policy':
                'geolocation=(self), camera=(self "https://example.com")'
          },
        );

        final policies = headers.permissionsPolicy?.directives;
        expect(policies?.length, equals(2));
        expect(policies?[0].name, equals('geolocation'));
        expect(policies?[0].values, equals(['self']));
        expect(policies?[1].name, equals('camera'));
        expect(policies?[1].values, equals(['self', '"https://example.com"']));
      },
    );

    test(
      'when no Permissions-Policy header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.permissionsPolicy, isNull);
      },
    );
  });

  group('Given a Permissions-Policy header with the strict flag false', () {
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

    group('when an empty Permissions-Policy header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'permissions-policy': ''},
          );

          expect(headers.permissionsPolicy, isNull);
        },
      );

      test(
        'then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'permissions-policy': ''},
          );

          expect(
            headers.failedHeadersToParse['permissions-policy'],
            equals(['']),
          );
        },
      );
    });
  });
}
