import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:serverpod_test_server/test_util/fake_health_indicator.dart';

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group('Given a running web server with a user-registered route', () {
    late int port;
    late http.Client httpClient;

    setUp(() async {
      final pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
        authenticationHandler: (session, token) => Future.value(
          token == 'valid'
              ? AuthenticationInfo('test-user', {}, authId: 'valid')
              : null,
        ),
      );
      // Register a user route so the web server's lazy app is initialized
      // (see Features.enableWebServer + WebServer.hasApp).
      pod.webServer.addRoute(_FallbackRoute(), '/existing');
      await pod.start();
      addTearDown(() => pod.shutdown(exitProcess: false));
      port = pod.webServer.port!;
      httpClient = http.Client();
      addTearDown(httpClient.close);
    });

    for (final probe in const ['livez', 'readyz', 'startupz']) {
      test(
        'when calling GET /$probe '
        'then response status code is 200',
        () async {
          final response = await httpClient.get(
            Uri.http('localhost:$port', '/$probe'),
          );

          expect(response.statusCode, 200);
        },
      );

      test(
        'when calling GET /$probe with no authentication '
        'then response has no body',
        () async {
          final response = await httpClient.get(
            Uri.http('localhost:$port', '/$probe'),
          );

          expect(response.body, isEmpty);
        },
      );

      test(
        'when calling GET /$probe with valid authentication '
        'then response is JSON with status pass',
        () async {
          final response = await httpClient.get(
            Uri.http('localhost:$port', '/$probe'),
            headers: {'Authorization': 'Bearer valid'},
          );

          expect(response.statusCode, 200);
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          expect(json['status'], 'pass');
        },
      );
    }
  });

  group('Given a web server with a failing readiness indicator', () {
    late int port;
    late http.Client httpClient;

    setUp(() async {
      final pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
        healthConfig: HealthConfig(
          additionalReadinessIndicators: [
            FakeHealthIndicator(
              name: 'test:service',
              isHealthy: false,
              failureMessage: 'Service unavailable',
            ),
          ],
        ),
      );
      pod.webServer.addRoute(_FallbackRoute(), '/existing');
      await pod.start();
      addTearDown(() => pod.shutdown(exitProcess: false));
      port = pod.webServer.port!;
      httpClient = http.Client();
      addTearDown(httpClient.close);
    });

    test(
      'when calling GET /readyz '
      'then response status code is 503 and reaches the client unmodified',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/readyz'),
        );

        // Status propagates through _devHtmlInjection / _ReportException /
        // _SessionMiddleware on the web server without being rewritten.
        expect(response.statusCode, 503);
        expect(response.body, isEmpty);
      },
    );
  });

  group('Given a fallback route is configured on the web server', () {
    late int port;
    late http.Client httpClient;

    setUp(() async {
      final pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
      );
      pod.webServer.fallbackRoute = _FallbackRoute();
      await pod.start();
      addTearDown(() => pod.shutdown(exitProcess: false));
      port = pod.webServer.port!;
      httpClient = http.Client();
      addTearDown(httpClient.close);
    });

    test(
      'when calling GET /livez '
      'then the probe handler responds, not the fallback',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/livez'),
        );

        expect(response.statusCode, 200);
        expect(response.body, isEmpty);
      },
    );

    test(
      'when calling an unrelated path '
      'then the fallback route still handles it',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/something-else'),
        );

        expect(response.statusCode, 200);
        expect(response.body, 'fallback');
      },
    );
  });
}

class _FallbackRoute extends Route {
  @override
  FutureOr<Result> handleCall(Session session, Request req) {
    return Response.ok(body: Body.fromString('fallback'));
  }
}
