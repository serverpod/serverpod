import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

void main() {
  group('Given UUID column definition', () {
    group('with no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'uuid',
        columnType: ColumnType.uuid,
        isNullable: false,
        dartType: 'UuidValue',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should not have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"uuid" uuid NOT NULL',
          );
        },
      );

      test(
        'when converting to SQLite SQL code, then it should not have the default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"uuid" BLOB NOT NULL',
          );
        },
      );
    });

    group('with gen_random_uuid() as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'uuid',
        columnType: ColumnType.uuid,
        isNullable: false,
        columnDefault: defaultUuidValueRandom,
        dartType: 'UuidValue',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"uuid" uuid NOT NULL DEFAULT gen_random_uuid()',
          );
        },
      );

      test(
        'when converting to SQLite SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"uuid" BLOB NOT NULL DEFAULT (unhex(hex(randomblob(6)) || \'4\' || substr(hex(randomblob(2)), 2, 3) || substr(\'89AB\', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15)))',
          );
        },
      );
    });

    group('with gen_random_uuid_v7() as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'uuid',
        columnType: ColumnType.uuid,
        isNullable: false,
        columnDefault: defaultUuidValueRandomV7,
        dartType: 'UuidValue',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"uuid" uuid NOT NULL DEFAULT gen_random_uuid_v7()',
          );
        },
      );

      test(
        'when converting to SQLite SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"uuid" BLOB NOT NULL DEFAULT (unhex(printf(\'%012x\', CAST(unixepoch(\'now\', \'subsecond\') * 1000 AS INTEGER)) || \'7\' || substr(hex(randomblob(2)), 2, 3) || substr(\'89AB\', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15)))',
          );
        },
      );
    });

    group('with a specific UUID string as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'uuid',
        columnType: ColumnType.uuid,
        isNullable: false,
        columnDefault: "'550e8400-e29b-41d4-a716-446655440000'",
        dartType: 'UuidValue',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"uuid" uuid NOT NULL DEFAULT \'550e8400-e29b-41d4-a716-446655440000\'::uuid',
          );
        },
      );

      test(
        'when converting to SQLite SQL code, then it should have the default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"uuid" BLOB NOT NULL DEFAULT (X\'550e8400e29b41d4a716446655440000\')',
          );
        },
      );
    });

    group('with nullable column and no default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'uuid',
        columnType: ColumnType.uuid,
        isNullable: true,
        dartType: 'UuidValue',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with no default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"uuid" uuid',
          );
        },
      );

      test(
        'when converting to SQLite SQL code, then it should be nullable with no default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"uuid" BLOB',
          );
        },
      );
    });

    group('with nullable column and default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'uuid',
        columnType: ColumnType.uuid,
        isNullable: true,
        columnDefault: defaultUuidValueRandom,
        dartType: 'UuidValue',
      );

      test(
        'when converting to PostgreSQL SQL code, then it should be nullable with the default value',
        () {
          expect(
            defaultColumn.toPgSqlFragment(),
            '"uuid" uuid DEFAULT gen_random_uuid()',
          );
        },
      );

      test(
        'when converting to SQLite SQL code, then it should be nullable with the default value',
        () {
          expect(
            defaultColumn.toSqlFragment(),
            '"uuid" BLOB DEFAULT (unhex(hex(randomblob(6)) || \'4\' || substr(hex(randomblob(2)), 2, 3) || substr(\'89AB\', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15)))',
          );
        },
      );
    });
  });
}
