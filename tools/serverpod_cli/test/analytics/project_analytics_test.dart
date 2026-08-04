import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/analytics/project_metadata.dart';
import 'package:serverpod_cli/src/analytics/project_metadata_store.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/ide.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
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
    'Given a full-stack project with optional services and IDEs configured, '
    'when capturing analytics for its creation, '
    'then its template and options are reported.',
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
          ides: TemplateIde.values,
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
      expect(
        properties['ides'],
        TemplateIde.values.map((ide) => ide.name).toList()..sort(),
      );
      expect(properties[r'$groups'], isNotNull);
    },
  );

  test(
    'Given a server-only project without a database, '
    'when capturing analytics for its creation, '
    'then the absence of a Flutter app and database is reported.',
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
    'Given a server project with SQLite configured, '
    'when capturing analytics for its creation, '
    'then the SQLite dialect is reported.',
    () async {
      await d.dir('sqlite', [
        d.dir('myapp_server', [d.file('pubspec.yaml', 'name: myapp_server')]),
      ]).create();

      await cliAnalytics.captureProjectCreated(
        serverDir: p.join(d.sandbox, 'sqlite', 'myapp_server'),
        method: 'create',
        template: ServerpodTemplateType.server,
        context: TemplateContext(
          template: ServerpodTemplateType.server,
          sqlite: true,
        ),
        force: false,
      );

      final properties = recording.properties.single;
      expect(properties['template'], 'server');
      expect(properties['with_database'], isTrue);
      expect(properties['database_dialect'], 'sqlite');
    },
  );

  test(
    'Given a module project, '
    'when capturing analytics for its creation, '
    'then the module template is reported.',
    () async {
      await d.dir('module', [
        d.dir('myapp_server', [d.file('pubspec.yaml', 'name: myapp_server')]),
      ]).create();

      await cliAnalytics.captureProjectCreated(
        serverDir: p.join(d.sandbox, 'module', 'myapp_server'),
        method: 'create',
        template: ServerpodTemplateType.module,
        context: TemplateContext(template: ServerpodTemplateType.module),
        force: false,
      );

      final properties = recording.properties.single;
      expect(properties['template'], 'module');
      expect(properties['with_database'], isFalse);
    },
  );

  test(
    'Given a year-old project upgraded with a default migration, '
    'when capturing analytics for its upgrade, '
    'then the upgrade and original project age are reported.',
    () async {
      await d.dir('upgraded', [
        d.dir('myapp_server', [d.file('pubspec.yaml', 'name: myapp_server')]),
      ]).create();

      final serverDir = p.join(d.sandbox, 'upgraded', 'myapp_server');
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
    'Given analytics are disabled, '
    'when capturing analytics for project creation, '
    'then no event is reported.',
    () async {
      initializeCliAnalytics(CliAnalytics(analytics: recording));

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
}
