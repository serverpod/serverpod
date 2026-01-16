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
  /// Converts the metric type to its OpenMetrics format string.
  String toOpenMetricsString() => name;
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
  MetricSample({
    required this.name,
    required final Map<String, String> labels,
    required this.value,
    this.timestampMs,
  }) : labels = Map<String, String>.unmodifiable(labels);

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
