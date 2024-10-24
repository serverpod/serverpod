import 'package:relic/src/headers.dart';
import 'package:test/test.dart';
import 'package:relic/src/relic_server.dart';
import 'dart:io';
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

  group('Via Header Tests', () {
    test('Given a valid Via header, it should parse correctly as a list',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'via': '1.1 example.com, 1.0 proxy.com'},
      );

      expect(headers.via, equals(['1.1 example.com', '1.0 proxy.com']));
    });

    test('Given no Via header, it should be null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.via, isNull);
    });

    test('Given an empty Via header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'via': ''},
      );

      expect(headers.via, isNull);
    });

    test(
        'Given a Via header with multiple values as a single string, it should split them correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'via': '1.1 example.com, 1.0 proxy.com'},
      );

      expect(headers.via, equals(['1.1 example.com', '1.0 proxy.com']));
    });
  });
}
