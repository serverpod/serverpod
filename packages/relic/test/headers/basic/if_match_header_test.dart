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

  group('If-Match Header Tests', () {
    test('Given a single If-Match value, it should parse correctly', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'if-match': '"etag123"'},
      );

      expect(headers.ifMatch, equals(['"etag123"']));
    });

    test('Given multiple If-Match values, it should parse all values as a list',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'if-match': '"etag123", "etag456"'},
      );

      expect(headers.ifMatch, equals(['"etag123"', '"etag456"']));
    });

    test('Given no If-Match header, it should be null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.ifMatch, isNull);
    });

    test('Given an empty If-Match header,  it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'if-match': ''},
      );

      expect(headers.ifMatch, isNull);
    });

    test(
        'Given If-Match header with multiple values as a single string, it should split them correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'if-match': '"etag123", "etag456"'},
      );

      expect(headers.ifMatch, equals(['"etag123"', '"etag456"']));
    });
  });
}
