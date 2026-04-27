import 'package:serverpod_cli/analyzer.dart';
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

      test(
        'when converting to SQLite SQL code, then it should not have the default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"boolDefault" INTEGER NOT NULL',
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

      test(
        'when converting to SQLite SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"boolDefault" INTEGER NOT NULL DEFAULT (1)',
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

      test(
        'when converting to SQLite SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"boolDefault" INTEGER NOT NULL DEFAULT (0)',
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

      test(
        'when converting to SQLite SQL code, then it should be nullable with no default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"boolDefault" INTEGER',
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

      test(
        'when converting to SQLite SQL code, then it should be nullable with the default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"boolDefault" INTEGER DEFAULT (1)',
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

      test(
        'when converting to SQLite SQL code, then it should be nullable with the default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"boolDefault" INTEGER DEFAULT (0)',
          );
        },
      );
    });
  });
}
