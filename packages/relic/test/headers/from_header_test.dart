import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('FromHeader Class Tests', () {
    test('FromHeader should parse a single email correctly', () {
      var fromHeader = FromHeader(['user@example.com']);

      expect(fromHeader.emails.length, equals(1));
      expect(fromHeader.emails.first, equals('user@example.com'));
    });

    test('FromHeader should parse multiple emails correctly', () {
      var fromHeader = FromHeader(['user1@example.com, user2@example.com']);

      expect(fromHeader.emails.length, equals(2));
      expect(fromHeader.emails[0], equals('user1@example.com'));
      expect(fromHeader.emails[1], equals('user2@example.com'));
    });

    test('FromHeader should return null for tryParse when input is null', () {
      var fromHeader = FromHeader.tryParse(null);

      expect(fromHeader, isNull);
    });

    test('FromHeader should handle empty string input and return an empty list',
        () {
      var fromHeader = FromHeader(['']);

      expect(fromHeader.emails.isEmpty, isTrue);
    });

    test(
        'FromHeader should return correct string representation of multiple emails',
        () {
      var fromHeader = FromHeader(['user1@example.com, user2@example.com']);
      var result = fromHeader.toString();

      expect(result, equals('user1@example.com, user2@example.com'));
    });

    test(
        'FromHeader should return the single email when there is only one email',
        () {
      var fromHeader = FromHeader(['user@example.com']);

      expect(fromHeader.singleEmail, equals('user@example.com'));
    });

    test(
        'FromHeader should return null for singleEmail when there are multiple emails',
        () {
      var fromHeader = FromHeader(['user1@example.com, user2@example.com']);

      expect(fromHeader.singleEmail, isNull);
    });
  });

  group('FromHeader HttpRequestMock Tests', () {
    test('Given a valid From header, it should parse correctly', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('from', 'user@example.com');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.from.toString(), equals('user@example.com'));
    });

    test('Given multiple From headers, it should parse all values correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('from', 'user1@example.com')
        ..headers.add('from', 'user2@example.com');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.from.toString(),
          equals('user1@example.com, user2@example.com'));
    });

    test('Given no From header, it should return null', () {
      var httpRequest = HttpRequestMock(); // No 'from' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.from, isNull);
    });

    test('Given an empty From header, it should return an empty list', () {
      var httpRequest = HttpRequestMock()..headers.add('from', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.from?.emails.isEmpty, isTrue);
    });

    test(
        'Given a From header with multiple values in a single string, it should split them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('from', 'user1@example.com, user2@example.com');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.from.toString(),
          equals('user1@example.com, user2@example.com'));
    });
  });
}
