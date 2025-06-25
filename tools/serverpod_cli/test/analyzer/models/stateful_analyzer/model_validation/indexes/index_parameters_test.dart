import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
      'Given a class with an index with undefined parameters, then return a definition where parameters is set to null.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          embedding: Vector(512)
        indexes:
          example_index:
            fields: embedding
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();
    var definition = definitions.first as ModelClassDefinition;

    var index = definition.indexes.first;
    expect(index.parameters, isNull);
  });
  test(
      'Given a class with an index with empty parameters, then return a definition where parameters is set to null.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          embedding: Vector(512)
        indexes:
          example_index:
            fields: embedding
            parameters: {}
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();
    var definition = definitions.first as ModelClassDefinition;

    var index = definition.indexes.first;
    expect(index.parameters, isNull);
  });

  test(
      'Given a class with an index with invalid parameters (not a map), then collect an error that the parameters must be a map.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          embedding: Vector(512)
        indexes:
          example_index:
            fields: embedding
            parameters: InvalidValue
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
      reason: 'Expected an error but none was generated.',
    );

    var error = collector.errors.first;
    expect(error.message, 'The "parameters" property must be a map.');
  });

  test(
      'Given a class with a non-vector field and parameters, then collect an error that parameters can only be used with vector indexes.',
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
              parameters:
                m: 16
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
      'The "parameters" property can only be used with vector indexes of type "hnsw, ivfflat".',
    );
  });

  test(
      'Given a class with a vector field and hnsw index with valid parameters, then return a definition where parameters are correctly set.',
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
              parameters:
                m: 16
                ef_construction: 64
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
    var parameters = definition.indexes.first.parameters;

    expect(parameters, isNotNull);
    expect(parameters!['m'], '16');
    expect(parameters['ef_construction'], '64');
  });

  test(
      'Given a class with a vector field and hnsw index with invalid parameter name, then collect an error about unknown parameters.',
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
              parameters:
                invalid_param: 16
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
      'Unknown parameters for hnsw index: "invalid_param". Allowed parameters '
      'are: "m", "ef_construction".',
    );
  });

  test(
      'Given a class with a vector field and ivfflat index with valid parameters, then no errors should be collected.',
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
              parameters:
                lists: 100
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
    var parameters = definition.indexes.first.parameters;

    expect(parameters, isNotNull);
    expect(parameters!['lists'], '100');
  });

  test(
      'Given a class with a vector field and ivfflat index with invalid parameter name, then collect an error about unknown parameters.',
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
              parameters:
                ef_construction: 64
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
      'Unknown parameters for ivfflat index: "ef_construction". Allowed '
      'parameters are: "lists".',
    );
  });

  test(
      'Given a class with a vector field and hnsw index with incorrect parameter type, then collect an error about parameter type.',
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
              parameters:
                m: "16"
                ef_construction: true
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors.length,
      equals(2),
      reason: 'Expected two errors, but got ${collector.errors.length}.',
    );

    expect(
      collector.errors[0].message,
      'The "m" parameter must be a int.',
    );

    expect(
      collector.errors[1].message,
      'The "ef_construction" parameter must be a int.',
    );
  });

  test(
      'Given a vector field with HNSW index where ef_construction < 2*m, then collect an error about the constraint.',
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
              parameters:
                m: 16
                ef_construction: 30
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
      'The "ef_construction" parameter must be greater than or equal to 2 * m. '
      'Set "m" <= 15 or increase "ef_construction" to a value >= 32.',
    );
  });

  test(
      'Given a vector field with HNSW index where ef_construction = 2*m, then no errors should be collected',
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
              parameters:
                m: 16
                ef_construction: 32
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors, but errors were collected.',
    );
  });

  test(
      'Given a vector field with HNSW index where ef_construction > 2*m, then no errors should be collected',
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
              parameters:
                m: 16
                ef_construction: 64
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors, but errors were collected.',
    );
  });

  test(
      'Given a vector field with HNSW index with only m parameter where default ef_construction < 2*m, then collect an error with suggestion',
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
              parameters:
                m: 40
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
      'The "ef_construction" parameter must be greater than or equal to 2 * m. '
      'Set "m" <= 32 or declare "ef_construction" with a value >= 80.',
    );
  });

  test(
      'Given a vector field with HNSW index with only ef_construction parameter where ef_construction < 2*default m, then collect an error with suggestion',
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
              parameters:
                ef_construction: 20
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
      'The "ef_construction" parameter must be greater than or equal to 2 * m. '
      'Set "ef_construction" >= 32 or declare "m" with a value <= 10.',
    );
  });
}
