import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
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
    });

    group('with gen_random_uuid() as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'uuid',
        columnType: ColumnType.uuid,
        isNullable: false,
        columnDefault: 'gen_random_uuid()',
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
    });

    group('with gen_random_uuid_v7() as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'uuid',
        columnType: ColumnType.uuid,
        isNullable: false,
        columnDefault: 'gen_random_uuid_v7()',
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
    });

    group('with a specific UUID string as default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'uuid',
        columnType: ColumnType.uuid,
        isNullable: false,
        columnDefault: "'550e8400-e29b-41d4-a716-446655440000'::uuid",
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
    });

    group('with nullable column and default value', () {
      ColumnDefinition defaultColumn = ColumnDefinition(
        name: 'uuid',
        columnType: ColumnType.uuid,
        isNullable: true,
        columnDefault: 'gen_random_uuid()',
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
    });
  });
}
