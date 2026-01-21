import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/src/analytics/posthog_analytics.dart';
import 'package:serverpod_cli/src/analytics/composite_analytics.dart';

/// Helper extension for tracking analytics events with properties.
/// 
/// This extension provides a unified interface for tracking events regardless
/// of whether the analytics instance is PostHogAnalytics or CompositeAnalytics.
extension AnalyticsHelper on Analytics {
  /// Tracks an event with custom properties.
  /// 
  /// Works with both PostHogAnalytics and CompositeAnalytics.
  /// If the analytics instance doesn't support properties, it falls back
  /// to tracking the event without properties.
  void trackWithProperties({
    required String event,
    Map<String, dynamic> properties = const {},
  }) {
    if (this is PostHogAnalytics) {
      (this as PostHogAnalytics).trackWithProperties(
        event: event,
        properties: properties,
      );
    } else if (this is CompositeAnalytics) {
      (this as CompositeAnalytics).trackWithProperties(
        event: event,
        properties: properties,
      );
    } else {
      // Fallback for other analytics implementations
      track(event: event);
    }
  }
}
