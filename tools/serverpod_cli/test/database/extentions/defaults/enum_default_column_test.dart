import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given Enum column definition', () {
    group('with byName (text) representation', () {
      group('with no default value', () {
        ColumnDefinition defaultColumn = ColumnDefinition(
          name: 'byNameEnumDefault',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        );

        test(
          'when converting to PostgreSQL SQL code, then it should not have the default value',
          () {
            expect(
              defaultColumn.toPgSqlFragment(),
              '"byNameEnumDefault" text NOT NULL',
            );
          },
        );
      });

      group('with a specific default value', () {
        test(
          'when "byName1" is set as default, then it should be correctly reflected in the SQL code',
          () {
            ColumnDefinition defaultColumn = ColumnDefinition(
              name: 'byNameEnumDefault',
              columnType: ColumnType.text,
              isNullable: false,
              columnDefault: "'byName1'::text",
              dartType: 'String',
            );

            expect(
              defaultColumn.toPgSqlFragment(),
              '"byNameEnumDefault" text NOT NULL DEFAULT \'byName1\'::text',
            );
          },
        );
      });

      group('with nullable column and specific default values', () {
        test(
          'when nullable with no default value, then it should not have any default in the SQL code',
          () {
            ColumnDefinition defaultColumn = ColumnDefinition(
              name: 'byNameEnumDefaultNull',
              columnType: ColumnType.text,
              isNullable: true,
              dartType: 'String',
            );

            expect(
              defaultColumn.toPgSqlFragment(),
              '"byNameEnumDefaultNull" text',
            );
          },
        );

        test(
          'when nullable with "byName1" as default, then it should be correctly reflected in the SQL code',
          () {
            ColumnDefinition defaultColumn = ColumnDefinition(
              name: 'byNameEnumDefaultNull',
              columnType: ColumnType.text,
              isNullable: true,
              columnDefault: "'byName1'::text",
              dartType: 'String',
            );

            expect(
              defaultColumn.toPgSqlFragment(),
              '"byNameEnumDefaultNull" text DEFAULT \'byName1\'::text',
            );
          },
        );
      });
    });

    group('with byIndex (integer) representation', () {
      group('with no default value', () {
        ColumnDefinition defaultColumn = ColumnDefinition(
          name: 'byIndexEnumDefault',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        );

        test(
          'when converting to PostgreSQL SQL code, then it should not have the default value',
          () {
            expect(
              defaultColumn.toPgSqlFragment(),
              '"byIndexEnumDefault" bigint NOT NULL',
            );
          },
        );
      });

      group('with 0 as default value', () {
        ColumnDefinition defaultColumn = ColumnDefinition(
          name: 'byIndexEnumDefault',
          columnType: ColumnType.bigint,
          isNullable: false,
          columnDefault: '0',
          dartType: 'int',
        );

        test(
          'when converting to PostgreSQL SQL code, then it should have the correct default value',
          () {
            expect(
              defaultColumn.toPgSqlFragment(),
              '"byIndexEnumDefault" bigint NOT NULL DEFAULT 0',
            );
          },
        );
      });
    });
  });
}
