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

  group('FromHeader Class Tests', () {
    test('FromHeader should parse a single email correctly', () {
      var fromHeader = FromHeader(['user@example.com']);

      expect(
        fromHeader.emails.length,
        equals(1),
      );
      expect(
        fromHeader.emails.first,
        equals('user@example.com'),
      );
    });

    test('FromHeader should parse multiple emails correctly', () {
      var fromHeader = FromHeader(['user1@example.com, user2@example.com']);

      expect(
        fromHeader.emails.length,
        equals(2),
      );
      expect(
        fromHeader.emails[0],
        equals('user1@example.com'),
      );
      expect(
        fromHeader.emails[1],
        equals('user2@example.com'),
      );
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

      expect(
        result,
        equals('user1@example.com, user2@example.com'),
      );
    });

    test(
        'FromHeader should return the single email when there is only one email',
        () {
      var fromHeader = FromHeader(['user@example.com']);

      expect(
        fromHeader.singleEmail,
        equals('user@example.com'),
      );
    });

    test(
        'FromHeader should return null for singleEmail when there are multiple emails',
        () {
      var fromHeader = FromHeader(['user1@example.com, user2@example.com']);

      expect(fromHeader.singleEmail, isNull);
    });
  });

  group('FromHeader HttpRequest Tests', () {
    test('Given a valid From header, it should parse correctly', () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'From': 'user@example.com'},
      );

      expect(
        headers.from.toString(),
        equals('user@example.com'),
      );
    });

    test('Given multiple From headers, it should parse all values correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'From': 'user1@example.com, user2@example.com'},
      );

      expect(
        headers.from.toString(),
        equals('user1@example.com, user2@example.com'),
      );
    });

    test('Given no From header, it should return null', () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.from, isNull);
    });

    test('Given an empty From header, it should return null', () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'From': ''},
      );

      expect(headers.from?.emails, isNull);
    });

    test(
        'Given a From header with multiple values in a single string, it should split them correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'From': 'user1@example.com, user2@example.com'},
      );

      expect(
        headers.from.toString(),
        equals('user1@example.com, user2@example.com'),
      );
    });
  });
}