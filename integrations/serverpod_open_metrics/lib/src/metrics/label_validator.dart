/// Internal validation helpers for metric and label names.
library;

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
