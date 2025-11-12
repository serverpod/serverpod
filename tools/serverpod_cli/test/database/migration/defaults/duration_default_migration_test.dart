import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/database/column_definition_builder.dart';
import '../../../test_util/builders/database/database_definition_builder.dart';
import '../../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group('Given a database table definition with a Duration column', () {
    test(
      'when generating SQL with a specific Duration default value (94230100ms), then the table should have the correct default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('durationDefault')
                        .withColumnType(ColumnType.bigint)
                        .withColumnDefault('94230100') // milliseconds
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"durationDefault" bigint NOT NULL DEFAULT 94230100',
          ),
        );
      },
    );

    test(
      'when generating SQL with a specific Duration default value (177640100ms), then the table should have the correct default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('durationDefault')
                        .withColumnType(ColumnType.bigint)
                        .withColumnDefault('177640100') // milliseconds
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"durationDefault" bigint NOT NULL DEFAULT 177640100',
          ),
        );
      },
    );

    test(
      'when generating SQL with no columnDefault, then the table should not have a default value for the Duration field.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('durationDefault')
                        .withColumnType(ColumnType.bigint)
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"durationDefault" bigint NOT NULL',
          ),
        );
        expect(
          sql,
          isNot(contains('DEFAULT')),
        );
      },
    );

    test(
      'when generating SQL with nullable Duration field and columnDefault (94230100ms), then the table should be nullable with the correct default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('durationDefault')
                        .withColumnType(ColumnType.bigint)
                        .withIsNullable(true)
                        .withColumnDefault('94230100') // milliseconds
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"durationDefault" bigint DEFAULT 94230100',
          ),
        );
      },
    );

    test(
      'when generating SQL with nullable Duration field and no columnDefault, then the table should be nullable with no default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('durationDefault')
                        .withColumnType(ColumnType.bigint)
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
            '"durationDefault" bigint',
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
