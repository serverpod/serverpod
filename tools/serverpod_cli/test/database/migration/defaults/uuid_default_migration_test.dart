import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/database/column_definition_builder.dart';
import '../../../test_util/builders/database/database_definition_builder.dart';
import '../../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group('Given a database table definition with a UUID column', () {
    test(
      'when generating SQL with a specific UUID default value, then the table should have the correct default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('uuid')
                        .withColumnType(ColumnType.uuid)
                        .withColumnDefault(
                          "'550e8400-e29b-41d4-a716-446655440000'::uuid",
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
            '"uuid" uuid NOT NULL DEFAULT \'550e8400-e29b-41d4-a716-446655440000\'::uuid',
          ),
        );
      },
    );

    test(
      'when generating SQL with no columnDefault, then the table should not have a default value for the UUID field.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('uuid')
                        .withColumnType(ColumnType.uuid)
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"uuid" uuid NOT NULL',
          ),
        );
        expect(
          sql,
          isNot(contains('DEFAULT')),
        );
      },
    );

    test(
      'when generating SQL with columnDefault set to "gen_random_uuid()", then the table should have gen_random_uuid() as the default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('uuid')
                        .withColumnType(ColumnType.uuid)
                        .withColumnDefault('gen_random_uuid()')
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"uuid" uuid NOT NULL DEFAULT gen_random_uuid()',
          ),
        );
      },
    );

    test(
      'when generating SQL with columnDefault set to "gen_random_uuid_v7()", then the table should have gen_random_uuid_v7() as the default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('uuid')
                        .withColumnType(ColumnType.uuid)
                        .withColumnDefault('gen_random_uuid_v7()')
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"uuid" uuid NOT NULL DEFAULT gen_random_uuid_v7()',
          ),
        );
      },
    );

    test(
      'when generating SQL with nullable UUID field and columnDefault, then the table should be nullable with the correct default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('uuid')
                        .withColumnType(ColumnType.uuid)
                        .withIsNullable(true)
                        .withColumnDefault(
                          "'550e8400-e29b-41d4-a716-446655440000'::uuid",
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
            '"uuid" uuid DEFAULT \'550e8400-e29b-41d4-a716-446655440000\'::uuid',
          ),
        );
      },
    );

    test(
      'when generating SQL with nullable UUID field and no columnDefault, then the table should be nullable with no default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('uuid')
                        .withColumnType(ColumnType.uuid)
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
            '"uuid" uuid',
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
