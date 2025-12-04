import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  late Serverpod pod;
  late int port;

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

    pod.webServer.addRoute(TestRoute('existing'), '/existing');

    await pod.start();
    port = pod.webServer.port!;
  });

  tearDown(() async {
    await pod.shutdown(exitProcess: false);
  });

  group('Given a fallback route is set', () {
    setUp(() async {
      pod.webServer.fallbackRoute = TestRoute('fallback');
    });

    test('when client requests an existing route, '
        'then the route handler is called', () async {
      var response = await http.get(
        Uri.http('localhost:$port', '/existing'),
      );
      expect(response.statusCode, 200);
      expect(response.body, 'existing');
    });

    test('when client requests a non-existing route, '
        'then the fallback route is called', () async {
      var response = await http.get(
        Uri.http('localhost:$port', '/non-existing'),
      );
      expect(response.statusCode, 200);
      expect(response.body, 'fallback');
    });

    test('when client requests root with no matching route, '
        'then the fallback route is called', () async {
      var response = await http.get(
        Uri.http('localhost:$port', '/'),
      );

      expect(response.statusCode, 200);
      expect(response.body, 'fallback');
    });
  });

  group('Given no fallback route is set', () {
    test('when client requests a non-existing route, '
        'then a 404 Not Found is returned', () async {
      var response = await http.get(
        Uri.http('localhost:$port', '/non-existing'),
      );

      expect(response.statusCode, 404);
    });
  });
}

class TestRoute extends Route {
  final String response;

  TestRoute(this.response);

  @override
  FutureOr<Result> handleCall(Session session, Request req) {
    return Response.ok(body: Body.fromString(response));
  }
}
