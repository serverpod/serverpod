import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

class RecordingAnalytics extends Analytics {
  final events = <String>[];
  final properties = <Map<String, dynamic>>[];

  @override
  void cleanUp() {}

  @override
  Future<void> sendEvent({
    required String event,
    Map<String, dynamic> properties = const {},
  }) async {
    events.add(event);
    this.properties.add(properties);
  }
}

GeneratorConfig _buildConfig(String serverDir) {
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
    relativeFlutterPackagePathParts: const ['..', 'myapp_flutter'],
  );
}

void main() {
  group('Given CliAnalytics, ', () {
    late RecordingAnalytics recording;

    setUp(() {
      recording = RecordingAnalytics();
      initializeCliAnalytics(CliAnalytics(analytics: recording));
    });

    test(
      'when project-created analytics is captured, '
      'then PostHog receives cli.project_created.',
      () async {
        // Anchor git-dir resolution inside the sandbox so metadata never
        // escapes to an ambient repo (e.g. a stray /tmp/.git).
        await d.dir('.git', [d.file('config', '')]).create();
        await d.dir('cli_analytics_project', [
          d.dir('myapp_server', [
            d.file('pubspec.yaml', 'name: myapp_server\n'),
          ]),
        ]).create();

        await cliAnalytics.captureProjectCreated(
          serverDir: p.join(
            d.sandbox,
            'cli_analytics_project',
            'myapp_server',
          ),
          method: 'create',
          template: ServerpodTemplateType.server,
          context: TemplateContext(
            template: ServerpodTemplateType.server,
            auth: true,
            redis: true,
            postgres: true,
          ),
          force: false,
          enabled: true,
        );

        expect(recording.events, ['cli.project_created']);
        expect(recording.properties.single['template'], 'server');
        expect(recording.properties.single[r'$groups'], isNotNull);
      },
    );

    test(
      'when project-created analytics is disabled, '
      'then nothing is sent.',
      () async {
        await cliAnalytics.captureProjectCreated(
          serverDir: 'missing/server',
          method: 'create',
          template: ServerpodTemplateType.server,
          context: TemplateContext(),
          force: false,
          enabled: false,
        );

        expect(recording.events, isEmpty);
      },
    );

    test(
      'when disabled session-start analytics has corrupt metadata, '
      'then metadata is not read and nothing is sent.',
      () async {
        await d.dir('cli_analytics_session_project', [
          d.dir('myapp_server', [
            d.file('pubspec.yaml', 'name: myapp_server\n'),
            d.dir('.dart_tool', [
              d.dir('serverpod', [
                d.file('metadata.json', 'not json'),
              ]),
            ]),
          ]),
        ]).create();

        final serverDir = p.join(
          d.sandbox,
          'cli_analytics_session_project',
          'myapp_server',
        );

        await cliAnalytics.captureSessionStart(
          config: _buildConfig(serverDir),
          watchMode: true,
          tuiEnabled: false,
          flutterEnabled: false,
          flutterDevice: 'chrome',
          dockerFlag: false,
          dockerComposePresent: false,
          enabled: false,
        );

        expect(recording.events, isEmpty);
      },
    );
  });
}
