import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_cli/src/test_util/builders/database/database_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/database/table_definition_builder.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given an empty source but a target definition with a new table', () {
    var tableName = 'example_table';

    var sourceDefinition =
        DatabaseDefinitionBuilder().withDefaultModules().build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder().withName(tableName).build())
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    test('then a migration action is created', () {
      expect(migration.actions, hasLength(1));
    });

    test(
      'then the database migration will create the table.',
      () {
        var action = migration.actions.first;
        expect(action.type, DatabaseMigrationActionType.createTable);
      },
      skip: migration.actions.length != 1,
    );

    test(
      'then the create table property is set with the table definition.',
      () {
        var createTable = migration.actions.first.createTable;
        expect(createTable, isNotNull);
        expect(createTable!.name, tableName);
      },
      skip: migration.actions.length != 1,
    );
  });
}
