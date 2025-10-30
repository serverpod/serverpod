import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:relic/relic.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('loggingMiddleware - basic logging', () {
    late Serverpod server;
    late http.Client httpClient;
    late Uri endpoint;
    late List<String> logMessages;

    setUp(() async {
      logMessages = [];

      // Create test config with port 0 (auto-assign)
      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      // Create server with logging middleware
      server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
        experimentalFeatures: ExperimentalFeatures(
          middleware: [
            loggingMiddleware(
              logger: (message) => logMessages.add(message),
            ),
          ],
        ),
      );

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

    test('logs request method, URI, status code, and timing', () async {
      // Make request
      final response = await httpClient.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: '{"value": 42}',
      );

      // Verify response succeeded
      expect(response.statusCode, 200);

      // Verify middleware logged the request
      expect(logMessages.length, 1);
      final logMessage = logMessages[0];

      // Verify log contains method, path, status code, and timing
      expect(logMessage, contains('POST'));
      expect(logMessage, contains('/basicTypes/testInt'));
      expect(logMessage, contains('200'));
      expect(logMessage, matches(RegExp(r'\(\d+ms\)')), reason: 'Should include timing in ms');
    });

    test('logs multiple requests independently', () async {
      // Make multiple requests
      for (var i = 0; i < 3; i++) {
        await httpClient.post(
          endpoint,
          headers: {'Content-Type': 'application/json'},
          body: '{"value": $i}',
        );
      }

      // Verify all requests were logged
      expect(logMessages.length, 3);
      for (final message in logMessages) {
        expect(message, contains('POST'));
        expect(message, contains('200'));
      }
    });

    test('logs different status codes correctly', () async {
      // Make a request that will succeed (200)
      await httpClient.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: '{"value": 123}',
      );

      expect(logMessages.length, 1);
      expect(logMessages[0], contains('200'));
    });

    test('logs timestamp in UTC format', () async {
      final beforeTime = DateTime.now().toUtc();

      await httpClient.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: '{"value": 42}',
      );

      final afterTime = DateTime.now().toUtc();

      expect(logMessages.length, 1);
      final logMessage = logMessages[0];

      // Verify log starts with a UTC timestamp
      expect(
        logMessage,
        matches(RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+Z')),
        reason: 'Log should start with UTC timestamp',
      );

      // Extract and verify timestamp is in reasonable range
      final timestampStr = logMessage.split(' ').take(2).join(' ');
      final loggedTime = DateTime.parse(timestampStr);

      expect(
        loggedTime.isAfter(beforeTime.subtract(Duration(seconds: 1))),
        isTrue,
      );
      expect(
        loggedTime.isBefore(afterTime.add(Duration(seconds: 1))),
        isTrue,
      );
    });

    test('tracks timing accurately', () async {
      await httpClient.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: '{"value": 42}',
      );

      expect(logMessages.length, 1);
      final logMessage = logMessages[0];

      // Extract duration from log (format: "...200 (123ms)")
      final durationMatch = RegExp(r'\((\d+)ms\)').firstMatch(logMessage);
      expect(durationMatch, isNotNull, reason: 'Should include timing');

      final duration = int.parse(durationMatch!.group(1)!);
      // Duration should be reasonable (0-2000ms for a simple request)
      expect(duration, greaterThanOrEqualTo(0));
      expect(duration, lessThan(2000));
    });
  });

  group('loggingMiddleware - verbose mode', () {
    late Serverpod server;
    late http.Client httpClient;
    late Uri endpoint;
    late List<String> logMessages;

    setUp(() async {
      logMessages = [];

      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
        experimentalFeatures: ExperimentalFeatures(
          middleware: [
            loggingMiddleware(
              verbose: true,
              logger: (message) => logMessages.add(message),
            ),
          ],
        ),
      );

      await server.start();
      httpClient = http.Client();

      final actualPort = server.server.port;
      endpoint = Uri.parse('http://localhost:$actualPort/basicTypes/testInt');
    });

    tearDown(() async {
      httpClient.close();
      await server.shutdown(exitProcess: false);
    });

    test('logs request and response headers', () async {
      await httpClient.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: '{"value": 42}',
      );

      // In verbose mode, should have 4 log messages:
      // 1. Request line with method and URI
      // 2. Request headers
      // 3. Response line with status and timing
      // 4. Response headers
      expect(logMessages.length, 4, reason: 'Verbose mode should log 4 messages');

      // Verify request line
      expect(logMessages[0], contains('POST'));
      expect(logMessages[0], contains('/basicTypes/testInt'));

      // Verify request headers logged
      expect(logMessages[1], contains('Request headers:'));

      // Verify response line with timing
      expect(logMessages[2], contains('Response:'));
      expect(logMessages[2], contains('200'));
      expect(logMessages[2], matches(RegExp(r'\(\d+ms\)')));

      // Verify response headers logged
      expect(logMessages[3], contains('Response headers:'));
    });

    test('verbose mode includes timing in response line', () async {
      await httpClient.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: '{"value": 42}',
      );

      // Response line (3rd message) should contain timing
      final responseLine = logMessages[2];
      expect(responseLine, contains('ms)'));
    });
  });

  group('loggingMiddleware - multiple middleware interaction', () {
    late Serverpod server;
    late http.Client httpClient;
    late Uri endpoint;
    late List<String> logMessages;
    late List<String> middlewareOrder;

    setUp(() async {
      logMessages = [];
      middlewareOrder = [];

      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      // Create middleware that tracks execution order
      Middleware orderTrackingMiddleware(String id) {
        return (Handler innerHandler) {
          return (ctx) async {
            middlewareOrder.add('$id-before');
            final result = await innerHandler(ctx);
            middlewareOrder.add('$id-after');
            return result;
          };
        };
      }

      server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
        experimentalFeatures: ExperimentalFeatures(
          middleware: [
            orderTrackingMiddleware('MW1'),
            loggingMiddleware(logger: (message) => logMessages.add(message)),
            orderTrackingMiddleware('MW2'),
          ],
        ),
      );

      await server.start();
      httpClient = http.Client();

      final actualPort = server.server.port;
      endpoint = Uri.parse('http://localhost:$actualPort/basicTypes/testInt');
    });

    tearDown(() async {
      httpClient.close();
      await server.shutdown(exitProcess: false);
    });

    test('logging middleware works correctly in middleware chain', () async {
      await httpClient.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: '{"value": 42}',
      );

      // Verify logging middleware executed
      expect(logMessages.length, 1);
      expect(logMessages[0], contains('POST'));
      expect(logMessages[0], contains('200'));

      // Verify middleware order (onion model)
      expect(middlewareOrder, [
        'MW1-before',
        // Logging middleware executes here (between MW1 and MW2)
        'MW2-before',
        'MW2-after',
        'MW1-after',
      ]);
    });
  });

  group('loggingMiddleware - error handling', () {
    late Serverpod server;
    late http.Client httpClient;
    late Uri endpoint;
    late List<String> logMessages;

    setUp(() async {
      logMessages = [];

      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      // Create middleware that throws an error
      Middleware errorThrowingMiddleware = (Handler innerHandler) {
        return (ctx) async {
          // Throw before calling inner handler
          throw Exception('Test error from middleware');
        };
      };

      server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
        experimentalFeatures: ExperimentalFeatures(
          middleware: [
            loggingMiddleware(
              logger: (message) => logMessages.add(message),
            ),
            errorThrowingMiddleware,
          ],
        ),
      );

      await server.start();
      httpClient = http.Client();

      final actualPort = server.server.port;
      endpoint = Uri.parse('http://localhost:$actualPort/basicTypes/testInt');
    });

    tearDown(() async {
      httpClient.close();
      await server.shutdown(exitProcess: false);
    });

    test('logs errors to custom logger with request details', () async {
      // Make request that will trigger error
      try {
        await httpClient.post(
          endpoint,
          headers: {'Content-Type': 'application/json'},
          body: '{"value": 42}',
        );
        // Request will fail due to error in middleware
      } catch (_) {
        // Expected - server error
      }

      // Verify error was logged to custom logger (not stderr)
      expect(logMessages.length, greaterThanOrEqualTo(3),
          reason: 'Should log error messages');

      // Verify error log contains request details
      final errorMessages = logMessages.join('\n');
      expect(errorMessages, contains('ERROR:'),
          reason: 'Should contain ERROR marker');
      expect(errorMessages, contains('POST'),
          reason: 'Should contain request method');
      expect(errorMessages, contains('/basicTypes/testInt'),
          reason: 'Should contain request URI');
      expect(errorMessages, contains('ms)'),
          reason: 'Should contain timing');
      expect(errorMessages, contains('Test error from middleware'),
          reason: 'Should contain error message');
    });

    test('includes stack trace in error logs', () async {
      try {
        await httpClient.post(
          endpoint,
          headers: {'Content-Type': 'application/json'},
          body: '{"value": 42}',
        );
      } catch (_) {
        // Expected
      }

      // Verify stack trace is logged
      final allLogs = logMessages.join('\n');
      expect(allLogs, contains('#'),
          reason: 'Stack trace should contain frame markers (#)');
    });
  });

  group('loggingMiddleware - separate error logger', () {
    late Serverpod server;
    late http.Client httpClient;
    late Uri endpoint;
    late List<String> normalMessages;
    late List<String> errorMessages;

    setUp(() async {
      normalMessages = [];
      errorMessages = [];

      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      // Create middleware that throws an error
      Middleware errorThrowingMiddleware = (Handler innerHandler) {
        return (ctx) async {
          throw Exception('Test error for separate logger');
        };
      };

      server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
        experimentalFeatures: ExperimentalFeatures(
          middleware: [
            loggingMiddleware(
              logger: (message) => normalMessages.add(message),
              errorLogger: (message) => errorMessages.add(message),
            ),
            errorThrowingMiddleware,
          ],
        ),
      );

      await server.start();
      httpClient = http.Client();

      final actualPort = server.server.port;
      endpoint = Uri.parse('http://localhost:$actualPort/basicTypes/testInt');
    });

    tearDown(() async {
      httpClient.close();
      await server.shutdown(exitProcess: false);
    });

    test('routes normal logs to logger and errors to errorLogger', () async {
      // Make request that will trigger error
      try {
        await httpClient.post(
          endpoint,
          headers: {'Content-Type': 'application/json'},
          body: '{"value": 42}',
        );
      } catch (_) {
        // Expected - server error
      }

      // Verify normal messages list is empty (request never completes successfully)
      expect(normalMessages.length, 0,
          reason: 'Normal logger should not receive error messages');

      // Verify error messages were routed to errorLogger
      expect(errorMessages.length, greaterThanOrEqualTo(3),
          reason: 'Error logger should receive error messages');

      final allErrors = errorMessages.join('\n');
      expect(allErrors, contains('ERROR:'));
      expect(allErrors, contains('Test error for separate logger'));
    });
  });

  group('loggingMiddleware - no server required', () {
    test('factory function creates valid Middleware', () {
      // Verify factory returns a Middleware function
      final middleware = loggingMiddleware();
      expect(middleware, isA<Middleware>());
    });

    test('factory function accepts custom logger', () {
      final customMessages = <String>[];
      final middleware = loggingMiddleware(
        logger: (message) => customMessages.add(message),
      );
      expect(middleware, isA<Middleware>());
    });

    test('factory function accepts verbose parameter', () {
      final middleware = loggingMiddleware(verbose: true);
      expect(middleware, isA<Middleware>());
    });
  });
}
