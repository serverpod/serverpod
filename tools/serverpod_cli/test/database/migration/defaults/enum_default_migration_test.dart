import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/database/column_definition_builder.dart';
import '../../../test_util/builders/database/database_definition_builder.dart';
import '../../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group('Given a database table definition with an enum column', () {
    group('with byName (text) representation', () {
      test(
        'when generating SQL with a specific enum default value ("byName1"), then the table should have the correct default value.',
        () {
          var databaseDefinition = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example_table')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('byNameEnumDefault')
                          .withColumnType(ColumnType.text)
                          .withColumnDefault("'byName1'")
                          .build(),
                    )
                    .build(),
              )
              .build();

          var sql = databaseDefinition.toPgSql(installedModules: []);

          expect(
            sql,
            contains(
              '"byNameEnumDefault" text NOT NULL DEFAULT \'byName1\'',
            ),
          );
        },
      );

      test(
        'when generating SQL with no columnDefault, then the table should not have a default value for the enum field.',
        () {
          var databaseDefinition = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example_table')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('byNameEnumDefault')
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
              '"byNameEnumDefault" text NOT NULL',
            ),
          );
          expect(
            sql,
            isNot(contains('DEFAULT')),
          );
        },
      );

      test(
        'when generating SQL with nullable enum field and columnDefault ("byName1"), then the table should be nullable with the correct default value.',
        () {
          var databaseDefinition = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example_table')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('byNameEnumDefault')
                          .withColumnType(ColumnType.text)
                          .withIsNullable(true)
                          .withColumnDefault("'byName1'::text")
                          .build(),
                    )
                    .build(),
              )
              .build();

          var sql = databaseDefinition.toPgSql(installedModules: []);

          expect(
            sql,
            contains(
              '"byNameEnumDefault" text DEFAULT \'byName1\'::text',
            ),
          );
        },
      );

      test(
        'when generating SQL with nullable enum field and no columnDefault, then the table should be nullable with no default value.',
        () {
          var databaseDefinition = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example_table')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('byNameEnumDefault')
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
              '"byNameEnumDefault" text',
            ),
          );
          expect(
            sql,
            isNot(contains('DEFAULT')),
          );
        },
      );
    });

    group('with byIndex (integer) representation', () {
      test(
        'when generating SQL with a specific enum index default value (0), then the table should have the correct default value.',
        () {
          var databaseDefinition = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example_table')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('byIndexEnumDefault')
                          .withColumnType(ColumnType.bigint)
                          .withColumnDefault('0')
                          .build(),
                    )
                    .build(),
              )
              .build();

          var sql = databaseDefinition.toPgSql(installedModules: []);

          expect(
            sql,
            contains(
              '"byIndexEnumDefault" bigint NOT NULL DEFAULT 0',
            ),
          );
        },
      );

      test(
        'when generating SQL with no columnDefault, then the table should not have a default value for the enum index field.',
        () {
          var databaseDefinition = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example_table')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('byIndexEnumDefault')
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
              '"byIndexEnumDefault" bigint NOT NULL',
            ),
          );
          expect(
            sql,
            isNot(contains('DEFAULT')),
          );
        },
      );

      test(
        'when generating SQL with nullable enum index field and columnDefault (0), then the table should be nullable with the correct default value.',
        () {
          var databaseDefinition = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example_table')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('byIndexEnumDefault')
                          .withColumnType(ColumnType.bigint)
                          .withIsNullable(true)
                          .withColumnDefault('0')
                          .build(),
                    )
                    .build(),
              )
              .build();

          var sql = databaseDefinition.toPgSql(installedModules: []);

          expect(
            sql,
            contains(
              '"byIndexEnumDefault" bigint DEFAULT 0',
            ),
          );
        },
      );

      test(
        'when generating SQL with nullable enum index field and no columnDefault, then the table should be nullable with no default value.',
        () {
          var databaseDefinition = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example_table')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('byIndexEnumDefault')
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
              '"byIndexEnumDefault" bigint',
            ),
          );
          expect(
            sql,
            isNot(contains('DEFAULT')),
          );
        },
      );
    });

    group(
      'Given a SQLite database table definition with an enum byName (text) column ',
      () {
        test(
          'when generating SQL with a specific enum default value ("byName1"), then TEXT keeps the abstract default expression.',
          () {
            var databaseDefinition = DatabaseDefinitionBuilder()
                .withDefaultModules()
                .withTable(
                  TableDefinitionBuilder()
                      .withName('example_table')
                      .withColumn(
                        ColumnDefinitionBuilder()
                            .withName('byNameEnumDefault')
                            .withColumnType(ColumnType.text)
                            .withColumnDefault("'byName1'")
                            .build(),
                      )
                      .build(),
                )
                .build();

            var sql = databaseDefinition.toSqliteSql(
              installedModules: databaseDefinition.installedModules,
            );

            expect(
              sql,
              contains(
                '"byNameEnumDefault" TEXT NOT NULL DEFAULT (\'byName1\')',
              ),
            );
          },
        );

        test(
          'when generating SQL with no columnDefault, then the enum column has no DEFAULT.',
          () {
            var databaseDefinition = DatabaseDefinitionBuilder()
                .withDefaultModules()
                .withTable(
                  TableDefinitionBuilder()
                      .withName('example_table')
                      .withColumn(
                        ColumnDefinitionBuilder()
                            .withName('byNameEnumDefault')
                            .withColumnType(ColumnType.text)
                            .build(),
                      )
                      .build(),
                )
                .build();

            var sql = databaseDefinition.toSqliteSql(
              installedModules: databaseDefinition.installedModules,
            );

            expect(sql, contains('"byNameEnumDefault" TEXT NOT NULL'));
            expect(
              sql,
              isNot(contains('"byNameEnumDefault" TEXT NOT NULL DEFAULT')),
            );
          },
        );

        test(
          'when generating SQL with nullable enum field and columnDefault ("byName1"), then the column is nullable with default.',
          () {
            var databaseDefinition = DatabaseDefinitionBuilder()
                .withDefaultModules()
                .withTable(
                  TableDefinitionBuilder()
                      .withName('example_table')
                      .withColumn(
                        ColumnDefinitionBuilder()
                            .withName('byNameEnumDefault')
                            .withColumnType(ColumnType.text)
                            .withIsNullable(true)
                            .withColumnDefault("'byName1'")
                            .build(),
                      )
                      .build(),
                )
                .build();

            var sql = databaseDefinition.toSqliteSql(
              installedModules: databaseDefinition.installedModules,
            );

            expect(
              sql,
              contains(
                '"byNameEnumDefault" TEXT DEFAULT (\'byName1\')',
              ),
            );
          },
        );

        test(
          'when generating SQL with nullable enum field and no columnDefault, then the column has no DEFAULT.',
          () {
            var databaseDefinition = DatabaseDefinitionBuilder()
                .withDefaultModules()
                .withTable(
                  TableDefinitionBuilder()
                      .withName('example_table')
                      .withColumn(
                        ColumnDefinitionBuilder()
                            .withName('byNameEnumDefault')
                            .withColumnType(ColumnType.text)
                            .withIsNullable(true)
                            .build(),
                      )
                      .build(),
                )
                .build();

            var sql = databaseDefinition.toSqliteSql(
              installedModules: databaseDefinition.installedModules,
            );

            expect(sql, contains('"byNameEnumDefault" TEXT\n'));
            expect(
              sql,
              isNot(contains('"byNameEnumDefault" TEXT DEFAULT')),
            );
          },
        );
      },
    );

    group('SQLite: enum byIndex (integer)', () {
      test(
        'when generating SQL with a specific enum index default value (0), then INTEGER has numeric default.',
        () {
          var databaseDefinition = DatabaseDefinitionBuilder()
              .withDefaultModules()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example_table')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('byIndexEnumDefault')
                          .withColumnType(ColumnType.bigint)
                          .withColumnDefault('0')
                          .build(),
                    )
                    .build(),
              )
              .build();

          var sql = databaseDefinition.toSqliteSql(
            installedModules: databaseDefinition.installedModules,
          );

          expect(
            sql,
            contains(
              '"byIndexEnumDefault" INTEGER NOT NULL DEFAULT (0)',
            ),
          );
        },
      );

      test(
        'when generating SQL with no columnDefault, then the enum index column has no DEFAULT.',
        () {
          var databaseDefinition = DatabaseDefinitionBuilder()
              .withDefaultModules()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example_table')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('byIndexEnumDefault')
                          .withColumnType(ColumnType.bigint)
                          .build(),
                    )
                    .build(),
              )
              .build();

          var sql = databaseDefinition.toSqliteSql(
            installedModules: databaseDefinition.installedModules,
          );

          expect(sql, contains('"byIndexEnumDefault" INTEGER NOT NULL'));
          expect(
            sql,
            isNot(contains('"byIndexEnumDefault" INTEGER NOT NULL DEFAULT')),
          );
        },
      );

      test(
        'when generating SQL with nullable enum index field and columnDefault (0), then the column is nullable with default.',
        () {
          var databaseDefinition = DatabaseDefinitionBuilder()
              .withDefaultModules()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example_table')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('byIndexEnumDefault')
                          .withColumnType(ColumnType.bigint)
                          .withIsNullable(true)
                          .withColumnDefault('0')
                          .build(),
                    )
                    .build(),
              )
              .build();

          var sql = databaseDefinition.toSqliteSql(
            installedModules: databaseDefinition.installedModules,
          );

          expect(
            sql,
            contains(
              '"byIndexEnumDefault" INTEGER DEFAULT (0)',
            ),
          );
        },
      );

      test(
        'when generating SQL with nullable enum index field and no columnDefault, then the column has no DEFAULT.',
        () {
          var databaseDefinition = DatabaseDefinitionBuilder()
              .withDefaultModules()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example_table')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('byIndexEnumDefault')
                          .withColumnType(ColumnType.bigint)
                          .withIsNullable(true)
                          .build(),
                    )
                    .build(),
              )
              .build();

          var sql = databaseDefinition.toSqliteSql(
            installedModules: databaseDefinition.installedModules,
          );

          expect(sql, contains('"byIndexEnumDefault" INTEGER\n'));
          expect(
            sql,
            isNot(contains('"byIndexEnumDefault" INTEGER DEFAULT')),
          );
        },
      );
    });
  });
}
