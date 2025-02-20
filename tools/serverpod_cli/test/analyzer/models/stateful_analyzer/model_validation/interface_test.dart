import 'package:test/test.dart';

import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures(
      [ExperimentalFeature.inheritance]).build();

  group('Interface Class Tests', () {
    test(
        'Given an interface class, when the class name is not a valid class name, then an error is collected that the name is not valid',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('example1').withYaml(
          '''
          interface: example
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
        'The "interface" type must be a valid class name (e.g. PascalCaseString).',
      );
    });

    test(
        'Given an interface class, when the class name is a reserved keyword, then an error is collected that the class name is reserved',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('example1').withYaml(
          '''
          interface: List
          fields:
            name: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      var error = collector.errors.first;
      expect(
        error.message,
        'The class name "List" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class, when implementing a single valid interface, then no errors are collected',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('example1').withYaml(
          '''
          class: ExampleClass
          implements: ValidInterface
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('interface1').withYaml(
          '''
          interface: ValidInterface
          fields:
            id: int
          ''',
        ).build(),
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

    test(
        'Given a class, when implementing multiple interfaces, then no errors are collected if all interfaces are valid',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('example1').withYaml(
          '''
          class: ExampleClass
          implements: Interface1, Interface2
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('interface1').withYaml(
          '''
          interface: Interface1
          fields:
            id: int
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('interface2').withYaml(
          '''
          interface: Interface2
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
        reason: 'Expected no errors but some were generated.',
      );
    });

    test(
        'Given a class, when implementing a non-existent interface, then an error is collected',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('example1').withYaml(
          '''
          class: ExampleClass
          implements: NonExistentInterface
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
        'The implemented interface name "NonExistentInterface" was not found in any model.',
      );
    });

    test(
        'Given a class, when implementing duplicate interfaces, then an error is collected',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('example1').withYaml(
          '''
          class: ExampleClass
          implements: DuplicateInterface, DuplicateInterface
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('interface1').withYaml(
          '''
          interface: DuplicateInterface
          fields:
            id: int
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
        'The interface name "DuplicateInterface" is duplicated.',
      );
    });

    test(
        'Given a class implementing a non-interface class, then an error is collected',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('example1 ').withYaml(
          '''
          class: ExampleClass
          implements: NonInterfaceClass
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('non_interface_class').withYaml(
          '''
          class: NonInterfaceClass
          fields:
            id: int
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
        'The implemented node "NonInterfaceClass" is not an interface.',
      );
    });

    test(
        'Given an exception implementing a valid interface, when generating code, then no errors are collected',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('example1').withYaml(
          '''
          class: ExampleException
          implements: ValidInterface
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('interface1').withYaml(
          '''
          interface: ValidInterface
          fields:
            id: int
          ''',
        ).build(),
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
  });
}
