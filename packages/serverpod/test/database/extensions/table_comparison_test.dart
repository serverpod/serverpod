import 'package:serverpod/src/database/extensions.dart';
import 'package:serverpod/src/database/migrations/table_comparison_warning.dart';
import 'package:test/test.dart';
import 'package:serverpod/protocol.dart';

void main() {
  test(
    'Given identical tables when compared then mismatches list is empty',
    () {
      var tableA = TableDefinition(
        name: 'test_table',
        schema: 'public',
        columns: [
          ColumnDefinition(
            name: 'id',
            columnType: ColumnType.integer,
            isNullable: false,
            dartType: 'int',
          ),
          ColumnDefinition(
            name: 'name',
            columnType: ColumnType.text,
            isNullable: false,
            dartType: 'String',
          ),
        ],
        foreignKeys: [],
        indexes: [],
        managed: true,
      );

      var mismatches = tableA.like(tableA);

      expect(mismatches, isEmpty);
    },
  );

  group('Table general property comparisons', () {
    test(
      'when tables have different names then mismatches include table name mismatch',
      () {
        var tableA = TableDefinition(
          name: 'test_table_a',
          schema: 'public',
          columns: [],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table_b',
          schema: 'public',
          columns: [],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isEmpty);
        expect(mismatches.first, isA<TableComparisonWarning>());
        expect(mismatches.first.expected, equals('test_table_a'));
        expect(mismatches.first.found, equals('test_table_b'));
        expect(mismatches.first.isMismatch, isTrue);
        expect(mismatches.first.isMissing, isFalse);
        expect(mismatches.first.isAdded, isFalse);
      },
    );

    test(
      'when tables have different schemas then mismatches include schema mismatch',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'schema_a',
          columns: [],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'schema_b',
          columns: [],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isEmpty);
        expect(mismatches.first, isA<TableComparisonWarning>());
        expect(mismatches.first.expected, equals('schema_a'));
        expect(mismatches.first.found, equals('schema_b'));
        expect(mismatches.first.isMismatch, isTrue);
        expect(mismatches.first.isMissing, isFalse);
        expect(mismatches.first.isAdded, isFalse);
      },
    );

    test(
      'when tables have different tablespaces then mismatches include tablespace mismatch',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          tableSpace: 'tablespace_a',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          tableSpace: 'tablespace_b',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isEmpty);
        expect(mismatches.first, isA<TableComparisonWarning>());
        expect(mismatches.first.expected, equals('tablespace_a'));
        expect(mismatches.first.found, equals('tablespace_b'));
        expect(mismatches.first.isMismatch, isTrue);
        expect(mismatches.first.isMissing, isFalse);
        expect(mismatches.first.isAdded, isFalse);
      },
    );

    test(
      'when tables have different managed property then mismatches include managed property mismatch',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: false,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isEmpty);
        expect(mismatches.first, isA<TableComparisonWarning>());
        expect(mismatches.first.expected, equals('true'));
        expect(mismatches.first.found, equals('false'));
        expect(mismatches.first.isMismatch, isTrue);
        expect(mismatches.first.isMissing, isFalse);
        expect(mismatches.first.isAdded, isFalse);
      },
    );

    test(
      'when tables have same names but different casing then mismatches include table name mismatch',
      () {
        var tableA = TableDefinition(
          name: 'Test_Table',
          schema: 'public',
          columns: [],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isEmpty);
        expect(mismatches.first, isA<TableComparisonWarning>());
        expect(mismatches.first.expected, equals('Test_Table'));
        expect(mismatches.first.found, equals('test_table'));
        expect(mismatches.first.isMismatch, isTrue);
        expect(mismatches.first.isMissing, isFalse);
        expect(mismatches.first.isAdded, isFalse);
      },
    );

    test(
      'when tables have one null tablespace and one with a value then mismatches include tablespace mismatch',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          tableSpace: null,
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          tableSpace: 'tablespace_b',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isEmpty);
        expect(mismatches.first, isA<TableComparisonWarning>());
        expect(mismatches.first.expected, isNull);
        expect(mismatches.first.found, equals('tablespace_b'));
        expect(mismatches.first.isMismatch, isFalse);
        expect(mismatches.first.isMissing, isFalse);
        expect(mismatches.first.isAdded, isTrue);
      },
    );
  });
}
