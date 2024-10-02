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

  group('AccessControlAllowCredentials Header Tests', () {
    test(
        'Given a valid Access-Control-Allow-Credentials header, it should parse as true',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-allow-credentials': 'true'},
      );

      expect(headers.accessControlAllowCredentials, isTrue);
    });

    test(
        'Given an invalid Access-Control-Allow-Credentials header, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-allow-credentials': 'invalid-value'},
      );

      expect(headers.accessControlAllowCredentials, isNull);
    });

    test(
        'Given no Access-Control-Allow-Credentials header, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.accessControlAllowCredentials, isNull);
    });
  });
}
