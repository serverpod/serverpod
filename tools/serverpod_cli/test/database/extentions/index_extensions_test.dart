import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/index_definition_builder.dart';

void main() {
  group('Given vector index definitions', () {
    test(
        'when comparing identical vector indexes then no mismatches are found.',
        () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
        IndexElementDefinition(
            definition: 'vector_col', type: IndexElementDefinitionType.column)
      ]).build();

      var index2 = index1.copyWith();

      expect(index1, isNot(index2));
      expect(index1.like(index2), isTrue);
    });

    test(
        'when comparing vector indexes with different distance functions then mismatch is found.',
        () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
        IndexElementDefinition(
            definition: 'vector_col', type: IndexElementDefinitionType.column)
      ]).build();

      var index2 = index1.copyWith(
        vectorDistanceFunction: VectorDistanceFunction.l2,
      );

      expect(index1.like(index2), isFalse);
    });

    test(
        'when comparing vector indexes with one null distance function then mismatch is found.',
        () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
        IndexElementDefinition(
            definition: 'vector_col', type: IndexElementDefinitionType.column)
      ]).build();

      var index2 = index1.copyWith(
        vectorDistanceFunction: null,
      );

      expect(index1.like(index2), isFalse);
    });
  });

  group('Given vector index types', () {
    test(
        'when comparing different vector index types with same distance function then mismatch is found.',
        () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.l2)
          .withElements([
        IndexElementDefinition(
            definition: 'vector_col', type: IndexElementDefinitionType.column)
      ]).build();

      var index2 = index1.copyWith(
        type: 'ivfflat',
      );

      expect(index1.like(index2), isFalse);
    });

    test(
        'when comparing vector index to non-vector index then mismatch is found.',
        () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.l2)
          .withElements([
        IndexElementDefinition(
            definition: 'vector_col', type: IndexElementDefinitionType.column)
      ]).build();

      var index2 = index1.copyWith(
        type: 'btree',
      );

      expect(index1.like(index2), isFalse);
    });
  });

  group('Given vector index parameters', () {
    test(
        'when comparing vector indexes with equal parameters then mismatches are found.',
        () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withParameters({'m': '16', 'ef.construction': '100'})
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
            IndexElementDefinition(
                definition: 'vector_col',
                type: IndexElementDefinitionType.column)
          ])
          .build();

      var index2 = index1.copyWith();

      expect(index1, isNot(index2));
      expect(index1.like(index2), isTrue);
    });
    test(
        'when comparing vector indexes with different parameter values then mismatches are found.',
        () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withParameters({'m': '16', 'ef.construction': '100'})
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
            IndexElementDefinition(
                definition: 'vector_col',
                type: IndexElementDefinitionType.column)
          ])
          .build();

      var index2 = index1.copyWith(
        parameters: {'ef.construction': '200', 'm': '16'},
      );

      expect(index1.like(index2), isFalse);
    });

    test(
        'when comparing vector indexes with missing parameters then mismatches are found.',
        () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withParameters({'m': '16', 'ef.construction': '100'})
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
            IndexElementDefinition(
                definition: 'vector_col',
                type: IndexElementDefinitionType.column)
          ])
          .build();

      var index2 = index1.copyWith(
        parameters: {'ef.construction': '100'},
      );

      expect(index1.like(index2), isFalse);
    });

    test(
        'when comparing vector indexes with extra parameters then mismatches are found.',
        () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withParameters({'ef.construction': '100'})
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
            IndexElementDefinition(
                definition: 'vector_col',
                type: IndexElementDefinitionType.column)
          ])
          .build();

      var index2 = index1.copyWith(
        parameters: {'m': '16', 'ef.construction': '100'},
      );

      expect(index1.like(index2), isFalse);
    });
  });

  group('Given vector distance functions', () {
    test(
        'when comparing indexes with different distance functions then appropriate mismatches are reported.',
        () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withElements([
        IndexElementDefinition(
            definition: 'vector_col', type: IndexElementDefinitionType.column)
      ]).build();

      var index2 = index1.copyWith(
        vectorDistanceFunction: VectorDistanceFunction.innerProduct,
      );

      expect(index1.like(index2), isFalse);
    });
  });

  group('Given vector index column types', () {
    test(
        'when comparing vector indexes with different column vector types then mismatch is found.',
        () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withVectorColumnType(ColumnType.vector)
          .withElements([
        IndexElementDefinition(
            definition: 'vector_col', type: IndexElementDefinitionType.column)
      ]).build();

      var index2 = index1.copyWith(
        vectorColumnType: ColumnType.halfvec,
      );

      expect(index1.like(index2), isFalse);
    });

    test(
        'when comparing vector indexes with same column vector types then no mismatch is found.',
        () {
      var index1 = IndexDefinitionBuilder()
          .withIndexName('vector_idx')
          .withType('hnsw')
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withVectorColumnType(ColumnType.vector)
          .withElements([
        IndexElementDefinition(
            definition: 'vector_col', type: IndexElementDefinitionType.column)
      ]).build();

      var index2 = index1.copyWith();

      expect(index1.like(index2), isTrue);
    });
  });
}
