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
            IndexDefinition(
              indexName: 'idx_id2',
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
              type: 'btree',
              isUnique: true,
              isPrimary: true,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 2);
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 2);
        expect(mismatches.first.subs.first.expected, equals('false'));
        expect(mismatches.first.subs.first.found, equals('true'));
        expect(mismatches.first.subs.first.isMismatch, isTrue);
        expect(mismatches.first.subs.last.expected, equals('false'));
        expect(mismatches.first.subs.last.found, equals('true'));
        expect(mismatches.first.subs.last.isMismatch, isTrue);
        expect(mismatches.last, isA<IndexComparisonWarning>());
        expect(mismatches.last.expected, equals('idx_id2'));
        expect(mismatches.last.found, isNull);
        expect(mismatches.last.isMissing, isTrue);
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
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 1);
        expect(mismatches.first.subs.first.expected, equals('btree'));
        expect(mismatches.first.subs.first.found, equals('hash'));
        expect(mismatches.first.subs.first.isMismatch, isTrue);
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
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 1);
        expect(mismatches.first.subs.first.expected, equals('true'));
        expect(mismatches.first.subs.first.found, equals('false'));
        expect(mismatches.first.subs.first.isMismatch, isTrue);
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
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 1);
        expect(mismatches.first.subs.first.expected, equals('id > 0'));
        expect(mismatches.first.subs.first.found, equals('id < 100'));
        expect(mismatches.first.subs.first.isMismatch, isTrue);
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
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 1);
        expect(mismatches.first.subs.first.expected, equals('tablespace_a'));
        expect(mismatches.first.subs.first.found, equals('tablespace_b'));
        expect(mismatches.first.subs.first.isMismatch, isTrue);
      },
    );
  });

  group('Given tables with vector indexes', () {
    test(
      'when vector indexes have different distance functions then mismatches include distance function mismatch.',
      () {
        var tableA = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'ivfflat',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'ivfflat',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.innerProduct,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 1);
        expect(mismatches.first.subs.first.expected, equals('cosine'));
        expect(mismatches.first.subs.first.found, equals('innerProduct'));
        expect(mismatches.first.subs.first.isMismatch, isTrue);
      },
    );

    test(
      'when vector indexes have different parameters then mismatches include parameters mismatch.',
      () {
        var tableA = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
              parameters: {'m': '16', 'ef_construction': '64'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
              parameters: {'m': '8', 'ef_construction': '32'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 2);
        expect(mismatches.first.subs.first.expected, '16');
        expect(mismatches.first.subs.first.found, '8');
        expect(mismatches.first.subs.first.isMismatch, isTrue);
        expect(mismatches.first.subs.last.expected, '64');
        expect(mismatches.first.subs.last.found, '32');
        expect(mismatches.first.subs.last.isMismatch, isTrue);
      },
    );

    test(
      'when vector indexes have missing parameters then mismatches include parameters mismatch.',
      () {
        var tableA = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
              parameters: {'m': '16', 'ef_construction': '64'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 2);
        expect(mismatches.first.subs.first.expected, '16');
        expect(mismatches.first.subs.first.found, isNull);
        expect(mismatches.first.subs.first.isMissing, isTrue);
        expect(mismatches.first.subs.last.expected, '64');
        expect(mismatches.first.subs.last.found, isNull);
        expect(mismatches.first.subs.last.isMissing, isTrue);
      },
    );

    test(
      'when one index is vector type and the other is not then mismatches include type mismatch.',
      () {
        var tableA = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'ivfflat',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
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
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 2);
        expect(mismatches.first.subs.first.expected, 'ivfflat');
        expect(mismatches.first.subs.first.found, 'btree');
        expect(mismatches.first.subs.first.isMismatch, isTrue);
        expect(mismatches.first.subs.last.expected, 'cosine');
        expect(mismatches.first.subs.last.found, isNull);
        expect(mismatches.first.subs.last.isMissing, isTrue);
      },
    );

    test(
      'when vector indexes are identical then no mismatches are reported.',
      () {
        var tableA = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
              parameters: {'m': '16', 'ef_construction': '64'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
              parameters: {'m': '16', 'ef_construction': '64'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 0);
      },
    );

    test(
      'when vector indexes have additional parameters then mismatches include parameters mismatch.',
      () {
        var tableA = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
              parameters: {'m': '16'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 1);
        expect(mismatches.first.subs.first.expected, isNull);
        expect(mismatches.first.subs.first.found, '16');
        expect(mismatches.first.subs.first.isAdded, isTrue);
      },
    );

    test(
      'when vector indexes have different types but same distance function then mismatches include type mismatch.',
      () {
        var tableA = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'ivfflat',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 1);
        expect(mismatches.first.subs.first.expected, 'ivfflat');
        expect(mismatches.first.subs.first.found, 'hnsw');
        expect(mismatches.first.subs.first.isMismatch, isTrue);
      },
    );

    test(
      'when vector indexes have different distance functions then mismatches include vector distance function mismatch.',
      () {
        var tableA = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.vector,
              isNullable: false,
              dartType: 'Vector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.innerProduct,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 1);
        expect(mismatches.first.subs.first.expected, equals('cosine'));
        expect(mismatches.first.subs.first.found, equals('innerProduct'));
        expect(mismatches.first.subs.first.isMismatch, isTrue);
      },
    );
  });

  group('Given tables with half vector indexes', () {
    test(
      'when half vector indexes have different distance functions then mismatches include distance function mismatch.',
      () {
        var tableA = TableDefinition(
          name: 'half_vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.halfvec,
              isNullable: false,
              dartType: 'HalfVector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'ivfflat',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'half_vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.halfvec,
              isNullable: false,
              dartType: 'HalfVector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'ivfflat',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.innerProduct,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 1);
        expect(mismatches.first.subs.first.expected, equals('cosine'));
        expect(mismatches.first.subs.first.found, equals('innerProduct'));
        expect(mismatches.first.subs.first.isMismatch, isTrue);
      },
    );

    test(
      'when half vector indexes have different parameters then mismatches include parameters mismatch.',
      () {
        var tableA = TableDefinition(
          name: 'half_vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.halfvec,
              isNullable: false,
              dartType: 'HalfVector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
              parameters: {'m': '16', 'ef_construction': '64'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'half_vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.halfvec,
              isNullable: false,
              dartType: 'HalfVector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
              parameters: {'m': '8', 'ef_construction': '32'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 2);
        expect(mismatches.first.subs.first.expected, '16');
        expect(mismatches.first.subs.first.found, '8');
        expect(mismatches.first.subs.first.isMismatch, isTrue);
        expect(mismatches.first.subs.last.expected, '64');
        expect(mismatches.first.subs.last.found, '32');
        expect(mismatches.first.subs.last.isMismatch, isTrue);
      },
    );

    test(
      'when half vector indexes are identical then no mismatches are reported.',
      () {
        var tableA = TableDefinition(
          name: 'half_vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.halfvec,
              isNullable: false,
              dartType: 'HalfVector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
              parameters: {'m': '16', 'ef_construction': '64'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'half_vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.halfvec,
              isNullable: false,
              dartType: 'HalfVector(3)',
              vectorDimension: 3,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
              parameters: {'m': '16', 'ef_construction': '64'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 0);
      },
    );
  });

  group('Given tables with sparse vector indexes', () {
    test(
      'when sparse vector indexes have different distance functions then mismatches include distance function mismatch.',
      () {
        var tableA = TableDefinition(
          name: 'sparse_vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.sparsevec,
              isNullable: false,
              dartType: 'SparseVector(1000)',
              vectorDimension: 1000,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'ivfflat',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'sparse_vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.sparsevec,
              isNullable: false,
              dartType: 'SparseVector(1000)',
              vectorDimension: 1000,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'ivfflat',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.innerProduct,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 1);
        expect(mismatches.first.subs.first.expected, equals('cosine'));
        expect(mismatches.first.subs.first.found, equals('innerProduct'));
        expect(mismatches.first.subs.first.isMismatch, isTrue);
      },
    );

    test(
      'when sparse vector indexes have different parameters then mismatches include parameters mismatch.',
      () {
        var tableA = TableDefinition(
          name: 'sparse_vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.sparsevec,
              isNullable: false,
              dartType: 'SparseVector(1000)',
              vectorDimension: 1000,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
              parameters: {'m': '16', 'ef_construction': '64'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'sparse_vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.sparsevec,
              isNullable: false,
              dartType: 'SparseVector(1000)',
              vectorDimension: 1000,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
              parameters: {'m': '8', 'ef_construction': '32'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 2);
        expect(mismatches.first.subs.first.expected, '16');
        expect(mismatches.first.subs.first.found, '8');
        expect(mismatches.first.subs.first.isMismatch, isTrue);
        expect(mismatches.first.subs.last.expected, '64');
        expect(mismatches.first.subs.last.found, '32');
        expect(mismatches.first.subs.last.isMismatch, isTrue);
      },
    );

    test(
      'when sparse vector indexes are identical then no mismatches are reported.',
      () {
        var tableA = TableDefinition(
          name: 'sparse_vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.sparsevec,
              isNullable: false,
              dartType: 'SparseVector(1000)',
              vectorDimension: 1000,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
              parameters: {'m': '16', 'ef_construction': '64'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'sparse_vector_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.sparsevec,
              isNullable: false,
              dartType: 'SparseVector(1000)',
              vectorDimension: 1000,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.cosine,
              parameters: {'m': '16', 'ef_construction': '64'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 0);
      },
    );
  });

  group('Given tables with bit vector indexes', () {
    test(
      'when bit vector indexes have different distance functions then mismatches include distance function mismatch.',
      () {
        var tableA = TableDefinition(
          name: 'bit_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.bit,
              isNullable: false,
              dartType: 'Bit(64)',
              vectorDimension: 64,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'ivfflat',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.hamming,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'bit_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.bit,
              isNullable: false,
              dartType: 'Bit(64)',
              vectorDimension: 64,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'ivfflat',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.jaccard,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 1);
        expect(mismatches.first.subs.first.expected, equals('hamming'));
        expect(mismatches.first.subs.first.found, equals('jaccard'));
        expect(mismatches.first.subs.first.isMismatch, isTrue);
      },
    );

    test(
      'when bit vector indexes have different parameters then mismatches include parameters mismatch.',
      () {
        var tableA = TableDefinition(
          name: 'bit_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.bit,
              isNullable: false,
              dartType: 'Bit(64)',
              vectorDimension: 64,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.hamming,
              parameters: {'m': '16', 'ef_construction': '64'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'bit_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.bit,
              isNullable: false,
              dartType: 'Bit(64)',
              vectorDimension: 64,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.hamming,
              parameters: {'m': '8', 'ef_construction': '32'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first, isA<IndexComparisonWarning>());
        expect(mismatches.first.subs.length, 2);
        expect(mismatches.first.subs.first.expected, '16');
        expect(mismatches.first.subs.first.found, '8');
        expect(mismatches.first.subs.first.isMismatch, isTrue);
        expect(mismatches.first.subs.last.expected, '64');
        expect(mismatches.first.subs.last.found, '32');
        expect(mismatches.first.subs.last.isMismatch, isTrue);
      },
    );

    test(
      'when bit vector indexes are identical then no mismatches are reported.',
      () {
        var tableA = TableDefinition(
          name: 'bit_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.bit,
              isNullable: false,
              dartType: 'Bit(64)',
              vectorDimension: 64,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.hamming,
              parameters: {'m': '16', 'ef_construction': '64'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'bit_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'embedding',
              columnType: ColumnType.bit,
              isNullable: false,
              dartType: 'Bit(64)',
              vectorDimension: 64,
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_embedding',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'embedding',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
              vectorDistanceFunction: VectorDistanceFunction.hamming,
              parameters: {'m': '16', 'ef_construction': '64'},
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 0);
      },
    );
  });
}
