import 'cli_analytics.dart';
import 'generate_tracker.dart';

/// Drains debounced and pending CLI analytics before shutdown.
Future<void> flushAnalytics() async {
  // Debounced watch-mode runs must be captured before draining event sends.
  await generateTracker.flushPending();
  await cliAnalytics.flush();
}
