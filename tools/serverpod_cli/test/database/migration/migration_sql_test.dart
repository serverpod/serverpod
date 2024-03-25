import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/test_util/builders/database/database_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/database/table_definition_builder.dart';
import 'package:test/test.dart';

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
  });
}
