/// OpenMetrics Histogram metric implementation.
library;

import 'label_validator.dart';
import 'metric.dart';

/// A Histogram samples observations (usually things like request durations or
/// response sizes) and counts them in configurable buckets. It also provides
/// a sum of all observed values and a count of observations.
///
/// Use histograms for metrics like:
/// - Request duration
/// - Response size
/// - Database query execution time
///
/// Example:
/// ```dart
/// final durationHistogram = Histogram(
///   name: 'http_request_duration_seconds',
///   help: 'HTTP request duration in seconds',
///   buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10],
/// );
/// durationHistogram.observe(0.123); // Observe a value
/// ```
class Histogram implements Metric {
  @override
  final String name;

  @override
  final String help;

  @override
  MetricType get type => MetricType.histogram;

  /// The upper bounds of the buckets.
  /// Must be sorted in ascending order.
  final List<double> buckets;

  /// Count of observations in each bucket.
  late final List<int> _bucketCounts;

  /// Sum of all observed values.
  double _sum = 0;

  /// Total count of observations.
  int _count = 0;

  /// Default bucket boundaries suitable for typical web application latencies
  /// (in seconds).
  static const List<double> defaultBuckets = [
    0.005, // 5ms
    0.01, // 10ms
    0.025, // 25ms
    0.05, // 50ms
    0.1, // 100ms
    0.25, // 250ms
    0.5, // 500ms
    1.0, // 1s
    2.5, // 2.5s
    5.0, // 5s
    10.0, // 10s
  ];

  /// Creates a histogram with the given [name], [help], and optional [buckets].
  Histogram({
    required this.name,
    required this.help,
    final List<double>? buckets,
  }) : buckets = List<double>.unmodifiable(
         List.of(buckets ?? defaultBuckets),
       ) {
    LabelValidator.validateMetricName(name);
    _validateBuckets(this.buckets);
    _bucketCounts = List.filled(this.buckets.length, 0);
  }

  /// Validate that buckets are sorted in ascending order.
  static void _validateBuckets(final List<double> buckets) {
    if (buckets.isEmpty) {
      throw ArgumentError('Histogram must have at least one bucket');
    }

    for (var i = 1; i < buckets.length; i++) {
      if (buckets[i] <= buckets[i - 1]) {
        throw ArgumentError(
          'Histogram buckets must be sorted in ascending order',
        );
      }
    }
  }

  /// Observe a value and update the appropriate buckets.
  ///
  /// Throws [ArgumentError] if [value] is NaN or infinite.
  void observe(final double value) {
    if (!value.isFinite) {
      throw ArgumentError('Histogram cannot observe NaN or infinity');
    }

    _sum += value;
    _count++;

    // Binary search to find the first bucket that can hold this value
    // Buckets are sorted, so we can use binary search for O(log n) lookup
    var left = 0;
    var right = buckets.length - 1;
    var bucketIndex = buckets.length; // Default: beyond all buckets

    while (left <= right) {
      final mid = left + ((right - left) >> 1);
      if (value <= buckets[mid]) {
        bucketIndex = mid;
        right = mid - 1;
      } else {
        left = mid + 1;
      }
    }

    // Increment only the matching bucket (non-cumulative count)
    if (bucketIndex < buckets.length) {
      _bucketCounts[bucketIndex]++;
    }
  }

  /// Get the sum of all observed values.
  double get sum => _sum;

  /// Get the total count of observations.
  int get count => _count;

  @override
  List<MetricSample> collect() {
    final samples = <MetricSample>[];

    // Build cumulative counts from non-cumulative bucket counts
    var cumulativeCount = 0;
    for (var i = 0; i < buckets.length; i++) {
      cumulativeCount += _bucketCounts[i];
      samples.add(
        MetricSample(
          name: '${name}_bucket',
          labels: {'le': buckets[i].toString()},
          value: cumulativeCount.toDouble(),
        ),
      );
    }

    // Emit +Inf bucket (total count)
    samples.add(
      MetricSample(
        name: '${name}_bucket',
        labels: {'le': '+Inf'},
        value: _count.toDouble(),
      ),
    );

    // Emit sum
    samples.add(
      MetricSample(
        name: '${name}_sum',
        labels: {},
        value: _sum,
      ),
    );

    // Emit count
    samples.add(
      MetricSample(
        name: '${name}_count',
        labels: {},
        value: _count.toDouble(),
      ),
    );

    return samples;
  }
}

