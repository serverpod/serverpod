import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/analytics/generate_tracker.dart';
import 'package:serverpod_cli/src/analytics/protocol_feature_analyzer.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../test_util/analytics_helpers.dart';

const _snapshot = ProtocolAnalyticsSnapshot(
  features: ['postgres', 'table_model'],
  featureCounts: {'table_model': 3},
  serverpodModules: [],
  counts: {'model_count': 3},
);

void main() {
  late GenerateTracker tracker;
  late RecordingAnalytics recording;
  late String serverDir;

  setUp(() async {
    tracker = GenerateTracker(debounceDuration: Duration.zero);
    recording = RecordingAnalytics();
    initializeCliAnalytics(
      CliAnalytics(analytics: recording)..enabled = true,
    );

    // Anchor git-dir resolution inside the sandbox so metadata never escapes
    // to an ambient repo (e.g. a stray /tmp/.git).
    await d.dir('.git', [d.file('config', '')]).create();
    await d.dir('tracker_project', [
      d.dir('myapp_server', [d.file('pubspec.yaml', 'name: myapp_server')]),
    ]).create();

    serverDir = p.join(d.sandbox, 'tracker_project', 'myapp_server');
  });

  tearDown(() => initializeCliAnalytics(CliAnalytics.disabled()));

  test(
    'Given two incremental generation runs in the same burst, '
    'when the debounce period ends, '
    'then one event reports their run count and mean duration.',
    () async {
      final config = buildAnalyticsTestConfig(serverDir);

      tracker.recordIncrementalRun(
        config: config,
        success: true,
        duration: const Duration(milliseconds: 100),
        snapshot: _snapshot,
      );
      tracker.recordIncrementalRun(
        config: config,
        success: true,
        duration: const Duration(milliseconds: 300),
        snapshot: _snapshot,
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(recording.events, ['cli.generate']);

      final properties = recording.properties.single;
      expect(properties['is_watch_mode'], isTrue);
      expect(properties['incremental_run_count'], 2);
      expect(properties['incremental_avg_duration_ms'], 200);
      expect(
        properties.containsKey('oneshot_duration_ms'),
        isFalse,
        reason: 'One-shot and watch timings must stay mutually exclusive.',
      );
    },
  );

  test(
    'Given a flushed generation burst followed by a new run, '
    'when the second debounce period ends, '
    'then the second event reports only the new run.',
    () async {
      final config = buildAnalyticsTestConfig(serverDir);

      tracker.recordIncrementalRun(
        config: config,
        success: true,
        duration: const Duration(milliseconds: 100),
        snapshot: _snapshot,
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      tracker.recordIncrementalRun(
        config: config,
        success: false,
        duration: const Duration(milliseconds: 400),
        snapshot: _snapshot,
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(recording.events, ['cli.generate', 'cli.generate']);
      expect(recording.properties.last['incremental_run_count'], 1);
      expect(recording.properties.last['incremental_avg_duration_ms'], 400);
      expect(recording.properties.last['generation_succeeded'], isFalse);
      expect(
        recording.properties.last['num_generate_calls'],
        2,
        reason: 'The metadata counter increments once per emitted event.',
      );
    },
  );
}
