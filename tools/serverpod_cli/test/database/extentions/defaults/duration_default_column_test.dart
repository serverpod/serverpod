import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given Duration column definition', () {
    group('with no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'durationDefault',
        columnType: ColumnType.bigint,
        isNullable: false,
        dartType: 'Duration',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should not have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"durationDefault" bigint NOT NULL',
          );
        },
      );
    });

    group('with 94230100ms as default value', () {
      // This corresponds to 1d 2h 10min 30s 100ms
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'durationDefault',
        columnType: ColumnType.bigint,
        isNullable: false,
        columnDefault: '94230100', // milliseconds
        dartType: 'Duration',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should have the default value in milliseconds',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"durationDefault" bigint NOT NULL DEFAULT 94230100',
          );
        },
      );
    });

    group('with 177640100ms as default value', () {
      // This corresponds to 2d 1h 20min 40s 100ms
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'durationDefault',
        columnType: ColumnType.bigint,
        isNullable: false,
        columnDefault: '177640100', // milliseconds
        dartType: 'Duration',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should have the default value in milliseconds',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"durationDefault" bigint NOT NULL DEFAULT 177640100',
          );
        },
      );
    });

    group('with nullable column and no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'durationDefault',
        columnType: ColumnType.bigint,
        isNullable: true,
        dartType: 'Duration',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with no default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"durationDefault" bigint',
          );
        },
      );
    });

    group('with nullable column and 94230100ms as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'durationDefault',
        columnType: ColumnType.bigint,
        isNullable: true,
        columnDefault: '94230100', // milliseconds
        dartType: 'Duration',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with the default value in milliseconds',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"durationDefault" bigint DEFAULT 94230100',
          );
        },
      );
    });

    group('with nullable column and 177640100ms as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'durationDefault',
        columnType: ColumnType.bigint,
        isNullable: true,
        columnDefault: '177640100', // milliseconds
        dartType: 'Duration',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with the default value in milliseconds',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"durationDefault" bigint DEFAULT 177640100',
          );
        },
      );
    });
  });
}
