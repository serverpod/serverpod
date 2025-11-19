import 'package:serverpod_cli/analyzer.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  test(
    'Given database table definition when generating sql then table id column uses bigserial type.',
    () {
      var databaseDefinition = DatabaseDefinitionBuilder()
          .withTable(
            TableDefinitionBuilder().withName('example_table').build(),
          )
          .build();

      var sql = databaseDefinition.toPgSql(installedModules: []);

      expect(sql, contains('"id" bigserial PRIMARY KEY'));
    },
  );

  for (var (idType, definitionContains) in [
    (SupportedIdType.int, '"id" bigserial PRIMARY KEY'),
    (SupportedIdType.uuidV4, '"id" uuid PRIMARY KEY DEFAULT gen_random_uuid()'),
    (
      SupportedIdType.uuidV7,
      '"id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7()',
    ),
  ]) {
    test(
      'Given database table definition when generating sql with id set to ${idType.aliases.first} then table id column contains $definitionContains.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withIdType(idType)
                  .withName('example_table')
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(sql, contains(definitionContains));
      },
    );
  }
}
