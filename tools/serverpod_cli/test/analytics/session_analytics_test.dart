import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/analytics/session_metrics.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../test_util/analytics_helpers.dart';

void main() {
  late RecordingAnalytics recording;

  tearDown(() => initializeCliAnalytics(CliAnalytics.disabled()));

  group('Given an enabled CliAnalytics, ', () {
    setUp(() async {
      recording = RecordingAnalytics();
      initializeCliAnalytics(
        CliAnalytics(analytics: recording)..enabled = true,
      );
      await d.dir('.git', [d.file('config', '')]).create();
    });

    test(
      'when a session starts without an explicit --docker flag, '
      'then cli.session_start reports the auto docker mode.',
      () async {
        await d.dir('session', [
          d.dir('myapp_server', [d.file('pubspec.yaml', 'name: myapp_server')]),
        ]).create();

        final serverDir = p.join(d.sandbox, 'session', 'myapp_server');

        await cliAnalytics.captureSessionStart(
          config: buildAnalyticsTestConfig(serverDir),
          watchMode: true,
          tuiEnabled: true,
          flutterEnabled: false,
          dockerMode: DockerStartMode.auto,
          dockerComposePresent: true,
        );

        expect(recording.events, ['cli.session_start']);

        final properties = recording.properties.single;
        expect(properties['docker_mode'], 'auto');
        expect(properties['docker_compose_present'], isTrue);
        expect(properties['watch_mode'], isTrue);
        expect(properties['flutter_app_count'], 0);
        expect(properties['flutter_device_categories'], isEmpty);
        expect(properties['flutter_device_platforms'], isEmpty);
        expect(properties['num_tool_calls'], 0);
      },
    );

    test(
      'when a session starts with companion Flutter apps configured, '
      'then cli.session_start reports their count and device buckets.',
      () async {
        await d.dir('flutter_session', [
          d.dir('myapp_server', [
            d.file('pubspec.yaml', '''
name: myapp_server
serverpod:
  flutter_apps:
    admin:
      path: ../myapp_admin
      auto_launch: true
      device: chrome
    phone:
      path: ../myapp_phone
      device: ios-simulator
'''),
          ]),
          d.dir('myapp_admin', [d.file('pubspec.yaml', 'name: myapp_admin')]),
          d.dir('myapp_phone', [d.file('pubspec.yaml', 'name: myapp_phone')]),
        ]).create();

        final serverDir = p.join(d.sandbox, 'flutter_session', 'myapp_server');

        await cliAnalytics.captureSessionStart(
          config: buildAnalyticsTestConfig(serverDir),
          watchMode: true,
          tuiEnabled: true,
          flutterEnabled: true,
          dockerMode: DockerStartMode.on,
          dockerComposePresent: false,
        );

        final properties = recording.eventNamed('cli.session_start');
        expect(properties['flutter_app_count'], 2);
        expect(properties['flutter_auto_launch_count'], 1);
        expect(properties['flutter_device_categories'], ['mobile', 'web']);
        expect(
          properties['flutter_device_platforms'],
          ['chrome', 'ios'],
          reason: 'The platform split is what shows which targets are used.',
        );
        expect(properties['docker_mode'], 'on');
      },
    );

    test(
      'when a tracked command runs, '
      'then its count is reported on the next session start.',
      () async {
        await d.dir('counted', [
          d.dir('myapp_server', [d.file('pubspec.yaml', 'name: myapp_server')]),
        ]).create();

        final serverDir = p.join(d.sandbox, 'counted', 'myapp_server');

        await cliAnalytics.recordCommandInvocation(
          serverDir: serverDir,
          commandName: 'generate',
        );
        await cliAnalytics.recordCommandInvocation(
          serverDir: serverDir,
          commandName: 'generate',
        );
        await cliAnalytics.recordCommandInvocation(
          serverDir: serverDir,
          commandName: 'database',
        );
        await cliAnalytics.recordCommandInvocation(
          serverDir: serverDir,
          commandName: '/Users/someone/secret project',
        );

        await cliAnalytics.captureSessionStart(
          config: buildAnalyticsTestConfig(serverDir),
          watchMode: true,
          tuiEnabled: true,
          flutterEnabled: false,
          dockerMode: DockerStartMode.off,
          dockerComposePresent: false,
        );

        final properties = recording.properties.single;
        expect(properties['command_invocations'], {
          'generate': 2,
          'database': 1,
        });
        expect(properties['num_tool_calls'], 3);
      },
    );

    test(
      'when a companion Flutter app is launched, '
      'then cli.flutter_launch reports its category and platform.',
      () async {
        await d.dir('launched', [
          d.dir('myapp_server', [d.file('pubspec.yaml', 'name: myapp_server')]),
        ]).create();

        await cliAnalytics.captureFlutterLaunch(
          serverDir: p.join(d.sandbox, 'launched', 'myapp_server'),
          device: 'macos',
          isRelaunch: false,
        );

        final properties = recording.eventNamed('cli.flutter_launch');
        expect(properties['device_category'], 'desktop');
        expect(properties['device_platform'], 'macos');
        expect(properties['is_relaunch'], isFalse);
      },
    );
  });

  test(
    'Given a disabled CliAnalytics and corrupt metadata, '
    'when session-start analytics is captured, '
    'then metadata is not read and nothing is sent.',
    () async {
      recording = RecordingAnalytics();
      initializeCliAnalytics(CliAnalytics(analytics: recording));
      await d.dir('disabled_session', [
        d.dir('myapp_server', [
          d.file('pubspec.yaml', 'name: myapp_server'),
          d.dir('.dart_tool', [
            d.dir('serverpod', [d.file('metadata.json', 'not json')]),
          ]),
        ]),
      ]).create();

      await cliAnalytics.captureSessionStart(
        config: buildAnalyticsTestConfig(
          p.join(d.sandbox, 'disabled_session', 'myapp_server'),
        ),
        watchMode: true,
        tuiEnabled: false,
        flutterEnabled: false,
        dockerMode: DockerStartMode.off,
        dockerComposePresent: false,
      );

      expect(recording.events, isEmpty);
    },
  );
}
