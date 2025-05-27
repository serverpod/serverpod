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
}
