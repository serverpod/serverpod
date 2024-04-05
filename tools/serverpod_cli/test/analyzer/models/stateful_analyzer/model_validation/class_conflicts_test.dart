import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
      'Given two models with the same class name, then an error is collected that there is a collision in the class names.',
      () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          name: String
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('example2').withYaml(
        '''
        class: Example
        fields:
          differentName: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
        .validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error but none was generated.',
    );

    var error = collector.errors.first;
    expect(
      error.message,
      'The class name "Example" is already used by another model class.',
    );
  });

  test(
      'Given a single valid model, then there is no error collected for the class name.',
      () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
        .validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors but some were generated.',
    );
  });
}
