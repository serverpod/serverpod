import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given Decimal column definition with precision and scale', () {
    group('with Decimal(10,2) and no default value', () {
      ColumnDefinition column = ColumnDefinition(
        name: 'price',
        columnType: ColumnType.decimal,
        isNullable: false,
        dartType: 'Decimal(10,2)',
        decimalPrecision: 10,
        decimalScale: 2,
      );

      test(
        'when converting to PostgreSQL SQL code, then it should generate decimal(10,2) NOT NULL.',
        () {
          expect(
            column.toPgSqlFragment(),
            '"price" decimal(10,2) NOT NULL',
          );
        },
      );
    });

    group('with unbounded Decimal and no default value', () {
      ColumnDefinition column = ColumnDefinition(
        name: 'amount',
        columnType: ColumnType.decimal,
        isNullable: false,
        dartType: 'Decimal',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should generate decimal NOT NULL.',
        () {
          expect(
            column.toPgSqlFragment(),
            '"amount" decimal NOT NULL',
          );
        },
      );
    });

    group('with Decimal(10,2) and 10.5 as default value', () {
      ColumnDefinition column = ColumnDefinition(
        name: 'price',
        columnType: ColumnType.decimal,
        isNullable: false,
        columnDefault: '10.5',
        dartType: 'Decimal(10,2)',
        decimalPrecision: 10,
        decimalScale: 2,
      );

      test(
        'when converting to PostgreSQL SQL code, then it should generate decimal(10,2) NOT NULL DEFAULT 10.5.',
        () {
          expect(
            column.toPgSqlFragment(),
            '"price" decimal(10,2) NOT NULL DEFAULT 10.5',
          );
        },
      );
    });

    group('with nullable Decimal(10,2) and no default value', () {
      ColumnDefinition column = ColumnDefinition(
        name: 'price',
        columnType: ColumnType.decimal,
        isNullable: true,
        dartType: 'Decimal(10,2)?',
        decimalPrecision: 10,
        decimalScale: 2,
      );

      test(
        'when converting to PostgreSQL SQL code, then it should generate decimal(10,2) without NOT NULL.',
        () {
          expect(
            column.toPgSqlFragment(),
            '"price" decimal(10,2)',
          );
        },
      );
    });

    group('with nullable unbounded Decimal and no default value', () {
      ColumnDefinition column = ColumnDefinition(
        name: 'amount',
        columnType: ColumnType.decimal,
        isNullable: true,
        dartType: 'Decimal?',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should generate decimal without NOT NULL.',
        () {
          expect(
            column.toPgSqlFragment(),
            '"amount" decimal',
          );
        },
      );
    });

    group('with nullable Decimal(10,2) and 99.99 as default value', () {
      ColumnDefinition column = ColumnDefinition(
        name: 'price',
        columnType: ColumnType.decimal,
        isNullable: true,
        columnDefault: '99.99',
        dartType: 'Decimal(10,2)?',
        decimalPrecision: 10,
        decimalScale: 2,
      );

      test(
        'when converting to PostgreSQL SQL code, then it should generate nullable decimal(10,2) with default.',
        () {
          expect(
            column.toPgSqlFragment(),
            '"price" decimal(10,2) DEFAULT 99.99',
          );
        },
      );
    });

    group('with Decimal(19,4) precision 19 scale 4', () {
      ColumnDefinition column = ColumnDefinition(
        name: 'quantity',
        columnType: ColumnType.decimal,
        isNullable: false,
        dartType: 'Decimal(19,4)',
        decimalPrecision: 19,
        decimalScale: 4,
      );

      test(
        'when converting to PostgreSQL SQL code, then it should generate decimal(19,4) NOT NULL.',
        () {
          expect(
            column.toPgSqlFragment(),
            '"quantity" decimal(19,4) NOT NULL',
          );
        },
      );
    });

    group('with Decimal(5,0) precision only (scale 0)', () {
      ColumnDefinition column = ColumnDefinition(
        name: 'count',
        columnType: ColumnType.decimal,
        isNullable: false,
        dartType: 'Decimal(5,0)',
        decimalPrecision: 5,
        decimalScale: 0,
      );

      test(
        'when converting to PostgreSQL SQL code, then it should generate decimal(5,0) NOT NULL.',
        () {
          expect(
            column.toPgSqlFragment(),
            '"count" decimal(5,0) NOT NULL',
          );
        },
      );
    });
  });
}
