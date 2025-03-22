import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a valid enum definition when validating', () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        values:
          - first
          - second
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector));

    var definitions = analyzer.validateAll();

    var definition = definitions.first as EnumDefinition;

    test('then no errors are collected', () {
      expect(collector.errors, isEmpty);
    });

    test('then defaultValue is set to null.', () {
      expect(definition.defaultValue, isNull);
    });
  });

  group(
      'Given a valid enum definition with default value set to valid value when validating',
      () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        default: first
        values:
          - first
          - second
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector));

    var definitions = analyzer.validateAll();
    var definition = definitions.first as EnumDefinition;

    test('then no errors are collected', () {
      expect(collector.errors, isEmpty);
    });

    test('then defaultValue is set to valid value.', () {
      expect(definition.defaultValue, definition.values.first);
    });
  });

  group(
      'Given a valid enum definition with default value set to an invalid value when validating',
      () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        values:
          - first
          - second
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector));

    var definitions = analyzer.validateAll();

    var definition = definitions.first as EnumDefinition;

    test('then no errors are collected', () {
      expect(collector.errors, isEmpty);
    });

    test('then defaultValue is set to valid value.', () {
      expect(definition.defaultValue, isNull);
    });
  });
}
