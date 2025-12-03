import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';

/// Tests to verify that user middleware cannot bypass core middleware
/// (_headers and _reportException).
void main() {
  late Serverpod pod;
  late int port;

  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group('Given user middleware that returns early without calling next', () {
    setUp(() async {
      // Middleware that returns early without calling next
      final earlyReturnMiddleware = (Handler innerHandler) {
        return (Request req) async {
          // Return without calling next
          return Response.ok(body: Body.fromString('early-return'));
        };
      };

      pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
      );

      // Add middleware
      pod.server.addMiddleware(earlyReturnMiddleware);

      await pod.start();
      port = pod.server.port;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when request is made '
      'then core _headers middleware still applies CORS headers',
      () async {
        final response = await http.get(
          Uri.http('localhost:$port', '/'),
        );

        // Verify the response is from our early return middleware
        expect(response.body, 'early-return');

        // Verify that CORS headers are still applied by _headers middleware
        expect(
          response.headers['access-control-allow-origin'],
          '*',
          reason:
              'Core _headers middleware should apply CORS headers even when user middleware returns early',
        );
      },
    );
  });

  group('Given user middleware that throws an exception', () {
    setUp(() async {
      // Middleware that throws an exception
      final throwingMiddleware = (Handler innerHandler) {
        return (Request req) async {
          throw Exception('User middleware error');
        };
      };

      pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
      );

      // Add middleware
      pod.server.addMiddleware(throwingMiddleware);

      await pod.start();
      port = pod.server.port;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when request is made '
      'then core _reportException middleware catches it and returns 500 error',
      () async {
        final response = await http.get(
          Uri.http('localhost:$port', '/'),
        );

        // Verify that _reportException catches the error and returns 500
        expect(
          response.statusCode,
          500,
          reason:
              'Core _reportException middleware should catch exceptions and return 500',
        );
      },
    );

    test(
      'when request is made '
      'then response still has CORS headers from _headers middleware',
      () async {
        final response = await http.get(
          Uri.http('localhost:$port', '/'),
        );

        // Verify that headers are still applied even for error responses
        expect(
          response.headers['access-control-allow-origin'],
          '*',
          reason:
              'Core _headers middleware should apply headers to error responses',
        );
      },
    );
  });

  group('Given user middleware that throws SerializableException', () {
    setUp(() async {
      // Middleware that throws a SerializableException
      final serializableExceptionMiddleware = (Handler innerHandler) {
        return (Request req) async {
          throw ExceptionWithData(
            message: 'Custom error',
            creationDate: DateTime.now(),
            errorFields: ['field1', 'field2'],
          );
        };
      };

      pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
      );

      // Add middleware
      pod.server.addMiddleware(serializableExceptionMiddleware);

      await pod.start();
      port = pod.server.port;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when request is made '
      'then core _reportException middleware converts it to 400 bad request',
      () async {
        final response = await http.get(
          Uri.http('localhost:$port', '/'),
        );

        // Verify that _reportException handles SerializableException specially
        expect(
          response.statusCode,
          400,
          reason:
              'Core _reportException middleware should convert SerializableException to 400',
        );
      },
    );
  });

  group('Given multiple user middleware returning early', () {
    setUp(() async {
      // First middleware that returns early
      final firstMiddleware = (Handler innerHandler) {
        return (Request req) async {
          if (req.url.path == '/first') {
            return Response.ok(body: Body.fromString('first'));
          }
          return innerHandler(req);
        };
      };

      // Second middleware that returns early
      final secondMiddleware = (Handler innerHandler) {
        return (Request req) async {
          if (req.url.path == '/second') {
            return Response.ok(body: Body.fromString('second'));
          }
          return innerHandler(req);
        };
      };

      pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
      );

      // Add middleware in order
      pod.server.addMiddleware(firstMiddleware);
      pod.server.addMiddleware(secondMiddleware);

      await pod.start();
      port = pod.server.port;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when requests are made '
      'then all early returns still have core headers applied',
      () async {
        // Test first middleware
        final response1 = await http.get(
          Uri.http('localhost:$port', '/first'),
        );
        expect(response1.body, 'first');
        expect(
          response1.headers['access-control-allow-origin'],
          '*',
          reason: 'First middleware early return should have CORS headers',
        );

        // Test second middleware
        final response2 = await http.get(
          Uri.http('localhost:$port', '/second'),
        );
        expect(response2.body, 'second');
        expect(
          response2.headers['access-control-allow-origin'],
          '*',
          reason: 'Second middleware early return should have CORS headers',
        );
      },
    );
  });
}
