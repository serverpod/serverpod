import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures(
      [ExperimentalFeature.interfaces]).build();

  group('Interface Class Tests', () {
    test(
        'Given an interface class with an invalid class name, when analyzed, then an error is collected that the name is not valid',
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
        'Given an interface class with a reserved keyword name, when analyzed, then an error is collected that the class name is reserved',
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
        'Given an interface with a relation field but without "requiresTable: true", when analyzed, then an error is collected.',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('other_class').withYaml(
          '''
          class: Example
          table: example_table
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('my_interface').withYaml(
          '''
          interface: ExampleInterface
          fields:
            other: Example?, relation
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason:
            'Expected an error for relation without requiresTable, but none was generated.',
      );

      var error = collector.errors.first;

      expect(
        error.message,
        'The "relation" keyword can only be used if the "requiresTable" property is set to true for the interface.',
      );
    });

    test(
        'Given an interface with "requiresTable: true" and a relation field, when analyzed, then no error is collected.',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('related_entity').withYaml(
          '''
          class: Example
          table: example_table
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('my_interface').withYaml(
          '''
          interface: ExampleInterface
          requiresTable: true
          fields:
            other: Example?, relation
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason:
            'The "requiresTable" error was found, but it should not be for a valid setup.',
      );
    });

    test(
        'Given an interface with a relation using a "field" sub-property that points to a non-existent scalar field, when analyzed, then an error is collected.',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('example').withYaml(
          '''
          class: Example
          table: example_table
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('my_interface').withYaml(
          '''
          interface: ExampleInterface
          requiresTable: true
          fields:
            entity: Example?, relation(field=nonExistentIdField)
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason:
            'Expected an error for relation pointing to a non-existent field, but none was generated.',
      );

      var error = collector.errors.first;

      expect(
        error.message,
        'The field "nonExistentIdField" was not found in the interface.',
      );
    });

    test(
        'Given an interface with a relation using a "field" sub-property that points to an existing but non-persisted scalar field, when analyzed, then an error is collected.',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('example').withYaml(
          '''
          class: Example
          table: example_table
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('my_interface').withYaml(
          '''
          interface: ExampleInterface
          requiresTable: true 
          fields:
            exampleId: int, !persist 
            entity: Example?, relation(field=exampleId)
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason:
            'Expected an error for relation pointing to a non-persisted field, but none was generated.',
      );

      var error = collector.errors.first;

      expect(
        error.message,
        'The field "exampleId" is not persisted and cannot be used in a relation.',
      );
    });
  });
}
