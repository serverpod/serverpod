import 'package:serverpod_cli/src/database/dialects/sqlite.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

List<DatabaseMigrationVersionModel> _modules(DatabaseDefinition def) => [
  DatabaseMigrationVersionModel(
    module: def.moduleName,
    version: '00000000000000',
  ),
];

void main() {
  group('Given a table with a decimal column without precision,', () {
    final db = DatabaseDefinitionBuilder()
        .withTable(
          TableDefinitionBuilder()
              .withName('prices')
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName('amount')
                    .withColumnType(ColumnType.decimal)
                    .withIsNullable(false)
                    .build(),
              )
              .build(),
        )
        .build();

    late final String sql;
    setUpAll(() {
      sql = db.toSqliteSql(installedModules: _modules(db));
    });

    test(
      'when SQLite DDL is generated, then the amount column is declared TEXT NOT NULL',
      () {
        expect(sql, contains('"amount" TEXT NOT NULL'));
      },
    );

    test(
      'when the metadata table is populated, then precision and scale are NULL',
      () {
        expect(
          sql,
          contains("('prices', 'amount', 'decimal', NULL, NULL, NULL)"),
        );
      },
    );
  });

  group('Given a table with a decimal column with precision and scale,', () {
    final db = DatabaseDefinitionBuilder()
        .withTable(
          TableDefinitionBuilder()
              .withName('prices')
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName('amount')
                    .withColumnType(ColumnType.decimal)
                    .withDecimalPrecision(10)
                    .withDecimalScale(2)
                    .withIsNullable(false)
                    .build(),
              )
              .build(),
        )
        .build();

    late final String sql;
    setUpAll(() {
      sql = db.toSqliteSql(installedModules: _modules(db));
    });

    test(
      'when the metadata table is populated, then precision and scale are recorded',
      () {
        expect(
          sql,
          contains("('prices', 'amount', 'decimal', NULL, 10, 2)"),
        );
      },
    );

    test(
      'when the metadata table DDL is emitted, then it declares decimal precision and scale columns',
      () {
        expect(sql, contains('"column_decimal_precision" INTEGER'));
        expect(sql, contains('"column_decimal_scale" INTEGER'));
      },
    );
  });
}
