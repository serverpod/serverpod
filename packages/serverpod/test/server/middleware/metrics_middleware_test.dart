import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('HttpMetrics', () {
    late HttpMetrics metrics;
    late MetricsMiddleware middleware;

    setUp(() {
      metrics = HttpMetrics();
      middleware = MetricsMiddleware(metrics);
    });

    test('initializes with empty state', () {
      expect(metrics.requestCounts, isEmpty);
      expect(metrics.requestDurations, isEmpty);
      expect(metrics.activeConnections, equals(0));
    });

    test('reset clears cumulative metrics but not active connections', () async {
      final request = _createRequest(method: Method.get, path: '/api');

      await middleware.handle(
        request,
        (_) async => Response.ok(body: Body.fromString('Success')),
      );

      expect(metrics.requestCounts, isNotEmpty);
      expect(metrics.activeConnections, equals(0)); // Request completed

      metrics.reset();

      expect(metrics.requestCounts, isEmpty);
      expect(metrics.requestDurations, isEmpty);
      expect(metrics.activeConnections, equals(0)); // Still 0
    });

    test('reset during in-flight request does not cause negative count', () async {
      final request = _createRequest(method: Method.get, path: '/api');
      var resetDuringRequest = false;

      // Start a request that will be in-flight during reset
      final requestFuture = middleware.handle(
        request,
        (_) async {
          // Request is in-flight here
          expect(metrics.activeConnections, equals(1));

          // Simulate reset happening while request is active
          metrics.reset();
          resetDuringRequest = true;

          // Active connections should still be 1 (reset doesn't affect it)
          expect(metrics.activeConnections, equals(1));

          await Future.delayed(Duration(milliseconds: 10));
          return Response.ok(body: Body.fromString('Success'));
        },
      );

      await requestFuture;

      // After request completes, active connections should be 0 (not negative!)
      // This verifies the race condition is fixed: if reset had zeroed
      // activeConnections, the finally block would decrement and leave it at -1
      expect(resetDuringRequest, isTrue);
      expect(metrics.activeConnections, equals(0));

      // Note: requestCounts will have one entry because metrics are recorded
      // AFTER the response in the try block, which happens after reset
      expect(metrics.requestCounts['GET:api:200'], equals(1));
    });

    test('returns immutable copies of metrics', () async {
      final request = _createRequest(method: Method.get, path: '/api');

      await middleware.handle(
        request,
        (_) async => Response.ok(body: Body.fromString('Success')),
      );

      // Request counts map is immutable
      final counts = metrics.requestCounts;
      expect(() => counts['GET:api:200'] = 999, throwsUnsupportedError);

      // Request durations map is immutable
      final durations = metrics.requestDurations;
      expect(() => durations.remove('GET:api:200'), throwsUnsupportedError);

      // DurationStats fields are read-only (getters only)
      final stats = metrics.requestDurations['GET:api:200']!;
      expect(stats.count, equals(1));
      // Verify stats object doesn't expose mutable fields
      // (attempting to set would be a compile error, not runtime)
    });
  });

  group('MetricsMiddleware', () {
    late HttpMetrics metrics;
    late MetricsMiddleware middleware;

    setUp(() {
      metrics = HttpMetrics();
      middleware = MetricsMiddleware(metrics);
    });

    test('increments request counter on successful request', () async {
      final request = _createRequest(method: Method.get, path: '/api/users');

      await middleware.handle(
        request,
        (_) async => Response.ok(body: Body.fromString('Success')),
      );

      expect(metrics.requestCounts['GET:api:200'], equals(1));
    });

    test('records request duration', () async {
      final request = _createRequest(method: Method.get, path: '/api/users');

      await middleware.handle(
        request,
        (_) async {
          await Future.delayed(Duration(milliseconds: 10));
          return Response.ok(body: Body.fromString('Success'));
        },
      );

      final stats = metrics.requestDurations['GET:api:200']!;
      expect(stats.count, equals(1));
      expect(stats.minMs, greaterThanOrEqualTo(10));
      expect(stats.maxMs, greaterThanOrEqualTo(10));
      expect(stats.totalMs, greaterThanOrEqualTo(10));
      expect(stats.averageMs, greaterThanOrEqualTo(10.0));
    });

    test('tracks active connections during request', () async {
      final request = _createRequest(method: Method.get, path: '/api/users');
      var activeConnectionsDuringRequest = 0;

      await middleware.handle(
        request,
        (_) async {
          activeConnectionsDuringRequest = metrics.activeConnections;
          return Response.ok(body: Body.fromString('Success'));
        },
      );

      expect(activeConnectionsDuringRequest, equals(1));
      expect(metrics.activeConnections, equals(0)); // Decremented after
    });

    test('decrements active connections even on error', () async {
      final request = _createRequest(method: Method.get, path: '/api/users');

      try {
        await middleware.handle(
          request,
          (_) async => throw Exception('Test error'),
        );
      } catch (e) {
        // Expected
      }

      expect(metrics.activeConnections, equals(0));
    });

    test('records metrics for different status codes', () async {
      final request1 = _createRequest(method: Method.get, path: '/api/users');
      final request2 = _createRequest(method: Method.get, path: '/api/users');

      await middleware.handle(
        request1,
        (_) async => Response.ok(body: Body.fromString('Success')),
      );

      await middleware.handle(
        request2,
        (_) async => Response(404, body: Body.fromString('Not found')),
      );

      expect(metrics.requestCounts['GET:api:200'], equals(1));
      expect(metrics.requestCounts['GET:api:404'], equals(1));
    });

    test('records metrics for different methods', () async {
      final getRequest = _createRequest(method: Method.get, path: '/api/users');
      final postRequest = _createRequest(method: Method.post, path: '/api/users');

      await middleware.handle(
        getRequest,
        (_) async => Response.ok(body: Body.fromString('Success')),
      );

      await middleware.handle(
        postRequest,
        (_) async => Response(201, body: Body.fromString('Created')),
      );

      expect(metrics.requestCounts['GET:api:200'], equals(1));
      expect(metrics.requestCounts['POST:api:201'], equals(1));
    });

    test('records metrics for different endpoints', () async {
      final apiRequest = _createRequest(method: Method.get, path: '/api/users');
      final healthRequest = _createRequest(method: Method.get, path: '/health');

      await middleware.handle(
        apiRequest,
        (_) async => Response.ok(body: Body.fromString('Success')),
      );

      await middleware.handle(
        healthRequest,
        (_) async => Response.ok(body: Body.fromString('Healthy')),
      );

      expect(metrics.requestCounts['GET:api:200'], equals(1));
      expect(metrics.requestCounts['GET:health:200'], equals(1));
    });

    test('handles errors and records as 500 status', () async {
      final request = _createRequest(method: Method.get, path: '/api/users');

      try {
        await middleware.handle(
          request,
          (_) async => throw Exception('Test error'),
        );
        fail('Expected exception to be thrown');
      } catch (e) {
        // Expected
      }

      expect(metrics.requestCounts['GET:api:500'], equals(1));
      expect(metrics.requestDurations['GET:api:500']!.count, equals(1));
    });

    test('extracts endpoint from path correctly', () async {
      final tests = [
        ('/api/users/123', 'api'),
        ('/health', 'health'),
        ('/', 'root'),
        ('/api', 'api'),
      ];

      for (var i = 0; i < tests.length; i++) {
        final path = tests[i].$1;
        final expectedEndpoint = tests[i].$2;
        final request = _createRequest(method: Method.get, path: path);

        await middleware.handle(
          request,
          (_) async => Response.ok(body: Body.fromString('Success')),
        );

        expect(
          metrics.requestCounts['GET:$expectedEndpoint:200'],
          equals(1),
          reason: 'Path $path should extract endpoint $expectedEndpoint',
        );

        metrics.reset(); // Reset for next iteration
      }
    });

    test('handles multiple concurrent requests', () async {
      final request1 = _createRequest(method: Method.get, path: '/api/users');
      final request2 = _createRequest(method: Method.post, path: '/api/posts');
      final request3 = _createRequest(method: Method.get, path: '/health');

      await Future.wait([
        middleware.handle(
          request1,
          (_) async => Response.ok(body: Body.fromString('Success')),
        ),
        middleware.handle(
          request2,
          (_) async => Response(201, body: Body.fromString('Created')),
        ),
        middleware.handle(
          request3,
          (_) async => Response.ok(body: Body.fromString('Healthy')),
        ),
      ]);

      expect(metrics.requestCounts['GET:api:200'], equals(1));
      expect(metrics.requestCounts['POST:api:201'], equals(1));
      expect(metrics.requestCounts['GET:health:200'], equals(1));
      expect(metrics.activeConnections, equals(0));
    });

    test('preserves response unchanged', () async {
      final request = _createRequest(method: Method.get, path: '/api/users');
      final expectedBody = Body.fromString('Test response');

      final response = await middleware.handle(
        request,
        (_) async => Response.ok(
          body: expectedBody,
          headers: Headers.build((h) {
            h['X-Custom-Header'] = ['test-value'];
          }),
        ),
      );

      expect(response.statusCode, equals(200));
      expect(response.body, equals(expectedBody));
      expect(response.headers['X-Custom-Header'], equals(['test-value']));
    });

    test('accumulates metrics across multiple requests', () async {
      final request = _createRequest(method: Method.get, path: '/api/users');

      for (var i = 0; i < 5; i++) {
        await middleware.handle(
          request,
          (_) async => Response.ok(body: Body.fromString('Success')),
        );
      }

      expect(metrics.requestCounts['GET:api:200'], equals(5));
      expect(metrics.requestDurations['GET:api:200']!.count, equals(5));
    });

    test('aggregates duration statistics correctly', () async {
      final request = _createRequest(method: Method.get, path: '/api/users');

      // Record requests with known delays
      await middleware.handle(
        request,
        (_) async {
          await Future.delayed(Duration(milliseconds: 10));
          return Response.ok(body: Body.fromString('Success'));
        },
      );

      await middleware.handle(
        request,
        (_) async {
          await Future.delayed(Duration(milliseconds: 20));
          return Response.ok(body: Body.fromString('Success'));
        },
      );

      await middleware.handle(
        request,
        (_) async {
          await Future.delayed(Duration(milliseconds: 15));
          return Response.ok(body: Body.fromString('Success'));
        },
      );

      final stats = metrics.requestDurations['GET:api:200']!;
      expect(stats.count, equals(3));

      // Verify min <= max (handles coarse timers where all land in same bucket)
      expect(stats.minMs, lessThanOrEqualTo(stats.maxMs));

      // Verify durations are in reasonable range considering delays
      expect(stats.minMs, greaterThanOrEqualTo(10));
      expect(stats.maxMs, greaterThanOrEqualTo(20));
      expect(stats.totalMs, greaterThanOrEqualTo(45)); // 10 + 20 + 15

      // Verify average is computed correctly
      expect(stats.averageMs, equals(stats.totalMs / stats.count));
      expect(stats.averageMs, greaterThanOrEqualTo(15.0));
    });
  });
}

/// Helper function to create a test request.
Request _createRequest({
  Method method = Method.get,
  String path = '/test',
}) {
  return Request(
    method,
    Uri.parse('http://localhost:8080$path'),
    headers: Headers.build((h) {}),
  );
}
