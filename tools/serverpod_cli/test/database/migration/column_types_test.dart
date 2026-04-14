import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group('Given table with int column as source and bigint column as target', () {
    var sourceDefinition = _singleColumnDatabaseDefinition(ColumnType.integer);
    var targetDefinition = _singleColumnDatabaseDefinition(ColumnType.bigint);

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    // We leave it to the user to make the column type migration.
    // The reason is that just altering the column type can be a very expensive
    // operation, especially if the table is large.
    test('then no migration actions are created.', () {
      expect(migration.actions, hasLength(0));
    });

    test('then no warnings are created.', () {
      expect(migration.warnings, hasLength(0));
    });
  });

  group('Given table with bigint column as source and int column as target', () {
    var sourceDefinition = _singleColumnDatabaseDefinition(ColumnType.bigint);
    var targetDefinition = _singleColumnDatabaseDefinition(ColumnType.integer);

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    // We leave it to the user to make the column type migration.
    // The reason is that just altering the column type can be a very expensive
    // operation, especially if the table is large.
    test('then no migration actions are created.', () {
      expect(migration.actions, hasLength(0));
    });

    test('then no warnings are created.', () {
      expect(migration.warnings, hasLength(0));
    });
  });

  group(
    'Given table with json column as source and jsonb column as target',
    () {
      var sourceDefinition = _singleColumnDatabaseDefinition(ColumnType.json);
      var targetDefinition = _singleColumnDatabaseDefinition(ColumnType.jsonb);

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      // The migration engine does not support in-place ALTER COLUMN TYPE for
      // json/jsonb, so the table is dropped and recreated. The destructive
      // warnings abort `serverpod create-migration` unless --force is used.
      test(
        'then the table is dropped and recreated with destructive warnings.',
        () {
          expect(migration.actions, hasLength(2));
          expect(
            migration.actions.first.type,
            DatabaseMigrationActionType.deleteTable,
          );
          expect(
            migration.actions.last.type,
            DatabaseMigrationActionType.createTable,
          );
          expect(migration.warnings, isNotEmpty);
          expect(migration.warnings.every((w) => w.destructive), isTrue);
        },
      );
    },
  );

  group(
    'Given table with jsonb column as source and json column as target',
    () {
      var sourceDefinition = _singleColumnDatabaseDefinition(ColumnType.jsonb);
      var targetDefinition = _singleColumnDatabaseDefinition(ColumnType.json);

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      // The migration engine does not support in-place ALTER COLUMN TYPE for
      // json/jsonb, so the table is dropped and recreated. The destructive
      // warnings abort `serverpod create-migration` unless --force is used.
      test(
        'then the table is dropped and recreated with destructive warnings.',
        () {
          expect(migration.actions, hasLength(2));
          expect(
            migration.actions.first.type,
            DatabaseMigrationActionType.deleteTable,
          );
          expect(
            migration.actions.last.type,
            DatabaseMigrationActionType.createTable,
          );
          expect(migration.warnings, isNotEmpty);
          expect(migration.warnings.every((w) => w.destructive), isTrue);
        },
      );
    },
  );
}

DatabaseDefinition _singleColumnDatabaseDefinition(ColumnType columnType) {
  return DatabaseDefinitionBuilder()
      .withTable(
        TableDefinitionBuilder()
            .withName('example_table')
            .withColumn(
              ColumnDefinitionBuilder()
                  .withName('test_column')
                  .withColumnType(columnType)
                  .build(),
            )
            .build(),
      )
      .build();
}
