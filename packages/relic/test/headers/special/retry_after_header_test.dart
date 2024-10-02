import 'dart:io';

import 'package:relic/src/headers.dart';
import 'package:relic/src/relic_server.dart';
import 'package:test/test.dart';

import '../../static/test_util.dart';

void main() {
  late RelicServer server;

  setUp(() async {
    try {
      server = await RelicServer.bind(InternetAddress.loopbackIPv6, 0);
    } on SocketException catch (_) {
      server = await RelicServer.bind(InternetAddress.loopbackIPv4, 0);
    }
  });

  tearDown(() => server.close());

  group('RetryAfterHeader Class Tests', () {
    test('RetryAfterHeader should parse a valid delay in seconds', () {
      var headerValue = '120'; // Retry after 120 seconds
      var retryAfterHeader = RetryAfterHeader.fromHeaderValue(headerValue);

      expect(retryAfterHeader.delay, equals(120));
      expect(retryAfterHeader.date, isNull);
    });

    test('RetryAfterHeader should parse a valid date', () {
      var headerValue =
          'Wed, 21 Oct 2015 07:28:00 GMT'; // Valid HTTP date format
      var retryAfterHeader = RetryAfterHeader.fromHeaderValue(headerValue);

      expect(retryAfterHeader.delay, isNull);
      expect(
          retryAfterHeader.date, equals(DateTime.utc(2015, 10, 21, 7, 28, 0)));
    });

    test(
        'RetryAfterHeader should throw an exception for an invalid date format',
        () {
      var headerValue = 'Invalid Date';

      expect(
        () => RetryAfterHeader.fromHeaderValue(headerValue),
        throwsA(isA<FormatException>()),
      );
    });

    test('RetryAfterHeader should return null when parsing a null value', () {
      var retryAfterHeader = RetryAfterHeader.tryParse(null);
      expect(retryAfterHeader, isNull);
    });

    test('RetryAfterHeader should return valid string representation for delay',
        () {
      var retryAfterHeader = RetryAfterHeader(delay: 120);
      var result = retryAfterHeader.toString();

      expect(result, equals('120'));
    });

    test('RetryAfterHeader should return valid string representation for date',
        () {
      var retryAfterHeader =
          RetryAfterHeader(date: DateTime.utc(2015, 10, 21, 7, 28, 0));
      var result = retryAfterHeader.toString();

      expect(result, equals('Wed, 21 Oct 2015 07:28:00 GMT'));
    });

    test('RetryAfterHeader should handle both delay and date as null', () {
      var retryAfterHeader = RetryAfterHeader();
      var result = retryAfterHeader.toString();

      expect(result, equals(''));
    });
  });

  group('RetryAfterHeader HttpRequest Tests', () {
    test(
        'Given a valid Retry-After header with delay, it should parse correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Retry-After': '120'}, // Retry after 120 seconds
      );
      var retryAfterHeader = headers.retryAfter;

      expect(retryAfterHeader!.delay, equals(120));
      expect(retryAfterHeader.date, isNull);
    });

    test(
        'Given a valid Retry-After header with date, it should parse correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Retry-After': 'Wed, 21 Oct 2015 07:28:00 GMT'},
      );
      var retryAfterHeader = headers.retryAfter;

      expect(retryAfterHeader!.delay, isNull);
      expect(
        retryAfterHeader.date,
        equals(DateTime.utc(2015, 10, 21, 7, 28, 0)),
      );
    });

    test('Given an invalid Retry-After header, it should throw FormatException',
        () async {
      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'Retry-After': 'Invalid Date'},
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
