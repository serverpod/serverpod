import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/migrations/create_migration_action.dart';
import 'package:test/test.dart';

import '../../test_util/analytics_helpers.dart';
import '../../test_util/builders/generator_config_builder.dart';

/// Drives the real `createMigrationAction` and asserts on the payload it
/// produced. The hook lives inside the action rather than in the command, so
/// this also covers the start TUI's Migrate button and the `create_migration`
/// MCP tool, which call the same function.
void main() {
  const projectName = 'example_project';

  late Directory root;
  late Directory serverDirectory;
  late RecordingAnalytics recording;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('migration_analytics_');
    serverDirectory = Directory(path.join(root.path, '${projectName}_server'))
      ..createSync(recursive: true);

    // The metadata file is resolved from the git common dir; anchoring a `.git`
    // inside the sandbox keeps it from escaping to an ambient repo.
    Directory(path.join(root.path, '.git')).createSync(recursive: true);
    File(path.join(root.path, '.git', 'config')).writeAsStringSync('');

    File(path.join(serverDirectory.path, 'pubspec.yaml')).writeAsStringSync('''
name: ${projectName}_server
''');

    recording = RecordingAnalytics();
    initializeCliAnalytics(CliAnalytics(analytics: recording)..enabled = true);
  });

  tearDown(() {
    initializeCliAnalytics(CliAnalytics.disabled());
    if (root.existsSync()) root.deleteSync(recursive: true);
  });

  void writeServerModel(String name) {
    File(
        path.join(serverDirectory.path, 'lib', 'src', 'models', '$name.yaml'),
      )
      ..createSync(recursive: true)
      ..writeAsStringSync('''
class: ${name[0].toUpperCase()}${name.substring(1)}
table: $name
fields:
  name: String
''');
  }

  void writeHostClientModel(String name) {
    File(
        path.join(serverDirectory.path, 'lib', 'src', 'models', '$name.yaml'),
      )
      ..createSync(recursive: true)
      ..writeAsStringSync('''
class: ${name[0].toUpperCase()}${name.substring(1)}
table: $name
database: all
fields:
  name: String
''');
  }

  GeneratorConfig buildConfig() => GeneratorConfigBuilder()
      .withName(projectName)
      .withServerPackageDirectoryPathParts(path.split(serverDirectory.path))
      .withModules([])
      .build();

  test(
    'Given a project with a server-only table, '
    'when a migration is created, '
    'then cli.migration_created reports the server side only.',
    () async {
      writeServerModel('example');

      final outcome = await createMigrationAction(config: buildConfig());
      expect(outcome, isA<CreateMigrationCreated>());

      final event = recording.eventNamed('cli.migration_created');
      expect(event['server_migration_created'], isTrue);
      expect(event['client_migration_created'], isFalse);
      expect(event['server_migration_count'], 1);
      expect(event['client_migration_count'], 0);
      expect(event['is_repair_migration'], isFalse);
      expect(
        event.containsKey('average_interval_days'),
        isFalse,
        reason: 'A single migration has no interval to average.',
      );
    },
  );

  test(
    'Given a project with a host client table, '
    'when a migration is created, '
    'then cli.migration_created reports both sides.',
    () async {
      writeHostClientModel('example');

      final outcome = await createMigrationAction(config: buildConfig());
      expect(outcome, isA<CreateMigrationServerClientCreated>());

      final event = recording.eventNamed('cli.migration_created');
      expect(event['server_migration_created'], isTrue);
      expect(event['client_migration_created'], isTrue);
      expect(event['server_migration_count'], 1);
      expect(event['client_migration_count'], 1);
    },
  );

  test(
    'Given a project with an existing migration, '
    'when nothing changed, '
    'then no event is sent.',
    () async {
      writeServerModel('example');
      final config = buildConfig();

      await createMigrationAction(config: config);
      recording.clear();

      final outcome = await createMigrationAction(config: config);

      expect(outcome, isA<CreateMigrationNoChanges>());
      expect(
        recording.events,
        isEmpty,
        reason: 'Nothing was written, so nothing is reported.',
      );
    },
  );

  test(
    'Given a second migration, '
    'when it is created, '
    'then the running server count is reported.',
    () async {
      writeServerModel('example');
      final config = buildConfig();

      await createMigrationAction(config: config);
      writeServerModel('second');
      recording.clear();

      await createMigrationAction(config: config);

      final event = recording.eventNamed('cli.migration_created');
      expect(event['server_migration_count'], 2);
    },
  );

  test(
    'Given analytics is disabled, '
    'when a migration is created, '
    'then nothing is sent.',
    () async {
      cliAnalytics.enabled = false;
      writeServerModel('example');

      final outcome = await createMigrationAction(config: buildConfig());

      expect(outcome, isA<CreateMigrationCreated>());
      expect(recording.events, isEmpty);
    },
  );

  test(
    'Given a created migration, '
    'when the payload is inspected, '
    'then it carries no migration name, table name or path.',
    () async {
      writeServerModel('example');

      await createMigrationAction(config: buildConfig());

      final serialized = recording
          .eventNamed('cli.migration_created')
          .toString();

      for (final secret in [root.path, 'example_project', 'Example']) {
        expect(
          serialized,
          isNot(contains(secret)),
          reason: '"$secret" must never leave the machine.',
        );
      }
    },
  );
}
