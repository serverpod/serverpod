import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/analytics/project_metadata.dart';
import 'package:serverpod_cli/src/analytics/project_metadata_store.dart';
import 'package:serverpod_cli/src/analytics/session_metrics.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/ide.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../test_util/analytics_helpers.dart';

GeneratorConfig buildTestConfig(String serverDir) {
  return GeneratorConfig(
    name: 'myapp',
    type: PackageType.server,
    serverPackage: 'myapp_server',
    dartClientPackage: 'myapp_client',
    dartClientDependsOnServiceClient: true,
    serverPackageDirectoryPathParts: p.split(serverDir),
    sharedModelsSourcePathsParts: const {},
    relativeDartClientPackagePathParts: const ['..', 'myapp_client'],
    modules: const [],
    extraClasses: const [],
    enabledFeatures: const [ServerpodFeature.database],
    databaseDialect: DatabaseDialect.postgres,
  );
}

void main() {
  late RecordingAnalytics recording;

  setUp(() {
    recording = RecordingAnalytics();
    initializeCliAnalytics(CliAnalytics(analytics: recording)..enabled = true);
  });

  tearDown(() => initializeCliAnalytics(CliAnalytics.disabled()));

  group('Given an enabled CliAnalytics, ', () {
    setUp(() async {
      // Anchor git-dir resolution inside the sandbox so metadata never escapes
      // to an ambient repo (e.g. a stray /tmp/.git).
      await d.dir('.git', [d.file('config', '')]).create();
    });

    test(
      'when a fullstack project is created, '
      'then cli.project_created reports the template and its options.',
      () async {
        await d.dir('project', [
          d.dir('myapp_server', [
            d.file('pubspec.yaml', 'name: myapp_server'),
          ]),
        ]).create();

        await cliAnalytics.captureProjectCreated(
          serverDir: p.join(d.sandbox, 'project', 'myapp_server'),
          method: 'create',
          template: ServerpodTemplateType.fullstack,
          context: TemplateContext(
            template: ServerpodTemplateType.fullstack,
            auth: true,
            redis: true,
            postgres: true,
            webapp: true,
            ides: const [TemplateIde.claude, TemplateIde.vscode],
          ),
          force: false,
        );

        expect(recording.events, ['cli.project_created']);

        final properties = recording.properties.single;
        expect(properties['template'], 'fullstack');
        expect(properties['with_flutter'], isTrue);
        expect(properties['with_auth'], isTrue);
        expect(properties['with_redis'], isTrue);
        expect(properties['with_webapp'], isTrue);
        expect(properties['with_website'], isFalse);
        expect(properties['database_dialect'], 'postgres');
        expect(properties['ides'], ['claude', 'vscode']);
        expect(properties[r'$groups'], isNotNull);
      },
    );

    test(
      'when a server-only project without a database is created, '
      'then cli.project_created reports no Flutter app and no dialect.',
      () async {
        await d.dir('server_only', [
          d.dir('myapp_server', [d.file('pubspec.yaml', 'name: myapp_server')]),
        ]).create();

        await cliAnalytics.captureProjectCreated(
          serverDir: p.join(d.sandbox, 'server_only', 'myapp_server'),
          method: 'quickstart',
          template: ServerpodTemplateType.server,
          context: TemplateContext(template: ServerpodTemplateType.server),
          force: true,
        );

        final properties = recording.properties.single;
        expect(properties['method'], 'quickstart');
        expect(properties['template'], 'server');
        expect(properties['with_flutter'], isFalse);
        expect(properties['with_database'], isFalse);
        expect(properties['database_dialect'], 'none');
        expect(properties['force'], isTrue);
      },
    );

    test(
      'when a session starts without an explicit --docker flag, '
      'then cli.session_start reports the auto docker mode.',
      () async {
        await d.dir('session', [
          d.dir('myapp_server', [d.file('pubspec.yaml', 'name: myapp_server')]),
        ]).create();

        final serverDir = p.join(d.sandbox, 'session', 'myapp_server');

        await cliAnalytics.captureSessionStart(
          config: buildTestConfig(serverDir),
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
          config: buildTestConfig(serverDir),
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
        // Not a command-shaped name; must never reach the payload.
        await cliAnalytics.recordCommandInvocation(
          serverDir: serverDir,
          commandName: '/Users/someone/secret project',
        );

        await cliAnalytics.captureSessionStart(
          config: buildTestConfig(serverDir),
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
      'when an existing project is upgraded with create ., '
      'then cli.project_upgraded is sent without resetting the project age.',
      () async {
        await d.dir('upgraded', [
          d.dir('myapp_server', [d.file('pubspec.yaml', 'name: myapp_server')]),
        ]).create();

        final serverDir = p.join(d.sandbox, 'upgraded', 'myapp_server');

        // Age the project by writing the metadata a year back.
        final store = await ProjectMetadataStore.loadOrCreate(serverDir);
        await ProjectMetadataStore.save(
          serverDir,
          ProjectMetadata(
            checkoutId: store.checkoutId,
            projectCreatedAt: DateTime.now().toUtc().subtract(
              const Duration(days: 365),
            ),
          ),
        );

        await cliAnalytics.captureProjectUpgraded(
          serverDir: serverDir,
          template: ServerpodTemplateType.fullstack,
          context: TemplateContext(
            template: ServerpodTemplateType.fullstack,
            postgres: true,
          ),
          createdDefaultMigration: true,
        );

        final properties = recording.eventNamed('cli.project_upgraded');
        expect(properties['template'], 'fullstack');
        expect(properties['created_default_migration'], isTrue);
        expect(
          properties['project_age_days'],
          greaterThanOrEqualTo(364),
          reason: 'An upgrade must not restamp project_created_at.',
        );

        final after = await ProjectMetadataStore.loadOrCreate(serverDir);
        expect(
          ProjectMetadataStore.projectAgeDays(after),
          greaterThanOrEqualTo(364),
        );
      },
    );

    test(
      'when a companion Flutter app is launched, '
      'then cli.flutter_launch reports its category and platform.',
      () async {
        await d.dir('launched', [
          d.dir('myapp_server', [d.file('pubspec.yaml', 'name: myapp_server')]),
        ]).create();

        final serverDir = p.join(d.sandbox, 'launched', 'myapp_server');

        await cliAnalytics.captureFlutterLaunch(
          serverDir: serverDir,
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

  group('Given a disabled CliAnalytics, ', () {
    setUp(() {
      cliAnalytics.enabled = false;
    });

    test(
      'when project-created analytics is captured, '
      'then nothing is sent.',
      () async {
        await cliAnalytics.captureProjectCreated(
          serverDir: 'missing/server',
          method: 'create',
          template: ServerpodTemplateType.server,
          context: TemplateContext(),
          force: false,
        );

        expect(recording.events, isEmpty);
      },
    );

    test(
      'when session-start analytics is captured over corrupt metadata, '
      'then metadata is not read and nothing is sent.',
      () async {
        await d.dir('disabled_session', [
          d.dir('myapp_server', [
            d.file('pubspec.yaml', 'name: myapp_server'),
            d.dir('.dart_tool', [
              d.dir('serverpod', [d.file('metadata.json', 'not json')]),
            ]),
          ]),
        ]).create();

        await cliAnalytics.captureSessionStart(
          config: buildTestConfig(
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
  });
}
