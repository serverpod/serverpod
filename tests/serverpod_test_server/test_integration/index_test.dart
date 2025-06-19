import 'package:serverpod/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod/src/database/analyze.dart';
import 'package:serverpod/serverpod.dart';

void main() async {
  Session session = await IntegrationTestServer().session();

  group('Given declared ObjectWithVector class when analyzing database schema',
      () {
    late List<IndexDefinition> indexes;

    setUpAll(() async {
      var databaseDefinition = await DatabaseAnalyzer.analyze(session.db);

      var vectorTable = databaseDefinition.tables.firstWhere(
        (table) => table.name == 'object_with_vector',
      );

      indexes = vectorTable.indexes;
    });

    test(
        'then the implicitly declared vector index exists with default type "hnsw".',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'vector_index_default',
      );

      expect(index.type, 'hnsw');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition, 'vector');
    });

    test(
        'then the explicitly declared "hnsw" vector index exists with correct type.',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'vector_index_hnsw',
      );

      expect(index.type, 'hnsw');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition, 'vectorIndexedHnsw');
      expect(index.vectorDistanceFunction, VectorDistanceFunction.l2);
      expect(index.parameters, isNull);
    });

    test(
        'then the explicitly declared "hnsw" vector index with parameters exists with correct type and parameters.',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'vector_index_hnsw_with_params',
      );

      expect(index.type, 'hnsw');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition, 'vectorIndexedHnswWithParams');
      expect(index.vectorDistanceFunction, VectorDistanceFunction.cosine);
      expect(index.parameters, {'m': '64', 'ef_construction': '200'});
    });

    test(
        'then the explicitly declared "ivfflat" vector index exists with correct type.',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'vector_index_ivfflat',
      );

      expect(index.type, 'ivfflat');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition, 'vectorIndexedIvfflat');
      expect(index.vectorDistanceFunction, VectorDistanceFunction.l2);
      expect(index.parameters, isNull);
    });

    test(
        'then the explicitly declared "ivfflat" vector index with parameters exists with correct type and parameters.',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'vector_index_ivfflat_with_params',
      );

      expect(index.type, 'ivfflat');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition, 'vectorIndexedIvfflatWithParams');
      expect(index.vectorDistanceFunction, VectorDistanceFunction.innerProduct);
      expect(index.parameters, {'lists': '300'});
    });
  });

  group(
      'Given declared ObjectWithHalfVector class when analyzing database schema',
      () {
    late List<IndexDefinition> indexes;

    setUpAll(() async {
      var databaseDefinition = await DatabaseAnalyzer.analyze(session.db);

      var halfVectorTable = databaseDefinition.tables.firstWhere(
        (table) => table.name == 'object_with_half_vector',
      );

      indexes = halfVectorTable.indexes;
    });

    test(
        'then the implicitly declared half vector index exists with default type "hnsw".',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'half_vector_index_default',
      );

      expect(index.type, 'hnsw');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition, 'halfVector');
    });

    test(
        'then the explicitly declared "hnsw" half vector index exists with correct type.',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'half_vector_index_hnsw',
      );

      expect(index.type, 'hnsw');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition, 'halfVectorIndexedHnsw');
      expect(index.vectorDistanceFunction, VectorDistanceFunction.l2);
      expect(index.parameters, isNull);
    });

    test(
        'then the explicitly declared "hnsw" half vector index with parameters exists with correct type and parameters.',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'half_vector_index_hnsw_with_params',
      );

      expect(index.type, 'hnsw');
      expect(index.elements.length, 1);
      expect(
          index.elements.first.definition, 'halfVectorIndexedHnswWithParams');
      expect(index.vectorDistanceFunction, VectorDistanceFunction.l2);
      expect(index.parameters, {'m': '64', 'ef_construction': '200'});
    });

    test(
        'then the explicitly declared "ivfflat" half vector index exists with correct type.',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'half_vector_index_ivfflat',
      );

      expect(index.type, 'ivfflat');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition, 'halfVectorIndexedIvfflat');
      expect(index.vectorDistanceFunction, VectorDistanceFunction.l2);
      expect(index.parameters, isNull);
    });

    test(
        'then the explicitly declared "ivfflat" half vector index with parameters exists with correct type and parameters.',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'half_vector_index_ivfflat_with_params',
      );

      expect(index.type, 'ivfflat');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition,
          'halfVectorIndexedIvfflatWithParams');
      expect(index.vectorDistanceFunction, VectorDistanceFunction.cosine);
      expect(index.parameters, {'lists': '300'});
    });
  });

  group(
      'Given declared ObjectWithSparseVector class when analyzing database schema',
      () {
    late List<IndexDefinition> indexes;

    setUpAll(() async {
      var databaseDefinition = await DatabaseAnalyzer.analyze(session.db);

      var sparseVectorTable = databaseDefinition.tables.firstWhere(
        (table) => table.name == 'object_with_sparse_vector',
      );

      indexes = sparseVectorTable.indexes;
    });

    test(
        'then the implicitly declared sparse vector index exists with default type "hnsw".',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'sparse_vector_index_default',
      );

      expect(index.type, 'hnsw');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition, 'sparseVector');
    });

    test(
        'then the explicitly declared "hnsw" sparse vector index exists with correct type.',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'sparse_vector_index_hnsw',
      );

      expect(index.type, 'hnsw');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition, 'sparseVectorIndexedHnsw');
      expect(index.vectorDistanceFunction, VectorDistanceFunction.l2);
      expect(index.parameters, isNull);
    });

    test(
        'then the explicitly declared "hnsw" sparse vector index with parameters exists with correct type and parameters.',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'sparse_vector_index_hnsw_with_params',
      );

      expect(index.type, 'hnsw');
      expect(index.elements.length, 1);
      expect(
          index.elements.first.definition, 'sparseVectorIndexedHnswWithParams');
      expect(index.vectorDistanceFunction, VectorDistanceFunction.l1);
      expect(index.parameters, {'m': '64', 'ef_construction': '200'});
    });
  });

  group('Given declared ObjectWithBit class when analyzing database schema',
      () {
    late List<IndexDefinition> indexes;

    setUpAll(() async {
      var databaseDefinition = await DatabaseAnalyzer.analyze(session.db);

      var bitTable = databaseDefinition.tables.firstWhere(
        (table) => table.name == 'object_with_bit',
      );

      indexes = bitTable.indexes;
    });

    test(
        'then the implicitly declared bit index exists with default type "hnsw".',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'bit_index_default',
      );

      expect(index.type, 'hnsw');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition, 'bit');
    });

    test(
        'then the explicitly declared "hnsw" bit index exists with correct type.',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'bit_index_hnsw',
      );

      expect(index.type, 'hnsw');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition, 'bitIndexedHnsw');
      expect(index.vectorDistanceFunction, VectorDistanceFunction.hamming);
      expect(index.parameters, isNull);
    });

    test(
        'then the explicitly declared "hnsw" bit index with parameters exists with correct type and parameters.',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'bit_index_hnsw_with_params',
      );

      expect(index.type, 'hnsw');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition, 'bitIndexedHnswWithParams');
      expect(index.vectorDistanceFunction, VectorDistanceFunction.jaccard);
      expect(index.parameters, {'m': '64', 'ef_construction': '200'});
    });

    test(
        'then the explicitly declared "ivfflat" bit index exists with correct type.',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'bit_index_ivfflat',
      );

      expect(index.type, 'ivfflat');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition, 'bitIndexedIvfflat');
      expect(index.vectorDistanceFunction, VectorDistanceFunction.hamming);
      expect(index.parameters, isNull);
    });

    test(
        'then the explicitly declared "ivfflat" bit index with parameters exists with correct type and parameters.',
        () {
      var index = indexes.firstWhere(
        (idx) => idx.indexName == 'bit_index_ivfflat_with_params',
      );

      expect(index.type, 'ivfflat');
      expect(index.elements.length, 1);
      expect(index.elements.first.definition, 'bitIndexedIvfflatWithParams');
      expect(index.vectorDistanceFunction, VectorDistanceFunction.hamming);
      expect(index.parameters, {'lists': '300'});
    });
  });
}
