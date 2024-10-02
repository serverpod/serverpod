import 'dart:io';
import 'package:relic/src/headers.dart';
import 'package:relic/src/method/method.dart';
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

  group('Access-Control-Request-Method Tests', () {
    test(
        'Given a valid Access-Control-Request-Method header, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-request-method': 'POST'},
      );

      expect(
          headers.accessControlRequestMethod?.value, equals(Method.post.value));
    });

    test(
        'Given a custom Access-Control-Request-Method header, it should parse as a new method',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-request-method': 'CUSTOM'},
      );

      expect(headers.accessControlRequestMethod?.value, equals('CUSTOM'));
    });

    test('Given no Access-Control-Request-Method header, it should be null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.accessControlRequestMethod, isNull);
    });

    test(
        'Given an empty Access-Control-Request-Method header, it should be null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-request-method': ''},
      );

      expect(headers.accessControlRequestMethod, isNull);
    });

    test(
        'Given a method that is not predefined, it should be parsed as a new method',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-request-method': 'customMethod'},
      );

      expect(headers.accessControlRequestMethod?.value, equals('CUSTOMMETHOD'));
    });

    test(
        'Given mixed-case method name, it should normalize to the correct predefined method',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-request-method': 'get'},
      );

      expect(
          headers.accessControlRequestMethod?.value, equals(Method.get.value));
    });

    test(
        'Given a single Access-Control-Request-Method header with multiple methods, it should parse the correct method',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-request-method': 'POST'},
      );

      expect(
          headers.accessControlRequestMethod?.value, equals(Method.post.value));
    });
  });
}
