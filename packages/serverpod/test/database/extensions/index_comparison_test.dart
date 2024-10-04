import 'package:serverpod/src/database/extensions.dart';
import 'package:serverpod/src/database/migrations/table_comparison_warning.dart';
import 'package:test/test.dart';
import 'package:serverpod/protocol.dart';

void main() {
  group('Given tables with different indexes', () {
    test(
      'when an index is missing in the target table then mismatches include missing index',
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
          indexes: [
            IndexDefinition(
              indexName: 'idx_id',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'id',
                ),
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
          ],
          foreignKeys: [],
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
          indexes: [],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isEmpty);

        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.mismatch, equals('missing index'));
        expect(mismatches.first.expected, equals('idx_id'));
        expect(mismatches.first.found, equals('none'));
      },
    );

    test(
      'when indexes have different types then mismatches include index type mismatch',
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
          indexes: [
            IndexDefinition(
              indexName: 'idx_id',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'id',
                ),
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
          ],
          foreignKeys: [],
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
          indexes: [
            IndexDefinition(
              indexName: 'idx_id',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'id',
                ),
              ],
              type: 'hash',
              isUnique: false,
              isPrimary: false,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isNotEmpty);

        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.first.mismatch, equals('type'));
        expect(mismatches.first.subs.first.expected, equals('btree'));
        expect(mismatches.first.subs.first.found, equals('hash'));
      },
    );

    test(
      'when indexes have different uniqueness then mismatches include index uniqueness mismatch',
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
          indexes: [
            IndexDefinition(
              indexName: 'idx_id',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'id',
                ),
              ],
              type: 'btree',
              isUnique: true,
              isPrimary: false,
            ),
          ],
          foreignKeys: [],
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
          indexes: [
            IndexDefinition(
              indexName: 'idx_id',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'id',
                ),
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isNotEmpty);

        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.first.mismatch, equals('uniqueness'));
        expect(mismatches.first.subs.first.expected, equals('true'));
        expect(mismatches.first.subs.first.found, equals('false'));
      },
    );

    test(
      'when indexes have different predicates then mismatches include index predicate mismatch',
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
          indexes: [
            IndexDefinition(
              indexName: 'idx_id',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'id',
                ),
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
              predicate: 'id > 0',
            ),
          ],
          foreignKeys: [],
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
          indexes: [
            IndexDefinition(
              indexName: 'idx_id',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'id',
                ),
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
              predicate: 'id < 100',
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isNotEmpty);

        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.first.mismatch, equals('predicate'));
        expect(mismatches.first.subs.first.expected, equals('id > 0'));
        expect(mismatches.first.subs.first.found, equals('id < 100'));
      },
    );

    test(
      'when indexes have different tablespaces then mismatches include index tablespace mismatch',
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
          indexes: [
            IndexDefinition(
              indexName: 'idx_id',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'id',
                ),
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
              tableSpace: 'tablespace_a',
            ),
          ],
          foreignKeys: [],
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
          indexes: [
            IndexDefinition(
              indexName: 'idx_id',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'id',
                ),
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
              tableSpace: 'tablespace_b',
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isNotEmpty);

        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.first.mismatch, equals('tablespace'));
        expect(mismatches.first.subs.first.expected, equals('tablespace_a'));
        expect(mismatches.first.subs.first.found, equals('tablespace_b'));
      },
    );
  });
}
