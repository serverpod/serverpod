/// Central registry for OpenMetrics metrics.
library;

import 'counter.dart';
import 'gauge.dart';
import 'histogram.dart';
import 'metric.dart';

/// A registry that manages a collection of OpenMetrics metrics.
///
/// The registry ensures metric name uniqueness and provides methods
/// to create and register metrics of different types.
///
/// Example:
/// ```dart
/// final registry = MetricRegistry();
///
/// final requestCounter = registry.counter(
///   'http_requests_total',
///   help: 'Total HTTP requests',
/// );
///
/// final requestDuration = registry.histogram(
///   'http_request_duration_seconds',
///   help: 'HTTP request duration in seconds',
/// );
///
/// // Collect all metrics
/// final allSamples = registry.collectAll();
/// ```
class MetricRegistry {
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

  /// Create and register a simple counter.
  ///
  /// Throws [ArgumentError] if a metric with the same name already exists.
  Counter counter(final String name, {required final String help}) {
    final counter = Counter(name: name, help: help);
    register(counter);
    return counter;
  }

  /// Create and register a labeled counter.
  ///
  /// Throws [ArgumentError] if a metric with the same name already exists.
  LabeledCounter labeledCounter(
    final String name, {
    required final String help,
    required final List<String> labelNames,
    final int maxCardinality = 1000,
  }) {
    final counter = LabeledCounter(
      name: name,
      help: help,
      labelNames: labelNames,
      maxCardinality: maxCardinality,
    );
    register(counter);
    return counter;
  }

  /// Create and register a simple gauge.
  ///
  /// Throws [ArgumentError] if a metric with the same name already exists.
  Gauge gauge(final String name, {required final String help}) {
    final gauge = Gauge(name: name, help: help);
    register(gauge);
    return gauge;
  }

  /// Create and register a labeled gauge.
  ///
  /// Throws [ArgumentError] if a metric with the same name already exists.
  LabeledGauge labeledGauge(
    final String name, {
    required final String help,
    required final List<String> labelNames,
    final int maxCardinality = 1000,
  }) {
    final gauge = LabeledGauge(
      name: name,
      help: help,
      labelNames: labelNames,
      maxCardinality: maxCardinality,
    );
    register(gauge);
    return gauge;
  }

  /// Create and register a simple histogram.
  ///
  /// Throws [ArgumentError] if a metric with the same name already exists.
  Histogram histogram(
    final String name, {
    required final String help,
    final List<double>? buckets,
  }) {
    final histogram = Histogram(
      name: name,
      help: help,
      buckets: buckets,
    );
    register(histogram);
    return histogram;
  }

  /// Create and register a labeled histogram.
  ///
  /// Throws [ArgumentError] if a metric with the same name already exists.
  LabeledHistogram labeledHistogram(
    final String name, {
    required final String help,
    required final List<String> labelNames,
    final List<double>? buckets,
    final int maxCardinality = 1000,
  }) {
    final histogram = LabeledHistogram(
      name: name,
      help: help,
      labelNames: labelNames,
      buckets: buckets,
      maxCardinality: maxCardinality,
    );
    register(histogram);
    return histogram;
  }

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
