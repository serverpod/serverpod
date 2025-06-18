import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  var validIndexTypes = [
    'btree',
    'hash',
    'gist',
    'spgist',
    'gin',
    'brin',
  ];

  for (var indexType in validIndexTypes) {
    test(
        'Given a class with an index type explicitly set to $indexType, then use that type',
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
                type: $indexType
            ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      var definition = definitions.first as ModelClassDefinition;

      var index = definition.indexes.first;

      expect(index.type, indexType);
    });
  }

  test(
      'Given a class with an index without a type set, then default to type btree',
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
          ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var definition = definitions.first as ModelClassDefinition;

    var index = definition.indexes.first;

    expect(index.type, 'btree');
  });

  test(
      'Given a class with an index type explicitly set to an invalid type, then collect an error that only the defined index types can be used.',
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
              type: invalid_pgsql_type
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
      'The "type" property must be one of: btree, hash, gin, gist, spgist, brin.',
    );
  });

  test(
      'Given a class with an index with an invalid type, then collect an error indicating that the type is invalid.',
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
              type: 1
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
      'The "type" property must be one of: btree, hash, gin, gist, spgist, brin.',
    );
  });

  test(
      'Given a class with an index on vector fields and no explicit type, then default to type "hnsw".',
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
          ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var definition = definitions.first as ModelClassDefinition;
    var index = definition.indexes.first;

    expect(index.type, 'hnsw');
  });

  test(
      'Given a class with an index on half vector fields and no explicit type, then default to type "hnsw".',
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
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var definition = definitions.first as ModelClassDefinition;
    var index = definition.indexes.first;

    expect(index.type, 'hnsw');
  });

  test(
      'Given a class with an index on sparse vector fields and no explicit type, then default to type "hnsw".',
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
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var definition = definitions.first as ModelClassDefinition;
    var index = definition.indexes.first;

    expect(index.type, 'hnsw');
  });

  test(
      'Given a class with an index on bit vector fields and no explicit type, then default to type "hnsw".',
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
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var definition = definitions.first as ModelClassDefinition;
    var index = definition.indexes.first;

    expect(index.type, 'hnsw');
  });

  test(
      'Given a class with an index on vector fields with explicit type "hnsw", then use that type.',
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
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var definition = definitions.first as ModelClassDefinition;
    var index = definition.indexes.first;

    expect(index.type, 'hnsw');
  });

  test(
      'Given a class with an index on vector fields with explicit type "ivfflat", then use that type.',
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
              type: ivfflat
          ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var definition = definitions.first as ModelClassDefinition;
    var index = definition.indexes.first;

    expect(index.type, 'ivfflat');
  });

  test(
      'Given a class with a sparse vector field and an index type explicitly set to "ivfflat", then collect an error that only HNSW is supported for SparseVector.',
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
            type: ivfflat
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
      'Only "hnsw" index type is supported for "SparseVector" fields.',
    );
  });

  test(
      'Given a class with a vector field and an index type explicitly set to an invalid type, then collect an error that only vector index types can be used.',
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
              type: invalid_pgsql_type
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
      'The "type" property must be one of: hnsw, ivfflat.',
    );
  });

  test(
      'Given a class with a half vector field and an index type explicitly set to an invalid type, then collect an error that only vector index types can be used.',
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
            type: invalid_pgsql_type
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
      'The "type" property must be one of: hnsw, ivfflat.',
    );
  });

  test(
      'Given a class with a sparse vector field and an index type explicitly set to an invalid type, then collect an error that only vector index types can be used.',
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
            type: invalid_pgsql_type
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
      'Only "hnsw" index type is supported for "SparseVector" fields.',
    );
  });

  test(
      'Given a class with a bit vector field and an index type explicitly set to an invalid type, then collect an error that only vector index types can be used.',
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
            type: invalid_pgsql_type
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
      'The "type" property must be one of: hnsw, ivfflat.',
    );
  });
}
