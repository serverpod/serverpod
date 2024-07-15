import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given Boolean column definition', () {
    group('with TRUE as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'boolDefault',
        columnType: ColumnType.boolean,
        isNullable: false,
        columnDefault: 'TRUE',
        dartType: 'bool',
      );

      test(
          'when converting to PostgreSQL SQL code, then it should have the default value',
          () {
        expect(
          defaultColumn.toPgSqlFragment(),
          '"boolDefault" boolean NOT NULL DEFAULT TRUE',
        );
      });
    });

    group('with FALSE as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'boolDefault',
        columnType: ColumnType.boolean,
        isNullable: false,
        columnDefault: 'FALSE',
        dartType: 'bool',
      );

      test(
          'when converting to PostgreSQL SQL code, then it should have the default value',
          () {
        expect(
          defaultColumn.toPgSqlFragment(),
          '"boolDefault" boolean NOT NULL DEFAULT FALSE',
        );
      });
    });

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
      });
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
      });
    });

    group('with nullable column and TRUE as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'boolDefault',
        columnType: ColumnType.boolean,
        isNullable: true,
        columnDefault: 'TRUE',
        dartType: 'bool',
      );

      test(
          'when converting to PostgreSQL SQL code, then it should be nullable with the default value',
          () {
        expect(
          defaultColumn.toPgSqlFragment(),
          '"boolDefault" boolean DEFAULT TRUE',
        );
      });
    });

    group('with nullable column and FALSE as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'boolDefault',
        columnType: ColumnType.boolean,
        isNullable: true,
        columnDefault: 'FALSE',
        dartType: 'bool',
      );

      test(
          'when converting to PostgreSQL SQL code, then it should be nullable with the default value',
          () {
        expect(
          defaultColumn.toPgSqlFragment(),
          '"boolDefault" boolean DEFAULT FALSE',
        );
      });
    });
  });
}
