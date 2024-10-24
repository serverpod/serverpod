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

  group('Content-Language Header Tests', () {
    test(
        'Given a valid Content-Language header with a single value, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'content-language': 'en'},
      );

      expect(headers.contentLanguage, equals(['en']));
    });

    test(
        'Given a valid Content-Language header with multiple values, it should parse all values',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'content-language': 'en, fr'},
      );

      expect(headers.contentLanguage, equals(['en', 'fr']));
    });

    test(
        'Given a Content-Language header with multiple values in a single string, it should split and parse them correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'content-language': 'en, fr'},
      );

      expect(headers.contentLanguage, equals(['en', 'fr']));
    });

    test('Given an empty Content-Language header, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'content-language': ''},
      );

      expect(headers.contentLanguage, isNull);
    });

    test('Given no Content-Language header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.contentLanguage, isNull);
    });
  });
}
