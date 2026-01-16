/// OpenMetrics text format exporter.
///
/// This module exports metrics in the OpenMetrics text exposition format:
/// https://openmetrics.io/
///
/// Also supports the Prometheus text format for backward compatibility:
/// https://prometheus.io/docs/instrumenting/exposition_formats/#text-based-format
library;

import '../metrics/metric.dart';
import '../metrics/metric_registry.dart';

/// The metrics format to use when exporting.
enum MetricsFormat {
  /// Prometheus text format 0.0.4
  prometheus,

  /// OpenMetrics text format 1.0.0
  openMetrics,
}

/// Exports metrics in OpenMetrics or Prometheus text format.
class OpenMetricsTextFormat {
  /// The content type for Prometheus text format 0.0.4.
  static const String prometheusContentType =
      'text/plain; version=0.0.4; charset=utf-8';

  /// The content type for OpenMetrics format 1.0.0.
  static const String openMetricsContentType =
      'application/openmetrics-text; version=1.0.0; charset=utf-8';

  /// Exports all metrics in the given [registry] as a text exposition string.
  ///
  /// The output [format] defaults to Prometheus 0.0.4 for backward
  /// compatibility.
  static String format(
    final MetricRegistry registry, {
    final MetricsFormat format = MetricsFormat.prometheus,
  }) {
    final buffer = StringBuffer();

    // Get all metric names (sorted)
    final allMetricNames = registry.metrics.map((final m) => m.name).toList()
      ..sort();

    // Export each metric family
    for (final metricName in allMetricNames) {
      final metric = registry.getMetric(metricName);
      if (metric == null) continue;

      // Write HELP line
      buffer.writeln('# HELP $metricName ${_escapeHelp(metric.help)}');

      // Write TYPE line
      buffer.writeln('# TYPE $metricName ${metric.type.toOpenMetricsString()}');

      // Collect and write samples for this specific metric
      final samples = metric.collect();
      for (final sample in samples) {
        _writeSample(buffer, sample);
      }
    }

    // Add EOF marker for OpenMetrics format
    if (format == MetricsFormat.openMetrics) {
      buffer.writeln('# EOF');
    }

    return buffer.toString();
  }

  /// Export metrics to OpenMetrics text format from a list of samples.
  ///
  /// This is useful when you have samples but no registry.
  /// Note: HELP and TYPE metadata won't be included without a registry.
  static String formatSamples(final List<MetricSample> samples) {
    final buffer = StringBuffer();
    for (final sample in samples) {
      _writeSample(buffer, sample);
    }
    return buffer.toString();
  }

  /// Write a single sample to the buffer.
  static void _writeSample(
    final StringBuffer buffer,
    final MetricSample sample,
  ) {
    buffer.write(sample.name);

    // Write labels
    if (sample.labels.isNotEmpty) {
      buffer.write('{');
      var first = true;
      for (final entry in sample.labels.entries) {
        if (!first) buffer.write(',');
        buffer.write('${entry.key}="${_escapeLabel(entry.value)}"');
        first = false;
      }
      buffer.write('}');
    }

    // Write value
    buffer.write(' ');
    buffer.write(_formatValue(sample.value));

    // Write timestamp if present
    if (sample.timestampMs != null) {
      buffer.write(' ${sample.timestampMs}');
    }

    buffer.writeln();
  }

  /// Format a metric value for OpenMetrics.
  ///
  /// Special cases:
  /// - Positive infinity → +Inf
  /// - Negative infinity → -Inf
  /// - NaN → NaN (this should never happen due to validation)
  static String _formatValue(final double value) {
    if (value.isInfinite) {
      return value.isNegative ? '-Inf' : '+Inf';
    }
    if (value.isNaN) {
      return 'NaN';
    }
    // Use toString() which handles proper decimal formatting
    return value.toString();
  }

  /// Escape special characters in help text.
  ///
  /// According to the spec:
  /// - Backslash and newline must be escaped
  static String _escapeHelp(final String text) {
    return text.replaceAll('\\', r'\\').replaceAll('\n', r'\n');
  }

  /// Escape special characters in label values.
  ///
  /// According to the spec:
  /// - Backslash, double-quote, and newline must be escaped
  static String _escapeLabel(final String text) {
    return text
        .replaceAll('\\', r'\\')
        .replaceAll('"', r'\"')
        .replaceAll('\n', r'\n');
  }

  /// Negotiate the metrics format based on the Accept header.
  ///
  /// Returns [MetricsFormat.openMetrics] if the Accept header indicates
  /// OpenMetrics support, otherwise returns [MetricsFormat.prometheus].
  ///
  /// OpenMetrics clients typically send:
  /// - `Accept: application/openmetrics-text`
  /// - `Accept: application/openmetrics-text; version=1.0.0`
  ///
  /// Prometheus clients typically send:
  /// - `Accept: text/plain`
  /// - No Accept header (defaults to Prometheus for backward compatibility)
  ///
  /// Examples:
  /// ```dart
  /// // From relic Request
  /// final format = OpenMetricsTextFormat.negotiateFormat(
  ///   request.headers.value('accept'),
  /// );
  /// ```
  static MetricsFormat negotiateFormat(final String? acceptHeader) {
    if (acceptHeader == null || acceptHeader.isEmpty) {
      // No Accept header - default to Prometheus for backward compatibility
      return MetricsFormat.prometheus;
    }

    // Parse Accept header (it may contain multiple media types with quality values)
    // Example: "application/openmetrics-text; version=1.0.0; charset=utf-8, text/plain; q=0.5"
    //
    // NOTE: Quality values (q=) are not currently parsed. This simple implementation
    // returns OpenMetrics format if it appears anywhere in the Accept header, regardless
    // of preference weights. This is acceptable for typical Prometheus/OpenMetrics client
    // behavior, as they generally send either "text/plain" or "application/openmetrics-text"
    // without mixing preferences.
    final mediaTypes = acceptHeader.toLowerCase().split(',');

    for (final mediaType in mediaTypes) {
      final trimmed = mediaType.trim();

      // Check if it's requesting OpenMetrics
      if (trimmed.startsWith('application/openmetrics-text')) {
        return MetricsFormat.openMetrics;
      }
    }

    // Default to Prometheus format
    return MetricsFormat.prometheus;
  }

  /// Get the appropriate content type for the given format.
  ///
  /// Returns the content-type header value for the specified format.
  static String getContentType(final MetricsFormat format) {
    switch (format) {
      case MetricsFormat.openMetrics:
        return openMetricsContentType;
      case MetricsFormat.prometheus:
        return prometheusContentType;
    }
  }
}
