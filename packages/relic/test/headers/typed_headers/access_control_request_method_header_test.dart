import 'dart:io';
import 'package:relic/src/method/request_method.dart';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Request-Method
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group(
      'Given an Access-Control-Request-Method header with the strict flag true',
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
      'when an empty Access-Control-Request-Method header is passed then the '
      'server responds with a bad request including a message that states the '
      'header value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'access-control-request-method': ''},
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
      'when an invalid method is passed then the server responds '
      'with a bad request including a message that states the header value '
      'is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'access-control-request-method': 'CUSTOM'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid value'),
            ),
          ),
        );
      },
    );

    test(
      'when a valid Access-Control-Request-Method header is passed then it '
      'should parse the method correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'access-control-request-method': 'POST'},
        );

        expect(
          headers.accessControlRequestMethod,
          equals(RequestMethod.post),
        );
      },
    );

    test(
      'when an Access-Control-Request-Method header with extra whitespace is '
      'passed then it should parse the method correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'access-control-request-method': ' POST '},
        );

        expect(headers.accessControlRequestMethod, equals(RequestMethod.post));
      },
    );

    test(
      'when no Access-Control-Request-Method header is passed then it should '
      'default to null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.accessControlRequestMethod, isNull);
      },
    );
  });

  group(
      'Given an Access-Control-Request-Method header with the strict flag false',
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

    group('when an empty Access-Control-Request-Method header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'access-control-request-method': ''},
          );

          expect(headers.accessControlRequestMethod, isNull);
        },
      );

      test(
        'then it should be recorded in "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'access-control-request-method': ''},
          );

          expect(
            headers.failedHeadersToParse['access-control-request-method'],
            equals(['']),
          );
        },
      );
    });
  });
}
