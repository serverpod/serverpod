import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given DateTime column definition', () {
    group('with no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'dateTime',
        columnType: ColumnType.timestampWithoutTimeZone,
        isNullable: false,
        dartType: 'DateTime',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should not have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"dateTime" timestamp without time zone NOT NULL',
          );
        },
      );
    });

    group('with CURRENT_TIMESTAMP as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'dateTime',
        columnType: ColumnType.timestampWithoutTimeZone,
        isNullable: false,
        columnDefault: 'CURRENT_TIMESTAMP',
        dartType: 'DateTime',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"dateTime" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP',
          );
        },
      );
    });

    group('with a specific timestamp as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'dateTime',
        columnType: ColumnType.timestampWithoutTimeZone,
        isNullable: false,
        columnDefault:
            "'2024-01-01T01:01:01.000Z'::timestamp without time zone",
        dartType: 'DateTime',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"dateTime" timestamp without time zone NOT NULL DEFAULT \'2024-01-01T01:01:01.000Z\'::timestamp without time zone',
          );
        },
      );
    });

    group('with nullable column and no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'dateTime',
        columnType: ColumnType.timestampWithoutTimeZone,
        isNullable: true,
        dartType: 'DateTime',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with no default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"dateTime" timestamp without time zone',
          );
        },
      );
    });

    group('with nullable column and default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'dateTime',
        columnType: ColumnType.timestampWithoutTimeZone,
        isNullable: true,
        columnDefault: 'CURRENT_TIMESTAMP',
        dartType: 'DateTime',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"dateTime" timestamp without time zone DEFAULT CURRENT_TIMESTAMP',
          );
        },
      );
    });
  });
}
