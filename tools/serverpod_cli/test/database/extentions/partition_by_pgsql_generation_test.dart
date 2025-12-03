import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group('Given a table definition with partitionBy when generating SQL', () {
    test(
      'then the CREATE TABLE statement includes PARTITION BY clause.',
      () {
        var table = TableDefinitionBuilder()
            .withName('example')
            .withPartitionBy(['source'])
            .build();

        var sql = table.tableCreationToPgsql();

        expect(sql, contains('PARTITION BY LIST ("source")'));
      },
    );

    test(
      'with multiple partition columns then all columns are in PARTITION BY.',
      () {
        var table = TableDefinitionBuilder()
            .withName('example')
            .withPartitionBy(['source', 'category'])
            .build();

        var sql = table.tableCreationToPgsql();

        expect(sql, contains('PARTITION BY LIST ("source", "category")'));
      },
    );

    test(
      'without partitionBy then the CREATE TABLE statement does not include PARTITION BY clause.',
      () {
        var table = TableDefinitionBuilder().withName('example').build();

        var sql = table.tableCreationToPgsql();

        expect(sql, isNot(contains('PARTITION BY')));
      },
    );

    test(
      'with ifNotExists flag then the CREATE TABLE IF NOT EXISTS includes PARTITION BY clause.',
      () {
        var table = TableDefinitionBuilder()
            .withName('example')
            .withPartitionBy(['source'])
            .build();

        var sql = table.tableCreationToPgsql(ifNotExists: true);

        expect(sql, contains('CREATE TABLE IF NOT EXISTS "example"'));
        expect(sql, contains('PARTITION BY LIST ("source")'));
      },
    );
  });
}
