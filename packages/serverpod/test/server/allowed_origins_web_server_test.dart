import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';

const _configuredOrigin = 'http://localhost:8082';
const _unrelatedOrigin = 'http://localhost:1';

class _DummyRoute extends Route {
  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    return Response.ok();
  }
}

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  Future<Serverpod> startPod({
    required String runMode,
    required List<String>? allowedOrigins,
    ServerConfig? webServer,
  }) async {
    final pod = Serverpod(
      ['-m', runMode],
      internal.Protocol(),
      EmptyEndpoints(),
      config: ServerpodConfig(
        apiServer: portZeroConfig,
        webServer: webServer ?? portZeroConfig,
        allowedOrigins: allowedOrigins,
        authCookie: allowedOrigins == null
            ? null
            : const WebAuthCookieConfig(secure: false),
      ),
    );
    addTearDown(() => pod.shutdown(exitProcess: false));
    pod.webServer.addRoute(_DummyRoute(), '/dummy');

    await pod.start();
    return pod;
  }

  group(
    'Given a server in development with allowed origins not naming its web server',
    () {
      late Serverpod pod;
      late String webOrigin;

      setUp(() async {
        pod = await startPod(
          runMode: ServerpodRunMode.development,
          allowedOrigins: [_configuredOrigin],
        );
        webOrigin = 'http://localhost:${pod.webServer.port}';
      });

      test(
        'when reading the config '
        'then the allowed origins are the configured one and the web server origin.',
        () {
          expect(pod.config.allowedOrigins, [_configuredOrigin, webOrigin]);
        },
      );

      test(
        'when a cookie auth call is made from the web server origin '
        'then the origin is not rejected.',
        () async {
          final response = await _cookieAuthCall(pod, origin: webOrigin);

          expect(response.statusCode, isNot(HttpStatus.forbidden));
          expect(response.headers['access-control-allow-origin'], webOrigin);
          expect(response.headers['access-control-allow-credentials'], 'true');
        },
      );

      test(
        'when a cookie auth call is made from an unrelated origin '
        'then the origin is rejected.',
        () async {
          final response = await _cookieAuthCall(pod, origin: _unrelatedOrigin);

          expect(response.statusCode, HttpStatus.forbidden);
          expect(response.body, 'Request origin not allowed.');
        },
      );

      test(
        'when a WebSocket connects from the web server origin '
        'then the handshake succeeds.',
        () async {
          final webSocket = await _connectWebSocket(pod, origin: webOrigin);
          addTearDown(webSocket.close);

          expect(webSocket.readyState, WebSocket.open);
        },
      );

      test(
        'when a WebSocket connects from an unrelated origin '
        'then the handshake is rejected.',
        () async {
          await expectLater(
            _connectWebSocket(pod, origin: _unrelatedOrigin),
            throwsA(isA<WebSocketException>()),
          );
        },
      );

      test(
        'when the servers are resumed '
        'then the web server origin is not added twice.',
        () async {
          await pod.withPausedRequestHandling(() async {});

          expect(
            pod.config.allowedOrigins!.where((origin) => origin == webOrigin),
            hasLength(1),
          );
        },
      );
    },
  );

  test(
    'Given a server in development with a web server on a default public port '
    'when starting the server '
    'then the web server origin is allowed without the port.',
    () async {
      final pod = await startPod(
        runMode: ServerpodRunMode.development,
        allowedOrigins: [_configuredOrigin],
        webServer: ServerConfig(
          port: 0,
          publicScheme: 'https',
          publicHost: 'app.example.com',
          publicPort: 443,
        ),
      );

      expect(pod.config.allowedOrigins, [
        _configuredOrigin,
        'https://app.example.com',
      ]);
    },
  );

  test(
    'Given a server in development with allowed origins naming its web server '
    'when starting the server '
    'then the allowed origins are unchanged.',
    () async {
      const webOrigin = 'https://app.example.com:8443';
      final pod = await startPod(
        runMode: ServerpodRunMode.development,
        allowedOrigins: [webOrigin],
        webServer: ServerConfig(
          port: 0,
          publicScheme: 'https',
          publicHost: 'app.example.com',
          publicPort: 8443,
        ),
      );

      expect(pod.config.allowedOrigins, [webOrigin]);
    },
  );

  test(
    'Given a server in development without allowed origins '
    'when starting the server '
    'then all origins stay allowed.',
    () async {
      final pod = await startPod(
        runMode: ServerpodRunMode.development,
        allowedOrigins: null,
      );

      expect(pod.config.allowedOrigins, isNull);
    },
  );

  test(
    'Given a server in production with allowed origins not naming its web server '
    'when a cookie auth call is made from the web server origin '
    'then the origin is rejected.',
    () async {
      final pod = await startPod(
        runMode: ServerpodRunMode.production,
        allowedOrigins: ['https://app.example.com'],
      );
      final webOrigin = 'http://localhost:${pod.webServer.port}';

      final response = await _cookieAuthCall(pod, origin: webOrigin);

      expect(pod.config.allowedOrigins, ['https://app.example.com']);
      expect(response.statusCode, HttpStatus.forbidden);
    },
  );
}

Future<http.Response> _cookieAuthCall(
  Serverpod pod, {
  required String origin,
}) => http.post(
  Uri.parse('http://localhost:${pod.server.port}/endpoint/method'),
  headers: {
    'Origin': origin,
    webAuthModeHeaderName: webAuthModeCookie,
    'Content-Type': 'application/json',
  },
  body: '{}',
);

Future<WebSocket> _connectWebSocket(Serverpod pod, {required String origin}) =>
    WebSocket.connect(
      'ws://localhost:${pod.server.port}/v1/websocket',
      headers: {'Origin': origin},
    );
