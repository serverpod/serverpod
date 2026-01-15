import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given an enum with valid properties when parsing', () {
    late CodeGenerationCollector collector;
    late List<SerializableModelDefinition> definitions;
    late EnumDefinition definition;

    setUp(() {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          enum: ExampleEnum
          properties:
            id: int
            name: String
          values:
            - first:
                id: 1
                name: 'First'
            - second:
                id: 2
                name: 'Second'
          ''',
        ).build(),
      ];

      collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      );

      definitions = analyzer.validateAll();
      definition = definitions.first as EnumDefinition;
    });

    test('then no errors are collected.', () {
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors but got: ${collector.errors}',
      );
    });

    test('then isEnhanced returns true.', () {
      expect(definition.isEnhanced, isTrue);
    });

    test('then properties are parsed correctly.', () {
      expect(definition.properties, hasLength(2));
      expect(definition.properties[0].name, 'id');
      expect(definition.properties[0].type, 'int');
      expect(definition.properties[1].name, 'name');
      expect(definition.properties[1].type, 'String');
    });

    test('then property values are parsed correctly.', () {
      var firstValue = definition.values.first;
      expect(firstValue.name, 'first');
      expect(firstValue.propertyValues['id'], 1);
      expect(firstValue.propertyValues['name'], "'First'");

      var secondValue = definition.values[1];
      expect(secondValue.name, 'second');
      expect(secondValue.propertyValues['id'], 2);
      expect(secondValue.propertyValues['name'], "'Second'");
    });
  });

  group('Given an enum without properties when parsing', () {
    late EnumDefinition definition;

    setUp(() {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          enum: ExampleEnum
          values:
            - first
            - second
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      );

      var definitions = analyzer.validateAll();
      definition = definitions.first as EnumDefinition;
    });

    test('then isEnhanced returns false.', () {
      expect(definition.isEnhanced, isFalse);
    });

    test('then properties is empty.', () {
      expect(definition.properties, isEmpty);
    });
  });

  group('Given an enum value missing a required property when parsing', () {
    late CodeGenerationCollector collector;

    setUp(() {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          enum: ExampleEnum
          properties:
            id: int
            name: String
          values:
            - first:
                id: 1
          ''',
        ).build(),
      ];

      collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();
    });

    test('then an error is collected.', () {
      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error for missing required property.',
      );
    });

    test(
      'then the error message identifies the missing property and value.',
      () {
        var error = collector.errors.first;
        expect(
          error.message,
          'Required property "name" is missing for enum value "first".',
        );
      },
    );
  });

  group('Given an enum with an unsupported property type when parsing', () {
    late CodeGenerationCollector collector;

    setUp(() {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          enum: ExampleEnum
          properties:
            data: List<String>
          values:
            - first:
                data: []
          ''',
        ).build(),
      ];

      collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();
    });

    test('then an error is collected.', () {
      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error for unsupported type.',
      );
    });

    test('then the error message describes the unsupported type.', () {
      var error = collector.errors.first;
      expect(
        error.message,
        'The property type "List<String>" is not supported. '
        'Supported types are: int, double, bool, String.',
      );
    });
  });

  group(
    'Given an enum value with a property that is not defined when parsing',
    () {
      late CodeGenerationCollector collector;

      setUp(() {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          enum: ExampleEnum
          properties:
            id: int
          values:
            - first:
                id: 1
                unknownProperty: 'test'
          ''',
          ).build(),
        ];

        collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test('then an error is collected.', () {
        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error for undefined property.',
        );
      });

      test('then the error message identifies the undefined property.', () {
        var error = collector.errors.first;
        expect(
          error.message,
          'Property "unknownProperty" is not defined for enum "ExampleEnum".',
        );
      });
    },
  );

  group(
    'Given an enum with a reserved keyword as property name when parsing',
    () {
      late CodeGenerationCollector collector;

      setUp(() {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          enum: ExampleEnum
          properties:
            class: int
          values:
            - first:
                class: 1
          ''',
          ).build(),
        ];

        collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test('then an error is collected.', () {
        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error for reserved keyword.',
        );
      });

      test('then the error message identifies the reserved keyword.', () {
        var error = collector.errors.first;
        expect(
          error.message,
          'The enum property name "class" is reserved and cannot be used.',
        );
      });
    },
  );
}
