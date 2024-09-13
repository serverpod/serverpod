import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures(
    [ExperimentalFeature.inheritance],
  ).build();

  group('Extends property tests', () {
    test(
        'Given a child-class of an existing class, then no errors are collected and childClasses and extendsClass are resolved',
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
      var models =
          StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
              .validateAll();

      expect(
        collector.errors,
        isEmpty,
      );

      var parent = models.first as ClassDefinition;
      var childClasses = parent.childClasses;
      var isChildResolved = childClasses.first is ResolvedInheritanceDefinition;

      var child = models.last as ClassDefinition;
      var extendsClass = child.extendsClass;
      var isExtendsResolved = extendsClass is ResolvedInheritanceDefinition;

      expect(isChildResolved, isTrue);
      expect(isExtendsResolved, isTrue);
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

  test(
      'Given a child class of a external class, then an error is collected that only classes from within the project can be extended',
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
      'Given a child-class when inheritance is not enabled, then error is collected that experimental-features=inheritance needs to be enabled',
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
      'The "extends" key can only be used when the (experimental) inheritance feature is enabled.',
    );
  });
}
