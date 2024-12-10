import 'package:serverpod/src/database/extensions.dart';
import 'package:serverpod/src/database/migrations/table_comparison_warning.dart';
import 'package:test/test.dart';
import 'package:serverpod/protocol.dart';

void main() {
  group('Given tables with different foreign keys', () {
    test(
      'when a foreign key is missing in the target table then mismatches include missing foreign key',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'user_id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [
            ForeignKeyDefinition(
              constraintName: 'fk_user',
              columns: ['user_id'],
              referenceTable: 'users',
              referenceTableSchema: 'public',
              referenceColumns: ['id'],
              onUpdate: ForeignKeyAction.noAction,
              onDelete: ForeignKeyAction.noAction,
              matchType: null,
            ),
          ],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'user_id',
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
        expect(mismatches.first, isA<ForeignKeyComparisonWarning>());
        expect(mismatches.first.expected, equals('fk_user'));
        expect(mismatches.first.found, isNull);
        expect(mismatches.first.isMissing, isTrue);
        expect(mismatches.first.isAdded, isFalse);
        expect(mismatches.first.isMismatch, isFalse);
      },
    );

    test(
      'when foreign keys have different definitions then mismatches include foreign key mismatch',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'user_id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [
            ForeignKeyDefinition(
              constraintName: 'fk_user',
              columns: ['user_id'],
              referenceTable: 'users',
              referenceTableSchema: 'public',
              referenceColumns: ['id'],
              onUpdate: ForeignKeyAction.noAction,
              onDelete: ForeignKeyAction.noAction,
              matchType: null,
            ),
          ],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'user_id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [
            ForeignKeyDefinition(
              constraintName: 'fk_user',
              columns: ['user_id'],
              referenceTable: 'users',
              referenceTableSchema: 'public',
              referenceColumns: ['id'],
              onUpdate: ForeignKeyAction.cascade,
              onDelete: ForeignKeyAction.noAction,
              matchType: null,
            ),
          ],
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isNotEmpty);
        expect(mismatches.first, isA<ForeignKeyComparisonWarning>());
        expect(mismatches.first.subs.first, isA<ForeignKeyComparisonWarning>());
        expect(mismatches.first.subs.first.expected, equals('noAction'));
        expect(mismatches.first.subs.first.found, equals('cascade'));
        expect(mismatches.first.subs.first.isMismatch, isTrue);
        expect(mismatches.first.subs.first.isMissing, isFalse);
        expect(mismatches.first.subs.first.isAdded, isFalse);
      },
    );
  });
}
