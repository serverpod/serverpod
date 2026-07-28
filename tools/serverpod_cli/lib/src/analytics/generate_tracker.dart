import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';

import 'cli_analytics.dart';
import 'protocol_feature_analyzer.dart';

/// Debounces watch-mode generate analytics bursts per server directory.
///
/// A save storm produces one `cli.generate` event carrying the run count and
/// the mean per-run duration, instead of one event per keystroke-triggered run.
class GenerateTracker {
  GenerateTracker({this.debounceDuration = const Duration(seconds: 30)});

  final Duration debounceDuration;
  final _bursts = <String, _PendingGenerateBurst>{};

  void recordIncrementalRun({
    required GeneratorConfig config,
    required bool success,
    required Duration duration,
    required ProtocolAnalyticsSnapshot snapshot,
  }) {
    try {
      final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
      final burst = _bursts.putIfAbsent(serverDir, _PendingGenerateBurst.new);
      burst
        ..latestSuccess = success
        ..totalDurationMs += duration.inMilliseconds
        ..runCount += 1
        ..latestSnapshot = snapshot;

      burst.debounceTimer?.cancel();
      burst.debounceTimer = Timer(
        debounceDuration,
        () => unawaited(_flush(serverDir: serverDir, burst: burst)),
      );
    } catch (_) {
      // Analytics must never disrupt watch-mode generation.
    }
  }

  /// Emits any burst still waiting on its debounce timer.
  ///
  /// Called on CLI exit: a watch session is usually ended mid-burst, so without
  /// this the last — and typically longest — run of every session is lost.
  Future<void> flushPending() async {
    try {
      final pending = _bursts.entries.toList();
      for (final entry in pending) {
        entry.value.debounceTimer?.cancel();
        await _flush(serverDir: entry.key, burst: entry.value);
      }
    } catch (_) {
      // Runs on the CLI exit path; it must never change the exit code.
    }
  }

  Future<void> _flush({
    required String serverDir,
    required _PendingGenerateBurst burst,
  }) async {
    final snapshot = burst.latestSnapshot;
    final runCount = burst.runCount;
    final totalDurationMs = burst.totalDurationMs;
    final success = burst.latestSuccess;

    // Reset before awaiting so runs arriving during the send start a new burst
    // instead of being double counted.
    burst
      ..runCount = 0
      ..totalDurationMs = 0
      ..latestSnapshot = null
      ..debounceTimer = null;

    if (runCount == 0 || snapshot == null) return;

    await cliAnalytics.captureGenerate(
      serverDir: serverDir,
      snapshot: snapshot,
      success: success,
      isWatchMode: true,
      incrementalRunCount: runCount,
      incrementalAvgDurationMs: totalDurationMs ~/ runCount,
    );
  }
}

class _PendingGenerateBurst {
  int runCount = 0;
  int totalDurationMs = 0;
  bool latestSuccess = true;
  ProtocolAnalyticsSnapshot? latestSnapshot;
  Timer? debounceTimer;
}

final generateTracker = GenerateTracker();
