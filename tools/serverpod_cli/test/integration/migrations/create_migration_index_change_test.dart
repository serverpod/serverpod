import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/index_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';
import '../../test_util/builders/generator_config_builder.dart';

const _projectName = 'test_project';
const _migrationVersion = '00000000000000';

void main() {
  group(
    'Given a project with a single-field index changed to multiple fields',
    () {
      late Directory testDirectory;
      late GeneratorConfig config;
      late MigrationGenerator generator;

      setUp(() {
        testDirectory = Directory(
          path.join(
            Directory.current.path,
            DateTime.now().microsecondsSinceEpoch.toString(),
          ),
        );
        testDirectory.createSync(recursive: true);

        final modelFile = File(
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
  value: String
indexes:
  example_name_idx:
    fields: name, value
    unique: true
''');

        final sourceDefinition = DatabaseDefinitionBuilder()
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
                  .withColumns([
                    ColumnDefinitionBuilder().withIdColumn('example').build(),
                    ColumnDefinitionBuilder().withNameColumn().build(),
                    ColumnDefinitionBuilder()
                        .withName('value')
                        .withDartType('String')
                        .build(),
                  ])
                  .withIndexes([
                    IndexDefinitionBuilder()
                        .withIndexName('example_name_idx')
                        .withIsUnique(true)
                        .withElements([
                          IndexElementDefinition(
                            definition: 'name',
                            type: IndexElementDefinitionType.column,
                          ),
                        ])
                        .build(),
                  ])
                  .build(),
            )
            .build();

        final sourceMigration = DatabaseMigration(
          actions: [],
          warnings: [],
          migrationApiVersion: 1,
        );

        _writeMigrationFiles(
          testDirectory: testDirectory,
          databaseDefinition: sourceDefinition,
          migration: sourceMigration,
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
        'when creating migration then the index is dropped and recreated with the updated field list.',
        () async {
          final result = await generator.createMigration(
            force: true,
            config: config,
            write: false,
          );

          expect(result, isNotNull);
          expect(result!.migration.actions, hasLength(1));

          final alterTable = result.migration.actions.single.alterTable;
          expect(alterTable, isNotNull);
          expect(alterTable!.deleteIndexes, contains('example_name_idx'));
          expect(alterTable.addIndexes, hasLength(1));
          expect(alterTable.addIndexes.single.indexName, 'example_name_idx');
          expect(
            alterTable.addIndexes.single.elements.map(
              (element) => element.definition,
            ),
            ['name', 'value'],
          );
        },
      );
    },
  );
}

void _writeMigrationFiles({
  required Directory testDirectory,
  required DatabaseDefinition databaseDefinition,
  required DatabaseMigration migration,
}) {
  final migrationDir = Directory(
    path.join(testDirectory.path, 'migrations', _migrationVersion),
  );
  migrationDir.createSync(recursive: true);

  File(
    path.join(migrationDir.path, 'definition_project.json'),
  ).writeAsStringSync(
    SerializationManager.encode(databaseDefinition, formatted: true),
  );

  File(
    path.join(migrationDir.path, 'definition.json'),
  ).writeAsStringSync(
    SerializationManager.encode(databaseDefinition, formatted: true),
  );

  File(
    path.join(migrationDir.path, 'migration.json'),
  ).writeAsStringSync(
    SerializationManager.encode(migration, formatted: true),
  );

  File(
    path.join(migrationDir.path, 'definition.sql'),
  ).writeAsStringSync('-- initial definition');

  File(
    path.join(migrationDir.path, 'migration.sql'),
  ).writeAsStringSync('-- initial migration');

  File(
    path.join(testDirectory.path, 'migrations', 'migration_registry.txt'),
  ).writeAsStringSync('$_migrationVersion\n');
}
