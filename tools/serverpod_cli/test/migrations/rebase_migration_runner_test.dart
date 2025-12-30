import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/commands/create_migration.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/migrations/generator.dart';
import 'package:serverpod_cli/src/migrations/migration_registry.dart';
import 'package:serverpod_cli/src/migrations/migration_registry_file.dart';
import 'package:serverpod_cli/src/migrations/rebase_migration_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../integration/generator_config/database_feature_config_test.dart'
    hide MockLogger, MockLogOutput;
import '../test_util/mock_log.dart';

void main() {
  late MigrationGenerator generator;
  late GeneratorConfig config;
  late MockLogger testLogger;
  late Directory originalDir;
  const m1 = '20251228100000000';
  const m2 = '20251228100000001';
  const m3 = '20251228100000002';

  Future<Directory> setupMigrations(
    List<String> migrations, {
    String projectName = 'my_project',
  }) async {
    // Create a mock serverpod project
    final projectDir = createMockServerpodProject(
      projectName: projectName,
      generatorYamlContent: '''
type: server
features:
  database: true
''',
    );
    await projectDir.create();
    Directory.current = projectDir.io;

    // Create migrations directory
    final serverDir = Directory(
      path.join(Directory.current.path, '${projectName}_server'),
    );
    final migrationsDir = Directory(
      path.join(serverDir.path, 'migrations'),
    );
    await migrationsDir.create(recursive: true);

    // Create migration registry file
    // await File(
    //   path.join(migrationsDir.path, 'migration_registry.txt'),
    // ).writeAsString(migrations.map((m) => '$m\n').join());

    generator = MigrationGenerator(
      directory: serverDir,
      projectName: projectName,
    );
    CommandLineExperimentalFeatures.initialize([]);
    config = await GeneratorConfig.load(
      serverRootDir: serverDir.path,
      interactive: false,
    );

    // Add migration registry
    for (var migrationName in migrations) {
      generator.migrationRegistry.add(migrationName);
    }
    await generator.migrationRegistry.write();

    // Create migrations
    for (var migration in migrations) {
      await Directory(path.join(migrationsDir.path, migration)).create();
    }

    return migrationsDir;
  }

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
          final runner = RebaseMigrationRunner();
          const migrationId = '$m1-tag';

          final timestamp = runner.getMigrationTimestamp(migrationId);

          expect(timestamp, equals(int.parse(m1)));
        },
      );

      test(
        'Given a malformed migration ID when getting migration timestamp then an ExitException is thrown',
        () {
          final runner = RebaseMigrationRunner();
          const migrationId = 'malformed';

          expect(
            () => runner.getMigrationTimestamp(migrationId),
            throwsA(isA<ExitException>()),
          );
        },
      );
    });

    group('validateMigration', () {
      test(
        'Given a migration that exists in registry when validating migration then the call succeeds',
        () {
          final runner = RebaseMigrationRunner();
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
          final runner = RebaseMigrationRunner();
          final migrationRegistry = MigrationRegistry(
            Directory('fake'),
            [m1, m2],
          );

          expect(
            () => runner.validateMigration(m3, migrationRegistry),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.errorMessages,
            contains('Migration $m3 does not exist.'),
          );
        },
      );
    });

    group('getBaseMigrationId', () {
      test(
        'Given onto migration exists in registry when getting base migration ID then onto is returned',
        () async {
          const onto = m1;
          const migration2 = m2;
          final runner = RebaseMigrationRunner(onto: onto);
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
          final runner = RebaseMigrationRunner(onto: onto);
          final migrationsDir = await setupMigrations([migration1, migration2]);

          final migrationRegistry = MigrationRegistry.load(migrationsDir);

          expect(
            () => runner.getBaseMigrationId(migrationRegistry),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.errorMessages,
            contains('Migration $onto does not exist.'),
          );
        },
      );

      test(
        'Given registry file does not exist when getting base migration ID then an ExitException is thrown',
        () async {
          final runner = RebaseMigrationRunner();
          final migrationsDir = Directory(path.join(d.sandbox, 'non_existent'));
          final migrationRegistry = MigrationRegistry(migrationsDir, []);

          expect(
            () => runner.getBaseMigrationId(migrationRegistry),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.errorMessages,
            contains('Migration registry file does not exist.'),
          );
        },
      );

      test(
        'Given no onto and registry has conflicts when getting base migration ID then incoming migration is returned',
        () async {
          final runner = RebaseMigrationRunner();
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
          final runner = RebaseMigrationRunner();
          final migrationsDir = await setupMigrations([m1, m2]);
          final migrationRegistry = MigrationRegistry.load(migrationsDir);

          expect(
            () => runner.getBaseMigrationId(migrationRegistry),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.errorMessages,
            anyElement(
              contains(
                'Migration registry file has no conflicts.',
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
          final runner = RebaseMigrationRunner();
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
            testLogger.output.infoMessages,
            contains(
              'There is only one migration after the base migration.',
            ),
          );
        },
      );

      test(
        'Given no migrations after base migration when checking migration then an ExitException is thrown',
        () async {
          final runner = RebaseMigrationRunner();
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
            testLogger.output.errorMessages,
            contains('There is no migration after the base migration.'),
          );
        },
      );

      test(
        'Given more than one migration after base migration when checking migration then an ExitException is thrown',
        () async {
          final runner = RebaseMigrationRunner();
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
            testLogger.output.errorMessages,
            contains(
              'There is more than one migration after the base migration.',
            ),
          );
        },
      );

      test(
        'Given migration with timestamp equal to base migration when checking migration then an ExitException is thrown',
        () async {
          final runner = RebaseMigrationRunner();
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
            testLogger.output.errorMessages,
            contains(
              'Migration timestamp is not after the base migration timestamp.',
            ),
          );
        },
      );

      test(
        'Given migration with timestamp before base migration when checking migration then an ExitException is thrown',
        () async {
          final runner = RebaseMigrationRunner();
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
            testLogger.output.errorMessages,
            contains(
              'Migration timestamp is not after the base migration timestamp.',
            ),
          );
        },
      );
    });

    group('getLastIncomingMigration', () {
      test(
        'Given a file with conflicts when getting incoming migration then the incoming migration is returned',
        () {
          final runner = RebaseMigrationRunner();
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

          final result = runner.getLastIncomingMigration(
            MigrationRegistryFile(file.path),
          );
          expect(result, equals(m3));
        },
      );

      test(
        'Given a file with conflicts and multiple lines when getting incoming migration then the last incoming migration is returned',
        () {
          final runner = RebaseMigrationRunner();
          final file = File(
            path.join(d.sandbox, 'registry_with_conflicts.txt'),
          );
          file.writeAsStringSync('''
$m1
<<<<<<< HEAD
$m2
=======
$m3
$m2
>>>>>>> feature-branch
''');

          final result = runner.getLastIncomingMigration(
            MigrationRegistryFile(file.path),
          );
          expect(result, equals(m2));
        },
      );

      test(
        'Given a file without conflicts when getting incoming migration then an ExitException is thrown',
        () {
          final runner = RebaseMigrationRunner();
          final file = File(
            path.join(d.sandbox, 'registry_without_conflicts.txt'),
          );
          file.writeAsStringSync('''
$m1
$m2
''');

          expect(
            () => runner.getLastIncomingMigration(
              MigrationRegistryFile(file.path),
            ),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.errorMessages,
            anyElement(
              contains(
                'Migration registry file has no conflicts.',
              ),
            ),
          );
        },
      );
    });

    group('extractMigrations', () {
      test(
        'Given a registry content with conflicts when extracting migrations then the correct record is returned',
        () {
          final file = File(path.join(d.sandbox, 'extract_migrations.txt'));
          const registryContent =
              '''
### AUTOMATICALLY GENERATED DO NOT MODIFY
$m1
<<<<<<< HEAD
$m2
=======
$m3
>>>>>>> feature-branch
''';
          file.writeAsStringSync(registryContent);

          final result = MigrationRegistryFile(file.path).extractMigrations();
          expect(result.common, [m1]);
          expect(result.local, [m2]);
          expect(result.incoming, [m3]);
        },
      );

      test(
        'Given registry content with multiple migrations in each part when extracting then all migrations are returned',
        () {
          final file = File(
            path.join(d.sandbox, 'extract_migrations_multiple.txt'),
          );
          const registryContent =
              '''
$m1
$m2
<<<<<<< HEAD
$m3
$m1
=======
$m2
$m3
>>>>>>> feature-branch
''';
          file.writeAsStringSync(registryContent);

          final result = MigrationRegistryFile(file.path).extractMigrations();
          expect(result.common, [m1, m2]);
          expect(result.local, [m3, m1]);
          expect(result.incoming, [m2, m3]);
        },
      );

      test(
        'Given registry content without conflicts when extracting then the content is returned as common',
        () {
          final file = File(
            path.join(d.sandbox, 'extract_migrations_no_conflicts.txt'),
          );
          const registryContent =
              '''
$m1
$m2
''';
          file.writeAsStringSync(registryContent);

          final result = MigrationRegistryFile(file.path).extractMigrations();
          expect(result.common, [m1, m2]);
          expect(result.local, isEmpty);
          expect(result.incoming, isEmpty);
        },
      );
    });

    group('ensureBaseMigration', () {
      test(
        'Given a base migration that does not exist when ensuring base migration then an ExitException is thrown',
        () async {
          final runner = RebaseMigrationRunner();
          const baseMigration = m3;
          const migration2 = m2;
          final migrationRegistry = MigrationRegistry(
            Directory('fake'),
            [migration2],
          );

          expect(
            () => runner.ensureBaseMigration(migrationRegistry, baseMigration),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.errorMessages,
            contains('Base migration $baseMigration does not exist.'),
          );
        },
      );

      test(
        'Given a base migration that exists when ensuring base migration then returns normally',
        () async {
          final runner = RebaseMigrationRunner();
          const baseMigration = m1;
          const migration2 = m2;
          final migrationRegistry = MigrationRegistry(
            Directory('fake'),
            [baseMigration, migration2],
          );

          expect(
            () => runner.ensureBaseMigration(migrationRegistry, baseMigration),
            returnsNormally,
          );
        },
      );
    });

    group('backupMigrations', () {
      test(
        'Given a base migration when backing up migrations then the migrations '
        'since the base migration are backed up',
        () async {
          final runner = RebaseMigrationRunner();
          const baseMigration = m1;
          const projectName = 'test_project';
          final migrationsDir = await setupMigrations(
            [baseMigration, m2],
            projectName: projectName,
          );
          final backupPath = runner.getBackupDirPath(baseMigration);
          expect(
            backupPath,
            '.dart_tool/migrations/.for_deletion_by_rebase_migration_onto_$m1',
          );

          final backupDir = runner.backupMigrations(
            generator,
            baseMigration,
            [m2],
          );
          expect(
            backupDir.path,
            path.join(migrationsDir.parent.path, backupPath),
          );
          expect(backupDir.existsSync(), isTrue);
          final folders = backupDir.listSync();
          expect(folders.length, 1);
          expect(path.basename(folders.first.path), m2);
        },
      );
    });

    group('rebaseMigration', () {
      test(
        'Given a base migration with no migrations since then an ExitException is thrown',
        () async {
          final runner = RebaseMigrationRunner();
          const baseMigration = m2;
          const projectName = 'test_project';
          await setupMigrations(
            [m1, baseMigration],
            projectName: projectName,
          );

          expect(
            () => runner.rebaseMigration(
              generator: generator,
              baseMigrationId: baseMigration,
              config: config,
            ),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.errorMessages,
            contains('No migrations since base migration: $baseMigration'),
          );
        },
      );

      test(
        'Given a base migration and one migration after when rebasing then returns true, registry is updated, and backup is created',
        () async {
          const baseMigration = m1;
          const migration2 = m2;
          const newMigration = m3;
          final mockCreateRunner = MockCreateMigrationRunner(newMigration);
          final runner = RebaseMigrationRunner(
            createMigrationRunner: mockCreateRunner,
          );

          final migrationsDir = await setupMigrations([
            baseMigration,
            migration2,
          ]);

          final registryFile = File(
            path.join(migrationsDir.path, 'migration_registry.txt'),
          );

          final result = await runner.rebaseMigration(
            generator: generator,
            baseMigrationId: baseMigration,
            config: config,
          );

          expect(result, isTrue);

          // Verify registry file content: base + new
          final registryFileMigrations = MigrationRegistryFile(
            registryFile.path,
          ).migrations;
          expect(registryFileMigrations, equals([baseMigration, newMigration]));

          // Verify backup
          final backupDir = Directory(
            path.join(
              migrationsDir.parent.path,
              '.dart_tool/migrations/.deleted_by_rebase_migration_onto_${baseMigration}_with_$newMigration',
            ),
          );
          expect(backupDir.existsSync(), isTrue);
          expect(
            Directory(path.join(backupDir.path, migration2)).existsSync(),
            isTrue,
          );
        },
      );

      test(
        'Given a registry conflict with one incoming migration when rebasing onto the last incoming then it succeeds',
        () async {
          const common = m1;
          const local = m2;
          const incoming = m3;
          const newMigration = '20251228100000003';
          final mockCreateRunner = MockCreateMigrationRunner(newMigration);
          final runner = RebaseMigrationRunner(
            createMigrationRunner: mockCreateRunner,
          );

          final migrationsDir = await setupMigrations([
            common,
            local,
            incoming,
          ]);
          final registryFile = File(
            path.join(migrationsDir.path, 'migration_registry.txt'),
          );
          registryFile.writeAsStringSync('''
$common
<<<<<<< HEAD
$local
=======
$incoming
>>>>>>> incoming
''');

          // Always rebase unto the last incoming migration
          final result = await runner.rebaseMigration(
            generator: generator,
            baseMigrationId: incoming,
            config: config,
          );

          expect(result, isTrue);

          // Verify registry file content: common + incoming + new
          final registryFileMigrations = MigrationRegistryFile(
            registryFile.path,
          ).migrations;
          expect(
            registryFileMigrations,
            equals([common, incoming, newMigration]),
          );

          // Verify backup contains both local and incoming (since we replaced the whole conflict block)
          final backupDir = Directory(
            path.join(
              migrationsDir.parent.path,
              '.dart_tool/migrations/.deleted_by_rebase_migration_onto_${incoming}_with_$newMigration',
            ),
          );
          expect(backupDir.existsSync(), isTrue);
          expect(
            Directory(path.join(backupDir.path, local)).existsSync(),
            isTrue,
          );
        },
      );

      test(
        'Given a registry conflict with two incoming migrations when rebasing onto the last incoming then it succeeds',
        () async {
          const common = m1;
          const local = m2;
          const incoming1 = m3;
          const incoming2 = '20251228100000003';
          const newMigration = '20251228100000004';
          final mockCreateRunner = MockCreateMigrationRunner(newMigration);
          final runner = RebaseMigrationRunner(
            createMigrationRunner: mockCreateRunner,
          );

          final migrationsDir = await setupMigrations([
            common,
            local,
            incoming1,
            incoming2,
          ]);
          final registryFile = File(
            path.join(migrationsDir.path, 'migration_registry.txt'),
          );
          registryFile.writeAsStringSync('''
$common
<<<<<<< HEAD
$local
=======
$incoming1
$incoming2
>>>>>>> incoming
''');

          final result = await runner.rebaseMigration(
            generator: generator,
            baseMigrationId: incoming2,
            config: config,
          );

          expect(result, isTrue);

          // Verify registry file content: common + incoming1 + incoming2 + new
          final registryFileMigrations = MigrationRegistryFile(
            registryFile.path,
          ).migrations;
          expect(
            registryFileMigrations,
            equals([common, incoming1, incoming2, newMigration]),
          );

          final backupDir = Directory(
            path.join(
              migrationsDir.parent.path,
              '.dart_tool/migrations/.deleted_by_rebase_migration_onto_${incoming2}_with_$newMigration',
            ),
          );
          expect(backupDir.existsSync(), isTrue);
          expect(
            Directory(path.join(backupDir.path, local)).existsSync(),
            isTrue,
          );
        },
      );

      test(
        'Given local migration with timestamp before base migration when rebasing then it succeeds and backs up correctly',
        () async {
          const baseMigration = m2;
          const earlyLocal = m1;
          const newMigration = m3;
          final mockCreateRunner = MockCreateMigrationRunner(newMigration);
          final runner = RebaseMigrationRunner(
            createMigrationRunner: mockCreateRunner,
          );

          final migrationsDir = await setupMigrations([
            baseMigration,
            earlyLocal,
          ]);
          final registryFile = File(
            path.join(migrationsDir.path, 'migration_registry.txt'),
          );
          registryFile.writeAsStringSync('$baseMigration\n$earlyLocal\n');

          final result = await runner.rebaseMigration(
            generator: generator,
            baseMigrationId: baseMigration,
            config: config,
          );

          expect(result, isTrue);

          // Verify registry file content: base + new
          final registryFileMigrations = MigrationRegistryFile(
            registryFile.path,
          ).migrations;
          expect(registryFileMigrations, equals([baseMigration, newMigration]));

          final backupDir = Directory(
            path.join(
              migrationsDir.parent.path,
              '.dart_tool/migrations/.deleted_by_rebase_migration_onto_${baseMigration}_with_$newMigration',
            ),
          );
          expect(
            Directory(path.join(backupDir.path, earlyLocal)).existsSync(),
            isTrue,
          );
        },
      );
    });
  });
}

class MockCreateMigrationRunner extends CreateMigrationRunner {
  final String migrationName;

  MockCreateMigrationRunner(this.migrationName) : super(force: false, tag: '');

  @override
  Future<String> createMigration({
    required MigrationGenerator generator,
    required GeneratorConfig config,
  }) async {
    // Create new folder
    final migrationsDir = generator.migrationRegistry.moduleMigrationDirectory;
    final newMigrationDir = Directory(
      path.join(migrationsDir.path, migrationName),
    );
    await newMigrationDir.create();

    // Reload registry to pick up the new folder and write it to the registry file
    final registry = MigrationRegistry.load(migrationsDir);
    await registry.write();

    return migrationName;
  }
}
