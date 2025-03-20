import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Implements Tests', () {
    test(
        'Given a class that implements a single valid interface, when analyzed, then no errors are collected',
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
        'Given a class that implements multiple valid interfaces, when analyzed, then no errors are collected',
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
        'Given a class that implements a non-existent interface, when analyzed, then an error is collected',
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
        'Given a class that implements duplicate interfaces, when analyzed, then an error is collected',
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
        'Given a class that implements a non-interface class, when analyzed, then an error is collected',
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
        'The referenced class "NonInterfaceClass" is not an interface. Only interfaces can be implemented.',
      );
    });

    test(
        'Given an exception class that implements a valid interface, when analyzed, then no errors are collected',
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

    test(
        'Given a class that implements an interface which implements another interface, when analyzed, then no errors are collected',
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
          implements: Interface2
          fields:
            age: int
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('interface2').withYaml(
          '''
          interface: Interface2
          fields:
            createdAt: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isEmpty);
    });

    test(
        'Given a class that implements an interface and assigns a default value to an interface field, when analyzed, then no errors are collected',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('example1').withYaml(
          '''
        class: ExampleClass
        implements: Interface1
        fields:
          status: String, default='active'
        ''',
        ).build(),
        ModelSourceBuilder().withFileName('interface1').withYaml(
          '''
        interface: Interface1
        fields:
          status: String
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isEmpty);
    });

    test(
        'Given a class that implements an interface with a duplicate field without default value, when analyzed, then an error is collected',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('example1').withYaml(
          '''
        class: ExampleClass
        implements: Interface1
        fields:
          status: String
        ''',
        ).build(),
        ModelSourceBuilder().withFileName('interface1').withYaml(
          '''
        interface: Interface1
        fields:
          status: String
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;
      expect(error.message,
          'Field "status" from interface "Interface1" must modify at least one property (defaults, scope, or relations) when redefined. Otherwise, remove the field from the implementing class.');
    });

    test(
        'Given interfaces with circular dependencies, when analyzed, then an error is collected',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('example1').withYaml(
          '''
          interface: Interface1
          implements: Interface2
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('interface2').withYaml(
          '''
          interface: Interface2
          implements: Interface1
          fields:
            age: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      var error = collector.errors.first;
      expect(error.message,
          'Circular interface dependency detected: Interface1 → Interface2 → Interface1');
    });

    test(
        'Given three interfaces with complex circular dependencies, when analyzed, then an error is collected',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('interface1').withYaml(
          '''
        interface: Interface1
        implements: Interface2
        fields:
          name: String
        ''',
        ).build(),
        ModelSourceBuilder().withFileName('interface2').withYaml(
          '''
        interface: Interface2
        implements: Interface3
        fields:
          age: int
        ''',
        ).build(),
        ModelSourceBuilder().withFileName('interface3').withYaml(
          '''
        interface: Interface3
        implements: Interface1
        fields:
          isActive: bool
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      var error = collector.errors.first;
      expect(error.message,
          'Circular interface dependency detected: Interface1 → Interface2 → Interface3 → Interface1');
    });
  });
}
