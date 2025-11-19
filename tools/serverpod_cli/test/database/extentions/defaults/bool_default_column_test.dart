import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given Boolean column definition', () {
    group('with no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'boolDefault',
        columnType: ColumnType.boolean,
        isNullable: false,
        dartType: 'bool',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should not have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"boolDefault" boolean NOT NULL',
          );
        },
      );
    });

    group('with TRUE as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'boolDefault',
        columnType: ColumnType.boolean,
        isNullable: false,
        columnDefault: 'true',
        dartType: 'bool',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"boolDefault" boolean NOT NULL DEFAULT true',
          );
        },
      );
    });

    group('with FALSE as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'boolDefault',
        columnType: ColumnType.boolean,
        isNullable: false,
        columnDefault: 'false',
        dartType: 'bool',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"boolDefault" boolean NOT NULL DEFAULT false',
          );
        },
      );
    });

    group('with nullable column and no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'boolDefault',
        columnType: ColumnType.boolean,
        isNullable: true,
        dartType: 'bool',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with no default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"boolDefault" boolean',
          );
        },
      );
    });

    group('with nullable column and TRUE as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'boolDefault',
        columnType: ColumnType.boolean,
        isNullable: true,
        columnDefault: 'true',
        dartType: 'bool',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"boolDefault" boolean DEFAULT true',
          );
        },
      );
    });

    group('with nullable column and FALSE as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'boolDefault',
        columnType: ColumnType.boolean,
        isNullable: true,
        columnDefault: 'false',
        dartType: 'bool',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"boolDefault" boolean DEFAULT false',
          );
        },
      );
    });
  });
}
