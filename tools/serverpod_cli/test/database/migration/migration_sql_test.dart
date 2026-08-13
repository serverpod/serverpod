import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  test(
    'Given database table definition, '
    'when generating sql, '
    'then table id column uses bigserial type.',
    () {
      var databaseDefinition = DatabaseDefinitionBuilder()
          .withTable(
            TableDefinitionBuilder().withName('example_table').build(),
          )
          .build();

      var sql = databaseDefinition.toPgSql(installedModules: []);

      expect(sql, contains('"id" bigserial PRIMARY KEY'));
    },
  );

  for (var (idType, definitionContains) in [
    (SupportedIdType.int, '"id" bigserial PRIMARY KEY'),
    (SupportedIdType.uuidV4, '"id" uuid PRIMARY KEY DEFAULT gen_random_uuid()'),
    (
      SupportedIdType.uuidV7,
      '"id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7()',
    ),
  ]) {
    test(
      'Given database table definition, '
      'when generating sql with id set to ${idType.aliases.first}, '
      'then table id column contains $definitionContains.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withTable(
              TableDefinitionBuilder()
                  .withIdType(idType)
                  .withName('example_table')
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toPgSql(installedModules: []);

        expect(sql, contains(definitionContains));
      },
    );
  }

  test(
    'Given SQLite database table definition, '
    'when generating SQL for SQLite, '
    'then table id column uses INTEGER PRIMARY KEY.',
    () {
      var databaseDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder().withName('example_table').build(),
          )
          .build();

      var sql = databaseDefinition.toSqliteSql(
        installedModules: databaseDefinition.installedModules,
      );

      expect(sql, contains('"id" INTEGER PRIMARY KEY'));
    },
  );

  test(
    'Given database table definition with a serial int column, '
    'when generating PostgreSQL SQL, '
    'then the column uses bigserial without an explicit sequence.',
    () {
      const tableName = 'example_table';
      const columnName = 'syncVersion';

      var serialColumn = ColumnDefinitionBuilder()
          .withName(columnName)
          .withColumnType(ColumnType.bigint)
          .withIsNullable(false)
          .withColumnDefault(defaultIntSerial)
          .withDartType('int?')
          .build();

      var databaseDefinition = DatabaseDefinitionBuilder()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withColumn(serialColumn)
                .build(),
          )
          .build();

      var sql = databaseDefinition.toPgSql(installedModules: []);

      expect(sql, contains('"syncVersion" bigserial NOT NULL'));
      expect(sql, isNot(contains('CREATE SEQUENCE')));
      expect(sql, isNot(contains('nextval')));
    },
  );

  test(
    'Given a SQLite database table definition with a serial int column, '
    'when generating SQL for SQLite, '
    'then the unsupported dialect configuration is rejected.',
    () {
      var databaseDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName('example_table')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('syncVersion')
                      .withColumnType(ColumnType.bigint)
                      .withIsNullable(false)
                      .withColumnDefault(defaultIntSerial)
                      .withDartType('int?')
                      .build(),
                )
                .build(),
          )
          .build();

      expect(
        () => databaseDefinition.toSqliteSql(
          installedModules: databaseDefinition.installedModules,
        ),
        throwsA(
          isA<MigrationUnsupportedByDialectException>()
              .having((error) => error.dialect, 'dialect', 'sqlite')
              .having(
                (error) => error.reason,
                'reason',
                'Column "syncVersion" on table "example_table" uses "serial" '
                    'as its default value, but "sqlite" only supports '
                    'auto-increment on the "id" column.',
              ),
        ),
      );
    },
  );

  for (var (idType, definitionContains) in [
    (SupportedIdType.int, '"id" INTEGER PRIMARY KEY'),
    (
      SupportedIdType.uuidV4,
      '"id" BLOB PRIMARY KEY DEFAULT (unhex(hex(randomblob(6)) || \'4\' || substr(hex(randomblob(2)), 2, 3) || substr(\'89AB\', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15)))',
    ),
    (
      SupportedIdType.uuidV7,
      '"id" BLOB PRIMARY KEY DEFAULT (unhex(printf(\'%012x\', CAST(unixepoch(\'now\', \'subsecond\') * 1000 AS INTEGER)) || \'7\' || substr(hex(randomblob(2)), 2, 3) || substr(\'89AB\', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15)))',
    ),
  ]) {
    test(
      'Given SQLite database table definition, '
      'when generating SQL for SQLite with id set to ${idType.aliases.first}, '
      'then the table id column contains expected fragment.',
      () {
        var databaseDefinition = DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(
              TableDefinitionBuilder()
                  .withIdType(idType)
                  .withName('example_table')
                  .build(),
            )
            .build();

        var sql = databaseDefinition.toSqliteSql(
          installedModules: databaseDefinition.installedModules,
        );

        expect(sql, contains(definitionContains));
      },
    );
  }

  test(
    'Given SQLite definition where the last table ends with a basic column after non-basic columns, '
    'when generating SQL for SQLite, '
    'then the serverpod_sqlite_schema VALUES list terminates the last row with a semicolon.',
    () {
      var databaseDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            // The id is a non-basic column and the default text name column is
            // the basic column that should be skipped.
            TableDefinitionBuilder()
                .withName('z_last_table')
                .withIdType(SupportedIdType.uuidV4)
                .build(),
          )
          .build();

      var sql = databaseDefinition.toSqliteSql(
        installedModules: databaseDefinition.installedModules,
      );

      expect(
        sql,
        contains("('z_last_table', 'id', 'uuid', NULL);"),
        reason: 'Must close VALUES with ";" to be valid SQL.',
      );
      expect(
        sql,
        isNot(contains("('z_last_table', 'id', 'uuid', NULL),")),
        reason: 'Trailing "," after the final row is invalid SQL.',
      );
    },
  );
}
