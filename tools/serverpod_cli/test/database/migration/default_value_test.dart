import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group(
    'Given a source and target definition with a table and adding a default value',
    () {
      var tableName = 'example_table';
      var columnName = 'example_column';

      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withColumn(
                  ColumnDefinition(
                    name: columnName,
                    columnType: ColumnType.text,
                    isNullable: false,
                    dartType: 'String',
                  ),
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
                  ColumnDefinition(
                    name: columnName,
                    columnType: ColumnType.text,
                    isNullable: false,
                    columnDefault: '\'This is a default value\'',
                    dartType: 'String',
                  ),
                )
                .build(),
          )
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('then a migration action is created', () {
        expect(migration.actions, hasLength(1));
      });

      test(
        'then the database migration will alter the table to add the default value.',
        () {
          var action = migration.actions.first;
          expect(action.type, DatabaseMigrationActionType.alterTable);
          expect(action.alterTable!.addColumns, hasLength(0));
          expect(action.alterTable!.modifyColumns, hasLength(1));
          expect(action.alterTable!.modifyColumns.first.columnName, columnName);
          expect(
            action.alterTable!.modifyColumns.first.newDefault,
            '\'This is a default value\'',
          );
        },
        skip: migration.actions.length != 1,
      );
    },
  );

  group(
    'Given a source and target definition with a table and dropping a default value',
    () {
      var tableName = 'example_table';
      var columnName = 'example_column';

      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withColumn(
                  ColumnDefinition(
                    name: columnName,
                    columnType: ColumnType.text,
                    isNullable: false,
                    columnDefault: '\'This is a default value\'',
                    dartType: 'String',
                  ),
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
                  ColumnDefinition(
                    name: columnName,
                    columnType: ColumnType.text,
                    isNullable: false,
                    dartType: 'String',
                  ),
                )
                .build(),
          )
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('then a migration action is created', () {
        expect(migration.actions, hasLength(1));
      });

      test(
        'then the database migration will alter the table to drop the default value.',
        () {
          var action = migration.actions.first;
          expect(action.type, DatabaseMigrationActionType.alterTable);
          expect(action.alterTable!.addColumns, hasLength(0));
          expect(action.alterTable!.modifyColumns, hasLength(1));
          expect(action.alterTable!.modifyColumns.first.columnName, columnName);
          expect(action.alterTable!.modifyColumns.first.newDefault, isNull);
        },
        skip: migration.actions.length != 1,
      );
    },
  );

  group(
    'Given a source and target definition with a table and changing a default value',
    () {
      var tableName = 'example_table';
      var columnName = 'example_column';

      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withColumn(
                  ColumnDefinition(
                    name: columnName,
                    columnType: ColumnType.text,
                    isNullable: false,
                    columnDefault: '\'This is the old default value\'',
                    dartType: 'String',
                  ),
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
                  ColumnDefinition(
                    name: columnName,
                    columnType: ColumnType.text,
                    isNullable: false,
                    columnDefault: '\'This is the new default value\'',
                    dartType: 'String',
                  ),
                )
                .build(),
          )
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('then a migration action is created', () {
        expect(migration.actions, hasLength(1));
      });

      test(
        'then the database migration will alter the table to change the default value.',
        () {
          var action = migration.actions.first;
          expect(action.type, DatabaseMigrationActionType.alterTable);
          expect(action.alterTable!.addColumns, hasLength(0));
          expect(action.alterTable!.modifyColumns, hasLength(1));
          expect(action.alterTable!.modifyColumns.first.columnName, columnName);
          expect(
            action.alterTable!.modifyColumns.first.newDefault,
            '\'This is the new default value\'',
          );
        },
        skip: migration.actions.length != 1,
      );
    },
  );

  group(
    'Given a source and target definition with a table and the same default value',
    () {
      var tableName = 'example_table';
      var columnName = 'example_column';

      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withColumn(
                  ColumnDefinition(
                    name: columnName,
                    columnType: ColumnType.text,
                    isNullable: false,
                    columnDefault: '\'This is a default value\'',
                    dartType: 'String',
                  ),
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
                  ColumnDefinition(
                    name: columnName,
                    columnType: ColumnType.text,
                    isNullable: false,
                    columnDefault: '\'This is a default value\'',
                    dartType: 'String',
                  ),
                )
                .build(),
          )
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('then no migration action is created', () {
        expect(migration.actions, isEmpty);
      });
    },
  );

  group(
    'Given a source and target definition with a table changing the id field on the model to not-nullable',
    () {
      var tableName = 'example_table';

      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withIdType(SupportedIdType.uuidV4, nullableModelField: true)
                .build(),
          )
          .build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withIdType(SupportedIdType.uuidV4, nullableModelField: false)
                .build(),
          )
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('then no migration action is created', () {
        expect(migration.actions, isEmpty);
      });
    },
  );

  group(
    'Given a source and target definition with a table changing the id field on the model to nullable',
    () {
      var tableName = 'example_table';

      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withIdType(SupportedIdType.uuidV4, nullableModelField: false)
                .build(),
          )
          .build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withIdType(SupportedIdType.uuidV4, nullableModelField: true)
                .build(),
          )
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('then no migration action is created', () {
        expect(migration.actions, isEmpty);
      });
    },
  );

  group(
    'Given a source and target definition with a table changing the id field from int to UUIDv4',
    () {
      var tableName = 'example_table';

      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withIdType(SupportedIdType.int)
                .build(),
          )
          .build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withIdType(SupportedIdType.uuidV4)
                .build(),
          )
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('then a column dropped warning is issued.', () {
        var warnings = migration.warnings.where(
          (e) => e.type == DatabaseMigrationWarningType.columnDropped,
        );

        expect(warnings, hasLength(1));
        expect(
          warnings.first.message,
          'Column id of table example_table is modified in a way that it '
          'must be deleted and recreated.',
        );
      });

      test('then a table dropped warning is issued.', () {
        var warnings = migration.warnings.where(
          (e) => e.type == DatabaseMigrationWarningType.tableDropped,
        );

        expect(warnings, hasLength(1));
        expect(
          warnings.first.message,
          'One or more columns are added to table "example_table" which cannot '
          'be added in a table migration. The complete table will be deleted '
          'and recreated.',
        );
      });

      test('then delete migration action is created.', () {
        var deleteActions = migration.actions.where(
          (e) => e.type == DatabaseMigrationActionType.deleteTable,
        );

        expect(deleteActions, hasLength(1));
        expect(deleteActions.first.deleteTable, tableName);
      });

      test('then create table migration action is created.', () {
        var createActions = migration.actions.where(
          (e) => e.type == DatabaseMigrationActionType.createTable,
        );

        expect(createActions, hasLength(1));
        expect(createActions.first.createTable!.name, tableName);
        expect(
          createActions.first.createTable!.columns.first.name,
          defaultPrimaryKeyName,
        );
        expect(
          createActions.first.createTable!.columns.first.columnDefault,
          'gen_random_uuid()',
        );
      });
    },
  );

  group(
    'Given a source and target definition with a table changing the id field from UUIDv4 to UUIDv7',
    () {
      var tableName = 'example_table';

      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withIdType(SupportedIdType.uuidV4)
                .build(),
          )
          .build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withIdType(SupportedIdType.uuidV7)
                .build(),
          )
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test(
        'then the database migration will alter the table to change the default value.',
        () {
          var action = migration.actions.first;
          expect(migration.actions, hasLength(1));
          expect(action.type, DatabaseMigrationActionType.alterTable);
          expect(action.alterTable!.addColumns, hasLength(0));
          expect(action.alterTable!.modifyColumns, hasLength(1));
          expect(action.alterTable!.modifyColumns.first.columnName, 'id');
          expect(
            action.alterTable!.modifyColumns.first.newDefault,
            'gen_random_uuid_v7()',
          );
        },
      );
    },
  );
}
