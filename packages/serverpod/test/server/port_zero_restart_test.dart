import 'dart:async';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';

void main() {
  // One per server, since ServerpodConfig names each config it holds.
  ServerConfig portZeroConfig() => ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group('Given a pod whose servers bound port zero,', () {
    late Serverpod pod;

    setUp(() async {
      pod = Serverpod(
        [],
        internal.Protocol(),
        EmptyEndpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig(),
          webServer: portZeroConfig(),
        ),
      );
      // A web server with no route is not started at all.
      pod.webServer.addRoute(_Route());
      await pod.start();
    });

    tearDown(() async {
      try {
        await pod.shutdown(exitProcess: false);
      } on SocketException {
        // A pod whose resume failed reports the bind error again here.
      }
    });

    test(
      'when request handling is paused and resumed, '
      'then they come back on the ports they had, so clients still reach them',
      () async {
        final apiPort = pod.server.port;
        final webPort = pod.webServer.port;
        expect(webPort, isNotNull);

        await pod.withPausedRequestHandling(() async {});

        expect(pod.server.port, apiPort);
        expect(pod.webServer.port, webPort);
      },
    );

    test(
      'when the API port is taken while request handling is paused, '
      'then resuming fails loudly rather than leaving a published port unbound',
      () async {
        final apiPort = pod.server.port;
        ServerSocket? squatter;
        addTearDown(() => squatter?.close());

        await expectLater(
          pod.withPausedRequestHandling(() async {
            // Shared, as Dart rejects a second plain bind within one process.
            squatter = await ServerSocket.bind(
              InternetAddress.anyIPv6,
              apiPort,
              shared: true,
            );
          }),
          throwsA(isA<StateError>()),
        );
        expect(pod.server.running, isFalse);
      },
    );

    test(
      'when the action throws and the API port is taken as well, '
      'then the action\'s error is the one reported',
      () async {
        final apiPort = pod.server.port;
        ServerSocket? squatter;
        addTearDown(() => squatter?.close());

        await expectLater(
          pod.withPausedRequestHandling(() async {
            squatter = await ServerSocket.bind(
              InternetAddress.anyIPv6,
              apiPort,
              shared: true,
            );
            throw const FormatException('bad migration');
          }),
          throwsA(isA<FormatException>()),
        );
      },
    );
  });
}

class _Route extends Route {
  @override
  FutureOr<Result> handleCall(Session session, Request request) =>
      Response.ok(body: Body.fromString('ok'));
}
