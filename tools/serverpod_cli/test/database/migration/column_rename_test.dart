import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group('Given a table with a renamed column when detecting migration', () {
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
      expect(tableMigration!.renameColumns, hasLength(1));
      expect(tableMigration.renameColumns[oldColumnName], newColumnName);
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
      var destructiveWarnings =
          migration.warnings.where((w) => w.destrucive).toList();
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

    test('then both renames are detected.', () {
      var action = migration.actions.first;
      var tableMigration = action.alterTable;
      expect(tableMigration!.renameColumns, hasLength(2));
      expect(tableMigration.renameColumns[oldName1], newName1);
      expect(tableMigration.renameColumns[oldName2], newName2);
    });
  });

  group(
      'Given a column with a changed type when detecting migration',
      () {
    const tableName = 'example_table';
    const columnName = 'column_name';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(
          TableDefinitionBuilder()
              .withName(tableName)
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(columnName)
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
                    .withName(columnName)
                    .withColumnType(ColumnType.integer)
                    .withDartType('int')
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
      var action = migration.actions.firstWhere(
        (a) => a.type == DatabaseMigrationActionType.alterTable,
        orElse: () => DatabaseMigrationAction(
          type: DatabaseMigrationActionType.alterTable,
        ),
      );
      var tableMigration = action.alterTable;
      if (tableMigration != null) {
        expect(tableMigration.renameColumns, isEmpty);
      }
    });

    test('then the column is in deleteColumns list.', () {
      var action = migration.actions.firstWhere(
        (a) => a.type == DatabaseMigrationActionType.alterTable,
        orElse: () => DatabaseMigrationAction(
          type: DatabaseMigrationActionType.alterTable,
        ),
      );
      var tableMigration = action.alterTable;
      if (tableMigration != null) {
        expect(tableMigration.deleteColumns, contains(columnName));
      }
    });

    test('then the column is in addColumns list.', () {
      var action = migration.actions.firstWhere(
        (a) => a.type == DatabaseMigrationActionType.alterTable,
        orElse: () => DatabaseMigrationAction(
          type: DatabaseMigrationActionType.alterTable,
        ),
      );
      var tableMigration = action.alterTable;
      if (tableMigration != null) {
        expect(
          tableMigration.addColumns.any((c) => c.name == columnName),
          isTrue,
        );
      }
    });
  });

  group(
      'Given a renamed column with changed nullability when detecting migration',
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

    test('then the rename is detected.', () {
      var action = migration.actions.first;
      var tableMigration = action.alterTable;
      expect(tableMigration!.renameColumns[oldColumnName], newColumnName);
    });

    test('then a modify column action is also created.', () {
      var action = migration.actions.first;
      var tableMigration = action.alterTable;
      expect(tableMigration!.modifyColumns, hasLength(1));
      expect(tableMigration.modifyColumns.first.columnName, newColumnName);
      expect(tableMigration.modifyColumns.first.addNullable, isTrue);
    });
  });

  group('Given a renamed column with changed default when detecting migration',
      () {
    const tableName = 'example_table';
    const oldColumnName = 'old_name';
    const newColumnName = 'new_name';
    const defaultValue = "'default'";

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
      expect(tableMigration!.renameColumns[oldColumnName], newColumnName);
    });

    test('then a modify column action is also created.', () {
      var action = migration.actions.first;
      var tableMigration = action.alterTable;
      expect(tableMigration!.modifyColumns, hasLength(1));
      expect(tableMigration.modifyColumns.first.columnName, newColumnName);
      expect(tableMigration.modifyColumns.first.changeDefault, isTrue);
      expect(tableMigration.modifyColumns.first.newDefault, defaultValue);
    });
  });

  group('Given a table with mixed operations when detecting migration', () {
    const tableName = 'example_table';
    const renamedOldName = 'old_name';
    const renamedNewName = 'new_name';
    const addedColumnName = 'added_column';
    const deletedColumnName = 'deleted_column';
    const unchangedColumnName = 'unchanged_column';

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
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(deletedColumnName)
                    .withColumnType(ColumnType.integer)
                    .build(),
              )
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(unchangedColumnName)
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
                    .withColumnType(ColumnType.text)
                    .build(),
              )
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(addedColumnName)
                    .withColumnType(ColumnType.doublePrecision)
                    .withIsNullable(true)
                    .build(),
              )
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName(unchangedColumnName)
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
      expect(tableMigration!.renameColumns, hasLength(1));
      expect(tableMigration.renameColumns[renamedOldName], renamedNewName);
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
      expect(tableMigration!.renameColumns.containsKey(unchangedColumnName),
          isFalse);
      expect(tableMigration.renameColumns.containsValue(unchangedColumnName),
          isFalse);
      expect(tableMigration.deleteColumns, isNot(contains(unchangedColumnName)));
      expect(
        tableMigration.addColumns.any((c) => c.name == unchangedColumnName),
        isFalse,
      );
    });
  });
}
