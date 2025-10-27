import 'dart:async';

import 'package:serverpod/serverpod.dart';

/// Container for HTTP metrics collected by [MetricsMiddleware].
///
/// This class stores request counts, durations, and active connection metrics.
/// All metrics are thread-safe in Dart's single-isolate concurrency model.
///
/// ## Example Usage
///
/// ```dart
/// final metrics = HttpMetrics();
///
/// final pod = await Serverpod(
///   args,
///   serializationManager,
///   endpoints,
///   experimentalFeatures: ExperimentalFeatures(
///     middleware: [
///       MetricsMiddleware(metrics),
///     ],
///   ),
/// );
///
/// // Later, access metrics:
/// print('Total requests: ${metrics.requestCounts}');
/// print('Active connections: ${metrics.activeConnections}');
/// ```
///
/// ## Metrics Collected
///
/// - **Request counts**: Number of requests by method, endpoint, and status
/// - **Request duration stats**: Min/max/total duration for computing averages
/// - **Active connections**: Current number of in-flight requests
///
/// ## Thread Safety
///
/// This class is safe to use across concurrent requests in Dart's single-isolate
/// model. Simple operations like counter increments are atomic in the event loop.
class HttpMetrics {
  final Map<String, int> _requestCounts = {};
  final Map<String, _DurationStats> _requestDurations = {};
  int _activeConnections = 0;

  /// Total number of requests by label (method:endpoint:status).
  ///
  /// Example:
  /// ```dart
  /// {
  ///   'GET:api:200': 150,
  ///   'POST:api:201': 50,
  ///   'GET:api:404': 5,
  /// }
  /// ```
  Map<String, int> get requestCounts => Map.unmodifiable(_requestCounts);

  /// Request duration statistics by label (method:endpoint:status).
  ///
  /// Returns aggregated statistics (min/max/total/count) to avoid
  /// unbounded memory growth. Use this to compute averages or track ranges.
  ///
  /// Example:
  /// ```dart
  /// final stats = metrics.requestDurations['GET:api:200'];
  /// if (stats != null) {
  ///   print('Min: ${stats.minMs}ms');
  ///   print('Max: ${stats.maxMs}ms');
  ///   print('Avg: ${stats.averageMs.toStringAsFixed(2)}ms');
  ///   print('Total: ${stats.totalMs}ms across ${stats.count} requests');
  /// }
  /// ```
  Map<String, DurationStats> get requestDurations =>
      Map.unmodifiable(_requestDurations);

  /// Current number of active connections (in-flight requests).
  int get activeConnections => _activeConnections;

  /// Increments the request counter for the given label.
  void _incrementCounter(String label) {
    _requestCounts[label] = (_requestCounts[label] ?? 0) + 1;
  }

  /// Records a request duration for the given label.
  void _recordDuration(String label, int durationMs) {
    _requestDurations
        .putIfAbsent(label, () => _DurationStats())
        ._record(durationMs);
  }

  /// Increments the active connections counter.
  void _incrementActive() => _activeConnections++;

  /// Decrements the active connections counter.
  void _decrementActive() => _activeConnections--;

  /// Resets cumulative metrics to their initial state.
  ///
  /// This clears request counts and duration statistics. Active connections
  /// is NOT reset because it's a gauge (point-in-time measurement) that
  /// should always reflect the actual number of in-flight requests.
  ///
  /// Resetting active connections would create a race condition where
  /// in-flight requests could leave the counter negative when they complete.
  ///
  /// Useful for testing or periodic metric resets.
  void reset() {
    _requestCounts.clear();
    _requestDurations.clear();
    // Note: _activeConnections is NOT reset - it's a gauge, not a counter
  }
}

/// Aggregated statistics for request durations.
///
/// This class stores min/max/total/count instead of individual samples
/// to avoid unbounded memory growth under load.
abstract class DurationStats {
  /// Minimum duration in milliseconds.
  int get minMs;

  /// Maximum duration in milliseconds.
  int get maxMs;

  /// Total duration in milliseconds across all requests.
  int get totalMs;

  /// Number of requests recorded.
  int get count;

  /// Average duration in milliseconds.
  double get averageMs => count > 0 ? totalMs / count : 0.0;
}

/// Internal implementation of duration statistics.
class _DurationStats implements DurationStats {
  int _minMs = 0;
  int _maxMs = 0;
  int _totalMs = 0;
  int _count = 0;

  @override
  int get minMs => _minMs;

  @override
  int get maxMs => _maxMs;

  @override
  int get totalMs => _totalMs;

