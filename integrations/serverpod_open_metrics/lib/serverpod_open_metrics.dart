/// OpenMetrics middleware and metrics collection for Serverpod.
///
/// This package provides OpenMetrics-compatible HTTP metrics collection
/// through middleware, including Counter, Gauge, and Histogram metric types.
///
/// ## Usage
///
/// ```dart
/// import 'package:serverpod/serverpod.dart';
/// import 'package:serverpod_open_metrics/serverpod_open_metrics.dart';
///
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
library;

// Metric types
export 'src/metrics/counter.dart';
export 'src/metrics/gauge.dart';
export 'src/metrics/histogram.dart';
export 'src/metrics/metric.dart';
export 'src/metrics/metric_registry.dart';
export 'src/metrics/serverpod_metric_registry_extension.dart';

// IP access control
export 'src/middleware/ip_access_control.dart';

// Middleware
export 'src/middleware/metrics_middleware.dart';

// Utilities
export 'src/util/path_normalizer.dart';
export 'src/util/text_format.dart';
