import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/database/column_definition_builder.dart';
import '../../../test_util/builders/database/database_definition_builder.dart';
import '../../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group('Given a database table definition with a string column', () {
    test(
      'when generating SQL with a specific string default value, then the table should have the correct default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('stringDefault')
                        .withColumnType(ColumnType.text)
                        .withColumnDefault('\'This is a default value\'')
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"stringDefault" text NOT NULL DEFAULT \'This is a default value\'',
          ),
        );
      },
    );

    test(
      'when generating SQL with another specific string default value, then the table should have the correct default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('stringDefault')
                        .withColumnType(ColumnType.text)
                        .withColumnDefault('\'Another default value\'')
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"stringDefault" text NOT NULL DEFAULT \'Another default value\'',
          ),
        );
      },
    );

    test(
      'when generating SQL with no columnDefault, then the table should not have a default value for the string field.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('stringDefault')
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
            '"stringDefault" text NOT NULL',
          ),
        );
        expect(
          sql,
          isNot(contains('DEFAULT')),
        );
      },
    );

    test(
      'when generating SQL with nullable string field and columnDefault, then the table should be nullable with the correct default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('stringDefault')
                        .withColumnType(ColumnType.text)
                        .withIsNullable(true)
                        .withColumnDefault('\'This is a default value\'')
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"stringDefault" text DEFAULT \'This is a default value\'',
          ),
        );
      },
    );

    test(
      'when generating SQL with nullable string field and no columnDefault, then the table should be nullable with no default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('stringDefault')
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
            '"stringDefault" text',
          ),
        );
        expect(
          sql,
          isNot(contains('DEFAULT')),
        );
      },
    );
  });
}
