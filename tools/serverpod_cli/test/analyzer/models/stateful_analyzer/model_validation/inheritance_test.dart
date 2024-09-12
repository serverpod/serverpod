import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Extends property tests', () {
    test(
        'Given a child-class of an existing class, then no errors are collected',
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
          class: ExampleChildClass
          extends: Example
          fields:
            age: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isEmpty,
      );
    });

    test(
        'Given a child-class of a not existing class, then collect an error that no class was found in models',
        () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          extends: NotExistingClass
          fields:
            name: String
          ''',
        ).build(),
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
        'The class "NotExistingClass" was not found in any model.',
      );
    });

    test(
        'Given a child-class is defined with the table property, then an error is collected that child-classes cannot have a table',
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
          class: ExampleChildClass
          extends: Example
          table: example_child_class
          fields:
            age: int
          ''',
        ).build(),
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
        'The "extends" property is mutually exclusive with the "table" property.',
      );
    });

    test(
        'Given a child-class extends a class with a table defined, then collect an error that parent class cannot have a table',
        () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('example2').withYaml(
          '''
          class: ExampleChildClass
          extends: Example
          fields:
            age: int
          ''',
        ).build(),
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
        'A parent class cannot have a table definition. Please remove the "table" property from the class "Example".',
      );
    });
  });
}
