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

  group('Accept-Ranges Header Tests', () {
    test('Given a valid Accept-Ranges header, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'accept-ranges': 'bytes'},
      );

      expect(headers.acceptRanges, equals(['bytes']));
    });

    test(
        'Given multiple Accept-Ranges values in a single string, it should parse them as a list',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'accept-ranges': 'bytes, none'},
      );

      expect(headers.acceptRanges, equals(['bytes', 'none']));
    });

    test('Given no Accept-Ranges header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.acceptRanges, isNull);
    });

    test('Given an empty Accept-Ranges header, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'accept-ranges': ''},
      );

      expect(headers.acceptRanges, isNull);
    });
  });
}
