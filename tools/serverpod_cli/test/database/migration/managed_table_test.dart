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
}
