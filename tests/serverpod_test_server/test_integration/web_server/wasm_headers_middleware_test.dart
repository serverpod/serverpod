import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';

void main() {
  late http.Client client;

  setUpAll(() {
    client = http.Client();
  });

  tearDownAll(() {
    client.close();
  });

  group('Given wasmHeadersMiddleware', () {
    late Serverpod pod;
    late int port;

    final portZeroConfig = ServerConfig(
      port: 0,
      publicScheme: 'http',
      publicHost: 'localhost',
      publicPort: 0,
    );

    setUp(() async {
      pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
      );

      pod.webServer.addMiddleware(const WasmHeadersMiddleware(), '/test');
      pod.webServer.addRoute(_TestRoute('test response'), '/test/route');

      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when Response is returned then WASM headers are added', () async {
      final response = await client.get(
        Uri.http('localhost:$port', '/test/route'),
      );
      expect(response.statusCode, 200);
      expect(response.body, 'test response');
      expect(response.headers['cross-origin-opener-policy'], 'same-origin');
      expect(response.headers['cross-origin-embedder-policy'], 'require-corp');
    });

    test(
      'when Response has existing headers then WASM headers are added preserving existing',
      () async {
        final response = await client.get(
          Uri.http('localhost:$port', '/test/route'),
        );
        expect(response.statusCode, 200);
        expect(response.headers['content-type'], contains('text/plain'));
        expect(response.headers['cross-origin-opener-policy'], 'same-origin');
        expect(
          response.headers['cross-origin-embedder-policy'],
          'require-corp',
        );
      },
    );
  });

  group('Given wasmHeadersMiddleware applied to multiple routes', () {
    late Serverpod pod;
    late int port;

    final portZeroConfig = ServerConfig(
      port: 0,
      publicScheme: 'http',
      publicHost: 'localhost',
      publicPort: 0,
    );

    setUp(() async {
      pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
      );

      pod.webServer.addMiddleware(const WasmHeadersMiddleware(), '/');
      pod.webServer.addRoute(_TestRoute('route1'), '/route1');
      pod.webServer.addRoute(_TestRoute('route2'), '/route2');

      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when applied to route then all responses get headers', () async {
      final response1 = await client.get(
        Uri.http('localhost:$port', '/route1'),
      );
      expect(response1.statusCode, 200);
      expect(response1.headers['cross-origin-opener-policy'], 'same-origin');
      expect(response1.headers['cross-origin-embedder-policy'], 'require-corp');

      final response2 = await client.get(
        Uri.http('localhost:$port', '/route2'),
      );
      expect(response2.statusCode, 200);
      expect(response2.headers['cross-origin-opener-policy'], 'same-origin');
      expect(response2.headers['cross-origin-embedder-policy'], 'require-corp');
    });
  });
}

/// Test route that returns a simple text response
class _TestRoute extends Route {
  final String response;

  _TestRoute(this.response);

  @override
  FutureOr<Result> handleCall(Session session, Request req) {
    return Response.ok(body: Body.fromString(response));
  }
}
