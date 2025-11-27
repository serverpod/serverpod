import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given Double column definition', () {
    group('with no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'doubleDefault',
        columnType: ColumnType.doublePrecision,
        isNullable: false,
        dartType: 'double',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should not have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"doubleDefault" double precision NOT NULL',
          );
        },
      );
    });

    group('with 10.5 as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'doubleDefault',
        columnType: ColumnType.doublePrecision,
        isNullable: false,
        columnDefault: '10.5',
        dartType: 'double',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"doubleDefault" double precision NOT NULL DEFAULT 10.5',
          );
        },
      );
    });

    group('with 20.5 as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'doubleDefault',
        columnType: ColumnType.doublePrecision,
        isNullable: false,
        columnDefault: '20.5',
        dartType: 'double',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"doubleDefault" double precision NOT NULL DEFAULT 20.5',
          );
        },
      );
    });

    group('with nullable column and no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'doubleDefault',
        columnType: ColumnType.doublePrecision,
        isNullable: true,
        dartType: 'double',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with no default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"doubleDefault" double precision',
          );
        },
      );
    });

    group('with nullable column and 10.5 as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'doubleDefault',
        columnType: ColumnType.doublePrecision,
        isNullable: true,
        columnDefault: '10.5',
        dartType: 'double',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"doubleDefault" double precision DEFAULT 10.5',
          );
        },
      );
    });

    group('with nullable column and 20.5 as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'doubleDefault',
        columnType: ColumnType.doublePrecision,
        isNullable: true,
        columnDefault: '20.5',
        dartType: 'double',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"doubleDefault" double precision DEFAULT 20.5',
          );
        },
      );
    });
  });
}
