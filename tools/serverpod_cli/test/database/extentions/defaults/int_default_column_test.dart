import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given Integer column definition', () {
    group('with no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'intDefault',
        columnType: ColumnType.integer,
        isNullable: false,
        dartType: 'int',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should not have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"intDefault" integer NOT NULL',
          );
        },
      );
    });

    group('with 10 as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'intDefault',
        columnType: ColumnType.integer,
        isNullable: false,
        columnDefault: '10',
        dartType: 'int',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"intDefault" integer NOT NULL DEFAULT 10',
          );
        },
      );
    });

    group('with 20 as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'intDefault',
        columnType: ColumnType.integer,
        isNullable: false,
        columnDefault: '20',
        dartType: 'int',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"intDefault" integer NOT NULL DEFAULT 20',
          );
        },
      );
    });

    group('with nullable column and no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'intDefault',
        columnType: ColumnType.integer,
        isNullable: true,
        dartType: 'int',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with no default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"intDefault" integer',
          );
        },
      );
    });

    group('with nullable column and 10 as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'intDefault',
        columnType: ColumnType.integer,
        isNullable: true,
        columnDefault: '10',
        dartType: 'int',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"intDefault" integer DEFAULT 10',
          );
        },
      );
    });

    group('with nullable column and 20 as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'intDefault',
        columnType: ColumnType.integer,
        isNullable: true,
        columnDefault: '20',
        dartType: 'int',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"intDefault" integer DEFAULT 20',
          );
        },
      );
    });
  });
}
