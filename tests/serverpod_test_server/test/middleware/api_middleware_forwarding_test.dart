import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('API middleware forwarding integration', () {
    late Serverpod server;
    late http.Client httpClient;
    late Uri endpoint;

    /// Middleware that adds a custom header to the response
    Middleware createTrackingMiddleware() {
      return (Handler innerHandler) {
        return (req) async {
          // Call the inner handler
          final result = await innerHandler(req);

          // Modify the response to add custom header
          if (result is Response) {
            return result.copyWith(
              headers: result.headers.transform((h) {
                h['X-Middleware'] = ['hit'];
              }),
            );
          }

          return result;
        };
      };
    }

    setUp(() async {
      // Create test config with port 0 (auto-assign)
      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      // Create server
      server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
      );

      // Add middleware
      server.server.addMiddleware(createTrackingMiddleware());

      // Start the server
      await server.start();

      httpClient = http.Client();

      // Get the actual port assigned
      final actualPort = server.server.port;
      endpoint = Uri.parse('http://localhost:$actualPort/basicTypes/testInt');
    });

    tearDown(() async {
      httpClient.close();
      await server.shutdown(exitProcess: false);
    });

    test(
      'Given middleware is configured '
      'when request is made to API endpoint '
      'then response contains custom header',
      () async {
        // Make request to basicTypes/testInt endpoint (returns the same value)
        final response = await httpClient.post(
          endpoint,
          headers: {'Content-Type': 'application/json'},
          body: '{"value": 42}',
        );

        // Verify normal response (testInt returns the same value)
        expect(response.statusCode, 200);
        expect(response.body, contains('42'));

        // Verify middleware added custom header
        expect(
          response.headers['x-middleware'],
          'hit',
          reason: 'Middleware should add X-Middleware header',
        );
      },
    );

    test(
      'Given counting middleware is configured '
      'when multiple requests are made '
      'then middleware executes for each request',
      () async {
        // Track multiple executions
        var executionCount = 0;

        Middleware countingMiddleware = (Handler innerHandler) {
          return (req) async {
            executionCount++;
            return await innerHandler(req);
          };
        };

        // Shutdown existing server and create new one with counting middleware
        await server.shutdown(exitProcess: false);

        final portZeroConfig = ServerConfig(
          port: 0,
          publicScheme: 'http',
          publicHost: 'localhost',
          publicPort: 0,
        );

        server = IntegrationTestServer.create(
          config: ServerpodConfig(apiServer: portZeroConfig),
        );

        // Add middleware
        server.server.addMiddleware(countingMiddleware);

        await server.start();

        final actualPort = server.server.port;
        final testEndpoint = Uri.parse(
          'http://localhost:$actualPort/basicTypes/testInt',
        );

        // Make multiple requests
        for (var i = 0; i < 3; i++) {
          await httpClient.post(
            testEndpoint,
            headers: {'Content-Type': 'application/json'},
            body: '{"value": $i}',
          );
        }

        // Verify middleware ran for each request
        expect(
          executionCount,
          3,
          reason: 'Middleware should execute once per request',
        );
      },
    );

    test(
      'Given multiple middleware are configured '
      'when request is made '
      'then middleware execute in correct order',
      () async {
        final executionOrder = <String>[];

        Middleware createOrderTrackingMiddleware(String id) {
          return (Handler innerHandler) {
            return (req) async {
              executionOrder.add('$id-before');
              final result = await innerHandler(req);
              executionOrder.add('$id-after');
              return result;
            };
          };
        }

        // Shutdown and recreate with ordered middleware
        await server.shutdown(exitProcess: false);

        final portZeroConfig = ServerConfig(
          port: 0,
          publicScheme: 'http',
          publicHost: 'localhost',
          publicPort: 0,
        );

        server = IntegrationTestServer.create(
          config: ServerpodConfig(apiServer: portZeroConfig),
        );

        // Add middleware in order
        server.server.addMiddleware(createOrderTrackingMiddleware('MW1'));
        server.server.addMiddleware(createOrderTrackingMiddleware('MW2'));
        server.server.addMiddleware(createOrderTrackingMiddleware('MW3'));

        await server.start();

        final actualPort = server.server.port;
        final testEndpoint = Uri.parse(
          'http://localhost:$actualPort/basicTypes/testInt',
        );

        // Make request
        await httpClient.post(
          testEndpoint,
          headers: {'Content-Type': 'application/json'},
          body: '{"value": 1}',
        );

        // Verify execution order: before in forward order, after in reverse
        expect(executionOrder, [
          'MW1-before',
          'MW2-before',
          'MW3-before',
          'MW3-after',
          'MW2-after',
          'MW1-after',
        ]);
      },
    );

    test(
      'Given server is configured without middleware '
      'when request is made '
      'then server responds normally',
      () async {
        // Shutdown and recreate without middleware
        await server.shutdown(exitProcess: false);

        final portZeroConfig = ServerConfig(
          port: 0,
          publicScheme: 'http',
          publicHost: 'localhost',
          publicPort: 0,
        );

        server = IntegrationTestServer.create(
          config: ServerpodConfig(apiServer: portZeroConfig),
          // No middleware
        );

        await server.start();

        final actualPort = server.server.port;
        final testEndpoint = Uri.parse(
          'http://localhost:$actualPort/basicTypes/testInt',
        );

        // Make request
        final response = await httpClient.post(
          testEndpoint,
          headers: {'Content-Type': 'application/json'},
          body: '{"value": 5}',
        );

        // Verify normal operation without middleware
        expect(response.statusCode, 200);
        expect(response.body, contains('5')); // testInt returns the same value

        // Verify no middleware header
        expect(
          response.headers['x-middleware'],
          isNull,
          reason: 'Should not have middleware header when no middleware',
        );
      },
    );
  });
}
