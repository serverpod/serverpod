import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group(
    'Given columns with different model field ids when names could match rename',
    () {
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
                      .withFieldName('fieldA')
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
                      .withFieldName('fieldB')
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

      test('then no rename is detected (drop and add instead).', () {
        var action = migration.actions.first;
        var tableMigration = action.alterTable;

        expect(
          tableMigration!.modifyColumns.where((m) => m.newColumnName != null),
          isEmpty,
        );
        expect(
          tableMigration.deleteColumns,
          contains(oldColumnName),
        );
        expect(
          tableMigration.addColumns.any((c) => c.name == newColumnName),
          isTrue,
        );
      });
    },
  );

  group('Given a table with a renamed column when detecting migration', () {
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

    test('then a migration action is created.', () {
      expect(migration.actions, hasLength(1));
    });

    test('then the action type is alterTable.', () {
      var action = migration.actions.first;
      expect(action.type, DatabaseMigrationActionType.alterTable);
    });

    test('then the table migration includes a rename.', () {
      var action = migration.actions.first;
      var tableMigration = action.alterTable;

      expect(tableMigration, isNotNull);
      expect(tableMigration!.modifyColumns, hasLength(1));
      var columnMigration = tableMigration.modifyColumns.first;
      expect(columnMigration.columnName, oldColumnName);
      expect(columnMigration.newColumnName, newColumnName);
    });

    test('then the column is not in addColumns list.', () {
      var action = migration.actions.first;
      var tableMigration = action.alterTable;
      expect(tableMigration!.addColumns, isEmpty);
    });

    test('then the column is not in deleteColumns list.', () {
      var action = migration.actions.first;
      var tableMigration = action.alterTable;
      expect(tableMigration!.deleteColumns, isEmpty);
    });

    test('then no destructive warnings are generated.', () {
      var destructiveWarnings = migration.warnings
          .where((w) => w.destructive)
          .toList();
      expect(destructiveWarnings, isEmpty);
    });
  });

  group(
    'Given a table with multiple renamed columns when detecting migration',
    () {
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

      test('then both renames are detected.', () {
        var action = migration.actions.first;
        var tableMigration = action.alterTable;
        expect(tableMigration!.modifyColumns, hasLength(2));

        var firstColumnMigration = tableMigration.modifyColumns.firstWhere(
          (m) => m.columnName == oldName1,
        );
        expect(firstColumnMigration.columnName, oldName1);
        expect(firstColumnMigration.newColumnName, newName1);

        var secondColumnMigration = tableMigration.modifyColumns.firstWhere(
          (m) => m.columnName == oldName2,
        );
        expect(secondColumnMigration.columnName, oldName2);
        expect(secondColumnMigration.newColumnName, newName2);
      });
    },
  );

  group(
    'Given a renamed column with a changed type when detecting migration',
    () {
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
                      .withDartType('String')
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
                      .withColumnType(ColumnType.integer)
                      .withDartType('int')
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

      test('then it is not detected as a rename.', () {
        var alterTableActionsWithRename = migration.actions.where(
          (a) =>
              a.type == DatabaseMigrationActionType.alterTable &&
              a.alterTable != null &&
              a.alterTable!.modifyColumns.any((m) => m.newColumnName != null),
        );
        expect(alterTableActionsWithRename, isEmpty);
      });

      test('then the original column is in deleteColumns list.', () {
        var action = migration.actions.firstWhere(
          (a) => a.type == DatabaseMigrationActionType.alterTable,
          orElse: () => DatabaseMigrationAction(
            type: DatabaseMigrationActionType.alterTable,
          ),
        );
        var tableMigration = action.alterTable;
        if (tableMigration != null) {
          expect(tableMigration.deleteColumns, contains(oldColumnName));
        }
      });

      test('then the new column is in addColumns list.', () {
        var action = migration.actions.firstWhere(
          (a) => a.type == DatabaseMigrationActionType.alterTable,
          orElse: () => DatabaseMigrationAction(
            type: DatabaseMigrationActionType.alterTable,
          ),
        );
        var tableMigration = action.alterTable;
        if (tableMigration != null) {
          expect(
            tableMigration.addColumns.any((c) => c.name == newColumnName),
            isTrue,
          );
        }
      });
    },
  );

  group(
    'Given a renamed column with changed nullability when detecting migration',
    () {
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

      test('then the rename is detected.', () {
        var action = migration.actions.first;
        var tableMigration = action.alterTable;
        var columnMigration = tableMigration!.modifyColumns.first;
        expect(columnMigration.columnName, oldColumnName);
        expect(columnMigration.newColumnName, newColumnName);
      });

      test('then a modify column action is also created.', () {
        var action = migration.actions.first;
        var tableMigration = action.alterTable;
        expect(tableMigration!.modifyColumns, hasLength(1));
        expect(tableMigration.modifyColumns.first.columnName, oldColumnName);
        expect(tableMigration.modifyColumns.first.newColumnName, newColumnName);
        expect(tableMigration.modifyColumns.first.addNullable, isTrue);
      });
    },
  );

  group(
    'Given a renamed column with changed default when detecting migration',
    () {
      const tableName = 'example_table';
      const oldColumnName = 'old_name';
      const newColumnName = 'new_name';
      const defaultValue = "'default'";
      const modelFieldName = 'defaultField';

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
                      .withColumnDefault(defaultValue)
                      .build(),
                )
                .build(),
          )
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('then the rename is detected.', () {
        var action = migration.actions.first;
        var tableMigration = action.alterTable;
        var columnMigration = tableMigration!.modifyColumns.first;

        expect(columnMigration.columnName, oldColumnName);
        expect(columnMigration.newColumnName, newColumnName);
      });

      test('then a modify column action is also created.', () {
        var action = migration.actions.first;
        var tableMigration = action.alterTable;

        expect(tableMigration!.modifyColumns, hasLength(1));
        var columnMigration = tableMigration.modifyColumns.first;
        expect(columnMigration.columnName, oldColumnName);
        expect(columnMigration.newColumnName, newColumnName);
        expect(columnMigration.changeDefault, isTrue);
        expect(columnMigration.newDefault, defaultValue);
      });
    },
  );

  group('Given a table with mixed operations when detecting migration', () {
    const tableName = 'example_table';
    const renamedOldName = 'old_name';
    const renamedNewName = 'new_name';
    const addedColumnName = 'added_column';
    const deletedColumnName = 'deleted_column';
    const unchangedColumnName = 'unchanged_column';
    const renamedModelField = 'renamedModelField';

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
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(deletedColumnName)
                    .withFieldName('deletedField')
                    .withColumnType(ColumnType.integer)
                    .build(),
              )
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(unchangedColumnName)
                    .withFieldName('unchangedField')
                    .withColumnType(ColumnType.boolean)
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
                    .withColumnType(ColumnType.doublePrecision)
                    .withIsNullable(true)
                    .build(),
              )
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(unchangedColumnName)
                    .withFieldName('unchangedField')
                    .withColumnType(ColumnType.boolean)
                    .build(),
              )
              .build(),
        )
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    test('then the rename is detected.', () {
      var action = migration.actions.first;
      var tableMigration = action.alterTable;
      var columnMigration = tableMigration!.modifyColumns.firstWhere(
        (m) => m.columnName == renamedOldName,
      );
      expect(columnMigration.columnName, renamedOldName);
      expect(columnMigration.newColumnName, renamedNewName);
    });

    test('then the added column is detected.', () {
      var action = migration.actions.first;
      var tableMigration = action.alterTable;
      expect(
        tableMigration!.addColumns.any((c) => c.name == addedColumnName),
        isTrue,
      );
    });

    test('then the deleted column is detected.', () {
      var action = migration.actions.first;
      var tableMigration = action.alterTable;
      expect(tableMigration!.deleteColumns, contains(deletedColumnName));
    });

    test('then the unchanged column is not in any change lists.', () {
      var action = migration.actions.first;
      var tableMigration = action.alterTable;

      for (var columnMigration in tableMigration!.modifyColumns) {
        expect(columnMigration.columnName, isNot(unchangedColumnName));
        expect(columnMigration.newColumnName, isNot(unchangedColumnName));
      }
      expect(
        tableMigration.deleteColumns,
        isNot(contains(unchangedColumnName)),
      );
      expect(
        tableMigration.addColumns.any((c) => c.name == unchangedColumnName),
        isFalse,
      );
    });
  });
}
