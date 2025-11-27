import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group(
    'Given a valid enum definition with default value set to valid value when validating',
    () {
      late CodeGenerationCollector collector;
      late EnumDefinition definition;
      setUp(() {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
        enum: ExampleEnum
        default: first
        values:
          - first
          - second
        ''',
          ).build(),
        ];

        collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        );

        var definitions = analyzer.validateAll();
        definition = definitions.first as EnumDefinition;
      });

      test('then no errors are collected', () {
        expect(collector.errors, isEmpty);
      });

      test('then defaultValue is set to valid value.', () {
        expect(definition.defaultValue, isNotNull);
        expect(definition.defaultValue!.name, definition.values.first.name);
      });
    },
  );

  group(
    'Given a valid enum definition with default value set to an invalid String value when validating',
    () {
      late CodeGenerationCollector collector;

      setUp(() {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
        enum: ExampleEnum
        default: Invalid
        values:
          - first
          - second
        ''',
          ).build(),
        ];

        collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        );

        analyzer.validateAll();
      });

      test('then 1 error is collected', () {
        expect(collector.errors, isNotEmpty);
        expect(collector.errors.length, 1);
        expect(
          collector.errors.first.message,
          '"Invalid" is not a valid default value. Allowed values are: first, second.',
        );
      });
    },
  );

  group(
    'Given a valid enum definition with default value set to and invalid int value when validating',
    () {
      late CodeGenerationCollector collector;

      setUp(() {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
        enum: ExampleEnum
        default: 0
        values:
          - first
          - second
        ''',
          ).build(),
        ];

        collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        );

        analyzer.validateAll();
      });

      test('then 1 error is collected', () {
        expect(collector.errors, isNotEmpty);
        expect(collector.errors.length, 1);
        expect(
          collector.errors.first.message,
          'The "default" property must be a String.',
        );
      });
    },
  );
}
