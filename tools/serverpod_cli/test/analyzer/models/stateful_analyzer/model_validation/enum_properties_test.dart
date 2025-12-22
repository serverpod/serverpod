import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given an enum with properties', () {
    test(
      'when properties are valid, then no errors are collected.',
      () {
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

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(
          collector.errors,
          isEmpty,
          reason: 'Expected no errors but got: ${collector.errors}',
        );
      },
    );

    test(
      'when property has default value, then no errors are collected.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
            enum: ExampleEnum
            properties:
              id: int
              description: String, default=''
            values:
              - first:
                  id: 1
              - second:
                  id: 2
                  description: 'Has description'
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(
          collector.errors,
          isEmpty,
          reason: 'Expected no errors but got: ${collector.errors}',
        );
      },
    );

    test(
      'when property type is unsupported, then an error is collected.',
      () {
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

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error for unsupported type.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The property type "List<String>" is not supported. '
          'Supported types are: int, int?, double, double?, bool, bool?, String, String?.',
        );
      },
    );

    test(
      'when property name is a reserved keyword, then an error is collected.',
      () {
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

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error for reserved keyword.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The property name "class" is reserved and cannot be used.',
        );
      },
    );

    test(
      'when enum definition has properties, then isEnhanced returns true.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
            enum: ExampleEnum
            properties:
              id: int
            values:
              - first:
                  id: 1
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

        var definition = definitions.first as EnumDefinition;
        expect(definition.isEnhanced, isTrue);
        expect(definition.properties, hasLength(1));
        expect(definition.properties.first.name, 'id');
        expect(definition.properties.first.type, 'int');
      },
    );

    test(
      'when enum value has property values, they are parsed correctly.',
      () {
        final modelSources = [
          ModelSourceBuilder().withYaml(
            '''
            enum: ExampleEnum
            properties:
              id: int
              name: String
            values:
              - first:
                  id: 1
                  name: 'First Value'
            ''',
          ).build(),
        ];

        final collector = CodeGenerationCollector();
        final analyzer = StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        );

        final definitions = analyzer.validateAll();

        final definition = definitions.first as EnumDefinition;
        final firstValue = definition.values.first;
        expect(firstValue.name, 'first');
        expect(firstValue.propertyValues['id'], 1);
        expect(firstValue.propertyValues['name'], "'First Value'");
      },
    );

    test(
      'when enum value is missing a required property, then an error is collected.',
      () {
        final modelSources = [
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

        final collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error for missing required property.',
        );

        final error = collector.errors.first;
        expect(
          error.message,
          'Required property "name" is missing for enum value "first".',
        );
      },
    );
  });
}
