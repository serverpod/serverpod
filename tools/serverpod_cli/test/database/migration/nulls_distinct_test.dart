import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/index_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group(
    'Given a unique index that treats nulls as distinct as source and as not distinct as target,'
    'when the migration is generated,',
    () {
      late DatabaseMigration migration;

      setUp(() {
        migration = generateDatabaseMigration(
          databaseSource: _databaseDefinition(nullsDistinct: true),
          databaseTarget: _databaseDefinition(nullsDistinct: false),
        );
      });

      test('then one action is created.', () {
        expect(migration.actions, hasLength(1));
      });

      test('then the index is deleted and added.', () {
        var alterTable = migration.actions.single.alterTable!;

        expect(alterTable.deleteIndexes, contains('example_unique_idx'));
        expect(
          alterTable.addIndexes.map((index) => index.indexName),
          contains('example_unique_idx'),
        );
      });

      test('then a unique index warning is created.', () {
        expect(
          migration.warnings.map((warning) => warning.type),
          contains(DatabaseMigrationWarningType.uniqueIndexCreated),
        );
      });

      test('then the SQL for the index recreates it as not distinct.', () {
        var sql = migration.toPgSql(
          databaseDefinition: _databaseDefinition(nullsDistinct: false),
          installedModules: [],
          removedModules: [],
        );

        expect(sql, contains('DROP INDEX "example_unique_idx"'));
        expect(sql, contains('NULLS NOT DISTINCT'));
      });
    },
  );

  test(
    'Given a unique index without configured null handling as source and with nulls explicitly distinct as target, '
    'when the migration is generated, '
    'then no action is created since both describe the database default.',
    () {
      var migration = generateDatabaseMigration(
        databaseSource: _databaseDefinition(nullsDistinct: null),
        databaseTarget: _databaseDefinition(nullsDistinct: true),
      );

      expect(migration.actions, isEmpty);
    },
  );
}

DatabaseDefinition _databaseDefinition({required bool? nullsDistinct}) {
  return DatabaseDefinitionBuilder()
      .withDefaultModules()
      .withTable(
        TableDefinitionBuilder()
            .withName('example')
            .withIndex(
              IndexDefinitionBuilder()
                  .withIndexName('example_unique_idx')
                  .withElements([
                    IndexElementDefinition(
                      type: IndexElementDefinitionType.column,
                      definition: 'name',
                    ),
                  ])
                  .withIsUnique(true)
                  .withNullsDistinct(nullsDistinct)
                  .build(),
            )
            .build(),
      )
      .build();
}
