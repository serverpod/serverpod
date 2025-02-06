import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given BigInt column definition', () {
    group('with no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'bigint',
        columnType: ColumnType.text,
        isNullable: false,
        dartType: 'BigInt',
      );

      test(
          'when converting to PostgreSQL SQL code, then it should not have the default value',
          () {
        expect(
          defaultColumn.toPgSqlFragment(),
          '"bigint" text NOT NULL',
        );
      });
    });

    group('with a specific BigInt string as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'bigint',
        columnType: ColumnType.text,
        isNullable: false,
        columnDefault: "'-13837646363612912343'::text",
        dartType: 'BigInt',
      );

      test(
          'when converting to PostgreSQL SQL code, then it should have the default value',
          () {
        expect(
          defaultColumn.toPgSqlFragment(),
          '"bigint" text NOT NULL DEFAULT \'-13837646363612912343\'::text',
        );
      });
    });

    group('with nullable column and no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'bigint',
        columnType: ColumnType.text,
        isNullable: true,
        dartType: 'BigInt',
      );

      test(
          'when converting to PostgreSQL SQL code, then it should be nullable with no default value',
          () {
        expect(
          defaultColumn.toPgSqlFragment(),
          '"bigint" text',
        );
      });
    });
  });
}
