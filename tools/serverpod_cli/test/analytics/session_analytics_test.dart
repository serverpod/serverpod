import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/analytics/project_metadata_store.dart';
import 'package:serverpod_cli/src/analytics/session_metrics.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../test_util/analytics_helpers.dart';

void main() {
  late RecordingAnalytics recording;

  setUp(() async {
    recording = RecordingAnalytics();
    initializeCliAnalytics(
      CliAnalytics(analytics: recording)..enabled = true,
    );
    await d.dir('.git', [d.file('config', '')]).create();
  });

  tearDown(() => initializeCliAnalytics(CliAnalytics.disabled()));

  test(
    'Given a start without an explicit --docker flag, '
    'when capturing analytics for start, '
    'then the auto Docker mode is reported.',
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
    'Given a session that starts with companion Flutter apps configured, '
    'when capturing analytics for start, '
    'then their count and device targets are reported.',
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
    'Given tracked CLI commands, '
    'when capturing analytics for start, '
    'then their invocation counts are reported.',
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
    'Given a companion Flutter app targeting macOS, '
    'when capturing analytics for its launch, '
    'then its device category and platform are reported.',
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

  test(
    'Given analytics are enabled and the project metadata is corrupt, '
    'when capturing analytics for start, '
    'then the metadata is recovered and the event is reported.',
    () async {
      await d.dir('corrupt_session', [
        d.dir('myapp_server', [
          d.file('pubspec.yaml', 'name: myapp_server'),
        ]),
      ]).create();

      final serverDir = p.join(
        d.sandbox,
        'corrupt_session',
        'myapp_server',
      );
      final metadataFile = File(
        ProjectMetadataStore.metadataFilePath(serverDir),
      );
      await metadataFile.parent.create(recursive: true);
      await metadataFile.writeAsString('not json');

      await cliAnalytics.captureSessionStart(
        config: buildAnalyticsTestConfig(serverDir),
        watchMode: true,
        tuiEnabled: false,
        flutterEnabled: false,
        dockerMode: DockerStartMode.off,
        dockerComposePresent: false,
      );

      expect(recording.events, ['cli.session_start']);
      expect(
        (await ProjectMetadataStore.loadOrCreate(serverDir)).checkoutId,
        isNotEmpty,
      );
    },
  );

  test(
    'Given analytics are disabled and the project metadata is corrupt, '
    'when capturing analytics for start, '
    'then the metadata is not read and no event is reported.',
    () async {
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
