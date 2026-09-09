import 'cli_analytics.dart';
import 'generate_tracker.dart';

/// Drains analytics before either a TUI exit or the CLI entry point exits.
Future<void> flushAnalytics() async {
  // Debounced watch-mode runs must be captured before draining event sends.
  await generateTracker.flushPending();
  await cliAnalytics.flush();
}
