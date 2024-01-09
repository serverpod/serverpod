import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_cli/src/test_util/builders/database/database_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/database/table_definition_builder.dart';
import 'package:test/test.dart';

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
}
