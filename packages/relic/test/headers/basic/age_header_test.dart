import 'dart:io';
import 'package:relic/src/headers.dart';
import 'package:relic/src/relic_server.dart';
import 'package:test/test.dart';

import '../../test_util.dart';

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

  group('Age Header Tests', () {
    test('Given a valid Age header, it should parse correctly as an integer',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'age': '3600'},
      );

      expect(headers.age, equals(3600));
    });

    test('Given a non-integer Age header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'age': 'invalid-age'},
      );

      expect(headers.age, isNull);
    });

    test('Given no Age header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.age, isNull);
    });

    test('Given an empty Age header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'age': ''},
      );

      expect(headers.age, isNull);
    });
  });
}
