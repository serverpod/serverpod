import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/migrations/migration_registry.dart';
import 'package:serverpod_cli/src/migrations/rebase_migration_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../integration/generator_config/database_feature_config_test.dart'
    hide MockLogger, MockLogOutput;
import '../test_util/mock_log.dart';

Future<Directory> setupMigrations(
  List<String> migrations, {
  String projectName = 'my_project',
}) async {
  // Create a mock serverpod project
  final projectDir = createMockServerpodProject(projectName: projectName);
  await projectDir.create();
  Directory.current = Directory(
    path.join(d.sandbox, 'project', '${projectName}_server'),
  );

  // Create migrations directory
  final migrationsDir = Directory(
    path.join(Directory.current.path, 'migrations', projectName),
  );
  await migrationsDir.create(recursive: true);

  // Create migrations
  for (var migration in migrations) {
    await Directory(path.join(migrationsDir.path, migration)).create();
  }

  // Create migration registry file
  await File(
    path.join(migrationsDir.path, 'migration_registry.txt'),
  ).writeAsString(migrations.map((m) => '$m\n').join());

  return migrationsDir;
}

void main() {
  late MockLogger testLogger;
  late Directory originalDir;
  const m1 = '20251228100000000';
  const m2 = '20251228100000001';
  const m3 = '20251228100000002';

  setUp(() async {
    testLogger = MockLogger();
    initializeLoggerWith(testLogger);
    originalDir = Directory.current;
  });

  tearDown(() {
    resetLogger();
    Directory.current = originalDir;
  });

  group('RebaseMigrationRunner', () {
    group('getMigrationTimestamp', () {
      test(
        'Given a migration ID with a tag when getting migration timestamp then the timestamp is correctly parsed',
        () {
          const runner = RebaseMigrationRunner();
          const migrationId = '$m1-tag';

          final timestamp = runner.getMigrationTimestamp(migrationId);

          expect(timestamp, equals(int.parse(m1)));
        },
      );

      test(
        'Given a malformed migration ID when getting migration timestamp then an ExitException is thrown',
        () {
          const runner = RebaseMigrationRunner();
          const migrationId = 'malformed';

          expect(
            () => runner.getMigrationTimestamp(migrationId),
            throwsA(isA<ExitException>()),
          );
        },
      );
    });

    test(
      'Given a migration that exists in registry when validating migration then the call succeeds',
      () {
        const runner = RebaseMigrationRunner();
        final migrationRegistry = MigrationRegistry(
          Directory('fake'),
          [m1, m2],
        );

        expect(
          () => runner.validateMigration(m1, migrationRegistry),
          returnsNormally,
        );
      },
    );

    test(
      'Given a migration that does not exist in registry when validating migration then an ExitException is thrown',
      () async {
        const runner = RebaseMigrationRunner();
        final migrationRegistry = MigrationRegistry(
          Directory('fake'),
          [m1, m2],
        );

        expect(
          () => runner.validateMigration(m3, migrationRegistry),
          throwsA(isA<ExitException>()),
        );
        expect(
          testLogger.output.messages,
          contains('ERROR: Migration $m3 does not exist.'),
        );
      },
    );

    group('getBaseMigrationId', () {
      test(
        'Given onto migration exists in registry when getting base migration ID then onto is returned',
        () async {
          const onto = m1;
          const migration2 = m2;
          const runner = RebaseMigrationRunner(onto: onto);
          final migrationsDir = await setupMigrations([onto, migration2]);

          final migrationRegistry = MigrationRegistry.load(migrationsDir);

          final result = runner.getBaseMigrationId(migrationRegistry);
          expect(result, equals(onto));
        },
      );

      test(
        'Given onto migration does not exist in registry when getting base migration ID then an ExitException is thrown',
        () async {
          const onto = m3;
          const migration1 = m1;
          const migration2 = m2;
          const runner = RebaseMigrationRunner(onto: onto);
          final migrationsDir = await setupMigrations([migration1, migration2]);

          final migrationRegistry = MigrationRegistry.load(migrationsDir);

          expect(
            () => runner.getBaseMigrationId(migrationRegistry),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.messages,
            contains('ERROR: Migration $onto does not exist.'),
          );
        },
      );

      test(
        'Given registry file does not exist when getting base migration ID then an ExitException is thrown',
        () async {
          const runner = RebaseMigrationRunner();
          final migrationsDir = Directory(path.join(d.sandbox, 'non_existent'));
          final migrationRegistry = MigrationRegistry(migrationsDir, []);

          expect(
            () => runner.getBaseMigrationId(migrationRegistry),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.messages,
            contains('ERROR: Migration registry file does not exist.'),
          );
        },
      );

      test(
        'Given no onto and registry has conflicts when getting base migration ID then incoming migration is returned',
        () async {
          const runner = RebaseMigrationRunner();
          final migrationsDir = await setupMigrations([m1, m2]);
          final registryFile = File(
            path.join(migrationsDir.path, 'migration_registry.txt'),
          );
          registryFile.writeAsStringSync('''
$m1
<<<<<<< HEAD
$m2
=======
$m3
>>>>>>> feature-branch
''');

          final migrationRegistry = MigrationRegistry.load(migrationsDir);

          final result = runner.getBaseMigrationId(migrationRegistry);
          expect(result, equals(m3));
        },
      );

      test(
        'Given no onto and registry has no conflicts when getting base migration ID then an ExitException is thrown',
        () async {
          const runner = RebaseMigrationRunner();
          final migrationsDir = await setupMigrations([m1, m2]);
          final migrationRegistry = MigrationRegistry.load(migrationsDir);

          expect(
            () => runner.getBaseMigrationId(migrationRegistry),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.messages,
            anyElement(
              contains(
                'ERROR: Migration registry file has no conflicts.',
              ),
            ),
          );
        },
      );
    });

    group('checkMigration', () {
      test(
        'Given exactly one migration after base migration when checking migration then true is returned',
        () async {
          const runner = RebaseMigrationRunner();
          const baseMigration = m1;
          const migration2 = m2;
          final migrationRegistry = MigrationRegistry(
            Directory('fake'),
            [baseMigration, migration2],
          );

          final result = await runner.checkMigration(
            migrationRegistry,
            baseMigration,
          );
          expect(result, isTrue);
          expect(
            testLogger.output.messages,
            contains(
              'INFO: There is only one migration after the base migration.',
            ),
          );
        },
      );

      test(
        'Given no migrations after base migration when checking migration then an ExitException is thrown',
        () async {
          const runner = RebaseMigrationRunner();
          const baseMigration = m1;
          final migrationRegistry = MigrationRegistry(
            Directory('fake'),
            [baseMigration],
          );

          expect(
            () => runner.checkMigration(migrationRegistry, baseMigration),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.messages,
            contains('ERROR: There is no migration after the base migration.'),
          );
        },
      );

      test(
        'Given more than one migration after base migration when checking migration then an ExitException is thrown',
        () async {
          const runner = RebaseMigrationRunner();
          const baseMigration = m1;
          const migration2 = m2;
          const migration3 = m3;
          final migrationRegistry = MigrationRegistry(
            Directory('fake'),
            [baseMigration, migration2, migration3],
          );

          expect(
            () => runner.checkMigration(migrationRegistry, baseMigration),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.messages,
            contains(
              'ERROR: There is more than one migration after the base migration.',
            ),
          );
        },
      );

      test(
        'Given migration with timestamp equal to base migration when checking migration then an ExitException is thrown',
        () async {
          const runner = RebaseMigrationRunner();
          const baseMigration = m1;
          const sameTimestamp = m1;
          final migrationRegistry = MigrationRegistry(
            Directory('fake'),
            [baseMigration, sameTimestamp],
          );

          expect(
            () => runner.checkMigration(migrationRegistry, baseMigration),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.messages,
            contains(
              'ERROR: Migration timestamp is not after the base migration timestamp.',
            ),
          );
        },
      );

      test(
        'Given migration with timestamp before base migration when checking migration then an ExitException is thrown',
        () async {
          const runner = RebaseMigrationRunner();
          const baseMigration = m2;
          const earlierTimestamp = m1; // m1 is before m2
          final migrationRegistry = MigrationRegistry(
            Directory('fake'),
            [baseMigration, earlierTimestamp],
          );

          expect(
            () => runner.checkMigration(migrationRegistry, baseMigration),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.messages,
            contains(
              'ERROR: Migration timestamp is not after the base migration timestamp.',
            ),
          );
        },
      );
    });

    group('hasConflicts', () {
      test(
        'Given a file with conflict markers when checking conflicts then true is returned',
        () {
          const runner = RebaseMigrationRunner();
          final file = File(
            path.join(d.sandbox, 'registry_with_conflicts.txt'),
          );
          file.writeAsStringSync('''
$m1
<<<<<<< HEAD
$m2
=======
$m3
>>>>>>> feature-branch
''');

          final result = runner.hasConflicts(file);
          expect(result, isTrue);
        },
      );

      test(
        'Given a file without conflict markers when checking conflicts then false is returned',
        () {
          const runner = RebaseMigrationRunner();
          final file = File(
            path.join(d.sandbox, 'registry_without_conflicts.txt'),
          );
          file.writeAsStringSync('''
$m1
$m2
''');

          final result = runner.hasConflicts(file);
          expect(result, isFalse);
        },
      );
    });

    group('getIncomingMigration', () {
      test(
        'Given a file with conflicts when getting incoming migration then the incoming migration is returned',
        () {
          const runner = RebaseMigrationRunner();
          final file = File(
            path.join(d.sandbox, 'registry_with_conflicts.txt'),
          );
          file.writeAsStringSync('''
$m1
<<<<<<< HEAD
$m2
=======
$m3
>>>>>>> feature-branch
''');

          final result = runner.getIncomingMigration(file);
          expect(result, equals(m3));
        },
      );

      test(
        'Given a file with conflicts and multiple lines when getting incoming migration then the incoming migration is returned',
        () {
          const runner = RebaseMigrationRunner();
          final file = File(
            path.join(d.sandbox, 'registry_with_conflicts.txt'),
          );
          file.writeAsStringSync('''
$m1
<<<<<<< HEAD
$m2
=======
$m3
$m1
>>>>>>> feature-branch
''');

          final result = runner.getIncomingMigration(file);
          expect(result, equals('$m3\n$m1'));
        },
      );

      test(
        'Given a file without conflicts when getting incoming migration then an ExitException is thrown',
        () {
          const runner = RebaseMigrationRunner();
          final file = File(
            path.join(d.sandbox, 'registry_without_conflicts.txt'),
          );
          file.writeAsStringSync('''
$m1
$m2
''');

          expect(
            () => runner.getIncomingMigration(file),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.messages,
            anyElement(
              contains(
                'ERROR: Migration registry file has no conflicts.',
              ),
            ),
          );
        },
      );
    });
  });
}
