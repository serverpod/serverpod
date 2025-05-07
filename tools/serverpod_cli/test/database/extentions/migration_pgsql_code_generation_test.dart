import 'package:serverpod_cli/analyzer.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';
import '../../test_util/builders/model_source_builder.dart';
import '../../test_util/database_definition_helpers.dart';

void main() {
  group(
      'Given a table that is not managed by serverpod that changes to be managed',
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

    var psql = migration.toPgSql(installedModules: [], removedModules: []);

    test(
        'Given a table transitioning from none manage to manage then the psql code contains a create table if not exists.',
        () {
      expect(psql, contains('CREATE TABLE IF NOT EXISTS "example_table"'));
    });
  });

  /// Issue: https://github.com/serverpod/serverpod/issues/3503
  test(
      'Given an existing table that that references a new table with a name lexically sorted before the existing one, when creating migraion sql then the migration code should create the table before defining the foreign key',
      () {
    var sourceModels = [
      ModelSourceBuilder().withFileName('existing_table').withYaml(
        '''
class: ExistingModel
table: a_existing_table
fields:
  name: String
          ''',
      ).build(),
    ];

    var targetModels = [
      ModelSourceBuilder().withFileName('new_model').withYaml(
        '''
class: NewModel
table: z_new_model
fields:
  name: String
          ''',
      ).build(),
      ModelSourceBuilder().withFileName('existing_table').withYaml(
        '''
class: ExistingModel
table: a_existing_table
fields:
  name: String
  newModel: NewModel?, relation(optional)
          ''',
      ).build(),
    ];

    var (:sourceDefinition, :targetDefinition) = databaseDefinitionsFromModels(
      sourceModels,
      targetModels,
    );

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    var psql = migration.toPgSql(installedModules: [], removedModules: []);

    var createNewModelTable = psql.indexOf('CREATE TABLE "z_new_model"');
    var addForeignKeyToExistingTable =
        psql.indexOf('ADD CONSTRAINT "a_existing_table_fk_0"');

    expect(createNewModelTable, greaterThanOrEqualTo(0));
    expect(addForeignKeyToExistingTable, greaterThanOrEqualTo(0));

    expect(createNewModelTable, lessThan(addForeignKeyToExistingTable));
  });
}
