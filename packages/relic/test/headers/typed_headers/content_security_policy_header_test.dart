import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Content-Security-Policy header with the strict flag true', () {
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
      'when an empty Content-Security-Policy header is passed then the server should respond with a bad request '
      'including a message that states the value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'content-security-policy': ''},
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
      'when a valid Content-Security-Policy header is passed then it should parse the directives correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {
            'content-security-policy': "default-src 'self'; script-src 'none'"
          },
        );

        final csp = headers.contentSecurityPolicy;
        expect(csp?.directives.length, equals(2));
        expect(csp?.directives[0].name, equals('default-src'));
        expect(csp?.directives[0].values, equals(["'self'"]));
        expect(csp?.directives[1].name, equals('script-src'));
        expect(csp?.directives[1].values, equals(["'none'"]));
      },
    );

    test(
      'when a Content-Security-Policy header with multiple directives is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {
            'content-security-policy':
                "default-src 'self'; img-src *; media-src media1.com media2.com"
          },
        );

        final csp = headers.contentSecurityPolicy;
        expect(csp?.directives.length, equals(3));
        expect(csp?.directives[0].name, equals('default-src'));
        expect(csp?.directives[0].values, equals(["'self'"]));
        expect(csp?.directives[1].name, equals('img-src'));
        expect(csp?.directives[1].values, equals(['*']));
        expect(csp?.directives[2].name, equals('media-src'));
        expect(csp?.directives[2].values, equals(['media1.com', 'media2.com']));
      },
    );

    test(
      'when no Content-Security-Policy header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.contentSecurityPolicy, isNull);
      },
    );
  });

  group('Given a Content-Security-Policy header with the strict flag false',
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

    group('when an empty Content-Security-Policy header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'content-security-policy': ''},
          );

          expect(headers.contentSecurityPolicy, isNull);
        },
      );
      test(
        'then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'content-security-policy': ''},
          );

          expect(
            headers.failedHeadersToParse['content-security-policy'],
            equals(['']),
          );
        },
      );
    });
  });
}
