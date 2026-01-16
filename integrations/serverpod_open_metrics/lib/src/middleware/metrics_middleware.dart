import 'dart:io' as io;

import 'package:serverpod/serverpod.dart';

import '../metrics/counter.dart';
import '../metrics/gauge.dart';
import '../metrics/histogram.dart';
import '../metrics/metric_registry.dart';
import '../util/path_normalizer.dart';
import '../util/text_format.dart';
import 'ip_access_control.dart';

/// Default histogram buckets for HTTP request duration (in seconds).
///
/// These buckets cover a range from 5ms to 10 seconds, which is suitable
/// for most HTTP APIs:
/// - 0.005 = 5ms
/// - 0.01 = 10ms
/// - 0.025 = 25ms
/// - 0.05 = 50ms
/// - 0.1 = 100ms
/// - 0.25 = 250ms
/// - 0.5 = 500ms
/// - 1.0 = 1 second
/// - 2.5 = 2.5 seconds
/// - 5.0 = 5 seconds
/// - 10.0 = 10 seconds
const List<double> _defaultHistogramBuckets = [
  0.005,
  0.01,
  0.025,
  0.05,
  0.1,
  0.25,
  0.5,
  1.0,
  2.5,
  5.0,
  10.0,
];

/// Creates an OpenMetrics middleware that collects HTTP metrics and
/// exposes them via a `/metrics` endpoint.
///
/// Parameters
///
/// - [registry] - Optional custom metric registry. If not provided, a new
///   registry is created. Use this to add custom metrics alongside the
///   standard HTTP metrics.
///
/// - [histogramBuckets] - Optional custom bucket boundaries for the
///   `http_request_duration_seconds` histogram (in seconds). Defaults to
///   a range from 5ms to 10 seconds.
///
/// - [maxPathPatterns] - Maximum number of unique normalized path patterns
///   to track. Once exceeded, additional paths are labeled as `:overflow`.
///   Default: 100
///
/// - [maxLabelCardinality] - Maximum number of unique label combinations
///   (method × path × status) across all metrics. Helps prevent unbounded
///   memory growth. Default: `maxPathPatterns × 250`
///
/// - [pathNormalizer] - Optional custom path normalizer for converting
///   dynamic paths (e.g., `/user/123`) to patterns (e.g., `/user/:id`).
///
/// - [trackInFlight] - Whether to track in-flight requests with the
///   `http_requests_in_flight` gauge. Default: true
///
/// - [metricsPath] - The URL path where metrics are exposed.
///   Default: `/metrics`
///
/// - [allowedIps] - Optional list of allowed IP addresses and subnets in
///   CIDR notation. Controls which clients can access the metrics endpoint.
///   - If `null` (default): Only localhost (127.0.0.1, ::1) is allowed
///   - If empty list `[]`: Access control is disabled (allow all)
///   - If non-empty list: Only specified IPs/subnets are allowed
///   Throws [ArgumentError] if any rule has invalid format.
///
/// - [ipExtractor] - Optional function to extract client IP from Request.
///   Defaults to `(req) => req.remoteInfo`, which handles proxy headers
///   (Forwarded, X-Forwarded-For) automatically. Primarily useful for
///   testing or custom proxy configurations.
Middleware metricsMiddleware({
  final MetricRegistry? registry,
  final List<double>? histogramBuckets,
  final int maxPathPatterns = 100,
  final int? maxLabelCardinality,
  final PathNormalizer? pathNormalizer,
  final bool trackInFlight = true,
  final String metricsPath = '/metrics',
  final List<String>? allowedIps,
  final String Function(Request)? ipExtractor,
}) {
  // Validate configuration parameters up-front
  if (maxPathPatterns <= 0) {
    throw ArgumentError.value(
      maxPathPatterns,
      'maxPathPatterns',
      'Must be greater than 0',
    );
  }

  if (maxLabelCardinality != null && maxLabelCardinality <= 0) {
    throw ArgumentError.value(
      maxLabelCardinality,
      'maxLabelCardinality',
      'Must be greater than 0',
    );
  }

  // Create IP access control - default to localhost only (secure by default)
  final IpAccessControl? accessControl = allowedIps != null
      ? (allowedIps.isEmpty
            ? null // Empty list means explicitly disable (allow all)
            : IpAccessControl(allowedIps))
      : IpAccessControl.localhostOnly(); // Default: localhost only

  // Use provided IP extractor or default to remoteInfo
  final extractIp = ipExtractor ?? (final Request req) => req.remoteInfo;

  // Create or use provided registry
  final metricRegistry = registry ?? MetricRegistry();
  final normalizer = pathNormalizer ?? PathNormalizer();
  final buckets = histogramBuckets ?? _defaultHistogramBuckets;

  // Calculate max label cardinality
  // We need to account for: paths × methods × status codes
  // Typical: ~10 HTTP methods (GET, POST, PUT, DELETE, PATCH, etc.)
  //          ~20 status codes (200, 201, 400, 401, 403, 404, 500, etc.)
  // So: maxPathPatterns × 10 × 20 = maxPathPatterns × 200
  // Add buffer for errors and edge cases: maxPathPatterns × 250
  final labelCardinality = maxLabelCardinality ?? (maxPathPatterns * 250);

  // Track path patterns we've seen to enforce cardinality limits
  final Set<String> knownPaths = {};

  // Register standard HTTP metrics
  late final LabeledCounter requestsTotal;
  late final LabeledHistogram requestDuration;
  late final LabeledGauge requestsInFlight;

  // Helper to register or reuse a metric with type checking
  T getOrRegisterMetric<T>(
    final String name,
    final T Function() factory,
    final String expectedTypeName,
  ) {
    try {
      return factory();
    } on ArgumentError catch (e) {
      // Check if this is an "already registered" error
      if (e.message?.toString().contains('already registered') ?? false) {
        // Metric exists - try to reuse it with type checking
        final existing = metricRegistry.getMetric(name);
        if (existing == null) {
          throw StateError(
            'Metric "$name" was reported as already registered but is not found in registry',
          );
        }
        if (existing is! T) {
          throw ArgumentError(
            'Metric "$name" already exists in registry with incompatible type ${existing.runtimeType}. '
            'Expected $expectedTypeName. Remove the conflicting metric or use a different registry.',
          );
        }
        // Safe to cast because we just checked with is! T
        return existing as T;
      }
      // Not an "already registered" error - rethrow original exception
      rethrow;
    }
  }

  requestsTotal = getOrRegisterMetric(
    'http_requests_total',
    () {
      final counter = LabeledCounter(
        name: 'http_requests_total',
        help: 'Total number of HTTP requests',
        labelNames: ['method', 'path', 'status'],
        maxCardinality: labelCardinality,
      );
      metricRegistry.register(counter);
      return counter;
    },
    'LabeledCounter',
  );

  requestDuration = getOrRegisterMetric(
    'http_request_duration_seconds',
    () {
      final histogram = LabeledHistogram(
        name: 'http_request_duration_seconds',
        help: 'HTTP request latency in seconds',
        labelNames: ['method', 'path', 'status'],
        buckets: buckets,
        maxCardinality: labelCardinality,
      );
      metricRegistry.register(histogram);
      return histogram;
    },
    'LabeledHistogram',
  );

  if (trackInFlight) {
    // In-flight tracking has fewer combinations (no status code)
    // So we can use a smaller limit: paths × methods
    final inFlightCardinality = maxLabelCardinality ?? (maxPathPatterns * 20);
    requestsInFlight = getOrRegisterMetric(
      'http_requests_in_flight',
      () {
        final gauge = LabeledGauge(
          name: 'http_requests_in_flight',
          help: 'Current number of in-flight HTTP requests',
          labelNames: ['method', 'path'],
          maxCardinality: inFlightCardinality,
        );
        metricRegistry.register(gauge);
        return gauge;
      },
      'LabeledGauge',
    );
  }

  // Register process start time metric
  // This helps Prometheus distinguish server restarts from counter resets
  getOrRegisterMetric(
    'process_start_time_seconds',
    () {
      final gauge = Gauge(
        name: 'process_start_time_seconds',
        help: 'Unix timestamp of when the process started',
      );
      metricRegistry.register(gauge);
      // Set to current time in seconds since epoch
      gauge.set(DateTime.now().millisecondsSinceEpoch / 1000);
      return gauge;
    },
    'Gauge',
  );

  return (final Handler innerHandler) {
    return (final Request req) async {
      final uri = req.url;

      // Short-circuit: serve metrics endpoint
      if (uri.path == metricsPath) {
        // Check IP access control
        if (accessControl != null) {
          final clientIp = extractIp(req);
          if (!accessControl.isAllowed(clientIp)) {
            return Response(
              io.HttpStatus.forbidden,
              body: Body.fromString(
                'Access denied',
                mimeType: MimeType.parse('text/plain'),
              ),
            );
          }
        }

        // Negotiate format based on Accept header
        // Get the raw Accept header value
        final acceptHeaderValues = req.headers['accept'];
        final acceptHeaderString =
            acceptHeaderValues != null && acceptHeaderValues.isNotEmpty
            ? acceptHeaderValues.first
            : null;

        final format = OpenMetricsTextFormat.negotiateFormat(
          acceptHeaderString,
        );

        // Format metrics in the negotiated format
        final metricsOutput = OpenMetricsTextFormat.format(
          metricRegistry,
          format: format,
        );

        final contentType = OpenMetricsTextFormat.getContentType(format);

        // Parse mimeType for the body (just the type/subtype part)
        final mimeTypeString = format == MetricsFormat.openMetrics
            ? 'application/openmetrics-text'
            : 'text/plain';
        final mimeType = MimeType.parse(mimeTypeString);

        // Create headers with the full content-type (including version parameter)
        final responseHeaders = Headers.build((final h) {
          h[io.HttpHeaders.contentTypeHeader] = [contentType];
        });

        // Create response with the specified mimeType
        return Response(
          io.HttpStatus.ok,
          headers: responseHeaders,
          body: Body.fromString(metricsOutput, mimeType: mimeType),
        );
      }

      // Normalize path for metrics (with cardinality protection)
      String normalizedPath = normalizer.normalize(uri.path);

      // Cardinality protection: enforce max unique paths
      if (!knownPaths.contains(normalizedPath)) {
        if (knownPaths.length >= maxPathPatterns) {
          normalizedPath = ':overflow';
        } else {
          knownPaths.add(normalizedPath);
        }
      }

      final method = req.method.value;
      final stopwatch = Stopwatch()..start();

      // Track in-flight requests
      if (trackInFlight) {
        requestsInFlight.labels([method, normalizedPath]).inc();
      }

      try {
        final result = await innerHandler(req);

        stopwatch.stop();
        // Use microseconds for sub-millisecond precision
        final durationSeconds = stopwatch.elapsedMicroseconds / 1e6;

        // Extract status code
        final statusCode = result is Response
            ? result.statusCode.toString()
            : 'unknown';

        // Record metrics
        requestsTotal.labels([method, normalizedPath, statusCode]).inc();
        requestDuration
            .labels([method, normalizedPath, statusCode])
            .observe(durationSeconds);

        return result;
      } catch (e) {
        stopwatch.stop();
        // Use microseconds for sub-millisecond precision
        final durationSeconds = stopwatch.elapsedMicroseconds / 1e6;

        // Record error metrics
        requestsTotal.labels([method, normalizedPath, 'error']).inc();
        requestDuration
            .labels([method, normalizedPath, 'error'])
            .observe(durationSeconds);

        rethrow;
      } finally {
        // Always decrement in-flight counter
        if (trackInFlight) {
          requestsInFlight.labels([method, normalizedPath]).dec();
        }
      }
    };
  };
}
