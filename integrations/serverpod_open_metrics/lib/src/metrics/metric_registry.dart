/// Central registry for OpenMetrics metrics.
library;

import 'metric.dart';

/// A registry that manages a collection of OpenMetrics metrics.
///
/// The registry ensures metric name uniqueness and provides methods
/// to register and retrieve metrics.
///
/// Example:
/// ```dart
/// final registry = MetricRegistry();
///
/// final requestCounter = Counter(
///   name: 'http_requests_total',
///   help: 'Total HTTP requests',
/// );
/// registry.register(requestCounter);
///
/// final requestDuration = Histogram(
///   name: 'http_request_duration_seconds',
///   help: 'HTTP request duration in seconds',
/// );
/// registry.register(requestDuration);
///
/// // Collect all metrics
/// final allSamples = registry.collectAll();
/// ```
class MetricRegistry {
  static MetricRegistry? _instance;

  /// Returns the singleton instance of [MetricRegistry].
  ///
  /// Throws [StateError] if not initialized via [set].
  static MetricRegistry get instance {
    final localInstance = _instance;
    if (localInstance == null) {
      throw StateError(
        'MetricRegistry is not set. Call MetricRegistry.set() to initialize it before accessing the instance.',
      );
    }

    return localInstance;
  }

  /// Creates a new [MetricRegistry] instance and sets it as the global
  /// singleton, or uses the provided [registry].
  static void set({final MetricRegistry? registry}) {
    _instance = registry ?? MetricRegistry();
  }

  final Map<String, Metric> _metrics = {};

  /// Register a metric in the registry.
  ///
  /// Throws [ArgumentError] if a metric with the same name is already registered.
  void register(final Metric metric) {
    if (_metrics.containsKey(metric.name)) {
      throw ArgumentError(
        'Metric with name "${metric.name}" is already registered',
      );
    }
    _metrics[metric.name] = metric;
  }

  /// Unregister a metric by name.
  ///
  /// Returns true if a metric was removed, false if no metric with that name exists.
  bool unregister(final String name) {
    return _metrics.remove(name) != null;
  }

  /// Clear all registered metrics.
  void clear() {
    _metrics.clear();
  }

  /// Get a registered metric by name.
  ///
  /// Returns null if no metric with that name is registered.
  Metric? getMetric(final String name) {
    return _metrics[name];
  }

  /// Get all registered metrics.
  List<Metric> get metrics => List.unmodifiable(_metrics.values);

  /// Collect samples from all registered metrics.
  ///
  /// Returns a list of all samples from all metrics in the registry.
  List<MetricSample> collectAll() {
    final allSamples = <MetricSample>[];
    for (final metric in _metrics.values) {
      allSamples.addAll(metric.collect());
    }
    return allSamples;
  }
}
