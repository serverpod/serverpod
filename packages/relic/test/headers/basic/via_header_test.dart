import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';
import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Via
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Via header with the strict flag true', () {
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
      'when an empty Via header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'via': ''},
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
      'when a valid Via header is passed then it should parse the values correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'via': '1.1 example.com, 1.0 another.com'},
        );

        expect(headers.via, equals(['1.1 example.com', '1.0 another.com']));
      },
    );

    test(
      'when a Via header with extra whitespace is passed then it should parse the values correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'via': ' 1.1 example.com , 1.0 another.com '},
        );

        expect(headers.via, equals(['1.1 example.com', '1.0 another.com']));
      },
    );

    test(
      'when a Via header with duplicate values is passed then it should parse '
      'the values correctly and remove duplicates',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'via': '1.1 example.com, 1.0 another.com, 1.0 another.com'},
        );

        expect(headers.via, equals(['1.1 example.com', '1.0 another.com']));
      },
    );

    test(
      'when no Via header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.via, isNull);
      },
    );
  });

  group('Given a Via header with the strict flag false', () {
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

    group('when an empty Via header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'via': ''},
          );

          expect(headers.via, isNull);
        },
      );

      test(
        'then it should be recorded in failedHeadersToParse',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'via': ''},
          );

          expect(headers.failedHeadersToParse['via'], equals(['']));
        },
      );
    });
  });
}
