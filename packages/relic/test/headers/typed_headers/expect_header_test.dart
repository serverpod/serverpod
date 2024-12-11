import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';
import '../headers_test_utils.dart';

import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Expect
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given an Expect header with the strict flag true', () {
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
      'when an empty Expect header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'expect': ''},
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
      'when an invalid Expect header is passed then the server should respond with a bad request '
      'including a message that states the value is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'expect': 'custom-directive'},
          ),
          throwsA(isA<BadRequestException>().having(
            (e) => e.message,
            'message',
            contains('Invalid value'),
          )),
        );
      },
    );

    test(
      'when a valid Expect header is passed then it should parse the directives correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'expect': '100-continue'},
        );

        expect(
          headers.expect?.value,
          contains('100-continue'),
        );
      },
    );
  });

  group('Given an Expect header with the strict flag false', () {
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

    group('when an empty Expect header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'expect': ''},
          );

          expect(headers.expect, isNull);
        },
      );

      test(
        'then it should be recorded in "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'expect': ''},
          );

          expect(
            headers.failedHeadersToParse['expect'],
            equals(['']),
          );
        },
      );
    });
  });
}
