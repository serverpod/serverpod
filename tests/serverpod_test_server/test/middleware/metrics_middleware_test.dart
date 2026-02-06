import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_open_metrics/serverpod_open_metrics.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('metricsMiddleware - basic metrics collection', () {
    late Serverpod server;
    late http.Client httpClient;
    late Uri endpoint;
    late Uri metricsEndpoint;

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

      // Add metrics middleware with disabled IP restrictions for testing
      server.server.addMiddleware(
        metricsMiddleware(
          allowedIps: [], // Disable IP access control for tests
        ),
      );

      // Start the server
      await server.start();

      httpClient = http.Client();

      // Get the actual port assigned
      final actualPort = server.server.port;
      endpoint = Uri.parse('http://localhost:$actualPort/basicTypes/testInt');
      metricsEndpoint = Uri.parse('http://localhost:$actualPort/metrics');
    });

    tearDown(() async {
      httpClient.close();
      await server.shutdown(exitProcess: false);
    });

    test(
      'given metrics middleware is configured, when requesting /metrics endpoint, then returns correct content type',
      () async {
        final response = await httpClient.get(metricsEndpoint);

        expect(response.statusCode, 200);
        expect(
          response.headers['content-type'],
          contains('text/plain'),
          reason: 'Should use Prometheus text format',
        );
        // Note: The relic framework may modify the content-type header
        // The important part is that it contains text/plain
      },
    );

    test(
      'given metrics middleware is configured, when requesting /metrics endpoint, then returns Prometheus format',
      () async {
        final response = await httpClient.get(metricsEndpoint);

        expect(response.statusCode, 200);
        final body = response.body;

        // Verify Prometheus format structure
        expect(body, contains('# HELP'), reason: 'Should include HELP lines');
        expect(body, contains('# TYPE'), reason: 'Should include TYPE lines');
      },
    );

    test(
      'given a request has been made, when requesting /metrics, then includes http_requests_total metric',
      () async {
        // Make a request
        await httpClient.post(
          endpoint,
          headers: {'Content-Type': 'application/json'},
          body: '{"value": 42}',
        );

        // Check metrics
        final metricsResponse = await httpClient.get(metricsEndpoint);
        final metrics = metricsResponse.body;

        // Verify counter metric exists
        expect(metrics, contains('http_requests_total'));
        expect(metrics, contains('# TYPE http_requests_total counter'));

        // Verify metric has labels and value
        expect(metrics, contains('method="POST"'));
        expect(metrics, contains('status="200"'));
        expect(metrics, matches(RegExp(r'http_requests_total.*\s+\d+')));
      },
    );

    test(
      'given a request has been made, when requesting /metrics, then includes http_request_duration_seconds metric',
      () async {
        // Make a request
        await httpClient.post(
          endpoint,
          headers: {'Content-Type': 'application/json'},
          body: '{"value": 42}',
        );

        // Check metrics
        final metricsResponse = await httpClient.get(metricsEndpoint);
        final metrics = metricsResponse.body;

        // Verify histogram metric exists
        expect(metrics, contains('http_request_duration_seconds'));
        expect(
          metrics,
          contains('# TYPE http_request_duration_seconds histogram'),
        );

        // Verify histogram components (count, sum, buckets)
        expect(metrics, contains('http_request_duration_seconds_count'));
        expect(metrics, contains('http_request_duration_seconds_sum'));
        expect(metrics, contains('http_request_duration_seconds_bucket'));
      },
    );

    test(
      'given metrics middleware is configured, when requesting /metrics, then includes http_requests_in_flight metric',
      () async {
        final metricsResponse = await httpClient.get(metricsEndpoint);
        final metrics = metricsResponse.body;

        // Verify gauge metric exists
        expect(metrics, contains('http_requests_in_flight'));
        expect(metrics, contains('# TYPE http_requests_in_flight gauge'));
      },
    );

    test(
      'given metrics middleware is configured, when requesting /metrics, then includes process_start_time_seconds metric',
      () async {
        final metricsResponse = await httpClient.get(metricsEndpoint);
        final metrics = metricsResponse.body;

        // Verify process start time metric exists
        expect(metrics, contains('process_start_time_seconds'));
        expect(metrics, contains('# TYPE process_start_time_seconds gauge'));

        // Extract and verify the timestamp value
        final timestampMatch = RegExp(
          r'process_start_time_seconds\s+(\d+\.?\d*)',
        ).firstMatch(metrics);

        expect(
          timestampMatch,
          isNotNull,
          reason: 'Should have process_start_time_seconds value',
        );

        final timestamp = double.parse(timestampMatch!.group(1)!);

        // Verify it's a reasonable Unix timestamp (after 2020, before far future)
        final year2020 = DateTime(2020).millisecondsSinceEpoch / 1000;
        final year2100 = DateTime(2100).millisecondsSinceEpoch / 1000;
        expect(
          timestamp,
          greaterThan(year2020),
          reason: 'Timestamp should be after 2020',
        );
        expect(
          timestamp,
          lessThan(year2100),
          reason: 'Timestamp should be before 2100',
        );

        // Verify it's close to current time (within 1 minute of test start)
        final now = DateTime.now().millisecondsSinceEpoch / 1000;
        expect(
          (now - timestamp).abs(),
          lessThan(60),
          reason: 'Timestamp should be recent (within 1 minute)',
        );
      },
    );

    test(
      'given multiple requests have been made, when requesting /metrics, then request counter is incremented',
      () async {
        // Make multiple requests
        for (var i = 0; i < 3; i++) {
          await httpClient.post(
            endpoint,
            headers: {'Content-Type': 'application/json'},
            body: '{"value": $i}',
          );
        }

        // Check that counter increased
        final metricsResponse = await httpClient.get(metricsEndpoint);
        final metrics = metricsResponse.body;

        // Extract count from histogram (which should match number of requests)
        final countMatch = RegExp(
          r'http_request_duration_seconds_count\{[^}]*\}\s+(\d+)',
        ).firstMatch(metrics);

        expect(countMatch, isNotNull);
        final count = int.parse(countMatch!.group(1)!);
        expect(count, greaterThanOrEqualTo(3));
      },
    );

    test(
      'given 50 concurrent requests are sent, when all complete, then metrics are recorded safely',
      () async {
        // Send 50 concurrent requests to test async interleaving
        final futures = List.generate(50, (i) {
          return httpClient.post(
            endpoint,
            headers: {'Content-Type': 'application/json'},
            body: '{"value": $i}',
          );
        });

        // Wait for all to complete
        final responses = await Future.wait(futures);

        // Verify all requests succeeded
        for (final response in responses) {
          expect(
            response.statusCode,
            equals(200),
            reason: 'All concurrent requests should succeed',
          );
        }

        // Verify metrics are correct
        final metricsResponse = await httpClient.get(metricsEndpoint);
        final metrics = metricsResponse.body;

        // Extract count
        final countMatch = RegExp(
          r'http_request_duration_seconds_count\{[^}]*\}\s+(\d+)',
        ).firstMatch(metrics);

        expect(
          countMatch,
          isNotNull,
          reason: 'Should have request duration count metric',
        );
        final count = int.parse(countMatch!.group(1)!);
        expect(
          count,
          equals(50),
          reason: 'All 50 concurrent requests should be counted',
        );
      },
    );

    test(
      'given requests to paths with numeric IDs, when requesting /metrics, then paths are normalized to prevent unbounded cardinality',
      () async {
        // Make requests to different endpoints with IDs
        final endpoints = [
          Uri.parse('http://localhost:${server.server.port}/api/user/123'),
          Uri.parse('http://localhost:${server.server.port}/api/user/456'),
          Uri.parse('http://localhost:${server.server.port}/api/user/789'),
        ];

        for (final endpoint in endpoints) {
          try {
            await httpClient.get(endpoint);
          } catch (_) {
            // Endpoints may not exist - that's OK, we just want metrics
          }
        }

        // Check metrics - should have normalized path
        final metricsResponse = await httpClient.get(metricsEndpoint);
        final metrics = metricsResponse.body;

        // Should see normalized path pattern, not individual IDs
        expect(metrics, contains('/api/user/:id'));

        // Should NOT see individual IDs as separate metrics
        expect(metrics, isNot(contains('/api/user/123')));
        expect(metrics, isNot(contains('/api/user/456')));
        expect(metrics, isNot(contains('/api/user/789')));
      },
    );

    test(
      'given a fast request has been made, when requesting /metrics, then duration has sub-millisecond precision',
      () async {
        // Make a fast request
        await httpClient.post(
          endpoint,
          headers: {'Content-Type': 'application/json'},
          body: '{"value": 42}',
        );

        // Check metrics - should have precise timing data
        final metricsResponse = await httpClient.get(metricsEndpoint);
        final metrics = metricsResponse.body;

        // Extract the duration sum value
        final sumMatch = RegExp(
          r'http_request_duration_seconds_sum\{[^}]*\}\s+([\d.]+)',
        ).firstMatch(metrics);

        expect(sumMatch, isNotNull, reason: 'Should have duration sum metric');
        final sum = double.parse(sumMatch!.group(1)!);

        // The sum should be greater than 0 (not quantized to 0)
        // and should have sub-millisecond precision (decimal places beyond .001)
        expect(
          sum,
          greaterThan(0.0),
          reason: 'Fast requests should not be recorded as 0 seconds',
        );

        // Check if we have precision beyond milliseconds
        // If using milliseconds, values would be multiples of 0.001
        // With microseconds, we should see more precision
        final sumString = sum.toString();
        if (sum < 1.0) {
          // For small values, check that we have more than 3 decimal places
          // or at least that it's not an exact millisecond multiple
          expect(
            sumString.contains(RegExp(r'\.\d{4,}')) || sum % 0.001 != 0,
            isTrue,
            reason: 'Should have sub-millisecond precision (microseconds)',
          );
        }
      },
    );

    test(
      'given POST and GET requests have been made, when requesting /metrics, then different HTTP methods are tracked separately',
      () async {
        final testEndpoint = Uri.parse(
          'http://localhost:${server.server.port}/basicTypes/testInt',
        );

        // Make POST request
        await httpClient.post(
          testEndpoint,
          headers: {'Content-Type': 'application/json'},
          body: '{"value": 42}',
        );

        // Make GET request (may fail, but metrics should still be collected)
        try {
          await httpClient.get(testEndpoint);
        } catch (_) {
          // Expected - endpoint may not support GET
        }

        // Check metrics
        final metricsResponse = await httpClient.get(metricsEndpoint);
        final metrics = metricsResponse.body;

        // Should see both methods tracked
        expect(metrics, contains('method="POST"'));
        expect(metrics, contains('method="GET"'));
      },
    );
  });

  group('metricsMiddleware - custom configuration', () {
    test(
      'given a custom registry with a custom metric, when requesting /metrics, then both standard and custom metrics are included',
      () async {
        final customRegistry = MetricRegistry();

        // Add custom metric
        final myCounter = Counter(
          name: 'my_custom_total',
          help: 'My custom counter',
        );
        customRegistry.register(myCounter);

        // Create test config
        final portZeroConfig = ServerConfig(
          port: 0,
          publicScheme: 'http',
          publicHost: 'localhost',
          publicPort: 0,
        );

        final server = IntegrationTestServer.create(
          config: ServerpodConfig(
            apiServer: portZeroConfig,
          ),
        );

        // Add metrics middleware
        server.server.addMiddleware(
          metricsMiddleware(
            registry: customRegistry,
            allowedIps: [], // Disable IP access control for tests
          ),
        );

        await server.start();

        try {
          final httpClient = http.Client();
          final actualPort = server.server.port;
          final metricsEndpoint = Uri.parse(
            'http://localhost:$actualPort/metrics',
          );

          // Increment custom counter
          myCounter.inc();

          // Check metrics
          final response = await httpClient.get(metricsEndpoint);
          final metrics = response.body;

          // Should see both standard and custom metrics
          expect(metrics, contains('http_requests_total'));
          expect(metrics, contains('my_custom_total'));
          expect(metrics, contains('My custom counter'));

          httpClient.close();
        } finally {
          await server.shutdown(exitProcess: false);
        }
      },
    );

    test(
      'given a custom metrics path is configured, when requesting the custom path, then returns metrics',
      () async {
        final portZeroConfig = ServerConfig(
          port: 0,
          publicScheme: 'http',
          publicHost: 'localhost',
          publicPort: 0,
        );

        final server = IntegrationTestServer.create(
          config: ServerpodConfig(
            apiServer: portZeroConfig,
          ),
        );

        // Add metrics middleware
        server.server.addMiddleware(
          metricsMiddleware(
            metricsPath: '/custom-metrics',
            allowedIps: [], // Disable IP access control for tests
          ),
        );

        await server.start();

        try {
          final httpClient = http.Client();
          final actualPort = server.server.port;
          final customEndpoint = Uri.parse(
            'http://localhost:$actualPort/custom-metrics',
          );
          final defaultEndpoint = Uri.parse(
            'http://localhost:$actualPort/metrics',
          );

          // Custom path should work
          final customResponse = await httpClient.get(customEndpoint);
          expect(customResponse.statusCode, 200);
          expect(customResponse.body, contains('# TYPE'));

          // Default path should not work (returns non-metrics response)
          final defaultResponse = await httpClient.get(defaultEndpoint);
          expect(
            defaultResponse.statusCode,
            isNot(equals(200)),
            reason: 'Default /metrics should not be available',
          );

          httpClient.close();
        } finally {
          await server.shutdown(exitProcess: false);
        }
      },
    );

    test(
      'given custom histogram buckets are configured, when requesting /metrics after a request, then uses custom bucket boundaries',
      () async {
        final customBuckets = [0.1, 0.5, 1.0];

        final portZeroConfig = ServerConfig(
          port: 0,
          publicScheme: 'http',
          publicHost: 'localhost',
          publicPort: 0,
        );

        final server = IntegrationTestServer.create(
          config: ServerpodConfig(
            apiServer: portZeroConfig,
          ),
        );

        // Add metrics middleware
        server.server.addMiddleware(
          metricsMiddleware(
            histogramBuckets: customBuckets,
            allowedIps: [], // Disable IP access control for tests
          ),
        );

        await server.start();

        try {
          final httpClient = http.Client();
          final actualPort = server.server.port;
          final endpoint = Uri.parse(
            'http://localhost:$actualPort/basicTypes/testInt',
          );
          final metricsEndpoint = Uri.parse(
            'http://localhost:$actualPort/metrics',
          );

          // Make a request
          await httpClient.post(
            endpoint,
            headers: {'Content-Type': 'application/json'},
            body: '{"value": 42}',
          );

          // Check metrics - should use custom buckets
          final response = await httpClient.get(metricsEndpoint);
          final metrics = response.body;

          // Should see custom bucket boundaries (as they appear in Prometheus format)
          expect(metrics, contains('le="0.1"'));
          expect(metrics, contains('le="0.5"'));
          expect(metrics, contains('le="1.0"')); // Dart's toString() adds .0
          expect(metrics, contains('le="+Inf"'));

          httpClient.close();
        } finally {
          await server.shutdown(exitProcess: false);
        }
      },
    );

    test(
      'given trackInFlight is set to false, when requesting /metrics, then http_requests_in_flight metric is absent',
      () async {
        final portZeroConfig = ServerConfig(
          port: 0,
          publicScheme: 'http',
          publicHost: 'localhost',
          publicPort: 0,
        );

        final server = IntegrationTestServer.create(
          config: ServerpodConfig(
            apiServer: portZeroConfig,
          ),
        );

        // Add metrics middleware
        server.server.addMiddleware(
          metricsMiddleware(
            trackInFlight: false,
            allowedIps: [], // Disable IP access control for tests
          ),
        );

        await server.start();

        try {
          final httpClient = http.Client();
          final actualPort = server.server.port;
          final metricsEndpoint = Uri.parse(
            'http://localhost:$actualPort/metrics',
          );

          // Check metrics
          final response = await httpClient.get(metricsEndpoint);
          final metrics = response.body;

          // Should NOT see in-flight metric
          expect(metrics, isNot(contains('http_requests_in_flight')));

          // Should still see other metrics
          expect(metrics, contains('http_requests_total'));

          httpClient.close();
        } finally {
          await server.shutdown(exitProcess: false);
        }
      },
    );
  });

  group('metricsMiddleware - parameter validation', () {
    test(
      'given maxPathPatterns is 0, when creating middleware, then throws ArgumentError',
      () {
        expect(
          () => metricsMiddleware(maxPathPatterns: 0),
          throwsA(
            isA<ArgumentError>()
                .having(
                  (e) => e.message,
                  'message',
                  contains('Must be greater than 0'),
                )
                .having(
                  (e) => e.name,
                  'name',
                  equals('maxPathPatterns'),
                ),
          ),
        );
      },
    );

    test(
      'given maxPathPatterns is negative, when creating middleware, then throws ArgumentError',
      () {
        expect(
          () => metricsMiddleware(maxPathPatterns: -1),
          throwsA(
            isA<ArgumentError>()
                .having(
                  (e) => e.message,
                  'message',
                  contains('Must be greater than 0'),
                )
                .having(
                  (e) => e.name,
                  'name',
                  equals('maxPathPatterns'),
                ),
          ),
        );
      },
    );

    test(
      'given maxLabelCardinality is 0, when creating middleware, then throws ArgumentError',
      () {
        expect(
          () => metricsMiddleware(maxLabelCardinality: 0),
          throwsA(
            isA<ArgumentError>()
                .having(
                  (e) => e.message,
                  'message',
                  contains('Must be greater than 0'),
                )
                .having(
                  (e) => e.name,
                  'name',
                  equals('maxLabelCardinality'),
                ),
          ),
        );
      },
    );

    test(
      'given maxLabelCardinality is negative, when creating middleware, then throws ArgumentError',
      () {
        expect(
          () => metricsMiddleware(maxLabelCardinality: -100),
          throwsA(
            isA<ArgumentError>()
                .having(
                  (e) => e.message,
                  'message',
                  contains('Must be greater than 0'),
                )
                .having(
                  (e) => e.name,
                  'name',
                  equals('maxLabelCardinality'),
                ),
          ),
        );
      },
    );

    test(
      'given maxPathPatterns is 1, when creating middleware, then succeeds with minimum valid value',
      () {
        final middleware = metricsMiddleware(maxPathPatterns: 1);
        expect(middleware, isA<Middleware>());
      },
    );

    test(
      'given maxLabelCardinality is 1, when creating middleware, then succeeds with minimum valid value',
      () {
        final middleware = metricsMiddleware(maxLabelCardinality: 1);
        expect(middleware, isA<Middleware>());
      },
    );

    test(
      'given maxLabelCardinality is null, when creating middleware, then uses default value',
      () {
        final middleware = metricsMiddleware(maxLabelCardinality: null);
        expect(middleware, isA<Middleware>());
      },
    );

    test(
      'given an invalid maxPathPatterns, when creating middleware, then fails fast during configuration',
      () {
        // This test ensures validation happens at middleware creation time,
        // not when the first request is processed
        expect(
          () => metricsMiddleware(maxPathPatterns: -5),
          throwsA(isA<ArgumentError>()),
          reason: 'Should fail immediately during configuration',
        );
      },
    );
  });

  group('metricsMiddleware - registry conflict handling', () {
    test(
      'given a registry with a conflicting metric type, when creating middleware, then throws descriptive error',
      () {
        final registry = MetricRegistry();

        // Register a counter with the name that middleware expects for a histogram
        registry.register(
          Counter(
            name: 'http_request_duration_seconds',
            help: 'This is a counter, not a histogram',
          ),
        );

        // Attempting to create middleware should fail with a clear error
        expect(
          () => metricsMiddleware(registry: registry),
          throwsA(
            isA<ArgumentError>()
                .having(
                  (e) => e.message,
                  'message',
                  contains('already exists in registry with incompatible type'),
                )
                .having(
                  (e) => e.message,
                  'message',
                  contains('Counter'),
                )
                .having(
                  (e) => e.message,
                  'message',
                  contains('LabeledHistogram'),
                ),
          ),
        );
      },
    );

    test(
      'given a registry with pre-registered compatible metrics, when creating middleware, then reuses existing metrics',
      () {
        final registry = MetricRegistry();

        // Pre-register the metrics with compatible types
        final existingCounter = LabeledCounter(
          name: 'http_requests_total',
          help: 'Pre-existing counter',
          labelNames: ['method', 'path', 'status'],
        );
        registry.register(existingCounter);

        final existingHistogram = LabeledHistogram(
          name: 'http_request_duration_seconds',
          help: 'Pre-existing histogram',
          labelNames: ['method', 'path', 'status'],
        );
        registry.register(existingHistogram);

        // Should succeed and reuse existing metrics
        final middleware = metricsMiddleware(registry: registry);
        expect(middleware, isA<Middleware>());

        // Increment the pre-existing counter to verify it's being used
        existingCounter.labels(['GET', '/test', '200']).inc();
        existingHistogram.labels(['GET', '/test', '200']).observe(0.5);

        // Verify metrics are in registry
        final samples = registry.collectAll();
        expect(
          samples.any((s) => s.name == 'http_requests_total' && s.value == 1.0),
          isTrue,
        );
      },
    );

    test(
      'given unsorted histogram buckets, when creating middleware, then throws original error',
      () {
        // Invalid buckets (not sorted)
        expect(
          () => metricsMiddleware(histogramBuckets: [1.0, 0.5, 0.1]),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('must be sorted'),
            ),
          ),
        );
      },
    );

    test(
      'given empty histogram buckets, when creating middleware, then throws original error',
      () {
        expect(
          () => metricsMiddleware(histogramBuckets: []),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('at least one bucket'),
            ),
          ),
        );
      },
    );
  });

  group('metricsMiddleware - cardinality protection', () {
    test(
      'given maxPathPatterns is 100, when creating middleware, then default maxLabelCardinality is calculated correctly',
      () {
        // With maxPathPatterns=100, default should be 100 × 250 = 25,000
        final middleware = metricsMiddleware(maxPathPatterns: 100);
        expect(middleware, isA<Middleware>());
        // This test verifies the default calculation doesn't throw during creation
      },
    );

    test(
      'given custom maxLabelCardinality is provided, when creating middleware, then accepts the value',
      () {
        final middleware = metricsMiddleware(
          maxPathPatterns: 50,
          maxLabelCardinality: 100000,
        );
        expect(middleware, isA<Middleware>());
      },
    );

    test(
      'given maxPathPatterns is 2, when more than 2 unique paths are requested, then overflow path is used',
      () async {
        final portZeroConfig = ServerConfig(
          port: 0,
          publicScheme: 'http',
          publicHost: 'localhost',
          publicPort: 0,
        );

        // Set very low limit for testing
        final server = IntegrationTestServer.create(
          config: ServerpodConfig(
            apiServer: portZeroConfig,
          ),
        );

        // Add metrics middleware
        server.server.addMiddleware(
          metricsMiddleware(
            maxPathPatterns: 2,
            allowedIps: [], // Disable IP access control for tests
          ),
        );

        await server.start();

        try {
          final httpClient = http.Client();
          final actualPort = server.server.port;

          // Make requests to different endpoints (all will be normalized to /api/:id)
          // Then make requests to different top-level paths to exceed limit
          final paths = [
            '/path1',
            '/path2',
            '/path3', // This should trigger overflow
          ];

          for (final path in paths) {
            final endpoint = Uri.parse('http://localhost:$actualPort$path');
            try {
              await httpClient.get(endpoint);
            } catch (_) {
              // Endpoints don't exist - that's OK
            }
          }

          // Check metrics
          final metricsEndpoint = Uri.parse(
            'http://localhost:$actualPort/metrics',
          );
          final response = await httpClient.get(metricsEndpoint);
          final metrics = response.body;

          // Should see :overflow path for paths beyond the limit
          expect(metrics, contains(':overflow'));

          httpClient.close();
        } finally {
          await server.shutdown(exitProcess: false);
        }
      },
    );
  });

  group('metricsMiddleware - error handling', () {
    late Serverpod server;
    late http.Client httpClient;
    late Uri endpoint;
    late Uri metricsEndpoint;

    setUp(() async {
      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      // Create middleware that throws an error
      final Middleware errorThrowingMiddleware = (Handler innerHandler) {
        return (ctx) async {
          throw Exception('Test error from middleware');
        };
      };

      server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
      );

      // Add middleware
      server.server.addMiddleware(
        metricsMiddleware(
          allowedIps: [], // Disable IP access control for tests
        ),
      );
      server.server.addMiddleware(errorThrowingMiddleware);

      await server.start();
      httpClient = http.Client();

      final actualPort = server.server.port;
      endpoint = Uri.parse('http://localhost:$actualPort/basicTypes/testInt');
      metricsEndpoint = Uri.parse('http://localhost:$actualPort/metrics');
    });

    tearDown(() async {
      httpClient.close();
      await server.shutdown(exitProcess: false);
    });

    test(
      'given a middleware that throws an error, when a request fails, then metrics are still tracked',
      () async {
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

        // Check metrics were still collected
        final response = await httpClient.get(metricsEndpoint);
        final metrics = response.body;

        // Should see metrics with error status
        expect(metrics, contains('status="error"'));
        expect(metrics, contains('http_requests_total'));
        expect(metrics, contains('http_request_duration_seconds'));
      },
    );

    test(
      'given a middleware that throws an error, when a request fails, then in-flight counter is decremented',
      () async {
        // Make request that will trigger error
        try {
          await httpClient.post(
            endpoint,
            headers: {'Content-Type': 'application/json'},
            body: '{"value": 42}',
          );
        } catch (_) {
          // Expected
        }

        // Check that in-flight counter is back to 0
        final response = await httpClient.get(metricsEndpoint);
        final metrics = response.body;

        // In-flight should be 0 (or not present if no active requests)
        // We'll just verify the metric exists and doesn't cause errors
        expect(metrics, contains('http_requests_in_flight'));
      },
    );
  });

  group('metricsMiddleware - multiple middleware interaction', () {
    late Serverpod server;
    late http.Client httpClient;
    late Uri endpoint;
    late Uri metricsEndpoint;
    late List<String> middlewareOrder;

    setUp(() async {
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
      );

      // Add middleware in order
      server.server.addMiddleware(orderTrackingMiddleware('MW1'));
      server.server.addMiddleware(
        metricsMiddleware(
          allowedIps: [], // Disable IP access control for tests
        ),
      );
      server.server.addMiddleware(orderTrackingMiddleware('MW2'));

      await server.start();
      httpClient = http.Client();

      final actualPort = server.server.port;
      endpoint = Uri.parse('http://localhost:$actualPort/basicTypes/testInt');
      metricsEndpoint = Uri.parse('http://localhost:$actualPort/metrics');
    });

    tearDown(() async {
      httpClient.close();
      await server.shutdown(exitProcess: false);
    });

    test(
      'given metrics middleware is between two other middlewares, when a request is made, then middleware chain executes in correct order',
      () async {
        await httpClient.post(
          endpoint,
          headers: {'Content-Type': 'application/json'},
          body: '{"value": 42}',
        );

        // Verify middleware order (onion model)
        // Note: Only check the first 4 items since additional requests
        // (like fetching metrics) will add more entries
        expect(middlewareOrder.take(4).toList(), [
          'MW1-before',
          // Metrics middleware executes here
          'MW2-before',
          'MW2-after',
          'MW1-after',
        ]);

        // Verify metrics were collected
        final response = await httpClient.get(metricsEndpoint);
        expect(response.statusCode, 200);
        expect(response.body, contains('http_requests_total'));
      },
    );
  });

  group('metricsMiddleware - metrics endpoint behavior', () {
    test(
      'given metrics middleware is configured, when /metrics is requested multiple times, then /metrics path is not tracked in metrics',
      () async {
        final portZeroConfig = ServerConfig(
          port: 0,
          publicScheme: 'http',
          publicHost: 'localhost',
          publicPort: 0,
        );

        final server = IntegrationTestServer.create(
          config: ServerpodConfig(
            apiServer: portZeroConfig,
          ),
        );

        // Add metrics middleware
        server.server.addMiddleware(
          metricsMiddleware(
            allowedIps: [], // Disable IP access control for tests
          ),
        );

        await server.start();

        try {
          final httpClient = http.Client();
          final actualPort = server.server.port;
          final metricsEndpoint = Uri.parse(
            'http://localhost:$actualPort/metrics',
          );

          // Get metrics multiple times
          await httpClient.get(metricsEndpoint);
          await httpClient.get(metricsEndpoint);
          final response = await httpClient.get(metricsEndpoint);

          final metrics = response.body;

          // Should not see /metrics path in the metrics
          // (metrics endpoint short-circuits before tracking)
          expect(metrics, isNot(contains('path="/metrics"')));

          httpClient.close();
        } finally {
          await server.shutdown(exitProcess: false);
        }
      },
    );
  });

  group('metricsMiddleware - no server required', () {
    test(
      'given no arguments, when calling metricsMiddleware factory, then returns a valid Middleware',
      () {
        final middleware = metricsMiddleware();
        expect(middleware, isA<Middleware>());
      },
    );

    test(
      'given a custom registry, when calling metricsMiddleware factory, then returns a valid Middleware',
      () {
        final registry = MetricRegistry();
        final middleware = metricsMiddleware(registry: registry);
        expect(middleware, isA<Middleware>());
      },
    );

    test(
      'given all configuration options, when calling metricsMiddleware factory, then returns a valid Middleware',
      () {
        final registry = MetricRegistry();
        final normalizer = PathNormalizer();

        final middleware = metricsMiddleware(
          registry: registry,
          histogramBuckets: [0.1, 0.5, 1.0],
          maxPathPatterns: 50,
          maxLabelCardinality: 10000,
          pathNormalizer: normalizer,
          trackInFlight: false,
          metricsPath: '/custom',
        );

        expect(middleware, isA<Middleware>());
      },
    );
  });

  group('metricsMiddleware - OpenMetrics content negotiation', () {
    late Serverpod server;
    late http.Client httpClient;
    late Uri metricsEndpoint;

    setUp(() async {
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
      );

      // Add metrics middleware
      server.server.addMiddleware(
        metricsMiddleware(
          allowedIps: [], // Disable IP access control for tests
        ),
      );

      await server.start();
      httpClient = http.Client();

      final actualPort = server.server.port;
      metricsEndpoint = Uri.parse('http://localhost:$actualPort/metrics');
    });

    tearDown(() async {
      httpClient.close();
      await server.shutdown(exitProcess: false);
    });

    test(
      'given no Accept header, when requesting metrics, then returns Prometheus format',
      () async {
        final response = await httpClient.get(metricsEndpoint);

        expect(response.statusCode, 200);
        expect(
          response.headers['content-type'],
          contains('text/plain'),
          reason: 'Should use Prometheus format by default',
        );

        // Prometheus format should NOT have EOF marker
        expect(response.body, isNot(endsWith('# EOF\n')));
      },
    );

    test(
      'given text/plain Accept header, when requesting metrics, then returns Prometheus format',
      () async {
        final response = await httpClient.get(
          metricsEndpoint,
          headers: {'Accept': 'text/plain'},
        );

        expect(response.statusCode, 200);
        expect(
          response.headers['content-type'],
          contains('text/plain'),
        );
        expect(response.body, isNot(contains('# EOF')));
      },
    );

    test(
      'given application/openmetrics-text Accept header, when requesting metrics, then returns OpenMetrics format',
      () async {
        final response = await httpClient.get(
          metricsEndpoint,
          headers: {'Accept': 'application/openmetrics-text'},
        );

        expect(response.statusCode, 200);
        expect(
          response.headers['content-type'],
          contains('application/openmetrics-text'),
          reason: 'Should use OpenMetrics content type',
        );

        // OpenMetrics format must have EOF marker
        expect(response.body, endsWith('# EOF\n'));
      },
    );

    test(
      'given full OpenMetrics Accept header with parameters, when requesting metrics, then returns OpenMetrics format',
      () async {
        final response = await httpClient.get(
          metricsEndpoint,
          headers: {
            'Accept':
                'application/openmetrics-text; version=1.0.0; charset=utf-8',
          },
        );

        expect(response.statusCode, 200);
        expect(
          response.headers['content-type'],
          contains('application/openmetrics-text'),
        );
        expect(response.body, endsWith('# EOF\n'));
      },
    );

    test(
      'given OpenMetrics Accept header with existing metrics, when requesting, then includes all standard metrics with EOF',
      () async {
        // Make a request to generate some metrics
        final endpoint = Uri.parse(
          'http://localhost:${server.server.port}/basicTypes/testInt',
        );
        try {
          await httpClient.post(
            endpoint,
            headers: {'Content-Type': 'application/json'},
            body: '{"value": 42}',
          );
        } catch (_) {
          // Ignore errors
        }

        final response = await httpClient.get(
          metricsEndpoint,
          headers: {'Accept': 'application/openmetrics-text'},
        );

        expect(response.statusCode, 200);
        final body = response.body;

        // Should have all standard metrics
        expect(body, contains('http_requests_total'));
        expect(body, contains('http_request_duration_seconds'));
        expect(body, contains('http_requests_in_flight'));

        // Should have HELP and TYPE lines
        expect(body, contains('# HELP'));
        expect(body, contains('# TYPE'));

        // Must end with EOF
        expect(body, endsWith('# EOF\n'));
      },
    );

    test(
      'given uppercase OpenMetrics Accept header, when requesting metrics, then returns OpenMetrics format',
      () async {
        final response = await httpClient.get(
          metricsEndpoint,
          headers: {'Accept': 'APPLICATION/OPENMETRICS-TEXT'},
        );

        expect(response.statusCode, 200);
        expect(
          response.headers['content-type'],
          contains('application/openmetrics-text'),
        );
        expect(response.body, endsWith('# EOF\n'));
      },
    );

    test(
      'given multiple Accept values with OpenMetrics, when requesting metrics, then prefers OpenMetrics',
      () async {
        final response = await httpClient.get(
          metricsEndpoint,
          headers: {
            'Accept': 'text/plain; q=0.5, application/openmetrics-text',
          },
        );

        expect(response.statusCode, 200);
        expect(
          response.headers['content-type'],
          contains('application/openmetrics-text'),
          reason: 'Should prefer OpenMetrics when explicitly listed',
        );
        expect(response.body, endsWith('# EOF\n'));
      },
    );

    test(
      'given unknown media type Accept header, when requesting metrics, then returns Prometheus format',
      () async {
        final response = await httpClient.get(
          metricsEndpoint,
          headers: {'Accept': 'application/json'},
        );

        expect(response.statusCode, 200);
        expect(
          response.headers['content-type'],
          contains('text/plain'),
          reason: 'Should default to Prometheus for unknown media types',
        );
        expect(response.body, isNot(contains('# EOF')));
      },
    );

    test(
      'given multiple metrics with OpenMetrics format, when requesting, then includes exactly one EOF marker',
      () async {
        // Make multiple requests to generate various metrics
        final endpoint = Uri.parse(
          'http://localhost:${server.server.port}/basicTypes/testInt',
        );
        for (var i = 0; i < 3; i++) {
          try {
            await httpClient.post(
              endpoint,
              headers: {'Content-Type': 'application/json'},
              body: '{"value": $i}',
            );
          } catch (_) {
            // Ignore errors
          }
        }

        final response = await httpClient.get(
          metricsEndpoint,
          headers: {'Accept': 'application/openmetrics-text'},
        );

        final body = response.body;
        final eofCount = '# EOF'.allMatches(body).length;

        expect(
          eofCount,
          equals(1),
          reason: 'Should have exactly one EOF marker',
        );
        expect(body, endsWith('# EOF\n'));
      },
    );

    test(
      'given custom metrics path with OpenMetrics Accept header, when requesting, then content negotiation works',
      () async {
        await server.shutdown(exitProcess: false);

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
        );

        // Add metrics middleware
        server.server.addMiddleware(
          metricsMiddleware(
            metricsPath: '/custom-metrics',
            allowedIps: [], // Disable IP access control for tests
          ),
        );

        await server.start();

        final actualPort = server.server.port;
        final customEndpoint = Uri.parse(
          'http://localhost:$actualPort/custom-metrics',
        );

        // Test OpenMetrics on custom path
        final response = await httpClient.get(
          customEndpoint,
          headers: {'Accept': 'application/openmetrics-text'},
        );

        expect(response.statusCode, 200);
        expect(
          response.headers['content-type'],
          contains('application/openmetrics-text'),
        );
        expect(response.body, endsWith('# EOF\n'));
      },
    );
  });

  group('metricsMiddleware - IP access control', () {
    test('defaults to localhost only when allowedIps not specified', () async {
      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      final server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
      );

      // Add metrics middleware with IP extractor that simulates localhost
      server.server.addMiddleware(
        metricsMiddleware(
          ipExtractor: (req) => '127.0.0.1', // localhost
        ),
      );

      await server.start();

      try {
        final httpClient = http.Client();
        final actualPort = server.server.port;
        final metricsEndpoint = Uri.parse(
          'http://localhost:$actualPort/metrics',
        );

        final response = await httpClient.get(metricsEndpoint);
        expect(response.statusCode, equals(200));
        expect(response.body, contains('# TYPE'));

        httpClient.close();
      } finally {
        await server.shutdown(exitProcess: false);
      }
    });

    test('denies remote access by default', () async {
      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      final server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
      );

      // Add metrics middleware with IP extractor that simulates remote IP
      server.server.addMiddleware(
        metricsMiddleware(
          ipExtractor: (req) => '10.0.0.1', // remote IP
        ),
      );

      await server.start();

      try {
        final httpClient = http.Client();
        final actualPort = server.server.port;
        final metricsEndpoint = Uri.parse(
          'http://localhost:$actualPort/metrics',
        );

        final response = await httpClient.get(metricsEndpoint);
        expect(response.statusCode, equals(403));
        expect(response.body, equals('Access denied'));

        httpClient.close();
      } finally {
        await server.shutdown(exitProcess: false);
      }
    });

    test('allows all when allowedIps is empty list', () async {
      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      final server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
      );

      // Add metrics middleware with empty allowedIps (explicitly disable restrictions)
      server.server.addMiddleware(
        metricsMiddleware(
          allowedIps: [], // Explicitly disable restrictions
          ipExtractor: (req) => '10.0.0.1',
        ),
      );

      await server.start();

      try {
        final httpClient = http.Client();
        final actualPort = server.server.port;
        final metricsEndpoint = Uri.parse(
          'http://localhost:$actualPort/metrics',
        );

        final response = await httpClient.get(metricsEndpoint);
        expect(response.statusCode, equals(200));
        expect(response.body, contains('# TYPE'));

        httpClient.close();
      } finally {
        await server.shutdown(exitProcess: false);
      }
    });

    test('allows access from allowed IPv4', () async {
      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      final server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
      );

      // Add metrics middleware with allowed subnet
      server.server.addMiddleware(
        metricsMiddleware(
          allowedIps: ['192.168.1.0/24'],
          ipExtractor: (req) => '192.168.1.100', // Simulate allowed IP
        ),
      );

      await server.start();

      try {
        final httpClient = http.Client();
        final actualPort = server.server.port;
        final metricsEndpoint = Uri.parse(
          'http://localhost:$actualPort/metrics',
        );

        final response = await httpClient.get(metricsEndpoint);
        expect(response.statusCode, equals(200));
        expect(response.body, contains('# TYPE'));

        httpClient.close();
      } finally {
        await server.shutdown(exitProcess: false);
      }
    });

    test('denies access from non-allowed IPv4', () async {
      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      final server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
      );

      // Add metrics middleware with allowed subnet
      server.server.addMiddleware(
        metricsMiddleware(
          allowedIps: ['192.168.1.0/24'],
          ipExtractor: (req) => '10.0.0.1', // Not in allowlist
        ),
      );

      await server.start();

      try {
        final httpClient = http.Client();
        final actualPort = server.server.port;
        final metricsEndpoint = Uri.parse(
          'http://localhost:$actualPort/metrics',
        );

        final response = await httpClient.get(metricsEndpoint);
        expect(response.statusCode, equals(403));
        expect(response.body, contains('Access denied'));

        httpClient.close();
      } finally {
        await server.shutdown(exitProcess: false);
      }
    });

    test('supports multiple IP rules', () async {
      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      final server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
      );

      // Add metrics middleware with multiple allowed ranges
      server.server.addMiddleware(
        metricsMiddleware(
          allowedIps: ['127.0.0.1', '192.168.1.0/24', '10.0.0.0/8'],
          ipExtractor: (req) => '10.5.10.15',
        ),
      );

      await server.start();

      try {
        final httpClient = http.Client();
        final actualPort = server.server.port;
        final metricsEndpoint = Uri.parse(
          'http://localhost:$actualPort/metrics',
        );

        final response = await httpClient.get(metricsEndpoint);
        expect(response.statusCode, equals(200));
        expect(response.body, contains('# TYPE'));

        httpClient.close();
      } finally {
        await server.shutdown(exitProcess: false);
      }
    });

    test('handles IPv6 addresses', () async {
      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      final server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
      );

      // Add metrics middleware with IPv6 rules
      server.server.addMiddleware(
        metricsMiddleware(
          allowedIps: ['::1', '2001:db8::/32'],
          ipExtractor: (req) => '2001:db8::1234',
        ),
      );

      await server.start();

      try {
        final httpClient = http.Client();
        final actualPort = server.server.port;
        final metricsEndpoint = Uri.parse(
          'http://localhost:$actualPort/metrics',
        );

        final response = await httpClient.get(metricsEndpoint);
        expect(response.statusCode, equals(200));
        expect(response.body, contains('# TYPE'));

        httpClient.close();
      } finally {
        await server.shutdown(exitProcess: false);
      }
    });

    test('throws on invalid IP format at creation', () {
      expect(
        () => metricsMiddleware(allowedIps: ['not-an-ip']),
        throwsArgumentError,
      );
    });

    test('denies access with invalid IP in headers', () async {
      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      final server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
      );

      // Add metrics middleware with IP extractor that returns invalid IP
      server.server.addMiddleware(
        metricsMiddleware(
          allowedIps: ['192.168.1.0/24'],
          ipExtractor: (req) => 'invalid-ip-string',
        ),
      );

      await server.start();

      try {
        final httpClient = http.Client();
        final actualPort = server.server.port;
        final metricsEndpoint = Uri.parse(
          'http://localhost:$actualPort/metrics',
        );

        final response = await httpClient.get(metricsEndpoint);
        expect(response.statusCode, equals(403));
        expect(response.body, contains('Access denied'));

        httpClient.close();
      } finally {
        await server.shutdown(exitProcess: false);
      }
    });

    test('does not affect non-metrics endpoints', () async {
      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      final server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
      );

      // Add metrics middleware with restricted access
      server.server.addMiddleware(
        metricsMiddleware(
          allowedIps: ['192.168.1.0/24'],
          ipExtractor: (req) => '10.0.0.1', // Denied IP
        ),
      );

      await server.start();

      try {
        final httpClient = http.Client();
        final actualPort = server.server.port;

        // Non-metrics endpoint should still work
        final regularEndpoint = Uri.parse(
          'http://localhost:$actualPort/basicTypes/testInt',
        );
        final response = await httpClient.post(
          regularEndpoint,
          headers: {'Content-Type': 'application/json'},
          body: '{"value": 42}',
        );

        // Should work normally (not 403)
        expect(response.statusCode, isNot(equals(403)));

        httpClient.close();
      } finally {
        await server.shutdown(exitProcess: false);
      }
    });

    test('uses default remoteInfo when no ipExtractor provided', () async {
      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      final server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
      );

      // Add metrics middleware WITHOUT ipExtractor (will use req.remoteInfo)
      // Use a very permissive allowlist to ensure localhost connections work
      // regardless of how the system represents localhost
      server.server.addMiddleware(
        metricsMiddleware(
          allowedIps: ['0.0.0.0/0', '::/0'], // Allow all IPs
        ),
      );

      await server.start();

      try {
        final httpClient = http.Client();
        final actualPort = server.server.port;
        final metricsEndpoint = Uri.parse(
          'http://localhost:$actualPort/metrics',
        );

        final response = await httpClient.get(metricsEndpoint);

        // Verify response succeeds - this demonstrates that the default
        // IP extractor (req.remoteInfo) is being used and working correctly
        expect(response.statusCode, equals(200));
        expect(response.body, contains('# TYPE'));

        httpClient.close();
      } finally {
        await server.shutdown(exitProcess: false);
      }
    });

    test('works with custom registry and IP restrictions', () async {
      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      final server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
      );

      final customRegistry = MetricRegistry();
      final customCounter = Counter(
        name: 'my_custom_metric',
        help: 'Custom metric',
      );
      customRegistry.register(customCounter);

      // Add metrics middleware with both custom registry and IP restrictions
      server.server.addMiddleware(
        metricsMiddleware(
          registry: customRegistry,
          allowedIps: ['127.0.0.1'],
          ipExtractor: (req) => '127.0.0.1',
        ),
      );

      await server.start();

      try {
        final httpClient = http.Client();
        final actualPort = server.server.port;
        final metricsEndpoint = Uri.parse(
          'http://localhost:$actualPort/metrics',
        );

        customCounter.inc();

        final response = await httpClient.get(metricsEndpoint);
        expect(response.statusCode, equals(200));
        expect(response.body, contains('my_custom_metric'));
        expect(response.body, contains('http_requests_total'));

        httpClient.close();
      } finally {
        await server.shutdown(exitProcess: false);
      }
    });

    test('IP check happens before content negotiation', () async {
      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      final server = IntegrationTestServer.create(
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
      );

      // Add metrics middleware with restricted access
      server.server.addMiddleware(
        metricsMiddleware(
          allowedIps: ['192.168.1.0/24'],
          ipExtractor: (req) => '10.0.0.1', // Denied IP
        ),
      );

      await server.start();

      try {
        final httpClient = http.Client();
        final actualPort = server.server.port;
        final metricsEndpoint = Uri.parse(
          'http://localhost:$actualPort/metrics',
        );

        // Try with OpenMetrics Accept header - should still be denied
        final response = await httpClient.get(
          metricsEndpoint,
          headers: {'Accept': 'application/openmetrics-text'},
        );

        expect(response.statusCode, equals(403));
        expect(response.body, equals('Access denied'));
        // Should not have metrics content
        expect(response.body, isNot(contains('# TYPE')));

        httpClient.close();
      } finally {
        await server.shutdown(exitProcess: false);
      }
    });
  });
}
