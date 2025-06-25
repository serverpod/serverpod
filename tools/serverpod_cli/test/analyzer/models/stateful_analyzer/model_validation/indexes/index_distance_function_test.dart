import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
      'Given a class with a vector field and index with invalid distance function value, then collect an error about invalid distance function value.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          table: example
          fields:
            embedding: Vector(1536)
          indexes:
            example_index:
              fields: embedding
              type: hnsw
              distanceFunction: invalid_distance
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error, but none was collected.',
    );

    var error = collector.errors.first;
    expect(
      error.message,
      'Invalid distance function "invalid_distance". Allowed values are: '
      '"l2", "innerProduct", "cosine", "l1".',
    );
  });

  test(
      'Given a class with a vector field and index with non-string distance function, then collect an error about parameter type.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          table: example
          fields:
            embedding: Vector(1536)
          indexes:
            example_index:
              fields: embedding
              type: hnsw
              distanceFunction: 123
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error, but none was collected.',
    );

    var error = collector.errors.first;
    expect(
      error.message,
      'The "distanceFunction" property must be a String.',
    );
  });

  test(
      'Given a class with a non-vector field and distance function, then collect an error that distance function can only be used with vector indexes.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          table: example
          fields:
            name: String
          indexes:
            example_index:
              fields: name
              type: btree
              distanceFunction: l2
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error, but none was collected.',
    );

    var error = collector.errors.first;
    expect(
      error.message,
      'The "distanceFunction" property can only be used with vector '
      'indexes of type "hnsw, ivfflat".',
    );
  });

  test(
      'Given a class with a vector field and hnsw index with valid distance function, then return a definition where distanceFunction is correctly set.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          table: example
          fields:
            embedding: Vector(1536)
          indexes:
            example_index:
              fields: embedding
              type: hnsw
              distanceFunction: cosine
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors, but errors were collected.',
    );

    var definition = definitions.first as ModelClassDefinition;
    var distanceFunction = definition.indexes.first.vectorDistanceFunction;

    expect(distanceFunction, isNotNull);
    expect(distanceFunction!.name, 'cosine');
  });

  test(
      'Given a class with a vector field and hnsw index without distance function, then return a definition where distanceFunction defaults to l2.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          table: example
          fields:
            embedding: Vector(1536)
          indexes:
            example_index:
              fields: embedding
              type: hnsw
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors, but errors were collected.',
    );

    var definition = definitions.first as ModelClassDefinition;
    var distanceFunction = definition.indexes.first.vectorDistanceFunction;

    expect(distanceFunction, isNotNull);
    expect(distanceFunction!.name, 'l2');
  });

  test(
      'Given a class with a half vector field and hnsw index with valid distance function, then return a definition where distanceFunction is correctly set.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          embedding: HalfVector(1536)
        indexes:
          example_index:
            fields: embedding
            type: hnsw
            distanceFunction: cosine
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors, but errors were collected.',
    );

    var definition = definitions.first as ModelClassDefinition;
    var distanceFunction = definition.indexes.first.vectorDistanceFunction;

    expect(distanceFunction, isNotNull);
    expect(distanceFunction!.name, 'cosine');
  });

  test(
      'Given a class with a half vector field and hnsw index without distance function, then return a definition where distanceFunction defaults to l2.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          embedding: HalfVector(1536)
        indexes:
          example_index:
            fields: embedding
            type: hnsw
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors, but errors were collected.',
    );

    var definition = definitions.first as ModelClassDefinition;
    var distanceFunction = definition.indexes.first.vectorDistanceFunction;

    expect(distanceFunction, isNotNull);
    expect(distanceFunction!.name, 'l2');
  });

  test(
      'Given a class with a sparse vector field and hnsw index with valid distance function, then return a definition where distanceFunction is correctly set.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          embedding: SparseVector(1536)
        indexes:
          example_index:
            fields: embedding
            type: hnsw
            distanceFunction: cosine
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors, but errors were collected.',
    );

    var definition = definitions.first as ModelClassDefinition;
    var distanceFunction = definition.indexes.first.vectorDistanceFunction;

    expect(distanceFunction, isNotNull);
    expect(distanceFunction!.name, 'cosine');
  });

  test(
      'Given a class with a sparse vector field and hnsw index without distance function, then return a definition where distanceFunction defaults to l2.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          embedding: SparseVector(1536)
        indexes:
          example_index:
            fields: embedding
            type: hnsw
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors, but errors were collected.',
    );

    var definition = definitions.first as ModelClassDefinition;
    var distanceFunction = definition.indexes.first.vectorDistanceFunction;

    expect(distanceFunction, isNotNull);
    expect(distanceFunction!.name, 'l2');
  });

  test(
      'Given a class with a bit field and hnsw index with valid distance function, then return a definition where distanceFunction is correctly set.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          embedding: Bit(1536)
        indexes:
          example_index:
            fields: embedding
            type: hnsw
            distanceFunction: jaccard
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors, but errors were collected.',
    );

    var definition = definitions.first as ModelClassDefinition;
    var distanceFunction = definition.indexes.first.vectorDistanceFunction;

    expect(distanceFunction, isNotNull);
    expect(distanceFunction!.name, 'jaccard');
  });

  test(
      'Given a class with a bit field and hnsw index without distance function, then return a definition where distanceFunction defaults to hamming.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          embedding: Bit(1536)
        indexes:
          example_index:
            fields: embedding
            type: hnsw
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors, but errors were collected.',
    );

    var definition = definitions.first as ModelClassDefinition;
    var distanceFunction = definition.indexes.first.vectorDistanceFunction;

    expect(distanceFunction, isNotNull);
    expect(distanceFunction!.name, 'hamming');
  });

  test(
      'Given a class with a vector field and index with jaccard distance function (binary only), then collect an error about invalid distance function.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          table: example
          fields:
            embedding: Vector(1536)
          indexes:
            example_index:
              fields: embedding
              type: hnsw
              distanceFunction: jaccard
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error, but none was collected.',
    );

    var error = collector.errors.first;
    expect(
      error.message,
      'Invalid distance function "jaccard". Allowed values are: '
      '"l2", "innerProduct", "cosine", "l1".',
    );
  });

  test(
      'Given a class with a half vector field and index with jaccard distance function (binary only), then collect an error about invalid distance function.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          embedding: HalfVector(1536)
        indexes:
          example_index:
            fields: embedding
            type: hnsw
            distanceFunction: jaccard
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error, but none was collected.',
    );

    var error = collector.errors.first;
    expect(
      error.message,
      'Invalid distance function "jaccard". Allowed values are: '
      '"l2", "innerProduct", "cosine", "l1".',
    );
  });

  test(
      'Given a class with a half vector field and ivfflat index with l1 distance function, then collect an error about invalid distance function.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          embedding: HalfVector(1536)
        indexes:
          example_index:
            fields: embedding
            type: ivfflat
            distanceFunction: l1
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error, but none was collected.',
    );

    var error = collector.errors.first;
    expect(
      error.message,
      'Invalid distance function "l1". Allowed values are: '
      '"l2", "innerProduct", "cosine".',
    );
  });

  test(
      'Given a class with a sparse vector field and index with jaccard distance function (binary only), then collect an error about invalid distance function.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          embedding: SparseVector(1536)
        indexes:
          example_index:
            fields: embedding
            type: hnsw
            distanceFunction: jaccard
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error, but none was collected.',
    );

    var error = collector.errors.first;
    expect(
      error.message,
      'Invalid distance function "jaccard". Allowed values are: '
      '"l2", "innerProduct", "cosine", "l1".',
    );
  });

  test(
      'Given a class with a bit field and index with l2 distance function (not allowed for binary), then collect an error about invalid distance function.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          embedding: Bit(1536)
        indexes:
          example_index:
            fields: embedding
            type: hnsw
            distanceFunction: l2
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error, but none was collected.',
    );

    var error = collector.errors.first;
    expect(
      error.message,
      'Invalid distance function "l2". Allowed values are: '
      '"jaccard", "hamming".',
    );
  });
}
