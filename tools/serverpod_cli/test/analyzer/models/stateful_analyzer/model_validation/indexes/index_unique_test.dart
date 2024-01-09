import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
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
    var analyzer = StatefulAnalyzer(models, onErrorsCollector(collector));
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
    var analyzer = StatefulAnalyzer(models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();
    var definition = definitions.first as ClassDefinition;

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
    var analyzer = StatefulAnalyzer(models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();
    var definition = definitions.first as ClassDefinition;

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
    var analyzer = StatefulAnalyzer(models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();
    var definition = definitions.first as ClassDefinition;

    var index = definition.indexes.first;
    expect(index.unique, true);
  });
}
