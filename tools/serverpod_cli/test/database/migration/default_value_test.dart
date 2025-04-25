import 'package:serverpod_cli/analyzer.dart';
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
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withColumn(ColumnDefinition(
              name: columnName,
              columnType: ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ))
            .build())
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withColumn(ColumnDefinition(
              name: columnName,
              columnType: ColumnType.text,
              isNullable: false,
              columnDefault: '\'This is a default value\'',
              dartType: 'String',
            ))
            .build())
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
        expect(action.alterTable!.modifyColumns.first.newDefault,
            '\'This is a default value\'');
      },
      skip: migration.actions.length != 1,
    );
  });

  group(
      'Given a source and target definition with a table and dropping a default value',
      () {
    var tableName = 'example_table';
    var columnName = 'example_column';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withColumn(ColumnDefinition(
              name: columnName,
              columnType: ColumnType.text,
              isNullable: false,
              columnDefault: '\'This is a default value\'',
              dartType: 'String',
            ))
            .build())
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withColumn(ColumnDefinition(
              name: columnName,
              columnType: ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ))
            .build())
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
  });

  group(
      'Given a source and target definition with a table and changing a default value',
      () {
    var tableName = 'example_table';
    var columnName = 'example_column';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withColumn(ColumnDefinition(
              name: columnName,
              columnType: ColumnType.text,
              isNullable: false,
              columnDefault: '\'This is the old default value\'',
              dartType: 'String',
            ))
            .build())
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withColumn(ColumnDefinition(
              name: columnName,
              columnType: ColumnType.text,
              isNullable: false,
              columnDefault: '\'This is the new default value\'',
              dartType: 'String',
            ))
            .build())
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
        expect(action.alterTable!.modifyColumns.first.newDefault,
            '\'This is the new default value\'');
      },
      skip: migration.actions.length != 1,
    );
  });

  group(
      'Given a source and target definition with a table and the same default value',
      () {
    var tableName = 'example_table';
    var columnName = 'example_column';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withColumn(ColumnDefinition(
              name: columnName,
              columnType: ColumnType.text,
              isNullable: false,
              columnDefault: '\'This is a default value\'',
              dartType: 'String',
            ))
            .build())
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withColumn(ColumnDefinition(
              name: columnName,
              columnType: ColumnType.text,
              isNullable: false,
              columnDefault: '\'This is a default value\'',
              dartType: 'String',
            ))
            .build())
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    test('then no migration action is created', () {
      expect(migration.actions, isEmpty);
    });
  });

  group(
      'Given a source and target definition with a table changing the id field on the model to not-nullable',
      () {
    var tableName = 'example_table';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withIdType(SupportedIdType.uuidV4, nullableModelField: true)
            .build())
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withIdType(SupportedIdType.uuidV4, nullableModelField: false)
            .build())
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    test('then no migration action is created', () {
      expect(migration.actions, isEmpty);
    });
  });

  group(
      'Given a source and target definition with a table changing the id field on the model to nullable',
      () {
    var tableName = 'example_table';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withIdType(SupportedIdType.uuidV4, nullableModelField: false)
            .build())
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withIdType(SupportedIdType.uuidV4, nullableModelField: true)
            .build())
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    test('then no migration action is created', () {
      expect(migration.actions, isEmpty);
    });
  });

  group(
      'Given a source and target definition with a table changing the id field from UUIDv4 to UUIDv7',
      () {
    var tableName = 'example_table';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withIdType(SupportedIdType.uuidV4)
            .build())
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withIdType(SupportedIdType.uuidV7)
            .build())
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
      expect(action.alterTable!.modifyColumns.first.newDefault,
          'gen_random_uuid_v7()');
    });
  });
}
