import 'dart:async';

import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/analytics/flush_analytics.dart';
import 'package:serverpod_cli/src/analytics/generate_tracker.dart';
import 'package:serverpod_cli/src/analytics/protocol_feature_analyzer.dart';
import 'package:serverpod_cli/src/analytics/session_metrics.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

import 'analytics_helpers.dart';

void main(List<String> args) {
  final posthog = PostHogAnalytics(
    uniqueUserId: 'test-user',
    projectApiKey: 'test-key',
    version: 'test-version',
    host: args[0],
  );
  final commands = CompoundAnalytics([posthog]);
  initializeCliAnalytics(
    CliAnalytics(analytics: posthog, commandAnalytics: commands)
      ..enabled = true,
  );
  final config = buildAnalyticsTestConfig(args[1]);
  commands.track(event: 'start');
  unawaited(
    cliAnalytics.captureSessionStart(
      config: config,
      watchMode: true,
      tuiEnabled: true,
      flutterEnabled: false,
      dockerMode: DockerStartMode.off,
      dockerComposePresent: false,
    ),
  );
  generateTracker.recordIncrementalRun(
    config: config,
    success: true,
    duration: const Duration(milliseconds: 100),
    snapshot: const ProtocolAnalyticsSnapshot(
      features: ['postgres'],
      featureCounts: {},
      serverpodModules: [],
      counts: {},
    ),
  );

  ServerpodTerminalBackend(
    preExit: (_) => flushAnalytics(),
  ).requestExit(int.parse(args[2]));
}
