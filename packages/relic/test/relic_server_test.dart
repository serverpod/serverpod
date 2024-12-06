@TestOn('vm')
library;

import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:relic/src/relic_server.dart';
import 'package:test/test.dart';

import 'util/test_util.dart';

void main() {
  late RelicServer server;

  setUp(() async {
    try {
      server = await RelicServer.createServer(InternetAddress.loopbackIPv6, 0);
    } on SocketException catch (_) {
      server = await RelicServer.createServer(InternetAddress.loopbackIPv4, 0);
    }
  });

  tearDown(() => server.close());

  test('serves HTTP requests with the mounted handler', () async {
    server.mountAndStart(syncHandler);
    expect(await http.read(server.url), equals('Hello from /'));
  });

  test('Handles malformed requests gracefully.', () async {
    server.mountAndStart(syncHandler);
    final rs = await http
        .get(Uri.parse('${server.url}/%D0%C2%BD%A8%CE%C4%BC%FE%BC%D0.zip'));
    expect(rs.statusCode, 400);
    expect(rs.body, 'Bad Request');
  });

  test('delays HTTP requests until a handler is mounted', () async {
    expect(http.read(server.url), completion(equals('Hello from /')));
    await Future<void>.delayed(Duration.zero);

    server.mountAndStart(asyncHandler);
  });

  test('disallows more than one handler from being mounted', () async {
    server.mountAndStart((_) => throw UnimplementedError());
    expect(
      () => server.mountAndStart((_) => throw UnimplementedError()),
      throwsStateError,
    );
    expect(
      () => server.mountAndStart((_) => throw UnimplementedError()),
      throwsStateError,
    );
  });
}
