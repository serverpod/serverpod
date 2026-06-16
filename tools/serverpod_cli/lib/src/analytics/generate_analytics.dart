import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';

import 'cli_analytics.dart';
import 'generate_tracker.dart';
import 'protocol_feature_analyzer.dart';

enum GenerateAnalyticsTiming {
  none,
  oneshot,
  watchIncremental,
}

Future<void> reportGenerateAnalytics({
  required GeneratorConfig config,
  required bool success,
  required Duration duration,
  required GenerateAnalyticsTiming timing,
  required bool enabled,
  ProtocolDefinition? protocolDefinition,
}) async {
  if (!enabled || timing == GenerateAnalyticsTiming.none) return;

  try {
    if (protocolDefinition == null) return;

    final dependencies = await readServerPubspecDependencies(config);

    switch (timing) {
      case GenerateAnalyticsTiming.none:
        return;
      case GenerateAnalyticsTiming.oneshot:
        final snapshot = ProtocolFeatureAnalyzer.analyze(
          protocolDefinition: protocolDefinition,
          config: config,
          serverPubspecDependencies: dependencies,
        );
        await cliAnalytics.captureGenerate(
          serverDir: p.joinAll(config.serverPackageDirectoryPathParts),
          config: config,
          snapshot: snapshot,
          success: success,
          isWatchMode: false,
          enabled: enabled,
          oneshotDurationMs: duration.inMilliseconds,
        );
      case GenerateAnalyticsTiming.watchIncremental:
        generateTracker.recordIncrementalRun(
          config: config,
          success: success,
          duration: duration,
          protocolDefinition: protocolDefinition,
          enabled: enabled,
          serverPubspecDependencies: dependencies,
        );
    }
  } catch (_) {
    // Analytics must never disrupt generation.
  }
}
