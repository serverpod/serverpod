import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/create_repair_migration.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';
import '../../test_util/builders/generator_config_builder.dart';

const _projectName = 'test_project';
const _migrationVersion = '00000000000000';

void main() {
  var config = GeneratorConfigBuilder().build();

  var testAssetsPath = path.join(
    'test',
    'integration',
    'migrations',
    'test_assets',
  );

  group('Given a latest version migration folder that is empty', () {
    var projectDirectory = Directory(
      path.join(testAssetsPath, 'empty_migration'),
    );
    var projectName = 'test_project';
    var generator = MigrationGenerator(
      directory: projectDirectory,
      projectName: projectName,
    );

    test(
      'when creating migration then MigrationVersionLoadException is thrown.',
      () async {
        expect(
          generator.createMigration(force: false, config: config),
          throwsA(
            isA<MigrationVersionLoadException>()
                .having(
                  (e) => e.moduleName,
                  'Matching module name',
                  equals(projectName),
                )
                .having(
                  (e) => e.versionName,
                  'Matching version name',
                  '00000000000000',
                )
                .having(
                  (e) => e.exception,
                  'Matching exception',
                  startsWith('PathNotFoundException: Cannot open file'),
                ),
          ),
        );
      },
    );

    test(
      'when creating repair migration then MigrationVersionLoadException exception is thrown.',
      () async {
        expect(
          generator.repairMigration(
            runMode:
                CreateRepairMigrationOption.runModes.first /* development */,
            force: false,
            dialect: DatabaseDialect.postgres,
          ),
          throwsA(
            isA<MigrationVersionLoadException>()
                .having(
                  (e) => e.moduleName,
                  'Matching module name',
                  equals(projectName),
                )
                .having(
                  (e) => e.versionName,
                  'Matching version name',
                  '00000000000000',
                )
                .having(
                  (e) => e.exception,
                  'Matching exception',
                  startsWith('PathNotFoundException: Cannot open file'),
                ),
          ),
        );
      },
    );
  });

  group('Given a migration that produces warnings due to column removal', () {
    late Directory testDirectory;
    late GeneratorConfig config;
    late MigrationGenerator generator;

    setUp(() async {
      testDirectory = Directory(
        path.join(Directory.current.path, const Uuid().v4()),
      );
      testDirectory.createSync(recursive: true);

      var modelFile = File(
        path.join(
          testDirectory.path,
          'lib',
          'src',
          'protocol',
          'example.yaml',
        ),
      );
      modelFile.createSync(recursive: true);
      modelFile.writeAsStringSync('''
class: Example
table: example
fields:
  name: String
''');

      var databaseDefinition = DatabaseDefinitionBuilder()
          .withModuleName(_projectName)
          .withInstalledModules([
            DatabaseMigrationVersion(
              module: _projectName,
              version: _migrationVersion,
            ),
          ])
          .withTable(
            TableDefinitionBuilder()
                .withName('example')
                .withModule(_projectName)
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('toBeDropped')
                      .withIsNullable(true)
                      .withDartType('String?')
                      .build(),
                )
                .build(),
          )
          .build();

      var migration = DatabaseMigration(
        actions: [],
        warnings: [],
        migrationApiVersion: 1,
      );

      _writeMigrationFiles(
        testDirectory: testDirectory,
        databaseDefinition: databaseDefinition,
        migration: migration,
      );

      config = GeneratorConfigBuilder()
          .withName(_projectName)
          .withServerPackageDirectoryPathParts(path.split(testDirectory.path))
          .withModules([])
          .build();

      generator = MigrationGenerator(
        directory: testDirectory,
        projectName: _projectName,
      );
    });

    tearDown(() {
      if (testDirectory.existsSync()) {
        testDirectory.deleteSync(recursive: true);
      }
    });

    test(
      'when creating migration with force `false` then MigrationAbortedException is thrown.',
      () async {
        await expectLater(
          generator.createMigration(force: false, config: config),
          throwsA(isA<MigrationAbortedException>()),
        );
      },
    );

    test(
      'when creating migration with force `true` then migration is created.',
      () async {
        var result = await generator.createMigration(
          force: true,
          config: config,
          write: false,
        );
        expect(result, isNotNull);
      },
    );
  });

  group('Given a project with no database changes', () {
    late Directory testDirectory;
    late GeneratorConfig config;
    late MigrationGenerator generator;

    setUp(() async {
      testDirectory = Directory(
        path.join(Directory.current.path, const Uuid().v4()),
      );
      testDirectory.createSync(recursive: true);

      var modelFile = File(
        path.join(
          testDirectory.path,
          'lib',
          'src',
          'protocol',
          'example.yaml',
        ),
      );
      modelFile.createSync(recursive: true);
      modelFile.writeAsStringSync('''
class: Example
table: example
fields:
  name: String
''');

      var databaseDefinition = DatabaseDefinitionBuilder()
          .withModuleName(_projectName)
          .withInstalledModules([
            DatabaseMigrationVersion(
              module: _projectName,
              version: _migrationVersion,
            ),
          ])
          .withTable(
            TableDefinitionBuilder()
                .withName('example')
                .withModule(_projectName)
                .build(),
          )
          .build();

      var migration = DatabaseMigration(
        actions: [],
        warnings: [],
        migrationApiVersion: 1,
      );

      _writeMigrationFiles(
        testDirectory: testDirectory,
        databaseDefinition: databaseDefinition,
        migration: migration,
      );

      config = GeneratorConfigBuilder()
          .withName(_projectName)
          .withServerPackageDirectoryPathParts(path.split(testDirectory.path))
          .withModules([])
          .build();

      generator = MigrationGenerator(
        directory: testDirectory,
        projectName: _projectName,
      );
    });

    tearDown(() {
      if (testDirectory.existsSync()) {
        testDirectory.deleteSync(recursive: true);
      }
    });

    test('when creating migration then `null` is returned.', () async {
      var result = await generator.createMigration(
        force: false,
        config: config,
      );
      expect(result, isNull);
    });
  });
}

void _writeMigrationFiles({
  required Directory testDirectory,
  required DatabaseDefinition databaseDefinition,
  required DatabaseMigration migration,
}) {
  var migrationDir = Directory(
    path.join(testDirectory.path, 'migrations', _migrationVersion),
  );
  migrationDir.createSync(recursive: true);

  var definitionProjectJson = File(
    path.join(migrationDir.path, 'definition_project.json'),
  );
  definitionProjectJson.writeAsStringSync(
    SerializationManager.encode(databaseDefinition, formatted: true),
  );

  var definitionJson = File(
    path.join(migrationDir.path, 'definition.json'),
  );
  definitionJson.writeAsStringSync(
    SerializationManager.encode(databaseDefinition, formatted: true),
  );

  var migrationJson = File(
    path.join(migrationDir.path, 'migration.json'),
  );
  migrationJson.writeAsStringSync(
    SerializationManager.encode(migration, formatted: true),
  );

  var definitionSql = File(
    path.join(migrationDir.path, 'definition.sql'),
  );
  definitionSql.writeAsStringSync('-- initial definition');

  var migrationSql = File(
    path.join(migrationDir.path, 'migration.sql'),
  );
  migrationSql.writeAsStringSync('-- initial migration');

  var registryFile = File(
    path.join(testDirectory.path, 'migrations', 'migration_registry.txt'),
  );
  registryFile.writeAsStringSync('$_migrationVersion\n');
}
