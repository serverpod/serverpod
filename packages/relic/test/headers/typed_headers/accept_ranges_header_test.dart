import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept-Ranges
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given an Accept-Ranges header with the strict flag true', () {
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
      'when an empty Accept-Ranges header is passed then the server should respond with a bad request '
      'including a message that states the value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'accept-ranges': ''},
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
      'when a valid Accept-Ranges header is passed then it should parse the range unit correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'accept-ranges': 'bytes'},
        );

        expect(headers.acceptRanges?.rangeUnit, equals('bytes'));
        expect(headers.acceptRanges?.isBytes, isTrue);
      },
    );

    test(
      'when a Accept-Ranges header with "none" is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'accept-ranges': 'none'},
        );

        expect(headers.acceptRanges?.rangeUnit, equals('none'));
        expect(headers.acceptRanges?.isNone, isTrue);
      },
    );

    test(
      'when no Accept-Ranges header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.acceptRanges, isNull);
      },
    );
  });

  group('Given an Accept-Ranges header with the strict flag false', () {
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

    group('when an empty Accept-Ranges header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'accept-ranges': ''},
          );

          expect(headers.acceptRanges, isNull);
        },
      );
      test(
        'then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'accept-ranges': ''},
          );

          expect(
            headers.failedHeadersToParse['accept-ranges'],
            equals(['']),
          );
        },
      );
    });
  });
}
