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

  group('If-None-Match Header Tests', () {
    test('Given a single If-None-Match value, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'if-none-match': '"etag123"'},
      );

      expect(headers.ifNoneMatch, equals(['"etag123"']));
    });

    test(
        'Given multiple If-None-Match values, it should parse all values as a list',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'if-none-match': '"etag123", "etag456"'},
      );

      expect(headers.ifNoneMatch, equals(['"etag123"', '"etag456"']));
    });

    test('Given no If-None-Match header, it should be null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.ifNoneMatch, isNull);
    });

    test('Given an empty If-None-Match header, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'if-none-match': ''},
      );

      expect(headers.ifNoneMatch, isNull);
    });

    test(
        'Given If-None-Match header with multiple values as a single string, it should split them correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'if-none-match': '"etag123", "etag456"'},
      );

      expect(headers.ifNoneMatch, equals(['"etag123"', '"etag456"']));
    });
  });
}