  @override
  int get count => _count;

  @override
  double get averageMs => _count > 0 ? _totalMs / _count : 0.0;

  /// Records a new duration sample.
  void _record(int durationMs) {
    if (_count == 0) {
      _minMs = durationMs;
      _maxMs = durationMs;
    } else {
      if (durationMs < _minMs) _minMs = durationMs;
      if (durationMs > _maxMs) _maxMs = durationMs;
    }
    _totalMs += durationMs;
    _count++;
  }
}

/// Middleware that collects HTTP metrics for observability.
///
/// This middleware tracks request counts, durations, and active connections,
/// providing insight into your application's HTTP traffic patterns.
///
/// ## Example Usage
///
/// ### Basic metrics collection
/// ```dart
/// final metrics = HttpMetrics();
///
/// final pod = await Serverpod(
///   args,
///   serializationManager,
///   endpoints,
///   experimentalFeatures: ExperimentalFeatures(
///     middleware: [
///       MetricsMiddleware(metrics),
///     ],
///   ),
/// );
///
/// // Access metrics
/// print('Requests: ${metrics.requestCounts}');
/// print('Active: ${metrics.activeConnections}');
/// ```
///
/// ### Exposing metrics via endpoint
/// ```dart
/// class MetricsEndpoint extends Endpoint {
///   final HttpMetrics metrics;
///
///   MetricsEndpoint(this.metrics);
///
///   Future<Map<String, dynamic>> getMetrics(Session session) async {
///     return {
///       'counts': metrics.requestCounts,
///       'active': metrics.activeConnections,
///     };
///   }
/// }
/// ```
///
/// ## Metrics Format
///
/// Metrics are labeled as `METHOD:endpoint:status`:
/// - `GET:api:200` - Successful GET requests to /api
/// - `POST:users:201` - Successful POST requests to /users
/// - `GET:api:500` - Failed GET requests to /api
///
/// ## Performance
///
/// This middleware has minimal overhead:
/// - Simple counter increments (< 1μs)
/// - Constant-time duration aggregation (min/max/sum updates)
/// - Bounded memory usage (O(1) per unique endpoint/status combination)
/// - No blocking operations
///
/// ## Integration with Monitoring Systems
///
/// The collected metrics can be exported to monitoring systems:
/// - Prometheus (convert to Prometheus format)
/// - Grafana (visualize metrics)
/// - OpenTelemetry (export as traces/metrics)
/// - Custom dashboards (via HTTP endpoint)
class MetricsMiddleware implements HttpMiddleware {
  /// The metrics collection instance.
  final HttpMetrics metrics;

  /// Creates a [MetricsMiddleware] instance.
  ///
  /// The same [HttpMetrics] instance should be passed to all instances
  /// of this middleware to aggregate metrics across the application.
  MetricsMiddleware(this.metrics);

  @override
  Future<Response> handle(Request request, NextFunction next) async {
    metrics._incrementActive();
    final stopwatch = Stopwatch()..start();

    try {
      final response = await next(request);
      final duration = stopwatch.elapsedMilliseconds;

      final label = _buildLabel(
        request.method.name.toUpperCase(),
        _extractEndpoint(request.requestedUri.path),
        '${response.statusCode}',
      );

      metrics._incrementCounter(label);
      metrics._recordDuration(label, duration);

      return response;
    } catch (error) {
      final duration = stopwatch.elapsedMilliseconds;

      final label = _buildLabel(
        request.method.name.toUpperCase(),
        _extractEndpoint(request.requestedUri.path),
        '500',
      );

      metrics._incrementCounter(label);
      metrics._recordDuration(label, duration);

      rethrow;
    } finally {
      metrics._decrementActive();
    }
  }

  /// Builds a metric label from method, endpoint, and status.
  ///
  /// Format: `METHOD:endpoint:status`
  ///
  /// Example: `GET:api:200`
  String _buildLabel(String method, String endpoint, String status) {
    return '$method:$endpoint:$status';
  }

  /// Extracts the endpoint name from the request path.
  ///
  /// Returns the first path segment, or 'unknown' if the path is empty.
  ///
  /// Examples:
  /// - `/api/users/123` → `api`
  /// - `/health` → `health`
  /// - `/` → `root`
  String _extractEndpoint(String path) {
    if (path == '/') return 'root';
    if (path.startsWith('/')) path = path.substring(1);
    final segments = path.split('/');
    return segments.isNotEmpty && segments[0].isNotEmpty
        ? segments[0]
        : 'unknown';
  }
}
