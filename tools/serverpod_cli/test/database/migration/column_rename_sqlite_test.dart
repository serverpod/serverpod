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
    const modelFieldName = 'myField';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(
          TableDefinitionBuilder()
              .withName(tableName)
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(oldColumnName)
                    .withFieldName(modelFieldName)
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
                    .withFieldName(modelFieldName)
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

    var sqlite = migration.toSqliteSql(
      databaseDefinition: targetDefinition,
      installedModules: targetDefinition.installedModules,
      removedModules: [],
    );

    test(
      'when generating SQLite then ALTER TABLE RENAME COLUMN statement is generated.',
      () {
        expect(
          sqlite,
          contains(
            'ALTER TABLE "$tableName" RENAME COLUMN "$oldColumnName" TO "$newColumnName";',
          ),
        );
      },
    );

    test(
      'when generating SQLite then DROP COLUMN statement is not generated.',
      () {
        expect(
          sqlite,
          isNot(contains('DROP COLUMN "$oldColumnName"')),
        );
      },
    );

    test(
      'when generating SQLite then ADD COLUMN statement is not generated.',
      () {
        expect(
          sqlite,
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
    const modelField1 = 'fieldOne';
    const modelField2 = 'fieldTwo';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(
          TableDefinitionBuilder()
              .withName(tableName)
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(oldName1)
                    .withFieldName(modelField1)
                    .withColumnType(ColumnType.text)
                    .build(),
              )
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(oldName2)
                    .withFieldName(modelField2)
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
                    .withFieldName(modelField1)
                    .withColumnType(ColumnType.text)
                    .build(),
              )
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(newName2)
                    .withFieldName(modelField2)
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

    var sqlite = migration.toSqliteSql(
      databaseDefinition: targetDefinition,
      installedModules: targetDefinition.installedModules,
      removedModules: [],
    );

    test(
      'when generating SQLite then both RENAME COLUMN statements are generated.',
      () {
        expect(
          sqlite,
          contains(
            'ALTER TABLE "$tableName" RENAME COLUMN "$oldName1" TO "$newName1";',
          ),
        );
        expect(
          sqlite,
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
    const renamedModelField = 'renamedField';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(
          TableDefinitionBuilder()
              .withName(tableName)
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(renamedOldName)
                    .withFieldName(renamedModelField)
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
                    .withFieldName(renamedModelField)
                    .withColumnType(ColumnType.text)
                    .build(),
              )
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(addedColumnName)
                    .withFieldName('addedField')
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

    var sqlite = migration.toSqliteSql(
      databaseDefinition: targetDefinition,
      installedModules: targetDefinition.installedModules,
      removedModules: [],
    );

    test('when generating SQLite then rename appears before add.', () {
      var renameIndex = sqlite.indexOf('RENAME COLUMN');
      var addIndex = sqlite.indexOf('ADD COLUMN');
      expect(renameIndex, isNot(-1));
      expect(addIndex, isNot(-1));
      expect(renameIndex, lessThan(addIndex));
    });
  });

  group('Given a table migration with renamed column and nullability change', () {
    const tableName = 'example_table';
    const oldColumnName = 'old_name';
    const newColumnName = 'new_name';
    const modelFieldName = 'nullableField';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(
          TableDefinitionBuilder()
              .withName(tableName)
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(oldColumnName)
                    .withFieldName(modelFieldName)
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
                    .withFieldName(modelFieldName)
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

    var sqlite = migration.toSqliteSql(
      databaseDefinition: targetDefinition,
      installedModules: targetDefinition.installedModules,
      removedModules: [],
    );

    test(
      'when generating SQLite '
      'then table rebuild copies data using the old physical column name in SELECT.',
      () {
        expect(sqlite, contains('CREATE TABLE "new_$tableName"'));
        expect(
          sqlite,
          contains(
            'INSERT INTO "new_$tableName" ("id", "name", "$newColumnName") '
            'SELECT "id", "name", "$oldColumnName" FROM "$tableName";',
          ),
        );
      },
    );

    test(
      'when generating SQLite then inline RENAME COLUMN is not used.',
      () {
        expect(
          sqlite,
          isNot(
            contains(
              'ALTER TABLE "$tableName" RENAME COLUMN "$oldColumnName" TO "$newColumnName";',
            ),
          ),
        );
      },
    );
  });
}
