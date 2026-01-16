/// OpenMetrics Counter metric implementation.
library;

import 'label_validator.dart';
import 'metric.dart';

/// A Counter is a cumulative metric that represents a single monotonically
/// increasing value. Counters can only go up (or be reset to zero on restart).
///
/// Use counters for metrics like:
/// - Number of requests served
/// - Tasks completed
/// - Errors occurred
///
/// Example:
/// ```dart
/// final requestsCounter = Counter(
///   name: 'http_requests_total',
///   help: 'Total number of HTTP requests',
/// );
/// requestsCounter.inc(); // Increment by 1
/// requestsCounter.inc(5); // Increment by 5
/// ```
class Counter implements Metric {
  @override
  final String name;

  @override
  final String help;

  @override
  MetricType get type => MetricType.counter;

  double _value = 0;

  /// Creates a counter with the given [name] and [help] description.
  Counter({
    required this.name,
    required this.help,
  }) {
    LabelValidator.validateMetricName(name);
  }

  /// Increment the counter by [amount] (default 1).
  ///
  /// Throws [ArgumentError] if [amount] is negative, NaN, or infinite.
  void inc([final double amount = 1]) {
    if (amount < 0) {
      throw ArgumentError(
        'Counter can only be incremented by non-negative amounts',
      );
    }
    if (!amount.isFinite) {
      throw ArgumentError('Counter cannot be incremented by NaN or infinity');
    }
    _value += amount;
  }

  /// Get the current value of the counter.
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

/// Wrapper class to store a child counter with its label map.
class _LabeledChild {
  final Counter counter;
  final Map<String, String> labels;

  _LabeledChild(this.counter, this.labels);
}

/// A Counter with labels support.
///
/// Example:
/// ```dart
/// final requestsCounter = LabeledCounter(
///   name: 'http_requests_total',
///   help: 'Total number of HTTP requests',
///   labelNames: ['method', 'status'],
/// );
/// requestsCounter.labels(['GET', '200']).inc();
/// requestsCounter.labels(['POST', '201']).inc(2);
/// ```
class LabeledCounter extends LabeledMetric<Counter> {
  @override
  final String name;

  @override
  final String help;

  @override
  final List<String> labelNames;

  @override
  MetricType get type => MetricType.counter;

  final Map<String, _LabeledChild> _children = {};

  /// Maximum number of unique label combinations allowed.
  /// This prevents unbounded memory growth from high-cardinality labels.
  final int maxCardinality;

  /// Creates a labeled counter with the given [name], [help], and [labelNames].
  LabeledCounter({
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

  /// Get or create a counter with the specified label values.
  @override
  Counter labels(final List<String> labelValues) {
    LabelValidator.validateLabelValues(labelNames, labelValues);

    final key = _labelKey(labelValues);

    // Fast path: Check if child already exists (no contention)
    final existing = _children[key];
    if (existing != null) {
      return existing.counter;
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
        Counter(name: name, help: help),
        labelMap,
      );
    }).counter;
  }

  /// Remove a child counter with the specified label values.
  @override
  void remove(final List<String> labelValues) {
    LabelValidator.validateLabelValues(labelNames, labelValues);
    _children.remove(_labelKey(labelValues));
  }

  /// Clear all child counters.
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
          value: child.counter.value,
        ),
      );
    }

    return samples;
  }
}
