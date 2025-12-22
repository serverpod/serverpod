import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

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
  });
}
