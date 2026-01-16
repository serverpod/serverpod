/// OpenMetrics Gauge metric implementation.
library;

import 'label_validator.dart';
import 'metric.dart';

/// A Gauge is a metric that represents a single numerical value that can
/// arbitrarily go up and down.
///
/// Use gauges for metrics like:
/// - Current memory usage
/// - Number of items in a queue
/// - Number of requests in progress
/// - Temperature readings
///
/// Example:
/// ```dart
/// final inProgressGauge = Gauge(
///   name: 'http_requests_in_progress',
///   help: 'Number of HTTP requests currently being processed',
/// );
/// inProgressGauge.inc(); // Increment by 1
/// inProgressGauge.dec(); // Decrement by 1
/// inProgressGauge.set(42); // Set to specific value
/// ```
class Gauge implements Metric {
  @override
  final String name;

  @override
  final String help;

  @override
  MetricType get type => MetricType.gauge;

  double _value = 0;

  /// Creates a gauge with the given [name] and [help] description.
  Gauge({
    required this.name,
    required this.help,
  }) {
    LabelValidator.validateMetricName(name);
  }

  /// Increment the gauge by [amount] (default 1).
  ///
  /// Throws [ArgumentError] if [amount] is NaN or infinite.
  void inc([final double amount = 1]) {
    if (!amount.isFinite) {
      throw ArgumentError('Gauge cannot be incremented by NaN or infinity');
    }
    _value += amount;
  }

  /// Decrement the gauge by [amount] (default 1).
  ///
  /// Throws [ArgumentError] if [amount] is NaN or infinite.
  void dec([final double amount = 1]) {
    if (!amount.isFinite) {
      throw ArgumentError('Gauge cannot be decremented by NaN or infinity');
    }
    _value -= amount;
  }

  /// Set the gauge to a specific [value].
  ///
  /// Throws [ArgumentError] if [value] is NaN or infinite.
  void set(final double value) {
    if (!value.isFinite) {
      throw ArgumentError('Gauge cannot be set to NaN or infinity');
    }
    _value = value;
  }

  /// Set the gauge to the current Unix timestamp in seconds.
  void setToCurrentTime() {
    _value = DateTime.now().millisecondsSinceEpoch / 1000;
  }

  /// Get the current value of the gauge.
  double get value => _value;

  @override
  List<MetricSample> collect() {
    return [
      MetricSample(
        name: name,
        labels: {},
        value: _value,
      ),
    ];
  }
}

/// Wrapper class to store a child gauge with its label map.
class _LabeledChild {
  final Gauge gauge;
  final Map<String, String> labels;

  _LabeledChild(this.gauge, this.labels);
}

/// A Gauge with labels support.
///
/// Example:
/// ```dart
/// final inProgressGauge = LabeledGauge(
///   name: 'http_requests_in_progress',
///   help: 'Number of HTTP requests currently being processed',
///   labelNames: ['method', 'path'],
/// );
/// inProgressGauge.labels(['GET', '/api/users']).inc();
/// inProgressGauge.labels(['GET', '/api/users']).dec();
/// ```
class LabeledGauge extends LabeledMetric<Gauge> {
  @override
  final String name;

  @override
  final String help;

  @override
  final List<String> labelNames;

  @override
  MetricType get type => MetricType.gauge;

  final Map<String, _LabeledChild> _children = {};

  /// Maximum number of unique label combinations allowed.
  /// This prevents unbounded memory growth from high-cardinality labels.
  final int maxCardinality;

  /// Creates a labeled gauge with the given [name], [help], and [labelNames].
  LabeledGauge({
    required this.name,
    required this.help,
    required final List<String> labelNames,
    this.maxCardinality = 1000,
  }) : labelNames = List<String>.unmodifiable(List.of(labelNames)) {
    if (maxCardinality < 1) {
      throw ArgumentError.value(
        maxCardinality,
        'maxCardinality',
        'Must be at least 1',
      );
    }
    LabelValidator.validateMetricName(name);
    for (final labelName in this.labelNames) {
      LabelValidator.validateLabelName(labelName);
    }
  }

  /// Get or create a gauge with the specified label values.
  @override
  Gauge labels(final List<String> labelValues) {
    LabelValidator.validateLabelValues(labelNames, labelValues);

    final key = _labelKey(labelValues);

    // Fast path: Check if child already exists (no contention)
    final existing = _children[key];
    if (existing != null) {
      return existing.gauge;
    }

    // Slow path: Need to create new child
    // Check cardinality BEFORE modification to prevent TOCTOU race
    if (_children.length >= maxCardinality) {
      throw StateError(
        'Maximum cardinality ($maxCardinality) reached for metric "$name". '
        'This may indicate a label with unbounded values.',
      );
    }

    final labelMap = Map<String, String>.unmodifiable(
      Map.fromIterables(labelNames, labelValues),
    );

    // putIfAbsent provides atomicity for map insertion
    // In edge cases, this might create one extra child beyond maxCardinality
    // (if another request creates the same key between our check and insert),
    // but this is acceptable and bounded.
    return _children.putIfAbsent(key, () {
      return _LabeledChild(
        Gauge(name: name, help: help),
        labelMap,
      );
    }).gauge;
  }

  /// Remove a child gauge with the specified label values.
  @override
  void remove(final List<String> labelValues) {
    LabelValidator.validateLabelValues(labelNames, labelValues);
    _children.remove(_labelKey(labelValues));
  }

  /// Clear all child gauges.
  @override
  void clear() {
    _children.clear();
  }

  /// Create a collision-free key for a set of label values.
  ///
  /// Uses length-prefixed encoding to avoid collisions from arbitrary user strings.
  /// For example, ['ab', 'c'] becomes '2:ab1:c' and ['a', 'bc'] becomes '1:a2:bc'.
  String _labelKey(final List<String> labelValues) {
    final buffer = StringBuffer();
    for (final value in labelValues) {
      buffer.write('${value.length}:$value');
    }
    return buffer.toString();
  }

  @override
  List<MetricSample> collect() {
    final samples = <MetricSample>[];

    for (final child in _children.values) {
      samples.add(
        MetricSample(
          name: name,
          labels: child.labels,
          value: child.gauge.value,
        ),
      );
    }

    return samples;
  }
}
