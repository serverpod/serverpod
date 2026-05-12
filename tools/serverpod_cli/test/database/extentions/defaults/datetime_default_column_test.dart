import 'package:serverpod_cli/analyzer.dart';
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

      test(
        'when converting to SQLite SQL code, then it should not have the default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"dateTime" INTEGER NOT NULL',
          );
        },
      );
    });

    group('with CURRENT_TIMESTAMP as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'dateTime',
        columnType: ColumnType.timestampWithoutTimeZone,
        isNullable: false,
        columnDefault: 'now',
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

      test(
        'when converting to SQLite SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"dateTime" INTEGER NOT NULL DEFAULT (CAST(unixepoch(\'subsecond\') * 1000 AS INTEGER))',
          );
        },
      );
    });

    group('with a specific timestamp as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'dateTime',
        columnType: ColumnType.timestampWithoutTimeZone,
        isNullable: false,
        columnDefault: '2024-01-01T01:01:01.000Z',
        dartType: 'DateTime',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"dateTime" timestamp without time zone NOT NULL DEFAULT \'2024-01-01 01:01:01.000\'::timestamp without time zone',
          );
        },
      );

      test(
        'when converting to SQLite SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"dateTime" INTEGER NOT NULL DEFAULT (1704070861000)',
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

      test(
        'when converting to SQLite SQL code, then it should be nullable with no default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"dateTime" INTEGER',
          );
        },
      );
    });

    group('with nullable column and default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'dateTime',
        columnType: ColumnType.timestampWithoutTimeZone,
        isNullable: true,
        columnDefault: 'now',
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

      test(
        'when converting to SQLite SQL code, then it should be nullable with the default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"dateTime" INTEGER DEFAULT (CAST(unixepoch(\'subsecond\') * 1000 AS INTEGER))',
          );
        },
      );
    });
  });
}
