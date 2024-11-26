import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';
import '../headers_test_utils.dart';

import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/From
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a From header with the strict flag true', () {
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
      'when an empty From header is passed then the server responds '
      'with a bad request including a message that states the header value '
      'cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'from': ''},
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
      'when a From header with an invalid email format is passed '
      'then the server responds with a bad request including a message that '
      'states the email format is invalid',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'from': 'invalid-email-format'},
          ),
          throwsA(
            isA<BadRequestException>().having(
              (e) => e.message,
              'message',
              contains('Invalid email format'),
            ),
          ),
        );
      },
    );

    test(
      'when a valid From header is passed then it should parse the email correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'from': 'user@example.com'},
        );

        expect(headers.from?.emails, equals(['user@example.com']));
      },
    );

    test(
      'when a From header with extra whitespace is passed then it should parse the email correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'from': ' user@example.com '},
        );

        expect(headers.from?.emails, equals(['user@example.com']));
      },
    );

    group('when multiple', () {
      test(
        'From headers are passed then they should parse all emails correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'from': 'user1@example.com, user2@example.com'},
          );

          expect(
            headers.from?.emails,
            equals(['user1@example.com', 'user2@example.com']),
          );
        },
      );

      test(
        'From headers with extra whitespace are passed then they should parse all emails correctly',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'from': ' user1@example.com , user2@example.com '},
          );

          expect(
            headers.from?.emails,
            equals(['user1@example.com', 'user2@example.com']),
          );
        },
      );

      test(
        'From headers with extra duplicate values are passed then they should '
        'parse all emails correctly and remove duplicates',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {
              'from': 'user1@example.com, user2@example.com, user1@example.com'
            },
          );

          expect(
            headers.from?.emails,
            equals(['user1@example.com', 'user2@example.com']),
          );
        },
      );

      test(
        'From headers with an invalid email format among valid ones are passed '
        'then the server responds with a bad request including a message that '
        'states the email format is invalid',
        () async {
          expect(
            () async => await getServerRequestHeaders(
              server: server,
              headers: {
                'from':
                    'user1@example.com, invalid-email-format, user2@example.com'
              },
            ),
            throwsA(
              isA<BadRequestException>().having(
                (e) => e.message,
                'message',
                contains('Invalid email format'),
              ),
            ),
          );
        },
      );
    });

    test(
      'when no From header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.from, isNull);
      },
    );
  });

  group('Given a From header with the strict flag false', () {
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

    group('when an invalid From header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'from': 'invalid-email-format'},
          );

          expect(headers.from, isNull);
        },
      );

      test(
        'then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'from': 'invalid-email-format'},
          );

          expect(
            headers.failedHeadersToParse['from'],
            equals(['invalid-email-format']),
          );
        },
      );
    });

    test(
      'when multiple From headers with an invalid email format among valid ones are passed '
      'then they should be recorded in failedHeadersToParse',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {
            'from': 'user1@example.com, invalid-email-format, user2@example.com'
          },
        );

        expect(
          headers.failedHeadersToParse['from'],
          equals([
            'user1@example.com',
            'invalid-email-format',
            'user2@example.com'
          ]),
        );
      },
    );
  });
}
