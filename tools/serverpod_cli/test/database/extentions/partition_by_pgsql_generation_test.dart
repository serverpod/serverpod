import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group(
    'Given a table definition with single partitionBy column',
    () {
      test(
        'when generating SQL then CREATE TABLE includes PARTITION BY LIST clause.',
        () {
          var table = TableDefinitionBuilder()
              .withName('example')
              .withPartitionBy(['source'])
              .build();

          var sql = table.tableCreationToPgsql();

          expect(sql, contains('PARTITION BY LIST ("source")'));
        },
      );
    },
  );

  group(
    'Given a table definition with multiple partitionBy columns',
    () {
      test(
        'when generating SQL then all columns are in PARTITION BY clause.',
        () {
          var table = TableDefinitionBuilder()
              .withName('example')
              .withPartitionBy(['source', 'category'])
              .build();

          var sql = table.tableCreationToPgsql();

          expect(sql, contains('PARTITION BY LIST ("source", "category")'));
        },
      );
    },
  );

  group(
    'Given a table definition without partitionBy',
    () {
      test(
        'when generating SQL then CREATE TABLE does not include PARTITION BY clause.',
        () {
          var table = TableDefinitionBuilder().withName('example').build();

          var sql = table.tableCreationToPgsql();

          expect(sql, isNot(contains('PARTITION BY')));
        },
      );
    },
  );

  group(
    'Given a table definition with partitionBy and method list',
    () {
      test(
        'when generating SQL then PARTITION BY LIST is generated.',
        () {
          var table = TableDefinitionBuilder()
              .withName('example')
              .withPartitionBy(['source'])
              .withPartitionMethod(PartitionMethod.list)
              .build();

          var sql = table.tableCreationToPgsql();

          expect(sql, contains('PARTITION BY LIST ("source")'));
        },
      );
    },
  );

  group(
    'Given a table definition with partitionBy and method range',
    () {
      test(
        'when generating SQL then PARTITION BY RANGE is generated.',
        () {
          var table = TableDefinitionBuilder()
              .withName('example')
              .withPartitionBy(['created'])
              .withPartitionMethod(PartitionMethod.range)
              .build();

          var sql = table.tableCreationToPgsql();

          expect(sql, contains('PARTITION BY RANGE ("created")'));
        },
      );
    },
  );

  group(
    'Given a table definition with partitionBy and method hash',
    () {
      test(
        'when generating SQL then PARTITION BY HASH is generated.',
        () {
          var table = TableDefinitionBuilder()
              .withName('example')
              .withPartitionBy(['userId'])
              .withPartitionMethod(PartitionMethod.hash)
              .build();

          var sql = table.tableCreationToPgsql();

          expect(sql, contains('PARTITION BY HASH ("userId")'));
        },
      );
    },
  );
}
