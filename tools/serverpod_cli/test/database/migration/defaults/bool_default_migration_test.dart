import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/database/column_definition_builder.dart';
import '../../../test_util/builders/database/database_definition_builder.dart';
import '../../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group('Given a database table definition with a boolean column', () {
    test(
      'when generating SQL with a specific boolean default value (TRUE), then the table should have the correct default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('boolDefault')
                        .withColumnType(ColumnType.boolean)
                        .withColumnDefault('true')
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"boolDefault" boolean NOT NULL DEFAULT true',
          ),
        );
      },
    );

    test(
      'when generating SQL with a specific boolean default value (FALSE), then the table should have the correct default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('boolDefault')
                        .withColumnType(ColumnType.boolean)
                        .withColumnDefault('false')
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"boolDefault" boolean NOT NULL DEFAULT false',
          ),
        );
      },
    );

    test(
      'when generating SQL with no columnDefault, then the table should not have a default value for the boolean field.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('boolDefault')
                        .withColumnType(ColumnType.boolean)
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"boolDefault" boolean NOT NULL',
          ),
        );
        expect(
          sql,
          isNot(contains('DEFAULT')),
        );
      },
    );

    test(
      'when generating SQL with nullable boolean field and columnDefault (TRUE), then the table should be nullable with the correct default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('boolDefault')
                        .withColumnType(ColumnType.boolean)
                        .withIsNullable(true)
                        .withColumnDefault('true')
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"boolDefault" boolean DEFAULT true',
          ),
        );
      },
    );

    test(
      'when generating SQL with nullable boolean field and columnDefault (FALSE), then the table should be nullable with the correct default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('boolDefault')
                        .withColumnType(ColumnType.boolean)
                        .withIsNullable(true)
                        .withColumnDefault('false')
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(
          sql,
          contains(
            '"boolDefault" boolean DEFAULT false',
          ),
        );
      },
    );

    test(
      'when generating SQL with nullable boolean field and no columnDefault, then the table should be nullable with no default value.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('boolDefault')
                        .withColumnType(ColumnType.boolean)
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
            '"boolDefault" boolean',
          ),
        );
        expect(
          sql,
          isNot(contains('DEFAULT')),
        );
      },
    );
  });

  group('Given a SQLite database table definition with a boolean column ', () {
    test(
      'when generating SQL with boolean default TRUE, then INTEGER uses 1.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('boolDefault')
                        .withColumnType(ColumnType.boolean)
                        .withColumnDefault('true')
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
            '"boolDefault" INTEGER NOT NULL DEFAULT (1)',
          ),
        );
      },
    );

    test(
      'when generating SQL with boolean default FALSE, then INTEGER uses 0.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('boolDefault')
                        .withColumnType(ColumnType.boolean)
                        .withColumnDefault('false')
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
            '"boolDefault" INTEGER NOT NULL DEFAULT (0)',
          ),
        );
      },
    );

    test(
      'when generating SQL with no columnDefault, then the boolean column has no DEFAULT.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('boolDefault')
                        .withColumnType(ColumnType.boolean)
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toSqliteSql(
          installedModules: databaseDefinition.installedModules,
        );

        expect(sql, contains('"boolDefault" INTEGER NOT NULL'));
        expect(
          sql,
          isNot(contains('"boolDefault" INTEGER NOT NULL DEFAULT')),
        );
      },
    );

    test(
      'when generating SQL with nullable boolean and default TRUE, then the column is nullable with 1.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('boolDefault')
                        .withColumnType(ColumnType.boolean)
                        .withIsNullable(true)
                        .withColumnDefault('true')
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
            '"boolDefault" INTEGER DEFAULT (1)',
          ),
        );
      },
    );

    test(
      'when generating SQL with nullable boolean and default FALSE, then the column is nullable with 0.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('boolDefault')
                        .withColumnType(ColumnType.boolean)
                        .withIsNullable(true)
                        .withColumnDefault('false')
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
            '"boolDefault" INTEGER DEFAULT (0)',
          ),
        );
      },
    );

    test(
      'when generating SQL with nullable boolean and no columnDefault, then the column has no DEFAULT.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(
              TableDefinitionBuilder()
                  .withName('example_table')
                  .withColumn(
                    ColumnDefinitionBuilder()
                        .withName('boolDefault')
                        .withColumnType(ColumnType.boolean)
                        .withIsNullable(true)
                        .build(),
                  )
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toSqliteSql(
          installedModules: databaseDefinition.installedModules,
        );

        expect(sql, contains('"boolDefault" INTEGER\n'));
        expect(sql, isNot(contains('"boolDefault" INTEGER DEFAULT')));
      },
    );
  });
}
