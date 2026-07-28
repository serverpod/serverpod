import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';

import 'cli_analytics.dart';
import 'generate_tracker.dart';
import 'protocol_feature_analyzer.dart';

/// Records one completed code generation run.
///
/// One-shot runs report immediately with their full wall time. Watch-mode runs
/// are handed to [generateTracker], which coalesces a burst of saves into a
/// single event.
///
/// [protocolDefinition] is `null` for models-only incremental runs, which carry
/// no protocol snapshot to report.
Future<void> reportGenerateAnalytics({
  required GeneratorConfig config,
  required bool success,
  required Duration duration,
  required bool incremental,
  ProtocolDefinition? protocolDefinition,
}) async {
  if (!cliAnalytics.enabled) return;
  if (protocolDefinition == null) return;

  try {
    final snapshot = ProtocolFeatureAnalyzer.analyze(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    if (incremental) {
      generateTracker.recordIncrementalRun(
        config: config,
        success: success,
        duration: duration,
        snapshot: snapshot,
      );
      return;
    }

    await cliAnalytics.captureGenerate(
      serverDir: p.joinAll(config.serverPackageDirectoryPathParts),
      snapshot: snapshot,
      success: success,
      isWatchMode: false,
      oneshotDurationMs: duration.inMilliseconds,
    );
  } catch (_) {
    // Analytics must never disrupt generation.
  }
}