/// Wrapper class to store a child histogram with its label map.
class _LabeledChild {
  final Histogram histogram;
  final Map<String, String> labels;

  _LabeledChild(this.histogram, this.labels);
}

/// A Histogram with labels support.
///
/// Example:
/// ```dart
/// final durationHistogram = LabeledHistogram(
///   name: 'http_request_duration_seconds',
///   help: 'HTTP request duration in seconds',
///   labelNames: ['method', 'status'],
/// );
/// durationHistogram.labels(['GET', '200']).observe(0.123);
/// ```
class LabeledHistogram extends LabeledMetric<Histogram> {
  @override
  final String name;

  @override
  final String help;

  @override
  final List<String> labelNames;

  @override
  MetricType get type => MetricType.histogram;

  /// The bucket boundaries for this histogram.
  final List<double> buckets;

  final Map<String, _LabeledChild> _children = {};

  /// Maximum number of unique label combinations allowed.
  /// This prevents unbounded memory growth from high-cardinality labels.
  final int maxCardinality;

  /// Creates a labeled histogram with the given [name], [help], [labelNames], and optional [buckets].
  LabeledHistogram({
    required this.name,
    required this.help,
    required final List<String> labelNames,
    final List<double>? buckets,
    this.maxCardinality = 1000,
  }) : labelNames = List<String>.unmodifiable(List.of(labelNames)),
       buckets = List<double>.unmodifiable(
         List.of(buckets ?? Histogram.defaultBuckets),
       ) {
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
    Histogram._validateBuckets(this.buckets);
  }

  /// Get or create a histogram with the specified label values.
  @override
  Histogram labels(final List<String> labelValues) {
    LabelValidator.validateLabelValues(labelNames, labelValues);

    final key = _labelKey(labelValues);

    // Fast path: Check if child already exists (no contention)
    final existing = _children[key];
    if (existing != null) {
      return existing.histogram;
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
        Histogram(name: name, help: help, buckets: buckets),
        labelMap,
      );
    }).histogram;
  }

  /// Remove a child histogram with the specified label values.
  @override
  void remove(final List<String> labelValues) {
    LabelValidator.validateLabelValues(labelNames, labelValues);
    _children.remove(_labelKey(labelValues));
  }

  /// Clear all child histograms.
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
      final baseLabels = child.labels;
      final histogram = child.histogram;

      // Build cumulative counts from non-cumulative bucket counts
      var cumulativeCount = 0;
      for (var i = 0; i < histogram.buckets.length; i++) {
        cumulativeCount += histogram._bucketCounts[i];
        samples.add(
          MetricSample(
            name: '${name}_bucket',
            labels: Map.unmodifiable({
              ...baseLabels,
              'le': histogram.buckets[i].toString(),
            }),
            value: cumulativeCount.toDouble(),
          ),
        );
      }

      // Emit +Inf bucket (total count)
      samples.add(
        MetricSample(
          name: '${name}_bucket',
          labels: Map.unmodifiable({...baseLabels, 'le': '+Inf'}),
          value: histogram.count.toDouble(),
        ),
      );

      // Emit sum
      samples.add(
        MetricSample(
          name: '${name}_sum',
          labels: baseLabels,
          value: histogram.sum,
        ),
      );

      // Emit count
      samples.add(
        MetricSample(
          name: '${name}_count',
          labels: baseLabels,
          value: histogram.count.toDouble(),
        ),
      );
    }

    return samples;
  }
}
