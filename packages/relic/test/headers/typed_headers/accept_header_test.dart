import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given an Accept header with the strict flag true', () {
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
      'when an empty Accept header is passed then the server should respond with a bad request '
      'including a message that states the value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'accept': ''},
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
      'when an Accept header with invalid quality value is passed then the server '
      'should respond with a bad request including a message that states the '
      'quality value is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'accept': 'text/html;q=abc'},
          ),
          throwsA(isA<BadRequestException>().having(
            (e) => e.message,
            'message',
            contains('Invalid quality value'),
          )),
        );
      },
    );

    test(
      'when a valid Accept header is passed then it should parse the media types correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'accept': 'text/html'},
        );

        final mediaRanges = headers.accept?.mediaRanges;
        expect(mediaRanges?.length, equals(1));
        expect(mediaRanges?[0].type, equals('text'));
        expect(mediaRanges?[0].subtype, equals('html'));
      },
    );

    test(
      'when a valid Accept header with no quality value is passed then the '
      'quality value should set to default of 1.0',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'accept': 'text/html'},
        );

        final mediaRanges = headers.accept?.mediaRanges;
        expect(mediaRanges?.length, equals(1));
        expect(mediaRanges?[0].quality, equals(1.0));
      },
    );

    test(
      'when a valid Accept header with quality value is passed then it should parse the quality value correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'accept': 'text/html;q=0.8'},
        );

        final mediaRanges = headers.accept?.mediaRanges;
        expect(mediaRanges?.length, equals(1));
        expect(mediaRanges?[0].quality, equals(0.8));
      },
    );

    test(
      'when an Accept header with wildcard (*) is passed then it should parse the wildcard correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'accept': '*/*'},
        );

        final mediaRanges = headers.accept?.mediaRanges;
        expect(mediaRanges?.length, equals(1));
        expect(mediaRanges?[0].type, equals('*'));
        expect(mediaRanges?[0].subtype, equals('*'));
      },
    );

    test(
      'when no Accept header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.accept, isNull);
      },
    );

    group('when multiple Accept media ranges are passed', () {
      test(
        'with invalid quality values are passed then the server should respond with a bad request '
        'including a message that states the quality value is invalid',
        () async {
          expect(
            () async => await getServerRequestHeaders(
              server: server,
              headers: {
                'accept': 'text/html;q=test, application/json;q=abc, */*;q=0.5'
              },
            ),
            throwsA(isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid quality value'),
            )),
          );
        },
      );
      test(
        'with different quality values are passed then they should parse correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {
              'accept': 'text/html;q=0.8, application/json;q=0.9, */*;q=0.5'
            },
          );

          final mediaRanges = headers.accept?.mediaRanges;
          expect(mediaRanges?.length, equals(3));
          expect(mediaRanges?[0].type, equals('text'));
          expect(mediaRanges?[0].subtype, equals('html'));
          expect(mediaRanges?[1].type, equals('application'));
          expect(mediaRanges?[1].subtype, equals('json'));
          expect(mediaRanges?[2].type, equals('*'));
          expect(mediaRanges?[2].subtype, equals('*'));
        },
      );

      test(
        'with different quality values are passed then it should parse the quality values correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {
              'accept': 'text/html;q=0.8, application/json;q=0.9, */*;q=0.5'
            },
          );

          final mediaRanges = headers.accept?.mediaRanges;
          expect(mediaRanges?.length, equals(3));
          expect(mediaRanges?[0].quality, equals(0.8));
          expect(mediaRanges?[1].quality, equals(0.9));
          expect(mediaRanges?[2].quality, equals(0.5));
        },
      );
    });
  });

  group('Given an Accept header with the strict flag false', () {
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

    group('when an Accept header with invalid quality value is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'accept': 'text/html;q=abc'},
          );

          expect(headers.accept, isNull);
        },
      );
      test(
        'then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'accept': 'text/html;q=abc'},
          );

          expect(
            headers.failedHeadersToParse['accept'],
            equals(['text/html;q=abc']),
          );
        },
      );
    });
  });
}
