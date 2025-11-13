import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/database/column_definition_builder.dart';
import '../../../test_util/builders/database/database_definition_builder.dart';
import '../../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group('Given a database table definition with a DateTime column', () {
    test(
      'when generating SQL with a specific timestamp default value, then the table should have the correct default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('dateTime')
                        .withColumnType(ColumnType.timestampWithoutTimeZone)
                        .withColumnDefault(
                          '\'2024-01-01 01:01:01\'::timestamp without time zone',
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
            '"dateTime" timestamp without time zone NOT NULL DEFAULT \'2024-01-01 01:01:01\'::timestamp without time zone',
          ),
        );
      },
    );

    test(
      'when generating SQL with no columnDefault, then the table should not have a default value for the DateTime field.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('dateTime')
                        .withColumnType(ColumnType.timestampWithoutTimeZone)
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"dateTime" timestamp without time zone NOT NULL',
          ),
        );
        expect(
          sql,
          isNot(contains('DEFAULT')),
        );
      },
    );

    test(
      'when generating SQL with columnDefault set to "CURRENT_TIMESTAMP", then the table should have CURRENT_TIMESTAMP as the default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('dateTime')
                        .withColumnType(ColumnType.timestampWithoutTimeZone)
                        .withColumnDefault('CURRENT_TIMESTAMP')
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"dateTime" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP',
          ),
        );
      },
    );

    test(
      'when generating SQL with nullable DateTime field and columnDefault, then the table should be nullable with the correct default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('dateTime')
                        .withColumnType(ColumnType.timestampWithoutTimeZone)
                        .withIsNullable(true)
                        .withColumnDefault(
                          '\'2024-01-01 01:01:01\'::timestamp without time zone',
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
            '"dateTime" timestamp without time zone DEFAULT \'2024-01-01 01:01:01\'::timestamp without time zone',
          ),
        );
      },
    );

    test(
      'when generating SQL with nullable DateTime field and no columnDefault, then the table should be nullable with no default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('dateTime')
                        .withColumnType(ColumnType.timestampWithoutTimeZone)
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
            '"dateTime" timestamp without time zone',
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
