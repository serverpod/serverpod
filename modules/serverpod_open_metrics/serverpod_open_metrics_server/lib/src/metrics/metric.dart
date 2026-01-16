/// Base classes and interfaces for OpenMetrics metrics.
library;

/// Base interface for all OpenMetrics metrics.
abstract class Metric {
  /// The name of this metric.
  String get name;

  /// The help text describing what this metric measures.
  String get help;

  /// The type of this metric (counter, gauge, histogram, summary).
  MetricType get type;

  /// Collect all samples for this metric.
  /// Returns a list of metric samples with their labels and values.
  List<MetricSample> collect();
}

/// Types of OpenMetrics metrics.
enum MetricType {
  /// A counter that only increases.
  counter,

  /// A gauge that can go up or down.
  gauge,

  /// A histogram that tracks distributions of values.
  histogram,

  /// A summary that tracks distributions with quantiles.
  summary,
}

/// Extension to convert MetricType to string representation.
extension MetricTypeExtension on MetricType {
  /// Converts the metric type to OpenMetrics format string.
  String toOpenMetricsString() {
    switch (this) {
      case MetricType.counter:
        return 'counter';
      case MetricType.gauge:
        return 'gauge';
      case MetricType.histogram:
        return 'histogram';
      case MetricType.summary:
        return 'summary';
    }
  }
}

/// A single sample from a metric with labels and value.
class MetricSample {
  /// The metric name.
  final String name;

  /// Labels for this sample.
  final Map<String, String> labels;

  /// The numeric value of this sample.
  final double value;

  /// Optional timestamp (milliseconds since epoch).
  /// If null, Prometheus will use scrape time.
  final int? timestampMs;

  /// Creates a metric sample with the given [name], [labels], and [value].
  const MetricSample({
    required this.name,
    required this.labels,
    required this.value,
    this.timestampMs,
  });

  @override
  String toString() => 'MetricSample($name$labels: $value)';
}

/// Base class for labeled metrics that support multiple label combinations.
abstract class LabeledMetric<T> implements Metric {
  /// The label names for this metric.
  List<String> get labelNames;

  /// Get or create a child metric with the specified label values.
  ///
  /// Throws [ArgumentError] if the number of label values doesn't match
  /// the number of label names.
  T labels(final List<String> labelValues);

  /// Remove a child metric with the specified label values.
  void remove(final List<String> labelValues);

  /// Clear all child metrics.
  void clear();
}

/// Helper class to validate label names and values.
class LabelValidator {
  /// Validates a label name according to OpenMetrics requirements.
  ///
  /// Label names must match the regex `[a-zA-Z_][a-zA-Z0-9_]*`.
  /// Reserved prefixes like `__` are not allowed.
  static void validateLabelName(final String name) {
    if (name.isEmpty) {
      throw ArgumentError('Label name cannot be empty');
    }

    if (name.startsWith('__')) {
      throw ArgumentError(
        'Label name "$name" cannot start with "__" (reserved prefix)',
      );
    }

    final validPattern = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
    if (!validPattern.hasMatch(name)) {
      throw ArgumentError(
        'Label name "$name" must match pattern [a-zA-Z_][a-zA-Z0-9_]*',
      );
    }
  }

  /// Validates a metric name according to OpenMetrics requirements.
  ///
  /// Metric names must match the regex `[a-zA-Z_:][a-zA-Z0-9_:]*`.
  static void validateMetricName(final String name) {
    if (name.isEmpty) {
      throw ArgumentError('Metric name cannot be empty');
    }

    final validPattern = RegExp(r'^[a-zA-Z_:][a-zA-Z0-9_:]*$');
    if (!validPattern.hasMatch(name)) {
      throw ArgumentError(
        'Metric name "$name" must match pattern [a-zA-Z_:][a-zA-Z0-9_:]*',
      );
    }
  }

  /// Validates that label values count matches label names count.
  static void validateLabelValues(
    final List<String> labelNames,
    final List<String> labelValues,
  ) {
    if (labelNames.length != labelValues.length) {
      throw ArgumentError(
        'Label values count (${labelValues.length}) must match '
        'label names count (${labelNames.length})',
      );
    }
  }
}
