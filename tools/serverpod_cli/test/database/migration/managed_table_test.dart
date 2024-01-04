import 'package:serverpod_cli/src/test_util/builders/database/column_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/database/database_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/database/table_definition_builder.dart';
import 'package:test/test.dart';
import 'package:serverpod_cli/src/database/migration.dart';

void main() {
  test(
      'Given two database definitions with one unchanged table and one unmanaged table in the target definition when generating the migration then no actions are added.',
      () {
    var unchangedTable = TableDefinitionBuilder().build();

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(unchangedTable)
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(unchangedTable)
        .withTable(TableDefinitionBuilder()
            .withName('unmanaged_table')
            .withManaged(false)
            .build())
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    expect(migration.actions, hasLength(0));
  });

  test(
      'Given two database definitions with one unchanged table and one unmanaged table in the source definition when generating the migration then no actions are added.',
      () {
    var unchangedTable = TableDefinitionBuilder().build();

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(unchangedTable)
        .withTable(TableDefinitionBuilder()
            .withName('unmanaged_table')
            .withManaged(false)
            .build())
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(unchangedTable)
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    expect(migration.actions, hasLength(0));
  });

  test(
      'Given a table that is managed by serverpod that changes to opt out of serverpod management then the database migration has no additional actions.',
      () {
    var tableName = 'example_table';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withManaged(true)
            .build())
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withManaged(false)
            .build())
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    expect(migration.actions, isEmpty);
  });

  test(
      'Given a table that is managed by serverpod that changes to opt out of serverpod management but also modifies the table in a backwards compatible way then the database migration has no additional actions.',
      () {
    var tableName = 'example_table';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withManaged(true)
            .build())
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withColumn(ColumnDefinitionBuilder()
                .withName('myColumn')
                .withIsNullable(true)
                .build())
            .withManaged(false)
            .build())
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    expect(migration.actions, isEmpty);
  });

  test(
      'Given a table that is managed by serverpod that changes to opt out of serverpod management but also modifies the table in a destructive way then the database migration has no additional actions.',
      () {
    var tableName = 'example_table';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withManaged(true)
            .build())
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withColumn(ColumnDefinitionBuilder()
                .withName('myColumn')
                .withIsNullable(false)
                .build())
            .withManaged(false)
            .build())
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    expect(migration.actions, isEmpty);
  });

  test(
      'Given a table that is not managed by serverpod that changes to be managed then the database migration will create the table if it does not exist.',
      () {
    var tableName = 'example_table';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withManaged(false)
            .build())
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withManaged(true)
            .build())
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    expect(migration.actions, hasLength(1));

    var createTable = migration.actions.first.createTable;
    expect(createTable, isNotNull);
    expect(createTable!.name, 'example_table');
  });
}
