import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';

import 'cli_analytics.dart';
import 'protocol_feature_analyzer.dart';

/// Debounces watch-mode generate analytics bursts per server directory.
class GenerateTracker {
  GenerateTracker({
    this.debounceDuration = const Duration(seconds: 30),
  });

  final Duration debounceDuration;
  final _trackers = <String, _PendingGenerateBurst>{};

  void recordIncrementalRun({
    required GeneratorConfig config,
    required bool success,
    required Duration duration,
    ProtocolDefinition? protocolDefinition,
    required bool enabled,
    Set<String>? serverPubspecDependencies,
  }) {
    if (!enabled) return;

    try {
      final snapshot = protocolDefinition == null
          ? null
          : ProtocolFeatureAnalyzer.analyze(
              protocolDefinition: protocolDefinition,
              config: config,
              serverPubspecDependencies: serverPubspecDependencies,
            );

      final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
      final tracker = _trackers.putIfAbsent(
        serverDir,
        _PendingGenerateBurst.new,
      );
      tracker.pendingSuccess = success;
      tracker.totalDurationMs += duration.inMilliseconds;
      tracker.runCount += 1;
      if (snapshot != null) {
        tracker.latestSnapshot = snapshot;
      }

      tracker.debounceTimer?.cancel();
      tracker.debounceTimer = Timer(debounceDuration, () {
        unawaited(
          _flush(
            serverDir: serverDir,
            config: config,
            tracker: tracker,
            enabled: enabled,
          ),
        );
      });
    } catch (_) {
      // Analytics must never disrupt watch-mode generation.
    }
  }

  Future<void> _flush({
    required String serverDir,
    required GeneratorConfig config,
    required _PendingGenerateBurst tracker,
    required bool enabled,
  }) async {
    if (tracker.runCount == 0 || tracker.latestSnapshot == null) return;

    final averageDurationMs = tracker.totalDurationMs ~/ tracker.runCount;
    await cliAnalytics.captureGenerate(
      serverDir: serverDir,
      config: config,
      snapshot: tracker.latestSnapshot!,
      success: tracker.pendingSuccess,
      isWatchMode: true,
      incrementalRunCount: tracker.runCount,
      incrementalAvgDurationMs: averageDurationMs,
      enabled: enabled,
    );

    tracker
      ..runCount = 0
      ..totalDurationMs = 0
      ..debounceTimer = null;
  }
}

class _PendingGenerateBurst {
  int runCount = 0;
  int totalDurationMs = 0;
  bool pendingSuccess = true;
  ProtocolAnalyticsSnapshot? latestSnapshot;
  Timer? debounceTimer;
}

final generateTracker = GenerateTracker();
