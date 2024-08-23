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

      group('with "byName1" as default value', () {
        ColumnDefinition defaultColumn = ColumnDefinition(
          name: 'byNameEnumDefault',
          columnType: ColumnType.text,
          isNullable: false,
          columnDefault: "'byName1'::text",
          dartType: 'String',
        );

        test(
          'when converting to PostgreSQL SQL code, then it should have the default value',
          () {
            expect(
              defaultColumn.toPgSqlFragment(),
              '"byNameEnumDefault" text NOT NULL DEFAULT \'byName1\'::text',
            );
          },
        );
      });

      group('with "byName2" as default value', () {
        ColumnDefinition defaultColumn = ColumnDefinition(
          name: 'byNameEnumDefault',
          columnType: ColumnType.text,
          isNullable: false,
          columnDefault: "'byName2'::text",
          dartType: 'String',
        );

        test(
          'when converting to PostgreSQL SQL code, then it should have the default value',
          () {
            expect(
              defaultColumn.toPgSqlFragment(),
              '"byNameEnumDefault" text NOT NULL DEFAULT \'byName2\'::text',
            );
          },
        );
      });

      group('with nullable column and no default value', () {
        ColumnDefinition defaultColumn = ColumnDefinition(
          name: 'byNameEnumDefaultNull',
          columnType: ColumnType.text,
          isNullable: true,
          dartType: 'String',
        );

        test(
          'when converting to PostgreSQL SQL code, then it should be nullable with no default value',
          () {
            expect(
              defaultColumn.toPgSqlFragment(),
              '"byNameEnumDefaultNull" text',
            );
          },
        );
      });

      group('with nullable column and "byName1" as default value', () {
        ColumnDefinition defaultColumn = ColumnDefinition(
          name: 'byNameEnumDefaultNull',
          columnType: ColumnType.text,
          isNullable: true,
          columnDefault: "'byName1'::text",
          dartType: 'String',
        );

        test(
          'when converting to PostgreSQL SQL code, then it should be nullable with the default value',
          () {
            expect(
              defaultColumn.toPgSqlFragment(),
              '"byNameEnumDefaultNull" text DEFAULT \'byName1\'::text',
            );
          },
        );
      });

      group('with nullable column and "byName2" as default value', () {
        ColumnDefinition defaultColumn = ColumnDefinition(
          name: 'byNameEnumDefaultNull',
          columnType: ColumnType.text,
          isNullable: true,
          columnDefault: "'byName2'::text",
          dartType: 'String',
        );

        test(
          'when converting to PostgreSQL SQL code, then it should be nullable with the default value',
          () {
            expect(
              defaultColumn.toPgSqlFragment(),
              '"byNameEnumDefaultNull" text DEFAULT \'byName2\'::text',
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
          'when converting to PostgreSQL SQL code, then it should have the default value',
          () {
            expect(
              defaultColumn.toPgSqlFragment(),
              '"byIndexEnumDefault" bigint NOT NULL DEFAULT 0',
            );
          },
        );
      });

      group('with 1 as default value', () {
        ColumnDefinition defaultColumn = ColumnDefinition(
          name: 'byIndexEnumDefault',
          columnType: ColumnType.bigint,
          isNullable: false,
          columnDefault: '1',
          dartType: 'int',
        );

        test(
          'when converting to PostgreSQL SQL code, then it should have the default value',
          () {
            expect(
              defaultColumn.toPgSqlFragment(),
              '"byIndexEnumDefault" bigint NOT NULL DEFAULT 1',
            );
          },
        );
      });

      group('with nullable column and no default value', () {
        ColumnDefinition defaultColumn = ColumnDefinition(
          name: 'byIndexEnumDefaultNull',
          columnType: ColumnType.bigint,
          isNullable: true,
          dartType: 'int',
        );

        test(
          'when converting to PostgreSQL SQL code, then it should be nullable with no default value',
          () {
            expect(
              defaultColumn.toPgSqlFragment(),
              '"byIndexEnumDefaultNull" bigint',
            );
          },
        );
      });

      group('with nullable column and 0 as default value', () {
        ColumnDefinition defaultColumn = ColumnDefinition(
          name: 'byIndexEnumDefaultNull',
          columnType: ColumnType.bigint,
          isNullable: true,
          columnDefault: '0',
          dartType: 'int',
        );

        test(
          'when converting to PostgreSQL SQL code, then it should be nullable with the default value',
          () {
            expect(
              defaultColumn.toPgSqlFragment(),
              '"byIndexEnumDefaultNull" bigint DEFAULT 0',
            );
          },
        );
      });

      group('with nullable column and 1 as default value', () {
        ColumnDefinition defaultColumn = ColumnDefinition(
          name: 'byIndexEnumDefaultNull',
          columnType: ColumnType.bigint,
          isNullable: true,
          columnDefault: '1',
          dartType: 'int',
        );

        test(
          'when converting to PostgreSQL SQL code, then it should be nullable with the default value',
          () {
            expect(
              defaultColumn.toPgSqlFragment(),
              '"byIndexEnumDefaultNull" bigint DEFAULT 1',
            );
          },
        );
      });
    });
  });
}
