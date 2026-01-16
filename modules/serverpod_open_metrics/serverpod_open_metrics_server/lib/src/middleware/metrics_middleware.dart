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
/// This middleware automatically tracks:
/// - **http_requests_total** (Counter) - Total number of HTTP requests
///   - Labels: method, path, status
/// - **http_request_duration_seconds** (Histogram) - HTTP request latency
///   - Labels: method, path, status
/// - **http_requests_in_flight** (Gauge) - Current number of in-flight requests
///   - Labels: method, path
/// - **process_start_time_seconds** (Gauge) - Unix timestamp when process started
///   - No labels (helps distinguish restarts from counter resets)
///
/// The middleware also exposes a `/metrics` endpoint that returns all metrics
/// in OpenMetrics text format. This endpoint can be scraped by Prometheus.
///
/// **Note**: WebSocket requests bypass all middleware and will not be tracked
/// by this middleware.
///
/// ## Basic Usage
///
/// ```dart
/// void run(List<String> args) async {
///   final pod = Serverpod(
///     args,
///     Protocol(),
///     Endpoints(),
///   );
///
///   // Add metrics middleware
///   pod.server.addMiddleware(metricsMiddleware());
///
///   await pod.start();
/// }
/// ```
///
/// Once running, metrics will be available at `http://localhost:8080/metrics`
///
/// ## IP Access Control
///
/// **By default, the metrics endpoint is only accessible from localhost**
/// (127.0.0.1 and ::1). This follows security best practices - metrics are
/// secure by default and must be explicitly configured for remote access.
///
/// ### Allowing Remote Access
///
/// To allow access from your monitoring infrastructure, explicitly configure
/// allowed IP addresses and subnets:
///
/// ```dart
/// pod.server.addMiddleware(
///   metricsMiddleware(
///     allowedIps: [
///       '127.0.0.1',        // localhost
///       '::1',              // IPv6 localhost
///       '192.168.0.0/16',   // private network
///       '10.0.0.0/8',       // another private network
///     ],
///   ),
/// );
/// ```
///
/// ### Supported Formats
///
/// - **IPv4 addresses**: `192.168.1.100`
/// - **IPv4 CIDR subnets**: `192.168.1.0/24`, `10.0.0.0/8`
/// - **IPv6 addresses**: `::1`, `2001:db8::1`
/// - **IPv6 CIDR subnets**: `2001:db8::/32`, `fe80::/10`
///
/// ### IP Extraction
///
/// The middleware uses `req.remoteInfo` which intelligently handles:
/// 1. `Forwarded` header (RFC 7239) - preferred
/// 2. `X-Forwarded-For` header - fallback
/// 3. Direct connection IP - final fallback
///
/// This ensures correct behavior behind load balancers and reverse proxies.
///
/// ### Disabling Access Control
///
/// To disable access control completely (not recommended for production):
///
/// ```dart
/// pod.server.addMiddleware(
///   metricsMiddleware(
///     allowedIps: [],  // Empty list = allow all
///   ),
/// );
/// ```
///
/// ### Access Denied Response
///
/// Requests from non-allowed IPs receive HTTP 403 (Forbidden) with a simple
/// "Access denied" message.
///
/// ### Common Configurations
///
/// **Kubernetes pod network:**
/// ```dart
/// allowedIps: ['10.244.0.0/16', '127.0.0.1']
/// ```
///
/// **Private networks only:**
/// ```dart
/// allowedIps: ['10.0.0.0/8', '172.16.0.0/12', '192.168.0.0/16']
/// ```
///
/// **Specific monitoring server:**
/// ```dart
/// allowedIps: ['203.0.113.50']  // Prometheus server IP
/// ```
///
/// ## Custom Metrics
///
/// You can register custom metrics by providing your own registry:
///
/// ```dart
/// final registry = MetricRegistry();
///
/// // Register custom metrics
/// final myCounter = registry.counter(
///   'my_custom_total',
///   help: 'Total number of custom events',
/// );
///
/// final myGauge = registry.gauge(
///   'my_custom_value',
///   help: 'Current value of custom metric',
/// );
///
/// // Use the registry in middleware
/// pod.server.addMiddleware(metricsMiddleware(registry: registry));
///
/// // Update metrics in your code
/// myCounter.inc();
/// myGauge.set(42.0);
/// ```
///
/// ## Configuration Options
///
/// ```dart
/// metricsMiddleware(
///   // Custom registry for your own metrics
///   registry: myRegistry,
///
///   // Custom histogram buckets (in seconds)
///   histogramBuckets: [0.01, 0.05, 0.1, 0.5, 1.0],
///
///   // Maximum unique path patterns to track (prevents unbounded cardinality)
///   maxPathPatterns: 200,
///
///   // Maximum label combinations for metrics (method × path × status)
///   // Default is maxPathPatterns × 250 (~100 paths × ~10 methods × ~25 status codes)
///   // Set this if you need to handle more combinations
///   maxLabelCardinality: 50000,
///
///   // Custom path normalizer
///   pathNormalizer: MyCustomNormalizer(),
///
///   // Disable in-flight tracking
///   trackInFlight: false,
///
///   // Custom metrics endpoint path
///   metricsPath: '/custom-metrics',
/// )
/// ```
///
/// ## Path Normalization
///
/// To prevent unbounded cardinality in metrics, paths are automatically
/// normalized to replace dynamic segments with placeholders:
///
/// - `/api/user/123` → `/api/user/:id`
/// - `/api/post/abc-def-123` → `/api/post/:id`
/// - `/api/posts/2024-01-15` → `/api/posts/:id`
///
/// This ensures that metrics don't grow unboundedly as new IDs are used.
///
/// ## Cardinality Protection
///
/// The middleware includes two layers of cardinality protection to prevent
/// metrics from consuming unbounded memory:
///
/// **Path-level protection** (controlled by `maxPathPatterns`):
/// - Maximum unique path patterns is configurable (default: 100)
/// - Once the limit is reached, new paths are labeled as `:overflow`
/// - This is the first line of defense against path explosion
///
/// **Label combination protection** (controlled by `maxLabelCardinality`):
/// - Maximum label combinations (method × path × status) is configurable
/// - Default is `maxPathPatterns × 250` to account for multiple methods and status codes
/// - Once this limit is reached, the metrics will throw an error to prevent memory exhaustion
/// - Set this explicitly if you need to handle more combinations
///
/// Example: With `maxPathPatterns=100`:
/// - Path-level: Up to 100 unique normalized paths (e.g., `/api/user/:id`)
/// - Label-level: Up to 25,000 combinations (100 paths × ~10 methods × ~25 status codes)
///
/// If you have many endpoints or expect high traffic diversity, consider increasing
/// both limits proportionally
///
/// ## OpenMetrics/Prometheus Integration
///
/// Configure Prometheus to scrape the metrics endpoint:
///
/// ```yaml
/// scrape_configs:
///   - job_name: 'serverpod'
///     static_configs:
///       - targets: ['localhost:8080']
///     metrics_path: '/metrics'
/// ```
///
/// ## See Also
///
/// - [MetricRegistry] - For registering custom metrics
/// - [Counter], [Gauge], [Histogram] - Metric types
/// - [Middleware] - The relic middleware type
/// - [ExperimentalFeatures.middleware] - How to register middleware
///
/// ## Parameters
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
    () => metricRegistry.labeledCounter(
      'http_requests_total',
      help: 'Total number of HTTP requests',
      labelNames: ['method', 'path', 'status'],
      maxCardinality: labelCardinality,
    ),
    'LabeledCounter',
  );

  requestDuration = getOrRegisterMetric(
    'http_request_duration_seconds',
    () => metricRegistry.labeledHistogram(
      'http_request_duration_seconds',
      help: 'HTTP request latency in seconds',
      labelNames: ['method', 'path', 'status'],
      buckets: buckets,
      maxCardinality: labelCardinality,
    ),
    'LabeledHistogram',
  );

  if (trackInFlight) {
    // In-flight tracking has fewer combinations (no status code)
    // So we can use a smaller limit: paths × methods
    final inFlightCardinality = maxLabelCardinality ?? (maxPathPatterns * 20);
    requestsInFlight = getOrRegisterMetric(
      'http_requests_in_flight',
      () => metricRegistry.labeledGauge(
        'http_requests_in_flight',
        help: 'Current number of in-flight HTTP requests',
        labelNames: ['method', 'path'],
        maxCardinality: inFlightCardinality,
      ),
      'LabeledGauge',
    );
  }

  // Register process start time metric
  // This helps Prometheus distinguish server restarts from counter resets
  getOrRegisterMetric(
    'process_start_time_seconds',
    () {
      final gauge = metricRegistry.gauge(
        'process_start_time_seconds',
        help: 'Unix timestamp of when the process started',
      );
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
