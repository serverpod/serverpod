import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Clear-Site-Data
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Clear-Site-Data header with the strict flag true', () {
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
      'when an empty Clear-Site-Data header is passed then the server should '
      'respond with a bad request including a message that states the value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'clear-site-data': ''},
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
      'when an invalid Clear-Site-Data header is passed then the server should '
      'respond with a bad request including a message that states the value '
      'is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'clear-site-data': 'invalidValue'},
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
      'when a Clear-Site-Data header with wildcard (*) and other data types is '
      'passed then the server should respond with a bad request including a '
      'message that states the wildcard cannot be used with other values',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'clear-site-data': '"cache", "*", "cookies"'},
          ),
          throwsA(isA<BadRequestException>().having(
            (e) => e.message,
            'message',
            contains('Wildcard (*) cannot be used with other values'),
          )),
        );
      },
    );

    test(
      'when a valid Clear-Site-Data header is passed then it should parse the data types correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'clear-site-data': '"cache", "cookies", "storage"'},
        );

        final dataTypes = headers.clearSiteData?.dataTypes;
        expect(dataTypes?.length, equals(3));
        expect(
          dataTypes?.map((dt) => dt.value).toList(),
          containsAll(['cache', 'cookies', 'storage']),
        );
      },
    );

    test(
      'when a Clear-Site-Data header with wildcard is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'clear-site-data': '*'},
        );

        expect(headers.clearSiteData?.isWildcard, isTrue);
      },
    );

    test(
      'when no Clear-Site-Data header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.clearSiteData, isNull);
      },
    );
  });

  group('Given a Clear-Site-Data header with the strict flag false', () {
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

    group('When an empty Clear-Site-Data header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'clear-site-data': ''},
          );

          expect(headers.clearSiteData, isNull);
        },
      );

      test(
        'then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'clear-site-data': ''},
          );

          expect(
            headers.failedHeadersToParse['clear-site-data'],
            equals(['']),
          );
        },
      );
    });
  });
}
