import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures(
      [ExperimentalFeature.inheritance]).build();

  group('Extends property tests', () {
    group('Given a child-class of an existing class', () {
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
      var models =
          StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
              .validateAll();

      test('Then no errors are collected', () {
        expect(
          collector.errors,
          isEmpty,
        );
      });

      test('Then the child-class is resolved', () {
        var parent = models.first as ClassDefinition;
        var childClasses = parent.childClasses;
        var isChildResolved =
            childClasses.first is ResolvedInheritanceDefinition;

        expect(isChildResolved, isTrue);
      });

      test('Then extendsClass is resolved', () {
        var child = models.last as ClassDefinition;
        var extendsClass = child.extendsClass;
        var isExtendsResolved = extendsClass is ResolvedInheritanceDefinition;

        expect(isExtendsResolved, isTrue);
      });
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
        'Given a child-class that extends an external class, then an error is collected that only classes from within the project can be extended',
        () {
      var modelSources = [
        ModelSourceBuilder()
            .withYaml(
              '''
          class: ExampleForeignClass
          fields:
            name: String
          ''',
            )
            .withModuleAlias('ModelSourceBuilder')
            .build(),
        ModelSourceBuilder().withFileName('example2').withYaml(
          '''
          class: ExampleChildClass
          extends: ExampleForeignClass
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
        'You can only extend classes from your own project.',
      );
    });

    test(
        'Given a child-class when inheritance is not enabled, then error is collected that the "extends" property is not allowed',
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

      var generatorConfig = GeneratorConfigBuilder().build();

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
              generatorConfig, modelSources, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The "extends" property is not allowed for class type. Valid keys are {class, table, managedMigration, serverOnly, fields, indexes}.',
      );
    });

    test(
        'Given a child-class with table, When the parent-class also has a table, then error is collected that only one class in hierarchy can have a table',
        () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example_table
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('example2').withYaml(
          '''
          class: ExampleChildClass
          table: example_child_table
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
        'The "table" property is not allowed because another class, "Example", in the class hierarchy already has one defined. Only one table definition is allowed when using inheritance.',
      );
    });

    test(
        'Given a child-class, when a field name already exists within the hierarchy, then an error is collected that child-class cannot be declared with this field.',
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
        'You cannot declare "ExampleChildClass" with field: "name" as it is already declared in "Example".',
      );
    });

    test(
        'Given a child-class, When the parent-class is serverOnly but the child-class is not, then error is collected that a client class cannot extend a serverOnly class',
        () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          serverOnly: true
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
        'Cannot extend a "serverOnly" class in the inheritance chain ("Example") unless class is marked as "serverOnly".',
      );
    });

    test(
        'Given a serverOnly child-class, When the parent-class is not serverOnly but the grandparent-class is, then error is collected that a client class cannot extend a serverOnly class',
        () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: ExampleGrandparentClass
          serverOnly: true
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('example1').withYaml(
          '''
          class: Example
          extends: ExampleGrandparentClass
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
        'Cannot extend a "serverOnly" class in the inheritance chain ("ExampleGrandparentClass") unless class is marked as "serverOnly".',
      );
    });
  });
}
