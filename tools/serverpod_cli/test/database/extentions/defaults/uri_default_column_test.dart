import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given Uri column definition', () {
    group('with no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'uriNoDefault',
        columnType: ColumnType.text,
        isNullable: false,
        dartType: 'Uri',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should not have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"uriNoDefault" text NOT NULL',
          );
        },
      );
    });

    group('with "This is a default value" as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'uriDefault',
        columnType: ColumnType.text,
        isNullable: false,
        columnDefault: "'https://serverpod.dev'",
        dartType: 'Uri',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"uriDefault" text NOT NULL DEFAULT \'https://serverpod.dev\'',
          );
        },
      );
    });

    group('with nullable column and no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'uriNullableNoDefault',
        columnType: ColumnType.text,
        isNullable: true,
        dartType: 'Uri',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with no default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"uriNullableNoDefault" text',
          );
        },
      );
    });

    group('with nullable column and a default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'uriNullableDefault',
        columnType: ColumnType.text,
        isNullable: true,
        columnDefault: "'https://serverpod.dev'",
        dartType: 'Uri',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"uriNullableDefault" text DEFAULT \'https://serverpod.dev\'',
          );
        },
      );
    });
  });
}
