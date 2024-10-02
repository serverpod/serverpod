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

  group('ConnectionHeader Class Tests', () {
    test(
        'ConnectionHeader should parse valid Connection header with single directive',
        () {
      var headerValue = 'keep-alive';
      var connectionHeader = ConnectionHeader.fromHeaderValue([headerValue]);

      expect(connectionHeader.directives.length, equals(1));
      expect(connectionHeader.isKeepAlive, isTrue);
      expect(connectionHeader.isClose, isFalse);
    });

    test('ConnectionHeader should parse multiple connection directives', () {
      var headerValue = 'upgrade, keep-alive';
      var connectionHeader = ConnectionHeader.fromHeaderValue([headerValue]);

      expect(connectionHeader.directives.length, equals(2));
      expect(connectionHeader.isKeepAlive, isTrue);
      expect(connectionHeader.directives.contains('upgrade'), isTrue);
      expect(connectionHeader.isClose, isFalse);
    });

    test('ConnectionHeader should handle `close` directive', () {
      var headerValue = 'close';
      var connectionHeader = ConnectionHeader.fromHeaderValue([headerValue]);

      expect(connectionHeader.directives.length, equals(1));
      expect(connectionHeader.isClose, isTrue);
      expect(connectionHeader.isKeepAlive, isFalse);
    });

    test('ConnectionHeader should handle empty string as input', () {
      var connectionHeader = ConnectionHeader.fromHeaderValue(['']);
      expect(connectionHeader.directives, isEmpty);
    });

    test('ConnectionHeader should return null when parsing a null value', () {
      var connectionHeader = ConnectionHeader.tryParse(null);
      expect(connectionHeader, isNull);
    });

    test(
        'ConnectionHeader should return valid string representation of the header',
        () {
      var connectionHeader =
          ConnectionHeader(directives: ['keep-alive', 'upgrade']);
      var result = connectionHeader.toString();

      expect(result, equals('keep-alive, upgrade'));
    });
  });

  group('ConnectionHeader HttpRequest Tests', () {
    test(
        'Given a valid Connection header with multiple directives, it should parse correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Connection': 'keep-alive, upgrade'},
      );
      var connectionHeader = headers.connection;

      expect(connectionHeader!.directives.length, equals(2));
      expect(connectionHeader.isKeepAlive, isTrue);
      expect(connectionHeader.directives.contains('upgrade'), isTrue);
    });

    test(
        'Given a Connection header with `close`, it should handle it correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Connection': 'close'},
      );
      var connectionHeader = headers.connection;

      expect(connectionHeader!.isClose, isTrue);
      expect(connectionHeader.isKeepAlive, isFalse);
    });

    test(
        'Given an empty Connection header, it should return null ConnectionHeader',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Connection': ''},
      );
      var connectionHeader = headers.connection;

      expect(connectionHeader, isNull);
    });
  });
}
