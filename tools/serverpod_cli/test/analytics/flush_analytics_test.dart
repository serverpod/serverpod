import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/analytics/flush_analytics.dart';
import 'package:serverpod_cli/src/analytics/generate_tracker.dart';
import 'package:serverpod_cli/src/analytics/protocol_feature_analyzer.dart';
import 'package:serverpod_cli/src/analytics/session_metrics.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../test_util/analytics_helpers.dart';

void main() {
  tearDown(() => initializeCliAnalytics(CliAnalytics.disabled()));

  test(
    'Given a session event still preparing project metadata, '
    'when analytics is flushed immediately, '
    'then its event is delivered before the flush completes.',
    () async {
      await d.dir('.git', [d.file('config', '')]).create();
      await d.dir('myapp_server', [
        d.file('pubspec.yaml', 'name: myapp_server'),
      ]).create();
      final recording = RecordingAnalytics();
      initializeCliAnalytics(
        CliAnalytics(analytics: recording)..enabled = true,
      );
      unawaited(
        cliAnalytics.captureSessionStart(
          config: buildAnalyticsTestConfig(p.join(d.sandbox, 'myapp_server')),
          watchMode: true,
          tuiEnabled: true,
          flutterEnabled: false,
          dockerMode: DockerStartMode.off,
          dockerComposePresent: false,
        ),
      );

      await flushAnalytics();

      expect(recording.events, ['cli.session_start']);
    },
  );

  test(
    'Given a rich event with a pending network send, '
    'when analytics is flushed, '
    'then the flush waits for delivery.',
    () async {
      final release = Completer<void>();
      final analytics = _DelayedAnalytics(release.future);
      final cli = CliAnalytics(analytics: analytics);
      analytics.track(event: 'cli.session_start');

      var flushed = false;
      final flushing = cli.flush().then((_) => flushed = true);
      await Future<void>.delayed(Duration.zero);
      final completedBeforeDelivery = flushed;
      release.complete();
      await flushing;

      expect(completedBeforeDelivery, isFalse);
      expect(analytics.delivered, ['cli.session_start']);
    },
  );

  test(
    'Given command events sent through an additional provider, '
    'when analytics is flushed, '
    'then the flush waits for that provider too.',
    () async {
      final release = Completer<void>();
      final commandProvider = _DelayedAnalytics(release.future);
      final richProvider = RecordingAnalytics();
      final commands = CompoundAnalytics([richProvider, commandProvider]);
      final cli = CliAnalytics(
        analytics: richProvider,
        commandAnalytics: commands,
      );
      commands.track(event: 'start');

      var flushed = false;
      final flushing = cli.flush().then((_) => flushed = true);
      await Future<void>.delayed(Duration.zero);
      final completedBeforeDelivery = flushed;
      release.complete();
      await flushing;

      expect(completedBeforeDelivery, isFalse);
      expect(commandProvider.delivered, ['start']);
    },
  );

  test(
    'Given a pending watch-mode generation burst, '
    'when analytics is flushed twice during shutdown, '
    'then the final burst is delivered exactly once.',
    () async {
      await d.dir('.git', [d.file('config', '')]).create();
      await d.dir('myapp_server', [
        d.file('pubspec.yaml', 'name: myapp_server'),
      ]).create();
      final recording = RecordingAnalytics();
      initializeCliAnalytics(
        CliAnalytics(analytics: recording)..enabled = true,
      );
      generateTracker.recordIncrementalRun(
        config: buildAnalyticsTestConfig(p.join(d.sandbox, 'myapp_server')),
        success: true,
        duration: const Duration(milliseconds: 100),
        snapshot: const ProtocolAnalyticsSnapshot(
          features: ['postgres'],
          featureCounts: {},
          serverpodModules: [],
          counts: {},
        ),
      );

      await flushAnalytics();
      await flushAnalytics();

      expect(recording.events, ['cli.generate']);
      expect(recording.properties.single['incremental_run_count'], 1);
    },
  );

  test(
    'Given an event capture was requested with analytics disabled, '
    'when shutdown flushes analytics, '
    'then no event or project metadata is created.',
    () async {
      final recording = RecordingAnalytics();
      initializeCliAnalytics(CliAnalytics(analytics: recording));
      final serverDir = p.join(d.sandbox, 'disabled_server');
      await cliAnalytics.capture(
        event: 'cli.session_start',
        serverDir: serverDir,
        properties: {},
      );

      await flushAnalytics();

      expect(recording.events, isEmpty);
      expect(Directory(serverDir).existsSync(), isFalse);
    },
  );

  test(
    'Given an analytics network request fails, '
    'when shutdown flushes analytics, '
    'then the failure does not prevent shutdown.',
    () async {
      final release = Completer<void>();
      final analytics = _DelayedAnalytics(release.future);
      final cli = CliAnalytics(analytics: analytics);
      analytics.track(event: 'start');
      release.completeError(StateError('network unavailable'));

      await expectLater(cli.flush(), completes);
    },
  );
}

class _DelayedAnalytics extends Analytics {
  _DelayedAnalytics(this.delivery);

  final Future<void> delivery;
  final delivered = <String>[];

  @override
  Future<void> sendEvent({
    required String event,
    Map<String, dynamic> properties = const {},
  }) async {
    await delivery;
    delivered.add(event);
  }
}
