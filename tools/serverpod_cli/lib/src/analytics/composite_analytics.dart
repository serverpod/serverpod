import 'dart:async';
import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/src/analytics/posthog_analytics.dart';

/// Composite analytics that sends events to multiple analytics providers.
class CompositeAnalytics implements Analytics {
  final List<Analytics> _providers;
  PostHogAnalytics? _postHog;
  MixPanelAnalytics? _mixPanel;

  CompositeAnalytics(this._providers) {
    for (final provider in _providers) {
      if (provider is PostHogAnalytics) {
        _postHog = provider;
      }
      if (provider is MixPanelAnalytics) {
        _mixPanel = provider;
      }
    }
  }

  @override
  void track({required String event}) {
    for (final provider in _providers) {
      provider.track(event: event);
    }
  }

  /// Tracks an event with custom properties (for PostHog)
  void trackWithProperties({
    required String event,
    Map<String, dynamic> properties = const {},
  }) {
    // PostHog supports properties
    if (_postHog != null) {
      _postHog!.trackWithProperties(event: event, properties: properties);
    }
    // MixPanel tracks the event (properties are not directly supported in the same way)
    if (_mixPanel != null) {
      _mixPanel!.track(event: event);
    }
  }

  @override
  void cleanUp() {
    for (final provider in _providers) {
      provider.cleanUp();
    }
  }

  /// Waits for pending requests from PostHog (if present)
  Future<void> waitForPendingRequests() async {
    if (_postHog != null) {
      await _postHog!.waitForPendingRequests();
    }
  }
}
