import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/config/config.dart';

import 'cli_analytics.dart';
import 'generate_tracker.dart';
import 'protocol_feature_analyzer.dart';

/// Records one completed code generation run.
///
/// One-shot runs report immediately with their full wall time. Watch-mode runs
/// are handed to [generateTracker], which coalesces a burst of saves into a
/// single event.
///
/// [protocolAnalyticsSnapshot] is `null` for models-only incremental runs,
/// which carry no protocol snapshot to report.
Future<void> reportGenerateAnalytics({
  required GeneratorConfig config,
  required bool success,
  required Duration duration,
  required bool incremental,
  required ProtocolAnalyticsSnapshot? protocolAnalyticsSnapshot,
}) async {
  if (!cliAnalytics.enabled) return;
  if (protocolAnalyticsSnapshot == null) return;

  try {
    if (incremental) {
      generateTracker.recordIncrementalRun(
        config: config,
        success: success,
        duration: duration,
        snapshot: protocolAnalyticsSnapshot,
      );
      return;
    }

    await cliAnalytics.captureGenerate(
      serverDir: p.joinAll(config.serverPackageDirectoryPathParts),
      snapshot: protocolAnalyticsSnapshot,
      success: success,
      isWatchMode: false,
      oneshotDurationMs: duration.inMilliseconds,
    );
  } catch (_) {
    // Analytics must never disrupt generation.
  }
}
