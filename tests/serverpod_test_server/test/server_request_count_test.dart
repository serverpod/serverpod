import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:test/test.dart';

void main() {
  group('Given a server', () {
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
        ),
      );

      await pod.start();
      port = pod.server.port;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when server starts then requestCount is zero.',
      () {
        expect(pod.server.requestCount, equals(0));
      },
    );

    test(
      'when an endpoint call is made then requestCount is incremented.',
      () async {
        final initialCount = pod.server.requestCount;

        await http.post(
          Uri.http('localhost:$port', '/invalid-endpoint'),
        );

        expect(pod.server.requestCount, equals(initialCount + 1));
      },
    );

    test(
      'when multiple endpoint calls are made then requestCount is incremented for each.',
      () async {
        final initialCount = pod.server.requestCount;

        await http.post(Uri.http('localhost:$port', '/endpoint1'));
        await http.post(Uri.http('localhost:$port', '/endpoint2'));
        await http.post(Uri.http('localhost:$port', '/endpoint3'));

        expect(pod.server.requestCount, equals(initialCount + 3));
      },
    );

    test(
      'when health check endpoint is called then requestCount is not incremented.',
      () async {
        final initialCount = pod.server.requestCount;

        await http.get(Uri.http('localhost:$port', '/'));

        // NOTE: Health check requests should not increment the counter as they
        // are typically from load balancer probes and should not prevent the
        // server from being considered idle.
        expect(pod.server.requestCount, equals(initialCount));
      },
    );
  });
}
