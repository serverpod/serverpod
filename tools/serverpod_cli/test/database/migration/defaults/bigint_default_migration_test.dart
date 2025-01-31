import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/test_util/builders/database/column_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/database/database_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/database/table_definition_builder.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given a database table definition with a BigInt column', () {
    test(
        'when generating SQL with a specific BigInt default value, then the table should have the correct default value.',
        () {
      var databaseDefinition = DatabaseDefinitionBuilder()
          .withTable(
            TableDefinitionBuilder()
                .withName('example_table')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('bigint')
                      .withColumnType(ColumnType.text)
                      .withColumnDefault(
                        "'-12345678901234567890'::text",
                      )
                      .build(),
                )
                .build(),
          )
          .build();

      var sql = databaseDefinition.toPgSql(installedModules: []);

      expect(
        sql,
        contains(
          '"bigint" text NOT NULL DEFAULT \'-12345678901234567890\'::text',
        ),
      );
    });

    test(
        'when generating SQL with no columnDefault, then the table should not have a default value for the BigInt field.',
        () {
      var databaseDefinition = DatabaseDefinitionBuilder()
          .withTable(
            TableDefinitionBuilder()
                .withName('example_table')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('bigint')
                      .withColumnType(ColumnType.text)
                      .build(),
                )
                .build(),
          )
          .build();

      var sql = databaseDefinition.toPgSql(installedModules: []);

      expect(
        sql,
        contains(
          '"bigint" text NOT NULL',
        ),
      );
      expect(
        sql,
        isNot(contains('DEFAULT')),
      );
    });

    test(
        'when generating SQL with nullable BigInt field and columnDefault, then the table should be nullable with the correct default value.',
        () {
      var databaseDefinition = DatabaseDefinitionBuilder()
          .withTable(
            TableDefinitionBuilder()
                .withName('example_table')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('bigint')
                      .withColumnType(ColumnType.text)
                      .withIsNullable(true)
                      .withColumnDefault(
                        "'-12345678901234567890'::text",
                      )
                      .build(),
                )
                .build(),
          )
          .build();

      var sql = databaseDefinition.toPgSql(installedModules: []);

      expect(
        sql,
        contains(
          '"bigint" text DEFAULT \'-12345678901234567890\'::text',
        ),
      );
    });

    test(
        'when generating SQL with nullable BigInt field and no columnDefault, then the table should be nullable with no default value.',
        () {
      var databaseDefinition = DatabaseDefinitionBuilder()
          .withTable(
            TableDefinitionBuilder()
                .withName('example_table')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('bigint')
                      .withColumnType(ColumnType.text)
                      .withIsNullable(true)
                      .build(),
                )
                .build(),
          )
          .build();

      var sql = databaseDefinition.toPgSql(installedModules: []);

      expect(
        sql,
        contains(
          '"bigint" text',
        ),
      );
      expect(
        sql,
        isNot(contains('DEFAULT')),
      );
    });
  });
}
