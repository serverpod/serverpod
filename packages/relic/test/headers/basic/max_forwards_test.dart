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

  group('Max-Forwards Header Tests', () {
    test(
        'Given a valid Max-Forwards header, it should parse correctly as an integer',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'Max-Forwards': '10'},
      );

      expect(headers.maxForwards, equals(10));
    });

    test(
        'Given an invalid Max-Forwards header (non-integer), it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'Max-Forwards': 'invalid-number'},
      );

      expect(headers.maxForwards, isNull);
    });

    test('Given no Max-Forwards header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.maxForwards, isNull);
    });

    test('Given an empty Max-Forwards header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'Max-Forwards': ''},
      );

      expect(headers.maxForwards, isNull);
    });
  });
}
