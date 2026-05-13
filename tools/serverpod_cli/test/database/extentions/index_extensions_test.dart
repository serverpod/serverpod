import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/index_definition_builder.dart';

void main() {
  test(
    'Given indexes with the same single column element, '
    'when comparing, '
    'then no mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('message_id_idx')
          .withIsUnique(true)
          .withElements([
            IndexElementDefinition(
              definition: 'messageId',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = index1.copyWith();

      expect(index1.like(index2), isTrue);
    },
  );

  test(
    'Given indexes that differ only by an added column element, '
    'when comparing, '
    'then a mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('message_id_idx')
          .withIsUnique(true)
          .withElements([
            IndexElementDefinition(
              definition: 'messageId',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = IndexDefinitionBuilder()
          .withIndexName('message_id_idx')
          .withIsUnique(true)
          .withElements([
            IndexElementDefinition(
              definition: 'messageId',
              type: IndexElementDefinitionType.column,
            ),
            IndexElementDefinition(
              definition: 'subscriber',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      expect(index1.like(index2), isFalse);
    },
  );

  test(
    'Given indexes that differ only by the column name of an element, '
    'when comparing, '
    'then a mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('message_id_idx')
          .withElements([
            IndexElementDefinition(
              definition: 'messageId',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = IndexDefinitionBuilder()
          .withIndexName('message_id_idx')
          .withElements([
            IndexElementDefinition(
              definition: 'subscriber',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      expect(index1.like(index2), isFalse);
    },
  );

  test(
    'Given indexes that differ only by the order of column elements, '
    'when comparing, '
    'then a mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('composite_idx')
          .withElements([
            IndexElementDefinition(
              definition: 'messageId',
              type: IndexElementDefinitionType.column,
            ),
            IndexElementDefinition(
              definition: 'subscriber',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = IndexDefinitionBuilder()
          .withIndexName('composite_idx')
          .withElements([
            IndexElementDefinition(
              definition: 'subscriber',
              type: IndexElementDefinitionType.column,
            ),
            IndexElementDefinition(
              definition: 'messageId',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      expect(index1.like(index2), isFalse);
    },
  );

  test(
    'Given indexes that differ only by the type of an element, '
    'when comparing, '
    'then a mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('expr_idx')
          .withElements([
            IndexElementDefinition(
              definition: 'messageId',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = IndexDefinitionBuilder()
          .withIndexName('expr_idx')
          .withElements([
            IndexElementDefinition(
              definition: 'messageId',
              type: IndexElementDefinitionType.expression,
            ),
          ])
          .build();

      expect(index1.like(index2), isFalse);
    },
  );

  test(
    'Given identical vector indexes, '
    'when comparing, '
    'then no mismatches are found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
            IndexElementDefinition(
              definition: 'vector_col',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = index1.copyWith();

      expect(index1, isNot(index2));
      expect(index1.like(index2), isTrue);
    },
  );

  test(
    'Given vector indexes with different distance functions, '
    'when comparing, '
    'then a mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
            IndexElementDefinition(
              definition: 'vector_col',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = index1.copyWith(
        vectorDistanceFunction: VectorDistanceFunction.l2,
      );

      expect(index1.like(index2), isFalse);
    },
  );

  test(
    'Given vector indexes with one null distance function, '
    'when comparing, '
    'then a mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
            IndexElementDefinition(
              definition: 'vector_col',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = index1.copyWith(
        vectorDistanceFunction: null,
      );

      expect(index1.like(index2), isFalse);
    },
  );

  test(
    'Given different vector index types with same distance function, '
    'when comparing, '
    'then a mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.l2)
          .withElements([
            IndexElementDefinition(
              definition: 'vector_col',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = index1.copyWith(
        type: 'ivfflat',
      );

      expect(index1.like(index2), isFalse);
    },
  );

  test(
    'Given vector index to non-vector index, '
    'when comparing, '
    'then a mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.l2)
          .withElements([
            IndexElementDefinition(
              definition: 'vector_col',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = index1.copyWith(
        type: 'btree',
      );

      expect(index1.like(index2), isFalse);
    },
  );

  test(
    'Given vector indexes with equal parameters, '
    'when comparing, '
    'then no mismatches are found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withParameters({'m': '16', 'ef.construction': '100'})
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
            IndexElementDefinition(
              definition: 'vector_col',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = index1.copyWith();

      expect(index1, isNot(index2));
      expect(index1.like(index2), isTrue);
    },
  );
  test(
    'Given vector indexes with different parameter values, '
    'when comparing, '
    'then a mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withParameters({'m': '16', 'ef.construction': '100'})
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
            IndexElementDefinition(
              definition: 'vector_col',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = index1.copyWith(
        parameters: {'ef.construction': '200', 'm': '16'},
      );

      expect(index1.like(index2), isFalse);
    },
  );

  test(
    'Given vector indexes with missing parameters, '
    'when comparing, '
    'then a mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withParameters({'m': '16', 'ef.construction': '100'})
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
            IndexElementDefinition(
              definition: 'vector_col',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = index1.copyWith(
        parameters: {'ef.construction': '100'},
      );

      expect(index1.like(index2), isFalse);
    },
  );

  test(
    'Given vector indexes with extra parameters, '
    'when comparing, '
    'then a mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withParameters({'ef.construction': '100'})
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
            IndexElementDefinition(
              definition: 'vector_col',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = index1.copyWith(
        parameters: {'m': '16', 'ef.construction': '100'},
      );

      expect(index1.like(index2), isFalse);
    },
  );
  test(
    'Given indexes with different distance functions, '
    'when comparing, '
    'then a mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
            IndexElementDefinition(
              definition: 'vector_col',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = index1.copyWith(
        vectorDistanceFunction: VectorDistanceFunction.innerProduct,
      );

      expect(index1.like(index2), isFalse);
    },
  );

  test(
    'Given vector indexes with different column vector types, '
    'when comparing, '
    'then a mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withVectorColumnType(ColumnType.vector)
          .withElements([
            IndexElementDefinition(
              definition: 'vector_col',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = index1.copyWith(
        vectorColumnType: ColumnType.halfvec,
      );

      expect(index1.like(index2), isFalse);
    },
  );

  test(
    'Given vector indexes with same column vector types, '
    'when comparing, '
    'then no mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withVectorColumnType(ColumnType.vector)
          .withElements([
            IndexElementDefinition(
              definition: 'vector_col',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = index1.copyWith();

      expect(index1.like(index2), isTrue);
    },
  );

  test(
    'Given gin indexes with different gin operator classes, '
    'when comparing, '
    'then a mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('gin_idx')
          .withType('gin')
          .withGinOperatorClass(GinOperatorClass.jsonbPathOps)
          .withElements([
            IndexElementDefinition(
              definition: 'gin_col',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = index1.copyWith(
        ginOperatorClass: GinOperatorClass.jsonbOps,
      );

      expect(index1.like(index2), isFalse);
    },
  );

  test(
    'Given gin indexes with same gin operator class, '
    'when comparing, '
    'then no mismatch is found.',
    () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('gin_idx')
          .withType('gin')
          .withGinOperatorClass(GinOperatorClass.jsonbPathOps)
          .withElements([
            IndexElementDefinition(
              definition: 'gin_col',
              type: IndexElementDefinitionType.column,
            ),
          ])
          .build();

      var index2 = index1.copyWith();

      expect(index1.like(index2), isTrue);
    },
  );
}
