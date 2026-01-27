import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group('Given a table migration with a column rename', () {
    const tableName = 'example_table';
    const oldColumnName = 'old_name';
    const newColumnName = 'new_name';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(
          TableDefinitionBuilder()
              .withName(tableName)
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(oldColumnName)
                    .withColumnType(ColumnType.text)
                    .build(),
              )
              .build(),
        )
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(
          TableDefinitionBuilder()
              .withName(tableName)
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(newColumnName)
                    .withColumnType(ColumnType.text)
                    .build(),
              )
              .build(),
        )
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    var psql = migration.toPgSql(installedModules: [], removedModules: []);

    test(
      'when generating PostgreSQL then ALTER TABLE RENAME COLUMN statement is generated.',
      () {
        expect(
          psql,
          contains(
            'ALTER TABLE "$tableName" RENAME COLUMN "$oldColumnName" TO "$newColumnName";',
          ),
        );
      },
    );

    test(
      'when generating PostgreSQL then DROP COLUMN statement is not generated.',
      () {
        expect(
          psql,
          isNot(contains('DROP COLUMN "$oldColumnName"')),
        );
      },
    );

    test(
      'when generating PostgreSQL then ADD COLUMN statement is not generated.',
      () {
        expect(
          psql,
          isNot(contains('ADD COLUMN "$newColumnName"')),
        );
      },
    );
  });

  group('Given a table migration with multiple column renames', () {
    const tableName = 'example_table';
    const oldName1 = 'old_name_1';
    const newName1 = 'new_name_1';
    const oldName2 = 'old_name_2';
    const newName2 = 'new_name_2';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(
          TableDefinitionBuilder()
              .withName(tableName)
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(oldName1)
                    .withColumnType(ColumnType.text)
                    .build(),
              )
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(oldName2)
                    .withColumnType(ColumnType.integer)
                    .build(),
              )
              .build(),
        )
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(
          TableDefinitionBuilder()
              .withName(tableName)
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(newName1)
                    .withColumnType(ColumnType.text)
                    .build(),
              )
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(newName2)
                    .withColumnType(ColumnType.integer)
                    .build(),
              )
              .build(),
        )
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    var psql = migration.toPgSql(installedModules: [], removedModules: []);

    test(
      'when generating PostgreSQL then both RENAME COLUMN statements are generated.',
      () {
        expect(
          psql,
          contains(
            'ALTER TABLE "$tableName" RENAME COLUMN "$oldName1" TO "$newName1";',
          ),
        );
        expect(
          psql,
          contains(
            'ALTER TABLE "$tableName" RENAME COLUMN "$oldName2" TO "$newName2";',
          ),
        );
      },
    );
  });

  group('Given a table migration with rename and add operations', () {
    const tableName = 'example_table';
    const renamedOldName = 'old_name';
    const renamedNewName = 'new_name';
    const addedColumnName = 'added_column';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(
          TableDefinitionBuilder()
              .withName(tableName)
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(renamedOldName)
                    .withColumnType(ColumnType.text)
                    .build(),
              )
              .build(),
        )
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(
          TableDefinitionBuilder()
              .withName(tableName)
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(renamedNewName)
                    .withColumnType(ColumnType.text)
                    .build(),
              )
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(addedColumnName)
                    .withColumnType(ColumnType.integer)
                    .withIsNullable(true)
                    .build(),
              )
              .build(),
        )
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    var psql = migration.toPgSql(installedModules: [], removedModules: []);

    test('when generating PostgreSQL then rename appears before add.', () {
      var renameIndex = psql.indexOf('RENAME COLUMN');
      var addIndex = psql.indexOf('ADD COLUMN');
      expect(renameIndex, isNot(-1));
      expect(addIndex, isNot(-1));
      expect(renameIndex, lessThan(addIndex));
    });
  });

  group('Given a table migration with renamed column and nullability change', () {
    const tableName = 'example_table';
    const oldColumnName = 'old_name';
    const newColumnName = 'new_name';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(
          TableDefinitionBuilder()
              .withName(tableName)
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(oldColumnName)
                    .withColumnType(ColumnType.text)
                    .withIsNullable(false)
                    .build(),
              )
              .build(),
        )
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(
          TableDefinitionBuilder()
              .withName(tableName)
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(newColumnName)
                    .withColumnType(ColumnType.text)
                    .withIsNullable(true)
                    .build(),
              )
              .build(),
        )
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    var psql = migration.toPgSql(installedModules: [], removedModules: []);

    test(
      'when generating PostgreSQL then both RENAME and DROP NOT NULL statements are generated.',
      () {
        expect(
          psql,
          contains(
            'ALTER TABLE "$tableName" RENAME COLUMN "$oldColumnName" TO "$newColumnName";',
          ),
        );
        expect(
          psql,
          contains(
            'ALTER TABLE "$tableName" ALTER COLUMN "$newColumnName" DROP NOT NULL;',
          ),
        );
      },
    );

    test(
      'when generating PostgreSQL then rename appears before nullability change.',
      () {
        var renameIndex = psql.indexOf('RENAME COLUMN');
        var dropNotNullIndex = psql.indexOf('DROP NOT NULL');
        expect(renameIndex, isNot(-1));
        expect(dropNotNullIndex, isNot(-1));
        expect(renameIndex, lessThan(dropNotNullIndex));
      },
    );
  });
}
