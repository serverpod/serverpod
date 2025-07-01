import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();
  test(
      'Given a class with an index with a unique key that is not a bool, then collect an error that the unique key has to be defined as a bool.',
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
            unique: InvalidValue
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
    expect(error.message, 'The value must be a boolean.');
  });

  test(
      'Given a class with an index with an undefined unique key, then return a definition where unique is set to false.',
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
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();
    var definition = definitions.first as ModelClassDefinition;

    var index = definition.indexes.first;
    expect(index.unique, false);
  });

  test(
      'Given a class with an index with a unique key set to false, then return a definition where unique is set to false.',
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
          unique: false
      ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();
    var definition = definitions.first as ModelClassDefinition;

    var index = definition.indexes.first;
    expect(index.unique, false);
  });

  test(
      'Given a class with an index with a unique key set to true, then return a definition where unique is set to true.',
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
            unique: true
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();
    var definition = definitions.first as ModelClassDefinition;

    var index = definition.indexes.first;
    expect(index.unique, true);
  });

  test(
      'Given a class with a vector index of type HNSW with unique set to true, then collect an error that unique property cannot be used with vector indexes.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          embeddings: Vector(512)
        indexes:
          vector_index:
            fields: embeddings
            type: hnsw
            unique: true
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
    expect(error.message,
        'The "unique" property cannot be used with vector indexes of type "hnsw".');
  });

  test(
      'Given a class with a vector index of type IVFFlat with unique set to true, then collect an error that unique property cannot be used with vector indexes.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          embeddings: Vector(512)
        indexes:
          vector_index:
            fields: embeddings
            type: ivfflat
            unique: true
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
    expect(error.message,
        'The "unique" property cannot be used with vector indexes of type "ivfflat".');
  });
}
